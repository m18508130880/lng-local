<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../skin/js/util.js"></script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	
%>
<body  style=" background:#CADFFF">
<form name="Spa_Store_IN_File" action="Spa_Store_IN_File.do" method="post" target="mFrame" enctype="multipart/form-data">
  <table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='30'>
			<td align=center>
				<strong>�밴Excel-2003��׼��ʽ����</strong>
			</td>
		</tr>		
		<tr height='30'>			
			<td align=center>
				&nbsp;&nbsp;&nbsp;<input name='file' type='file' style='width:90%;height:20px;' title='�ĵ��ϴ�'>
			</td>
		</tr>	
		<tr height='30'>
		<td width='100%' align='center' >
			<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doEdit()'>
		</td>
	</tr>
	</table> 
	<input type="hidden" name="Sid"             value="<%=Sid%>">
</form>
</body>
<script LANGUAGE="javascript">
	
function doEdit()
{	
	if(Spa_Store_IN_File.file.value.Trim().length > 0)
  {
  	if(Spa_Store_IN_File.file.value.indexOf('.xls') == -1 
  	&& Spa_Store_IN_File.file.value.indexOf('.XLS') == -1 
  	&& Spa_Store_IN_File.file.value.indexOf('.xlsx') == -1 
  	&& Spa_Store_IN_File.file.value.indexOf('.XLSX') == -1 )	
		{
			alert('��ȷ���ĵ���ʽ,֧��xls,xlsx��ʽ!');
			return;
		}
  }								
	if(confirm('��Ϣ����,ȷ���ύ?'))
  {
		Spa_Store_IN_File.submit();
  }	
}

</script>
</html>