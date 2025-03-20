import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qdrobe_app/utils/no_internet_widget.dart';

class PermissionService {
  static Future<bool> requestPermission(Permission permission) async {
    try {
      final status = await permission.status;

      if (status.isGranted) return true;

      if (status.isDenied || status.isPermanentlyDenied) {
        final result = await permission.request();

        if (result.isPermanentlyDenied) {
          await openAppSettings();
          return false;
        }

        return result.isGranted;
      }

      return false;
    } catch (e) {
      print('Permission request error for ${permission.toString()}: $e');
      return false;
    }
  }
}

class Home extends GetView<HomeController> {
  const Home({super.key});

  Future<bool> _showExitDialog() async {
    return await Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.exit_to_app_rounded,
                      size: 40,
                      color: Colors.red.shade300,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Exit App',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Are you sure you want to exit?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.back(result: false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            foregroundColor: Colors.grey.shade800,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Get.back(result: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            'Exit',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
          transitionCurve: Curves.easeInOutBack,
          transitionDuration: const Duration(milliseconds: 400),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller =
        Get.put<HomeController>(HomeController(), permanent: true);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) {
          return;
        }

        final currentUrl = await controller.getCurrentUrl();

        if (currentUrl != null &&
            (currentUrl == "https://qdrobe.in" ||
                currentUrl == "https://qdrobe.in/")) {
          final shouldExit = await _showExitDialog();
          if (shouldExit) {
            await SystemNavigator.pop();
          }
        } else {
          final canGoBack =
              await controller._inAppWebViewController?.canGoBack() ?? false;
          if (canGoBack) {
            await controller.goBack();
          } else {
            await controller.loadUrl("https://qdrobe.in");
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Obx(
            () => Stack(
              children: [
                if (controller.hasInternet.value)
                  InAppWebView(
                    key: const Key('inAppWebView'),
                    initialSettings: InAppWebViewSettings(
                      geolocationEnabled: true,
                      javaScriptEnabled: true,
                      useShouldOverrideUrlLoading: true,
                      mediaPlaybackRequiresUserGesture: false,
                      cacheEnabled: true,
                      clearCache: false,
                      useHybridComposition: true,
                      domStorageEnabled: true,
                      databaseEnabled: true,
                      allowsInlineMediaPlayback: true,
                      supportZoom: false,
                    ),
                    onWebViewCreated:
                        (InAppWebViewController inAppWebViewController) async {
                      controller.setWebViewController(inAppWebViewController);
                      await controller.initializePermissions();
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;
                      if (uri.toString().startsWith("https://qdrobe.in")) {
                        return NavigationActionPolicy.ALLOW;
                      }
                      return NavigationActionPolicy.CANCEL;
                    },
                    onPermissionRequest:
                        (InAppWebViewController webViewController,
                            PermissionRequest permissionRequest) async {
                      if (permissionRequest.resources
                          .contains(PermissionResourceType.MICROPHONE)) {
                        final microphoneGranted =
                            await PermissionService.requestPermission(
                                Permission.microphone);
                        return PermissionResponse(
                          resources: permissionRequest.resources,
                          action: microphoneGranted
                              ? PermissionResponseAction.GRANT
                              : PermissionResponseAction.DENY,
                        );
                      }
                      return null;
                    },
                    onGeolocationPermissionsShowPrompt:
                        (InAppWebViewController webViewController,
                            String origin) async {
                      final locationGranted =
                          await PermissionService.requestPermission(
                              Permission.location);
                      return GeolocationPermissionShowPromptResponse(
                        origin: origin,
                        allow: locationGranted,
                        retain: true,
                      );
                    },
                    initialUrlRequest: URLRequest(
                      url: WebUri.uri(
                        Uri.parse("https://qdrobe.in"),
                      ),
                    ),
                  ),
                if (!controller.hasInternet.value)
                  NoInternetWidget(
                    onRetry: () => controller.retryConnection(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeController extends GetxController {
  RxBool hasInternet = true.obs;
  RxBool isPermissionRequestInProgress = false.obs;
  InAppWebViewController? _inAppWebViewController;

  void setWebViewController(InAppWebViewController controller) {
    _inAppWebViewController = controller;
  }

  Future<void> initializePermissions() async {
    if (isPermissionRequestInProgress.value) return;

    try {
      isPermissionRequestInProgress.value = true;

      // Request location permission
      await PermissionService.requestPermission(Permission.location);

      // Add other necessary permissions here
      await PermissionService.requestPermission(Permission.camera);
    } catch (e) {
      print('Permission initialization error: $e');
    } finally {
      isPermissionRequestInProgress.value = false;
    }
  }

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> checkConnectivity() async {
    hasInternet.value = await checkInternetConnection();
  }

  void retryConnection() async {
    await checkConnectivity();
    if (hasInternet.value) {
      await reload();
    }
  }

  Future<String?> getCurrentUrl() async {
    if (_inAppWebViewController != null) {
      final url = await _inAppWebViewController!.getUrl();
      if (url != null) {
        String urlString = url.toString();
        if (urlString.endsWith("/")) {
          urlString = urlString.substring(0, urlString.length - 1);
        }
        return urlString;
      }
    }
    return null;
  }

  Future<void> goBack() async {
    if (_inAppWebViewController != null) {
      final canGoBack = await _inAppWebViewController!.canGoBack();
      if (canGoBack) {
        await _inAppWebViewController!.goBack();
      } else {
        await loadUrl("https://qdrobe.in");
      }
    }
  }

  Future<void> loadUrl(String url) async {
    if (_inAppWebViewController != null) {
      await _inAppWebViewController!.loadUrl(
        urlRequest: URLRequest(
          url: WebUri.uri(Uri.parse(url)),
        ),
      );
    }
  }

  Future<void> clearCache() async {
    if (_inAppWebViewController != null) {
      await InAppWebViewController.clearAllCache(includeDiskFiles: true);
      await _inAppWebViewController!.clearHistory();
    }
  }

  Future<void> reload() async {
    if (_inAppWebViewController != null) {
      await _inAppWebViewController!.reload();
    }
  }

  @override
  void onInit() {
    super.onInit();
    checkConnectivity();
  }

  @override
  void dispose() {
    _inAppWebViewController?.dispose();
    super.dispose();
  }
}
