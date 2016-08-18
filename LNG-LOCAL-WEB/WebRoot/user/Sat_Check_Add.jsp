<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.text.*" %>
<%@ taglib uri="/WEB-INF/limitvalidatetag.tld" prefix="Limit"%>
<html>
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type='text/css' href='../skin/css/style.css' rel='stylesheet'/>
<script type='text/javascript' src='../skin/js/My97DatePicker/WdatePicker.js'></script>
<script type='text/javascript' src='../skin/js/util.js'></script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String Cpm_Id     = CommUtil.StrToGB2312(request.getParameter("Cpm_Id"));
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	String BDate = CommUtil.getDate();
	
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
  UserInfoBean UserInfo        = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  String ManageId = UserInfo.getManage_Role();
  
  CorpInfoBean Corp_Info = (CorpInfoBean)session.getAttribute("User_Corp_Info_" + Sid);
	String Dept = "";
  if(Corp_Info != null)
	{
		Dept = Corp_Info.getDept();
    if(Dept == null)
    {
    	Dept = "";
    }
 	}
 	
	ArrayList Sat_Check_Type   = (ArrayList)session.getAttribute("Sat_Check_Type_" + Sid);
	
	ArrayList Sat_Danger_Type    = (ArrayList)session.getAttribute("Sat_Danger_Type_" + Sid);
	ArrayList Sat_Danger_Level   = (ArrayList)session.getAttribute("Sat_Danger_Level_" + Sid);
	ArrayList User_User_Info = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
