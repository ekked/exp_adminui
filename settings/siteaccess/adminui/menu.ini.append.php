<?php /* #?ini charset="utf-8"?

# Exponential Admin UI: the side bar draws the admin top menu. Layouts and Tags have their own side bar entries
# (exp_adminui.ini [MenuPlugins]), so their tabs are left out here, as in the reference.

[TopAdminMenu]
HiddenTabs[]
HiddenTabs[]=explayouts_ui_dashboard
HiddenTabs[]=eztags

# The names the reference shows in the side bar (Exponential's menu.ini shortens them to Media, Users, Store)
# Icon - (optional) the name of an icon admin4 draws before the tab's name: a name of design.ini
#        [AdminDesignSettings] IconList[] (Bootstrap Icons); a name it does not know draws no icon.
#        The adminui side bar draws its own Font Awesome icons; Icon names the tab's icon wherever an admin4
#        header shows these tabs.
[Topmenu_media]
Icon=images
Name=Media library

[Topmenu_users]
Icon=people
Name=User accounts

[Topmenu_shop]
Icon=box-seam
Name=Webshop

# The newsletter (cjw_newsletter) left menu, parts/newsletter/menu.tpl: the link lists below its tree, drawn by
# parts/ini_menu.tpl like the other left menus. Settings only with newsletter/admin, as in cjw_newsletter.
[Leftmenu_newsletter]
Name=administer
Links[]
Links[dashboard]=newsletter/index
Links[users]=newsletter/user_list
Links[blacklists]=newsletter/blacklist_item_list
Links[bounces]=newsletter/mailbox_item_list

[Leftmenu_newsletter_settings]
Name=settings
PolicyList[]=newsletter/admin
Links[]
Links[mail_accounts]=newsletter/mailbox_list
Links[imports]=newsletter/import_list
Links[subscription_form]=newsletter/subscribe
Links[ini_settings]=newsletter/settings

*/ ?>
