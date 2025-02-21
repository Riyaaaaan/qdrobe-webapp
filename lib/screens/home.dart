import 'package:flutter/material.dart';
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
                  // Icon at the top
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
                  // Title
                  const Text(
                    'Exit App',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Message
                  const Text(
                    'Are you sure you want to exit?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Cancel Button
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
                      // Exit Button
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
    Get.put<HomeController>(HomeController());

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }

        final canGoBack = await controller.canGoBack();
        if (!canGoBack) {
          final shouldExit = await _showExitDialog();
          if (shouldExit) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: InAppWebView(
            initialSettings: InAppWebViewSettings(
              useShouldOverrideUrlLoading: true,
              mediaPlaybackRequiresUserGesture: false,
              cacheEnabled: true,
              clearCache: false,
              useHybridComposition: true,
              domStorageEnabled: true,
              databaseEnabled: true,
              allowsInlineMediaPlayback: true,
              supportZoom: false,
              javaScriptEnabled: true,
            ),
            onProgressChanged:
                (InAppWebViewController inAppWebViewController, int progress) {
              controller.setProgress(progress);
            },
            onWebViewCreated: (InAppWebViewController inAppWebViewController) {
              controller.setWebViewController(inAppWebViewController);
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
                final PermissionStatus permissionStatus =
                    await Permission.microphone.request();
                if (permissionStatus.isGranted) {
                  return PermissionResponse(
                    resources: permissionRequest.resources,
                    action: PermissionResponseAction.GRANT,
                  );
                } else if (permissionStatus.isDenied) {
                  return PermissionResponse(
                    resources: permissionRequest.resources,
                    action: PermissionResponseAction.DENY,
                  );
                }
              }
              return null;
            },
            initialUrlRequest:
                URLRequest(url: WebUri.uri(Uri.parse("https://qdrobe.in"))),
          ),
        ),
      ),
    );
  }
}

class HomeController extends GetxController {
  RxDouble progress = 0.0.obs;
  setProgress(int newProgress) {
    progress.value = newProgress / 100;
  }

  InAppWebViewController? _inAppWebViewController;

  setWebViewController(InAppWebViewController controller) {
    _inAppWebViewController = controller;
  }

  Future<bool> canGoBack() async {
    if (_inAppWebViewController != null) {
      final canGoBack = await _inAppWebViewController!.canGoBack();
      if (canGoBack) {
        await _inAppWebViewController!.goBack();
        return true;
      }
    }
    return false;
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
  void dispose() {
    super.dispose();
    _inAppWebViewController?.dispose();
  }
}
