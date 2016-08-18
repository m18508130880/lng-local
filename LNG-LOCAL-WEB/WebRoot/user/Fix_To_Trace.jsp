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
	UserInfoBean UserInfo  = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
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
 	
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  String BDate = currStatus.getVecDate().get(0).toString().substring(0,10);
	String EDate = currStatus.getVecDate().get(1).toString().substring(0,10);
	
	ArrayList User_User_Info = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
	ArrayList Dev_List_Breed = (ArrayList)session.getAttribute("Dev_List_Breed_" + Sid);
	ArrayList Dev_List       = (ArrayList)session.getAttribute("Dev_List_" + Sid);
  ArrayList Fix_To_Trace      = (ArrayList)session.getAttribute("Fix_To_Trace_" + Sid);
  ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	String ManageId = UserInfo.getManage_Role();
  
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
%>
<body style="background:#CADFFF">
<form name="Fix_To_Trace"  action="Fix_To_Trace.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
				加气站点:
				<select  name='Func_Cpm_Id' style='width:100px;height:20px' onChange="doSelect()" >				
					<option value='<%=Manage_List%>' <%=currStatus.getFunc_Cpm_Id().equals(Manage_List)?"selected":""%>>全部站点</option>	
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
				<select name='Func_Sub_Id' style='width:70px;height:20px' onChange="doSelect()">
					<option value='9' <%=currStatus.getFunc_Sub_Id() == 9 ? "selected":""%>>全部</option>
					<option value='0' <%=currStatus.getFunc_Sub_Id() == 0 ? "selected":""%>>维修中</option>
					<option value='1' <%=currStatus.getFunc_Sub_Id() == 1 ? "selected":""%>>已关闭</option>
				</select>
				<input id='BDate' name='BDate' type='text' style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				-
				<input id='EDate' name='EDate' type='text' style='width:90px;height:18px;' value='<%=EDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
			</td>
			<td width='30%' align='right'>
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">				
				<img id="img3" src="../skin/images/mini_button_add.gif"    onClick='doAdd()'   style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='160102' ctype='1'/>" >
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='160103' ctype='1'/>">
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25' valign='middle'>
						<td width='5%'  align='center' class="table_deep_blue">序号</td>
						<td width='10%' align='center' class="table_deep_blue">申请场站</td>
						<td width='10%' align='center' class="table_deep_blue">申请日期</td>
						<td width='9%' align='center' class="table_deep_blue">故障设备</td>
						<td width='23%' align='center' class="table_deep_blue">问题描述</td>
						<td width='23%' align='center' class="table_deep_blue">应急措施</td>
						<td width='10%' align='center' class="table_deep_blue">申请人员</td>
						<td width='10%' align='center' class="table_deep_blue">详情跟踪</td>
					</tr>
					<%
					if(Fix_To_Trace != null)
					{
						Iterator iterator = Fix_To_Trace.iterator();
						while(iterator.hasNext())
						{
							FixTraceBean Bean = (FixTraceBean)iterator.next();
							String SN         = Bean.getSN();
							String Cpm_Name   = Bean.getCpm_Name();
							String Apply_Time = Bean.getApply_Time();
							
							//申请信息
							String Dev_Name      = Bean.getDev_Name();
							String Apply_Des     = Bean.getApply_Des();
							String Apply_Man     = Bean.getApply_Man();
							String Apply_Pre     = Bean.getApply_Pre();
							String Apply_OP_Name = Bean.getApply_OP_Name();			
							sn++;					
					%>
					<tr height='25' valign='middle' <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
						<td width='5%'  align='center' ><%=sn%></td>
						<td width='10%' align='center' ><%=Cpm_Name%></td>
						<td width='10%' align='center' ><%=Apply_Time%></td>
						<td width='9%' align='center' ><%=Dev_Name%></td>
						<td width='23%' align='center' ><%=Apply_Des%></td>
						<td width='23%' align='center' ><%=Apply_Pre%></td>
						<td width='10%' align='center' ><%=Apply_Man%></td>
						<td width='10%' align='center' ><a href="#" onClick="ToFix('<%=SN%>')"><font color="red">详情跟踪</font></a></td>
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
						<td colspan="8" class="table_deep_blue">
				 			<table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0">
			    			<tr valign="bottom">
			      			<td nowrap><%=currStatus.GetPageHtml("Fix_To_Trace")%></td>
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
<input type="hidden" name="BTime"    value="">
<input type="hidden" name="ETime"    value="">
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
	var days = new Date(Fix_To_Trace.EDate.value.replace(/-/g, "/")).getTime() - new Date(Fix_To_Trace.BDate.value.replace(/-/g, "/")).getTime();
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
	
	Fix_To_Trace.Cpm_Id.value = Fix_To_Trace.Func_Cpm_Id.value;
	Fix_To_Trace.BTime.value = Fix_To_Trace.BDate.value;
	Fix_To_Trace.ETime.value = Fix_To_Trace.EDate.value;
	Fix_To_Trace.submit();
}

function GoPage(pPage)
{
	var days = new Date(Fix_To_Trace.EDate.value.replace(/-/g, "/")).getTime() - new Date(Fix_To_Trace.BDate.value.replace(/-/g, "/")).getTime();
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
	Fix_To_Trace.Cpm_Id.value = Fix_To_Trace.Func_Cpm_Id.value;
	Fix_To_Trace.BTime.value = Fix_To_Trace.BDate.value;
	Fix_To_Trace.ETime.value = Fix_To_Trace.EDate.value;
	Fix_To_Trace.CurrPage.value = pPage;
	Fix_To_Trace.submit();
}

//添加申请信息
function doAdd()
{
	location = "Fix_Trace_Add.jsp?Sid=<%=Sid%>";
}
function ToFix(pSN)
{
	window.parent.frames.mFrame.location = "Fix_Trace.do?Sid=<%=Sid%>&Cmd=1&SN="+pSN;	
}

var req = null;
function doExport()
{
	var days = new Date(Fix_To_Trace.EDate.value.replace(/-/g, "/")).getTime() - new Date(Fix_To_Trace.BDate.value.replace(/-/g, "/")).getTime();
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
		var url = "Fix_Trace_Export.do?Sid=<%=Sid%>&Cpm_Id="+Fix_To_Trace.Func_Cpm_Id.value+"&BTime="+Fix_To_Trace.BDate.value+"&ETime="+Fix_To_Trace.EDate.value+"&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>";
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




</SCRIPT>
</html>