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
	
  CurrStatus currStatus    = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Sat_Train_Type = (ArrayList)session.getAttribute("Sat_Train_Type_" + Sid);
  ArrayList Sat_Train_L    = (ArrayList)session.getAttribute("Sat_Train_L_" + Sid);
  
  int sn = 0;
  int Year = Integer.parseInt(CommUtil.getDate().substring(0,4));
  int Month = Integer.parseInt(CommUtil.getLastMonth(CommUtil.getDate().substring(0,7)).substring(5,7));
  if(null != (String)session.getAttribute("Year_" + Sid) && ((String)session.getAttribute("Year_" + Sid)).trim().length() > 0){Year = CommUtil.StrToInt((String)session.getAttribute("Year_" + Sid));}
  if(null != (String)session.getAttribute("Month_" + Sid) && ((String)session.getAttribute("Month_" + Sid)).trim().length() > 0){Month = CommUtil.StrToInt((String)session.getAttribute("Month_" + Sid));}
  
  //累计
  int Train_Cnt_All = 0;
  int Train_Object_All = 0;
  int Train_Hour_All = 0;
  
%>
<body style=" background:#CADFFF">
<form name="Sat_Train_L"  action="Sat_Train_L.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
				培训类型:
        <select name='Func_Corp_Id' style='width:120px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>全部</option>
					<%
					if(null != Sat_Train_Type)
					{
						Iterator typeiter = Sat_Train_Type.iterator();
						while(typeiter.hasNext())
						{
							AqscTrainTypeBean typeBean = (AqscTrainTypeBean)typeiter.next();
					%>
							<option value='<%=typeBean.getId()%>' <%=currStatus.getFunc_Corp_Id().equals(typeBean.getId())?"selected":""%>><%=typeBean.getCName()%></option>
					<%
						}
					}
					%>
				</select>
				<select name="Func_Sub_Id"  style="width:90px;height:20px" onChange="doSelect()">
					<option value="0" <%=(currStatus.getFunc_Sub_Id() == 0 ?"SELECTED":"")%>>年报表</option>
	        <option value="1" <%=(currStatus.getFunc_Sub_Id() == 1 ?"SELECTED":"")%>>月报表</option>
	      </select>
	      <select id="Year" name="Year" style="width:70px;height:20px;">
        <%
        for(int j=2010; j<=2049; j++)
        {
        %>
          <option value="<%=j%>" <%=(Year == j?"selected":"")%>><%=j%>年</option>
        <%
        }
        %>
        </select>
        <select id="Month" name="Month" style="width:60px;height:20px;">
        <%
        for(int k=1; k<13; k++)
        {
       	%>
       		<option value="<%=k%>" <%=(Month == k?"selected":"")%>><%=k%>月</option>
       	<%
       	}
       	%>
        </select>
			</td>
			<td width='30%' align='right'>
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='090405' ctype='1'/>">
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25' valign='middle'>
						<td width='10%' align='center' class="table_deep_blue">培训类型</td>
						<td width='10%' align='center' class="table_deep_blue">培训次数</td>
						<td width='10%' align='center' class="table_deep_blue">培训人数</td>
						<td width='10%' align='center' class="table_deep_blue">培训课时</td>
					</tr>
					<%
					if(Sat_Train_L != null)
					{
						Iterator iterator = Sat_Train_L.iterator();
						while(iterator.hasNext())
						{
							SatTrainLBean Bean = (SatTrainLBean)iterator.next();
							String Train_Type_Name = Bean.getTrain_Type_Name();
							String Train_Cnt = Bean.getTrain_Cnt();
							String Train_Object = Bean.getTrain_Object();
							String Train_Hour = Bean.getTrain_Hour();
							
							Train_Cnt_All += Integer.parseInt(Train_Cnt);
						  Train_Object_All += Integer.parseInt(Train_Object);
						  Train_Hour_All += Integer.parseInt(Train_Hour);
						  
							sn++;
					%>
						  <tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
						    <td align=center><%=Train_Type_Name%></td>
						    <td align=center><%=Train_Cnt%></td>
						    <td align=center><%=Train_Object%></td>
						    <td align=center><%=Train_Hour%></td>
							</tr>
					<%
						}
					%>
							<tr height=30>
								<td align=center><B>累计</B></td>
						    <td align=center><B><%=Train_Cnt_All%></B></td>
						    <td align=center><B><%=Train_Object_All%></B></td>
						    <td align=center><B><%=Train_Hour_All%></B></td>
							</tr>
					<%
					}
					if(0 == sn)
					{
					%>
						<tr height=30>
							<td width='100%' align=center colspan=4>无!</td>
						</tr>
					<%
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

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Sat_Train_L.jsp';

switch(parseInt(<%=currStatus.getFunc_Sub_Id()%>))
{
	case 0://年报表
			document.getElementById('Year').style.display  = '';
			document.getElementById('Month').style.display = 'none';
		break;
	case 1://月报表
			document.getElementById('Year').style.display  = '';
			document.getElementById('Month').style.display = '';
		break;
}

function doSelect()
{
	switch(parseInt(Sat_Train_L.Func_Sub_Id.value))
	{
		case 0://年报表
				var Year  = new Date().format("yyyy-MM-dd").substring(0,4);
				Sat_Train_L.BTime.value = Sat_Train_L.Year.value + '-01-01';
  			Sat_Train_L.ETime.value = Sat_Train_L.Year.value + '-12-31';
			break;
		case 1://月报表
				Sat_Train_L.BTime.value = Sat_Train_L.Year.value + '-' + StrLeftFillZero(Sat_Train_L.Month.value,2) + '-01';
  			Sat_Train_L.ETime.value = getFirstAndLastMonthDay(Sat_Train_L.Year.value, StrLeftFillZero(Sat_Train_L.Month.value,2));
			break;
	}
	
	//Sat_Train_L.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
	Sat_Train_L.submit();
}

//导出
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
	
	switch(parseInt(Sat_Train_L.Func_Sub_Id.value))
	{
		case 0://年报表
				var Year  = new Date().format("yyyy-MM-dd").substring(0,4);
				Sat_Train_L.BTime.value = Sat_Train_L.Year.value + '-01-01';
  			Sat_Train_L.ETime.value = Sat_Train_L.Year.value + '-12-31';
			break;
		case 1://月报表
				Sat_Train_L.BTime.value = Sat_Train_L.Year.value + '-' + StrLeftFillZero(Sat_Train_L.Month.value,2) + '-01';
  			Sat_Train_L.ETime.value = getFirstAndLastMonthDay(Sat_Train_L.Year.value, StrLeftFillZero(Sat_Train_L.Month.value,2));
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
		var url = "Sat_Train_L_Export.do?Sid=<%=Sid%>&BTime="+Sat_Train_L.BTime.value+"&ETime="+Sat_Train_L.ETime.value+"&Year="+Sat_Train_L.Year.value+"&Month="+Sat_Train_L.Month.value+"&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>";
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