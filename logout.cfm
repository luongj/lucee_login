<CFINCLUDE TEMPLATE="template/_header.cfm"/>

<cfset structDelete(SESSION, 'user', false)/>
<cfset SESSION.user_id = 0/>

<cflocation url="index.cfm?flash=logout" addtoken="false"/>