{* The Authors tab of the content view, for the adminui design: the Layouts extension's tab (design/admin
   tabs/authors.tpl) with cells that wrap. There every cell but the contributors was nowrap, and the contributors
   cell took the leftover width (width 100%, max-width 0): at 200% zoom the dates and the two names still did not
   fit the tab and the table ran up to 120px past the main area. Here the table lays itself out: at full width
   nothing wraps, and when the tab is narrow the dates and names break onto a second line instead.

   Contributors: everyone who created a version of this object, de-duplicated. The object carries one version per
   edit, each recording its creator, so the distinct creators across every version are the people who have worked on
   it. Built with contains() rather than unique() because the same person appears once per version they saved. *}
{def $tab_contributors = array()}
{foreach $node.object.versions as $tab_version}
    {if $tab_version.creator}
        {if not( $tab_contributors|contains( $tab_version.creator.name ) )}
            {set $tab_contributors = $tab_contributors|append( $tab_version.creator.name )}
        {/if}
    {/if}
{/foreach}
{set $tab_contributors = $tab_contributors|sort()}

<div class="block">
<table class="list" cellspacing="0" summary="{'Authors and publication information'|i18n( 'design/admin/tabs/authors' )}">
<tr>
    <th>{'Published'|i18n( 'design/admin/tabs/authors' )}</th>
    <th>{'Modified'|i18n( 'design/admin/tabs/authors' )}</th>
    <th>{'Creator'|i18n( 'design/admin/tabs/authors' )}</th>
    <th>{'Last contributor'|i18n( 'design/admin/tabs/authors' )}</th>
    <th>{'Contributors'|i18n( 'design/admin/tabs/authors' )}{if $tab_contributors|count|gt(1)} ({$tab_contributors|count}){/if}</th>
</tr>
<tr class="bglight">
    <td>{$node.object.published|l10n(shortdatetime)}</td>
    <td>{$node.object.modified|l10n(shortdatetime)}</td>
    <td><a href={$node.object.owner.main_node.url_alias|ezurl}>{$node.object.owner.name|wash}</a></td>
    <td><a href={$node.object.current.creator.main_node.url_alias|ezurl}>{$node.object.current.creator.name|wash}</a></td>
    <td class="contributors" style="white-space: normal; overflow-wrap: anywhere; line-height: 1.7;">
        {if $tab_contributors|count|gt(0)}{$tab_contributors|implode(', ')|wash}{else}-{/if}
    </td>
</tr>
</table>
</div>
{undef $tab_contributors}
