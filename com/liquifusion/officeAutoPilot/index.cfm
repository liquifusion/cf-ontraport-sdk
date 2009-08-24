
<!---
	<cfdump var="#application#" />
	<cfabort />
	<cfset searchArray = ArrayNew(1) />
	<cfset searchArray[1] = {field="contacttags", operation="like", value="I-AM RAINMAKER buyer"} />
--->


<cfset contact = CreateObject("component", "model.contact").init(appId="2_543_kK2Gb4T7F", key="vAUJHunuAC29Ym3").findByKey(276) />

<cfset contact.update(country="US") />

<cfdump var="#contact#" />
<cfabort />
