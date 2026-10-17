{* Exponential Admin UI: the head of the page frame, from page_head.html.twig of the Netgen Admin UI bundle.
   Favicons, the generator and the base path. *}
    <meta charset="utf-8" />
    <meta name="generator" content="{ezini( 'AdminUISettings', 'Title', 'exp_adminui.ini' )|wash}" />
    {* the Exponential mark (images/exponential/); the reference's favicon set, manifest and tile config carried its
       own brand and are not linked *}
    <link rel="apple-touch-icon" sizes="180x180" href={'exponential/apple-touch-icon.png'|ezimage} />
    <link rel="icon" type="image/png" href={'exponential/favicon-32.png'|ezimage} sizes="32x32" />
    <link rel="icon" type="image/png" href={'exponential/favicon-16.png'|ezimage} sizes="16x16" />
    <link rel="shortcut icon" href={'exponential/favicon.ico'|ezimage} />
    <meta name="theme-color" content="#ffffff" />
    <meta name="ngadminui-base-path" content={'/'|ezurl} />
{* The old admin's left and right menu sizes (admin_left_menu_size, admin_right_menu_show) were set here in a <style>
   block for div#leftmenu, div#rightmenu and div#maincolumn. The Admin UI frame has none of those columns (its side
   bar is the aside, sized by style.css), so the block is gone: no CSS in the templates. *}
