{default $view_parameters            = array()
         $attribute_categorys        = ezini( 'ClassAttributeSettings', 'CategoryList', 'content.ini' )
         $attribute_default_category = ezini( 'ClassAttributeSettings', 'DefaultCategory', 'content.ini' )}

{foreach $content_attributes_grouped_data_map as $attribute_group => $content_attributes_grouped}
    <div class="tab">
        {foreach $content_attributes_grouped as $attribute_identifier => $attribute}
            {def $contentclass_attribute = $attribute.contentclass_attribute}
            <div class="block ezcca-edit-datatype-{$attribute.data_type_string} ezcca-edit-{$attribute_identifier}" role="group" aria-labelledby="ezcca-name-{$attribute.id}">
                <div class="edit-row">
                    {* Show view GUI if we can't edit, otherwise: show edit GUI. *}
                    {if and( eq( $attribute.can_translate, 0 ), ne( $object.initial_language_code, $attribute.language_code ) )}
                        <div class="label-edit">
                            <label class="attribute-label">
                                <span class="classattribute-name" id="ezcca-name-{$attribute.id}">{first_set( $contentclass_attribute.nameList[$content_language], $contentclass_attribute.name )|wash}</span>
                                {if $attribute.can_translate|not} <span class="nontranslatable">({'not translatable'|i18n( 'design/admin/content/edit_attribute' )})</span>{/if}:
                                {if $contentclass_attribute.description} <span class="classattribute-description">{first_set( $contentclass_attribute.descriptionList[$content_language], $contentclass_attribute.description)|wash}</span>{/if}
                            </label>
                        </div>
                        <div class="attribute-edit">
                            {if $is_translating_content}
                                <div class="attribute-block float-break">
                                    <div class="original">
                                    {attribute_view_gui attribute_base=$attribute_base attribute=$attribute view_parameters=$view_parameters}
                                    <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
                                    </div>
                                </div>
                            {else}
                                {attribute_view_gui attribute_base=$attribute_base attribute=$attribute view_parameters=$view_parameters}
                                <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
                            {/if}
                        </div>
                    {else}
                        {if $is_translating_content}
                            <div class="label-edit">
                                <label class="attribute-label{if $attribute.has_validation_error} message-error{/if}"{if $attribute.display_info.edit.grouped_input|not} for="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}"{/if}>
                                    <span class="classattribute-name" id="ezcca-name-{$attribute.id}">{first_set( $contentclass_attribute.nameList[$content_language], $contentclass_attribute.name )|wash}</span>
                                    {if $attribute.is_required} <span class="required">*</span>{/if}
                                    {if $attribute.is_information_collector} <span class="collector">({'information collector'|i18n( 'design/admin/content/edit_attribute' )})</span>{/if}:
                                    {if $contentclass_attribute.description} <span class="classattribute-description">{first_set( $contentclass_attribute.descriptionList[$content_language], $contentclass_attribute.description)|wash}</span>{/if}
                                </label>
                            </div>
                            <div class="attribute-edit">
                                <div class="attribute-block float-break">
                                    <div class="original"{include uri='design:parts/exp_content_direction.tpl' exp_locale_code=$from_content_attributes_grouped_data_map[$attribute_group][$attribute_identifier].language_code exp_lang_always=true()}>
                                    {attribute_view_gui attribute_base=$attribute_base attribute=$from_content_attributes_grouped_data_map[$attribute_group][$attribute_identifier] view_parameters=$view_parameters}
                                    </div>
                                    <div class="translation"{include uri='design:parts/exp_content_direction.tpl' exp_locale_code=$attribute.language_code exp_lang_always=true()}>
                                    {if $attribute.display_info.edit.grouped_input}
                                        <fieldset class="attribute-fieldset">
                                        {attribute_edit_gui attribute_base=$attribute_base attribute=$attribute view_parameters=$view_parameters}
                                        <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
                                        </fieldset>
                                    {else}
                                        {attribute_edit_gui attribute_base=$attribute_base attribute=$attribute view_parameters=$view_parameters}
                                        <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
                                    {/if}
                                    </div>
                                </div>
                            </div>
                        {else}
                            {if $attribute.display_info.edit.grouped_input}
                                <div class="label-edit">
                                    <label class="attribute-label {if $attribute.has_validation_error} message-error{/if}">
                                        <span class="classattribute-name" id="ezcca-name-{$attribute.id}">{first_set( $contentclass_attribute.nameList[$content_language], $contentclass_attribute.name )|wash}</span>
                                        {if $attribute.is_required} <span class="required">*</span>{/if}
                                        {if $attribute.is_information_collector} <span class="collector">({'information collector'|i18n( 'design/admin/content/edit_attribute' )})</span>{/if}
                                        {if $contentclass_attribute.description} <span class="classattribute-description">{first_set( $contentclass_attribute.descriptionList[$content_language], $contentclass_attribute.description)|wash}</span>{/if}
                                    </label>
                                </div>
                                <div class="attribute-edit">
                                    <div class="attribute-block float-break">
                                        {set-block variable=exp_text_attrs}{include uri='design:parts/exp_content_direction.tpl' exp_locale_code=$attribute.language_code}{/set-block}{if $exp_text_attrs|ne( '' )}<div class="exp-content-text"{$exp_text_attrs}>{/if}
                                        {attribute_edit_gui attribute_base=$attribute_base attribute=$attribute view_parameters=$view_parameters}
                                        {if $exp_text_attrs|ne( '' )}</div>{/if}{undef $exp_text_attrs}
                                        <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
                                    </div>
                                </div>
                            {else}
                                <div class="label-edit">
                                    <label class="attribute-label{if $attribute.has_validation_error} message-error{/if}" for="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}">
                                        <span class="classattribute-name" id="ezcca-name-{$attribute.id}">{first_set( $contentclass_attribute.nameList[$content_language], $contentclass_attribute.name )|wash}</span>
                                        {if $attribute.is_required} <span class="required">*</span>{/if}
                                        {if $attribute.is_information_collector} <span class="collector">({'information collector'|i18n( 'design/admin/content/edit_attribute' )})</span>{/if}
                                        {if $contentclass_attribute.description} <span class="classattribute-description">{first_set( $contentclass_attribute.descriptionList[$content_language], $contentclass_attribute.description)|wash}</span>{/if}
                                    </label>
                                </div>
                                <div class="attribute-edit">
                                    <div class="attribute-block float-break">
                                        {set-block variable=exp_text_attrs}{include uri='design:parts/exp_content_direction.tpl' exp_locale_code=$attribute.language_code}{/set-block}{if $exp_text_attrs|ne( '' )}<div class="exp-content-text"{$exp_text_attrs}>{/if}
                                        {attribute_edit_gui attribute_base=$attribute_base attribute=$attribute view_parameters=$view_parameters}
                                        {if $exp_text_attrs|ne( '' )}</div>{/if}{undef $exp_text_attrs}
                                        <input type="hidden" name="ContentObjectAttribute_id[]" value="{$attribute.id}" />
                                    </div>
                                </div>
                            {/if}
                        {/if}
                    {/if}
                </div>
            </div>
            {undef $contentclass_attribute}
        {/foreach}
    </div>
{/foreach}
{run-once}
{* if is_set( $content_attributes_grouped_data_map[1] ) *}
{ezscript( array( 'exp_adminui_content_edit_attribute.js' ) )}
{* /if *}
{/run-once}
{/default}
