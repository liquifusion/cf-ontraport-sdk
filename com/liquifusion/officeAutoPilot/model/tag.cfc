<cfcomponent extends="base">

	
	<cfset variables.instance.name = "tag" />


	<cffunction name="init">
		<cfargument name="appId" required="true" type="string" />
		<cfargument name="key" required="true" type="string" />
		<cfargument name="properties" required="false" default="#StructNew()#" />
		<cfscript>
			// init base.cfc to store our settings
			return super.init(url="https://moon-ray.com/api/cdata.php", appId=arguments.appId, key=arguments.key, properties=arguments.properties, $persisted=false);
		</cfscript>
	</cffunction>
	
	
	<cffunction name="properties" access="public" returntype="array" hint="returns an array of properties for the contact object.">
		<cfscript>
			var loc = StructNew();
			
			// check to see if in the application scope, otherwise get from service
			if ($hasPropertyData(getName()))
				return $getPropertyData(getName());
				
			loc.data = ArrayNew(1);
			
			loc.struct = StructNew();
			
			loc.struct.name = "id";
			loc.struct.label = "Id";
			loc.struct.type = "primarykey";
			loc.struct.group = "";
			
			ArrayAppend(loc.data, Duplicate(loc.struct));
			
			loc.struct.name = "stringid";
			loc.struct.label = "String Id";
			loc.struct.type = "string";
			loc.struct.group = "";
			
			ArrayAppend(loc.data, Duplicate(loc.struct));
			
			loc.struct.name = "groupname";
			loc.struct.label = "Group Name";
			loc.struct.type = "string";
			loc.struct.group = "";
			
			ArrayAppend(loc.data, Duplicate(loc.struct));
			
			$setPropertyData(getName(), Duplicate(loc.data));
	
			return loc.data;
		</cfscript>
	</cffunction>
	
	
	<cffunction name="create">
		<cfthrow type="officeautopilot.MethodNotImplemented" message="create() cannot be implemented for this object." />
	</cffunction>
	
	
	<cffunction name="update">
		<cfthrow type="officeautopilot.MethodNotImplemented" message="update() cannot be implemented for this object." />
	</cffunction>
	
	
	<cffunction name="save">
		<cfthrow type="officeautopilot.MethodNotImplemented" message="save() cannot be implemented for this object." />
	</cffunction>
	
	
	<cffunction name="search">
		<cfthrow type="officeautopilot.MethodNotImplemented" message="search() cannot be implemented for this object." />
	</cffunction>
	
	
	<cffunction name="findAllById">
		<cfthrow type="officeautopilot.MethodNotImplemented" message="findAllById() cannot be implemented for this object." />
	</cffunction>
	
	
	<cffunction name="findByKey">
		<cfthrow type="officeautopilot.MethodNotImplemented" message="findByKey() cannot be implemented for this object." />
	</cffunction>
	
	
	<cffunction name="findAll">
		<cfargument name="returnAs" required="false" default="structs" /><!--- can also be objects and query --->
		<cfscript>
			var loc = StructNew();
			
			loc.response = this.$process(reqType="fetch_tag");
			loc.xml = loc.response.getXmlContent();
			loc.dataArray = XmlSearch(loc.xml, "//result/tags");
			loc.dataList = loc.dataArray[1].XmlText;
			loc.iEnd = ListLen(loc.dataList, "*/*");
			
			if (arguments.returnAs eq "query") {
			
				loc.results = QueryNew("id,stringid,groupname");
				loc.dump = QueryAddRow(loc.results, loc.iEnd);
				
				for (loc.i = 1; loc.i lte loc.iEnd; loc.i++) {
				
					QuerySetCell(loc.results, "id", loc.i, loc.i);
					QuerySetCell(loc.results, "stringid", $normalizeFieldName(ListGetAt(loc.dataList, loc.i, "*/*")), loc.i);
					QuerySetCell(loc.results, "groupname", ListGetAt(loc.dataList, loc.i, "*/*"), loc.i);
				}
			
			} else {
			
				loc.results = ArrayNew(1);
				
				for (loc.i = 1; loc.i lte loc.iEnd; loc.i++) {
					
					loc.struct = StructNew();
					loc.struct.id = loc.i;
					loc.struct.stringid = $normalizeFieldName(ListGetAt(loc.dataList, loc.i, "*/*"));
					loc.struct.name = ListGetAt(loc.dataList, loc.i, "*/*");
					
					if (arguments.returnAs eq "objects") { 
					
						ArrayAppend(loc.results, CreateObject("component", getName()).init(appId=getAppId(), key=getKey(), properties=Duplicate(loc.struct)));
					
					} else {
					
						ArrayAppend(loc.results, Duplicate(loc.struct));
					}
				}
			}
			
			return loc.results;
		</cfscript>
	</cffunction>



</cfcomponent>
