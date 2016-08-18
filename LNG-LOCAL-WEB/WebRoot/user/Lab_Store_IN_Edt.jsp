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
</head>
<%

	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));	
	
	CurrStatus currStatus  = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  UserInfoBean UserInfo  = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator        = UserInfo.getId();
  String Operator_Name   = UserInfo.getCName();
	String IN_Date         = CommUtil.getDate();
	String Lab_I_Cnt       = "";
	String SN              = "";
	String IN_Cnt          = "";
	ArrayList Lab_Store_IN   = (ArrayList)session.getAttribute("Lab_Store_IN_" + Sid);
					if(Lab_Store_IN != null)
					{
						Iterator iterator = Lab_Store_IN.iterator();
						while(iterator.hasNext())
						{
							LabStoreIBean Bean = (LabStoreIBean)iterator.next();
							 SN                = Bean.getSN();
							 Lab_I_Cnt         = Bean.getLab_I_Cnt();	
							 IN_Cnt            = Bean.getIN_Cnt();					
								}      
							}             
%>
<body style="background:#CADFFF">
<form name="Lab_Store_IN_Edt" action="Lab_Store_I.do" method="post" target="mFrame">
	<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='40'>
			<td width='25%' align='center'>交货单号</td>
			<td width='75%' align='left'>
				<input name='IN_Numb' type='text' style='width:248px;height:18px;' value='' maxlength=20>
			</td>
		</tr>
		<tr height='40'>
			<td width='25%' align='center'>交货数量</td>
			<td width='75%' align='left'>
				<input name='AD_IN_Cnt'  type='text' style='width:248px;height:18px;' value='' maxlength=4>
			</td>
		</tr>
		<tr height='40'>
			<td width='25%' align='center'>交货日期</td>
			<td width='75%' align='left'>
				<input name='IN_Date' type='text' style='width:248px;height:18px;' value='<%=IN_Date%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
			</td>
		</tr>
		<tr height='40'>
			<td width='25%' align='center'>经办人员</td>
			<td width='75%' align='left'>
				<%=Operator_Name%>
			</td>
		</tr>
		<tr height='40'>
			<td width='100%' align='center' colspan=2>
				<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doEdit()'>
			</td>
		</tr>
	</table>
	<input type="hidden" name="Cmd"       value="14">
	<input type="hidden" name="Sid"       value="<%=Sid%>">
	<input type="hidden" name="SN"        value="<%=SN%>">
	<input type="hidden" name="IN_Oper"   value="<%=Operator%>">
	<input type="hidden" name="IN_Status" value="">
	<input type="hidden" name="IN_Cnt"    value="">
	<input type="hidden" name="BTime"     value="<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>">
	<input type="hidden" name="ETime"     value="<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>">
	<input type="hidden" name="CurrPage"  value="<%=currStatus.getCurrPage()%>">
	<input type="hidden" name="Func_Corp_Id" value="<%=currStatus.getFunc_Corp_Id()%>">
	<input type="hidden" name="Func_Sub_Id"  value="<%=currStatus.getFunc_Sub_Id()%>">
	<input type="hidden" name="Func_Type_Id" value="<%=currStatus.getFunc_Type_Id()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doEdit()
{
	if(Lab_Store_IN_Edt.IN_Numb.value.Trim().length < 1)
  {
  	alert('请填写交货单号!');
  	return;
  }
  if(Lab_Store_IN_Edt.AD_IN_Cnt.value.Trim().length < 1 || Lab_Store_IN_Edt.AD_IN_Cnt.value <= 0)
  {
  	alert("交货数量输入错误,可能的原因：\n\n  1.为空。\n\n  2.不是正值。");
		return;
  }
  for(var i=0; i<Lab_Store_IN_Edt.AD_IN_Cnt.value.length; i++)
	{
		if(isNaN(Lab_Store_IN_Edt.AD_IN_Cnt.value.charAt(i)))
	  {
	    alert("交货数量输入有误，请重新输入!");
	    return;
	  }
	}
	
	if(Lab_Store_IN_Edt.IN_Date.value.length < 1)
  {
  	alert('请选择交货日期!');
  	return;
  }
	if(confirm("信息无误，确认提交?"))
  {
  	//Lab_Store_IN_Edt.Cpm_Id.value = parent.window.parent.frames.lFrame.document.getElementById('id').value;
  	var stat = "";
  	if(0 < <%=Lab_I_Cnt%> -  <%=IN_Cnt%> -  document.getElementById('AD_IN_Cnt').value )
  	{
  		stat = 0;
  	}else if(0 ==( <%=Lab_I_Cnt%> -  <%=IN_Cnt%> - document.getElementById('AD_IN_Cnt').value) )
  	{
  		stat = 1;
  	}else{  alert("输入数量有误");return;}
  				
  	Lab_Store_IN_Edt.IN_Status.value = stat;	
  	Lab_Store_IN_Edt.IN_Cnt.value =  parseInt(<%=IN_Cnt%>) +  parseInt(document.getElementById('AD_IN_Cnt').value);
		Lab_Store_IN_Edt.submit();
  }
}
</SCRIPT>
</html>