%>
<body style="background:#CADFFF">
<form name="Sat_Check_Add" action="Sat_Check_Add.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/sat_check_add.gif"></div><br><br><br>
	<div id="right_table_center">
		<table width="60%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
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
							<td width='25%' align='center'>检查对象</td>
							<td width='25%' align='left'>
								<select name="Cpm_Id" style="width:120px;height:20px" >
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
							<td width='25%' align='center'>检查部门</td>
							<td width='25%' align='left'>
								<select name="Check_Dept" style="width:120px;height:20px">
								<%
								if(Dept.trim().length() > 0)
								{
									String[] DeptList = Dept.split(",");
								  String pDept_Id = "";
								  String pDept_Name = "";
								  for(int i=0; i<DeptList.length; i++)
								  {
										pDept_Id = CommUtil.IntToStringLeftFillZero(i+1, 2);
										pDept_Name = DeptList[i];
								%>
								    <option value="<%=pDept_Id%>"><%=pDept_Name%></option>
								<%
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
							<td width='25%' align='center'>检查类型</td>
							<td width='25%' align='left'>
								<select name="Check_Type" style="width:120px;height:20px">
								<%
								if(null != Sat_Check_Type)
								{
									Iterator typeiter = Sat_Check_Type.iterator();
									while(typeiter.hasNext())
									{
										AqscExamTypeBean typeBean = (AqscExamTypeBean)typeiter.next();
										if(typeBean.getStatus().equals("0"))
										{
								%>
											<option value='<%=typeBean.getId()%>'><%=typeBean.getCName()%></option>
								<%
										}
									}
								}
								%>
								</select>
							</td>
							<td width='25%' align='center'>检查时间</td>
							<td width='25%' align='left'>
								<input name='Check_Time' type='text' style='width:118px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
							</td>
						</tr>		
					<!--	<tr height='30'>
							<td width='25%' align='center' >录入选项</td>
							<td width='25%' align='left'>
								<select name="Func_Id" style="width:120px;height:20px" onchange="doSel(this.value)">
									<option value='0' >其他录入</option>
									<option value='1' >全部录入</option>
									<option value='2' >隐患录入</option>
									<option value='3' >违章录入</option>
								</select>
							</td>
							<td width='25%' align='left'>&nbsp;</td>
							<td width='25%' align='left'>&nbsp;</td>
						</tr>			-->		
						<tr height='30'>
							<td width='25%' align='center' >问题描述</td>
							<td width='75%' align='left'colspan="3">
								<textarea name='Memo' rows='3' cols='75' maxlength=150></textarea>
							</td>
						</tr>				
					
				</table>
			<!--	<table id='table_YH' width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff" style="display:none">								
						<tr height='30'><td colspan="4">隐患部分</td></tr>
						<tr height='30' >
							<td width='25%' align='center'>隐患分类</td>
							<td width='25%' align='left' >
								<select name="Danger_Type" style="width:120px;height:20px">
									<option value='*'>请选择...</option>
									<%
									if(null != Sat_Danger_Type)
									{
										Iterator typeiter = Sat_Danger_Type.iterator();
										while(typeiter.hasNext())
										{
											AqscDangerTypeBean typeBean = (AqscDangerTypeBean)typeiter.next();
											if(typeBean.getStatus().equals("0"))
											{
									%>
												<option value='<%=typeBean.getId()%>'><%=typeBean.getCName()%></option>
									<%
											}
										}
									}
									%>
								</select>
							</td>	
							<td width='25%' align='center'>隐患级别</td>
							<td width='25%' align='left'>
								<select name="Danger_Level" style="width:120px;height:20px">
									<option value='*'>请选择...</option>
									<%
									if(null != Sat_Danger_Level)
									{
										Iterator leveliter = Sat_Danger_Level.iterator();
										while(leveliter.hasNext())
										{
											AqscDangerLevelBean levelBean = (AqscDangerLevelBean)leveliter.next();
											if(levelBean.getStatus().equals("0"))
											{
									%>
												<option value='<%=levelBean.getId()%>'><%=levelBean.getCName()%></option>
									<%
											}
										}
									}
									%>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>发现日期</td>
							<td width='25%' align='left'>
								<input name='Danger_BTime' type='text' style='width:118px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
							</td>	
							<td width='25%' align='center'>整改期限</td>
							<td width='25%' align='left'>
								<input name='Danger_ETime' type='text' style='width:118px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
							</td>						
						</tr>
						<tr height='30'>
							<td width='25%' align='center' >隐患描述</td>
							<td width='75%' align='left'colspan="3">
								<textarea name='Danger_Des' rows='3' cols='75' maxlength=150></textarea>
							</td>
						</tr>		
					</table>
					
					
					<table id='table_WZ' width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff" style="display:none">
						<tr height='30'><td colspan="4">违章部分</td></tr>
						<tr height='30'>
							<td width='25%' align='center'>违章时间</td>
							<td width='25%' align='left'>
								<input name='Break_Time' type='text' style='width:118px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
							</td>	
							<td width='25%' align='center'>违章人</td>
							<td width='25%' align='left'>
								<select id="Break_OP" name="Break_OP" style="width:120px;height:20px">								
								</select>
							</td>						
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>直接管理人</td>
							<td width='25%' align='left'>
								<select id="Manag_OP" name="Manag_OP" style="width:120px;height:20px">
								</select>
							</td>	
							<td width='25%' align='center'>绩效挂钩</td>
							<td width='25%' align='left'>
								<input type='text' name='Break_Point' style="width:118px;height:18px" value='0' maxlength=4> 分
							</td>						
						</tr>
						
						<tr height='30'>
							<td width='25%' align='center' >违章行为<br>(违反条款)</td>
							<td width='75%' align='left'colspan="3">
								<textarea name='Break_Des' rows='3' cols='75' maxlength=150></textarea>
							</td>
						</tr>				
						<tr height='30'>
							<td width='25%' align='center'>录入人员</td>
							<td width='75%' align='left'colspan="3">
								<%=Operator_Name%>
							</td>
						</tr>
					</table> -->
					
				</td>
			</tr>
		</table>
	</div>
</div>
<input name="Cmd"       type="hidden"   value="10">
<input name="Sid"       type="hidden"   value="<%=Sid%>">
<input name="Operator"  type="hidden"   value="<%=Operator%>"/>
<input name="CurrPage"       type="hidden"   value="<%=currStatus.getCurrPage()%>">
<input name="Func_Corp_Id"       type="hidden"   value="<%=currStatus.getFunc_Corp_Id()%>">
<input name="Check_SN"       type="hidden"   value="">
<input name="Check_Danger"       type="hidden"   value="">
<input name="Check_Break"       type="hidden"   value="">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Sat_Check_Add.jsp';

function doNO()
{
	location = "Sat_Check.jsp?Sid=<%=Sid%>";
}

var reqAdd = null;
function doAdd()
{
  if(Sat_Check_Add.Cpm_Id.value.length < 1)
  {
  	alert('请选择检查对象!');
  	return;
  }
  if(Sat_Check_Add.Check_Type.value.length < 1)
  {
  	alert('请选择检查类型!');
  	return;
  }
  if(Sat_Check_Add.Check_Time.value.length < 1)
  {
  	alert('请选择检查时间!');
  	return;
  }
  if(Sat_Check_Add.Check_Dept.value.length < 1)
  {
  	alert('请选择检查部门!');
  	return;
  }
  if(confirm("信息无误,确定提交?"))
  {  	
  	Sat_Check_Add.Check_Break.value = '';
  	Sat_Check_Add.Check_Danger.value = '';
  	var Memo = Sat_Check_Add.Memo.value.Trim();
  	//var Danger_Des=Sat_Check_Add.Danger_Des.value.Trim(); 	 
  	//var Break_Des=Sat_Check_Add.Break_Des.value.Trim();
  	var BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>;
  	var ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>;
  	var currtime=+new Date();
		Sat_Check_Add.submit();
  }
}
/**
function doChange(pCpm_Id)
{
	//先删除
	var length1 = document.getElementById('Break_OP').length;
	for(var i=0; i<length1; i++)
	{
		document.getElementById('Break_OP').remove(0);
	}
	
	var length2 = document.getElementById('Manag_OP').length;
	for(var i=0; i<length2; i++)
	{
		document.getElementById('Manag_OP').remove(0);
	}
	
	//再添加
	if(pCpm_Id.length > 0)
	{
		<%
		if(null != User_User_Info)
		{
			Iterator useriter = User_User_Info.iterator();
			while(useriter.hasNext())
			{
				UserInfoBean userBean = (UserInfoBean)useriter.next();
				if(userBean.getStatus().equals("0"))
				{
					switch(userBean.getDept_Id().length())
					{
						case 2:
		%>
							if(1 == 1)
							{
								var objOption = document.createElement('OPTION');
								objOption.value = '<%=userBean.getId()%>';
								objOption.text  = '<%=userBean.getCName()%>';
								document.getElementById('Manag_OP').add(objOption);
							}
		<%
							break;
						case 10:
		%>
							if('<%=userBean.getDept_Id()%>' == pCpm_Id)
							{
								var objOption1 = document.createElement('OPTION');
								objOption1.value = '<%=userBean.getId()%>';
								objOption1.text  = '<%=userBean.getCName()%>';
								document.getElementById('Break_OP').add(objOption1);
								
								var objOption2 = document.createElement('OPTION');
								objOption2.value = '<%=userBean.getId()%>';
								objOption2.text  = '<%=userBean.getCName()%>';
								document.getElementById('Manag_OP').add(objOption2);
							}
		<%
							break;
					}
				}
			}
		}
		%>
	}
}
doChange(Sat_Check_Add.Cpm_Id.value);

**/

/**
function doSel(cnt)
{
	switch(parseInt(cnt))
	{
		case 0:
			document.getElementById('table_YH').style.display = 'none';  
			document.getElementById('table_WZ').style.display = 'none'; 
			break;
		case 1:
			document.getElementById('table_YH').style.display = '';  
			document.getElementById('table_WZ').style.display = ''; 
			break;
			
			case 2:
			document.getElementById('table_YH').style.display = '';  
			document.getElementById('table_WZ').style.display = 'none'; 
			break;
			
			case 3:
			document.getElementById('table_YH').style.display = 'none'; 
			document.getElementById('table_WZ').style.display = ''; 
			break;
		
	}
}
**/
</SCRIPT>
</html>