<cfcomponent>


	<cffunction name="init">
		<cfargument name="appId" required="true" type="string" />
		<cfargument name="key" required="true" type="string" />
		<cfscript>
			variables.appId = arguments.appId;
			variables.key = arguments.key;
		
			// need to pull in Appid, Key
			return this;
		</cfscript>
	</cffunction>



	<!---
		Input:
			none
		returns:
			pulls back all contact fields organized by groups
	--->
	<cffunction name="key">
		<cfscript>
		
		</cfscript>
	</cffunction>



	<!---
		input:
			xml search document in the format of
				<search>
					<equation>
						<field>fieldName</field>
						<op>
							e = equal,
							n = not equal,
							s = starts with,
							c = like, 
							k = not like, 
							l = less than, 
							g = greater than, 
							m = less than or equal to,
							h = greater than or equal to
						</op>
						<value></value>
					</equation>
				</search>
		returns:
			list of contacts that match your search or if none are found 0
	--->
	<cffunction name="search">
		<cfscript>
		
		</cfscript>
	</cffunction>
	
	
	
	<!---
		input:
			for contacts and products, takes an list of ids
			for forms, takes nothing or a single id
		returns:
			data associated with service being called
	--->
	<cffunction name="fetch">
		<cfscript>
		
		</cfscript>
	</cffunction>
	
	
	<!---
		input:

</cfcomponent>