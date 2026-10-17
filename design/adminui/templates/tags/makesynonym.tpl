<div class="context-block tags-edit">
    <div class="box-header">
        <h1 class="context-title">{"Convert to synonym"|i18n( 'extension/eztags/tags/edit' )}: {$tag.keyword|wash} [{$tag.id}]</h1>
        <div class="header-mainline"></div>
    </div>

    {if $error|count}
        <div class="message-error">
            <h2>{$error|wash}</h2>
        </div>
    {/if}

    {if $warning|count}
        <div class="message-warning">
            <h2>{$warning|wash}</h2>
        </div>
    {/if}

    {if $convert_allowed}
        <div class="box-content panel">
            <form name="tageditform" id="tageditform" enctype="multipart/form-data" method="post" action={concat( 'tags/makesynonym/', $tag.id )|ezurl}>
                <div class="block tag-edit-parent form-inline">
                    {if ezhttp_hasvariable( 'MainTagID', 'post' )}
                        {def $main_tag_id = ezhttp( 'MainTagID', 'post' )}
                    {else}
                        {def $main_tag_id = 0}
                    {/if}

                    <label>{'Main tag'|i18n( 'extension/eztags/tags/edit' )}</label>
                    <input id="eztags_parent_id_0" type="hidden" name="MainTagID" value="{$main_tag_id}" />
                    <input id="hide_tag_id_0" type="hidden" name="TagHideID" value="{$tag.id}" />
                    <span id="eztags_parent_keyword_0">{eztags_parent_string( $main_tag_id )|wash}</span>
                    <input class="btn btn-default" type="button" name="SelectParentButton" id="eztags-parent-selector-button-0" value="{'Select main tag'|i18n( 'extension/eztags/tags/edit' )}" />
                </div>

                <div class="controlbar">
                    <div class="btn-group">
                        <input class="btn btn-primary" type="submit" name="SaveButton" value="{'Save'|i18n( 'extension/eztags/tags/edit' )}" />
                        <input type="hidden" name="DiscardConfirm" value="1" />
                        <input class="btn btn-default" type="submit" name="DiscardButton" value="{'Discard'|i18n( 'extension/eztags/tags/edit' )}" data-expui-discard-confirm="{'Are you sure you want to discard changes?'|i18n( 'extension/eztags/tags/edit' )|wash}" />
                    </div>
                </div>
            </form>
        </div>
    {else}
        <div class="controlbar">
            <div class="block">
                <input class="button" type="button" data-expui-history-back value="{'Go back'|i18n( 'extension/eztags/errors' )}" />
            </div>
        </div>
    {/if}
</div>

{if $convert_allowed}
    {include uri='design:ezjsctemplate/modal_dialog.tpl'}

    {* Discard asks first: data-expui-discard-confirm (exp_adminui_actions.js) *}
{/if}
