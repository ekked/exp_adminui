{def $assigned_nodes_count = $node.object.assigned_nodes|count}
{* DESIGN: Control bar START *}
<div class="node-control-toolbar">

    <form method="post" action={'content/action'|ezurl} class="btn-toolbar">
        <input type="hidden" name="TopLevelNode" value="{$node.object.main_node_id}" />
        <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
        <input type="hidden" name="ContentObjectID" value="{$node.contentobject_id}" />
        <div class="form-inline">
            {def $languages = fetch( 'content', 'prioritized_languages' )}

            {* Edit button. *}

            {if and(eq( $languages|count, 1 ), is_set( $languages[0] ) )}
                <input name="ContentObjectLanguageCode" value="{$languages[0].locale}" type="hidden" />
            {else}
                {foreach $node.object.can_edit_languages as $language}
                    {if $language.locale|eq($node.object.current_language)}
                        <input name="ContentObjectLanguageCode" value="{$language.locale|wash}" type="hidden">
                    {/if}
                {/foreach}
            {/if}

            <div class="btn-group">
                <button class="btn btn-primary" type="submit" name="EditButton" {if $node.can_edit}title="{'Edit the contents of this item.'|i18n( 'design/admin/node/view/full' )}"{else}title="{'You do not have permission to edit this item.'|i18n( 'design/admin/node/view/full' )}" disabled="disabled"{/if}><i class="fa fa-pencil-square-o"></i>&nbsp; {'Edit'|i18n( 'design/admin/node/view/full' )}</button>
                <div class="btn-group" role="group">
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><strong>...</strong></button>
                    <ul class="dropdown-menu dropdown-menu-right">
                        {* Upload: ezmultiupload's upload page for this node, only where the module is enabled and
                           fetch( 'ezmultiupload', 'can_upload' ) says the current user can upload here (the
                           ezmultiupload/upload policy, read and create access, a container or a configured upload
                           class or node); published objects only. The icon is components.css's Bootstrap Icon. *}
                        {def $exp_can_upload = false()}
                        {if and( is_set( $node.node_id ), eq( $node.object.status, 1 ) )}
                            {if ezmodule( 'ezmultiupload/upload' )}{set $exp_can_upload = fetch( 'ezmultiupload', 'can_upload', hash( 'node_id', $node.node_id ) )}{/if}
                        {/if}
                        {if $exp_can_upload}
                            <li><a class="exp-node-upload" href={concat( 'ezmultiupload/upload/', $node.node_id )|ezurl} title="{'Upload files to this location.'|i18n( 'design/admin/node/view/full' )|wash}"><span class="a4-icon a4-bi-upload" aria-hidden="true"></span> {'Upload'|i18n( 'design/admin/node/view/full' )}</a></li>
                        {/if}
                        {undef $exp_can_upload}
                        {* Import/Export: the node's export and import menu (the administration's
                           node/view/import_export_button.tpl, the entries of popupmenu/popup_export_items.tpl), only
                           with an entry for the user here *}
                        {include uri='design:node/view/import_export_button.tpl' node=$node button_class='' in_list=true()}
                        {* Move button. *}
                        {if $node.can_move}
                            <li><input type="submit" name="MoveNodeButton" value="{'Move'|i18n( 'design/admin/node/view/full' )}" title="{'Move this item to another location.'|i18n( 'design/admin/node/view/full' )}" /></li>
                        {else}
                            <li><input class="disabled" type="submit" name="MoveNodeButton" value="{'Move'|i18n( 'design/admin/node/view/full' )}" title="{'You do not have permission to move this item to another location.'|i18n( 'design/admin/node/view/full' )}" disabled="disabled" /></li>
                        {/if}
                        
                        {* Copy button. *}
                        {if $node.object.can_create}
                            <li><a href={concat("content/copy/",$node.contentobject_id)|ezurl}>{'Copy'|i18n( 'design/admin/node/view/full' )}</a></li>
                        {else}
                            <li><a class="disabled" disabled="disabled" href="#">{'Copy'|i18n( 'design/admin/node/view/full' )}</a></li>
                        {/if}

                        {* Remove button. *}
                        {if $node.can_remove}
                            {if $assigned_nodes_count|gt(1)}
                                <li><button type="button" class="removeNodeConfirm">{'Remove'|i18n( 'design/admin/node/view/full' )}</button></li>
                            {else}
                                <li><input type="submit" name="ActionRemove" value="{'Remove'|i18n( 'design/admin/node/view/full' )}" title="{'Remove this item.'|i18n( 'design/admin/node/view/full' )}" /></li>
                            {/if}
                        {else}
                            <li><input class="disabled" type="submit" name="ActionRemove" value="{'Remove'|i18n( 'design/admin/node/view/full' )}" title="{'You do not have permission to remove this item.'|i18n( 'design/admin/node/view/full' )}" disabled="disabled" /></li>
                        {/if}
                        <li role="separator" class="divider"></li>
                        {* Link to manage versions *}
                        <li><a href={concat("content/history/", $node.contentobject_id )|ezurl} title="{'View and manage (copy, delete, etc.) the versions of this object.'|i18n( 'design/admin/content/edit' )}">{'Manage versions'|i18n( 'design/admin/content/edit' )}</a></li>
                    </ul>
                </div>
            </div>
        </div>

        {if $assigned_nodes_count|gt(1)}
            <div class="modal fade" id="removePrompt" tabindex="-1" role="dialog" aria-labelledby="removePromptLabel">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" id="removePromptLabel">{'Confirm location removal'|i18n( 'design/admin/node/removeobject' )}</h4>
                        </div>
                        <div class="modal-body">
                            <p>The object you want to remove exists on one or more locations and will be removed only from this location.</p>
                            <p>Are you sure you want to remove object from this location?</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                            <input type="submit" class="btn btn-primary" name="ActionRemove" value="{'Remove'|i18n( 'design/admin/node/view/full' )}" title="{'Remove this item.'|i18n( 'design/admin/node/view/full' )}" />
                        </div>
                    </div>
                </div>
            </div>
        {/if}
    </form>
</div>
{* DESIGN: Control bar END *}
