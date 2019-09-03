//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <connectivity/ConnectivityPlugin.h>
#import <flutter_downloader/FlutterDownloaderPlugin.h>
#import <flutter_image_compress/FlutterImageCompressPlugin.h>
#import <flutter_picker/FlutterPickerPlugin.h>
#import <image_picker/ImagePickerPlugin.h>
#import <package_info/PackageInfoPlugin.h>
#import <path_provider/PathProviderPlugin.h>
#import <qr_code_scanner/FlutterQrPlugin.h>
#import <shared_preferences/SharedPreferencesPlugin.h>
#import <url_launcher/UrlLauncherPlugin.h>
#import <webview_flutter/WebViewFlutterPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTConnectivityPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTConnectivityPlugin"]];
  [FlutterDownloaderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterDownloaderPlugin"]];
  [FlutterImageCompressPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterImageCompressPlugin"]];
  [FlutterPickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterPickerPlugin"]];
  [FLTImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerPlugin"]];
  [FLTPackageInfoPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPackageInfoPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [FlutterQrPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterQrPlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
  [FLTUrlLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTUrlLauncherPlugin"]];
  [FLTWebViewFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTWebViewFlutterPlugin"]];
}

@end
