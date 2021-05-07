<CFINCLUDE TEMPLATE="template/_header.cfm"/>

<cfif StructKeyExists(SESSION, 'user') AND SESSION.user.is_admin>
    <cfset VARIABLES.query_user_all = Application.db_user.admin_get_user_all()/>

    <table border="1">
    <tr>
        <td>id</td><td>name_last</td><td>name_first</td><td>email</td><td>is_admin</td>
    </tr>
    <cfoutput query="VARIABLES.query_user_all">
        <tr>
            <td><a href="profile.cfm?id=#VARIABLES.query_user_all.id#">#VARIABLES.query_user_all.id#</a></td><td>#VARIABLES.query_user_all.name_last#</td><td>#VARIABLES.query_user_all.name_first#</td><td>#VARIABLES.query_user_all.email#</td><td>#VARIABLES.query_user_all.is_admin#</td>
        </tr>    
    </cfoutput>
    </table>
<cfelse>
Not authorized!
</cfif>