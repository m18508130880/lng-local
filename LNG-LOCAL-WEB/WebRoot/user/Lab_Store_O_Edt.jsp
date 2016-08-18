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
<script type="text/javascript" src="../skin/js/util.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%

	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String SN  = CommUtil.StrToGB2312(request.getParameter("SN"));
	
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	String Operator = UserInfo.getId();
  
%>
<body style="background:#CADFFF">
<form name="Lab_Store_O_Edt" action="Lab_Store_O.do" method="post" target="mFrame">
	<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">					
		<tr height='30px'>
			<td width='25%' align=center>作废原因</td>
			<td width='75%' align=left>
				<textarea name='Status_Memo' rows='6' cols='40' maxlength=128></textarea>
			</td>
		</tr>
		<tr height='40px'>
			<td width='100%' align=center colspan=2>
				<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doEdit()'>
			</td>
		</tr>
	</table>
	<input type="hidden" name="Cmd"          value="11">
	<input type="hidden" name="Sid"          value="<%=Sid%>">
	<input type="hidden" name="SN"     			 value="<%=SN%>">
	<input type="hidden" name="Status"    	 value="2">
	<input type="hidden" name="Status_OP"    value="<%=Operator%>">
	<input type="hidden" name="Cpm_Id"       value="">
	<input type="hidden" name="BTime"        value="<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>">
	<input type="hidden" name="ETime"        value="<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>">
	<input type="hidden" name="CurrPage"     value="<%=currStatus.getCurrPage()%>">
	<input type="hidden" name="Func_Corp_Id" value="<%=currStatus.getFunc_Corp_Id()%>">
	<input type="hidden" name="Func_Sub_Id"  value="<%=currStatus.getFunc_Sub_Id()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doEdit()
{
	if(Lab_Store_O_Edt.Status_Memo.value.Trim().length < 1)
  {
  	alert('请填写作废原因!');
  	return;
  }
  if(Lab_Store_O_Edt.Status_Memo.value.Trim().length > 128)
  {
    alert("作废原因描述过长，请简化!");
    return;
  }
  if(confirm("确认审核?"))
  {
  	//Lab_Store_O_Edt.Cpm_Id.value = parent.window.parent.frames.lFrame.document.getElementById('id').value;
  	Lab_Store_O_Edt.submit();
  }
}
</SCRIPT>
</html>