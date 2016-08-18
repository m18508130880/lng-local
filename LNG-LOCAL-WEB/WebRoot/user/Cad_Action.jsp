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
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
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
	
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  String BDate = currStatus.getVecDate().get(0).toString().substring(0,10);
	String EDate = currStatus.getVecDate().get(1).toString().substring(0,10);
	
  ArrayList Cad_Action = (ArrayList)session.getAttribute("Cad_Action_" + Sid);
  int sn = 0; 
  
%>
<body style=" background:#CADFFF">
<form name="Cad_Action"  action="Cad_Action.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
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
					<option value='0' <%=currStatus.getFunc_Sub_Id() == 0 ? "selected":""%>>整改中</option>
					<option value='1' <%=currStatus.getFunc_Sub_Id() == 1 ? "selected":""%>>已关闭</option>
				</select>
				<input id='BDate' name='BDate' type='text' style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				-
				<input id='EDate' name='EDate' type='text' style='width:90px;height:18px;' value='<%=EDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
			</td>
			<td width='30%' align='right'>
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">
				<img id="img3" src="../skin/images/mini_button_add.gif"    onClick='doAdd()'  style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='090602' ctype='1'/>"  >
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25' valign='middle'>
						<td width='5%'  align='center' class="table_deep_blue">序号</td>
						<td width='10%' align='center' class="table_deep_blue">被观察人</td>
						<td width='10%' align='center' class="table_deep_blue">岗位</td>
						<td width='10%' align='center' class="table_deep_blue">时间</td>
						<td width='20%' align='center' class="table_deep_blue">地点</td>
						<td width='10%' align='center' class="table_deep_blue">状态</td>
						<td width='10%' align='center' class="table_deep_blue">录入人员</td>
					</tr>
					<%
					if(Cad_Action != null)
					{
						Iterator iterator = Cad_Action.iterator();
						while(iterator.hasNext())
						{
							CadActionBean Bean = (CadActionBean)iterator.next();
							String SN = Bean.getSN();
							String Observe_BY_Name = Bean.getObserve_BY_Name();
							String Observe_BY_Pos = Bean.getObserve_BY_Pos();
							String Observe_Time = Bean.getObserve_Time();
							String Observe_Addr = Bean.getObserve_Addr();
							String Status = Bean.getStatus();
							String Operator_Name = Bean.getOperator_Name();
							
							String str_Status = "";
							switch(Integer.parseInt(Status))
							{
								case 0:
										str_Status = "整改中";
									break;
								case 1:
										str_Status = "已关闭";
									break;
							}
							
							sn++;
					%>
						  <tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
								<td align=center><a href='#' title='查看明细' onclick="doEdit('<%=SN%>')"><U><%=sn%></U></a></td>
								<td align=left><%=Observe_BY_Name%></td>
						    <td align=left><%=Observe_BY_Pos%></td>
						    <td align=center><%=Observe_Time%></td>
						    <td align=left><%=Observe_Addr%></td>
								<td align=center><%=str_Status%></td>
								<td align=center><%=Operator_Name%></td>
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
				      	<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
				      </tr>
					<%
						}
					  else
					  {
					%>				
		          <tr <%=((i%2)==0?"class='table_white_l'":"class='table_blue'")%>>
			          <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
			        </tr>      
					<%
       			}
     			}
					%> 
     		 	<tr>
						<td colspan="7" class="table_deep_blue" >
				 			<table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0" >
			    			<tr valign="bottom">
			      			<td nowrap><%=currStatus.GetPageHtml("Cad_Action")%></td>
			    			</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="Cmd"   value="0">
<input type="hidden" name="Sid"   value="<%=Sid%>">
<input type="hidden" name="UId"   value="">
<input type="hidden" name="BTime" value="">
<input type="hidden" name="ETime" value="">
<input type="hidden" name="CurrPage" value="<%=currStatus.getCurrPage()%>">
<input type="button" id="CurrButton" onClick="doSelect()" style="display:none">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
if(<%=currStatus.getResult().length()%> > 0)
   alert("<%=currStatus.getResult()%>");
<%
currStatus.setResult("");
session.setAttribute("CurrStatus_" + Sid, currStatus);
%>

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Cad_Action.jsp';

switch(parseInt(<%=currStatus.getFunc_Sub_Id()%>))
{
	case 0:
			document.getElementById('BDate').style.display = 'none';
			document.getElementById('EDate').style.display = 'none';
		break;
	case 1:
	case 9:
			document.getElementById('BDate').style.display = '';
			document.getElementById('EDate').style.display = '';
		break;
}

function doSelect()
{
/**	var days = new Date(Cad_Action.EDate.value.replace(/-/g, "/")).getTime() - new Date(Cad_Action.BDate.value.replace(/-/g, "/")).getTime();
	var dcnt = parseInt(days/(1000*60*60*24));
	if(dcnt < 0)
	{
		alert('截止日期需大于开始日期');
		return;
	}
	if((dcnt + 1) > 31)
	{
		alert('日期跨越不超过31天');
		return;
	}
	**/
	Cad_Action.UId.value = Cad_Action.Func_Cpm_Id.value;
	Cad_Action.BTime.value = Cad_Action.BDate.value;
	Cad_Action.ETime.value = Cad_Action.EDate.value;
	Cad_Action.submit();
}

function GoPage(pPage)
{
/**	var days = new Date(Cad_Action.EDate.value.replace(/-/g, "/")).getTime() - new Date(Cad_Action.BDate.value.replace(/-/g, "/")).getTime();
	var dcnt = parseInt(days/(1000*60*60*24));
	if(dcnt < 0)
	{
		alert('截止日期需大于开始日期');
		return;
	}
	if((dcnt + 1) > 31)
	{
		alert('日期跨越不超过31天');
		return;
	}
	**/
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
	Cad_Action.UId.value = Cad_Action.Func_Cpm_Id.value;
	Cad_Action.BTime.value = Cad_Action.BDate.value;
	Cad_Action.ETime.value = Cad_Action.EDate.value;
	Cad_Action.CurrPage.value = pPage;
	Cad_Action.submit();
}

function doAdd()
{
	location = "Cad_Action_Add.jsp?Sid=<%=Sid%>";
}

function doEdit(pSN)
{
	/**if('<Limit:limitValidate userrole='<%=FpList%>' fpid='100303' ctype='1'/>' == 'none')
	{
		alert('您无权限修改行为观察!');
		return;
	}**/
	location = "Cad_Action_Edt.jsp?Sid=<%=Sid%>&SN="+pSN;
}
</SCRIPT>
</html>