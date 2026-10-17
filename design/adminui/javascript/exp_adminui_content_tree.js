/**
 * Exponential Admin UI: the content tree of the left column (contentstructuremenu/content_structure_menu_dynamic.tpl).
 *
 * The template prints div.exp-adminui-tree-data with the tree's data as JSON (data-expui-tree-root,
 * data-expui-tree-params, data-expui-tree-request) and this file right after it. As a normal (blocking) script it
 * writes the list in place, as the inline script did, with the ContentStructureMenu of contentstructuremenu_dynamic.js
 * (BackendJavaScriptList); window.treeMenu is set as before.
 */
(function ()
{
    var me = document.currentScript, data = null, el;
    for ( el = me ? me.previousElementSibling : null; el; el = el.previousElementSibling )
    {
        if ( el.classList && el.classList.contains( 'exp-adminui-tree-data' ) )
        {
            data = el;
            break;
        }
    }
    if ( !data )
    {
        var all = document.querySelectorAll( 'div.exp-adminui-tree-data' );
        data = all.length ? all[all.length - 1] : null;
    }
    if ( !data || data.getAttribute( 'data-expui-tree-drawn' ) || typeof window.ContentStructureMenu !== 'function' )
        return;
    data.setAttribute( 'data-expui-tree-drawn', '1' );

    function json( name )
    {
        try { return JSON.parse( data.getAttribute( name ) || '{}' ) || {}; } catch ( e ) { return {}; }
    }

    var rootNode = json( 'data-expui-tree-root' ), cached = json( 'data-expui-tree-params' ), request = json( 'data-expui-tree-request' );
    var params = {
        iconsList: {},
        contentTreeUrl: cached.contentTreeUrl,
        wwwDirPrefix: cached.wwwDirPrefix,
        languages: cached.languages || {},
        classes: cached.classes || {},
        showTips: !!cached.showTips,
        createHereMenu: cached.createHereMenu || '',
        autoOpen: !!cached.autoOpen,
        action: request.action || '',
        context: request.context || '',
        hideNodes: ( request.hideNodes || [] ).map( function ( id ) { return isNaN( id ) ? id : Number( id ); } ),
        maxDepth: parseInt( request.maxDepth, 10 ) || 0,
        expiry: request.expiry || '',
        useCookie: !!request.useCookie,
        path: request.path || [],
        perm: request.perm || ''
    };
    var icons = cached.icons || {}, key;
    for ( key in icons )
    {
        if ( Object.prototype.hasOwnProperty.call( icons, key ) )
            params.iconsList[key] = params.wwwDirPrefix + icons[key];
    }
    params.iconsList['__default__'] = params.wwwDirPrefix + cached.defaultIcon;
    if ( cached.preloadIcons && typeof window.ezjslib_preloadImageList === 'function' )
        window.ezjslib_preloadImageList( params.iconsList );

    var treeMenu = window.treeMenu = new ContentStructureMenu( params, cached.i18n || {} );

    document.writeln( '<ul id="content-tree-menu">' );
    document.writeln( treeMenu.generateEntry( rootNode, false, true ) );
    document.writeln( '<\/ul>' );

    treeMenu.load( false, rootNode.node_id, rootNode.modified_subnode );
})();
