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
	
	ArrayList Aqsc_Act_Type = (ArrayList)session.getAttribute("Aqsc_Act_Type_" + Sid);
  String CName = "";
	String Status = "0";
	String Des = "";
	if(Aqsc_Act_Type != null)
	{
		Iterator iterator = Aqsc_Act_Type.iterator();
		while(iterator.hasNext())
		{
			AqscActTypeBean statBean = (AqscActTypeBean)iterator.next();
			if(statBean.getId().equals(Id))
			{
				CName = statBean.getCName();
				Status = statBean.getStatus();
				Des = statBean.getDes();
				if(null == Des)
				{
					Des = "";
				}
			}
		}
 	}
 	
%>
<body style="background:#CADFFF">
<form name="Aqsc_Act_Type_SubEdit" action="Aqsc_Act_Type.do" method="post" target="mFrame">
<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
	<tr height='30'>
		<td width='20%' align='center'>������</td>
		<td width='30%' align='left'>
			<%=Id%>
		</td>
		<td width='20%' align='center'>����״̬</td>
		<td width='30%' align='left'>
		  <select name="Status" style="width:92%;height:20px;">
		  	<option value='0' <%=Status.equals("0")?"selected":""%>>����</option>
		  	<option value='1' <%=Status.equals("1")?"selected":""%>>ע��</option>
		  </select>
		</td>
	</tr>
	<tr height='30'>
		<td width='20%' align='center'>��������</td>
		<td width='80%' align='left' colspan=3>
			<input type='text' name='CName' style='width:96%;height:18px;' value='<%=CName%>' maxlength='15'>
		</td>
	</tr>
	<tr height='30'>
		<td width='20%' align='center'>��������</td>
		<td width='80%' align='left' colspan=3>
			<textarea name='Des' rows='4' cols='37' maxlength=128><%=Des%></textarea>
		</td>
	</tr>
	<tr height='30'>
		<td width='100%' align='center' colspan=4>
			<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doEdit()'>
		</td>
	</tr>
</table>
<input name="Cmd" type="hidden" value="11">
<input name="Id"  type="hidden" value="<%=Id%>">
<input name="Sid" type="hidden" value="<%=Sid%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doEdit()
{
  if(Aqsc_Act_Type_SubEdit.CName.value.Trim().length < 1)
  {
    alert("��������������!");
    return;
  }
  if(Aqsc_Act_Type_SubEdit.Des.value.Trim().length > 128)
  {
    alert("�����������������!");
    return;
  }
  if(confirm("��Ϣ����,ȷ���ύ?"))
  {
  	Aqsc_Act_Type_SubEdit.submit();
  }
}
</SCRIPT>
</html>