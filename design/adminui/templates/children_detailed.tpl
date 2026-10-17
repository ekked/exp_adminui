{* Exponential Admin UI: admin4's sub-items table (Exponential UI exp::datatable), with the reference's "Create new subitem" label. The reference's own children_detailed.tpl needs YUI 2. *}
{def $section         = fetch( 'section', 'object', hash( 'section_id', $node.object.section_id ) )
    $visible_columns  = ezini('SubItems', 'VisibleColumns', 'admininterface.ini')
    $locales          = fetch( 'content', 'translation_list' )
    $subitems_languages = hash()
    $subitems_icons   = hash()
    $subitems_columns = hash()
    $subitems_sort_key = 'published_date'
    $subitems_create_groups  = array()
    $subitems_create_options = array()
    $subitems_group_options  = array()}

{* The sub-items table's settings and texts: data attributes of #exp-adminui-subitems-config (JSON, HTML-escaped for
   the attribute), which exp_adminui_children_detailed.js hands to the table script (ezajaxsubitems_expdatatable.js).
   No inline script, so the page runs under a Content Security Policy without 'unsafe-inline'. *}
{foreach $locales as $language}{set $subitems_languages = $subitems_languages|merge( hash( $language.locale_code, $language.intl_language_name ) )}{/foreach}
{foreach $locales as $locale}{set $subitems_icons = $subitems_icons|merge( hash( $locale.locale_code, $locale.locale_code|flag_icon() ) )}{/foreach}
{foreach $visible_columns as $index => $object}{set $subitems_columns = $subitems_columns|merge( hash( $index, $object ) )}{/foreach}

{switch match=$node.sort_field}
{case match='2'}{set $subitems_sort_key = 'published_date'}{/case}
{case match='3'}{set $subitems_sort_key = 'modified_date'}{/case}
{case match='4'}{set $subitems_sort_key = 'section'}{/case}
{case match='7'}{set $subitems_sort_key = 'class_name'}{/case}
{case match='8'}{set $subitems_sort_key = 'priority'}{/case}
{case match='9'}{set $subitems_sort_key = 'name'}{/case}
{case}{set $subitems_sort_key = 'published_date'}{/case}
{/switch}

{if and( $node.is_container,  $node.can_create)}
    {if $node.path_array|contains( ezini( 'NodeSettings', 'MediaRootNode', 'content.ini' ) )}
        {def $group_id = array( ezini( 'ClassGroupIDs', 'Users', 'content.ini' ),
                                ezini( 'ClassGroupIDs', 'Setup', 'content.ini' ) )}
    {elseif $node.path_array|contains( ezini( 'NodeSettings', 'UserRootNode', 'content.ini' ) )}
        {def $group_id = array( ezini( 'ClassGroupIDs', 'Setup', 'content.ini' ),
                                ezini( 'ClassGroupIDs', 'Content', 'content.ini' ),
                                ezini( 'ClassGroupIDs', 'Media', 'content.ini' ) )}
    {else}
        {def $group_id = false()}
    {/if}

    {def $can_create_classes = fetch( 'content', 'can_instantiate_class_list', hash( 'parent_node', $node,
                                                                                     'filter_type', 'exclude',
                                                                                     'group_id', $group_id,
                                                                                     'group_by_class_group', true() ) )}

    {* The "Create new" menu: one group per class group, its classes (names HTML-escaped: the menu shows them as markup) *}
    {foreach $can_create_classes as $group}
        {set $subitems_create_groups = $subitems_create_groups|append( $group.group_name )}
        {set $subitems_group_options = array()}
        {foreach $group.items as $can_create_class}
            {if $can_create_class.can_instantiate_languages}
                {set $subitems_group_options = $subitems_group_options|append( hash( 'text', $can_create_class.name|wash(), 'value', $can_create_class.id|int() ) )}
            {/if}
        {/foreach}
        {set $subitems_create_options = $subitems_create_options|append( $subitems_group_options )}
    {/foreach}
{/if}

