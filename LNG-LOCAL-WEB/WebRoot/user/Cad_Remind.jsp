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
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	ArrayList User_User_Info  = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
	String FpId   = UserInfo.getFp_Role();
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
	
	CorpInfoBean Corp_Info   = (CorpInfoBean)session.getAttribute("User_Corp_Info_" + Sid);
	String Dept = "";
  if(Corp_Info != null)
	{
		Dept = Corp_Info.getDept();
    if(Dept == null)
    {
    	Dept = "";
    }
 	}
 	
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList Cad_Remind  = (ArrayList)session.getAttribute("Cad_Remind_" + Sid);
  String BDate = currStatus.getVecDate().get(0).toString().substring(0,10);
	String EDate = currStatus.getVecDate().get(1).toString().substring(0,10);	
  int sn = 0; 
  
%>
<body style=" background:#CADFFF">
<form name="Cad_Remind"  action="Cad_Remind.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
				&nbsp;部门：
				<select  name='Func_Type_Id' style='width:100px;height:20px' onChange="doSelect()" >		
					<option value='999' <%=currStatus.getFunc_Type_Id().equals("999")?"selected":""%>>所有部门</option>	
			<%	
					if(null != Corp_Info)
					{
						String Dept1 = Corp_Info.getDept();
						if(Dept1.trim().length() > 0)
						{
							String[] DeptLists = Dept1.split(",");
							for(int i=0; i<DeptLists.length; i++)
							{								
									 String Dept_Name1 = DeptLists[i];	
									 int uc  = 1+i;
									 String  num  = "0"+uc;									 									 	
				%>
					<option value='<%=num%>' <%=currStatus.getFunc_Type_Id().equals(num)?"selected":""%>><%=Dept_Name1%></option>	
				<%					 			
							}
						}
					}
					if(null != User_Device_Detail)
					{
						Iterator deviter1 = User_Device_Detail.iterator();
						while(deviter1.hasNext())
						{
							DeviceDetailBean devBean1 = (DeviceDetailBean)deviter1.next();							
								String Dept_Name2 = devBean1.getBrief();
								String Id         = devBean1.getId();
			%>
					<option value='<%=Id%>' <%=currStatus.getFunc_Type_Id().equals(Id)?"selected":""%>><%=Dept_Name2%></option>	
			<%	
						}
					}
			%>	
				</select>
				
				
				
				人员姓名:
				<select  name='Func_Cpm_Id' style='width:100px;height:20px' onChange="doSelect()" >		
					<%				
								String Manage_List = "";
								if( null != User_User_Info )
								{
									Iterator iterator = User_User_Info.iterator();
									while(iterator.hasNext())
									{
										UserInfoBean usertBean = (UserInfoBean)iterator.next();		
										String sys = 	usertBean.getSys_Id();							
										Manage_List  = Manage_List+sys;
									}
								}
				%>					
								<option value='<%=Manage_List%>' <%=currStatus.getFunc_Cpm_Id().equals(Manage_List)?"selected":""%>>全部人员</option>							
								
				<%						
								if( null != User_User_Info )
								{
									Iterator iterator = User_User_Info.iterator();
									while(iterator.hasNext())
									{
										UserInfoBean usertBean = (UserInfoBean)iterator.next();										
				%>
								<option value='<%=usertBean.getSys_Id()%>'<%=currStatus.getFunc_Cpm_Id().equals(usertBean.getSys_Id())?"selected":""%> ><%=usertBean.getCName()%></option>
				<%
									}
								}
				%>
				</select>
				记录状态:
				<select name='Func_Sub_Id' style='width:90px;height:20px' onChange="doSelect()">
					<option value='9' <%=currStatus.getFunc_Sub_Id() == 9 ? "selected":""%>>全部</option>
					<option value='0' <%=currStatus.getFunc_Sub_Id() == 0 ? "selected":""%>>未处理</option>
					<option value='2' <%=currStatus.getFunc_Sub_Id() == 2 ? "selected":""%>>已处理</option>
				</select>
				<input name='BDate' type='text' style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				<input name='EDate' type='text' style='width:90px;height:18px;' value='<%=EDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
			</td>
			<td width='30%' align='right'>				
				<img id="img1" src="../skin/images/mini_button_search.gif"  onClick='doSelect()' style='cursor:hand;'>
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25' valign='middle'>
						<td width='3%'  align='center' class="table_deep_blue">序号</td>
						<td width='8%'  align='center' class="table_deep_blue">提醒时间</td>
						<td width='8%' align='center' class="table_deep_blue">姓名</td>
						<td width='8%' align='center' class="table_deep_blue">部门</td>
						<td width='8%' align='center' class="table_deep_blue">岗位</td>
						<td width='20%' align='center' class="table_deep_blue">证件类型</td>
						<td width='20%' align='center' class="table_deep_blue">描述</td>
						<td width='6%'  align='center' class="table_deep_blue">状态</td>
					</tr>
					<%
					if(Cad_Remind != null)
					{
						Iterator iterator = Cad_Remind.iterator();
						while(iterator.hasNext())
						{
							CadRemindBean Bean = (CadRemindBean)iterator.next();
							String SN = Bean.getSN();
							String CTime = Bean.getCTime().substring(0,10);
							String Sys_Name = Bean.getSys_Name();
							String Dept_Id = Bean.getDept_Id();
							String Position_Name = Bean.getPosition_Name();
							String Card_Type_Name = Bean.getCard_Type_Name();
							String Des = Bean.getDes();
							String Status = Bean.getStatus();
							
							String Dept_Name = "无";
						  if(null != Dept_Id)
						 	{
						 		switch(Dept_Id.length())
						 		{
						 			case 2:
						 					if(Dept.trim().length() > 0)
									 		{
										 		String[] DeptList = Dept.split(",");
												for(int i=0; i<DeptList.length; i++)
												{
										    	if(Dept_Id.equals(CommUtil.IntToStringLeftFillZero(i+1, 2)))
										    	{
												  	Dept_Name = DeptList[i];
												  }
												}
											}
						 				break;
						 			case 10:
						 					if(null != User_Device_Detail)
						 					{
						 						Iterator deviter = User_Device_Detail.iterator();
												while(deviter.hasNext())
												{
													DeviceDetailBean devBean = (DeviceDetailBean)deviter.next();
													if(Dept_Id.equals(devBean.getId()))
													{
														Dept_Name = devBean.getBrief();
													}
												}
						 					}
						 				break;
						 		}
						 	}
						 	
							String str_Status = "";
							switch(Integer.parseInt(Status))
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
								<td align=center><%=CTime%></td>
								<td align=left><%=Sys_Name%></td>
						    <td align=left><%=Dept_Name%></td>
						    <td align=left><%=Position_Name%></td>		    
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
						<td colspan="7" class="table_deep_blue" >
				 			<table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0" >
			    			<tr valign="bottom">
			      			<td nowrap><%=currStatus.GetPageHtml("Cad_Remind")%></td>
			    			</tr>			    		
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="Cmd" value="0">
<input type="hidden" name="Sid" value="<%=Sid%>">
<input type="hidden" name="UId" value="">
<input type="hidden" name="BTime" value="">
<input type="hidden" name="ETime" value="">
<input type="hidden" name="CurrPage" value="<%=currStatus.getCurrPage()%>">
<input type="button" id="CurrButton" onClick="doSelect()" style="display:none">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Cad_Remind.jsp';

function doSelect()
{
	Cad_Remind.BTime.value = Cad_Remind.BDate.value + " 00:00:00";
	Cad_Remind.ETime.value = Cad_Remind.EDate.value + " 23:59:59";
	Cad_Remind.UId.value = Cad_Remind.Func_Cpm_Id.value;
	Cad_Remind.submit();
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
	Cad_Remind.UId.value = Cad_Remind.Func_Cpm_Id.value;
	Cad_Remind.CurrPage.value = pPage;
	Cad_Remind.submit();
}
</SCRIPT>
</html>