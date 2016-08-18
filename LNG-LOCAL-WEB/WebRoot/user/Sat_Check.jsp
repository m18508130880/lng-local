<%@ page contentType="text/html; charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.math.*" %>
<%@ page import="java.text.*" %>
<%@ taglib uri="/WEB-INF/limitvalidatetag.tld" prefix="Limit"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type='text/css' href='../skin/css/style.css' rel='stylesheet'/>
<script type='text/javascript' src='../skin/js/day.js'></script>
<script type='text/javascript' src='../skin/js/util.js'></script>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/My97DatePicker/WdatePicker.js'></script>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	ArrayList User_User_Info = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
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
	
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  String BDate = currStatus.getVecDate().get(0).toString().substring(0,10);
	String EDate = currStatus.getVecDate().get(1).toString().substring(0,10);
	ArrayList Sat_Danger_Level   = (ArrayList)session.getAttribute("Sat_Danger_Level_" + Sid);
	ArrayList Sat_Check_Type = (ArrayList)session.getAttribute("Sat_Check_Type_" + Sid);
  ArrayList Sat_Check      = (ArrayList)session.getAttribute("Sat_Check_" + Sid);
  ArrayList Sat_Danger      = (ArrayList)session.getAttribute("Sat_Danger_" + Sid);
  ArrayList Sat_Beank      = (ArrayList)session.getAttribute("Sat_Beank_" + Sid);
  int sn = 0; 
  
