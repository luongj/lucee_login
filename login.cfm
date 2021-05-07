<CFINCLUDE TEMPLATE="template/_header.cfm"/>

<cfif StructCount(FORM)>
    <cfset VARIABLES.struct_loginResult = Application.db_user.login(email = FORM.email, password=FORM.password)/>

    <cfif VARIABLES.struct_loginResult.success>
        <!--- write to SESSION scope --->
        <cfset SESSION.user     = VARIABLES.struct_loginResult.user/>   <!--- object --->
        <cfset SESSION.user_id  = VARIABLES.struct_loginResult.user.id/><!--- integer --->

        <!--- relocate user to homepage --->
        <cflocation url="index.cfm?flash=login" addtoken="false"/>
    </cfif>

    <!--- bad username/password --->
    <cfif NOT VARIABLES.struct_loginResult.success>
        That didn't work. Try again!
    </cfif>
</cfif>

<form method="post" action="login.cfm">
    <strong>login</strong>
    <br/>Email      <input type="text" name="email"/>
    <br/>Password   <input type="password" name="password"/>
    <br/><input type="submit" name="login"/>
</form>