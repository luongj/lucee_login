<cfcomponent>
    <!--- placeholder for query --->
    <cfset VARIABLES.query_user_db      = QueryNew("")/>

    <cffunction name="init">
        <cfset LOCAL.columnName         = "id,name_last,name_first,email,password,is_admin"/>
        <cfset LOCAL.columnType         = "Integer,Varchar,Varchar,Varchar,Varchar,Bit"/>
        <cfset LOCAL.query_user_db      = queryNew( LOCAL.columnName, LOCAL.columnType )/>

        <cfset VARIABLES.query_user_db  = LOCAL.query_user_db/>

        <!--- create superuser --->
        <cfset insert_user
        (
            name_last   = "foo",
            name_first  = "bar",
            email       = "foo@bar",
            password    = "foo@bar",
            is_admin    = 1
        )/>

        <cfset insert_user
        (
            name_last   = "asfasdfasd",
            name_first  = "basdfasdfar",
            email       = "asdfasfasdf@bar",
            password    = "asdfasfsadf@bar",
            is_admin    = 0
        )/>

        <cfreturn/>
    </cffunction>

<!--- 
    "DATABASE CALLS" 
--->
    <!--- get maximum user_id --->
    <cffunction name="get_max_user_id">
        <CFQUERY NAME="LOCAL.query_user_id" DBTYPE="query">
            SELECT  MAX(id) AS max_id
            FROM    VARIABLES.query_user_db
        </CFQUERY>

        <!--- return maximum user_id; 0 if no entries --->
        <CFIF NOT isNumeric(LOCAL.query_user_id.max_id)>
            <CFRETURN 0/>
        <CFELSE>
            <CFRETURN LOCAL.query_user_id.max_id/>
        </CFIF>
    </cffunction>

    <cffunction name="insert_user">
        <cfargument name="name_last"/>
        <cfargument name="name_first"/>
        <cfargument name="email"/>
        <cfargument name="password"/>
        <cfargument name="is_admin" default=0/>

        <cftransaction>
            <!--- create id value for new entry --->
            <cfset LOCAL.new_user_id = get_max_user_id() + 1/>

            <!--- add a single row --->
            <cfset queryAddRow(VARIABLES.query_user_db, 1)/>

            <!--- fill in the row --->
            <cfset querySetCell(VARIABLES.query_user_db, "id",          LOCAL.new_user_id)/>
            <cfset querySetCell(VARIABLES.query_user_db, "name_last",   ARGUMENTS.name_last)/>
            <cfset querySetCell(VARIABLES.query_user_db, "name_first",  ARGUMENTS.name_first)/>
            <cfset querySetCell(VARIABLES.query_user_db, "email",       ARGUMENTS.email)/>
            <cfset querySetCell(VARIABLES.query_user_db, "password",    ARGUMENTS.password)/>
            <cfset querySetCell(VARIABLES.query_user_db, "is_admin",    ARGUMENTS.is_admin)/>
        </cftransaction>

        <cfreturn LOCAL.new_user_id/>
    </cffunction>

    <!--- favor selection by `id` --->
    <cffunction name="get_user">
        <cfargument name="id" default=0/>
        <cfargument name="email" default=""/>

        <!--- SELECT * for simplicity; bad form to move password --->
        <CFQUERY NAME="LOCAL.query_user_id" DBTYPE="query">
            SELECT  *
            FROM    VARIABLES.query_user_db
            <cfif ARGUMENTS.id NEQ 0>
            WHERE   id = <cfqueryparam value="#ARGUMENTS.id#">
            <cfelseif LEN(TRIM(ARGUMENTS.email))>
            WHERE   email = <cfqueryparam value="#ARGUMENTS.email#">
            <cfelse>
            <!--- fail --->
            WHERE   1=0
            </cfif>
        </CFQUERY>

        <cfreturn LOCAL.query_user_id/>
    </cffunction>

    <cffunction name="admin_get_user_all">
        <CFQUERY NAME="LOCAL.query_user_all" DBTYPE="query">
            SELECT  id, name_last, name_first, email, is_admin
            FROM    VARIABLES.query_user_db
            ORDER BY id ASC
        </CFQUERY>

        <cfreturn LOCAL.query_user_all/>
    </cffunction>

<!--- 
    FUNCTIONS 
--->
    <cffunction name="login">
        <cfargument name="email"/>
        <cfargument name="password"/>

        <!--- instantiate return structure and assume failure --->
        <cfset LOCAL.struct_return['success']   =   0/>

        <cfset LOCAL.query_user_id = get_user(email = ARGUMENTS.email)/>

        <!--- if successful, write to an object, attach object to return object --->
        <CFIF (LOCAL.query_user_id.recordCount EQ 1) AND (LOCAL.query_user_id.password EQ ARGUMENTS.password)>
            <CFSET LOCAL.user   = 
            {
                id          = LOCAL.query_user_id.id,
                name_last   = LOCAL.query_user_id.name_last,
                name_first  = LOCAL.query_user_id.name_first,
                email       = LOCAL.query_user_id.email,
                is_admin    = LOCAL.query_user_id.is_admin
            }/>
            <CFSET LOCAL.struct_return.user = LOCAL.user/>
            <CFSET LOCAL.struct_return.success = 1/>
        </CFIF>

        <cfreturn LOCAL.struct_return/>
    </cffunction>

    <cffunction name="register">
        <cfargument name="email">
        <cfargument name="name_last">
        <cfargument name="name_first">
        <cfargument name="password">

        <!--- instantiate return structure and assume failure --->
        <cfset LOCAL.struct_return['success']   =   0/>

        <!--- check to make sure a user email doesn't already exist --->
        <cfset LOCAL.query_user_id = get_user(email = ARGUMENTS.email)/>

        <!--- user already exists --->
        <CFIF (LOCAL.query_user_id.recordCount EQ 1)>
            <CFSET LOCAL.struct_return['message']   = "exist"/>
        <CFELSE>
            <!--- add user --->
            <CFSET insert_user
            (
                name_last   = ARGUMENTS.name_last,
                name_first  = ARGUMENTS.name_first,
                email       = ARGUMENTS.email,
                password    = ARGUMENTS.password,
                is_admin    = 0
            )/>

            <!--- log user in; assume success --->
            <CFSET LOCAL.struct_return_login = login( email = ARGUMENTS.email, password = ARGUMENTS.password )/>

            <!--- change return object --->
            <CFSET LOCAL.struct_return['success']   = LOCAL.struct_return_login.success/>
            <CFSET LOCAL.struct_return['user']      = Duplicate(LOCAL.struct_return_login.user)/>
        </CFIF>        

        <cfreturn LOCAL.struct_return/>
    </cffunction>
</cfcomponent>