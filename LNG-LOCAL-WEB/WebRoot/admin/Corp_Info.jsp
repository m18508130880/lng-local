<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.text.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	CorpInfoBean Corp_Info = (CorpInfoBean)session.getAttribute("Corp_Info_" + Sid);
	String Cmd = "10";
	String Id = "";
	String CName = "";
	String Brief = "";
	String Contact = "";
	String Tel = "";
	String Addr = "";
	String Dept = "";
	String Station_Info = "";
	String Car_Info = "";
	String Oil_Info = "";
	String Rate = "";
 	if(Corp_Info != null)
	{
		Cmd = "11";
		Id = Corp_Info.getId();
		CName = Corp_Info.getCName();
		Brief = Corp_Info.getBrief();
		Contact = Corp_Info.getContact();
		Tel = Corp_Info.getTel();	
		Addr = Corp_Info.getAddr();
		Dept = Corp_Info.getDept();
   	Station_Info = Corp_Info.getStation_Info();
   	Car_Info = Corp_Info.getCar_Info();
   	Oil_Info = Corp_Info.getOil_Info();
   	Rate = Corp_Info.getRate();
   	
  	if(CName == null){CName = "";}
  	if(Brief == null){Brief = "";}
  	if(Contact == null){Contact = "";}
  	if(Tel == null){Tel = "";}
  	if(Addr == null){Addr = "";}
  	if(Dept == null){Dept = "";}
    if(Station_Info == null){Station_Info = "";} 
    if(Car_Info == null){Car_Info = "";}
    if(Oil_Info == null){Oil_Info = "";}
    if(Rate == null){Rate = "";}
 	}
 	
%>
<body  style=" background:#CADFFF">
<form name="CorpInfo_Edit" action="Corp_Info.do" method="post" target="mFrame">
<div id="down_bg_2">
  <div id="cap"><img src="../skin/images/corp_info.gif"></div><br><br>
  <div id="right_table_center">
  	<table width="70%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
 			<tr height='30' valign='middle'>
 				<td width='100%' align='right'>
 					<img style="cursor:hand" src="../skin/images/mini_button_submit.gif" onclick='doEdit()'>
 				</td>
 			</tr>
 		</table>
	  <table width="70%" style='margin:auto;' border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		 	<tr height="30">
		 		<td width="20%" align="center">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
		  	<td width="30%" align="left"><input name="Id" type="text"    maxlength="10" style="width:97%;height:20px" value="<%=Id%>"></td>
		  	<td width="20%" align="center">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
		  	<td width="30%" align="left"><input name="CName" type="text" maxlength="30" style="width:97%;height:20px" value="<%=CName%>"></td>
		  </tr>
		  <tr height="30">
		  	<td width="20%" align="center">�� ϵ ��</td>
		  	<td width="30%" align="left"><input name="Contact" type="text" maxlength="6" style="width:97%;height:20px" value="<%=Contact%>"></td>
		  	<td width="20%" align="center">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
		  	<td width="30%" align="left"><input name="Brief" type="text" maxlength="8"  style="width:97%;height:20px" value="<%=Brief%>"></td>
		  </tr>
		  <tr height="30">
		  	<td width="20%" align="center">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
		  	<td width="30%" align="left"><input name="Tel" type="text" maxlength="15" style="width:97%;height:20px" value="<%=Tel%>"></td> 		
		  	<td width="20%" align="center">�ۺϱ���</td>
		  	<td width="30%" align="left">	<input name="Rate" type="text" maxlength="60" style="width:97%;height:20px" value="<%=Rate%>"></td>
		  </tr>	 
		  <tr height="30">
		  	<td width="20%" align="center">��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ַ</td>
		  	<td width="80%" align="left" colspan=3><input name="Addr" type="text" maxlength="128" style="width:99%;height:20px" value="<%=Addr%>"></td>
		  </tr>
		  <tr height="30">
		  	<td width="20%" align="center">��������</td>
		  	<td width="80%" align="left" colspan=3><input name="Dept" type="text" maxlength="128" style="width:99%;height:20px" value="<%=Dept%>"></td> 		
		  </tr>
		  <tr height="30">
		  	<td width="20%" align="center">վ������</td>
		  	<td width="80%" align="left" colspan=3><input name="Station_Info" type="text" maxlength="1024" style="width:99%;height:20px" value="<%=Station_Info%>"></td> 		
		  </tr>
		  <tr height="30">
		  	<td width="20%" align="center">��������</td>
		  	<td width="80%" align="left" colspan=3><input name="Car_Info" type="text" maxlength="1024" style="width:99%;height:20px" value="<%=Car_Info%>"></td> 		
		  </tr>
		  <tr height="30">
		  	<td width="20%" align="center">ȼ������</td>
		  	<td width="80%" align="left" colspan=3><input name="Oil_Info" type="text" maxlength="1024" style="width:99%;height:20px" value="<%=Oil_Info%>"></td> 		
		  </tr>
		</table>
	</div>   
</div>
<input type="hidden" name="Cmd" value="<%=Cmd%>">
<input type="hidden" name="Sid" value="<%=Sid%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>	
if(<%=currStatus.getResult().length()%> > 0)
   alert("<%=currStatus.getResult()%>");
<%
currStatus.setResult("");
session.setAttribute("CurrStatus_" + Sid, currStatus);
%>

function doEdit()
{ 
	if(CorpInfo_Edit.Id.value.Trim().length < 1)
	{
		alert("����д���");
		return;
	}
	if(CorpInfo_Edit.CName.value.Trim().length < 1)
	{
		alert("����д����");
		return;
	}
	if(CorpInfo_Edit.Brief.value.Trim().length < 1)
	{
		alert("����д���");
		return;
	}
	if(CorpInfo_Edit.Contact.value.Trim().length < 1)
	{
		alert("����д��ϵ��");
		return;
	}
	if(CorpInfo_Edit.Tel.value.Trim().length < 1)
	{
		alert("����д�绰");
		return;
	}
	if(CorpInfo_Edit.Addr.value.Trim().length < 1)
	{
		alert("����д��ַ");
		return;
	}
	if(CorpInfo_Edit.Dept.value.indexOf("��")  >= 0)
  {
  	 CorpInfo_Edit.Dept.value = CorpInfo_Edit.Dept.value.replace(/��/g,",");
  }
  if(confirm("ȷ���ύ?"))
  {    	  
			CorpInfo_Edit.submit();
	}
}

//ȥ�ո��������ʽ
String.prototype.Trim = function() 
{ 
	return this.replace(/(^\s*)|(\s*$)/g, ""); 	
}  
String.prototype.LTrim = function()
{ 
	return this.replace(/(^\s*)/g, ""); 
}  
String.prototype.RTrim = function()
{
	 return this.replace(/(\s*$)/g, ""); 
} 
</SCRIPT>
</html>