%>
<body style=" background:#CADFFF">
<form name="Sat_Check"  action="Sat_Check.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
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
				检查类型:
				<select name='Func_Corp_Id' style='width:120px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>全部</option>
					<%
					if(null != Sat_Check_Type)
					{
						Iterator typeiter = Sat_Check_Type.iterator();
						while(typeiter.hasNext())
						{
							AqscExamTypeBean typeBean = (AqscExamTypeBean)typeiter.next();
					%>
							<option value='<%=typeBean.getId()%>' <%=currStatus.getFunc_Corp_Id().equals(typeBean.getId())?"selected":""%>><%=typeBean.getCName()%></option>
					<%
						}
					}
					%> 
				</select>
				<input name='BDate' type='text' style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				-
				<input name='EDate' type='text' style='width:90px;height:18px;' value='<%=EDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
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
						<td width='3%'  align='center' class="table_deep_blue">序号</td>
						<td width='8%'  align='center' class="table_deep_blue">检查对象</td>
						<td width='8%'  align='center' class="table_deep_blue">检查类型</td>
						<td width='8%'  align='center' class="table_deep_blue">检查时间</td>
						<td width='8%'  align='center' class="table_deep_blue">检查部门</td>
						<td width='16%' align='center' class="table_deep_blue">隐患</td>
						<td width='12%' align='center' class="table_deep_blue">违章人员</td>
						<td width='8%'  align='center' class="table_deep_blue">问题描述</td>
						<td width='8%'  align='center' class="table_deep_blue">录入人员</td>
					</tr>
					<%
					 if(Sat_Check != null)
					 {
						Iterator iterator = Sat_Check.iterator();
						while(iterator.hasNext())
						{
							SatCheckBean Bean = (SatCheckBean)iterator.next();
							String SN = Bean.getSN();
							String Cpm_Id = Bean.getCpm_Id();
							String Cpm_Name = Bean.getCpm_Name();
							String Check_Dept = Bean.getCheck_Dept();
							String Check_Type = Bean.getCheck_Type();
							String Check_Type_Name = Bean.getCheck_Type_Name();
							String Check_Time = Bean.getCheck_Time();							 			 							      
							String Memo = Bean.getMemo();
							String CTime = Bean.getCTime();
							String Operator = Bean.getOperator();
							String Operator_Name = Bean.getOperator_Name();
							String Check_Break   = Bean.getCheck_Break();
							String Check_Danger  = Bean.getCheck_Danger();							
							if(null == Memo){Memo = "";}
							if(null == Check_Danger){Check_Danger = "";}
							if(null == Check_Break){Check_Break = "";}
							
							String Check_Dept_Name = "无";
						  if(null != Check_Dept)
						 	{
						 		switch(Check_Dept.length())
						 		{
						 			case 2:
						 					if(Dept.trim().length() > 0)
									 		{
									 			String[] DeptList = Dept.split(",");
												for(int i=0; i<DeptList.length; i++)
												{
										    	if(Check_Dept.equals(CommUtil.IntToStringLeftFillZero(i+1, 2)))
										    	{
												  	Check_Dept_Name = DeptList[i];
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
													if(Check_Dept.equals(devBean.getId()))
													{
														Check_Dept_Name = devBean.getBrief();
													}
												}
						 					}
						 				break;
						 		}
						 	}
						 	
							sn++;
					%>
						  <tr height='30' <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>						  
								<td align=center><%=sn%></td>
								<td align='center'><%=Cpm_Name%></td>
						    <td align='center'><%=Check_Type_Name%></td>
						    <td align='center'><%=Check_Time%></td>		    
						    <td align='center'><%=Check_Dept_Name%></td>
								<td align='center' >

								
							<%	
								if(null != Sat_Danger)	
								{
								int sn_t = 0;
									Iterator dit = Sat_Danger.iterator();									
									while(dit.hasNext())
									{
										SatDangerBean dBean = (SatDangerBean)dit.next();
										String Status        = dBean.getStatus();
										if(dBean.getCheck_SN().equals(SN) )
										{
										sn_t++;
										if(Status.equals("0")){
								%>		
								<a href="#" onClick="ToDang('<%=dBean.getSN()%>')"><font color="red">
								<%=sn_t%>、&nbsp;<%= dBean.getDanger_Type_Name()%></br></font></a>
								<%		
									}else
										{
								%>		
								<a href="#" onClick="ToDang('<%=dBean.getSN()%>')"><font color="gray">
								<%=sn_t%>、&nbsp;<%= dBean.getDanger_Type_Name()%></br></font></a>
								<%				
										}
										}									
									}
								}
							%>		
						
							<img src='../skin/images/device_cmdadd.png' title='隐患添加' onclick="doDangerAdd('<%=SN%>', '<%=Cpm_Id%>', '<%=Cpm_Name%>', '<%=Check_Time%>' )" >													
								&nbsp;	</td>	
									<td align='center'>							
						<%			if(null != Sat_Beank)
									{
										int B_SN = 0;
										Iterator useriter = Sat_Beank.iterator();
										while(useriter.hasNext())
										{
											SatBreakBean bBean = (SatBreakBean)useriter.next();											
											if(bBean.getCheck_SN().equals(SN))
											{
												B_SN++;
						%>														
									<a href="#" onClick="ToBreak('<%=bBean.getSN()%>')"><font color="red"><%=B_SN%>、&nbsp;<%=bBean.getBreak_OP_Name()%><br></font></a>
						<%					
											}
											
										}
									}	
							%>							
							<img src='../skin/images/device_cmdadd.png' title='违章添加' onclick="doBreakAdd('<%=SN%>', '<%=Cpm_Id%>', '<%=Cpm_Name%>', '<%=Check_Time%>' )" >													
									
							&nbsp;</td>																					
								<td align='center'><%=Memo%>&nbsp;</td>
								<td align='center'><%=Operator_Name%></td>
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
				      	<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
				      </tr>  
					<%
						}
					  else
					  {
					%>				
		          <tr <%=((i%2)==0?"class='table_white_l'":"class='table_blue'")%>>
			          <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
			        </tr>      
					<%
       			}
     			}
					%> 
     		 	<tr>
						<td colspan="9" class="table_deep_blue" >
				 			<table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0" >
			    			<tr valign="bottom">
			      			<td align='center' nowrap><%=currStatus.GetPageHtml("Sat_Check")%></td>
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

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Sat_Check.jsp';

//查询
function doSelect()
{
	/**var days = new Date(Sat_Check.EDate.value.replace(/-/g, "/")).getTime() - new Date(Sat_Check.BDate.value.replace(/-/g, "/")).getTime();
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
	
	Sat_Check.Cpm_Id.value = Sat_Check.Func_Cpm_Id.value;
	Sat_Check.BTime.value = Sat_Check.BDate.value;
	Sat_Check.ETime.value = Sat_Check.EDate.value;
	Sat_Check.submit();
}

//分页
function GoPage(pPage)
{
	/**var days = new Date(Sat_Check.EDate.value.replace(/-/g, "/")).getTime() - new Date(Sat_Check.BDate.value.replace(/-/g, "/")).getTime();
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
	Sat_Check.Cpm_Id.value = Sat_Check.Func_Cpm_Id.value;
	Sat_Check.BTime.value = Sat_Check.BDate.value;
	Sat_Check.ETime.value = Sat_Check.EDate.value;
	Sat_Check.CurrPage.value = pPage;
	Sat_Check.submit();
}

//导出
var req = null;
function doExport()
{
	/**var days = new Date(Sat_Check.EDate.value.replace(/-/g, "/")).getTime() - new Date(Sat_Check.BDate.value.replace(/-/g, "/")).getTime();
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
		var url = "Sat_Check_Export.do?Sid=<%=Sid%>&Cpm_Id="+Sat_Check.Func_Cpm_Id.value+"&BTime="+Sat_Check.BDate.value+"&ETime="+Sat_Check.EDate.value+"&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>";
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

//添加
function doAdd()
{
	location = "Sat_Check_Add.jsp?Sid=<%=Sid%>";
}

//统计
function doLedger()
{
	var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
  var ETime = showPreviousLastDay().format("yyyy-MM-dd");
  var Year  = BTime.substring(0,4);
  var Month = BTime.substring(5,7);
	location = "Sat_Check_L.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id="+Sat_Check.Func_Cpm_Id.value+"&Func_Sub_Id=1&Func_Corp_Id=9999&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month;
}

//隐患录入
function doDangerAdd(pSN, pCpm_Id, pCpm_Name, pCheck_Time)
{
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 400;
	diag.Height = 318;
	diag.Title = "隐患跟踪录入";
	diag.URL = 'Sat_Check_Add_Danger.jsp?Sid=<%=Sid%>&Check_SN='+pSN+'&Cpm_Id='+pCpm_Id+'&Cpm_Name='+pCpm_Name+'&&Check_Time='+pCheck_Time;
	diag.show();
}

//违章录入
function doBreakAdd(pSN, pCpm_Id, pCpm_Name, pCheck_Time)
{
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 400;
	diag.Height = 318;
	diag.Title = "违章记录录入";
	diag.URL = 'Sat_Check_Add_Break.jsp?Sid=<%=Sid%>&Check_SN='+pSN+'&Cpm_Id='+pCpm_Id+'&Cpm_Name='+pCpm_Name+'&Check_Time='+pCheck_Time;
	diag.show();
}

//删除隐患
var reqDangerDele = null;
function doDangerDele(pSN, pDangerSN, pCheck_Danger)
{
	var Check_Danger = '';
	var list = pCheck_Danger.split(',');
	for(var i=0; i<list.length && list[i].length>0; i++)
	{
		if(list[i] != pDangerSN)
			Check_Danger += list[i] + ',';
	}
	if(confirm("确定删除当前隐患?"))
  {
  	if(window.XMLHttpRequest)
	  {
			reqDangerDele = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqDangerDele = new ActiveXObject("Microsoft.XMLHTTP");
		}		
		//设置回调函数
		reqDangerDele.onreadystatechange = function()
		{
			var state = reqDangerDele.readyState;
			if(state == 4)
			{
				if(reqDangerDele.status == 200)
				{
					var resp = reqDangerDele.responseText;			
					if(resp != null && resp.substring(0,4) == '0000')
					{
						alert('成功');
						doSelect();
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
		var url = 'Sat_Check_Del.do?Cmd=15&Sid=<%=Sid%>&SN='+pSN+'&DangerSN='+pDangerSN+'&Check_Danger='+Check_Danger+'&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>&currtime='+new Date();
		reqDangerDele.open("post",url,true);
		reqDangerDele.send(null);
		return true;
  }
}

//删除违章
var reqBreakDele = null;
function doBreakDele(pSN, pBreakSN, pCheck_Break)
{
	var Check_Break = '';
	var list = pCheck_Break.split(',');
	for(var i=0; i<list.length && list[i].length>0; i++)
	{
		if(list[i] != pBreakSN)
			Check_Break += list[i] + ',';
	}
	if(confirm("确定删除当前违章?"))
  {
  	if(window.XMLHttpRequest)
	  {
			reqDangerDele = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqDangerDele = new ActiveXObject("Microsoft.XMLHTTP");
		}		
		//设置回调函数
		reqDangerDele.onreadystatechange = function()
		{
			var state = reqDangerDele.readyState;
			if(state == 4)
			{
				if(reqDangerDele.status == 200)
				{
					var resp = reqDangerDele.responseText;			
					if(resp != null && resp.substring(0,4) == '0000')
					{
						alert('成功');
						doSelect();
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
		var url = 'Sat_Check_Del.do?Cmd=16&Sid=<%=Sid%>&SN='+pSN+'&BreakSN='+pBreakSN+'&Check_Break='+Check_Break+'&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>&currtime='+new Date();
		reqDangerDele.open("post",url,true);
		reqDangerDele.send(null);
		return true;
  }
}

//违章链接
function doBreakLink(pSN)
{
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 360;
	diag.Height = 318;
	diag.Title = "违章记录查询、编辑";
	diag.URL = "Sat_Break.do?Cmd=1&Sid=<%=Sid%>&SN="+pSN+"&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>";
	diag.show();
}

//隐患链接-修改隐患基本信息
function doDangerLink01(pSN)
{
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 360;
	diag.Height = 318;
	diag.Title = "隐患基本信息查询、编辑";
	diag.URL = "Sat_Danger.do?Cmd=1&Sid=<%=Sid%>&Func_Sel_Id=1&SN="+pSN+"&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>";
	diag.show();
}

//隐患链接-修改确定方案
function doDangerLink02(pSN)
{
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 360;
	diag.Height = 318;
	diag.Title = "确定方案查询、编辑";
	diag.URL = "Sat_Danger.do?Cmd=1&Sid=<%=Sid%>&Func_Sel_Id=2&SN="+pSN+"&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>";
	diag.show();
}

//隐患链接-修改实施整改
function doDangerLink03(pSN)
{
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 360;
	diag.Height = 318;
	diag.Title = "实施整改查询、编辑";
	diag.URL = "Sat_Danger.do?Cmd=1&Sid=<%=Sid%>&Func_Sel_Id=3&SN="+pSN+"&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>";
	diag.show();
}

//隐患链接-修改审核验收
function doDangerLink04(pSN)
{
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 360;
	diag.Height = 318;
	diag.Title = "审核验收查询、编辑";
	diag.URL = "Sat_Danger.do?Cmd=1&Sid=<%=Sid%>&Func_Sel_Id=4&SN="+pSN+"&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>";
	diag.show();
}
function ToDang(pSN)
{
	window.parent.frames.mFrame.location = "Sat_Danger.do?Cmd=2&Sid=<%=Sid%>&SN="+pSN;
}

function ToBreak(pSN)
{
	window.parent.frames.mFrame.location = "Sat_Break.do?Cmd=2&Sid=<%=Sid%>&SN="+pSN;
}





</SCRIPT>
</html>