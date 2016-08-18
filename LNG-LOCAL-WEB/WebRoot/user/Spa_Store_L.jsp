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
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
<script type="text/javascript" src="../skin/js/util.js"></script>
<script type="text/javascript" src="../skin/js/day.js"></script>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role     = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	ArrayList User_Manage_Role = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	UserInfoBean UserInfo      = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
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
	
	
 	int Year = Integer.parseInt(CommUtil.getDate().substring(0,4));
  int Month = Integer.parseInt(CommUtil.getLastMonth(CommUtil.getDate().substring(0,7)).substring(5,7));
  int Quarter = 1;
  if(null != (String)session.getAttribute("Year_" + Sid) && ((String)session.getAttribute("Year_" + Sid)).trim().length() > 0){Year = CommUtil.StrToInt((String)session.getAttribute("Year_" + Sid));}
  if(null != (String)session.getAttribute("Month_" + Sid) && ((String)session.getAttribute("Month_" + Sid)).trim().length() > 0){Month = CommUtil.StrToInt((String)session.getAttribute("Month_" + Sid));}
  if(null != (String)session.getAttribute("Quarter_" + Sid) && ((String)session.getAttribute("Quarter_" + Sid)).trim().length() > 0){Quarter = CommUtil.StrToInt((String)session.getAttribute("Quarter_" + Sid));}
  
  CurrStatus currStatus   = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList Spa_Store     = (ArrayList)session.getAttribute("Spa_Store_" + Sid);
  ArrayList Spa_Store_Type   = (ArrayList)session.getAttribute("Spa_Store_Type_" + Sid);
  ArrayList Spa_Store_Mode    = (ArrayList)session.getAttribute("Spa_Store_Mode_" + Sid);
  ArrayList Spa_Store_Cpm     = (ArrayList)session.getAttribute("Spa_Store_Cpm_" + Sid);
  ArrayList Spa_Station_L     = (ArrayList)session.getAttribute("Spa_Station_L_" + Sid);
  ArrayList CNameList   = new ArrayList();

  int cnt = 0;
  int sn  = 0;   
  int cosp = 0;

			if( null != Spa_Store_Cpm)
			{
				Iterator itera = Spa_Store_Cpm.iterator();
				while(itera.hasNext())
				{
					SpaStoreOBean tBean = (SpaStoreOBean)itera.next();	
					cosp++;
				}
			}
						 				 
