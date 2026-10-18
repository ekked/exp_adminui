{* Exponential Admin UI: the footer, from page_footer.html.twig *}
<footer id="footer">
    {* the Help center (the kernel's help system) for users with exphelp/read while the help is switched on *}
    {if ezini_hasvariable( 'HelpSettings', 'Enabled', 'exphelp.ini' )}{if and( ezini( 'HelpSettings', 'Enabled', 'exphelp.ini' )|eq( 'true' ), fetch( 'user', 'has_access_to', hash( 'module', 'exphelp', 'function', 'read' ) ) )}
    <p class="aui-footer-help"><a href={'/exphelp/dashboard'|ezurl}><i class="fa fa-question-circle" aria-hidden="true"></i> {'Help center'|i18n( 'design/admin/page_copyright' )|wash}</a></p>
    {/if}{/if}
    <p><a href="https://se7enx.com" target="_blank">7x</a> {'Exponential Admin UI. Based on Exponential Platform Administration'|i18n( 'design/adminui/pagelayout' )} &ndash; Copyright &copy;&nbsp;1998-{currentdate()|datetime( 'custom', '%Y' )} 7x and others.</p>
</footer>
