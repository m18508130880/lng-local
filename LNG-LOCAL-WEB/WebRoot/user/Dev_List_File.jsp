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
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../skin/js/util.js"></script>
</head>
<%
	
	String Sid   = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String Dev_Wendang = CommUtil.StrToGB2312(request.getParameter("Dev_Wendang"));
	String SN    = CommUtil.StrToGB2312(request.getParameter("SN"));
	String Cpm_Id    = CommUtil.StrToGB2312(request.getParameter("Cpm_Id"));
	CurrStatus currStatus   = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	
%>
<body style="background:#CADFFF">
<form name="Dev_List_File" action="Dev_List_File.do" method="post" target="mFrame" enctype="multipart/form-data">
<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">					
			<tr height='30' class='table_blue'>
			  <td width='100%' align='center' colspan=4><B>�豸�����ĵ�����</B></td>
			</tr>			
			<tr height='30'>
				<td width='20%' align='center'>ԭ���ĵ�</td>
				<td width='80%' align='left' colspan=3>
			<%	if(Dev_Wendang.length()>1)
					{ 
			%>		
						<a href='../files/upfiles/<%=Dev_Wendang%>' title='�������'><%=Dev_Wendang%></a>
			<%	}
					else
					{
			%>
					��δ�ϴ��ĵ�!
			<%	
					}%>			
					<input type='hidden' name='Dev_Wendang' value='<%=Dev_Wendang%>'>
				</td>
			</tr>
			<tr height='30'>
				<td width='20%' align='center'>�ĵ��ϴ�</td>
				<td width='80%' align='left' colspan=3>
					<input name='file' type='file' style='width:99%;height:20px;' title='�ĵ��ϴ�'>
				</td>
			</tr>

	<tr height='40'>
		<td width='100%' align='center' colspan=4>
			<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doEdit()'>
		</td>
	</tr>
</table>
<input type="hidden" name="Cmd"             value="13">
<input type="hidden" name="Sid"             value="<%=Sid%>">
<input type="hidden" name="SN"              value="<%=SN%>">
<input type="hidden" name="Cpm_Id"          value="<%=Cpm_Id%>">
<input type="hidden" name="Func_Corp_Id"    value="9999">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doEdit()
{				
	if(Dev_List_File.file.value.Trim().length > 0)
  {
  	if(Dev_List_File.file.value.indexOf('.doc') == -1 
  	&& Dev_List_File.file.value.indexOf('.DOC') == -1 
  	&& Dev_List_File.file.value.indexOf('.docx') == -1 
  	&& Dev_List_File.file.value.indexOf('.DOCX') == -1 
  	&& Dev_List_File.file.value.indexOf('.xls') == -1 
  	&& Dev_List_File.file.value.indexOf('.XLS') == -1 
  	&& Dev_List_File.file.value.indexOf('.xlsx') == -1 
  	&& Dev_List_File.file.value.indexOf('.XLSX') == -1 
  	&& Dev_List_File.file.value.indexOf('.pdf') == -1 
  	&& Dev_List_File.file.value.indexOf('.PDF') == -1)
		{
			alert('��ȷ���ĵ���ʽ,֧��doc,docx,xls,xlsx,pdf��ʽ!');
			return;
		}
  }								
	if(confirm('��Ϣ����,ȷ���ύ?'))
  {
		Dev_List_File.submit();
  }	
}
</SCRIPT>
</html>