%>
<body style=" background:#CADFFF">
<form name="Spa_Store_L"  action="Spa_Store_L.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
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
				备品类型:
				<select name='Func_Corp_Id' style='width:100px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>全部</option>
					<%
					if(null != Spa_Store_Type)
					{
						Iterator typeiter = Spa_Store_Type.iterator();
						while(typeiter.hasNext())
						{
							SpaStoreBean typeBean = (SpaStoreBean)typeiter.next();
					%>
							<option value='<%=typeBean.getSpa_Type()%>' <%=currStatus.getFunc_Corp_Id().equals(typeBean.getSpa_Type())?"selected":""%>><%=typeBean.getSpa_Type()%></option>
					<%
						}
					}
					%>
				</select>
				备品类别:
				<select name='Func_Type_Id' style='width:100px;height:20px' onChange="doSelect()">
					<option value='888' <%=currStatus.getFunc_Type_Id().equals("888")?"selected":""%>>全部</option>
					<%
					if(null != Spa_Store_Mode)
					{
						Iterator peiter = Spa_Store_Mode.iterator();
						while(peiter.hasNext())
						{
							SpaStoreBean peBean = (SpaStoreBean)peiter.next();
					%>
							<option value='<%=peBean.getSpa_Mode()%>' <%=currStatus.getFunc_Type_Id().equals(peBean.getSpa_Mode())?"selected":""%>><%=peBean.getSpa_Mode()%></option>
					<%
						}
					}
					%>
				</select>
			</td>
			<td width='30%' align='right'>				
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='140502' ctype='1'/>">
			</td>
		</tr>
		<tr height='30'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='50'>
						<td width='100%' align=center colspan='17'>
							<font size=4><B>
								<%
								switch(currStatus.getFunc_Sel_Id())
								{
									case 1:
								%>
											备品备件库存月报表
								<%
										break;
									case 2:
								%>
											备品备件库存季度报表
								<%
										break;
									case 3:
								%>
											备品备件库存年报表
								<%
										break;
								}
								%>
							</B></font>
						</td>
					</tr>
					<tr height='30'>
						<td width='28%' align=center colspan=3>
							类别							
						</td>
						<td width='72%' align=right colspan='14'>
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
						<td width='4%'  align='center' rowspan='2'><strong>序号</strong></td>
						<td width='8%' align='center' rowspan='2'><strong>备件名称</strong></td>
						<td width='15%' align='center' rowspan='2'><strong>规格型号</strong></td>
						<td width='4%'  align='center' rowspan='2'><strong>单位</strong></td>
						<td width='24%' align='center' colspan='5'>
							<strong>维修队结存明细</strong>
					</td>
						<td width='37%' align='center' colspan='<%=cosp%>'>
							<strong>各站结存明细</strong>
						</td>
						<td width='8%' align='center' rowspan='2'><strong>本期结存</strong></td>
					</tr>
				  <tr height='30'>
				    <td width='6%'  align='center'><strong>上期结存</strong></td>
				    <td width='6%'  align='center'><strong>进库</strong></td>
				    <td width='6%'  align='center'><strong>出库</strong></td>
				    <td width='6%'  align='center'><strong>结存</strong></td>
				    <td width='6%'  align='center'><strong>保底存量</strong></td>
				    	<%
								if( null != Spa_Store_Cpm)
								{
									Iterator iterator = Spa_Store_Cpm.iterator();
									while(iterator.hasNext())
									{
										SpaStoreOBean statBean = (SpaStoreOBean)iterator.next();	
										String Crm_Name = statBean.getCpm_Id();									
				%>													
							<td  align='center'><strong><%=Crm_Name%></strong></td>													
				<%							
									CNameList.add(Crm_Name);
									}
								}
				%>			 				 
				  </tr>
					<%
					if(Spa_Store != null)
					{
						Iterator iterator = Spa_Store.iterator();
						while(iterator.hasNext())
						{
							SpaStoreBean Bean = (SpaStoreBean)iterator.next();
							String Spa_Type = Bean.getSpa_Type();
							String Spa_Mode = Bean.getSpa_Mode();
							String Unit = Bean.getUnit();
							String Spa_I_Cnt = Bean.getSpa_I_Cnt();
							String Spa_O_Cnt = Bean.getSpa_O_Cnt();
							String Spa_S_Cnt = Bean.getSpa_S_Cnt();
							String Spa_R_Cnt = Bean.getSpa_R_Cnt();		
							int num = Integer.parseInt(Spa_I_Cnt)	+Integer.parseInt(Spa_O_Cnt)-Integer.parseInt(Spa_S_Cnt)	;							
							sn++;																									
					%>
							  <tr height='30' <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
									<td align=center><%=sn%></td>
									<td align=center rowspan='<%=cnt%>'><%=Spa_Type%></td>
							    <td align=left><%=Spa_Mode%></td>
							    <td align=center rowspan='<%=cnt%>'><%=Unit%></td>
							    <td align=center><%=Spa_I_Cnt%></td>
									<td align=center><%=Spa_O_Cnt%></td>
									<td align=center><%=Spa_S_Cnt%></td>	
									<td align=center><%=num%></td>				
									<td align=center <%=(Integer.parseInt(Spa_I_Cnt) - Integer.parseInt(Spa_R_Cnt)) < 0?"style='background:red;'":""%>><%=Spa_R_Cnt%></td>
								
											<%
											if(null != Spa_Station_L && null != CNameList)
											{
												Iterator cnamelist = CNameList.iterator();
												while(cnamelist.hasNext())
												{ 
													String cname   = (String)cnamelist.next();
													String str_num = "0";								
												Iterator statiter = Spa_Station_L.iterator();
												while(statiter.hasNext())
												{
													SpaStoreOBean stationBean = (SpaStoreOBean)statiter.next();		
													String CrmName	= stationBean.getCpm_Id();										
													if(cname.equals(CrmName) && stationBean.getSpa_Type().equals(Spa_Type) && stationBean.getSpa_Mode().equals(Spa_Mode))
													{
															str_num = stationBean.getSpa_Num();											
												}												
												}
												%>										
															<td  align=center> <%=str_num%></td>						
											<%
												}
											}
											%>
												<td  align=center> <%=num%></td>	
								</tr>
					<%
							}													
							cnt = 0;						
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

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Spa_Store_L.jsp';

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
	switch(parseInt(Spa_Store_L.Func_Sel_Id.value))
	{
		case 1:
				Spa_Store_L.BTime.value = Spa_Store_L.Year.value + '-' + StrLeftFillZero(Spa_Store_L.Month.value,2) + '-01';
				Spa_Store_L.ETime.value = Spa_Store_L.Year.value + '-' + StrLeftFillZero(Spa_Store_L.Month.value,2) + '-31';
			break;
		case 2:
				switch(parseInt(Spa_Store_L.Quarter.value))
				{
					case 1:
							Spa_Store_L.BTime.value = Spa_Store_L.Year.value + '-01-01';
							Spa_Store_L.ETime.value = Spa_Store_L.Year.value + '-03-31';
						break;
					case 2:
							Spa_Store_L.BTime.value = Spa_Store_L.Year.value + '-04-01';
							Spa_Store_L.ETime.value = Spa_Store_L.Year.value + '-06-31';
						break;
					case 3:
							Spa_Store_L.BTime.value = Spa_Store_L.Year.value + '-07-01';
							Spa_Store_L.ETime.value = Spa_Store_L.Year.value + '-09-31';
						break;
					case 4:
							Spa_Store_L.BTime.value = Spa_Store_L.Year.value + '-10-01';
							Spa_Store_L.ETime.value = Spa_Store_L.Year.value + '-12-31';
						break;
				}
			break;
		case 3:
				Spa_Store_L.BTime.value = Spa_Store_L.Year.value + '-01-01';
				Spa_Store_L.ETime.value = Spa_Store_L.Year.value + '-12-31';
			break;
	}
	//Spa_Store_L.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
	Spa_Store_L.submit();
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
	switch(parseInt(Spa_Store_L.Func_Sel_Id.value))
	{
		case 1:
				BTime = Spa_Store_L.Year.value + '-' + StrLeftFillZero(Spa_Store_L.Month.value,2) + '-01';
				ETime = Spa_Store_L.Year.value + '-' + StrLeftFillZero(Spa_Store_L.Month.value,2) + '-31';
			break;
		case 2:
				switch(parseInt(Spa_Store_L.Quarter.value))
				{
					case 1:
							BTime = Spa_Store_L.Year.value + '-01-01';
							ETime = Spa_Store_L.Year.value + '-03-31';
						break;
					case 2:
							BTime = Spa_Store_L.Year.value + '-04-01';
							ETime = Spa_Store_L.Year.value + '-06-31';
						break;
					case 3:
							BTime = Spa_Store_L.Year.value + '-07-01';
							ETime = Spa_Store_L.Year.value + '-09-31';
						break;
					case 4:
							BTime = Spa_Store_L.Year.value + '-10-01';
							ETime = Spa_Store_L.Year.value + '-12-31';
						break;
				}
			break;
		case 3:
				BTime = Spa_Store_L.Year.value + '-01-01';
				ETime = Spa_Store_L.Year.value + '-12-31';
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
		switch(parseInt(Spa_Store_L.Func_Sel_Id.value))
		{
			case 1:
					url = "Spa_Store_L_Export.do?Sid=<%=Sid%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&Func_Sel_Id=<%=currStatus.getFunc_Sel_Id()%>&BTime="+BTime+"&Year="+Spa_Store_L.Year.value+"&Month="+Spa_Store_L.Month.value;
				break;
			case 2:
					url = "Spa_Store_L_Export.do?Sid=<%=Sid%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&Func_Sel_Id=<%=currStatus.getFunc_Sel_Id()%>&BTime="+BTime+"&Year="+Spa_Store_L.Year.value+"&Quarter="+Spa_Store_L.Quarter.value;
				break;
			case 3:
					url = "Spa_Store_L_Export.do?Sid=<%=Sid%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&Func_Sel_Id=<%=currStatus.getFunc_Sel_Id()%>&BTime="+BTime+"&Year="+Spa_Store_L.Year.value;
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

//调整记录
function doFixRow(pIndex)
{
	switch(parseInt(pIndex))
	{
		case 1:
				var diag = new Dialog();
				diag.Top = "50%";
				diag.Width = 900;
				diag.Height = 400;
				diag.Title = "查看历史调整记录";
				diag.URL = "Spa_Store_L.do?Cmd=1&Sid=<%=Sid%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&Func_Sel_Id=<%=currStatus.getFunc_Sel_Id()%>";
				diag.show();
			break;
		case 2:
				var diag = new Dialog();
				diag.Top = "50%";
				diag.Width = 900;
				diag.Height = 400;
				diag.Title = "查看历史调整记录";
				diag.URL = "Spa_Station_L.do?Cmd=1&Sid=<%=Sid%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&Func_Sel_Id=<%=currStatus.getFunc_Sel_Id()%>";
				diag.show();
			break;
	}
}

//手工调整
function doFix(pIndex)
{
	switch(parseInt(pIndex))
	{
		case 1:
				var diag = new Dialog();
				diag.Top = "50%";
				diag.Width = 500;
				diag.Height = 287;
				diag.Title = "调整维修队结存明细";
				diag.URL = "Spa_Store_L_Fix1.jsp?Sid=<%=Sid%>";
				diag.show();
			break;
		case 2:
				var diag = new Dialog();
				diag.Top = "50%";
				diag.Width = 500;
				diag.Height = 223;
				diag.Title = "调整各站结存明细";
				diag.URL = "Spa_Store_L_Fix2.jsp?Sid=<%=Sid%>";
				diag.show();
			break;
	}
}
</SCRIPT>
</html>