{* Exponential Admin UI: the login page frame, from pagelayout_login.html.twig of the Netgen Admin UI bundle.
   As in the reference only the Admin UI stylesheets and scripts are loaded, not the admin's. *}
<!DOCTYPE html>
<html lang="{$site.http_equiv.Content-language|wash}"{if eq( first_set( $site.text_direction, 'ltr' ), 'rtl' )} dir="rtl"{/if}>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>{ezini( 'AdminUISettings', 'Title', 'exp_adminui.ini' )|wash}</title>
    <meta name="generator" content="{ezini( 'AdminUISettings', 'Title', 'exp_adminui.ini' )|wash}" />
    <link rel="shortcut icon" href={'exponential/favicon.ico'|ezimage} />
    <link rel="stylesheet" type="text/css" href={'stylesheets/font-awesome.css'|ezdesign} />
    <link rel="stylesheet" type="text/css" href={'stylesheets/icomoon.css'|ezdesign} />
    {* style.css right to left (style-rtl.css, built from it) for a right-to-left interface language *}{if eq( first_set( $site.text_direction, 'ltr' ), 'rtl' )}<link rel="stylesheet" type="text/css" href={'stylesheets/style-rtl.css'|ezdesign} />{else}<link rel="stylesheet" type="text/css" href={'stylesheets/style.css'|ezdesign} />{/if}
    <link rel="stylesheet" type="text/css" href={'stylesheets/adminui-rem.css'|ezdesign} />
    <link rel="stylesheet" type="text/css" href={'stylesheets/adminui.css'|ezdesign} />
    {if eq( first_set( $site.text_direction, 'ltr' ), 'rtl' )}<link rel="stylesheet" type="text/css" href={'stylesheets/adminui-rtl.css'|ezdesign} />{/if}
</head>
<body class="loginpage">
    {$module_result.content}

    <div class="login-container">
        {include uri='design:adminui/page_footer.tpl'}
    </div>
<!--DEBUG_REPORT-->
</body>
</html>
