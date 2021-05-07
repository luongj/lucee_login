<CFINCLUDE TEMPLATE="template/_header.cfm"/>

<cfif StructCount(FORM)>
    <cfif FORM.password_1 NEQ FORM.password_2>
        <strong>Passwords don't match!</strong><br/><br/>
        <cfset VARIABLES.struct_registerResult['success'] = 0/>
        <cfset VARIABLES.struct_registerResult['message'] = "password"/>
    </cfif>

    <cfif NOT structKeyExists(VARIABLES, 'struct_registerResult')>
        <cfset VARIABLES.struct_registerResult = Application.db_user.register
        (
            email       = FORM.email, 
            name_last   = FORM.name_last, 
            name_first  = FORM.name_first, 
            password    = FORM.password_1
        )/>
    </cfif>

    <cfif VARIABLES.struct_registerResult.success EQ 0 AND VARIABLES.struct_registerResult.message EQ "exist">
        <strong>Email already registered, go <a href="login.cfm">login</a> or use a different email address.</strong><br/><br/>
    </cfif>

    <cfif VARIABLES.struct_registerResult.success>
        <!--- write to SESSION scope --->
        <cfset SESSION.user     = VARIABLES.struct_registerResult.user/>   <!--- object --->
        <cfset SESSION.user_id  = VARIABLES.struct_registerResult.user.id/><!--- integer --->

        <!--- relocate user to homepage --->
        <cflocation url="index.cfm?flash=register" addtoken="false"/>
    </cfif>
</cfif>

<form method="post" action="register.cfm">
<strong>register</strong>
<br/>email <input type="text" name="email">
<br/>first name <input type="text" name="name_first">
<br/>last name <input type="text" name="name_last">
<br/>password <input type="password" name="password_1">
<br/>(verify) <input type="password" name="password_2">
<br/><input type="submit" name="register">
</form>