<form id="createpolicyform" action={concat( $module.functions.edit.uri, '/', $role.id, '/' )|ezurl} method="post" >

    <div class="context-block">

        {* DESIGN: Header START *}<div class="box-header">

            <h1 class="context-title">{'Create a new policy for the <%role_name> role'|i18n( 'design/admin/role/createpolicystep1',, hash( '%role_name', $role.name ) )|wash}</h1>

            {* DESIGN: Mainline *}<div class="header-mainline"></div>

            {* DESIGN: Header END *}
        </div>

        {* DESIGN: Content START *}
        <div class="box-content panel">

            <div class="context-attributes">
                <div class="block">
                    <p>{'Welcome to the policy wizard. This three-step wizard will help you create a new policy that will be added to the role that is currently being edited. The wizard can be aborted at any stage by using the "Cancel" button.'|i18n( 'design/admin/role/createpolicystep1' )}</p>
                    <hr />

                    <h2>{'Step one: select module'|i18n( 'design/admin/role/createpolicystep1' )}</h2>
                    <p>
                        {'Instructions'|i18n( 'design/admin/role/createpolicystep1' )}:
                    </p>
                    <ol>
                        <li>{'Use the drop-down menu to select the module that you want to grant access to.'|i18n( 'design/admin/role/createpolicystep1' )}</li>
                        <li>{'Click one of the "Grant.." buttons (explained below) in order to go to the next step.'|i18n( 'design/admin/role/createpolicystep1' )}</li>
                    </ol>
                    <p>
                        {'The "Grant access to all functions" button will create a policy that grants unlimited access to all functions of the selected module. If you wish to limit the access method to a specific function, use the "Grant access to a function" button. Please note that function limitation is only supported by some modules (the next step will reveal if it works or not).'|i18n( 'design/admin/role/createpolicystep1' )}
                    </p>
                </div>

                <div class="block">
                    <div class="form-inline">
                        <label for="ezrole-createpolizy-module">{'Module'|i18n( 'design/admin/role/createpolicystep1' )}:</label>
                        {def $exp_module_functions = hash() $exp_functions = array()}
                        {foreach $module_list as $module}
                            {set $exp_functions = array()}
                            {foreach $module.available_functions as $fn => $lim}{set $exp_functions = $exp_functions|append( $fn )}{/foreach}
                            {set $exp_module_functions = $exp_module_functions|merge( hash( $module.name, $exp_functions ) )}
                        {/foreach}
                        <select class="form-control" id="ezrole-createpolizy-module" name=CurrentModule data-expui-functions="{json_encode( $exp_module_functions )|wash}" data-expui-every="{'Every function'|i18n( 'design/admin/role/createpolicystep1' )|wash}">
                        {undef $exp_module_functions $exp_functions}
                            <option value="*">{'Every module'|i18n( 'design/admin/role/createpolicystep1' )}</option>
                            {section var=Modules loop=$modules }
                                <option value="{$Modules.item}">{$Modules.item}</option>
                            {/section}
                        </select>
                    </div>
                </div>

                <div class="block">
                    <div class="form-inline">
                    	<label for="ezrole-createpolizy-function">{'Function'|i18n( 'design/admin/role/createpolicystep2' )}:</label>
                    	<select class="form-control" id="ezrole-createpolizy-function" name="ModuleFunction" disabled="disabled">
                    	    <option value="*">{'Every function'|i18n( 'design/admin/role/createpolicystep1' )}</option>
                    	</select>
                    </div>
                </div>

                <div class="block">
                    <input class="button" type="submit" name="AddModule" value="{'Grant access to all functions'|i18n( 'design/admin/role/createpolicystep1' )}" />
                    <input class="button button-module" type="submit" name="CustomFunction" value="{'Grant access to one function'|i18n( 'design/admin/role/createpolicystep1' )}" />

                    <input class="button-disabled button-function" disabled="disabled" type="submit" name="AddFunction" value="{'Grant full access'|i18n( 'design/admin/role/createpolicystep2' )}"  />
                    <input class="button-disabled button-function" disabled="disabled" type="submit" name="Limitation" value="{'Grant limited access'|i18n( 'design/admin/role/createpolicystep2' )}" />
                </div>


                {* DESIGN: Content END *}

                <div class="controlbar">
                    <input class="button-disabled" type="submit" name="_Disabled" value="{'OK'|i18n( 'design/admin/role/createpolicystep1' )}" disabled="disabled" />
                    <input class="button" type="submit" value="{'Cancel'|i18n( 'design/admin/role/createpolicystep1' )}" />
                </div>
                {* DESIGN: Control bar END *}
            </div>
        </div>

    </div>
</form>

{ezscript( array( 'exp_adminui_role_createpolicystep1.js' ) )}
