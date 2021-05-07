<cfoutput>
<ul>
    <li><a href="index.cfm">home</a></li>
<CFIF SESSION.user_id EQ 0>
    <li><a href="login.cfm">login</a></li>
    <li><a href="register.cfm">register</a></li>
<CFELSE>
    <li>hello #SESSION.user.name_last# #SESSION.user.name_last# (#SESSION.user.email#) - the time is #NOW()#</li>
    <li><a href="profile.cfm">profile</a></li>
    <li><a href="logout.cfm">logout</a></li>
    <cfif StructKeyExists(SESSION, 'user') AND SESSION.user.is_admin>
    <li><a href="admin_listuser.cfm">ADMIN: all users</a></li>
    </cfif>
</CFIF>
</ul>
</cfoutput>

<hr/>