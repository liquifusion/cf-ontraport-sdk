<cfcomponent extends="base">

	<cfset variables.name = "contact" />

	<cffunction name="init">
		<cfargument name="appId" required="true" type="string" />
		<cfargument name="key" required="true" type="string" />
		<cfscript>
			// init base.cfc to store our settings
			super.init(url="http://api.moon-ray.com/cdata.php", appId=arguments.appId, key=arguments.key);
			
			return this;
		</cfscript>
	</cffunction>
	
	
	
	<cffunction name="getName">
		<cfreturn variables.name />
	</cffunction>
	
	
	<cffunction name="properties" access="public" returntype="array" hint="returns an array of properties for the contact object.">
		<cfscript>
			var loc = StructNew();
			
			// check to see if in the application scope, otherwise get from service
			if ($hasPropertyData(getName()))
				return $getPropertyData(getName()));
			
			loc.data = ArrayNew(1);
			
			loc.response = this.$process(reqType="key");
			
			loc.xml = loc.response.getXmlContent();
			
			// create our response data
			loc.groupArray = XmlSearch(loc.xml, "//result/contact/Group_Tag");
			
			loc.iEnd = ArrayLen(loc.groupArray);
			
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i++) {
			
				loc.group = loc.groupArray[loc.i];
				
				loc.fieldArray = loc.group.XmlChildren;
				
				loc.jEnd = ArrayLen(loc.fieldArray);
				
				for (loc.j = 1; loc.j lte loc.jEnd; loc.j++) {
				
					loc.field = loc.fieldArray[loc.j];
					
					loc.fieldStuct = StructNew();
					
					loc.fieldStruct.name = LCase(REReplace(loc.field.XmlAttributes.name, "[^a-zA-Z0-9\-]+", "", "all"));
					loc.fieldStruct.label = loc.field.XmlAttributes.name;
					loc.fieldStruct.type = loc.field.XmlAttributes.type;
					loc.fieldStruct.group = loc.group.XmlAttributes.name;
			
					
					ArrayAppend(loc.data, Duplicate(loc.fieldStruct));
				}
			}
			
			// create the id field
			loc.fieldStuct = StructNew();
			
			loc.fieldStruct.name = "id";
			loc.fieldStruct.label = "Contact Id";
			loc.fieldStruct.type = "primaryKey";
			loc.fieldStruct.group = "";
			
			ArrayPrepend(loc.data, Duplicate(loc.fieldStruct));
			
			$setPropertyData("contact", loc.data);
			
			return loc.data;
		</cfscript>
	</cffunction>



</cfcomponent>