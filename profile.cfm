<CFINCLUDE TEMPLATE="template/_header.cfm"/>

<!--- attempt to call profile by id --->
<cfif structKeyExists(URL, 'id')>
    <cfif StructKeyExists(SESSION, 'user') AND SESSION.user.is_admin>
        <!--- attempt by id --->
        <cfset VARIABLES.struct_user = Application.db_user.get_user(id = URL.id)/>

        <cfif VARIABLES.struct_user.recordCount EQ 1>
            <cfset VARIABLES.render_user = 
            {
                id          = VARIABLES.struct_user.id,
                email       = VARIABLES.struct_user.email,
                name_first  = VARIABLES.struct_user.name_first,
                name_last   = VARIABLES.struct_user.name_last,
                is_admin    = VARIABLES.struct_user.is_admin
            }/>
        <cfelse>    
            User not found.
            <cfabort>
        </cfif>
    <cfelse>
        <strong>Permission denied.</strong><br/>
        <cfabort>
    </cfif>
<!--- show logged in user data from SESSION --->
<cfelse>
    <cfif StructKeyExists(SESSION, 'user')>
        <CFSET VARIABLES.render_user = Duplicate(SESSION.user)/>
    <cfelse>
        Not logged in. Go <a href="login.cfm">login</a> first.
        <cfabort>
    </cfif>
</cfif>

<!--- render user information --->
<cfoutput>
<br/>id <input type="text" value="#VARIABLES.render_user.id#" readonly>
<br/>email <input type="text" value="#VARIABLES.render_user.email#" readonly>
<br/>name_first <input type="text" value="#VARIABLES.render_user.name_first#" readonly>
<br/>name_last <input type="text" value="#VARIABLES.render_user.name_last#" readonly>
<br/>is_admin <input type="text" value="#VARIABLES.render_user.is_admin#" readonly>
</cfoutput>