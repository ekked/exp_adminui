{if is_unset( $menu_persistence )}{def $menu_persistence = ezini( 'TreeMenu', 'MenuPersistence', 'eztags.ini' )|eq( 'enabled' )}{/if}
{if is_unset( $current_user )}{def $current_user = fetch( user, current_user )}{/if}
{def $tree_path = array()}
{if is_set( $module_result.path[0].tag_id )}
    {foreach $module_result.path as $element}{set $tree_path = $tree_path|append( concat( '', $element.tag_id ) )}{/foreach}
{/if}
{* The tags tree is drawn by exp_adminui_tags_tree.js, printed right after this element, from its data (JSON), with
   the TagsStructureMenu of eztags; no inline script (Content Security Policy). treeMenu_0 and
   TagsStructureMenuParams are set as before. *}
<div class="exp-adminui-tags-tree-data" hidden data-expui-tags-tree="{json_encode( hash(
    'params', hash(
        'path', $tree_path,
        'useCookie', cond( $menu_persistence, true(), false() ),
        'perm', concat( $current_user.role_id_list|implode( ',' ), '|' , $current_user.limited_assignment_value_list|implode( ',' ) )|md5,
        'expiry', concat( '', fetch( content, content_tree_menu_expiry ) ),
        'modal', false(),
        'context', concat( '', $ui_context ),
        'showTips', ezini( 'TreeMenu', 'ToolTips', 'eztags.ini' )|eq( 'enabled' ),
        'autoOpen', ezini( 'TreeMenu', 'AutoopenCurrentTag', 'eztags.ini' )|eq( 'enabled' ),
        'tag_id_string', 'Tag ID'|i18n( 'extension/eztags/tags/treemenu' ),
        'parent_tag_id_string', 'Parent tag ID'|i18n( 'extension/eztags/tags/treemenu' ),
        'treemenu_base_url', 'tags/treemenu'|ezurl( no ),
        'not_allowed_string', 'Dynamic tree not allowed for this siteaccess'|i18n( 'extension/eztags/tags/treemenu' ),
        'no_tag_string', 'Tag does not exist'|i18n( 'extension/eztags/tags/treemenu' ),
        'internal_error_string', 'Internal error'|i18n( 'extension/eztags/tags/treemenu' ) ),
    'root', hash(
        'id', 0,
        'parent_id', 0,
        'has_children', true(),
        'keyword', 'Top level tags'|i18n( 'extension/eztags/tags/treemenu' ),
        'url', 'tags/dashboard'|ezurl( no ),
        'icon', ezini( 'Icons', 'Default', 'eztags.ini' )|tag_icon ) ) )|wash}"></div>
{ezscript( array( 'exp_adminui_tags_tree.js' ) )}
{undef $tree_path}
