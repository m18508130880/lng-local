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
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	Date date1 = new Date();
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String CTime = formatter.format(date1);
	String Sid       = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String Operator  = CommUtil.StrToGB2312(request.getParameter("Operator"));
	String Cpm_Id    = CommUtil.StrToGB2312(request.getParameter("Cpm_Id"));
	String Cpm_Name  = CommUtil.StrToGB2312(request.getParameter("Cpm_Name"));
	String Oil_CType = CommUtil.StrToGB2312(request.getParameter("Oil_CType"));
	String Value_Ware= CommUtil.StrToGB2312(request.getParameter("Value_Ware"));
	String Value_Plan = CommUtil.StrToGB2312(request.getParameter("Value_Plan"));									
	String Status = CommUtil.StrToGB2312(request.getParameter("Status"));
	String Tank_No = CommUtil.StrToGB2312(request.getParameter("Tank_No"));
	String Value = CommUtil.StrToGB2312(request.getParameter("Value"));
	String PUnit      = CommUtil.StrToGB2312(request.getParameter("PUnit"));
	String WUnit      = CommUtil.StrToGB2312(request.getParameter("WUnit"));
	String VUnit      = CommUtil.StrToGB2312(request.getParameter("VUnit"));
	String Oil_CName = "";
	
	CurrStatus currStatus  = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	CorpInfoBean Corp_Info = (CorpInfoBean)session.getAttribute("User_Corp_Info_" + Sid);
	String Oil_Info = "";
	if(null != Corp_Info)
	{
		Oil_Info = Corp_Info.getOil_Info();
		if(null != Oil_Info && Oil_Info.trim().length() > 0)
		{
		  String[] List = Oil_Info.split(";");
		  for(int i=0; i<List.length && List[i].length()>0; i++)
		  {
		  	String[] subList = List[i].split(",");
		  	if(subList[0].equals(Oil_CType))
		  	{
		  		Oil_CName = subList[1];
		  		break;
		  	}
		  }
		}
	}
	
%>
<body style="background:#CADFFF">
<form name="Pro_R_Value_Plan" action="Pro_R.do" method="post" target="mFrame">
	<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='30'>
			<td width='25%' align='center'>վ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</td>
			<td width='75%' align='left'>
				<%=Cpm_Name%>
				<input type='hidden' name='Cpm_Id' value='<%=Cpm_Id%>'>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>ȼ������</td>
			<td width='75%' align='left'>
				<%=Oil_CName%>
				<input type='hidden' name='Oil_CType' value='<%=Oil_CType%>'>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>ж���ƻ�</td>
			<td width='75%' align='left'>
				<input type='text' name='Value_Plan' value='<%=Value_Plan%>' style='width:120px;height:16px;' maxlength=10> <%=PUnit%>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>��ǰ���</td>
			<td width='75%' align='left'>
				<input type='text' name='Value' value='<%=Value%>' style='width:120px;height:16px;' maxlength=10> 				
				<%=VUnit%>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>Ԥ����ֵ</td>
			<td width='75%' align='left'>
				<input type='text' name='Value_Ware' value='<%=Value_Ware%>' style='width:120px;height:16px;' maxlength=10> <%=WUnit%>
			</td>
		</tr>
		<tr height='40'>
			<td width='100%' align='center' colspan=2>
				<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doSave()'>
			</td>
		</tr>
	</table>
	<input type='hidden' name='Cmd' value='13'>
	<input name="Sid"       type="hidden"   value="<%=Sid%>">
	<input type='hidden' name='Status' value='<%=Status%>'>
	<input type='hidden' name='Tank_No' value='<%=Tank_No%>'>
	<input type='hidden' name='CTime' value='<%=CTime%>'>
	<input type='hidden' name='PUnit' value='<%=PUnit%>'>
	<input type='hidden' name='VUnit' value='<%=VUnit%>'>
	<input type='hidden' name='WUnit' value='<%=WUnit%>'>
	<input type='hidden' name='Operator'     value='<%=Operator%>'>
	<input type='hidden' name='Func_Corp_Id' value='<%=currStatus.getFunc_Corp_Id()%>'>
	<input type='hidden' name='Func_Sub_Id'  value='<%=currStatus.getFunc_Sub_Id()%>'>
	<input type='hidden' name='Func_Sel_Id'  value='<%=currStatus.getFunc_Sel_Id()%>'>
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doSave()
{
	if(Pro_R_Value_Plan.Value_Plan.value.Trim().length < 1 || Pro_R_Value_Plan.Value_Plan.value < 0)
  {
  	alert("��ǰж���ƻ�����,���ܵ�ԭ��\n\n  1.����Ϊ�ա�\n\n  2.����������ֵ��");
		return;
  }
	for(var i=0; i<Pro_R_Value_Plan.Value_Plan.value.length; i++)
	{
		if(Pro_R_Value_Plan.Value_Plan.value.charAt(0) == '.' || Pro_R_Value_Plan.Value_Plan.value.charAt(Pro_R_Value_Plan.Value_Plan.value.length-1) == '.')
		{
			alert("���뵱ǰж���ƻ���������������!");
	    return;
		}
		if(Pro_R_Value_Plan.Value_Plan.value.charAt(i) != '.' && isNaN(Pro_R_Value_Plan.Value_Plan.value.charAt(i)))
	  {
	    alert("���뵱ǰж���ƻ���������������!");
	    return;
	  }
	}
	if(Pro_R_Value_Plan.Value_Plan.value.indexOf(".") != -1)
	{
		if(Pro_R_Value_Plan.Value_Plan.value.substring(Pro_R_Value_Plan.Value_Plan.value.indexOf(".")+1,Pro_R_Value_Plan.Value_Plan.value.length).length >2)
		{
			alert("С��������ֻ��������λ!");
			return;
		}
	}
	if(Pro_R_Value_Plan.Value_Ware.value.Trim().length < 1 || Pro_R_Value_Plan.Value_Ware.value < 0)
  {
  	alert("��ǰж���ƻ�����,���ܵ�ԭ��\n\n  1.����Ϊ�ա�\n\n  2.����������ֵ��");
		return;
  }
	for(var i=0; i<Pro_R_Value_Plan.Value_Ware.value.length; i++)
	{
		if(Pro_R_Value_Plan.Value_Ware.value.charAt(0) == '.' || Pro_R_Value_Plan.Value_Ware.value.charAt(Pro_R_Value_Plan.Value_Ware.value.length-1) == '.')
		{
			alert("���뵱ǰж���ƻ���������������!");
	    return;
		}
		if(Pro_R_Value_Plan.Value_Ware.value.charAt(i) != '.' && isNaN(Pro_R_Value_Plan.Value_Ware.value.charAt(i)))
	  {
	    alert("���뵱ǰж���ƻ���������������!");
	    return;
	  }
	}
	if(Pro_R_Value_Plan.Value_Ware.value.indexOf(".") != -1)
	{
		if(Pro_R_Value_Plan.Value_Ware.value.substring(Pro_R_Value_Plan.Value_Ware.value.indexOf(".")+1,Pro_R_Value_Plan.Value_Ware.value.length).length >2)
		{
			alert("С��������ֻ��������λ!");
			return;
		}
	}
	if(confirm('ȷ����ƫ[��ǰվ��][��ǰȼ��]�Ŀ����������Ԥ����ֵ?'))
	{
		Pro_R_Value_Plan.submit();
	}
}
</SCRIPT>
</html>