<div id="exp-adminui-subitems-config" hidden
     data-conf="{json_encode( hash(
        'sortKey', $subitems_sort_key,
        'dataSourceURL', concat( 'ezjscore/call/ezjscnode::subtree::', $node.node_id )|ezurl( 'no' ),
        'nodeID', $node.node_id|int(),
        'subitemsServer', ezini_hasvariable( 'ezjscServer_expsubitems', 'Class', 'ezjscore.ini' ),
        'exportURL', concat( 'content/subitemsexport/', $node.node_id )|ezurl( 'no' ),
        'editPrefixURL', '/content/edit/'|ezurl( 'no' ),
        'rowsPrPage', $number_of_items|int(),
        'sortOrder', $node.sort_order|int(),
        'nameFilter', concat( '', first_set( $view_parameters.namefilter, '' ) ),
        'defaultShownColumns', $subitems_columns,
        'navigationPart', concat( '', $section.navigation_part_identifier ),
        'cookieName', 'eZSubitemColumns',
        'cookieSecure', false(),
        'cookieDomain', ezsys( 'hostname' ),
        'languages', $subitems_languages,
        'classesString', concat( '', $node.classes_js_array ),
        'flagIcons', $subitems_icons ) )|wash}"
     data-labels="{json_encode( 
hash(
    'DATA_TABLE', hash(
        'msg_loading', 'Loading ...'|i18n( 'design/admin/node/view/full' ) ),
    'DATA_TABLE_COLS', hash(
        'thumbnail', 'Thumbnail'|i18n( 'design/admin/node/view/full' ),
        'name', 'Name'|i18n( 'design/admin/node/view/full' ),
        'visibility', 'Visibility'|i18n( 'design/admin/node/view/full' ),
        'type', 'Type'|i18n( 'design/admin/node/view/full' ),
        'modifier', 'Modifier'|i18n( 'design/admin/node/view/full' ),
        'modified', 'Modified'|i18n( 'design/admin/node/view/full' ),
        'published', 'Published'|i18n( 'design/admin/node/view/full' ),
        'section', 'Section'|i18n( 'design/admin/node/view/full' ),
        'translations', 'Translations'|i18n( 'design/admin/node/view/full' ),
        'priority', 'Priority'|i18n( 'design/admin/node/view/full' ),
        'nodeid', 'Node ID'|i18n( 'design/admin/node/view/full' ),
        'objectid', 'Object ID'|i18n( 'design/admin/node/view/full' ),
        'noderemoteid', 'Node remote ID'|i18n( 'design/admin/node/view/full' ),
        'objectremoteid', 'Object remote ID'|i18n( 'design/admin/node/view/full' ),
        'objectstate', 'Object state'|i18n( 'design/admin/node/view/full' ) ),
    'TABLE_OPTIONS', hash(
        'header', 'Table options'|i18n( 'design/admin/node/view/full' ),
        'header_noipp', 'Number of items per page:'|i18n( 'design/admin/node/view/full' ),
        'header_vtc', 'Visible table columns:'|i18n( 'design/admin/node/view/full' ),
        'button_close', 'Close'|i18n( 'design/admin/node/view/full' ),
        'custom_label', 'Custom'|i18n( 'design/admin/node/view/full' ),
        'custom_placeholder', 'Enter number'|i18n( 'design/admin/node/view/full' ),
        'custom_invalid', 'Please enter a valid number between 1 and 10000'|i18n( 'design/admin/node/view/full' ),
        'filter_label', 'Find a column:'|i18n( 'design/admin/node/view/full' ),
        'filter_placeholder', 'Column name'|i18n( 'design/admin/node/view/full' ),
        'filter_none', 'No columns match.'|i18n( 'design/admin/node/view/full' ),
        'group_other', 'Other'|i18n( 'design/admin/node/view/full' ),
        'order_legend', 'Order of the visible columns:'|i18n( 'design/admin/node/view/full' ),
        'order_hint', 'Drag a column to move it, or use its arrow buttons.'|i18n( 'design/admin/node/view/full' ),
        'order_up', 'Move %name up'|i18n( 'design/admin/node/view/full' ),
        'order_down', 'Move %name down'|i18n( 'design/admin/node/view/full' ),
        'presets_legend', 'Column presets:'|i18n( 'design/admin/node/view/full' ),
        'presets_choose', 'Preset'|i18n( 'design/admin/node/view/full' ),
        'presets_none', 'None'|i18n( 'design/admin/node/view/full' ),
        'presets_name', 'Name of the new preset'|i18n( 'design/admin/node/view/full' ),
        'presets_save_as', 'Save current as...'|i18n( 'design/admin/node/view/full' ),
        'presets_delete', 'Delete preset'|i18n( 'design/admin/node/view/full' ),
        'export_csv', 'Export CSV'|i18n( 'design/admin/node/view/full' ),
        'export_csv_title', 'Download the items with the visible columns as a CSV file'|i18n( 'design/admin/node/view/full' ),
        'copy_title', 'Click to copy'|i18n( 'design/admin/node/view/full' ),
        'copied', 'Copied'|i18n( 'design/admin/node/view/full' ),
        'copy_failed', 'Not copied'|i18n( 'design/admin/node/view/full' ) ),
    'ACTION_BUTTONS', hash(
        'select', 'Select'|i18n( 'design/admin/node/view/full' ),
        'select_sav', 'Select all visible'|i18n( 'design/admin/node/view/full' ),
        'select_sn', 'Select none'|i18n( 'design/admin/node/view/full' ),
        'select_inv', 'Invert selection'|i18n( 'design/admin/node/view/full' ),
        'create_new', 'Create new subitem'|i18n( 'design/admin/node/view/full' ),
        'more_actions', 'More actions'|i18n( 'design/admin/node/view/full' ),
        'more_actions_rs', 'Remove selected'|i18n( 'design/admin/node/view/full' ),
        'more_actions_ms', 'Move selected'|i18n( 'design/admin/node/view/full' ),
        'more_actions_cp', 'Copy selected'|i18n( 'design/admin/node/view/full' ),
        'more_actions_hs', 'Hide selected'|i18n( 'design/admin/node/view/full' ),
        'more_actions_us', 'Unhide selected'|i18n( 'design/admin/node/view/full' ),
        'create_multiple', 'Create multiple new'|i18n( 'design/admin/node/view/full' ),
        'more_actions_me', 'Edit selected'|i18n( 'design/admin/node/view/full' ),
        'more_actions_al', 'Add a location'|i18n( 'design/admin/node/view/full' ),
        'more_actions_no', 'Use the checkboxes to select one or more items.'|i18n( 'design/admin/node/view/full' ),
        'table_options', 'Table options'|i18n( 'design/admin/node/view/full' ),
        'first_page', concat( '&laquo;&nbsp;', 'first'|i18n( 'design/admin/node/view/full' ) ),
        'previous_page', concat( '&lsaquo;&nbsp;', 'prev'|i18n( 'design/admin/node/view/full' ) ),
        'next_page', concat( 'next'|i18n( 'design/admin/node/view/full' ), '&nbsp;&rsaquo;' ),
        'last_page', concat( 'last'|i18n( 'design/admin/node/view/full' ), '&nbsp;&raquo;' ) ) ) )|wash}"
     data-create-groups="{json_encode( $subitems_create_groups )|wash}"
     data-create-options="{json_encode( $subitems_create_options )|wash}"
     data-multiedit-url="{'content/multiedit'|ezurl( 'no' )|wash}"></div>
{ezscript( array( 'exp_adminui_children_detailed.js' ) )}
{undef $section $visible_columns $locales $subitems_languages $subitems_icons $subitems_columns $subitems_sort_key
       $subitems_create_groups $subitems_create_options $subitems_group_options}

<div id="action-controls-container">
    <div id="action-controls"></div>
    <div id="tpg"></div>
</div>
<div id="content-sub-items-list" class="content-navigation-childlist"></div>
<div id="bpg"></div>

<div id="to-dialog-container"></div>

{if ezini( 'ExtensionSettings', 'ActiveExtensions' )|contains( 'expui' )}
    {* the texts Exponential UI's table shows itself (page links, sorting, editing), translated *}
    {exp_config( hash( 'strings', array( 'Loading...', 'No records found.', 'Data error.', 'Click to sort ascending', 'Click to sort descending',
                                         'Pages', 'Page %page', 'Page %page of %pages', 'First page', 'Previous page', 'Next page', 'Last page',
                                         'Table actions', 'Select %name', 'Press Enter to edit', 'Sorted by %column, ascending', 'Sorted by %column, descending' ) ) )}
{/if}
