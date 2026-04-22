#ifndef FLUTTER_PLUGIN_RISTO_WIDGETS_PLUGIN_H_
#define FLUTTER_PLUGIN_RISTO_WIDGETS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace risto_widgets {

class RistoWidgetsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  RistoWidgetsPlugin();

  virtual ~RistoWidgetsPlugin();

  // Disallow copy and assign.
  RistoWidgetsPlugin(const RistoWidgetsPlugin&) = delete;
  RistoWidgetsPlugin& operator=(const RistoWidgetsPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace risto_widgets

#endif  // FLUTTER_PLUGIN_RISTO_WIDGETS_PLUGIN_H_
