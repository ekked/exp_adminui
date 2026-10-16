{* Exponential Admin UI: the stylesheets, in the reference's order. First the legacy admin stylesheets as the
   reference's design chain resolves them (core, pagelayout, content, theme/rounded and theme/yui_datatable come from
   this design's copies of the Netgen Admin UI legacy files), the extensions' BackendCSSFileList, ng2admin.css; then
   page_head_style.html.twig's three files: Font Awesome 4.4, IcoMoon and the Admin UI stylesheet, linked as files
   (not packed) like the reference does, so their relative font and image paths stay as they are.
   The administration's shared components and module stylesheets (design.ini AdminComponentCSSFileList, found in
   admin4 through the design chain) come before BackendCSSFileList: the module pages this design shares with admin4
   (the content language pages ...) are drawn with them; no CSS in the templates. *}
{if is_unset( $load_css_file_list )}
  {def $load_css_file_list = true()}
{/if}
{if $load_css_file_list}
    {ezcss_load( array( 'core.css',
                        'debug.css',
                        'pagelayout.css',
                        'content.css',
                        'theme/rounded.css',
                        'theme/yui_datatable.css',
                        'theme/modalwindow.css',
                        ezini( 'StylesheetSettings', 'AdminComponentCSSFileList', 'design.ini' ),
                        ezini( 'StylesheetSettings', 'BackendCSSFileList', 'design.ini' ),
                        'ng2admin.css' ) )}
{else}
    {ezcss_load( array( 'core.css', 'debug.css', 'pagelayout.css', 'content.css', 'theme/rounded.css', ezini( 'StylesheetSettings', 'AdminComponentCSSFileList', 'design.ini' ), 'ng2admin.css' ) )}
{/if}
{include uri='design:page_head_style_inline.tpl'}
<link rel="stylesheet" type="text/css" href={'stylesheets/font-awesome.css'|ezdesign} />
<link rel="stylesheet" type="text/css" href={'stylesheets/icomoon.css'|ezdesign} />
{* style.css right to left (style-rtl.css, built from it) for a right-to-left interface language *}{if eq( first_set( $site.text_direction, 'ltr' ), 'rtl' )}<link rel="stylesheet" type="text/css" href={'stylesheets/style-rtl.css'|ezdesign} />{else}<link rel="stylesheet" type="text/css" href={'stylesheets/style.css'|ezdesign} />{/if}
{* the 16px root that the modules' rem sizes expect, with style.css's own rem rules kept at their size *}
<link rel="stylesheet" type="text/css" href={'stylesheets/adminui-rem.css'|ezdesign} />
{* this design's own additions: the Admin UI look for Exponential's markup (the Exponential UI widgets) *}
<link rel="stylesheet" type="text/css" href={'stylesheets/adminui.css'|ezdesign} />
{* module pages with stylesheets of their own (Exponential Layouts, Exponential UI widgets ...) in the Admin UI frame *}
<link rel="stylesheet" type="text/css" href={'stylesheets/adminui-modules.css'|ezdesign} />
<link rel="stylesheet" type="text/css" href={'stylesheets/adminui-dashboard.css'|ezdesign} />
{* right to left (the interface language's direction): the frame mirrored, only then, so a left-to-right page is unchanged *}
{if eq( first_set( $site.text_direction, 'ltr' ), 'rtl' )}<link rel="stylesheet" type="text/css" href={'stylesheets/adminui-rtl.css'|ezdesign} />{/if}
