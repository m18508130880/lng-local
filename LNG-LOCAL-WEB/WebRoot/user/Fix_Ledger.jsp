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
<script type="text/javascript" src="../skin/js/util.js"></script>
<script type="text/javascript" src="../skin/js/day.js"></script>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo  = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
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
 	
 	int Year = Integer.parseInt(CommUtil.getDate().substring(0,4));
  int Month = Integer.parseInt(CommUtil.getLastMonth(CommUtil.getDate().substring(0,7)).substring(5,7));
  int Quarter = 1;
  if(null != (String)session.getAttribute("Year_" + Sid) && ((String)session.getAttribute("Year_" + Sid)).trim().length() > 0){Year = CommUtil.StrToInt((String)session.getAttribute("Year_" + Sid));}
  if(null != (String)session.getAttribute("Month_" + Sid) && ((String)session.getAttribute("Month_" + Sid)).trim().length() > 0){Month = CommUtil.StrToInt((String)session.getAttribute("Month_" + Sid));}
  if(null != (String)session.getAttribute("Quarter_" + Sid) && ((String)session.getAttribute("Quarter_" + Sid)).trim().length() > 0){Quarter = CommUtil.StrToInt((String)session.getAttribute("Quarter_" + Sid));}
  
  CurrStatus currStatus    = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList Dev_List_Breed = (ArrayList)session.getAttribute("Dev_List_Breed_" + Sid);
  ArrayList Fix_Ledger     = (ArrayList)session.getAttribute("Fix_Ledger_" + Sid);
  ArrayList Fix_Trace     = (ArrayList)session.getAttribute("Fix_Trace_" + Sid);
  
  String Cpm_Chg  = "";
  int cnt = 0;
  int sn  = 0;
  double Value_O_All       = 0.0;
