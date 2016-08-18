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
	ArrayList Spa_Station_L      = (ArrayList)session.getAttribute("Spa_Station_L_" + Sid);
	UserInfoBean UserInfo        = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	String ManageId = UserInfo.getManage_Role();
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  
%>
<body style="background:#CADFFF">
<form name="Spa_Store_L_Fix2" action="Spa_Station_L.do" method="post" target="mFrame">
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
			<td width='25%' align='center'>本期结存</td>
			<td width='75%' align='left'>
				<input type='text' id="Now_R_Cnt" name="Now_R_Cnt" style="width:95%;height:16px" value="" maxlength=4>
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
		if(null != Spa_Station_L)
		{
			Iterator statiter = Spa_Station_L.iterator();
			while(statiter.hasNext())
			{
				SpaStationLBean stationBean = (SpaStationLBean)statiter.next();
				String type_Id        = stationBean.getSpa_Type();
				String type_Name      = stationBean.getSpa_Type_Name();
				String type_Mode      = stationBean.getSpa_Mode();
				String type_CTime     = stationBean.getCTime();
				String type_Now_R_Cnt = stationBean.getNow_R_Cnt();
				String type_Model     = stationBean.getModel();
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
					objOption.value = '<%=type_Id+"^"+type_Mode+"^"+type_CTime+"^"+type_Now_R_Cnt%>';
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
doChange(Spa_Store_L_Fix2.Cpm_Id.value);

function doChange2(pValue)
{
	document.getElementById('Now_R_Cnt').value = '';
	
	if(pValue.length > 0)
	{
		var List = pValue.split('^');
		document.getElementById('Now_R_Cnt').value = List[3];
	}
}

var reqFix = null;
function doEdit()
{
	if(Spa_Store_L_Fix2.Cpm_Id.value.length < 1)
	{
		alert("请选择场站!");
		return;
	}
	if(Spa_Store_L_Fix2.Spa_Type_Chg.value.length < 1)
	{
		alert("请选择备品备件!");
		return;
	}
	if(Spa_Store_L_Fix2.Now_R_Cnt.value.Trim().length < 1 || Spa_Store_L_Fix2.Now_R_Cnt.value < 0)
  {
  	alert("本期结存输入错误,可能的原因：\n\n  1.为空。\n\n  2.不是正值。");
		return;
  }
  for(var i=0; i<Spa_Store_L_Fix2.Now_R_Cnt.value.length; i++)
	{
		if(isNaN(Spa_Store_L_Fix2.Now_R_Cnt.value.charAt(i)))
	  {
	    alert("本期结存输入有误，请重新输入!");
	    return;
	  }
	}
	if(Spa_Store_L_Fix2.Memo.value.Trim().length < 1)
  {
   	alert('请填写调整原因');
   	return;
  }
	if(Spa_Store_L_Fix2.Memo.value.Trim().length > 128)
  {
    alert("调整原因描述过长，请简化!");
    return;
  }
  
  var Spa_Type = Spa_Store_L_Fix2.Spa_Type_Chg.value.split('^')[0];
  var Spa_Mode = Spa_Store_L_Fix2.Spa_Type_Chg.value.split('^')[1];
  var CTime    = Spa_Store_L_Fix2.Spa_Type_Chg.value.split('^')[2];
  if(confirm("信息无误，确认调整?"))
  {
  	if(window.XMLHttpRequest)
	  {
			reqFix = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqFix = new ActiveXObject("Microsoft.XMLHTTP");
		}		
		//设置回调函数
		reqFix.onreadystatechange = function()
		{
			var state = reqFix.readyState;
			if(state == 4)
			{
				if(reqFix.status == 200)
				{
					var resp = reqFix.responseText;
					if(resp != null && resp.substring(0,4) == '0000')
					{
						alert('成功');
						parent.doSelect();
						return;
					}
					else
					{
						alert('失败，请重新操作');
						return;
					}
				}
				else
				{
					alert("失败，请重新操作");
					return;
				}
			}
		};
		var url = "Spa_Station_L_Fix.do?Cmd=11&Sid=<%=Sid%>&Cpm_Id="+Spa_Store_L_Fix2.Cpm_Id.value
				    + "&Spa_Type="+Spa_Type
				    + "&Spa_Mode="+Spa_Mode
				    + "&CType=<%=currStatus.getFunc_Sel_Id()%>"
				    + "&CTime="+CTime
				    + "&Old_R_Cnt=0"
				    + "&Now_R_Cnt="+Spa_Store_L_Fix2.Now_R_Cnt.value.Trim()
				    + "&Memo="+Spa_Store_L_Fix2.Memo.value.Trim()
				    + "&Operator=<%=Operator%>"
						+ "&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>"
						+ "&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>"
						+ "&Func_Sel_Id=<%=currStatus.getFunc_Sel_Id()%>"
						+ "&currtime="+new Date();
		reqFix.open("post",url,true);
		reqFix.send(null);
		return true;
  }
}
</SCRIPT>
</html>