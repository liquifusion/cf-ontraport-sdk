<cffunction name="scopeLockRead" output="false" returnType="any">
   <cfargument name="scope" type="string" required="true">
   <cfargument name="key" type="string" required="true">
   <cfargument name="timeout" type="numeric" required="false" default="30">
   <cfset var ptr = "">
   
   <cflock scope="#arguments.scope#" type="readOnly" timeout="#arguments.timeout#">
      <cfset ptr = structGet(arguments.scope)>
      <cfreturn duplicate(ptr[arguments.key])>
   </cflock>
</cffunction>

<cffunction name="scopeLockWrite" output="false" returnType="void">
   <cfargument name="scope" type="string" required="true">
   <cfargument name="key" type="string" required="true">
   <cfargument name="value" type="any" required="true">
   <cfargument name="timeout" type="numeric" required="false" default="30">
   <cfset var ptr = "">
   
   <cflock scope="#arguments.scope#" type="exclusive" timeout="#arguments.timeout#">
      <cfset ptr = structGet(arguments.scope)>
      <cfset ptr[arguments.key] = arguments.value>
   </cflock>
</cffunction>