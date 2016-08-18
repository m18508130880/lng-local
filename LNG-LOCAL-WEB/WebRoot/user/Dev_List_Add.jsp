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
	
	String Sid   = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String BDate = CommUtil.getDate();
	
	CurrStatus currStatus        = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Dev_List_Breed     = (ArrayList)session.getAttribute("Dev_List_Breed_" + Sid);
	ArrayList Dev_List_Type      = (ArrayList)session.getAttribute("Dev_List_Type_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
  UserInfoBean UserInfo        = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String ManageId = UserInfo.getManage_Role();
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
								String Dept_Id = UserInfo.getDept_Id();
								if(Dept_Id.length()>3){Role_List = Dept_Id; }
%>
<body style="background:#CADFFF">
<form name="Dev_List_Add" action="Dev_List.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/dev_list_add.gif"></div><br><br><br>
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
					<table id='table_2' width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
						<tr height='30'>
							<td width='25%' align='center'>场站名称</td>
							<td width='75%' align='center'>
								<select name="Cpm_Id" style="width:91%;height:20px">
								<%								
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
							<td width='25%' align='center'>设备品种</td>
							<td width='75%' align='center'>
								<select name="CType" style="width:91%;height:20px" onchange="doChange(this.value)">
								<%
								if(null != Dev_List_Breed)
								{
									Iterator breediter = Dev_List_Breed.iterator();
									while(breediter.hasNext())
									{
										AqscDeviceBreedBean breedBean = (AqscDeviceBreedBean)breediter.next();
								%>
										<option value='<%=breedBean.getId()%>'><%=breedBean.getCName()%></option>
								<%
									}
								}
								%>
							</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>设备类型</td>
							<td width='75%' align='center'>
								<select id="Dev_Type" name="Dev_Type" style="width:91%;height:20px" onchange="toChange()">
								
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>设备名称</td>
							<td width='75%' align='center'>
								<input type='text' name='Dev_Name' style="width:90%;height:16px" value='' maxlength=32>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>设备位号</td>
							<td width='75%' align='center'>
								<input type='text' name='Dev_Id' style="width:90%;height:16px" value='' maxlength=20>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>设备状态</td>
							<td width='75%' align='center'>
								<input type='text' name='Dev_Zhuangtai' style="width:90%;height:16px" value='' maxlength=20>
							</td>
						</tr>										
						<tr height='30'>
							<td width='25%' align='center'>出产日期</td>
							<td width='75%' align='center'>
								<input type='text' name='Dev_Date' style='width:91%;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>
<input type="hidden" name="Cmd"    value="10">
<input type="hidden" name="Sid"    value="<%=Sid%>">
<input type="hidden" name="Dev_Wendang"    value=" ">
<input type="hidden" name="Dev_ShuXing"    value="">
<input type="hidden" name="Func_Corp_Id" value="<%=currStatus.getFunc_Corp_Id()%>">
<input type="hidden" name="Func_Sel_Id" value="<%=currStatus.getFunc_Sel_Id()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Dev_List_Add.jsp';
var list_str = '';
function doNO()
{
	location = "Dev_List.jsp?Sid=<%=Sid%>";
}

function doChange(pCType)
{
	//先删除
	var length = document.getElementById('Dev_Type').length;
	for(var i=0; i<length; i++)
	{
		document.getElementById('Dev_Type').remove(0);
	}
	
	//再添加
	if(pCType.length > 0)
	{
		<%
		if(null != Dev_List_Type)
		{
			Iterator typeiter = Dev_List_Type.iterator();
			while(typeiter.hasNext())
			{
				AqscDeviceTypeBean typeBean = (AqscDeviceTypeBean)typeiter.next();
		%>
				if('<%=typeBean.getStatus()%>' == '0' && '<%=typeBean.getCType()%>' == pCType)
				{
					var objOption = document.createElement('OPTION');
					objOption.value = '<%=typeBean.getId()%>';
					objOption.text  = '<%=typeBean.getCName()%>';
					document.getElementById('Dev_Type').add(objOption);
				}
		<%
			}
		}
		%>
	}
	toChange();
}
doChange(Dev_List_Add.CType.value);

function toChange()
{
	var str = ""
	var tab = document.getElementById("table_2"); 
	var len = tab.rows.length; 	
	if(len >7)
	{
		for(var a =0;a <len-7;a++)
		{
			tab.deleteRow(7);    
		}
	}
<%
	if(null != Dev_List_Type)
	{
		Iterator typeit = Dev_List_Type.iterator();
		while(typeit.hasNext())
		{
			AqscDeviceTypeBean tBean = (AqscDeviceTypeBean)typeit.next();
			String Dev_Id = tBean.getId();
			String Str_List = tBean.getDes();
			if(Str_List.trim().length() > 0)
			{
%>
				if("<%=Dev_Id%>" == Dev_List_Add.Dev_Type.value)
				{
	<%
					String[] SubList = Str_List.split(",");
					for(int i = 0; i<SubList.length && SubList[i].length()>0; i++)
					{
	%>								
						var aRow = tab.insertRow(7+<%=i%>);  
						aRow.insertCell(0).innerHTML = "<tr height='30'><td width='25%' align='center' >"+'<%=SubList[i]%>'+"</td>"; 
						aRow.insertCell(1).innerHTML = "<td width='75%' align='center'  ><input type='text' name='Value_<%=i%>' style='width:90%;height:16px' value='' maxlength=1000></td></tr>"; 		
	<%					
					}
	%>
				}				
	<%
			}	
		}	
	}
%>
}

function doAdd()
{
  if(Dev_List_Add.Cpm_Id.value.length < 1)
  {
  	alert('请选择站点!');
  	return;
  }
  if(Dev_List_Add.Dev_Type.value.length < 1)
  {
  	alert('请选择类型!');
  	return;
  }
  if(Dev_List_Add.Dev_Name.value.Trim().length < 1)
  {
  	alert('请填写名称!');
  	return;
  }
  if(Dev_List_Add.Dev_Id.value.Trim().length < 1)
  {
  	alert('请填写出厂编号!');
  	return;
  }
  if(Dev_List_Add.Dev_Zhuangtai.value.Trim().length < 1)
  {
  	alert('请填设备状态!');
  	return;
  }
  if(Dev_List_Add.Dev_Date.value.Trim().length < 1)
  {
  	alert('请选择出厂日期!');
  	return;
  }
 
	var shux = "";

<%
	if(null != Dev_List_Type)
	{
		Iterator typeit = Dev_List_Type.iterator();
		while(typeit.hasNext())
		{
			AqscDeviceTypeBean tBean = (AqscDeviceTypeBean)typeit.next();
			String Dev_Id = tBean.getId();
			String Str_List = tBean.getDes();
			if(Str_List.trim().length() > 0)
			{
%>
				if("<%=Dev_Id%>" == Dev_List_Add.Dev_Type.value)
				{
	<%
					String[] SubList = Str_List.split(",");
					for(int i = 0; i<SubList.length && SubList[i].length()>0; i++)
					{
	%>								
						shux += '<%=SubList[i]%>,' + Dev_List_Add.Value_<%=i%>.value + ";";			
	<%					
					}
	%>
				}				
	<%
			}	
		}	
	}
%>
		Dev_List_Add.Dev_ShuXing.value = shux; 



	alert(Dev_List_Add.Dev_ShuXing.value);

  if(confirm("信息无误,确定提交?"))
  {
  	Dev_List_Add.submit();
  }
}

</SCRIPT>
</html>