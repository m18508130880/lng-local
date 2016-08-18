<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<%@ taglib uri="/WEB-INF/limitvalidatetag.tld" prefix="Limit"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/util.js"></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%

	String Sid          = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String UId          = CommUtil.StrToGB2312(request.getParameter("UId"));
	String Sys_Id       = CommUtil.StrToGB2312(request.getParameter("Sys_Id"));
	String Card_Type    = CommUtil.StrToGB2312(request.getParameter("Card_Type"));
	String CName        = CommUtil.StrToGB2312(request.getParameter("CName"));
	String Dept_Name    = CommUtil.StrToGB2312(request.getParameter("Dept_Name"));
	String Dept_Id    = CommUtil.StrToGB2312(request.getParameter("Dept_Id"));
	String PositionName = CommUtil.StrToGB2312(request.getParameter("PositionName"));
	
	CurrStatus currStatus  = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Cad_Status   = (ArrayList)session.getAttribute("Cad_Status_" + Sid);
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo  = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator        = UserInfo.getId();
  String Operator_Name   = UserInfo.getCName();
  String FpId            = UserInfo.getFp_Role();
	String FpList          = "";
	if(null != FpId && FpId.length() > 0 && null != User_FP_Role)
	{
		Iterator roleiter = User_FP_Role.iterator();
		while(roleiter.hasNext())
		{
			UserRoleBean roleBean = (UserRoleBean)roleiter.next();
			if(roleBean.getId().equals(FpId) && null != roleBean.getPoint())
			{
				FpList = roleBean.getPoint();
			}
		}
	}
	
	String Card_Type_Name = "";
	String Card_Id        = "";
	String Card_BTime     = "";
	String Card_ETime     = "";
	String Card_Review    = "";
	if(Cad_Status != null)
	{
		Iterator iterator = Cad_Status.iterator();
		while(iterator.hasNext())
		{
			CadStatusBean Bean = (CadStatusBean)iterator.next();
			if(Bean.getSys_Id().equals(Sys_Id) && Bean.getCard_Type().equals(Card_Type))
		  {
		  	Card_Type_Name = Bean.getCard_Type_Name();
		  	Card_Id = Bean.getCard_Id();
		  	Card_BTime = Bean.getCard_BTime();
		  	Card_ETime = Bean.getCard_ETime();
		  	Card_Review = Bean.getCard_Review();
		  }
		}
	}
	
%>
<body style="background:#CADFFF">
<form name="Cad_Status_Edt" action="Cad_Status.do" method="post" target="mFrame">
<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
	<tr height='40'>
		<td width='15%' align='center'>姓&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名</td>
		<td width='35%' align='left'>
			<%=CName%>
		</td>
		<td width='15%' align='center'>部&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;门</td>
		<td width='35%' align='left'>
		  <%=Dept_Name%>
		</td>
	</tr>
	<tr height='40'>
		<td width='15%' align='center'>岗&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;位</td>
		<td width='35%' align='left'>
			<%=PositionName%>
		</td>
		<td width='15%' align='center'>证件类型</td>
		<td width='35%' align='left'>
			<%=Card_Type_Name%>
		</td>
	</tr>
	<tr height='40'>
		<td width='15%' align='center'>证件编号</td>
		<td width='35%' align='left'>
			<input type='text' name='Card_Id' style='width:96%;height:16px;' value='<%=Card_Id%>' maxlength='32'>
		</td>
		<td width='15%' align='center'>发证日期</td>
		<td width='35%' align='left'>
		  <input name='Card_BTime' type='text' style='width:96%;height:18px;' value='<%=Card_BTime%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
		</td>
	</tr>
	<tr height='40'>
		<td width='15%' align='center'>复审年限</td>
		<td width='35%' align='left'>
			<select name='Card_Review' style='width:98%;height:20px;'>
				<option value='1' <%=Card_Review.equals("1")?"selected":""%>>1年</option>
				<option value='2' <%=Card_Review.equals("2")?"selected":""%>>2年</option>
				<option value='3' <%=Card_Review.equals("3")?"selected":""%>>3年</option>
				<option value='4' <%=Card_Review.equals("4")?"selected":""%>>4年</option>
				<option value='5' <%=Card_Review.equals("5")?"selected":""%>>5年</option>
				<option value='6' <%=Card_Review.equals("6")?"selected":""%>>6年</option>
				<option value='7' <%=Card_Review.equals("7")?"selected":""%>>7年</option>
				<option value='8' <%=Card_Review.equals("8")?"selected":""%>>8年</option>
			</select>
		</td>
		<td width='15%' align='center'>录入人员</td>
		<td width='35%' align='left'>
		  <%=Operator_Name%>
		</td>
	</tr>
	<tr height='40'>
		<td width='100%' align='center' colspan=4>
			<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doAdd()'>
		</td>
	</tr>
</table>
<input name="Cmd"         type="hidden" value="11">
<input name="Sid"         type="hidden" value="<%=Sid%>">
<input name="UId"         type="hidden" value="<%=UId%>">
<input name="Sys_Id"      type="hidden" value="<%=Sys_Id%>">
<input name="Card_Type"   type="hidden" value="<%=Card_Type%>">
<input name="Func_Type_Id"   type="hidden" value="<%=Dept_Id%>">
<input name="Func_Cpm_Id"      type="hidden" value="<%=Sys_Id%>">
<input name="Operator"    type="hidden" value="<%=Operator%>">
<input name="Card_ETime"  type="hidden" value="">
<input name="Func_Sub_Id" type="hidden" value="<%=currStatus.getFunc_Sub_Id()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doAdd()
{
	/**if('<Limit:limitValidate userrole='<%=FpList%>' fpid='100104' ctype='1'/>' == 'none')
	{
		alert('您无权限修改证件信息!');
		return;
	}**/
  if(Cad_Status_Edt.Card_Id.value.Trim().length < 1)
  {
    alert("请填写证件编号!");
    return;
  }
  if(Cad_Status_Edt.Card_BTime.value.length < 1)
  {
    alert("请选择发证日期!");
    return;
  }
  
  Cad_Status_Edt.Card_ETime.value = (parseInt(Cad_Status_Edt.Card_BTime.value.substring(0,4)) + parseInt(Cad_Status_Edt.Card_Review.value)) + Cad_Status_Edt.Card_BTime.value.substring(4,10);
  if(confirm("信息无误,确定提交?"))
  {
  	Cad_Status_Edt.submit();
  }
}
</SCRIPT>
</html>