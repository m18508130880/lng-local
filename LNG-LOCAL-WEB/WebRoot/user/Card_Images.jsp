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
	String Sys_Id          = CommUtil.StrToGB2312(request.getParameter("Sys_Id"));
	String Tid          = CommUtil.StrToGB2312(request.getParameter("Tid"));
	String Func_Cpm_Id  = Sys_Id +"_" + Tid;
	String RCName          = CommUtil.StrToGB2312(request.getParameter("RCName"));
	String ZCName          = CommUtil.StrToGB2312(request.getParameter("ZCName"));
	String Card_Images     = CommUtil.StrToGB2312(request.getParameter("Card_Images"));
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  
	
	
%>
<body  style=" background:#CADFFF">
<form name="Card_Images" action="Card_Images.do" method="post" target="mFrame" enctype="multipart/form-data">
  <table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		
		<tr height='30'>
			<td align=center>
			&nbsp;</br> <strong><%=RCName%>&nbsp;  的<%=ZCName%>&nbsp;</strong>
			<input name="Func_Cpm_Id"         type="hidden" value="<%=Func_Cpm_Id%>">
			</td>
		</tr>				
		<tr height='30'>
			<td align=center>			
	<%
		if(Card_Images.length()>0)
		{
	%>
		<a href='../skin/images/zhengjian/<%=Func_Cpm_Id%>.jpg' title='点击下载'><font color=red><U><%=Func_Cpm_Id%></U></font></a></font>
	<%	
		}else
		{
	%>	
								尚无图片上传
	<%	
		}
	%>									
			</td>
		</tr>				
		<tr height='30'>			
			<td align=center>
				&nbsp;&nbsp;&nbsp;<input name='file' type='file' style='width:90%;height:20px;' title='图片上传'>
			</td>
		</tr>	
		<tr height='30'>
		<td width='100%' align='center' >
			<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doEdit()'>
		</td>
	</tr>
	</table> 
</form>
</body>
<script LANGUAGE="javascript">
	
function doEdit()
{		
	if(Card_Images.file.value.Trim().length > 0)
  {
  	if(Card_Images.file.value.indexOf('.jpg') == -1 )  	
		{
			alert('请确认图片格式,支持.jpg格式!');
			return;
		}
  }									
	if(confirm('信息无误,确定提交?'))
  { 	
		Card_Images.submit();
  }	
}



</script>
</html>