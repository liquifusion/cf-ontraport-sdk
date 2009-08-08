<cffunction name="$image" returntype="struct" access="package" output="false">
	<cfset var returnValue = {}>
	<cfset arguments.structName = "returnValue">
	<cfimage attributeCollection="#arguments#">
	<cfreturn returnValue>
</cffunction>

<cffunction name="$mail" returntype="void" access="package" output="false">
	<cfset var loc = {}>
	<cfset loc.content = arguments.body>
	<cfset StructDelete(arguments, "body")>
	<cfmail attributeCollection="#arguments#"><cfif ArrayLen(loc.content) GT 1><cfmailpart type="text">#Trim(loc.content[1])#</cfmailpart><cfmailpart type="html">#Trim(loc.content[2])#</cfmailpart><cfelse>#Trim(loc.content[1])#</cfif></cfmail>
</cffunction>

<cffunction name="$zip" returntype="any" access="package" output="false">
	<cfzip attributeCollection="#arguments#">
	</cfzip>
</cffunction>

<cffunction name="$content" returntype="any" access="package" output="false">
	<cfcontent attributeCollection="#arguments#">
</cffunction>

<cffunction name="$header" returntype="void" access="package" output="false">
	<cfheader attributeCollection="#arguments#">
</cffunction>

<cffunction name="$abort" returntype="void" access="package" output="false">
	<cfabort attributeCollection="#arguments#">
</cffunction>

<cffunction name="$include" returntype="void" access="package" output="false">
	<cfargument name="template" type="string" required="true">
	<cfset var loc = {}>
	<cfinclude template="../../#LCase(arguments.template)#">
</cffunction>

<cffunction name="$includeAndReturnOutput" returntype="string" access="package" output="false">
	<cfargument name="$template" type="string" required="true">
	<cfset var loc = {}>
	<cfif StructKeyExists(arguments, "$type") AND arguments.$type IS "partial">
		<!--- make it so the developer can reference passed in arguments in the loc scope if they prefer --->
		<cfset loc = arguments>
	</cfif>
	<!--- we prefix returnValue with "wheels" here to make sure the variable does not get overwritten in the included template --->
	<cfsavecontent variable="loc.wheelsReturnValue"><cfoutput><cfinclude template="../../#LCase(arguments.$template)#"></cfoutput></cfsavecontent>
	<cfreturn loc.wheelsReturnValue>
</cffunction>

<cffunction name="$directory" returntype="any" access="package" output="false">
	<cfset var returnValue = "">
	<cfset arguments.name = "returnValue">
	<cfdirectory attributeCollection="#arguments#">
	<cfreturn returnValue>
</cffunction>

<cffunction name="$file" returntype="any" access="package" output="false">
	<cfset var returnValue = "">
	<cfset arguments.variable = "returnValue">
	<cffile attributeCollection="#arguments#">
	<cfreturn returnValue>
</cffunction>

<cffunction name="$throw" returntype="void" access="package" output="false">
	<cfthrow attributeCollection="#arguments#">
</cffunction>

<cffunction name="$invoke" returntype="any" access="package" output="false">
	<cfset var loc = {}>
	<cfset arguments.returnVariable = "loc.returnValue">
	<cfif StructKeyExists(arguments, "componentReference")>
		<cfset arguments.component = arguments.componentReference>
	</cfif>
	<cfset StructDelete(arguments, "componentReference")>
	<cfinvoke attributeCollection="#arguments#">
	<cfif StructKeyExists(loc, "returnValue")>
		<cfreturn loc.returnValue>
	</cfif>
</cffunction>

<cffunction name="$location" returntype="void" access="package" output="false">
	<cflocation attributeCollection="#arguments#">
</cffunction>
	
<cffunction name="$dump" access="package">
	<cfargument name="var" required="true" type="any" />
	<cfargument name="abort" required="false" default="true" />
	<cfdump var="#arguments.var#" />
	<cfif arguments.abort>
		<cfabort />
	</cfif>
</cffunction>