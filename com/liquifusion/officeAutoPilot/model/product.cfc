<cfcomponent extends="base">


	<cfset variables.instance.name = "product" />


	<cffunction name="init">
		<cfargument name="appId" required="true" type="string" />
		<cfargument name="key" required="true" type="string" />
		<cfargument name="properties" required="false" default="#StructNew()#" />
		<cfargument name="$persisted" required="false" default="false" />
		<cfscript>
			// init base.cfc to store our settings
			return super.init(url="http://moon-ray.com/api/pdata.php", appId=arguments.appId, key=arguments.key, properties=arguments.properties, $persisted=arguments.$persisted);
		</cfscript>
	</cffunction>


</cfcomponent>