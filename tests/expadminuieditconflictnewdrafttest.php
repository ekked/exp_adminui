<?php
/**
 * The adminui edit-conflict page (content/edit of an object that already has a draft): "New draft" opens the editor of
 * the new draft. The template no longer posts DoNotEditAfterNewDraft, which made content/edit create the draft and
 * redirect back to the same conflict page, so the button seemed to do nothing. Reads the files only, without the kernel.
 *
 *   php tests/expadminuieditconflictnewdrafttest.php
 *
 *  ND-01 - the template has the New draft button
 *  ND-02 - it posts no DoNotEditAfterNewDraft field
 */

$failures = 0;
function ndCheck( $ok, $message )
{
    global $failures;
    echo ( $ok ? 'PASS' : 'FAIL' ), ": $message\n";
    if ( !$ok )
        $failures++;
}

$tpl = preg_replace( '/\{\*.*?\*\}/s', '', (string)@file_get_contents( dirname( __DIR__ ) . '/design/adminui/templates/content/edit_draft.tpl' ) );
ndCheck( strpos( $tpl, 'name="NewDraftButton"' ) !== false, 'ND-01 the edit-conflict page has the New draft button' );
ndCheck( !preg_match( '/<input[^>]+name="DoNotEditAfterNewDraft"/', $tpl ), 'ND-02 it posts no DoNotEditAfterNewDraft, so New draft opens the editor' );

echo $failures ? "FAIL: $failures check(s)\n" : "PASS: all checks\n";
exit( $failures ? 1 : 0 );
