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
<script type='text/javascript' src='../skin/js/day.js'></script>
<script type='text/javascript' src='../skin/js/util.js'></script>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
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
	
	ArrayList User_User_Info = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	String ManageId = UserInfo.getManage_Role();
	ArrayList Sat_Drill_Type = (ArrayList)session.getAttribute("Sat_Drill_Type_" + Sid);
  ArrayList Sat_Drill      = (ArrayList)session.getAttribute("Sat_Drill_" + Sid);
  int sn = 0; 
  
%>
<body style=" background:#CADFFF">
<form name="Sat_Drill"  action="Sat_Drill.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop' style="display:none">
			<td width='70%' align='left'>
				演练站点:
				<select  name='Func_Cpm_Id' style='width:100px;height:20px' onChange="doSelect()" >					
						<%
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
				演练类型:
				<select name='Func_Corp_Id' style='width:120px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>全部</option>
					<%
					if(null != Sat_Drill_Type)
					{
						Iterator typeiter = Sat_Drill_Type.iterator();
						while(typeiter.hasNext())
						{
							AqscDrillTypeBean typeBean = (AqscDrillTypeBean)typeiter.next();
					%>
							<option value='<%=typeBean.getId()%>' <%=currStatus.getFunc_Corp_Id().equals(typeBean.getId())?"selected":""%>><%=typeBean.getCName()%></option>
					<%
						}
					}
					%>
				</select>
				记录状态:
				<select name='Func_Sub_Id' style='width:70px;height:20px' onChange="doSelect()">
					<option value='9' <%=currStatus.getFunc_Sub_Id() == 9 ? "selected":""%>>全部</option>
					<option value='0' <%=currStatus.getFunc_Sub_Id() == 0 ? "selected":""%>>计划中</option>
					<option value='1' <%=currStatus.getFunc_Sub_Id() == 1 ? "selected":""%>>已关闭</option>
				</select>
				<input id='BDate' name='BDate' type='text' style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				-
				<input id='EDate' name='EDate' type='text' style='width:90px;height:18px;' value='<%=EDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
			</td>
			<td width='30%' align='right'>
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' >
				<img id="img3" src="../skin/images/mini_button_add.gif"    onClick='doAdd()'    >
				<img id="img4" src="../skin/images/mini_button_ledger.gif" onClick='doLedger()' >						
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25' valign='middle'>
						<td width='10%' align='center' class="table_deep_blue">序号</td>
						<td width='30%' align='center' class="table_deep_blue">演练基本信息</td>
						<td width='30%' align='center' class="table_deep_blue">演练效果评估</td>
						<td width='30%' align='center' class="table_deep_blue">观摩效果评估</td>
					</tr>
					<%
					if(Sat_Drill != null)
					{
						Iterator iterator = Sat_Drill.iterator();
						while(iterator.hasNext())
						{
							SatDrillBean Bean = (SatDrillBean)iterator.next();
							
							//演练基本信息
							String SN              = Bean.getSN();
							String Cpm_Name        = Bean.getCpm_Name();
							String Drill_Type_Name = Bean.getDrill_Type_Name();
							String Drill_Title     = Bean.getDrill_Title();
							String Drill_Time      = Bean.getDrill_Time();
							String Drill_Cnt       = Bean.getDrill_Cnt();
							String Drill_Memo      = Bean.getDrill_Memo();
							String Operator_Name   = Bean.getOperator_Name();
							if(null == Drill_Memo){Drill_Memo = "";}
							String Desc_1 = "<font color=green>演练单位: </font>" + Cpm_Name
														+ "<br>"
							              + "<font color=green>演练类型: </font>" + Drill_Type_Name
							              + "<br>"
							              + "<font color=green>演练名称: </font>" + Drill_Title
							              + "<br>"
							              + "<font color=green>演练时间: </font>" + Drill_Time
							              + "<br>"
							              + "<font color=green>参演人数: </font>" + Drill_Cnt
							              + "<br>"
							              + "<font color=green>演练备注: </font>" + Drill_Memo
							              + "<br>"
							              + "<font color=green>录入人员: </font>" + Operator_Name;
							              
							//演练效果评估
							String Drill_Assess_Des = Bean.getDrill_Assess_Des();
							String Drill_Assess_OP  = Bean.getDrill_Assess_OP();
							if(null == Drill_Assess_Des){Drill_Assess_Des = "";}
							if(null == Drill_Assess_OP){Drill_Assess_OP = "";}
							
							//观摩效果评估
							String View_Assess_Des = Bean.getView_Assess_Des();
							String View_Assess_OP  = Bean.getView_Assess_OP();
							String Status          = Bean.getStatus();
							if(null == View_Assess_Des){View_Assess_Des = "";}
							if(null == View_Assess_OP){View_Assess_OP = "";}
							String str_Status = "";
							switch(Integer.parseInt(Status))
							{
								case 0:
										str_Status = "计划中";
									break;
								case 1:
										str_Status = "已关闭";
									break;
							}
							
							//录入人员
							String Drill_Assess_OP_Name = "";
							String View_Assess_OP_Name = "";
							if(User_User_Info != null)
							{
								for(int i=0; i<User_User_Info.size(); i++)
								{
									UserInfoBean Info = (UserInfoBean)User_User_Info.get(i);
									if(Info.getId().equals(Drill_Assess_OP))
										Drill_Assess_OP_Name = Info.getCName();
									if(Info.getId().equals(View_Assess_OP))
										View_Assess_OP_Name = Info.getCName();
								}
							}
							
							String Desc_2 = "";
							String Desc_3 = "";
							if(Drill_Assess_OP.trim().length() > 0)
							{
								Desc_2 = "<font color=green>演练评估: </font>已评估"
								       + "<br>"
								       + "<font color=green>简要描述: </font>" + Drill_Assess_Des
								       + "<br>"
								       + "<font color=green>评估人员: </font>" + Drill_Assess_OP_Name;
							}
							else
							{
								Desc_2 = "<font color=red>演练评估: </font>未评估"
								       + "<br>"
								       + "<font color=red>简要描述: </font>" + Drill_Assess_Des
								       + "<br>"
								       + "<font color=red>评估人员: </font>" + Drill_Assess_OP_Name;
							}
							
							if(View_Assess_OP.trim().length() > 0)
							{
								Desc_3 = "<font color=green>观摩评估: </font>已评估"
								       + "<br>"
								       + "<font color=green>简要描述: </font>" + View_Assess_Des
								       + "<br>"
								       + "<font color=green>状态跟踪: </font>" + str_Status
								       + "<br>"
								       + "<font color=green>评估人员: </font>" + View_Assess_OP_Name;
							}
							else
							{
								Desc_3 = "<font color=red>观摩评估: </font>未评估"
								       + "<br>"
								       + "<font color=red>简要描述: </font>" + View_Assess_Des
								       + "<br>"
								       + "<font color=red>状态跟踪: </font>" + str_Status
								       + "<br>"
								       + "<font color=red>评估人员: </font>" + View_Assess_OP_Name;
							}
							
							sn++;
					%>
						  <tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
								<td align=center><%=sn%></td>
								<td align=left valign=top style='cursor:hand;' title='编辑演练基本信息' onclick="doEdit01('<%=SN%>', '<%=Status%>', '<%=Drill_Assess_OP%>')"><%=Desc_1%></td>
						    <td align=left valign=top style='cursor:hand;' title='编辑演练效果评估' onclick="doEdit02('<%=SN%>', '<%=Status%>', '<%=View_Assess_OP%>')"><%=Desc_2%></td>
						    <td align=left valign=top style='cursor:hand;' title='编辑观摩效果评估' onclick="doEdit03('<%=SN%>', '<%=Status%>', '<%=Drill_Assess_OP%>')"><%=Desc_3%></td>
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
				      	<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
				      </tr>  
					<%
						}
					  else
					  {
					%>				
		          <tr <%=((i%2)==0?"class='table_white_l'":"class='table_blue'")%>>
			          <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
			        </tr>      
					<%
       			}
     			}
					%> 
     		 	<tr>
						<td colspan="4" class="table_deep_blue" >
				 			<table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0" >
			    			<tr valign="bottom">
			      			<td nowrap><%=currStatus.GetPageHtml("Sat_Drill")%></td>
			    			</tr>			    		
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="Cmd"    value="0">
<input type="hidden" name="Sid"    value="<%=Sid%>">
<input type="hidden" name="Cpm_Id" value="">
<input type="hidden" name="BTime"  value="">
<input type="hidden" name="ETime"  value="">
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