%>
<body style=" background:#CADFFF">
<form name="Fix_Ledger" action="Fix_Ledger.do" method="post" target="mFrame">
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
				模式:
				<select name="Func_Sel_Id"  style="width:90px;height:20px" onChange="doSelect()">					
	        <option value="1" <%=(currStatus.getFunc_Sel_Id() == 1 ?"SELECTED":"")%>>月报表</option>
	        <option value="2" <%=(currStatus.getFunc_Sel_Id() == 2 ?"SELECTED":"")%>>季报表</option>
	        <option value="3" <%=(currStatus.getFunc_Sel_Id() == 3 ?"SELECTED":"")%>>年报表</option>
	      </select>
	      <select id="Year" name="Year" style="width:70px;height:20px;display:none;">
        <%
        for(int j=2012; j<=2030; j++)
        {
        %>
          <option value="<%=j%>" <%=(Year == j?"selected":"")%>><%=j%>年</option>
        <%
        }
        %>
        </select>
        <select id="Month" name="Month" style="width:70px;height:20px;display:none;">
        <%
        for(int k=1; k<13; k++)
        {
       	%>
       		<option value="<%=k%>" <%=(Month == k?"selected":"")%>><%=k%>月</option>
       	<%
       	}
       	%>
        </select>
        <select id="Quarter" name="Quarter" style="width:70px;height:20px;display:none;">
        	<option value="1" <%=(Quarter == 1?"selected":"")%>>第一季</option>
        	<option value="2" <%=(Quarter == 2?"selected":"")%>>第二季</option>
        	<option value="3" <%=(Quarter == 3?"selected":"")%>>第三季</option>
        	<option value="4" <%=(Quarter == 4?"selected":"")%>>第四季</option>
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
			</td>
			<td width='30%' align='right'>				
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' >
			</td>
		</tr>
		<tr height='30'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='50'>
						<td width='100%' align=center colspan='5'>
							<font size=4><B>
					<%
								switch(currStatus.getFunc_Sel_Id())
								{
									case 1:
					%>
											故障统计月报表
					<%
										break;
									case 2:
					%>
											故障统计季度报表
					<%
										break;
									case 3:
					%>
											故障统计年报表
					<%
										break;
								}
					%>
							</B></font>
						</td>
					</tr>
					<tr height='30'>						
						<td width='100%' align=right colspan='5'>
					<%
							switch(currStatus.getFunc_Sel_Id())
							{
								case 1:
					%>
										<%=Year%>年<%=Month%>月
					<%
									break;
								case 2:
										switch(Quarter)
										{
											case 1:
					%>
													<%=Year%>年第一季度
					<%
												break;
											case 2:
					%>
													<%=Year%>年第二季度
					<%
												break;
											case 3:
					%>
													<%=Year%>年第三季度
					<%
												break;
											case 4:
					%>
													<%=Year%>年第四季度
					<%
												break;
										}
									break;
								case 3:
					%>
										<%=Year%>年
					<%
									break;
							}
					%>						
						</td>
					</tr>
					<tr height='30'>
						<td width='10%' align='center'><strong>序号</strong></td>
						<td width='30%' align='center'><strong>场站名称</strong></td>
						<td width='30%' align='center'><strong>设备名称</strong></td>
						<td width='30%' align='center'><strong>故障次数</strong></td>						
					</tr>
					
				  <%
				  
				  if(null != Fix_Trace)
				  {
				  	Iterator iter = Fix_Trace.iterator();
				  	while(iter.hasNext())
				  	{
				  		FixTraceBean traBean = (FixTraceBean)iter.next();
				  		String des = traBean.getFix_Des();
				  		String[] str1 = des.split(";");
				  		for(int a =0;a<str1.length&&str1[a].length()>0;a++)
				  		{				  				
				  				String[] str2 = str1[a].split(",");			  				
				  				String str3 = str2[2]; 		
				  				 Value_O_All     = Value_O_All + Double.parseDouble(str3);			  						
				  		}		
				  			  							
				  	}		
				  }		
				  	  
					if(Fix_Ledger != null)
					{
						Iterator iterator = Fix_Ledger.iterator();
						while(iterator.hasNext())
						{
							FixLedgerBean Bean = (FixLedgerBean)iterator.next();
							String Dev_SN   = Bean.getDev_SN();
							String Cpm_Id   = Bean.getCpm_Id();
							String Cpm_Name = Bean.getCpm_Name();
							String Dev_Type = Bean.getDev_Type();
							String Dev_Name = Bean.getDev_Name();
							String Fix_Cnt  = Bean.getFix_Cnt();
							
							sn++;
							
							if(!Cpm_Chg.equals(Cpm_Id))
							{
								Iterator curriter = Fix_Ledger.iterator();
								while(curriter.hasNext())
								{
									FixLedgerBean currBean = (FixLedgerBean)curriter.next();
									if(currBean.getCpm_Id().equals(Cpm_Id))
									{
										cnt++;
									}
								}
														
										
					%>
							  <tr height='30' <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
									<td align=center><%=sn%></td>
									<td align=center rowspan='<%=cnt%>'><%=Cpm_Name%><br><a href="#" onClick="ToXH()"><font color="red">共计消耗器材<%=Value_O_All%>件</font></a></td>
							    <td align=center><a href="#" onClick="ToSG('<%=Dev_SN%>')"><font color="red"><%=Dev_Name%></font></a></td>
							    <td align=center><%=Fix_Cnt%></td>							    
								</tr>
					<%
							}
							else
							{
					%>
							  <tr height='30' <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
									<td align=center><%=sn%></td>
							    <td align=center><a href="#" onClick="ToSG('<%=Dev_SN%>')"><font color="red"><%=Dev_Name%></font></a></td>
							    <td align=center><%=Fix_Cnt%></td>							    
								</tr>
					<%
							}
							
							cnt = 0;
							Cpm_Chg = Cpm_Id;
						}
					}
					%>
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
<input type="button" id="CurrButton" onClick="doSelect()" style="display:none">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//ipad禁掉导出
if(1 == fBrowserRedirect() || 2 == fBrowserRedirect())
{
	document.getElementById('img2').style.display = 'none';
}

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Fix_Ledger.jsp';

switch(parseInt(<%=currStatus.getFunc_Sel_Id()%>))
{
	case 1:
			document.getElementById('Year').style.display = '';
			document.getElementById('Month').style.display = '';
			document.getElementById('Quarter').style.display = 'none';
		break;
	case 2:
			document.getElementById('Year').style.display = '';
			document.getElementById('Month').style.display = 'none';
			document.getElementById('Quarter').style.display = '';
		break;
	case 3:
			document.getElementById('Year').style.display = '';
			document.getElementById('Month').style.display = 'none';
			document.getElementById('Quarter').style.display = 'none';
		break;
}

