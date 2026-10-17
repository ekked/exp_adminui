/**
 * Exponential Admin UI: the sub-items table of the node view (children_detailed.tpl). Reads the settings and texts
 * from the data attributes of #exp-adminui-subitems-config (JSON) and starts Exponential UI's exp::datatable
 * (ezajaxsubitems_expdatatable.js), as the inline script did. window.eZExpMultiEditURL is where "Edit selected"
 * sends the selection.
 */
(function ()
{
    var config = document.getElementById( 'exp-adminui-subitems-config' );
    if ( !config || config.getAttribute( 'data-expui-started' ) )
        return;
    config.setAttribute( 'data-expui-started', '1' );

    function json( name, fallback )
    {
        try
        {
            var value = JSON.parse( config.getAttribute( name ) || 'null' );
            return value === null ? fallback : value;
        }
        catch ( e )
        {
            return fallback;
        }
    }

    var confObj = json( 'data-conf', {} );
    var labelsObj = json( 'data-labels', {} );
    var createGroups = json( 'data-create-groups', [] );
    var createOptions = json( 'data-create-options', [] );

    // The columns of each navigation part, as the setting lists them (checkbox;crank;name;...)
    var vcols = {}, columns = confObj.defaultShownColumns || {}, part;
    for ( part in columns )
    {
        if ( Object.prototype.hasOwnProperty.call( columns, part ) )
            vcols[part] = String( columns[part] ).split( ';' );
    }
    confObj.defaultShownColumns = vcols;

    // The classes that may be created here: node.classes_js_array, a JSON array, or '' when none may
    var classes = confObj.classesString;
    if ( typeof classes !== 'string' || classes === '' || classes === "''" )
        confObj.classesString = '';
    else
    {
        try { confObj.classesString = JSON.parse( classes ); } catch ( e ) { confObj.classesString = ''; }
    }

    var multiEditURL = config.getAttribute( 'data-multiedit-url' );
    if ( multiEditURL )
        window.eZExpMultiEditURL = multiEditURL;

    // The sub-items table: Exponential UI's exp::datatable (ezajaxsubitems_expdatatable.js)
    if ( window.Exp && Exp.$ && Exp.$.fn.expDataTable && window.eZAjaxSubitemsExpDataTable )
    {
        Exp.ready( function ()
        {
            eZAjaxSubitemsExpDataTable.init( confObj, labelsObj, createGroups, createOptions );
        } );
    }
})();
