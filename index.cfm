<CFINCLUDE TEMPLATE="template/_header.cfm"/>

<cfif StructKeyExists(URL, 'flash')>
    <strong>
    <cfif URL.flash EQ "login">
        You have logged in!
    </cfif>
    <cfif URL.flash EQ "logout">
        You have logged out!
    </cfif>
    <cfif URL.flash EQ "register">
        Registration successful!
    </cfif>
    </strong><br/><br/>
</cfif>

Welcome to minimalsville!