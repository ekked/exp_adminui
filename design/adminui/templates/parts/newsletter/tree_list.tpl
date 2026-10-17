{* Exponential Admin UI: one newsletter list in the tree of parts/newsletter/menu.tpl, with its subscriptions and its
   editions by status (draft, sending, archived, aborted) and, for an ordinary list, its virtual lists below it
   (as contentstructuremenu/4_newsletter_list.tpl and 5_newsletter_list_virtual.tpl of cjw_newsletter).
   Input: list_node, last_item, path_ids (node ids of the current page's path), current_id (its node id), uri_string. *}
{def $tl_id         = $list_node.node_id
     $tl_virtual    = $list_node.class_identifier|eq( 'cjw_newsletter_list_virtual' )
     $tl_children   = cond( $tl_virtual, array(),
                            fetch( 'content', 'list', hash( 'parent_node_id', $tl_id,
                                                            'class_filter_type', 'include',
                                                            'class_filter_array', array( 'cjw_newsletter_list_virtual' ) ) ) )
     $tl_open       = $path_ids|contains( $tl_id )
     $tl_statistic  = $list_node.data_map.newsletter_list.content.user_count_statistic
     $tl_status_url = ''
     $tl_items      = array( hash( 'status', 'draft',   'icon', 'Edit.png',   'name', 'Draft'|i18n( 'cjw_newsletter/contentstructuremenu' ) ),
                             hash( 'status', 'process', 'icon', 'Outbox.png', 'name', 'Sending'|i18n( 'cjw_newsletter/contentstructuremenu' ) ),
                             hash( 'status', 'archive', 'icon', 'Box.png',    'name', 'Archived'|i18n( 'cjw_newsletter/contentstructuremenu' ) ),
                             hash( 'status', 'abort',   'icon', 'Stop.png',   'name', 'Aborted'|i18n( 'cjw_newsletter/contentstructuremenu' ) ) )
     $tl_sub_url    = concat( 'newsletter/subscription_list/', $tl_id )
     $tl_on_list    = and( $current_id|eq( $tl_id ), $uri_string|contains( '(status)' )|not, $uri_string|begins_with( 'newsletter/subscription_list/' )|not )}
<li id="nt{$tl_id}" class="{if $tl_on_list}currentnode{/if}{if $last_item} lastli{/if}">
    <a class="{if $tl_open}openclose-close{else}openclose-open{/if}" href="#" title="{'Fold/Unfold'|i18n( 'cjw_newsletter/contentstructuremenu' )}" data-expui-openclose></a>
    {$list_node.class_identifier|class_icon( 'small' )}&nbsp;<a class="image-text" href={concat( 'content/view/full/', $tl_id )|ezurl}><span class="node-name-normal">{$list_node.name|wash}</span></a>
    <div class="{if $tl_open}loaded{else}hidden{/if}"><ul>
        <li id="n{$tl_id}_subscription_list"{if or( $uri_string|eq( $tl_sub_url ), $uri_string|begins_with( concat( $tl_sub_url, '/' ) ) )} class="currentnode"{/if}>
            <img src={'icons/kp/16x16/Users.png'|ezimage} width="16" height="16" alt="" />&nbsp;<a class="image-text" href={$tl_sub_url|ezurl}><span class="node-name-normal">{if $tl_virtual}{'Subscriptions Filter (%approved/%all)'|i18n( 'cjw_newsletter/contentstructuremenu',, hash( '%approved', $tl_statistic.approved, '%all', $tl_statistic.all ) )}{else}{'Subscriptions'|i18n( 'cjw_newsletter/contentstructuremenu' )} ({$tl_statistic.approved}/{$tl_statistic.all}){/if}</span></a>
        </li>
        {foreach $tl_items as $tl_index => $tl_item}
        {set $tl_status_url = concat( 'content/view/full/', $tl_id, '/(status)/', $tl_item.status )}
        <li id="n{$tl_id}_{$tl_item.status}" class="{if and( $current_id|eq( $tl_id ), $uri_string|contains( concat( '(status)/', $tl_item.status ) ) )}currentnode{/if}{if and( $tl_index|eq( 3 ), $tl_children|count|eq( 0 ) )} lastli{/if}">
            <img src={concat( 'icons/kp/16x16/', $tl_item.icon )|ezimage} width="16" height="16" alt="" />&nbsp;<a class="image-text" href={$tl_status_url|ezurl}><span class="node-name-normal">{$tl_item.name} ({fetch( 'content', 'list_count', hash( 'parent_node_id', $tl_id, 'extended_attribute_filter', hash( 'id', 'CjwNewsletterEditionFilter', 'params', hash( 'status', $tl_item.status ) ) ) )})</span></a>
        </li>
        {/foreach}
        {foreach $tl_children as $tl_child_index => $tl_child}
            {include uri='design:parts/newsletter/tree_list.tpl' list_node=$tl_child last_item=$tl_child_index|eq( $tl_children|count|dec ) path_ids=$path_ids current_id=$current_id uri_string=$uri_string}
        {/foreach}
    </ul></div>
</li>
{undef $tl_id $tl_virtual $tl_children $tl_open $tl_statistic $tl_status_url $tl_items $tl_sub_url $tl_on_list}
