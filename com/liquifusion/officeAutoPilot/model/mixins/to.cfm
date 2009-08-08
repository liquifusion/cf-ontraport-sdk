<cffunction name="$queryColumnList" access="package" returntype="string">
	<cfargument name="response" required="true" type="any" />
	<cfscript>
		var loc = StructNew();
		
		loc.xml = arguments.response.getXmlContent();
		
		// create our response data
		loc.dataArray = XmlSearch(loc.xml, "//result/" & getName() & "/Group_Tag/field");
		
		loc.iEnd = ArrayLen(loc.dataArray);
		
		loc.returnList = "";
		
		for (loc.i = 1; loc.i lte loc.iEnd; loc.i++) {
		
			loc.field = loc.dataArray[loc.i];
			loc.fieldName = $normalizeFieldName(loc.field.XmlAttributes.name);
		
			if (not ListFind(loc.returnList, loc.fieldName)) {
			
				loc.returnList = loc.returnList & loc.fieldName & ",";
			}
		}
	
		if (Right(loc.returnList, 1) eq ",")
			loc.returnList = Left(loc.returnList, Len(loc.returnList) - 1);
			
		loc.returnList = ListPrepend(loc.returnList, "id");
			
		return loc.returnList;
	</cfscript>
</cffunction>


<cffunction name="$toQuery" access="package" returntype="query">
	<cfargument name="response" required="true" type="any" />
	<cfscript>
		var loc = StructNew();
		
		loc.xml = arguments.response.getXmlContent();
		
		loc.returnQuery = QueryNew($queryColumnList(arguments.response));
		
		// create our response data
		loc.dataArray = XmlSearch(loc.xml, "//result/" & getName());
		loc.iEnd = ArrayLen(loc.dataArray);
		
		if (loc.iEnd gt 0)
			loc.dump = QueryAddRow(loc.returnQuery, loc.iEnd);
		else
			loc.returnQuery = QueryNew("empty");
		
		for (loc.i = 1; loc.i lte loc.iEnd; loc.i++) {
		
			loc.data = XmlParse(loc.dataArray[loc.i]);
			loc.dump = QuerySetCell(loc.returnQuery, "id", loc.data.contact.XmlAttributes.id, loc.i);
			loc.fields = XmlSearch(loc.data, "//" & getName() & "/Group_Tag/field");
			loc.jEnd = ArrayLen(loc.fields);
							
			for (loc.j = 1; loc.j lte loc.jEnd; loc.j++) {
			
				loc.field = loc.fields[loc.j];
				loc.fieldName = $normalizeFieldName(loc.field.XmlAttributes.name);
				loc.dump = QuerySetCell(loc.returnQuery, loc.fieldName, loc.field.XmlText, loc.i);
			}
		}
		
		return loc.returnQuery;
	</cfscript>
</cffunction>


<cffunction name="$toArray" access="package" returntype="array">
	<cfargument name="response" required="true" type="any" />
	<cfargument name="returnAs" required="false" default="structs" /><!--- options are structs or objects --->
	<cfscript>
		var loc = StructNew();
		
		loc.xml = arguments.response.getXmlContent();
		
		loc.returnArray = ArrayNew(1);
		
		// create our response data
		loc.dataArray = XmlSearch(loc.xml, "//result/" & getName());
		loc.iEnd = ArrayLen(loc.dataArray);
		
		for (loc.i = 1; loc.i lte loc.iEnd; loc.i++) {
		
			loc.data = XmlParse(loc.dataArray[loc.i]);
	
			if (arguments.returnAs eq "objects") {
			
				ArrayAppend(loc.returnArray, $toObject(xml=loc.data, returnAs=arguments.returnAs));
				
			} else {
			
				ArrayAppend(loc.returnArray, $toStruct(xml=loc.data, returnAs=arguments.returnAs));
			}
		}	

		return loc.returnArray;
	</cfscript>
</cffunction>


<cffunction name="$toObject" access="package" returntype="any">
	<cfargument name="xml" required="true" type="xml" />
	<cfargument name="useGroupTag" required="false" default="true" />
	<cfscript>
		return CreateObject("component", "com.liquifusion.officeAutoPilot.model." & getName()).init(appId=getAppId(), key=getKey(), properties=$toStruct(xml=arguments.xml, useGroupTag=arguments.useGroupTag));
	</cfscript>
</cffunction>


<cffunction name="$toStruct" access="package" returntype="struct">
	<cfargument name="xml" required="true" type="xml" />
	<cfargument name="useGroupTag" required="false" default="true" />
	<cfscript>
		var loc = StructNew();
	
		loc.struct = StructNew();
		loc.struct.id = arguments.xml[getName()].XmlAttributes.id;
		
		if (arguments.useGroupTag)
			loc.fields = XmlSearch(arguments.xml, "//" & getName() & "/Group_Tag/field");
		else
			loc.fields = XmlSearch(arguments.xml, "//" & getName() & "/field");
		
		loc.jEnd = ArrayLen(loc.fields);
						
		for (loc.j = 1; loc.j lte loc.jEnd; loc.j++) {
		
			loc.field = loc.fields[loc.j];
			loc.fieldName = $normalizeFieldName(loc.field.XmlAttributes.name);
			loc.struct[loc.fieldName] = loc.field.XmlText;
		}
		
		return Duplicate(loc.struct);
	</cfscript>
</cffunction>
	