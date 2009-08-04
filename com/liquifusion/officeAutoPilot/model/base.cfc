<cfcomponent>
	
	<cffunction name="init" access="public">
		<cfargument name="url" required="true" type="string" />
		<cfargument name="appId" required="true" type="string" />
		<cfargument name="key" required="true" type="string" />
		<cfargument name="timeout" required="false" type="numeric" default="30" />
		<cfscript>
			variables.url = arguments.url;
			variables.timeout = arguments.timeout;
			variables.appId = arguments.appId;
			variables.key = arguments.key;
		
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="getAppId">
		<cfreturn variables.appId />
	</cffunction>
	
	<cffunction name="setAppId">
		<cfargument name="appId" required="true" type="string" />
		<cfscript>
			variables.appId = arguments.appId;
		</cfscript>
	</cffunction>
	
	<cffunction name="getTimeout">
		<cfreturn variables.timeout />
	</cffunction>
	
	<cffunction name="setTimeout">
		<cfargument name="timeout" required="true" type="string" />
		<cfscript>
			variables.timeout = arguments.timeout;
		</cfscript>
	</cffunction>
	
	<cffunction name="getKey">
		<cfreturn variables.key />
	</cffunction>
	
	<cffunction name="setKey">
		<cfargument name="key" required="true" type="string" />
		<cfscript>
			variables.key = arguments.key;
		</cfscript>
	</cffunction>
	
	<cffunction name="$process" access="package">
		<cfargument name="reqType" required="true" type="string" />
		<cfargument name="data" required="false" type="string" default="" />
		<cfargument name="f_add" required="false" type="boolean" default="false" />
		<cfargument name="return_id" required="false" type="boolean" default="false" />
		
		<cfset var loc = StructNew() />
		
		<cfhttp url="#variables.url#" timeout="#variables.timeout#" method="post" result="loc.http" throwonerror="false">
			<cfhttpparam name="Appid" value="#variables.appId#" type="formfield" />
			<cfhttpparam name="Key" value="#variables.key#" type="formfield" />
			<cfhttpparam name="reqType" value="#arguments.reqType#" type="formfield" />
			
			<cfif Len(arguments.data)>
				<cfhttpparam name="data" value="#arguments.data#" type="formfield" />
			</cfif>
			
			<cfif arguments.f_add eq true>
				<cfhttpparam name="f_add" value="1" type="formfield" />
			</cfif>
			
			<cfif arguments.return_id eq true>
				<cfhttpparam name="return_id" value="1" type="formfield" />
			</cfif>
		</cfhttp>
		
		<cfset loc.response = CreateObject("component", "response").init(loc.http) />
		
		<cfif loc.response.hasError()>
			<cfthrow type="officeAutoPilot.messageError" message="#loc.response.getError()#" />
		</cfif>
		
		<cfreturn loc.response />
	</cffunction>
	
	<cffunction name="$verifyApplicationScopeExists" access="package">
		<cfif not StructKeyExists(application, "officeautopilot")>
			<cflock name="officeautopilot" timeout="5">
				<cfset application.officeautopilot = StructNew() />
			</cflock>
		</cfif>
	</cffunction>
	
	
	
	
	<cffunction name="$hasPropertyData">
		<cfargument name="objectName" required="true" type="string" />
		<cfscript>
			$verifyApplicationScopeExists();
			
			if (not StructKeyExists(application.officeautopilot, arguments.objectName))
				return false;
				
			if (not StructKeyExists(application.officeautopilot[arguments.objectName], "properties"))
				return false;
			
			if (not IsArray(application.officeautopilot[arguments.objectName].properties));
				return false;
				
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="$getPropertyData">
		<cfargument name="objectName" required="true" type="string" />
		
		<cfset 
		<cfscript>
			$verifyApplicationScopeExists();
			
			if (not StructKeyExists(application.officeautopilot, arguments.objectName))
				return false;
				
			if (not StructKeyExists(application.officeautopilot[arguments.objectName], "properties"))
				return false;
			
			if (not IsArray(application.officeautopilot[arguments.objectName].properties));
				return false;
				
			return true;
		</cfscript>
	</cffunction>
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	<cffunction name="$dump" access="package">
		<cfargument name="var" required="true" type="any" />
		<cfargument name="abort" required="false" default="true" />
		<cfdump var="#arguments.var#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>
	
	
</cfcomponent>