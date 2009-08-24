<cfcomponent>
	
	<cfset variables.instance = StructNew() />
	
	<!---
		init the response with the response object from cfhttp
	--->
	<cffunction name="init" access="public">
		<cfargument name="request" required="true" type="struct" />
		<cfargument name="response" required="true" type="struct" />
		<cfscript>
			variables.instance.response = arguments.response;
			variables.instance.request = arguments.request;
			

			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="hasError">
		<cfreturn (Len(variables.instance.response.errorDetail) or Find("<result>failure", variables.instance.response.fileContent)) />
	</cffunction>
	
	<cffunction name="getError">
		<cfscript>
			if (Find("<result>failure", variables.instance.response.fileContent))
				return variables.instance.response.fileContent;
			else
				return variables.instance.response.errorDetail;
		</cfscript>
	</cffunction>
	
	<cffunction name="getStatusCode" access="public" returntype="string">
		<cfreturn variables.instance.response.statusCode />
	</cffunction>
	
	<cffunction name="getResponse" access="public" returntype="struct">
		<cfreturn variables.instance.response />
	</cffunction>
	
	<cffunction name="getCharSet" access="public" returntype="string">
		<cfreturn variables.instance.response.charset />
	</cffunction>
	
	<cffunction name="getMimeType" access="public" returntype="string">
		<cfreturn variables.instance.response.mimeType />
	</cffunction>
	
	<cffunction name="getResponseHeader" access="public" returntype="string">
		<cfreturn variables.instance.response.charset />
	</cffunction>
	
	<cffunction name="getRawHeader" access="public" returntype="string">
		<cfreturn variables.instance.response.header />
	</cffunction>
	
	<cffunction name="getHeader" access="public" returntype="struct">
		<cfreturn variables.instance.response.responseHeader />
	</cffunction>
	
	<cffunction name="getXmlContent" access="public" returntype="xml">
		<!--- RERplace removes any characters before the XML starts http://www.bennadel.com/blog/1206-Content-Is-Not-Allowed-In-Prolog-ColdFusion-XML-And-The-Byte-Order-Mark-BOM-.htm --->
		<cfsetting enablecfoutputonly="false" />
		<cfreturn XmlParse(REReplace(variables.instance.response.fileContent, "^[^<]*", "", "all")) />
	</cffunction>
	
	<cffunction name="getStringContent" access="public" returntype="xml">
		<cfreturn variables.instance.response.fileContent />
	</cffunction>
	
	<cffunction name="setResponseData">
		<cfargument name="data" required="true" type="any" />
		<cfset variables.instance.response.data = arguments.data />
	</cffunction>
	
	<cffunction name="getResponseData">
		<cfreturn variables.instance.response.data />
	</cffunction>
	
	<cffunction name="getRequest" access="public" returntype="struct">
		<cfreturn variables.instance.request />
	</cffunction>
	
	<cffunction name="getMemento" access="public" returntype="struct">
		<cfreturn variables.instance />
	</cffunction>


</cfcomponent>