/**
 * Exponential Admin UI: the small actions of the templates, as data attributes instead of inline handlers.
 *
 * Loaded on every page of the design (page_head_script.tpl). One listener per event on the document, so the
 * templates carry no on...= attribute and no javascript: link and the pages run under a Content Security Policy
 * without 'unsafe-inline'. It needs no other script; ezjs_toggleCheckboxes() is used where the page has it.
 *
 *   data-expui-toggle-checkboxes="Name[]"   click: invert the checkboxes of that name in the form
 *       data-expui-form="formname"          (the form by name; default: the element's own form)
 *   data-expui-confirm="Question?"          click (or submit of a form): go on only when confirmed
 *   data-expui-discard-confirm="Question?"  click: as data-expui-confirm, and first set the form's DiscardConfirm
 *                                           field to "0" (the confirmation page is not needed then)
 *   data-expui-submit-on-change             change: submit the element's form
 *   data-expui-navigate-on-change           change: go to the address that is the field's value
 *   data-expui-submit-form="id"            click: submit the form with that id
 *   data-expui-disable-on-click="selector"  click: disable the fields the selector finds (the button still sends)
 *   data-expui-history-back                 click: go back in the history
 *   data-expui-prevent                      click: do nothing (a script of the page sets the button up)
 *   data-expui-check-all="selector"         click: set every checkbox the selector finds to this one's state
 *   data-expui-set-class="id class"         click: set the class of the element with that id
 *   data-expui-reveal="id"                  click: show the element with that id, focus the field of
 *       data-expui-reveal-focus="id"        data-expui-reveal-focus, and hide the button
 *   data-expui-openclose                    click: fold or unfold the tree item (openclose-open/-close, the div
 *                                           after it loaded/hidden)
 *   data-expui-multioption="attribute id"   change: ezmultioption_check_option( this, rules<id>, <id> )
 *   data-expui-highlight="#selector"        change: mark that button as the one to press (btn-primary), unless
 *                                           it is disabled
 *   data-expui-highlight-main="#selector"   change of a radio: btn-primary when the radio has only its own class
 *                                           (not the current main one), btn-default otherwise
 *   data-expui-highlight-toggle="#selector" change: switch that button between btn-default and btn-primary
 *   data-expui-highlight-initial="#selector" change: btn-primary when any field with this attribute and the same
 *                                           selector differs from its value on load, btn-default otherwise
 *   data-expui-focus                        on load: select and focus the (first) field
 *
 * confirmDiscard( question ) stays a global function for templates of other extensions that still call it.
 */
