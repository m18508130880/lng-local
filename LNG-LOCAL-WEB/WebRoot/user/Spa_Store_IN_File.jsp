<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
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
				<strong>请按Excel-2003标准格式导入</strong>
			</td>
		</tr>		
		<tr height='30'>			
			<td align=center>
				&nbsp;&nbsp;&nbsp;<input name='file' type='file' style='width:90%;height:20px;' title='文档上传'>
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
			alert('请确认文档格式,支持xls,xlsx格式!');
			return;
		}
  }								
	if(confirm('信息无误,确定提交?'))
  {
		Spa_Store_IN_File.submit();
  }	
}

</script>
</html>