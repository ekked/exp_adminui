{* One workflow process (workflow/process/<id>), in the boxes of the other workflow views.
   The standard design's template left a <b> open after the event status, and the browser carried it on around the
   page footer, which shrank the main column to the width of its text. The view sets no path, so there are no
   breadcrumbs; the boxes give the text the same inset as the other views. The form posts the same buttons
   (Reset, RunProcess) to the same view. *}
<form action={concat( $module.functions.process.uri, '/', $process.id )|ezurl} method="post" name="WorkflowProcess">

<div class="context-block">

{* DESIGN: Header START *}<div class="box-header"><div class="box-ml">
<h1 class="context-title">{'Workflow process'|i18n( 'design/standard/workflow' )} {$process.id}</h1>
{* DESIGN: Mainline *}<div class="header-mainline"></div>
{* DESIGN: Header END *}</div></div>

{* DESIGN: Content START *}<div class="box-ml"><div class="box-mr"><div class="box-content">

<div class="context-attributes">

<p>{'Workflow process was created at %creation and modified at %modification.'|i18n( 'design/standard/workflow',, hash( '%creation', $process.created|l10n( shortdatetime ), '%modification', $process.modified|l10n( shortdatetime ) ) )}</p>

<h2>{'Workflow'|i18n( 'design/standard/workflow' )}</h2>
<p>{'Using workflow'|i18n( 'design/standard/workflow' )} <b><a href={concat( $module.functions.edit.uri, '/', $process.workflow_id )|ezurl}>{$current_workflow.name|wash} ({$process.workflow_id})</a></b> {'for processing.'|i18n( 'design/standard/workflow' )}</p>

<h2>{'User'|i18n( 'design/standard/workflow' )}</h2>
<p>{'This workflow is running for user'|i18n( 'design/standard/workflow' )} <b>{$process.user.login|wash}</b>.</p>

<h2>{'Content object'|i18n( 'design/standard/workflow' )}</h2>
<p>{'Workflow was created for content'|i18n( 'design/standard/workflow' )} <b><a href={concat( '/content/view/', $process.content_id )|ezurl}>{$process.content.name|wash}</a></b>
{'using version'|i18n( 'design/standard/workflow' )} <b><a href={concat( '/content/view/', $process.content_id, '/', $process.content_version )|ezurl}>{$process.content_version}</a></b>
{'in parent'|i18n( 'design/standard/workflow' )} <b><a href={concat( '/content/view/', $process.node_id )|ezurl}>{$process.node.name|wash}</a></b></p>

<h2>{'Workflow event'|i18n( 'design/standard/workflow' )}</h2>
{if $current_event|not}
<p>{'Workflow has not started yet, number of main events in workflow is'|i18n( 'design/standard/workflow' )} <b>{$current_workflow.event_count}</b>.</p>
{else}
<p>{'Current event position is'|i18n( 'design/standard/workflow' )} <b>{$process.event_position}</b>.
{'Event to be run is'|i18n( 'design/standard/workflow' )} <i>{$current_event.workflow_type.name|wash}</i> {'event'|i18n( 'design/standard/workflow' )} <b>{$current_event.description|wash} ({$process.event_id})</b>.</p>
{/if}

{if $event_status}
<p>{'Last event returned status'|i18n( 'design/standard/workflow' )} <b>{$event_status|wash}</b>.</p>
{/if}

<h3>{'Workflow event list'|i18n( 'design/standard/workflow' )}</h3>
<ul>
{foreach $current_workflow.ordered_event_list as $index => $event}{def $number = $index|inc}
    {if eq( $number, $process.event_position )}
    <li><b>{$number}: {$event.workflow_type.name|wash} - {$event.description|wash}</b></li>
    {elseif eq( $number, $process.last_event_position )}
    <li><i>{$number}: {$event.workflow_type.name|wash} - {$event.description|wash}</i></li>
    {else}
    <li>{$number}: {$event.workflow_type.name|wash} - {$event.description|wash}</li>
    {/if}
    {undef $number}
{/foreach}
</ul>

</div>

{* DESIGN: Content END *}</div></div></div>

<div class="controlbar">
{* DESIGN: Control bar START *}<div class="box-bc"><div class="box-ml">
<div class="block">
    <input class="button" type="submit" name="Reset" value="{'Reset'|i18n( 'design/standard/workflow' )}" />
    <input class="button" type="submit" name="RunProcess" value="{'Next step'|i18n( 'design/standard/workflow' )}" />
</div>
{* DESIGN: Control bar END *}</div></div>
</div>

</div>

</form>