(function ()
{
    if ( window.expAdminUIActions )
        return;
    window.expAdminUIActions = true;

    function closest( target, selector )
    {
        var el = target && target.nodeType === 1 ? target : ( target && target.parentNode );
        return el && el.closest ? el.closest( selector ) : null;
    }

    function formOf( el )
    {
        var name = el.getAttribute( 'data-expui-form' );
        if ( name && document.forms[name] )
            return document.forms[name];
        return el.form || ( el.closest ? el.closest( 'form' ) : null );
    }

    function toggleCheckboxes( form, name )
    {
        if ( !form )
            return;
        if ( typeof window.ezjs_toggleCheckboxes === 'function' )
            return window.ezjs_toggleCheckboxes( form, name );
        for ( var i = 0; i < form.elements.length; i++ )
        {
            var box = form.elements[i];
            if ( box.type === 'checkbox' && box.name === name && !box.disabled )
                box.checked = !box.checked;
        }
    }

    function discardConfirmField( form )
    {
        form = form || document.editform || document.tageditform;
        return form && form.elements ? form.elements.DiscardConfirm : null;
    }

    if ( typeof window.confirmDiscard !== 'function' )
    {
        window.confirmDiscard = function ( question )
        {
            var field = discardConfirmField( null );
            if ( field )
                field.value = '0';
            return window.confirm( question );
        };
    }

    function highlight( button, on )
    {
        if ( !button )
            return;
        if ( on )
        {
            button.classList.remove( 'button', 'btn-default' );
            button.classList.add( 'btn-primary' );
        }
        else
        {
            button.classList.remove( 'btn-primary' );
            button.classList.add( 'btn-default' );
        }
    }

    document.addEventListener( 'click', function ( e )
    {
        var el;

        if ( ( el = closest( e.target, '[data-expui-toggle-checkboxes]' ) ) )
        {
            e.preventDefault();
            toggleCheckboxes( formOf( el ), el.getAttribute( 'data-expui-toggle-checkboxes' ) );
            return;
        }
        if ( ( el = closest( e.target, '[data-expui-discard-confirm]' ) ) )
        {
            var field = discardConfirmField( formOf( el ) );
            if ( field )
                field.value = '0';
            if ( !window.confirm( el.getAttribute( 'data-expui-discard-confirm' ) ) )
            {
                e.preventDefault();
                e.stopImmediatePropagation();
            }
            return;
        }
        if ( ( el = closest( e.target, '[data-expui-confirm]' ) ) && el.tagName !== 'FORM' )
        {
            if ( !window.confirm( el.getAttribute( 'data-expui-confirm' ) ) )
            {
                e.preventDefault();
                e.stopImmediatePropagation();
            }
            return;
        }
        if ( ( el = closest( e.target, '[data-expui-disable-on-click]' ) ) )
        {
            var off = document.querySelectorAll( el.getAttribute( 'data-expui-disable-on-click' ) );
            for ( var d = 0; d < off.length; d++ )
                off[d].disabled = true;
            return;
        }
        if ( ( el = closest( e.target, '[data-expui-submit-form]' ) ) )
        {
            var form = document.getElementById( el.getAttribute( 'data-expui-submit-form' ) );
            if ( form )
                form.submit();
            return;
        }
        if ( ( el = closest( e.target, '[data-expui-history-back]' ) ) )
        {
            e.preventDefault();
            window.history.back();
            return;
        }
        if ( ( el = closest( e.target, '[data-expui-prevent]' ) ) )
        {
            e.preventDefault();
            return;
        }
        if ( ( el = closest( e.target, '[data-expui-check-all]' ) ) )
        {
            var boxes = document.querySelectorAll( el.getAttribute( 'data-expui-check-all' ) );
            for ( var i = 0; i < boxes.length; i++ )
                boxes[i].checked = el.checked;
            return;
        }
        if ( ( el = closest( e.target, '[data-expui-set-class]' ) ) )
        {
            e.preventDefault();
            var parts = el.getAttribute( 'data-expui-set-class' ).split( ' ' ), target = document.getElementById( parts[0] );
            if ( target )
                target.className = parts.slice( 1 ).join( ' ' );
            return;
        }
        if ( ( el = closest( e.target, '[data-expui-reveal]' ) ) )
        {
            e.preventDefault();
            var box = document.getElementById( el.getAttribute( 'data-expui-reveal' ) ),
                input = document.getElementById( el.getAttribute( 'data-expui-reveal-focus' ) || '' );
            if ( box )
            {
                box.hidden = false;
                box.style.display = 'block';
            }
            if ( input )
                input.focus();
            el.style.display = 'none';
            return;
        }
        if ( ( el = closest( e.target, '[data-expui-openclose]' ) ) )
        {
            e.preventDefault();
            var open = el.className === 'openclose-open', inner = el.parentNode.querySelector( 'div' );
            el.className = open ? 'openclose-close' : 'openclose-open';
            if ( inner )
                inner.className = open ? 'loaded' : 'hidden';
        }
    } );

    // a form with data-expui-confirm asks when it is sent
    document.addEventListener( 'submit', function ( e )
    {
        var form = e.target;
        if ( form && form.hasAttribute && form.hasAttribute( 'data-expui-confirm' ) && !window.confirm( form.getAttribute( 'data-expui-confirm' ) ) )
            e.preventDefault();
    } );

    document.addEventListener( 'change', function ( e )
    {
        var el = e.target, selector, i;
        if ( !el || !el.hasAttribute )
            return;

        if ( el.hasAttribute( 'data-expui-submit-on-change' ) && el.form )
        {
            el.form.submit();
            return;
        }
        if ( el.hasAttribute( 'data-expui-navigate-on-change' ) )
        {
            window.location.href = el.value;
            return;
        }
        if ( el.hasAttribute( 'data-expui-multioption' ) )
        {
            var id = el.getAttribute( 'data-expui-multioption' );
            if ( typeof window.ezmultioption_check_option === 'function' )
                window.ezmultioption_check_option( el, window['rules' + id], id );
            return;
        }
        if ( ( selector = el.getAttribute( 'data-expui-highlight' ) ) )
        {
            var button = document.querySelector( selector );
            if ( button && !button.disabled && !button.hasAttribute( 'disabled' ) )
                highlight( button, true );
        }
        if ( ( selector = el.getAttribute( 'data-expui-highlight-main' ) ) )
            highlight( document.querySelector( selector ), el.className === 'main-locations-radio' || el.className === 'main-translation-radio' );
        if ( ( selector = el.getAttribute( 'data-expui-highlight-toggle' ) ) )
        {
            var toggled = document.querySelector( selector );
            if ( toggled )
            {
                toggled.classList.toggle( 'btn-default' );
                toggled.classList.toggle( 'btn-primary' );
            }
        }
        if ( ( selector = el.getAttribute( 'data-expui-highlight-initial' ) ) )
        {
            var fields = document.querySelectorAll( '[data-expui-highlight-initial]' ), changed = false;
            for ( i = 0; i < fields.length; i++ )
            {
                if ( fields[i].getAttribute( 'data-expui-highlight-initial' ) === selector && fields[i].value !== fields[i].getAttribute( 'data-expui-initial' ) )
                    changed = true;
            }
            highlight( document.querySelector( selector ), changed );
        }
    } );

    function ready()
    {
        var fields = document.querySelectorAll( '[data-expui-highlight-initial]' ), i;
        for ( i = 0; i < fields.length; i++ )
            fields[i].setAttribute( 'data-expui-initial', fields[i].value );

        var focus = document.querySelector( '[data-expui-focus]' );
        if ( focus )
        {
            if ( focus.select )
                focus.select();
            focus.focus();
        }
    }

    if ( document.readyState === 'loading' )
        document.addEventListener( 'DOMContentLoaded', ready );
    else
        ready();
})();
