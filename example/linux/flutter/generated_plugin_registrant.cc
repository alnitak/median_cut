//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <median_cut/median_cut_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) median_cut_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "MedianCutPlugin");
  median_cut_plugin_register_with_registrar(median_cut_registrar);
}
