<cfset contact = CreateObject("component", "model.contact").init(appId="2_543_kK2Gb4T7F", key="vAUJHunuAC29Ym3") />
<cfset response = contact.properties() />

<cfdump var="#response.getResponse()#" />