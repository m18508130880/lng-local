<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>ÖĞº£ÓÍLNG¼ÓÆøÕ¾¹«Ë¾¼¶ĞÅÏ¢»¯¹ÜÀíÆ½Ì¨</title>
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
	String PositionName = CommUtil.StrToGB2312(request.getParameter("PositionName"));
	String BDate        = CommUtil.getDate();
	String Dept_Id      = CommUtil.StrToGB2312(request.getParameter("Dept_Id"));
	CurrStatus currStatus     = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Cad_Status_Type = (ArrayList)session.getAttribute("Cad_Status_Type_" + Sid);
	UserInfoBean UserInfo     = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator      = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  String Card_Type_N   = "";
  if(null != Cad_Status_Type)
	{
		Iterator typeiter = Cad_Status_Type.iterator();
		while(typeiter.hasNext())
		{
			AqscCardTypeBean typeBean = (AqscCardTypeBean)typeiter.next();
			if(typeBean.getId().equals(Card_Type))
			{
				Card_Type_N = typeBean.getCName();
				break;
			}
		}
	}
%>
<body style="background:#CADFFF">
<form name="Cad_Status_Add" action="Cad_Status.do" method="post" target="mFrame">
<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
	<tr height='40'>
		<td width='15%' align='center'>ĞÕ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ãû</td>
		<td width='35%' align='left'>
			<%=CName%>
		</td>
		<td width='15%' align='center'>²¿&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ÃÅ</td>
		<td width='35%' align='left'>
		  <%=Dept_Name%>
		</td>
	</tr>
	<tr height='40'>
		<td width='15%' align='center'>¸Ú&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Î»</td>
		<td width='35%' align='left'>
			<%=PositionName%>
		</td>
		<td width='15%' align='center'>Ö¤¼şÀàĞÍ</td>
		<td width='35%' align='left'>
			<%=Card_Type_N%>
		</td>
	</tr>
	<tr height='40'>
		<td width='15%' align='center'>Ö¤¼ş±àºÅ</td>
		<td width='35%' align='left'>
			<input type='text' name='Card_Id' style='width:96%;height:16px;' value='' maxlength='32'>
		</td>
		<td width='15%' align='center'>·¢Ö¤ÈÕÆÚ</td>
		<td width='35%' align='left'>
		  <input name='Card_BTime' type='text' style='width:96%;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
		</td>
	</tr>
	<tr height='40'>
		<td width='15%' align='center'>¸´ÉóÄêÏŞ</td>
		<td width='35%' align='left'>
			<select name='Card_Review' style='width:98%;height:20px;'>
				<option value='1'>1Äê</option>
				<option value='2'>2Äê</option>
				<option value='3'>3Äê</option>
				<option value='4'>4Äê</option>
				<option value='5'>5Äê</option>
				<option value='6'>6Äê</option>
				<option value='7'>7Äê</option>
				<option value='8'>8Äê</option>
			</select>
		</td>
		<td width='15%' align='center'>Â¼ÈëÈËÔ±</td>
		<td width='35%' align='left'>
		  <%=Operator_Name%>¶
		</td>
	</tr
	
	<tr height='40'>
		<td width='100%' align='center' colspan=4>
			<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doAdd()'>
		</td>
	</tr>
</table>
<input name="Cmd"         type="hidden" value="10">
<input name="Sid"         type="hidden" value="<%=Sid%>">
<input name="UId"         type="hidden" value="<%=UId%>">
<input name="Sys_Id"      type="hidden" value="<%=Sys_Id%>">
<input name="Card_Type"   type="hidden" value="<%=Card_Type%>">
<input name="Operator"    type="hidden" value="<%=Operator%>">
<input name="Card_ETime"  type="hidden" value="">
<input name="Func_Sub_Id" type="hidden" value="<%=currStatus.getFunc_Sub_Id()%>">
<input name="Func_Type_Id"         type="hidden" value="<%=Dept_Id%>">
<input name="Func_Cpm_Id"         type="hidden" value="<%=Sys_Id%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doAdd()
{
  if(Cad_Status_Add.Card_Type.value.length < 1)
  {
    alert("ÇëÑ¡ÔñÖ¤¼şÀàĞÍ!");
    return;
  }
  if(Cad_Status_Add.Card_Id.value.Trim().length < 1)
  {
    alert("ÇëÌîĞ´Ö¤¼ş±àºÅ!");
    return;
  }
  if(Cad_Status_Add.Card_BTime.value.length < 1)
  {
    alert("ÇëÑ¡Ôñ·¢Ö¤ÈÕÆÚ!");
    return;
  }
  
  Cad_Status_Add.Card_ETime.value = (parseInt(Cad_Status_Add.Card_BTime.value.substring(0,4)) + parseInt(Cad_Status_Add.Card_Review.value)) + Cad_Status_Add.Card_BTime.value.substring(4,10);
  if(confirm("ĞÅÏ¢ÎŞÎó,È·¶¨Ìá½»?"))
  {
  	Cad_Status_Add.submit();
  }
}
</SCRIPT>
</html>