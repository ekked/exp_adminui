/**
 * Exponential Admin UI: the information step of the package creator (package/create/info.tpl): the license
 * chosen shows its link and its description (the data-* attributes of its option). Printed right after the list.
 */
(function()
{
    var select = document.getElementById( 'PackageLicence' ),
        link = document.getElementById( 'PackageLicenceLink' ),
        linkLine = document.getElementById( 'PackageLicenceLinkLine' ),
        description = document.getElementById( 'PackageLicenceDescription' );
    if ( !select || !link )
        return;
    function update()
    {
        var option = select.options[select.selectedIndex];
        if ( !option )
            return;
        var url = option.getAttribute( 'data-url' ) || '',
            text = option.getAttribute( 'data-description' ) || '';
        link.href = url || '#';
        link.textContent = option.getAttribute( 'data-name' ) || option.value;
        linkLine.hidden = !url;
        description.firstChild.nodeValue = text;
        description.hidden = !text;
    }
    if ( !description.firstChild || description.firstChild.nodeType !== 3 )
        description.insertBefore( document.createTextNode( '' ), description.firstChild );
    select.onchange = update;
})();