//ipad禁掉导出
if(1 == fBrowserRedirect() || 2 == fBrowserRedirect())
{
	document.getElementById('img2').style.display = 'none';
}

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Sat_Drill.jsp';

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
	/**var days = new Date(Sat_Drill.EDate.value.replace(/-/g, "/")).getTime() - new Date(Sat_Drill.BDate.value.replace(/-/g, "/")).getTime();
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
	}**/
	
	Sat_Drill.Cpm_Id.value = Sat_Drill.Func_Cpm_Id.value;
	Sat_Drill.BTime.value = Sat_Drill.BDate.value;
	Sat_Drill.ETime.value = Sat_Drill.EDate.value;
	Sat_Drill.submit();
}

function GoPage(pPage)
{
	/**var days = new Date(Sat_Drill.EDate.value.replace(/-/g, "/")).getTime() - new Date(Sat_Drill.BDate.value.replace(/-/g, "/")).getTime();
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
	Sat_Drill.Cpm_Id.value = Sat_Drill.Func_Cpm_Id.value;
	Sat_Drill.BTime.value = Sat_Drill.BDate.value;
	Sat_Drill.ETime.value = Sat_Drill.EDate.value;
	Sat_Drill.CurrPage.value = pPage;
	Sat_Drill.submit();
}

var req = null;
function doExport()
{
	/**var days = new Date(Sat_Drill.EDate.value.replace(/-/g, "/")).getTime() - new Date(Sat_Drill.BDate.value.replace(/-/g, "/")).getTime();
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
	if(0 == <%=sn%>)
	{
		alert('当前无记录!');
		return;
	}
	if(65000 <= <%=currStatus.getTotalRecord()%>)
	{
		alert('记录过多，请分批导出!');
		return;
	}
	if(confirm("确定导出?"))
  {
		if(window.XMLHttpRequest)
	  {
			req = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			req = new ActiveXObject("Microsoft.XMLHTTP");
		}
		//设置回调函数
		req.onreadystatechange = callbackForName;
		var url = "Sat_Drill_Export.do?Sid=<%=Sid%>&Cpm_Id="+Sat_Drill.Func_Cpm_Id.value+"&BTime="+Sat_Drill.BDate.value+"&ETime="+Sat_Drill.EDate.value+"&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>";
		req.open("post",url,true);
		req.send(null);
		return true;
	}
}

function callbackForName()
{
	var state = req.readyState;
	if(state==4)
	{
		var resp = req.responseText;
		var str = "";
		if(resp != null)
		{
			location.href = "../files/excel/" + resp + ".xls";
		}
	}
}

function doAdd()
{
	location = "Sat_Drill_Add.jsp?Sid=<%=Sid%>";
}

function doLedger()
{
	var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
  var ETime = showPreviousLastDay().format("yyyy-MM-dd");
  var Year  = BTime.substring(0,4);
  var Month = BTime.substring(5,7);
	location = "Sat_Drill_L.do?Cmd=0&Sid=<%=Sid%>&Func_Sub_Id=1&Func_Corp_Id=9999&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month;
}

//演练基本信息
function doEdit01(pSN, pStatus, pDrill_Assess_OP)
{
	/**if('<Limit:limitValidate userrole='<%=FpList%>' fpid='090506' ctype='1'/>' == 'none')
	{
		alert('您无权限修改演练基本信息!');
		return;
	}**/
	if('1' == pStatus)
	{
		alert('当前应急演练已关闭!');
		return;
	}
	if(pDrill_Assess_OP.Trim().length > 0)
	{
		alert('演练效果已评估，您不可再次修改演练基本信息!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 350;
	diag.Title = "演练基本信息编辑";
	diag.URL = 'Sat_Drill_Edit.jsp?Sid=<%=Sid%>&CType=1&SN='+pSN;
	diag.show();
}

//演练效果评估
function doEdit02(pSN, pStatus, pView_Assess_OP)
{
	/**if('<Limit:limitValidate userrole='<%=FpList%>' fpid='090507' ctype='1'/>' == 'none')
	{
		alert('您无权限修改演练效果评估!');
		return;
	}**/
	if('1' == pStatus)
	{
		alert('当前应急演练已关闭!');
		return;
	}
	if(pView_Assess_OP.Trim().length > 0)
	{
		alert('观摩效果已评估，您不可再次修改演练效果评估!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 350;
	diag.Title = "演练效果评估编辑";
	diag.URL = 'Sat_Drill_Edit.jsp?Sid=<%=Sid%>&CType=2&SN='+pSN;
	diag.show();
}

//观摩效果评估
function doEdit03(pSN, pStatus, pDrill_Assess_OP)
{
	/**if('<Limit:limitValidate userrole='<%=FpList%>' fpid='090508' ctype='1'/>' == 'none')
	{
		alert('您无权限修改观摩效果评估!');
		return;
	}**/
	if('1' == pStatus)
	{
		alert('当前应急演练已关闭!');
		return;
	}
	if(pDrill_Assess_OP.Trim().length < 1)
	{
		alert('当前应急演练效果尚未评估!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 350;
	diag.Title = "观摩效果评估编辑";
	diag.URL = 'Sat_Drill_Edit.jsp?Sid=<%=Sid%>&CType=3&SN='+pSN;
	diag.show();
}
</SCRIPT>
</html>