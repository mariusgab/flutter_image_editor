//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <image_editor_pro/image_editor_pro_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) image_editor_pro_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ImageEditorProPlugin");
  image_editor_pro_plugin_register_with_registrar(image_editor_pro_registrar);
}