function doSelect()
{
	switch(parseInt(Fix_Ledger.Func_Sel_Id.value))
	{
		case 1:
				Fix_Ledger.BTime.value = Fix_Ledger.Year.value + '-' + StrLeftFillZero(Fix_Ledger.Month.value,2) + '-01';
				Fix_Ledger.ETime.value = Fix_Ledger.Year.value + '-' + StrLeftFillZero(Fix_Ledger.Month.value,2) + '-31';
			break;
		case 2:
				switch(parseInt(Fix_Ledger.Quarter.value))
				{
					case 1:
							Fix_Ledger.BTime.value = Fix_Ledger.Year.value + '-01-01';
							Fix_Ledger.ETime.value = Fix_Ledger.Year.value + '-03-31';
						break;
					case 2:
							Fix_Ledger.BTime.value = Fix_Ledger.Year.value + '-04-01';
							Fix_Ledger.ETime.value = Fix_Ledger.Year.value + '-06-31';
						break;
					case 3:
							Fix_Ledger.BTime.value = Fix_Ledger.Year.value + '-07-01';
							Fix_Ledger.ETime.value = Fix_Ledger.Year.value + '-09-31';
						break;
					case 4:
							Fix_Ledger.BTime.value = Fix_Ledger.Year.value + '-10-01';
							Fix_Ledger.ETime.value = Fix_Ledger.Year.value + '-12-31';
						break;
				}
			break;
		case 3:
				Fix_Ledger.BTime.value = Fix_Ledger.Year.value + '-01-01';
				Fix_Ledger.ETime.value = Fix_Ledger.Year.value + '-12-31';
			break;
	}
	Fix_Ledger.Cpm_Id.value = Fix_Ledger.Func_Cpm_Id.value;
	Fix_Ledger.submit();
}

