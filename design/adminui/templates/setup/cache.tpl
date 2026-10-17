{* Feedbacks. *}
{foreach array( 'opcache', 'apcu', 'querycache', 'httpcache' ) as $phpCache}
{if $cache_cleared[$phpCache]}
    <div class="alert {if $cache_cleared[$phpCache][0]}alert-success{else}alert-warning{/if}" role="alert">
        <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {$cache_cleared[$phpCache][1]|wash}</h2>
    </div>
{/if}
{/foreach}

{if $cache_cleared.content}
    <div class="alert alert-success" role="alert">
        <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'Content view cache was cleared'|i18n( 'design/admin/setup/cache' )}</h2>
    </div>
{/if}

{if $cache_cleared.all}
    <div class="alert alert-success" role="alert">
        <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'All caches were cleared'|i18n( 'design/admin/setup/cache' )}</h2>
    </div>
{/if}

{if $cache_cleared.ini}
    <div class="alert alert-success" role="alert">
        <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'Ini file cache was cleared'|i18n( 'design/admin/setup/cache' )}</h2>
    </div>
{/if}

{if $cache_cleared.template}
    <div class="alert alert-success" role="alert">
        <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'Template cache was cleared'|i18n( 'design/admin/setup/cache' )}</h2>
    </div>
{/if}

{* cache_cleared.static is the number of pages written, not a flag: a run that
   wrote nothing must not report success. *}
{if $cache_cleared.static}
    <div class="alert alert-success" role="alert">
        <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'Static content cache was regenerated, %count pages written to %dir'|i18n( 'design/admin/setup/cache',, hash( '%count', $cache_cleared.static, '%dir', $static_cache_storage_dir ) )}</h2>
    </div>
{/if}

{section show=$cache_cleared.list}
    <div class="alert alert-success" role="alert">
        <h2><span class="time">[{currentdate()|l10n( shortdatetime )}]</span> {'The following caches were cleared'|i18n( 'design/admin/setup/cache' )}:</h2>
        <ul>
        {section var=Caches loop=$cache_cleared.list}
            <li>{'%name was cleared'|i18n( 'design/admin/setup/cache',, hash( '%name', $Caches.item.name ) )}</li>
        {/section}
        </ul>
    </div>
{/section}



