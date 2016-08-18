<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.text.*" %>
<%@ taglib uri="/WEB-INF/limitvalidatetag.tld" prefix="Limit"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../skin/js/util.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	Date date1 = new Date();
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String CTime = formatter.format(date1);
	String Sid       = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String Cpm_Id       = CommUtil.StrToGB2312(request.getParameter("Cpm_Id"));
	String Cpm_Name       = CommUtil.StrToGB2312(request.getParameter("Cpm_Name"));
	String Dev_Type       = CommUtil.StrToGB2312(request.getParameter("Dev_Type"));
	String Dev_Type_Name       = CommUtil.StrToGB2312(request.getParameter("Dev_Type_Name"));
	String Dev_Name       = CommUtil.StrToGB2312(request.getParameter("Dev_Name"));
	String Dev_Zhuangtai       = CommUtil.StrToGB2312(request.getParameter("Dev_Zhuangtai"));
	String CType       = CommUtil.StrToGB2312(request.getParameter("CType"));
	CurrStatus currStatus  = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	CorpInfoBean Corp_Info = (CorpInfoBean)session.getAttribute("User_Corp_Info_" + Sid);	
	
	
%>
<body style="background:#CADFFF">
<form name="Dev_List_ZT" action="Dev_List.do" method="post" target="mFrame">
	<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='30'>
			<td width='25%' align='center'>站&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;点</td>
			<td width='75%' align='left'>
				<%=Cpm_Name%>
				<input type='hidden' name='Cpm_Id' value='<%=Cpm_Id%>'>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>设备类型</td>
			<td width='75%' align='left'>
				<%=Dev_Type_Name%>
				<input type='hidden' name='Dev_Type' value='<%=Dev_Type%>'>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>设备名称</td>
			<td width='75%' align='left'>				
				<%=Dev_Name%>
				<input type='hidden' name='Dev_Name' value='<%=Dev_Name%>'>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>当前状态</td>
			<td width='75%' align='left'>
				<input type='text' name='Dev_Zhuangtai' value='<%=Dev_Zhuangtai%>' style='width:120px;height:16px;' maxlength=10> 				
			</td>
		</tr>		
		<tr height='40'>
			<td width='100%' align='center' colspan=2>
				<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doSave()'>
			</td>
		</tr>
	</table>
	<input type='hidden' name='Cmd' value='14'>
	<input name="Sid"       type="hidden"   value="<%=Sid%>">	
	<input name="Func_Corp_Id"       type="hidden"   value="<%=CType%>">	
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doSave()
{
	
	if(confirm('确定修改设备当前状态?'))
	{
		Dev_List_ZT.submit();
	}
}
</SCRIPT>
</html>