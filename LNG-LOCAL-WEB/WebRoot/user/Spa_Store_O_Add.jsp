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
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%

	String Sid   = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String BDate = CommUtil.getDate();
	
	CurrStatus currStatus        = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Spa_Store          = (ArrayList)session.getAttribute("Spa_Store_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
  UserInfoBean UserInfo        = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator      = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  String ManageId      = UserInfo.getManage_Role();
  String  Cpm_Id       = "";
  
%>
<body style="background:#CADFFF">
<form name="Spa_Store_O_Add" action="Spa_Store_O.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/spa_store_o_add.gif"></div><br><br><br>
	<div id="right_table_center">
		<table width="50%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			<tr height='30'>
				<td width='100%' align='right'>
					<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doAdd()'>
					<img src="../skin/images/button10.gif"           style='cursor:hand;' onclick='doNO()'>
				</td>
			</tr>
			<tr height='30'>
				<td width='100%' align='center'>
					<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">					
						<tr height='30'>
							<td width='25%' align='center'>备品备件</td>
							<td width='75%' align='left'>
								<select name="Spa_Type_Chg" style="width:250px;height:20px" onchange="doChange(this.value)">
								<%
								if(null != Spa_Store)
								{
									Iterator typeiter = Spa_Store.iterator();
									while(typeiter.hasNext())
									{
										SpaStoreBean typeBean = (SpaStoreBean)typeiter.next();
										String type_Id        = typeBean.getSpa_Type();
										String type_Name      = typeBean.getSpa_Type_Name();
										String type_I         = typeBean.getSpa_I_Cnt();
										String type_Mode      = typeBean.getSpa_Mode();
										String type_Model     = typeBean.getModel();
										String type_Mode_Name = "/";
										if(null != type_Model && type_Model.length() > 0)
										{
											String[] List = type_Model.split(",");
											if(List.length >= Integer.parseInt(type_Mode))
												type_Mode_Name = List[Integer.parseInt(type_Mode)-1];
										}
								%>
										<option value='<%=type_Id+","+type_Mode+","+type_I%>'><%=type_Name%>{型号:<%=type_Mode_Name%>}</option>
								<%
									}
								}
								%>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>出库日期</td>
							<td width='75%' align='left'>
								<input name='Spa_O_Time' type='text' style='width:248px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>去向场站</td>
							<td width='75%' align='left'>
								<select name='Spa_O_Stat' style='width:250px;height:20px'>
								<%
								String Role_List = "";
								if(ManageId.length() > 0 && null != User_Manage_Role)
								{
									Iterator iterator = User_Manage_Role.iterator();
									while(iterator.hasNext())
									{
										UserRoleBean statBean = (UserRoleBean)iterator.next();
										if(statBean.getId().substring(0,4).equals(ManageId) && statBean.getId().length() == 8)
										{
											String R_Point = statBean.getPoint();
											if(null == R_Point){R_Point = "";}
											Role_List += R_Point;
										}
									}
								}
								if(Role_List.length() > 0 && null != User_Device_Detail)
								{
									Iterator iterator = User_Device_Detail.iterator();
									while(iterator.hasNext())
									{
										DeviceDetailBean statBean = (DeviceDetailBean)iterator.next();
										if(Role_List.contains(statBean.getId()))
										{										
								%>
											<option value='<%=statBean.getId()%>'><%=statBean.getBrief()%></option>
								<%										
										}
									}
								}
								%>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>当前库存</td>
							<td width='75%' align='left' id='curr_I'>
								&nbsp;
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>出库数量</td>
							<td width='75%' align='left'>
								<input name='Spa_O_MCnt' type='text' style='width:248px;height:18px;' value='' maxlength=4>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>领用人员</td>
							<td width='75%' align='left'>
								<input name='Spa_O_Man' type='text' style='width:248px;height:18px;' value='' maxlength=10>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>出库备注</td>
							<td width='75%' align='left'>
								<textarea name='Spa_O_Memo' rows='5' cols='33' maxlength=128></textarea>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>录入人员</td>
							<td width='75%' align='left'>
								<%=Operator_Name%>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>
<input type="hidden" name="Cmd"          value="10">
<input type="hidden" name="Sid"          value="<%=Sid%>">
<input type="hidden" name="Spa_Type"     value="">
<input type="hidden" name="Spa_Mode"     value="">
<input type="hidden" name="Spa_O_BCnt"   value="">
<input type="hidden" name="Spa_O_ACnt"   value="">
<input type="hidden" name="Operator"     value="<%=Operator%>">
<input type="hidden" name="Cpm_Id"       value="">
<input type="hidden" name="BTime"        value="<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>">
<input type="hidden" name="ETime"        value="<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>">
<input type="hidden" name="CurrPage"     value="<%=currStatus.getCurrPage()%>">
<input type="hidden" name="Func_Corp_Id" value="<%=currStatus.getFunc_Corp_Id()%>">
<input type="hidden" name="Func_Sub_Id"  value="<%=currStatus.getFunc_Sub_Id()%>">
<input type="hidden" name="Func_Sel_Id"  value="<%=currStatus.getFunc_Sel_Id()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Spa_Store_O_Add.jsp';

function doNO()
{
	location = "Spa_Store_O.jsp?Sid=<%=Sid%>";
}

function doChange(pValue)
{
	if(pValue.length > 0)
	{
		document.getElementById('curr_I').innerHTML = pValue.split(',')[2];
	}
}
doChange(Spa_Store_O_Add.Spa_Type_Chg.value);

function doAdd()
{
  if(Spa_Store_O_Add.Spa_Type_Chg.value.length < 1)
  {
  	alert('请选择备品备件!');
  	return;
  }
	if(Spa_Store_O_Add.Spa_O_Time.value.length < 1)
  {
  	alert('请选择出库日期!');
  	return;
  }
  if(Spa_Store_O_Add.Spa_O_Stat.value.length < 1)
  {
  	alert('请选择去向场站!');
  	return;
  }
  if(Spa_Store_O_Add.Spa_O_MCnt.value.Trim().length < 1 || Spa_Store_O_Add.Spa_O_MCnt.value <= 0)
  {
  	alert("出库数量输入错误,可能的原因：\n\n  1.为空。\n\n  2.不是正值。");
		return;
  }
  for(var i=0; i<Spa_Store_O_Add.Spa_O_MCnt.value.length; i++)
	{
		if(isNaN(Spa_Store_O_Add.Spa_O_MCnt.value.charAt(i)))
	  {
	    alert("出库数量输入有误，请重新输入!");
	    return;
	  }
	}
	if(parseInt(Spa_Store_O_Add.Spa_O_MCnt.value) > parseInt(Spa_Store_O_Add.Spa_Type_Chg.value.split(',')[2]))
	{
		alert('出库数量超过当前库存总数量!');
		return;
	}
	if(Spa_Store_O_Add.Spa_O_Man.value.Trim().length < 1)
  {
  	alert('请填写领用人员!');
  	return;
  }
  if(Spa_Store_O_Add.Spa_O_Memo.value.Trim().length < 1)
  {
  	alert('请填写出库备注!');
  	return;
  }
  if(Spa_Store_O_Add.Spa_O_Memo.value.Trim().length > 128)
  {
    alert("出库备注描述过长，请简化!");
    return;
  }
  if(confirm("信息无误，确认提交?"))
  {
  	Spa_Store_O_Add.Cpm_Id.value = Spa_Store_O_Add.Spa_O_Stat.value;
  	Spa_Store_O_Add.Spa_Type.value = Spa_Store_O_Add.Spa_Type_Chg.value.split(',')[0];
  	Spa_Store_O_Add.Spa_Mode.value = Spa_Store_O_Add.Spa_Type_Chg.value.split(',')[1];
  	Spa_Store_O_Add.Spa_O_BCnt.value = Spa_Store_O_Add.Spa_Type_Chg.value.split(',')[2];
  	Spa_Store_O_Add.Spa_O_ACnt.value = parseInt(Spa_Store_O_Add.Spa_Type_Chg.value.split(',')[2]) - parseInt(Spa_Store_O_Add.Spa_O_MCnt.value.Trim());
		Spa_Store_O_Add.submit();
  }
}
</SCRIPT>
</html>