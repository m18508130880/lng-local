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
<script type="text/javascript" src="../skin/js/util.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%

	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus        = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	ArrayList Spa_Station        = (ArrayList)session.getAttribute("Spa_Station_" + Sid);
	UserInfoBean UserInfo        = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	String ManageId = UserInfo.getManage_Role();
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  
%>
<body style="background:#CADFFF">
<form name="Spa_Store_Fix2" action="Spa_Station.do" method="post" target="mFrame">
	<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">					
		<tr height='30'>
			<td width='25%' align='center'>场站名称</td>
			<td width='75%' align='left'>
				<select name='Cpm_Id' style='width:96%;height:20px' onchange="doChange(this.value)">
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
			<td width='25%' align='center'>备品备件</td>
			<td width='75%' align='left'>
				<select id="Spa_Type_Chg" name="Spa_Type_Chg" style="width:96%;height:20px" onchange="doChange2(this.value)">
				</select>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>备用数量</td>
			<td width='75%' align='left'>
				<input type='text' id="Spa_I_Cnt" name="Spa_I_Cnt" style="width:95%;height:16px" value="" maxlength=4>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>在用数量</td>
			<td width='75%' align='left'>
				<input type='text' id="Spa_O_Cnt" name="Spa_O_Cnt" style="width:95%;height:16px" value="" maxlength=4>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>报废数量</td>
			<td width='75%' align='left'>
				<input type='text' id="Spa_S_Cnt" name="Spa_S_Cnt" style="width:95%;height:16px" value="" maxlength=4>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>调整原因</td>
			<td width='75%' align='left'>
				<textarea name='Memo' rows='3' cols='48' maxlength=128></textarea>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>调整人员</td>
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
	<input type="hidden" name="Cmd"      value="13">
	<input type="hidden" name="Sid"      value="<%=Sid%>">
	<input type="hidden" name="Spa_Type" value="">
	<input type="hidden" name="Spa_Mode" value="">
	<input type="hidden" name="Operator" value="<%=Operator%>">
	<input type="hidden" name="Func_Corp_Id" value="<%=currStatus.getFunc_Corp_Id()%>">
	<input type="hidden" name="Func_Sub_Id"  value="<%=currStatus.getFunc_Sub_Id()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doChange(pCpm_Id)
{
	//先删除
	var length = document.getElementById('Spa_Type_Chg').length;
	for(var i=0; i<length; i++)
	{
		document.getElementById('Spa_Type_Chg').remove(0);
	}
	
	//再添加
	if(pCpm_Id.length > 0)
	{
		var i = 0;
		<%
		if(null != Spa_Station)
		{
			Iterator statiter = Spa_Station.iterator();
			while(statiter.hasNext())
			{
				SpaStationBean stationBean = (SpaStationBean)statiter.next();
				String type_Id    = stationBean.getSpa_Type();
				String type_Name  = stationBean.getSpa_Type_Name();
				String type_Mode  = stationBean.getSpa_Mode();
				String type_I_Cnt = stationBean.getSpa_I_Cnt();
				String type_O_Cnt = stationBean.getSpa_O_Cnt();
				String type_S_Cnt = stationBean.getSpa_S_Cnt();
				String type_Model = stationBean.getModel();										
				String type_Mode_Name = "/";
				if(null != type_Model && type_Model.length() > 0)
				{
					String[] List = type_Model.split(",");
					if(List.length >= Integer.parseInt(type_Mode))
						type_Mode_Name = List[Integer.parseInt(type_Mode)-1];
				}
		%>
				if('<%=stationBean.getCpm_Id()%>' == pCpm_Id)
				{
					i++;
					var objOption = document.createElement('OPTION');
					objOption.value = '<%=type_Id+"^"+type_Mode+"^"+type_I_Cnt+"^"+type_O_Cnt+"^"+type_S_Cnt%>';
					objOption.text  = '<%=type_Name%>' + '{型号:' + '<%=type_Mode_Name%>' + '}';
					document.getElementById('Spa_Type_Chg').add(objOption);
					if(1 == i)
					{
						doChange2(objOption.value);
					}
				}
		<%
			}
		}
		%>
	}
}
doChange(Spa_Store_Fix2.Cpm_Id.value);

function doChange2(pValue)
{
	document.getElementById('Spa_I_Cnt').value = '';
	document.getElementById('Spa_O_Cnt').value = '';
	document.getElementById('Spa_S_Cnt').value = '';
	
	if(pValue.length > 0)
	{
		var List = pValue.split('^');
		document.getElementById('Spa_I_Cnt').value = List[2];
		document.getElementById('Spa_O_Cnt').value = List[3];
		document.getElementById('Spa_S_Cnt').value = List[4];
	}
}

function doEdit()
{
	if(Spa_Store_Fix2.Cpm_Id.value.length < 1)
	{
		alert("请选择场站!");
		return;
	}
	if(Spa_Store_Fix2.Spa_Type_Chg.value.length < 1)
	{
		alert("请选择备品备件!");
		return;
	}
	if(Spa_Store_Fix2.Spa_I_Cnt.value.Trim().length < 1 || Spa_Store_Fix2.Spa_I_Cnt.value < 0)
  {
  	alert("备用数量输入错误,可能的原因：\n\n  1.为空。\n\n  2.不是正值。");
		return;
  }
  for(var i=0; i<Spa_Store_Fix2.Spa_I_Cnt.value.length; i++)
	{
		if(isNaN(Spa_Store_Fix2.Spa_I_Cnt.value.charAt(i)))
	  {
	    alert("备用数量输入有误，请重新输入!");
	    return;
	  }
	}
	if(Spa_Store_Fix2.Spa_O_Cnt.value.Trim().length < 1 || Spa_Store_Fix2.Spa_O_Cnt.value < 0)
  {
  	alert("在用数量输入错误,可能的原因：\n\n  1.为空。\n\n  2.不是正值。");
		return;
  }
  for(var i=0; i<Spa_Store_Fix2.Spa_O_Cnt.value.length; i++)
	{
		if(isNaN(Spa_Store_Fix2.Spa_O_Cnt.value.charAt(i)))
	  {
	    alert("在用数量输入有误，请重新输入!");
	    return;
	  }
	}
	if(Spa_Store_Fix2.Spa_S_Cnt.value.Trim().length < 1 || Spa_Store_Fix2.Spa_S_Cnt.value < 0)
  {
  	alert("报废数量输入错误,可能的原因：\n\n  1.为空。\n\n  2.不是正值。");
		return;
  }
  for(var i=0; i<Spa_Store_Fix2.Spa_S_Cnt.value.length; i++)
	{
		if(isNaN(Spa_Store_Fix2.Spa_S_Cnt.value.charAt(i)))
	  {
	    alert("报废数量输入有误，请重新输入!");
	    return;
	  }
	}
	if(Spa_Store_Fix2.Memo.value.Trim().length < 1)
  {
   	alert('请填写调整原因');
   	return;
  }
	if(Spa_Store_Fix2.Memo.value.Trim().length > 128)
  {
    alert("调整原因描述过长，请简化!");
    return;
  }
  if(confirm("信息无误，确认提交?"))
  {
  	Spa_Store_Fix2.Spa_Type.value = Spa_Store_Fix2.Spa_Type_Chg.value.split('^')[0];
  	Spa_Store_Fix2.Spa_Mode.value = Spa_Store_Fix2.Spa_Type_Chg.value.split('^')[1];
		Spa_Store_Fix2.submit();
  }
}
</SCRIPT>
</html>