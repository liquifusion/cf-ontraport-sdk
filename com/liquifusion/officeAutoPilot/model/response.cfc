<cfcomponent>

	<!---
		init the response with the response object from cfhttp
	--->
	<cffunction name="init" access="public">
		<cfargument name="response" required="true" type="struct" />
		<cfscript>
			variables.response = arguments.response;
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="hasError">
		<cfreturn (Len(variables.response.errorDetail)) />
	</cffunction>
	
	<cffunction name="getError">
		<cfreturn variables.response.errorDetail />
	</cffunction>
	
	<cffunction name="getStatusCode" access="public" returntype="string">
		<cfreturn variables.response.statusCode />
	</cffunction>
	
	<cffunction name="getResponse" access="public" returntype="struct">
		<cfreturn variables.response />
	</cffunction>
	
	<cffunction name="getCharSet" access="public" returntype="string">
		<cfreturn variables.response.charset />
	</cffunction>
	
	<cffunction name="getMimeType" access="public" returntype="string">
		<cfreturn variables.response.mimeType />
	</cffunction>
	
	<cffunction name="getResponseHeader" access="public" returntype="string">
		<cfreturn variables.response.charset />
	</cffunction>
	
	<cffunction name="getRawHeader" access="public" returntype="string">
		<cfreturn variables.response.header />
	</cffunction>
	
	<cffunction name="getHeader" access="public" returntype="struct">
		<cfreturn variables.response.responseHeader />
	</cffunction>
	
	<cffunction name="getXmlContent" access="public" returntype="xml">
		<cfreturn XmlParse(variables.response.fileContent) />
	</cffunction>
	
	<cffunction name="getStringContent" access="public" returntype="xml">
		<cfreturn variables.response.fileContent />
	</cffunction>
	
	<cffunction name="setResponseData">
		<cfargument name="data" required="true" type="any" />
		<cfset variables.response.data = arguments.data />
	</cffunction>
	
	<cffunction name="getResponseData">
		<cfreturn variables.response.data />
	</cffunction>


</cfcomponent>