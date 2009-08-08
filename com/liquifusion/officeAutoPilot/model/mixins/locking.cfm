<cffunction name="$namedLockRead" output="false" returnType="any" access="package">
	<cfargument name="name" type="string" required="true" />
	<cfargument name="objectName" type="string" required="true" />
	<cfargument name="key" type="string" required="true" />
	<cfargument name="timeout" type="numeric" required="false" default="30" />
	
	<cfset var loc = StructNew() />
   
	<cflock name="#arguments.name#" type="readOnly" timeout="#arguments.timeout#">
		<cfset loc.object = Evaluate(arguments.objectName) />
		<cfreturn Duplicate(loc.object[arguments.key]) />
	</cflock>
</cffunction>

<cffunction name="$namedLockWrite" output="false" returnType="void" access="package">
	<cfargument name="name" type="string" required="true" />
	<cfargument name="objectName" type="string" required="true" />
	<cfargument name="key" type="string" required="true" />
	<cfargument name="value" type="any" required="true" />
	<cfargument name="timeout" type="numeric" required="false" default="30" />
	
	<cfset var loc = StructNew() />
	
	<cflock name="#arguments.name#" type="exclusive" timeout="#arguments.timeout#">
		<cfset loc.object = Evaluate(arguments.objectName) />
		<cfset loc.object[arguments.key] = arguments.value />
	</cflock>
</cffunction>