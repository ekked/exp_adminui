{* Exponential Admin UI: the context Help control at the end of the header. It opens the help page of the module and
   view on screen (fetch( 'exphelp', 'context' ): the help system's context map for this design, falling back to the
   module's page and then the help dashboard; its url carries the heading anchor). Shown only when the kernel has
   the help module and the user may read the help (the fetch gives false otherwise), so an older kernel or a user
   without exphelp/read sees nothing. A plain link, no inline script or style (stylesheets/adminui-pages.css). *}
{if ezini( 'ModuleSettings', 'ModuleList', 'module.ini' )|contains( 'exphelp' )}
{def $adminui_help_mp    = module_params()
     $adminui_help_ctx   = fetch( 'exphelp', 'context', hash( 'module', first_set( $adminui_help_mp.module_name, '' ),
                                                              'view', first_set( $adminui_help_mp.function_name, '' ),
                                                              'design', ezini( 'DesignSettings', 'SiteDesign', 'site.ini' ) ) )
     $adminui_help_label = ''}
{if $adminui_help_ctx}
{if $adminui_help_ctx.title}
    {set $adminui_help_label = 'Help: %title'|i18n( 'kernel/exphelp',, hash( '%title', $adminui_help_ctx.title ) )}
{else}
    {set $adminui_help_label = 'Help for this page'|i18n( 'kernel/exphelp' )}
{/if}
<div class="aui-help">
    <a class="aui-help-btn" href={$adminui_help_ctx.url|ezurl} title="{$adminui_help_label|wash}" aria-label="{$adminui_help_label|wash}">
        <i class="fa fa-question-circle" aria-hidden="true"></i>
        <span class="aui-help-label">{'Help'|i18n( 'kernel/exphelp' )}</span>
    </a>
</div>
{/if}
{undef $adminui_help_mp $adminui_help_ctx $adminui_help_label}
{/if}
