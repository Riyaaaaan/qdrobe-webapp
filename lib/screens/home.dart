import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

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
          child: Stack(
            children: [
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
                onProgressChanged:
                    (InAppWebViewController inAppWebViewController,
                        int progress) {
                  controller.setProgress(progress);
                },
                onWebViewCreated:
                    (InAppWebViewController inAppWebViewController) async {
                  controller.setWebViewController(inAppWebViewController);
                  await controller.checkAndRequestLocationPermission();
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;
                  if (uri.toString().startsWith("https://qdrobe.in")) {
                    return NavigationActionPolicy.ALLOW;
                  }
                  return NavigationActionPolicy.CANCEL;
                },
                onLoadStart: (InAppWebViewController controller, WebUri? url) {
                  // Handle page load start
                },
                onLoadStop: (InAppWebViewController controller, WebUri? url) {
                  // Handle page load complete
                },
                onPermissionRequest: (InAppWebViewController controller,
                    PermissionRequest permissionRequest) async {
                  if (permissionRequest.resources
                      .contains(PermissionResourceType.MICROPHONE)) {
                    final status = await Permission.microphone.request();
                    return PermissionResponse(
                      resources: permissionRequest.resources,
                      action: status.isGranted
                          ? PermissionResponseAction.GRANT
                          : PermissionResponseAction.DENY,
                    );
                  }
                  return null;
                },
                onGeolocationPermissionsShowPrompt:
                    (InAppWebViewController controller, String origin) async {
                  final status = await Permission.location.request();
                  return GeolocationPermissionShowPromptResponse(
                    origin: origin,
                    allow: status.isGranted,
                    retain: true,
                  );
                },
                initialUrlRequest:
                    URLRequest(url: WebUri.uri(Uri.parse("https://qdrobe.in"))),
              ),
              Obx(
                () => controller.progress.value < 1.0
                    ? LinearProgressIndicator(
                        value: controller.progress.value,
                        backgroundColor: Colors.grey[200],
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeController extends GetxController {
  RxDouble progress = 0.0.obs;
  InAppWebViewController? _inAppWebViewController;

  void setProgress(int newProgress) {
    progress.value = newProgress / 100;
  }

  void setWebViewController(InAppWebViewController controller) {
    _inAppWebViewController = controller;
  }

  Future<bool> checkAndRequestLocationPermission() async {
    final status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.location.request();
      return result.isGranted;
    }

    return false;
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
    checkAndRequestLocationPermission();
  }

  @override
  void dispose() {
    _inAppWebViewController?.dispose();
    super.dispose();
  }
}
