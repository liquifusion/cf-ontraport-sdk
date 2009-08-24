<cfcomponent>

	<cfset variables.instance = StructNew() />
	<cfset variables.instance.scopeName = "officeautopilot" />
	
	
	<!---
	****************************************************************
		INSTANCE METHODS
	****************************************************************
	--->
	
	<cffunction name="init" access="public" returntype="base">
		<cfargument name="url" required="true" type="string" />
		<cfargument name="appId" required="true" type="string" />
		<cfargument name="key" required="true" type="string" />
		<cfargument name="properties" required="false" default="#StructNew()#" />
		<cfargument name="timeout" required="false" type="numeric" default="30" />
		<cfargument name="$persisted" required="false" default="false" />
		<cfscript>
			variables.instance.url = arguments.url;
			variables.instance.timeout = arguments.timeout;
			variables.instance.appId = arguments.appId;
			variables.instance.key = arguments.key;
			
			$createProperties(this.properties());
			$populateProperties(arguments.properties);
				
			if (arguments.$persisted)
				$updatePersistedProperties();
			
			variables.instance.searchOperations = StructNew();
			variables.instance.searchOperations["eq"]            = "e";
			variables.instance.searchOperations["neq"]           = "n";
			variables.instance.searchOperations["starts with"]   = "s";
			variables.instance.searchOperations["like"]          = "c";
			variables.instance.searchOperations["not like"]      = "k";
			variables.instance.searchOperations["lt"]            = "l";
			variables.instance.searchOperations["gt"]            = "g";
			variables.instance.searchOperations["lte"]           = "m";
			variables.instance.searchOperations["gte"]           = "h";		
		
			return this;
		</cfscript>
	</cffunction>
	
	<cfinclude template="mixins/locking.cfm" />
	<cfinclude template="mixins/to.cfm" />
	
	
	
	<cffunction name="getName">
		<cfreturn variables.instance.name />
	</cffunction>
	
	<cffunction name="getAppId">
		<cfreturn variables.instance.appId />
	</cffunction>
	
	<cffunction name="setAppId">
		<cfargument name="appId" required="true" type="string" />
		<cfscript>
			variables.instance.appId = arguments.appId;
		</cfscript>
	</cffunction>
	
	<cffunction name="getTimeout">
		<cfreturn variables.instance.timeout />
	</cffunction>
	
	<cffunction name="setTimeout">
		<cfargument name="timeout" required="true" type="string" />
		<cfscript>
			variables.instance.timeout = arguments.timeout;
		</cfscript>
	</cffunction>
	
	<cffunction name="getKey">
		<cfreturn variables.instance.key />
	</cffunction>
	
	<cffunction name="setKey">
		<cfargument name="key" required="true" type="string" />
		<cfscript>
			variables.instance.key = arguments.key;
		</cfscript>
	</cffunction>
	
	<cffunction name="getUrl">
		<cfreturn variables.instance.url />
	</cffunction>
	
	<cffunction name="setUrl">
		<cfargument name="url" required="true" type="string" />
		<cfscript>
			variables.instance.url = arguments.url;
		</cfscript>
	</cffunction>
	
	
	<!--- get field attribute methods --->
	<cffunction name="getFieldGroup">
		<cfargument name="fieldName" required="true" type="string" />
		<cfscript>
			var loc = StructNew();
			loc.property = $getProperty(arguments.fieldName);
			return loc.property.group;
		</cfscript>
	</cffunction>
	
	
	<cffunction name="getFieldType">
		<cfargument name="fieldName" required="true" type="string" />
		<cfscript>
			var loc = StructNew();
			loc.property = $getProperty(arguments.fieldName);
			return loc.property.type;
		</cfscript>
	</cffunction>
	
	
	<cffunction name="getFieldLabel">
		<cfargument name="fieldName" required="true" type="string" />
		<cfscript>
			var loc = StructNew();
			loc.property = $getProperty(arguments.fieldName);
			return loc.property.label;
		</cfscript>
	</cffunction>
	
	<cffunction name="properties" access="public" returntype="array" hint="returns an array of properties for the contact object.">
		<cfscript>
			var loc = StructNew();
			
			// check to see if in the application scope, otherwise get from service
			if ($hasPropertyData(getName()))
				return $getPropertyData(getName());
			
			return this.$keys();
		</cfscript>
	</cffunction>
	
	
	<cffunction name="changedProperties" returntype="string" access="public" output="false">
		<cfscript>
			var loc = StructNew();
			
			loc.returnValue = "";
			loc.properties = $getPropertyData();
			loc.iEnd = ArrayLen(loc.properties);
			
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i+1) {
			
				loc.property = loc.properties[loc.i];
				if (hasChanged(loc.property.name))
					loc.returnValue = ListAppend(loc.returnValue, loc.property.name);
			}
			
			return loc.returnValue;
		</cfscript>
	</cffunction>
	
	<cffunction name="hasChanged" returntype="boolean" access="public" output="false">
		<cfargument name="property" type="string" required="false" default="" hint="Name of property to check for change">
		<cfscript>
			var loc =  StructNew();
			
			loc.returnValue = false;
			loc.properties = $getPropertyData();
			loc.iEnd = ArrayLen(loc.properties);
			
			
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i+1) {
			
				loc.property = loc.properties[loc.i];
				
				if (not StructKeyExists(this, loc.property.name) 
					or not StructKeyExists(variables.instance, "$persistedProperties") 
					or not StructKeyExists(variables.instance.$persistedProperties, loc.property.name) 
					or Compare(this[loc.property.name], variables.instance.$persistedProperties[loc.property.name]) 
					and (not Len(arguments.property) or loc.property.name eq arguments.property)) {
					
					loc.returnValue = true;	
				}
			}
			
			return loc.returnValue;
		</cfscript>
	</cffunction>
	
	<cffunction name="allChanges" returntype="struct" access="public" output="false">
		<cfscript>
			var loc = StructNew();
			loc.returnValue = StructNew();
			if (hasChanged())
			{
				loc.changedProperties = changedProperties();
				loc.iEnd = ListLen(loc.changedProperties);
				for (loc.i=1; loc.i lte loc.iEnd; loc.i+1)
				{
					loc.item = ListGetAt(loc.changedProperties, loc.i);
					loc.returnValue[loc.item] = StructNew();
					loc.returnValue[loc.item].changedFrom = changedFrom(loc.item);
					if (StructKeyExists(this, loc.item))
						loc.returnValue[loc.item].changedTo = this[loc.item];
					else
						loc.returnValue[loc.item].changedTo = "";
				}
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="changedFrom" returntype="string" access="public" output="false">
		<cfargument name="property" type="string" required="true" hint="Name of property to get the previous value for">
		<cfscript>
			var loc = StructNew();
			loc.returnValue = "";
			if (StructKeyExists(variables.instance, "$persistedProperties") and StructKeyExists(variables.instance.$persistedProperties, arguments.property))
				loc.returnValue = variables.instance.$persistedProperties[arguments.property];
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>	
	
	
	<cffunction name="isNew" access="public" returntype="boolean" hint="i let you know whether this object has been persisted or not">
		<cfscript>
			var loc = StructNew();
			loc.returnValue = true;
			
			if (StructKeyExists(variables.instance, "$persistedProperties"))
				loc.returnValue = false;
			
			return loc.returnValue;
		</cfscript>
	</cffunction>


	<cffunction name="create" returntype="any" access="public" output="false">
		<cfargument name="properties" type="struct" required="false" default="#StructNew()#" />
		<cfscript>
			return save(argumentCollection=arguments);
		</cfscript>
	</cffunction>


	<cffunction name="update" returntype="boolean" access="public" output="false">
		<cfargument name="properties" type="struct" required="false" default="#StructNew()#" />
		<cfscript>
			return save(argumentCollection=arguments);
		</cfscript>
	</cffunction>


	<cffunction name="save" returntype="boolean" access="public" output="false">
		<cfargument name="properties" type="struct" required="false" default="#StructNew()#" />
		<cfscript>
			var loc = StructNew();
			
			for (loc.key in arguments)
				if (loc.key neq "properties")
					arguments.properties[loc.key] = arguments[loc.key];
					
			for (loc.key in arguments.properties)
				this[loc.key] = arguments.properties[loc.key];
			
			loc.returnValue = false;
			
			if (isNew()) {
				
				loc.reqType = "add";
			
			} else {
			
				loc.reqType = "update";
				
				if (not hasChanged())
					return true;
			}
			
			// send it off!
			loc.response = $process(reqType=loc.reqType, data=$toXml(), return_id=true);
			
			loc.xml = loc.response.getXmlContent();
			loc.dataArray = XmlSearch(loc.xml, "//result/" & getName());
			
			if (ArrayIsEmpty(loc.dataArray))
				return false;
				
			loc.data = XmlParse(loc.dataArray[1]);
			$populateProperties($toStruct(xml=loc.data));
			$updatePersistedProperties();
			
			return true;			
		</cfscript>
	</cffunction>

	
	<!---
	****************************************************************
		CLASS METHODS
	****************************************************************
	--->
	
	
	<cffunction name="findAllById" access="public" returntype="any">
		<cfargument name="ids" required="true" type="any" />
		<cfargument name="returnAs" required="false" default="structs" /><!--- can also be objects and query --->

		<cfscript>
			var loc = StructNew();
			loc.name = getName();
			
			if (IsSimpleValue(arguments.ids))
				arguments.ids = ListToArray(arguments.ids);
			else if (IsQuery(arguments.ids))
				arguments.ids = ListToArray(ValueList(arguments.ids.id));
				
			if (not IsArray(arguments.ids))
				$throw(type="officeautopilot.ArgumentTypeMismatch", message="The argument ids may be of type Array, List or Query with a column of id.");
				
			loc.iEnd = ArrayLen(arguments.ids);
		</cfscript>
		
		<cfsavecontent variable="loc.requestXml">
			<cfoutput>
				<cfloop index="loc.i" from="1" to="#loc.iEnd#">
					<#loc.name#_id>#arguments.ids[loc.i]#</#loc.name#_id>
				</cfloop>
			</cfoutput>
		</cfsavecontent>
		
		<cfscript>
			loc.response = this.$process(reqType="fetch", data=ToString(loc.requestXml));
			
			if (arguments.returnAs eq "query") {
			
				return $toQuery(loc.response);
			
			} else {
			
				return $toArray(loc.response, arguments.returnAs);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="findByKey" access="public" returntype="any">
		<cfargument name="id" required="true" type="numeric" />
		
		<cfset var loc = StructNew() />
		<cfset loc.name = getName() />
		
		<cfsavecontent variable="loc.requestXml">
			<cfoutput>
				<#loc.name#_id>#arguments.id#</#loc.name#_id>
			</cfoutput>
		</cfsavecontent>
		
		<cfscript>
			loc.response = this.$process(reqType="fetch", data=ToString(loc.requestXml));
			
			if (loc.response.hasError())
				return false;
			
			loc.xml = loc.response.getXmlContent();
			
			loc.dataArray = XmlSearch(loc.xml, "//result/" & getName());
			
			if (ArrayIsEmpty(loc.dataArray))
				return false;
				
			loc.data = XmlParse(loc.dataArray[1]);
			
			return $toObject(xml=loc.data);
		</cfscript>
	</cffunction>
	
	<cffunction name="search" access="public" returntype="any" hint="">
		<cfargument name="searchArray" required="false" type="array" default="#ArrayNew(1)#" />
		<cfargument name="returnAs" required="false" default="structs" /><!--- can also be objects and query --->
		
		<cfset var loc = StructNew() />

		<cfsavecontent variable="loc.item">
			<equation>
				<field>{field}</field>
				<op>{operation}</op>
				<value>{value}</value>
			</equation>
		</cfsavecontent>
		
		<!--- loop through the arguments to see if there are any others so that we can specify equals to easily --->
		<cfscript>

			loc.preDefinedArguments = "searchArray,returnAs";
			
			for (loc.key in arguments) {
			
				if (not ListFindNoCase(loc.preDefinedArguments, loc.key) and IsSimpleValue(arguments[loc.key])) {
				
					// we found an argument for search, add it to the search array
					loc.struct = StructNew();
					loc.struct.field = loc.key;
					loc.struct.operation = "eq";
					loc.struct.value = arguments[loc.key];
					
					ArrayAppend(arguments.searchArray, Duplicate(loc.struct));
				}
			}

			if (ArrayIsEmpty(arguments.searchArray))
				$throw(type="officeautopilot.SearchCriteriaRequired", message="You must sepecify at least one search criteria for the search method.");
			
			loc.searchXml = "";
			loc.iEnd = ArrayLen(arguments.searchArray);
			
			
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i+1) {
			
				loc.itemXml = loc.item;
				
				loc.itemXml = Replace(loc.itemXml, "{field}", getFieldLabel(arguments.searchArray[loc.i].field), "all");
				loc.itemXml = Replace(loc.itemXml, "{operation}", mapOperation(arguments.searchArray[loc.i].operation), "all");
				loc.itemXml = Replace(loc.itemXml, "{value}", arguments.searchArray[loc.i].value, "all");
				loc.searchXml = loc.searchXml & loc.itemXml;
			}
		</cfscript>
		
		<cfsavecontent variable="loc.requestXml">
			<cfoutput>
				<search>
					#loc.searchXml#
				</search>
			</cfoutput>
		</cfsavecontent>
		
		<cfscript>
			loc.response = this.$process(reqType="search", data=ToString(loc.requestXml));
			
			if (arguments.returnAs eq "query") {
			
				return $toQuery(loc.response);
			
			} else {
			
				return $toArray(loc.response, arguments.returnAs);
			}
		</cfscript>
	</cffunction>
	
	
	<cffunction name="$createModelObject" access="package" returntype="base" output="false">
		<cfargument name="properties" required="true" type="struct" />
		<cfargument name="persisted" required="false" default="false" />
		<cfscript>
			var loc = StructNew();
			loc.returnObject = CreateObject("component", getName()).init(appId=getAppId(), key=getKey(), properties=arguments.properties, $persisted=arguments.persisted);
			return loc.returnObject;
		</cfscript>
	</cffunction>
	
	
	
	<!-----------------------------------------------
		PACKAGE METHODS
	------------------------------------------------>
	<cffunction name="$normalizeFieldName" access="package" returntype="string">
		<cfargument name="fieldName" required="true" type="string" />
		<cfscript>
			return LCase(REReplace(arguments.fieldName, "[^a-zA-Z0-9]+", "", "all"));
		</cfscript>	
	</cffunction>
	
	
	<cffunction name="$keys" access="package" returntype="array">
		<cfscript>

			loc.data = ArrayNew(1);
			
			loc.response = this.$process(reqType="key");
			
			loc.xml = loc.response.getXmlContent();
			
			// create our response data
			loc.groupArray = XmlSearch(loc.xml, "//result/" & getName() & "/Group_Tag");
			
			loc.iEnd = ArrayLen(loc.groupArray);
			
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i+1) {
			
				loc.group = loc.groupArray[loc.i];
				
				loc.fieldArray = loc.group.XmlChildren;
				
				loc.jEnd = ArrayLen(loc.fieldArray);
				
				for (loc.j = 1; loc.j lte loc.jEnd; loc.j++) {
				
					loc.field = loc.fieldArray[loc.j];
					
					loc.fieldStuct = StructNew();
					
					loc.fieldStruct.name = $normalizeFieldName(loc.field.XmlAttributes.name);
					loc.fieldStruct.label = loc.field.XmlAttributes.name;
					loc.fieldStruct.type = loc.field.XmlAttributes.type;
					loc.fieldStruct.group = loc.group.XmlAttributes.name;
			
					ArrayAppend(loc.data, Duplicate(loc.fieldStruct));
				}
			}
			
			// create the id field
			loc.fieldStuct = StructNew();
			
			loc.fieldStruct.name = "id";
			loc.fieldStruct.label = "Id";
			loc.fieldStruct.type = "primaryKey";
			loc.fieldStruct.group = "";
			
			ArrayPrepend(loc.data, Duplicate(loc.fieldStruct));
			
			$setPropertyData(getName(), loc.data);
			
			return loc.data;		
		</cfscript>
	</cffunction>
	
	
	<cffunction name="$process" access="package">
		<cfargument name="reqType" required="true" type="string" />
		<cfargument name="data" required="false" type="string" default="" />
		<cfargument name="f_add" required="false" type="boolean" default="false" />
		<cfargument name="return_id" required="false" type="boolean" default="false" />
		
		<cfset var loc = StructNew() />
		
		<cfset arguments.url = getUrl() />
		<cfset arguemnts.appId = getAppId() />
		<cfset arguemnts.key = getKey() />
		
		<cfhttp url="#arguments.url#" timeout="#getTimeout()#" method="post" result="loc.http" throwonerror="false">
			<cfhttpparam name="Appid" value="#arguemnts.appId#" type="formfield" />
			<cfhttpparam name="Key" value="#arguemnts.key#" type="formfield" />
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
		
		<cfset loc.response = CreateObject("component", "response").init(request=Duplicate(arguments), response=Duplicate(loc.http)) />
		
		<cfreturn loc.response />
	</cffunction>
	
	
	<cffunction name="$verifyApplicationScopeExists" access="package">
		<cfscript>
			if (not StructKeyExists(application, "officeautopilot"))
				$namedLockWrite(name=$getScopeName(), objectName="application", key="officeautopilot", value=StructNew());
		</cfscript>
	</cffunction>
	
	
	<cffunction name="$getScopeName" access="package" returntype="string">
		<cfreturn variables.instance.scopeName />
	</cffunction>
	
	
	<cffunction name="$hasPropertyData" access="package" returntype="boolean">
		<cfargument name="objectName" required="true" type="string" />
		<cfscript>
			$verifyApplicationScopeExists();
			
			if (not StructKeyExists(application.officeautopilot, arguments.objectName))
				return false;
				
			if (not StructKeyExists(application.officeautopilot[arguments.objectName], "properties"))
				return false;
			
			if (IsArray(application.officeautopilot[arguments.objectName].properties));
				return true;
				
			return false;
		</cfscript>
	</cffunction>
	
	
	<cffunction name="$getProperty" access="package" returntype="struct">
		<cfargument name="fieldName" required="true" type="string" />
		<cfscript>
			var loc = StructNew();
			
			loc.properties = $getPropertyData(getName());
			
			loc.iEnd = ArrayLen(loc.properties);
			
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i+1) {
			
				if (loc.properties[loc.i].name eq arguments.fieldName)
					return loc.properties[loc.i];
			}
			
			$throw(type="officeautopilot", message="Field `#arguments.fieldname#` does not exist on this object.");
		</cfscript>
	</cffunction>
	 
	
	<cffunction name="$getPropertyData" access="package" returntype="array" output="false">
		<cfscript>
			var loc = StructNew();
			loc.objectName = getName();
			return $namedLockRead(name=$getScopeName(), objectName="application.officeautopilot.#loc.objectName#", key="properties");
		</cfscript>
	</cffunction>
	
	
	<cffunction name="$setPropertyData" access="package" returntype="void">
		<cfargument name="objectName" required="true" type="string" />
		<cfargument name="value" required="true" type="array" />
		<cfscript>
			var loc = StructNew();
			
			$verifyApplicationScopeExists();
			
			if (not StructKeyExists(application.officeautopilot, arguments.objectName))
				$namedLockWrite(name=$getScopeName(), objectName="application.officeautopilot", key=arguments.objectName, value=StructNew());
				
			$namedLockWrite(name=$getScopeName(), objectName="application.officeautopilot.#arguments.objectName#", key="properties", value=arguments.value);
			
			loc.iEnd = ArrayLen(arguments.value);
			
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i+1) {
			
				loc.field = arguments.value[loc.i];
				
				this[loc.field.name] = "";
			}
		</cfscript>
	</cffunction>
	
	
	<cffunction name="$createProperties" access="package" returntype="void">
		<cfargument name="properties" required="true" type="array" />
		<cfscript>
			var loc = StructNew();
			
			loc.iEnd = ArrayLen(arguments.properties);
			
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i+1) {
			
				loc.field = arguments.properties[loc.i];
				
				this[loc.field.name] = "";
			}
		</cfscript>
	</cffunction>
	
	
	<cffunction name="$populateProperties" access="package" returntype="void">
		<cfargument name="properties" required="true" type="struct" />
		<cfscript>
			var loc = StructNew();
			
			for (loc.item in arguments.properties) {
			
				this[loc.item] = arguments.properties[loc.item];
			}
		</cfscript>
	</cffunction>
	
	
	<cffunction name="$updatePersistedProperties">
		<cfscript>
			var loc = StructNew();
			variables.instance.$persistedProperties = StructNew();
			loc.properties = $getPropertyData();
			loc.iEnd = ArrayLen(loc.properties);
			
			for (loc.i = 1; loc.i lte loc.iEnd; loc.i+1) {
			
				loc.property = loc.properties[loc.i];
				if (StructKeyExists(this, loc.property.name))
					variables.instance.$persistedProperties[loc.property.name] = this[loc.property.name];
			}
		</cfscript>
	</cffunction>
	
	<!---
		SEARCH HELPER FUNCTIONS
	--->
	<cffunction name="mapOperation" access="package" returntype="string" output="false">
		<cfargument name="operation" required="true" type="string" />
		<cfscript>
			if (not StructKeyExists(variables.instance.searchOperations, arguments.operation)) 
				$throw(type="officeautopilot.OperationNotFound", message="The operation `#arguments.operation#` is not valid.");
				
			return variables.instance.searchOperations[arguments.operation];
		</cfscript>
	</cffunction>
	
	
	<cffunction name="getMemento" access="public" returntype="struct" output="false">
		<cfreturn variables.instance />
	</cffunction>
	
	
	<cffunction name="$throw" returntype="void" access="package" output="false">
		<cfargument name="type" required="true" type="string" />
		<cfargument name="message" required="true" type="string" />
		<cfthrow type="#arguments.type#" message="#arguments.message#" />
	</cffunction>	
	
</cfcomponent>
