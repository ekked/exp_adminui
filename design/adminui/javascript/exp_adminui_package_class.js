/**
 * Exponential Admin UI: the class step of the package creator (package/creators/ezcontentclass/class.tpl):
 * the class list shows as many rows as it has classes, at most 30. Printed right after the list.
 */
(function ()
{
    var listBoxMultiple = document.getElementsByClassName( 'listbox' )[0];
    if ( listBoxMultiple )
        listBoxMultiple.setAttribute( 'size', listBoxMultiple.children.length < 30 ? listBoxMultiple.children.length : 30 );
})();
