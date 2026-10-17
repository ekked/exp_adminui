{* Exponential Admin UI: the left menu of the newsletter (cjw_newsletter, navigation part eznewsletternavigationpart),
   drawn with the markup of the standard left menus so that the AdminUI stylesheets style it: the newsletter systems
   as a tree in #content-tree-menu (as parts/content/menu.tpl), then Administer and Settings as menu.ini link lists
   through parts/ini_menu.tpl (as parts/setup/menu.tpl; [Leftmenu_newsletter] and [Leftmenu_newsletter_settings] in
   this siteaccess's menu.ini). Settings needs newsletter/admin, as before; every link is also checked against the
   address it opens. The tree is drawn by parts/newsletter/tree_list.tpl, icons from the AdminUI icon theme. *}
{if $module_result.ui_context|ne( 'edit' )}
{def $nl_root_id    = ezini( 'NewsletterSettings', 'RootFolderNodeId', 'cjw_newsletter.ini' )
     $nl_root       = fetch( 'content', 'node', hash( 'node_id', $nl_root_id ) )
     $nl_systems    = fetch( 'content', 'tree', hash( 'parent_node_id', $nl_root_id,
                                                      'class_filter_type', 'include',
                                                      'class_filter_array', array( 'cjw_newsletter_system' ),
                                                      'sort_by', array( 'name', true() ) ) )
     $nl_current_id = first_set( $module_result.node_id, 0 )
     $nl_path_ids   = array()
     $nl_lists      = array()
     $nl_open       = false()
     $nl_uri        = first_set( $module_result.uri, '' )|trim( '/' )}
{* the request address without the siteaccess of a URI siteaccess (adminui/newsletter/... -> newsletter/...) *}
{def $nl_prefix = '/'|ezurl( 'no' )|trim( '/' )}
{if and( $nl_prefix|ne( '' ), $nl_uri|begins_with( concat( $nl_prefix, '/' ) ) )}
    {set $nl_uri = $nl_uri|extract_right( $nl_uri|count_chars|sub( $nl_prefix|count_chars, 1 ) )}
{/if}
{undef $nl_prefix}
{if is_set( $module_result.path )}
    {foreach $module_result.path as $nl_path_item}
        {if is_set( $nl_path_item.node_id )}{set $nl_path_ids = $nl_path_ids|append( $nl_path_item.node_id )}{/if}
    {/foreach}
{/if}
{* a newsletter list's own subscription page opens its system and list *}
{if $nl_uri|begins_with( 'newsletter/subscription_list/' )}
    {def $nl_sub_node = fetch( 'content', 'node', hash( 'node_id', $nl_uri|explode( '/' )[2]|int ) )}
    {if $nl_sub_node}{set $nl_path_ids = $nl_path_ids|merge( $nl_sub_node.path_array )}{/if}
    {undef $nl_sub_node}
{/if}
<div id="content-tree">
    <h4 class="leftmenu-hl">{'Newsletter systems'|i18n( 'cjw_newsletter/menu' )}</h4>
    <div id="contentstructure">
        {if $nl_root}
        <ul id="content-tree-menu">
            <li id="n{$nl_root.node_id}"{if $nl_current_id|eq( $nl_root.node_id )} class="currentnode"{/if}>{$nl_root.class_identifier|class_icon( 'small' )}&nbsp;<a class="image-text" href={concat( 'content/view/full/', $nl_root.node_id )|ezurl}><span class="node-name-normal">{$nl_root.name|wash}</span></a>
            {if $nl_systems|count}
                <div class="loaded"><ul>
                {foreach $nl_systems as $nl_index => $nl_system}
                    {set $nl_lists = fetch( 'content', 'list', hash( 'parent_node_id', $nl_system.node_id,
                                                                     'class_filter_type', 'include',
                                                                     'class_filter_array', array( 'cjw_newsletter_list', 'cjw_newsletter_list_virtual' ) ) )
                         $nl_open  = $nl_path_ids|contains( $nl_system.node_id )}
                    <li id="n{$nl_system.node_id}" class="{if $nl_current_id|eq( $nl_system.node_id )}currentnode{/if}{if $nl_index|eq( $nl_systems|count|dec )} lastli{/if}">
                        {if $nl_lists|count}<a class="{if $nl_open}openclose-close{else}openclose-open{/if}" href="#" title="{'Fold/Unfold'|i18n( 'cjw_newsletter/contentstructuremenu' )}" data-expui-openclose></a>{/if}
                        {'cjw_newsletter_system'|class_icon( 'small' )}&nbsp;<a class="image-text" href={concat( 'content/view/full/', $nl_system.node_id )|ezurl}><span class="node-name-normal">{$nl_system.name|wash}</span></a>
                        {if $nl_lists|count}
                            <div class="{if $nl_open}loaded{else}hidden{/if}"><ul>
                            {foreach $nl_lists as $nl_list_index => $nl_list}
                                {include uri='design:parts/newsletter/tree_list.tpl' list_node=$nl_list last_item=$nl_list_index|eq( $nl_lists|count|dec ) path_ids=$nl_path_ids current_id=$nl_current_id uri_string=$nl_uri}
                            {/foreach}
                            </ul></div>
                        {/if}
                    </li>
                {/foreach}
                </ul></div>
            {/if}
            </li>
        </ul>
        {/if}
    </div>
</div>

{* See parts/ini_menu.tpl and menu.ini for more info, or parts/setup/menu.tpl for full example *}
{include uri='design:parts/ini_menu.tpl' ini_section='Leftmenu_newsletter' uri_string=$nl_uri i18n_hash=hash(
    'administer',   'Administer'|i18n( 'cjw_newsletter/menu' ),
    'dashboard',    'Dashboard'|i18n( 'cjw_newsletter/menu' ),
    'users',        'Users'|i18n( 'cjw_newsletter/menu' ),
    'blacklists',   'Blacklists'|i18n( 'cjw_newsletter/menu' ),
    'bounces',      'Bounces'|i18n( 'cjw_newsletter/menu' ),
)}
{include uri='design:parts/ini_menu.tpl' ini_section='Leftmenu_newsletter_settings' uri_string=$nl_uri i18n_hash=hash(
    'settings',          'Settings'|i18n( 'cjw_newsletter/menu' ),
    'mail_accounts',     'Mail accounts'|i18n( 'cjw_newsletter/menu' ),
    'imports',           'Imports'|i18n( 'cjw_newsletter/menu' ),
    'subscription_form', 'Subscription form'|i18n( 'cjw_newsletter/menu' ),
    'ini_settings',      'INI Settings'|i18n( 'cjw_newsletter/menu' ),
)}
{undef $nl_root_id $nl_root $nl_systems $nl_current_id $nl_path_ids $nl_lists $nl_open $nl_uri}
{/if}