var req = null;
function doExport()
{
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
	
	var BTime = '';
	var ETime = '';
	switch(parseInt(Fix_Ledger.Func_Sel_Id.value))
	{
		case 1:
				BTime = Fix_Ledger.Year.value + '-' + StrLeftFillZero(Fix_Ledger.Month.value,2) + '-01';
				ETime = Fix_Ledger.Year.value + '-' + StrLeftFillZero(Fix_Ledger.Month.value,2) + '-31';
			break;
		case 2:
				switch(parseInt(Fix_Ledger.Quarter.value))
				{
					case 1:
							BTime = Fix_Ledger.Year.value + '-01-01';
							ETime = Fix_Ledger.Year.value + '-03-31';
						break;
					case 2:
							BTime = Fix_Ledger.Year.value + '-04-01';
							ETime = Fix_Ledger.Year.value + '-06-31';
						break;
					case 3:
							BTime = Fix_Ledger.Year.value + '-07-01';
							ETime = Fix_Ledger.Year.value + '-09-31';
						break;
					case 4:
							BTime = Fix_Ledger.Year.value + '-10-01';
							ETime = Fix_Ledger.Year.value + '-12-31';
						break;
				}
			break;
		case 3:
				BTime = Fix_Ledger.Year.value + '-01-01';
				ETime = Fix_Ledger.Year.value + '-12-31';
			break;
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
		var url = "";
		switch(parseInt(Fix_Ledger.Func_Sel_Id.value))
		{
			case 1:
					url = "Fix_Ledger_Export.do?Sid=<%=Sid%>&Cpm_Id="+Fix_Ledger.Func_Cpm_Id.value+"&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sel_Id=<%=currStatus.getFunc_Sel_Id()%>&BTime="+BTime+"&ETime="+ETime+"&Year="+Fix_Ledger.Year.value+"&Month="+Fix_Ledger.Month.value;
				break;
			case 2:
					url = "Fix_Ledger_Export.do?Sid=<%=Sid%>&Cpm_Id="+Fix_Ledger.Func_Cpm_Id.value+"&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sel_Id=<%=currStatus.getFunc_Sel_Id()%>&BTime="+BTime+"&ETime="+ETime+"&Year="+Fix_Ledger.Year.value+"&Quarter="+Fix_Ledger.Quarter.value;
				break;
			case 3:
					url = "Fix_Ledger_Export.do?Sid=<%=Sid%>&Cpm_Id="+Fix_Ledger.Func_Cpm_Id.value+"&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sel_Id=<%=currStatus.getFunc_Sel_Id()%>&BTime="+BTime+"&ETime="+ETime+"&Year="+Fix_Ledger.Year.value;
				break;
		}
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

function ToSG(pDev_SN)
{
	var BTime ="";
	var ETime = "";
	switch(parseInt(Fix_Ledger.Func_Sel_Id.value))
	{
		case 1:
				BTime = Fix_Ledger.Year.value + '-' + StrLeftFillZero(Fix_Ledger.Month.value,2) + '-01';
				ETime = Fix_Ledger.Year.value + '-' + StrLeftFillZero(Fix_Ledger.Month.value,2) + '-31';
			break;
		case 2:
				switch(parseInt(Fix_Ledger.Quarter.value))
				{
					case 1:
							BTime = Fix_Ledger.Year.value + '-01-01';
							ETime = Fix_Ledger.Year.value + '-03-31';
						break;
					case 2:
							BTime = Fix_Ledger.Year.value + '-04-01';
							ETime = Fix_Ledger.Year.value + '-06-31';
						break;
					case 3:
							BTime = Fix_Ledger.Year.value + '-07-01';
							ETime = Fix_Ledger.Year.value + '-09-31';
						break;
					case 4:
							BTime = Fix_Ledger.Year.value + '-10-01';
							ETime = Fix_Ledger.Year.value + '-12-31';
						break;
				}
			break;
		case 3:
				BTime = Fix_Ledger.Year.value + '-01-01';
				ETime = Fix_Ledger.Year.value + '-12-31';
			break;
	}			
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 700;
	diag.Height = 120;
	diag.Title = "故障详情";
	diag.URL ="Fix_Trace.do?Cmd=2&Sid=<%=Sid%>&Cpm_Id="+Fix_Ledger.Func_Cpm_Id.value+"&Dev_SN="+pDev_SN+"&BTime="+BTime+"&ETime="+ETime;
	diag.show();	
}

function ToXH()
{
	var BTime ="";
	var ETime = "";
	var str = "";
	switch(parseInt(Fix_Ledger.Func_Sel_Id.value))
	{
		case 1:
				str   = Fix_Ledger.Year.value + '-' + StrLeftFillZero(Fix_Ledger.Month.value,2)+"月 消耗品清单";
				BTime = Fix_Ledger.Year.value + '-' + StrLeftFillZero(Fix_Ledger.Month.value,2) + '-01';
				ETime = Fix_Ledger.Year.value + '-' + StrLeftFillZero(Fix_Ledger.Month.value,2) + '-31';
			break;
		case 2:
				switch(parseInt(Fix_Ledger.Quarter.value))
				{
					case 1:
							str   = Fix_Ledger.Year.value + '第一季 消耗品清单';
							BTime = Fix_Ledger.Year.value + '-01-01';
							ETime = Fix_Ledger.Year.value + '-03-31';
						break;
					case 2:
							str   = Fix_Ledger.Year.value + '第二季 消耗品清单';
							BTime = Fix_Ledger.Year.value + '-04-01';
							ETime = Fix_Ledger.Year.value + '-06-31';
						break;
					case 3:
							str   = Fix_Ledger.Year.value + '第三季 消耗品清单';
							BTime = Fix_Ledger.Year.value + '-07-01';
							ETime = Fix_Ledger.Year.value + '-09-31';
						break;
					case 4:
							str   = Fix_Ledger.Year.value + '第四季 消耗品清单';
							BTime = Fix_Ledger.Year.value + '-10-01';
							ETime = Fix_Ledger.Year.value + '-12-31';
						break;
				}
			break;
		case 3:
				str   = Fix_Ledger.Year.value+"年 消耗品清单";
				BTime = Fix_Ledger.Year.value + '-01-01';
				ETime = Fix_Ledger.Year.value + '-12-31';
			break;
	}			
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 700;
	diag.Height = 260;
	diag.Title = str;
	diag.URL ="Fix_Trace.do?Cmd=3&Sid=<%=Sid%>&Cpm_Id="+Fix_Ledger.Func_Cpm_Id.value+"&BTime="+BTime+"&ETime="+ETime;
	diag.show();	
}

</SCRIPT>
</html>