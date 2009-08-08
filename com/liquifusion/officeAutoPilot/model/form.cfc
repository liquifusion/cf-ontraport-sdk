<cfcomponent extends="base">


	<cfset variables.instance.name = "form" />


	<cffunction name="init">
		<cfargument name="appId" required="true" type="string" />
		<cfargument name="key" required="true" type="string" />
		<cfargument name="properties" required="false" default="" />
		<cfscript>
			// init base.cfc to store our settings
			return super.init(url="http://api.moon-ray.com/fdata.php", appId=arguments.appId, key=arguments.key, properties=arguments.properties);
		</cfscript>
	</cffunction>


</cfcomponent>