<form name="clearcacheform" method="post" action={"/setup/cache/"|ezurl}>

    {* Clear caches window. *}

    <div class="panel">

        {* DESIGN: Header START *}

        <h2>{'Clear caches'|i18n( 'design/admin/setup/cache' )}</h2>

        {* DESIGN: Mainline *}<div class="header-mainline"></div>

        {* DESIGN: Header END *}

        {* DESIGN: Content START *}
        <table class="list cache" cellspacing="0">

            <tr>
                <th width="61%">{'Categories'|i18n( 'design/admin/setup/cache' )}</th>
                <th width="39%"></th>
            </tr>

            {* Template cache. *}
            <tr class="bglight">
                <td>{'Template overrides and compiled templates'|i18n( 'design/admin/setup/cache' )}:</td>
                <td><input class="button" type="submit" name="ClearTemplateCacheButton" value="{'Clear template caches'|i18n( 'design/admin/setup/cache' )}" title="{'This operation will clear all the template override caches and the compiled templates. It may lead to slower site performance until the caches are recreated.'|i18n( 'design/admin/setup/cache' )}" /></td>
            </tr>

            {* Content cache. *}
            <tr class="bgdark">
                <td>{'Content views and template blocks'|i18n( 'design/admin/setup/cache' )}:</td>
                <td><input class="button" type="submit" name="ClearContentCacheButton" value="{'Clear content caches'|i18n( 'design/admin/setup/cache' )}" title="{'This operation will clear all caches that are related to either template views or cache blocks inside the pagelayout template. Use it if you have modified templates or if you have made changes inside a cache block.'|i18n( 'design/admin/setup/cache' )}"/></td>
            </tr>

            {* Configuration cache. *}
            <tr class="bglight">
                <td>{'Configuration (ini) caches'|i18n( 'design/admin/setup/cache' )}:</td>
                <td><input class="button" type="submit" name="ClearINICacheButton" value="{'Clear Ini caches'|i18n( 'design/admin/setup/cache' )}" title="{'This operation will clear all the configuration caches. Use it to force the system to re-read the configuration files if you have changed settings.'|i18n( 'design/admin/setup/cache' )}" /></td>
            </tr>

            {* SQL query cache. *}
            <tr class="bgdark">
                <td>{'Database query results (SQL query cache)'|i18n( 'design/admin/setup/cache' )}: <span class="small">({if $query_cache_enabled}{$query_cache_mode|wash}{else}{'off'|i18n( 'design/admin/setup/cache' )}{/if})</span></td>
                <td><input class="button" type="submit" name="ClearQueryCacheButton" value="{'Clear query cache'|i18n( 'design/admin/setup/cache' )}" title="{'Makes every stored SQL result stale at once, on every server sharing this installation. Writes already invalidate the tables they touch; use this after changing the database outside Exponential, for example with a SQL client or a restore.'|i18n( 'design/admin/setup/cache' )}" /></td>
            </tr>

            {* HTTP cache. *}
            <tr class="bglight">
                <td>{'Whole pages (HTTP cache)'|i18n( 'design/admin/setup/cache' )}: <span class="small">({if $http_cache_enabled}{'enabled'|i18n( 'design/admin/setup/cache' )}{else}{'off'|i18n( 'design/admin/setup/cache' )}{/if})</span></td>
                <td><input class="button" type="submit" name="ClearHttpCacheButton" value="{'Clear HTTP cache'|i18n( 'design/admin/setup/cache' )}"{if $http_cache_enabled|not} disabled="disabled"{/if} title="{'Drops every cached page for every permission context, including the copies the Velocity response cache holds. Publishing already purges the pages it affects.'|i18n( 'design/admin/setup/cache' )}" /></td>
            </tr>

            {* All caches. *}
            <tr class="bgdark">
                <td>{'Everything'|i18n( 'design/admin/setup/cache' )}:</td>
                <td><input class="button" type="submit" name="ClearAllCacheButton" value="{'Clear all caches'|i18n( 'design/admin/setup/cache' )}" title="{'This operation will clear all the caches and may lead to slow site response times until the caches are recreated.'|i18n( 'design/admin/setup/cache' )}" /></td>
            </tr>

        </table>

        {* DESIGN: Content END *}

    </div>

    <div class="panel">
        {* Cache overview window. *}

        {* DESIGN: Header START *}

        <h2>{'Fine-grained cache control'|i18n( 'design/admin/setup/cache' )}</h2>

        {* DESIGN: Header END *}

        {* DESIGN: Content START *}

        <table class="list" cellspacing="0">
            <tr>
                <th class="tight"><i class="fa fa-check-square-o" data-expui-toggle-checkboxes="CacheList[]" data-expui-form="clearcacheform" title="{'Invert selection.'|i18n( 'design/admin/setup/cache' )}"></i></th>
                <th>{'Name'|i18n( 'design/admin/setup/cache' )}</th>
                <th>{'Path'|i18n( 'design/admin/setup/cache' )}</th>
            </tr>
            {section var=Caches loop=$cache_list sequence=array( bglight, bgdark )}

            {* Checkbox *}
            <tr class="{$Caches.sequence}">
                {if $cache_enabled.list[$Caches.item.id]}
                <td><input type="checkbox" name="CacheList[]" value="{$Caches.item.id}" title="{'Select the %cache_name for clearing.'|i18n( 'design/admin/setup/cache',, hash( '%cache_name', $Caches.item.name ) )|wash}" /></td>
                {else}
                <td><input type="checkbox" name="CacheList[]" value="{$Caches.item.id}" disabled="disabled" title="{'The %cache_name is disabled and thus it cannot be marked for clearing.'|i18n( 'design/admin/setup/cache',, hash( '%cache_name', $Caches.item.name ) )|wash}" /></td>
                {/if}

                {* Name *}
                <td>{$Caches.item.name}&nbsp;</td>

                {* Path *}
                <td>{$Caches.item.path}&nbsp;</td>

            </tr>
            {/section}
        </table>

        {* DESIGN: Content END *}
        <div class="controlbar">
            {* DESIGN: Control bar START *}
            <div class="block">
                <input class="button" type="submit" name="ClearCacheButton" value="{'Clear selected'|i18n( 'design/admin/setup/cache' )}" title="{'Clear the selected caches.'|i18n( 'design/admin/setup/cache' )}" />
            </div>
            {* DESIGN: Control bar END *}

        </div>
    </div>

    <div class="panel">

        {* Regenerate static cache window. *}

        {* DESIGN: Header START *}

        <h2 class="context-title">{'Static content cache'|i18n( 'design/admin/setup/cache' )}</h2>

        {* DESIGN: Header END *}

        {* DESIGN: Content START *}

        {if $static_cache_siteaccess_list|count|eq(0)}
        <div class="alert alert-danger" role="alert">
            <b>{'No site can be cached.'|i18n( 'design/admin/setup/cache' )}</b><br />
            {'Every siteaccess either requires a login or has no SiteSettings/SiteURL, so there is no page to fetch and store.'|i18n( 'design/admin/setup/cache' )}
        </div>
        {else}

        <table class="list cache" cellspacing="0">
            <tr>
                <th width="61%">{'Categories'|i18n( 'design/admin/setup/cache' )}</th>
                <th width="39%"></th>
            </tr>

            <tr class="bglight">
                <td>{'Pages are written to'|i18n( 'design/admin/setup/cache' )}:</td>
                <td><code>{$static_cache_storage_dir|wash}</code></td>
            </tr>

            {* Which site to generate is chosen, not inferred: one installation serves
               several, each with its own host or url prefix, and generating all of them is
               rarely what is wanted. *}
            <tr class="bgdark">
                <td><label for="staticcache-siteaccess">{'Site to generate'|i18n( 'design/admin/setup/cache' )}</label>:</td>
                <td>
                    <select class="form-control input-sm" id="staticcache-siteaccess" name="StaticCacheSiteAccess">
                    {foreach $static_cache_siteaccess_list as $static_cache_target}
                        <option value="{$static_cache_target.name|wash}">{$static_cache_target.name|wash} &mdash; {$static_cache_target.url|wash}</option>
                    {/foreach}
                        <option value="">{'All sites'|i18n( 'design/admin/setup/cache' )}</option>
                    </select>
                </td>
            </tr>

            {* The crawl is bounded, so a large site cannot run away and a first pass can
               be kept short deliberately. *}
            <tr class="bglight">
                <td>{'Limits'|i18n( 'design/admin/setup/cache' )}:</td>
                <td>
                    <label for="staticcache-max-pages">{'Pages'|i18n( 'design/admin/setup/cache' )}</label>
                    <input id="staticcache-max-pages" type="text" size="6" value="2500" />
                    &nbsp;
                    <label for="staticcache-max-depth">{'Link depth'|i18n( 'design/admin/setup/cache' )}</label>
                    <input id="staticcache-max-depth" type="text" size="4" value="12" />
                </td>
            </tr>

            {* Static content cache. *}
            <tr class="bgdark">
                <td width="60%">{'Regenerate static content cache'|i18n( 'design/admin/setup/cache' )}:</td>
                <td width="40%"><input class="button" id="staticcache-start" type="submit" name="RegenerateStaticCacheButton" value="{'Create new'|i18n( 'design/admin/setup/cache' )}" title="{'Fetches every url of the chosen site that the site itself links to and stores the page, so the web server can answer the next visitor from a file instead of starting the CMS. This can take some time on a large site. If you encounter time-out problems, use the &quot;bin/php/makestaticcache.php&quot; shell script.'|i18n( 'design/admin/setup/cache' )}" />
                <input class="button" id="staticcache-stop" type="button" disabled="disabled" value="{'Stop'|i18n( 'design/admin/setup/cache' )}" title="{'Stops listening and leaves the pages written so far in place.'|i18n( 'design/admin/setup/cache' )}" />
                <span id="staticcache-status" class="aui-ms-4"></span></td>
            </tr>

        </table>

