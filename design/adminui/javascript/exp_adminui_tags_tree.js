/**
 * Exponential Admin UI: the tags tree of the left column (tagsstructuremenu/tags_structure_menu_dynamic.tpl).
 *
 * The template prints div.exp-adminui-tags-tree-data with data-expui-tags-tree (JSON: params and root) and this file
 * right after it. As a normal (blocking) script it writes the list in place, as the inline script did, with eztags'
 * TagsStructureMenu; window.treeMenu_0 and window.TagsStructureMenuParams are set as before.
 */
(function ()
{
    var me = document.currentScript, data = null, el;
    for ( el = me ? me.previousElementSibling : null; el; el = el.previousElementSibling )
    {
        if ( el.classList && el.classList.contains( 'exp-adminui-tags-tree-data' ) )
        {
            data = el;
            break;
        }
    }
    if ( !data )
    {
        var all = document.querySelectorAll( 'div.exp-adminui-tags-tree-data' );
        data = all.length ? all[all.length - 1] : null;
    }
    if ( !data || data.getAttribute( 'data-expui-tree-drawn' ) || typeof window.TagsStructureMenu !== 'function' )
        return;
    data.setAttribute( 'data-expui-tree-drawn', '1' );

    var conf = {};
    try { conf = JSON.parse( data.getAttribute( 'data-expui-tags-tree' ) || '{}' ) || {}; } catch ( e ) { conf = {}; }

    var currentDate = new Date().valueOf();
    window.TagsStructureMenuParams = conf.params || {};
    var treeMenu = window.treeMenu_0 = new TagsStructureMenu( window.TagsStructureMenuParams, '0' );

    var rootTag = conf.root || {};
    rootTag.modified = currentDate;

    document.writeln( '<ul id="content-tree-menu">' );
    document.writeln( treeMenu.generateEntry( rootTag, false, true ) );
    document.writeln( '<\/ul>' );

    treeMenu.load( false, 0, currentDate );
})();
