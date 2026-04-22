#include "include/risto_widgets/risto_widgets_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "risto_widgets_plugin.h"

void RistoWidgetsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  risto_widgets::RistoWidgetsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
