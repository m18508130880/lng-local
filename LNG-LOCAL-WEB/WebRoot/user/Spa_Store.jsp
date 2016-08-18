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
<script type='text/javascript' src='../skin/js/browser.js'    charset='gb2312'></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role     = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	ArrayList User_Manage_Role = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	UserInfoBean UserInfo      = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	String ManageId = UserInfo.getManage_Role();
	String FpId = UserInfo.getFp_Role();
	String FpList = "";
	String Role_List = "";
	String Cpm_List  = "";
	int a    = 0;
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
				Role_List += R_Point;
				a++;
			}
		}
	}
	
  CurrStatus currStatus    = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList Spa_Station    = (ArrayList)session.getAttribute("Spa_Station_" + Sid);
  ArrayList Spa_Store      = (ArrayList)session.getAttribute("Spa_Store_" + Sid);
  ArrayList Spa_Store_Type   = (ArrayList)session.getAttribute("Spa_Store_Type_" + Sid);
  ArrayList Spa_Store_Mode    = (ArrayList)session.getAttribute("Spa_Store_Mode_" + Sid);
  ArrayList Spa_Store_Cpm      = (ArrayList)session.getAttribute("Spa_Store_Cpm_" + Sid);
  ArrayList Spa_Store_All      = (ArrayList)session.getAttribute("Spa_Store_All_" + Sid);
  ArrayList CNameList   = new ArrayList();
  String Spa_Chg  = "";
  int cnt = 0;
  int sn  = 0;
  
%>
<body style=" background:#CADFFF">
<form name="Spa_Store"  action="Spa_Store.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
				备品类型:
				<select name='Func_Corp_Id' style='width:220px;height:20px' onChange="doSelect()">
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
				<select name='Func_Type_Id' style='width:220px;height:20px' onChange="doSelect()">
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
			
				<img id="img1" src="../skin/images/pldr.gif" onClick='doAllAdd()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='140102' ctype='1'/>">	
			</td>
		</tr>
		<tr height='30'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='30'>
						<td width='3%'  align='center' rowspan='2'><strong>序号</strong></td>
						<td width='13%' align='center' rowspan='2'><strong>备件名称</strong></td>
						<td width='21%' align='center' rowspan='2'><strong>规格型号</strong></td>
						<td width='3%'  align='center' rowspan='2'><strong>单位</strong></td>
						<td width='10%' align='center' colspan='2'>
							<strong>维修队实时库存</strong>					
						</td>
						<td width='42%' align='center'colspan='7' >
							<strong>各站分配情况(备用数量)</strong>						
						</td>																	
					</tr>
				  <tr height='30'>
				  	<td   width='5%' align='center'><strong>结存数量</strong></td>
				    <!--<td   width='4%' align='center'><strong>进库</strong></td>
				    <td   width='4%' align='center'><strong>出库</strong></td>
				    <td   width='4%' align='center'><strong>结存</strong></td>-->
				    <td   width='5%' align='center'><strong>保底存量</strong></td>	
				<%
								if( null != Spa_Store_Cpm)
								{
									Iterator iterator = Spa_Store_Cpm.iterator();
									while(iterator.hasNext())
									{
										SpaStoreOBean statBean = (SpaStoreOBean)iterator.next();	
										String Crm_Name = statBean.getCpm_Id();								
				%>													
							<td width='6%' align='center'><strong><%=Crm_Name%></strong></td>														
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
							String Spa_R_Cnt = Bean.getSpa_R_Cnt();								
							sn++;																									
					%>
							  <tr height='30' <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
									<td align=center><%=sn%></td>
									<td align=center rowspan='<%=cnt%>'><%=Spa_Type%>&nbsp;</td>
							    <td align=left><%=Spa_Mode%>&nbsp;</td>
							    <td align=center rowspan='<%=cnt%>'><%=Unit%>&nbsp;</td>
							    <td align=center><%=Spa_I_Cnt%>&nbsp;</td>									
									<td align=center <%=(Integer.parseInt(Spa_I_Cnt) - Integer.parseInt(Spa_R_Cnt)) < 0?"style='background:red;'":""%>><%=Spa_R_Cnt%></td>
								
											<%
											if(null != Spa_Store_All && null != CNameList)
											{
												Iterator cnamelist = CNameList.iterator();
												while(cnamelist.hasNext())
												{ 
													String cname   = (String)cnamelist.next();
													String str_num = "0";								
												Iterator statiter = Spa_Store_All.iterator();
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
															<td  align=center> <%=str_num%>&nbsp;</td>						
											<%
												}
											}
											%>
					
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
<input type="hidden" name="Cmd" value="0">
<input type="hidden" name="Sid" value="<%=Sid%>">
<input type="hidden" name="Cpm_Id" value="">
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

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Spa_Store.jsp';

function doSelect()
{
	//Spa_Store.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
	Spa_Store.submit();
}

//添加
function doAdd()
{
	location = "Spa_Store_Add.jsp?Sid=<%=Sid%>";
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
		var url = "Spa_Store_Export.do?Sid=<%=Sid%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>";
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

//报废处理
function doEdt(pSpa_Type, pSpa_Mode)
{
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 500;
	diag.Height = 300;
	diag.Title = "报废处理";
	diag.URL = "Spa_Store_Edt.jsp?Sid=<%=Sid%>&Spa_Type="+pSpa_Type+"&Spa_Mode="+pSpa_Mode;
	diag.show();
}

//保底更新
function doRdt(pSpa_Type, pSpa_Mode)
{
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 500;
	diag.Height = 268;
	diag.Title = "保底更新";
	diag.URL = "Spa_Store_Rdt.jsp?Sid=<%=Sid%>&Spa_Type="+pSpa_Type+"&Spa_Mode="+pSpa_Mode;
	diag.show();
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
				diag.URL = "Spa_Store.do?Cmd=1&Sid=<%=Sid%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>";
				diag.show();
			break;
		case 2:
				var diag = new Dialog();
				diag.Top = "50%";
				diag.Width = 900;
				diag.Height = 400;
				diag.Title = "查看历史调整记录";
				diag.URL = "Spa_Station.do?Cmd=1&Sid=<%=Sid%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>";
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
				diag.Height = 255;
				diag.Title = "调整维修队实时库存";
				diag.URL = "Spa_Store_Fix1.jsp?Sid=<%=Sid%>";
				diag.show();
			break;
		case 2:
				var diag = new Dialog();
				diag.Top = "50%";
				diag.Width = 500;
				diag.Height = 287;
				diag.Title = "调整各站分配情况";
				diag.URL = "Spa_Store_Fix2.jsp?Sid=<%=Sid%>";
				diag.show();
			break;
	}
}
//连接申购
function doSG()
{
	location = "Spa_Store_I_Add.jsp?Sid=<%=Sid%>";
}
//出库
function doCK()
{
	location = "Spa_Store_O_Add.jsp?Sid=<%=Sid%>";
}

function doAllAdd()
{
	var Pdiag = new Dialog();
	Pdiag.Top = "50%";
	Pdiag.Width = 500;
	Pdiag.Height = 120;
	Pdiag.Title = "备品备件台账导入";
	Pdiag.URL = 'Spa_Store_File.jsp?Sid=<%=Sid%>&Func_Corp_Id=9999';
	Pdiag.show();

}
</SCRIPT>
</html>