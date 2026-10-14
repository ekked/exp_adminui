<?php /* #?ini charset="utf-8"?

# Exponential Admin UI: settings the extension brings to the adminui siteaccess (access extension placement, see
# doc/settings.md). The siteaccess itself (settings/siteaccess/adminui/) holds the design chain and the
# ActiveAccessExtensions[] line that switches this extension on.

[RegionalSettings]
TranslationExtensions[]=exp_adminui

# the exp_adminui_asset() template operator: the page head's stylesheet and script links carry the file's
# modification time, so a browser fetches a changed file at once (autoloads/eztemplateautoload.php)
[TemplateSettings]
ExtensionAutoloadPath[]=exp_adminui
*/ ?>
