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
<link type='text/css' href='../skin/css/style.css' rel='stylesheet'/>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/util.js'    charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/My97DatePicker/WdatePicker.js'></script>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	String ManageId = UserInfo.getManage_Role();
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
	
	ArrayList Sat_Danger_Type  = (ArrayList)session.getAttribute("Sat_To_Danger_Type_" + Sid);
	ArrayList Sat_Danger_Level = (ArrayList)session.getAttribute("Sat_To_Danger_Level_" + Sid);
	ArrayList User_User_Info   = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
  ArrayList Sat_To_Danger       = (ArrayList)session.getAttribute("Sat_To_Danger_" + Sid);
  int sn = 0;
  
%>
<body style=" background:#CADFFF">
<form name="Sat_To_Danger"  action="Sat_To_Danger.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='75%' align='left'>
				加气站点:
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
						%>
						<option value="<%=Manage_List%>" <%=currStatus.getFunc_Cpm_Id().equals(Manage_List)?"selected":""%>>全部站点</option>	
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
				隐患分类:
				<select name='Func_Corp_Id' style='width:100px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>全部</option>
					<%
					if(null != Sat_Danger_Type)
					{
						Iterator typeiter = Sat_Danger_Type.iterator();
						while(typeiter.hasNext())
						{
							AqscDangerTypeBean typeBean = (AqscDangerTypeBean)typeiter.next();
					%>
							<option value='<%=typeBean.getId()%>' <%=currStatus.getFunc_Corp_Id().equals(typeBean.getId())?"selected":""%>><%=typeBean.getCName()%></option>
					<%
						}
					}
					%>
				</select>
				隐患级别:
				<select name='Func_Type_Id' style='width:80px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Type_Id().equals("9999")?"selected":""%>>全部</option>
					<%
					if(null != Sat_Danger_Level)
					{
						Iterator typeiter = Sat_Danger_Level.iterator();
						while(typeiter.hasNext())
						{
							AqscDangerLevelBean levelBean = (AqscDangerLevelBean)typeiter.next();
					%>
							<option value='<%=levelBean.getId()%>' <%=currStatus.getFunc_Type_Id().equals(levelBean.getId())?"selected":""%>><%=levelBean.getCName()%></option>
					<%
						}
					}
					%>
				</select>
				记录状态:
				<select name='Func_Sub_Id' style='width:80px;height:20px' onChange="doSelect()">
					<option value='9' <%=currStatus.getFunc_Sub_Id() == 9 ? "selected":""%>>全部</option>
					<option value='0' <%=currStatus.getFunc_Sub_Id() == 0 ? "selected":""%>>整改中</option>
					<option value='1' <%=currStatus.getFunc_Sub_Id() == 1 ? "selected":""%>>已关闭</option>
				</select>
				<input id='BDate' name='BDate' type='text' style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				<input id='EDate' name='EDate' type='text' style='width:90px;height:18px;' value='<%=EDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
			</td>
			<td width='25%' align='right'>
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' >
				<!--<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='090202' ctype='1'/>">
				<img id="img3" src="../skin/images/mini_button_add.gif"    onClick='doAdd()'    style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='090203' ctype='1'/>">-->
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25' valign='middle'>
						<td width='9%'  align='center' class="table_deep_blue">序号</td>
						<td width='13%' align='center' class="table_deep_blue">责任部门</td>
						<td width='13%' align='center' class="table_deep_blue">检查时间</td>
						<td width='13%' align='center' class="table_deep_blue">整改期限</td>
						<td width='13%' align='center' class="table_deep_blue">隐患分类</td>
						<td width='13%' align='center' class="table_deep_blue">隐患级别</td>
						<td width='13%' align='center' class="table_deep_blue">当前状态</td>
						<td width='13%' align='center' class="table_deep_blue">隐患跟踪</td>
					</tr>
					<%
					if(Sat_To_Danger != null)
					{
						Iterator iterator = Sat_To_Danger.iterator();
						while(iterator.hasNext())
						{
							SatDangerBean Bean = (SatDangerBean)iterator.next();
							
							//隐患基本信息
							String SN = Bean.getSN();
							String Danger_Type = Bean.getDanger_Type();
							String Danger_Type_Name = Bean.getDanger_Type_Name();
							String Danger_Level = Bean.getDanger_Level();
							String Danger_Level_Name = Bean.getDanger_Level_Name();
							String Danger_Des = Bean.getDanger_Des();
							String Cpm_Name = Bean.getCpm_Name();
							String Cpm_Id   = Bean.getCpm_Id();
							String Danger_BTime = Bean.getDanger_BTime();
							String Danger_ETime = Bean.getDanger_ETime();
							String Operator_Name = Bean.getOperator_Name();
														
							//审核验收
							String Danger_Check = Bean.getDanger_Check();
							String Danger_Check_OP = Bean.getDanger_Check_OP();
							String Status = Bean.getStatus();
							String str_Status = "";
							if(null == Danger_Check){Danger_Check = "";}
							if(null == Danger_Check_OP){Danger_Check_OP = "";}							
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
					<tr height='25' valign='middle' <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
						<td width='9%'  align='center' ><%=sn%></td>
						<td width='13%' align='center' ><%=Cpm_Name%></td>
						<td width='13%' align='center' ><%=Danger_BTime.substring(0,10)%></td>
						<td width='13%' align='center' ><%=Danger_ETime%></td>
						<td width='13%' align='center' ><%=Danger_Type_Name%></td>
						<td width='13%' align='center' ><%=Danger_Level_Name%></td>
						<td width='13%' align='center' ><%=str_Status%></td>
						<td width='13%' align='center' ><a href="#" onClick="ToXX('<%=SN%>')" ><font color="red">隐患跟踪</font></a></td>
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
			      			<td nowrap><%=currStatus.GetPageHtml("Sat_To_Danger")%></td>
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

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Sat_To_Danger.jsp';

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
	/**var days = new Date(Sat_To_Danger.EDate.value.replace(/-/g, "/")).getTime() - new Date(Sat_To_Danger.BDate.value.replace(/-/g, "/")).getTime();
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
	
	Sat_To_Danger.Cpm_Id.value = Sat_To_Danger.Func_Cpm_Id.value;
	Sat_To_Danger.BTime.value = Sat_To_Danger.BDate.value;
	Sat_To_Danger.ETime.value = Sat_To_Danger.EDate.value;
	Sat_To_Danger.submit();
}

function GoPage(pPage)
{
	/**var days = new Date(Sat_To_Danger.EDate.value.replace(/-/g, "/")).getTime() - new Date(Sat_To_Danger.BDate.value.replace(/-/g, "/")).getTime();
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
	Sat_To_Danger.Cpm_Id.value = Sat_To_Danger.Func_Cpm_Id.value;
	Sat_To_Danger.BTime.value = Sat_To_Danger.BDate.value;
	Sat_To_Danger.ETime.value = Sat_To_Danger.EDate.value;
	Sat_To_Danger.CurrPage.value = pPage;
	Sat_To_Danger.submit();
}

var req = null;
function doExport()
{
	/**var days = new Date(Sat_To_Danger.EDate.value.replace(/-/g, "/")).getTime() - new Date(Sat_To_Danger.BDate.value.replace(/-/g, "/")).getTime();
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
		var url = "Sat_Danger_Export.do?Sid=<%=Sid%>&Cpm_Id="+Sat_To_Danger.Func_Cpm_Id.value+"&BTime="+Sat_To_Danger.BDate.value+"&ETime="+Sat_To_Danger.EDate.value+"&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Type_Id=<%=currStatus.getFunc_Type_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>";
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
	
function ToXX(pSN)
{	
		window.parent.frames.mFrame.location = "Sat_Danger.do?Cmd=2&Sid=<%=Sid%>&SN="+pSN;
}	
	
</SCRIPT>
</html>