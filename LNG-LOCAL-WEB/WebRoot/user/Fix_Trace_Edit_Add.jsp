<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/util.js"></script>

</head>
<%
	
	String Sid      = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String Cpm_Id   = CommUtil.StrToGB2312(request.getParameter("Cpm_Id"));
	String Cpm_Name = CommUtil.StrToGB2312(request.getParameter("Cpm_Name"));
	String Index    = CommUtil.StrToGB2312(request.getParameter("Index"));
	ArrayList Spa_Store_All      = (ArrayList)session.getAttribute("Spa_Store_All_" + Sid);
	ArrayList Spa_Station_All    = (ArrayList)session.getAttribute("Spa_Station_All_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	ArrayList User_User_Info     = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
  UserInfoBean UserInfo        = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String ManageId = UserInfo.getManage_Role();
  
%>
<body style="background:#e0e6ed">
<form name="Fix_Trace_Edit_Add"  action="" method="post" target="_self">
	<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
		<!--tr height='30'>
			<td width='30%' align='center'>备件来源</td>
			<td width='70%' align='left'>
				<select name='From_Mode' style='width:95%;height:20px;' onchange='doChange(this.value)'>
					<option value='1'>维修队库存</option>
					
					<option value='2' selected>本站备用</option>
					<option value='3'>友站备用</option>					
					
				</select>
			</td>
		</tr>
		<tr height='30'>
			<td width='30%' align='center'>备件归属</td>
			<td width='70%' align='left' id='Spa_From'>
				&nbsp;
			</td>
		</tr-->
		<tr height='30'>
			<td width='30%' align='center'>备件名称</td>
			<td width='70%' align='left'>
				<select name='Spa_Info' style='width:95%;height:20px;'>
				<%
				if(null != Spa_Store_All)
				{
					Iterator storeiter = Spa_Store_All.iterator();
					while(storeiter.hasNext())
					{
						SpaStoreBean storeBean = (SpaStoreBean)storeiter.next();
						String Spa_Name = storeBean.getSpa_Type() + storeBean.getSpa_Mode();
						
				%>
						<option value='<%=Spa_Name%>'><%=Spa_Name%></option>
				<%
					}
				}
				%>
				</select>
			</td>
		</tr>
		<tr height='30'>
			<td width='30%' align='center'>耗品数量</td>
			<td width='70%' align='left'>
				<input type='text' name='Spa_Cnt' style='width:94%;height:16px;' value='' maxlength=4>
			</td>
		</tr>
		<tr height='40'>
			<td width='100%' align='center' colspan=2>
				<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doSave()'>
				<img src="../skin/images/button10.gif"           style='cursor:hand;' onclick='doNO()'>
			</td>
		</tr>
	</table>
	<input type='hidden' name='Cpm_Id' value='9999999999'>
	<input type='hidden' name='From_Mode' value='1'>
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doNO()
{
	parent.closeDiv();
}

function doChange(pMode)
{
	 /**switch(parseInt(pMode))
	{
		case 1://维修队
				document.getElementById('Spa_From').innerHTML = "维修队<input type='hidden' name='Cpm_Id' value='9999999999'>";
			break;
		case 2://本站
				document.getElementById('Spa_From').innerHTML = "<%=Cpm_Name%><input type='hidden' name='Cpm_Id' value='<%=Cpm_Id%>'>";
			break;
		case 3://友站
				var objHTML = "";
				objHTML += "<select name='Cpm_Id' style='width:95%;height:20px;'>";
				
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
						if(Role_List.contains(statBean.getId()) && !statBean.getId().equals(Cpm_Id))
						{
				%>
							objHTML += "<option value='<%=statBean.getId()%>'><%=statBean.getBrief()%></option>";
				<%
						}
					}
				}
				%>
				
				objHTML += "</select>";
				document.getElementById('Spa_From').innerHTML = objHTML;
			break;
			
	}**/
}
doChange(Fix_Trace_Edit_Add.From_Mode.value);

function doSave()
{
	if(Fix_Trace_Edit_Add.Cpm_Id.value.length < 1)
	{
		alert('请选择备件来源!');
		return;
	}
	if(Fix_Trace_Edit_Add.Spa_Info.value.length < 1)
	{
		alert('请选择备件名称!');
		return;
	}
	if(Fix_Trace_Edit_Add.Spa_Cnt.value.Trim().length < 1 || Fix_Trace_Edit_Add.Spa_Cnt.value <= 0)
  {
  	alert("耗品数量输入错误,可能的原因：\n\n  1.为空。\n\n  2.不是正值。");
		return;
  }
  for(var i=0; i<Fix_Trace_Edit_Add.Spa_Cnt.value.length; i++)
	{
		if(isNaN(Fix_Trace_Edit_Add.Spa_Cnt.value.charAt(i)))
	  {
	    alert("耗品数量输入有误，请重新输入!");
	    return;
	  }
	}
	
	var str_Value = Fix_Trace_Edit_Add.Spa_Info.value 
	              + ',' 
	              + Fix_Trace_Edit_Add.Cpm_Id.value 
	              + ',' 
	              + Fix_Trace_Edit_Add.Spa_Cnt.value;
	
	var Spa_From_Name = '';
	switch(parseInt(Fix_Trace_Edit_Add.From_Mode.value))
	{
		case 1:
				Spa_From_Name = '维修队库存';
			break;
		/**case 2:
				Spa_From_Name = '<%=Cpm_Name%>备用';
			break;
		case 3:
				Spa_From_Name = Fix_Trace_Edit_Add.Cpm_Id.options[Fix_Trace_Edit_Add.Cpm_Id.selectedIndex].text + '备用';
			break;**/
	}
	
	//var Spa_Type_Name = Fix_Trace_Edit_Add.Spa_Info.options[Fix_Trace_Edit_Add.Spa_Info.selectedIndex].text.split(']')[0].substring(1);
	//var Spa_Mode_Name = Fix_Trace_Edit_Add.Spa_Info.options[Fix_Trace_Edit_Add.Spa_Info.selectedIndex].text.split(']')[1].substring(1);
	
	var str_CName = (parseInt(<%=Index%>)+1) + '、' + '[' + Fix_Trace_Edit_Add.Spa_Info.value  + '] '  + '[' + Fix_Trace_Edit_Add.Spa_Cnt.value.Trim() + '] ' ;
	
	parent.document.getElementById('ConD<%=Index%>').innerHTML = "<img src='../skin/images/cmddel.gif' style='cursor:hand;' title='耗品删除' onclick=\"doSpaDel('<%=Index%>')\">"
																														 + "&nbsp;"
	                                                    			 + str_CName
	                                                    			 + "<input type='hidden' id='ConDValue<%=Index%>' name='ConDValue<%=Index%>' value='"+str_Value+"'>";
	parent.document.getElementById('ConD<%=Index%>').style.display = '';
	parent.closeDiv();
}
</SCRIPT>
</html>