{if $static_cache_enabled|not}
<div class="alert alert-warning" role="alert">
    {'Generated pages will not be refreshed when an editor publishes, because site.ini [ContentSettings] StaticCache is not enabled.'|i18n( 'design/admin/setup/cache' )}
</div>
{/if}

{* A fixed height, scrolling region: a full site prints hundreds of lines and
   should not push the rest of the interface off the screen. *}
<pre id="staticcache-console" class="aui-cache-console" hidden data-expui-stream-url="{$static_cache_stream_url|ezurl( 'no' )|wash}" data-expui-text="{json_encode( hash( 'running', 'running…'|i18n( 'design/admin/setup/cache' ), 'finished', 'finished'|i18n( 'design/admin/setup/cache' ), 'stopped', 'stopped'|i18n( 'design/admin/setup/cache' ), 'noStream', 'Could not open the stream. Check that you have the setup/managecache policy.'|i18n( 'design/admin/setup/cache' ), 'closed', 'Stream closed.'|i18n( 'design/admin/setup/cache' ), 'stoppedByOperator', 'Stopped by operator. Pages written so far are kept.'|i18n( 'design/admin/setup/cache' ) ) )|wash}"></pre>

{ezscript( array( 'exp_adminui_setup_cache.js' ) )}

{/if}

        {* DESIGN: Content END *}

    </div>

    {* PHP's own caches. Not part of "Clear all caches": they are not files of
       this installation but memory of the server process answering this page,
       and emptying them costs every other site that process serves as well. *}

    <div class="panel aui-anchor" id="php-caches">

        {* DESIGN: Header START *}

        <h2 class="context-title">{'PHP caches of this server process'|i18n( 'design/admin/setup/cache' )}</h2>

        {* DESIGN: Header END *}

        {* DESIGN: Content START *}

        <p><small>{'The figures and settings are on'|i18n( 'design/admin/setup/cache' )} <a href="{'/setup/info'|ezurl( 'no' )}#php-caches">{'System information'|i18n( 'design/admin/setup/cache' )}</a>.</small></p>

        <table class="list cache" cellspacing="0">

            <tr>
                <th width="61%">{'Categories'|i18n( 'design/admin/setup/cache' )}</th>
                <th width="39%"></th>
            </tr>

            <tr class="bglight">
                <td>{'OPcache (compiled PHP scripts)'|i18n( 'design/admin/setup/cache' )}: <small>{$php_cache_state.opcache.text|wash}</small></td>
                <td><input class="button" type="submit" name="ResetOPcacheButton" value="{'Reset OPcache'|i18n( 'design/admin/setup/cache' )}"{if $php_cache_state.opcache.available|not} disabled="disabled"{/if} title="{'Empties the opcode cache of the server process answering this page. Every PHP file is compiled again on its next include, so the next requests are slower. Use it when an edited PHP file is not picked up.'|i18n( 'design/admin/setup/cache' )}" /></td>
            </tr>
            <tr class="bgdark">
                <td>{'APCu (data in shared memory)'|i18n( 'design/admin/setup/cache' )}: <small>{$php_cache_state.apcu.text|wash}</small></td>
                <td><input class="button" type="submit" name="ClearAPCuButton" value="{'Empty APCu'|i18n( 'design/admin/setup/cache' )}"{if $php_cache_state.apcu.available|not} disabled="disabled"{/if} title="{'Empties APCu for the server process answering this page: every entry any application stored there is gone, including the memory tier of a Qbix response cache.'|i18n( 'design/admin/setup/cache' )}" /></td>
            </tr>

        </table>

        {* DESIGN: Content END *}

    </div>
</form>
