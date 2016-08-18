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
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	String ManageId = UserInfo.getManage_Role();
	String FpId = UserInfo.getFp_Role();
	String FpList = "";
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
 	
  CurrStatus currStatus    = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList Dev_List_Breed = (ArrayList)session.getAttribute("Dev_List_Breed_" + Sid);
  ArrayList Dev_Remind     = (ArrayList)session.getAttribute("Dev_Remind_" + Sid);
  int sn = 0; 
  String Manage_List = "";
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
											Manage_List += R_Point;
										}
									}
								}
								String Dept_Id = UserInfo.getDept_Id();
								if(Dept_Id.length()>3){Manage_List = Dept_Id; }
  
%>
<body style=" background:#CADFFF">
<form name="Dev_Remind"  action="Dev_Remind.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
				加气站点:
				<select  name='Func_Cpm_Id' style='width:100px;height:20px' onChange="doSelect()" >					
						<%						
								if(Manage_List.length() > 0 && null != User_Device_Detail)
								{
									Iterator iterator = User_Device_Detail.iterator();
									while(iterator.hasNext())
									{
										DeviceDetailBean statBean = (DeviceDetailBean)iterator.next();
										if(Manage_List.contains(statBean.getId()))
										{
								%>
											<option value='<%=statBean.getId()%>' <%=currStatus.getFunc_Cpm_Id().equals(statBean.getId())?"selected":""%>><%=statBean.getBrief()%></option>
								<%
										}
									}
								}
								%>
				</select>
				设备品种:
				<select name='Func_Corp_Id' style='width:120px;height:20px;' onchange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>全部</option>
					<%
					if(null != Dev_List_Breed)
					{
						Iterator breediter = Dev_List_Breed.iterator();
						while(breediter.hasNext())
						{
							AqscDeviceBreedBean breedBean = (AqscDeviceBreedBean)breediter.next();
					%>
							<option value='<%=breedBean.getId()%>' <%=currStatus.getFunc_Corp_Id().equals(breedBean.getId())?"selected":""%>><%=breedBean.getCName()%></option>
					<%
						}
					}
					%>
				</select>
				记录状态:
				<select name='Func_Sel_Id' style='width:90px;height:20px' onChange="doSelect()">
					<option value='9' <%=currStatus.getFunc_Sel_Id() == 9 ? "selected":""%>>全部</option>
					<option value='0' <%=currStatus.getFunc_Sel_Id() == 0 ? "selected":""%>>未处理</option>
					<option value='2' <%=currStatus.getFunc_Sel_Id() == 2 ? "selected":""%>>已处理</option>
				</select>
			</td>
			<td width='30%' align='right'>
				<img id="img1" src="../skin/images/mini_button_search.gif"  onClick='doSelect()' style='cursor:hand;'>
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25' valign='middle'>
						<td width='5%'  align='center' class="table_deep_blue">序号</td>
						<td width='10%' align='center' class="table_deep_blue">场站名称</td>
						<td width='10%' align='center' class="table_deep_blue">设备品种</td>
						<td width='10%' align='center' class="table_deep_blue">设备类型</td>
						<td width='10%' align='center' class="table_deep_blue">设备名称</td>
						<td width='15%' align='center' class="table_deep_blue">证件类型</td>
						<td width='25%' align='center' class="table_deep_blue">描述</td>
						<td width='8%'  align='center' class="table_deep_blue">状态</td>
					</tr>
					<%
					if(Dev_Remind != null)
					{
						Iterator iterator = Dev_Remind.iterator();
						while(iterator.hasNext())
						{
							DevRemindBean Bean = (DevRemindBean)iterator.next();
							String Cpm_Name = Bean.getCpm_Name();
							String Dev_CType_Name = Bean.getDev_CType_Name();
							String Dev_Type_Name = Bean.getDev_Type_Name();
							String Dev_Name = Bean.getDev_Name();
							String Card_Type_Name = Bean.getCard_Type_Name();
							String Des = Bean.getDes();
							
							String str_Status = "";
							switch(Integer.parseInt(Bean.getStatus()))
							{
								case 0:
										str_Status = "<font color=red>未处理</font>";
									break;
								case 2:
										str_Status = "<font color=green>已处理</font>";
									break;
							}
							
							sn++;
					%>
						  <tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
								<td align=center><%=sn%></td>
								<td align=left><%=Cpm_Name%></td>
						    <td align=left><%=Dev_CType_Name%></td>
						    <td align=left><%=Dev_Type_Name%></td>
						    <td align=left><%=Dev_Name%></td>
						    <td align=left><%=Card_Type_Name%></td>
								<td align=left><%=Des%></td>
								<td align=center><%=str_Status%></td>
							</tr>
					<%				
						}
					}
					for(int i=0;i<(MsgBean.CONST_PAGE_SIZE - sn);i++)
					{
						if(sn % 2 != 0)
					  {
					%>   				  
				      <tr <%=((i%2)==0?"class='table_blue'":"class='table_white_l'")%>>
				      	<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
				      </tr>  
					<%
						}
					  else
					  {
					%>				
		          <tr <%=((i%2)==0?"class='table_white_l'":"class='table_blue'")%>>
			          <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
			        </tr>      
					<%
       			}
     			}
					%> 
     		 	<tr>
						<td colspan="8" class="table_deep_blue" >
				 			<table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0" >
			    			<tr valign="bottom">
			      			<td nowrap><%=currStatus.GetPageHtml("Dev_Remind")%></td>
			    			</tr>			    		
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="Cmd"      value="0">
<input type="hidden" name="Sid"      value="<%=Sid%>">
<input type="hidden" name="Cpm_Id"   value="">
<input type="hidden" name="CurrPage" value="<%=currStatus.getCurrPage()%>">
<input type="button" id="CurrButton" onClick="doSelect()" style="display:none">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Dev_Remind.jsp';

function doSelect()
{
	Dev_Remind.Cpm_Id.value = Dev_Remind.Func_Cpm_Id.value;
	Dev_Remind.submit();
}

function GoPage(pPage)
{
	if(pPage == "")
	{
		 alert("请输入目标页面的数值!");
		 return;
	}
	if(pPage < 1)
	{
	   	alert("请输入页数大于1");
		  return;	
	}
	if(pPage > <%=currStatus.getTotalPages()%>)
	{
		pPage = <%=currStatus.getTotalPages()%>;
	}
	Dev_Remind.Cpm_Id.value = Dev_Remind.Func_Cpm_Id.value;
	Dev_Remind.CurrPage.value = pPage;
	Dev_Remind.submit();
}
</SCRIPT>
</html>