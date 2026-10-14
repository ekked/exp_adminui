# Settings

## exp_adminui.ini

Defaults in `settings/exp_adminui.ini`. Override per siteaccess in
`settings/siteaccess/adminui/exp_adminui.ini.append.php` (in the extension or the installation).

### [AdminUISettings]

- `Title`: the name in the window title, the generator meta tag and the logo's tooltip. Default `Exponential Admin UI`.
- `LogoType`: which logo the stylesheets draw. `exponential` (default) is the Exponential mark in the header and
  the full logo on the login page (`images/exponential/`, white ink for the dark backgrounds). `default` and
  `ngadminui` are the reference's own logos, still drawn by its unchanged `style.css`.

### [MenuPlugins]

- `Enabled[]`: the blocks of the side bar, in the order the reference has them:
  - `legacy`: the admin top menu, one entry per `menu.ini [TopAdminMenu] Tabs[]`, with the reference's icons per
    URL or navigation part. Tabs another block draws are left out (`eztags` when `tags` is on,
    `explayouts_ui_dashboard` when `layouts` is on).
  - `layouts`, `tags`, `information_collection`: one entry each, shown when the user has access
    (`explayouts_ui/read`, `tags/read`, `infocollector/read`).
  - `cache`: the clear cache dropdown (`setup/clear_cache.tpl`), with `setup/managecache` access.
  - `bookmarks`: the bookmarks dropdown (`toolbar/full/admin_bookmarks.tpl`), with `content/bookmark` access.

### [MenuPlugin_layouts], [MenuPlugin_tags], [MenuPlugin_information_collection]

- `URL`: where the entry points. Defaults `explayouts_ui/dashboard`, `tags/dashboard`, `infocollector/overview`.

### [ViewSettings] (from the reference's ngadminui.ini)

- `DefaultTab`: the tab a content view opens on: `view`, `subitems`, `translations`, `locations` or `relations`.
- `DefaultTabs[<class identifier>]`: per class. Containers (folder, user_group, ng_* containers) open on `subitems`.

### [SnippetEditorSettings], [SnippetEditorClass_<class>]

- `ClassList[]`: classes whose text fields are edited with the Ace code editor.
- `FieldList[]`: per class, the `eztext` fields that get it.
- `SnippetEditorConfig_<field>[mode|theme|highlight_active_line|show_print_margin]`: editor options.

## Other INI files (extension/exp_adminui/settings/siteaccess/adminui/)

| File | What |
|---|---|
| `design.ini.append.php` | `DesignExtensions[]=exp_adminui` |
| `site.ini.append.php` | `TranslationExtensions[]=exp_adminui` |
| `icon.ini.append.php` | The reference's icon set: repository `design/adminui/images/icons`, theme `kp` (with `StandardTheme=kp`), class, class group, MIME and flag icons |
| `menu.ini.append.php` | `HiddenTabs[]` for the tabs the side bar draws itself; the reference's tab names (Media library, User accounts, Webshop). The Setup left menu is Exponential's (a superset of the reference's, in the same order); `[Leftmenu_newsletter]` and `[Leftmenu_newsletter_settings]`, the Administer and Settings lists of the newsletter left menu (`parts/newsletter/menu.tpl`, Settings only with `newsletter/admin`) |
| `ezoe.ini.append.php` | `SkinVariant=silver`, as in the reference |
| `zone.ini.append.php` | ezflow zone thumbnails, as in the reference |

## The siteaccess (settings/siteaccess/adminui/ of the installation)

A copy of the admin siteaccess's settings, with `SiteDesign=adminui`, the chain
`admin4l, admin4, admin3, admin2, admin`, and `ActiveAccessExtensions[]=exp_adminui`. Its `icon.ini` and `ezoe.ini`
are empty, because a copy of the admin's would override the extension's.

## Reading order, and why some values cannot be set here

Exponential reads, from first to last (last wins): defaults, access-extension settings (this extension, including
its `settings/override/`), the siteaccess, every globally active extension, `settings/override`. A value a global
extension also sets beats this extension and the siteaccess. Example: cjw_newsletter maps its classes to crystal
icon paths (`filesystems/folder.png` ...). The adminui design therefore carries copies of fitting kp icons under
those paths (`images/icons/kp/<size>/filesystems/...`, listed in ASSETS.md) instead of remapping the classes.

## User preferences

| Preference | Set by | Values |
|---|---|---|
| `exp_adminui_details_width` | the handle on the left edge of the content view's details panel (`preview.tpl`, `javascript/exp_adminui_details_resizer.js`): drag it with the mouse or a finger, or focus it and use the arrow keys (Shift for bigger steps, Home and End for the limits, a double click for the default) | the width in pixels, 160 to 640 (200 to 640 where there is room); empty or out of range means the default 320 |

The width is saved once at the end of a drag, or 0.6 s after the last key press, through `user/preferences`
(`set_and_exit`, as `$.ez.setPreference` of ezjscore does), so it follows the user to every browser.
`pagelayout.tpl` reads it back and sets `--exp-adminui-details-width` on `<html>`, so the page opens at that width.
The content next to the panel keeps at least 360 px: on a narrower window a width saved on a wider one is held in
that room (the saved value is not changed), and where 200 px do not fit the minimum gives way, down to 160 px.
The panel stays beside the content, with the handle, down to a 720 px wide window, so also at 200 % zoom (a window
of about 960 px): the navigation column and the tree take 50 px below about 800 px, 260 px up to
about 900 px and 340 px above, so the preview is at least about 540 px there. Below 720 px the panel is stacked
under the content and the handle is hidden.
