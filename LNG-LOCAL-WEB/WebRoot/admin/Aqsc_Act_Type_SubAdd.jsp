<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/util.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%

	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String Id  = CommUtil.StrToGB2312(request.getParameter("Id"));
	
%>
<body style="background:#CADFFF">
<form name="Aqsc_Act_Type_SubAdd" action="Aqsc_Act_Type.do" method="post" target="mFrame">
<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
	<tr height='30'>
		<td width='20%' align='center'>������</td>
		<td width='30%' align='left'>
			<%=Id%>**
		</td>
		<td width='20%' align='center'>����״̬</td>
		<td width='30%' align='left'>
		  <select name="Status" style="width:92%;height:20px;">
		  	<option value='0'>����</option>
		  	<option value='1'>ע��</option>
		  </select>
		</td>
	</tr>
	<tr height='30'>
		<td width='20%' align='center'>��������</td>
		<td width='80%' align='left' colspan=3>
			<input type='text' name='CName' style='width:96%;height:18px;' value='' maxlength='15'>
		</td>
	</tr>
	<tr height='30'>
		<td width='20%' align='center'>��������</td>
		<td width='80%' align='left' colspan=3>
			<textarea name='Des' rows='4' cols='37' maxlength=128></textarea>
		</td>
	</tr>
	<tr height='30'>
		<td width='100%' align='center' colspan=4>
			<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doAdd()'>
		</td>
	</tr>
</table>
<input name="Cmd" type="hidden" value="10">
<input name="Id"  type="hidden" value="<%=Id%>**">
<input name="Sid" type="hidden" value="<%=Sid%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doAdd()
{
  if(Aqsc_Act_Type_SubAdd.CName.value.Trim().length < 1)
  {
    alert("��������������!");
    return;
  }
  if(Aqsc_Act_Type_SubAdd.Des.value.Trim().length > 128)
  {
    alert("�����������������!");
    return;
  }
  if(confirm("��Ϣ����,ȷ���ύ?"))
  {
  	Aqsc_Act_Type_SubAdd.submit();
  }
}
</SCRIPT>
</html>