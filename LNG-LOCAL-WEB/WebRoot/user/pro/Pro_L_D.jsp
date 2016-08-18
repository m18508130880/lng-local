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
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../../skin/css/style.css" rel="stylesheet"/>
<script type='text/javascript' src='../../skin/js/browser.js' charset='gb2312'></script>
<script type="text/javascript" src="../../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../../skin/js/util.js"></script>
<script type="text/javascript" src="../../skin/js/day.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%

	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	String BDate = currStatus.getVecDate().get(0).toString().substring(0,10);
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	String Operator_Name = UserInfo.getCName();
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
	
	ArrayList Pro_R_Type   = (ArrayList)session.getAttribute("Pro_R_Type_" + Sid);
	CorpInfoBean Corp_Info = (CorpInfoBean)session.getAttribute("User_Corp_Info_" + Sid);
	String Oil_Info = "";
	String Oil_Name = "";
	if(null != Corp_Info)
	{
		Oil_Info = Corp_Info.getOil_Info();
		if(null == Oil_Info){Oil_Info = "";}
		if(null != currStatus.getFunc_Corp_Id() && Oil_Info.length() > 0)
		{
			String[] List = Oil_Info.split(";");
		  for(int i=0; i<List.length && List[i].length()>0; i++)
		  {
		  	String[] subList = List[i].split(",");
		  	if(currStatus.getFunc_Corp_Id().equals(subList[0]))
		  	{
		  		Oil_Name = subList[1];
		  		break;
		  	}
  		}
		}
	}
	
	ArrayList Pro_L_Crm = (ArrayList)session.getAttribute("Pro_L_Crm_" + Sid);
  ArrayList Pro_L_D   = (ArrayList)session.getAttribute("Pro_L_D_" + Sid);
	String T_Cpm_Id = "";
	int cnt         = 0;
	
%>
<body style=" background:#CADFFF">
<form name="Pro_L_D"  action="Pro_L.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
				ȼ������:
				<select name='Func_Corp_Id' style='width:150px;height:20px' onChange="doSelect()">				
				<%
				if(null != Pro_R_Type)
				{
					Iterator typeiter = Pro_R_Type.iterator();
					while(typeiter.hasNext())
					{
						ProRBean typeBean = (ProRBean)typeiter.next();
						String type_Id = typeBean.getOil_CType();
						String type_Name = "��";
												
						if(Oil_Info.trim().length() > 0)
						{
						  String[] List = Oil_Info.split(";");
						  for(int i=0; i<List.length && List[i].length()>0; i++)
						  {
						  	String[] subList = List[i].split(",");
						  	if(type_Id.equals(subList[0]))
						  	{
						  		type_Name = subList[1];
						  		break;
						  	}
				  		}
				  	}
				%>
				  	<option value='<%=type_Id%>' <%=currStatus.getFunc_Corp_Id().equals(type_Id)?"selected":""%>><%=type_Id%>|<%=type_Name%></option>
				<%				  	
					}
				}
				%>
				</select>
				<select name="Func_Sub_Id"  style="width:90px;height:20px" onChange="doChangeSelect(this.value)">
	        <option value="1" <%=(currStatus.getFunc_Sub_Id() == 1 ?"SELECTED":"")%>>�±���</option>
	        <option value="2" <%=(currStatus.getFunc_Sub_Id() == 2 ?"SELECTED":"")%>>�ܱ���</option>
	        <option value="3" <%=(currStatus.getFunc_Sub_Id() == 3 ?"SELECTED":"")%>>�ձ���</option>
	      </select>
	      <input id='BDate' name='BDate' type='text' style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
			</td>
			<td width='30%' align='right'>		
				<img id="img1" src="../../skin/images/mini_button_search.gif" onClick='doSelect()' style='cursor:hand;'>
				<img id="img2" src="../../skin/images/excel.gif"              onClick='doExport()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='020402' ctype='1'/>">
				<img id="img3" src="../../skin/images/tubiaofenxi.gif"        onClick='doGraph()'  style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='020403' ctype='1'/>">
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
				<%
				if(null != Pro_L_D)
				{
					Iterator iterator = Pro_L_D.iterator();
					while(iterator.hasNext())
					{
						ProLBean Bean = (ProLBean)iterator.next();
						cnt++;
						if(!T_Cpm_Id.equals(Bean.getCpm_Id()))
						{
				%>
							<tr height='50'>
								<td width='100%' align=center colspan=9><font size=4><B>����վ/����վ������Ӫ�ձ���[<%=Oil_Name%>]</B></font></td>
							</tr>
							<tr height='30'>
								<td width='100%' align=center colspan=9>
									<table width="100%" border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
										<tr height='30'>
											<td width='11%' align=center>&nbsp;</td>
											<td width='66%' align=left><strong>վ������: <%=Bean.getCpm_Name()%></strong></td>
											<td width='23%' align=left><strong>��������: <%=BDate%></strong></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr height='30'>
								<td width='22%' align=center colspan=2><strong>��������</strong></td>
								<td width='22%' align=center colspan=2><strong>ж������</strong></td>
								<td width='22%' align=center colspan=2><strong>�������</strong></td>
								<td width='22%' align=center colspan=2><strong>ӯ������</strong></td>
								<td width='12%' align=center><strong>�ɹ�����</strong></td>
							</tr>
							<%
							String Name1 = "";
						  String Name2 = "";
						  String Name3 = "";
					  	switch(Integer.parseInt(currStatus.getFunc_Corp_Id()))
							{
								default:
								case 1000://����
								case 1010://90#����
								case 1011://90#��Ǧ����
								case 1012://90#�������
								case 1020://92#����
								case 1021://92#��Ǧ����
								case 1022://92#�������
								case 1030://93#����
								case 1031://93����Ǧ����
								case 1032://93#�������
								case 1040://95#����
								case 1041://95#��Ǧ����
								case 1042://95#�������
								case 1050://97#����
								case 1051://97#��Ǧ����
								case 1052://97#�������
								case 1060://120������
								case 1080://������������
								case 1090://98#����
								case 1091://98#��Ǧ����
								case 1092://98���������
								case 1100://��������
								case 1200://��������
								case 1201://75#��������
								case 1202://95#��������
								case 1203://100#��������
								case 1204://������������
								case 1300://��������
								case 2000://����
								case 2001://0#����
								case 2002://+5#����
								case 2003://+10#����
								case 2004://+15#����
								case 2005://+20#����
								case 2006://-5#����
								case 2007://-10#����
								case 2008://-15#����
								case 2009://-20#����
								case 2010://-30#����
								case 2011://-35#����
								case 2015://-50#����
								case 2100://�����
								case 2016://���������
								case 2200://�ز���
								case 2012://10#�ز���
								case 2013://20#�ز���
								case 2014://�����ز���
								case 2300://���ò���
								case 2301://-10#���ò���
								case 2900://��������
										Name1 = "ȼ����(L)";
								    Name2 = "�ۺ�����(kg)";
								    Name3 = "(L)";
									break;
								case 3001://CNG
								case 3002://LNG
										Name1 = "ȼ����(kg)";
								    Name2 = "�ۺ���̬(m3)";
								    Name3 = "(kg)";
									break;
							}
							%>
							<tr height='30'>
								<td width='11%' align=center><%=Name1%></td>
								<td width='11%' align=center><%=Name2%></td>
								<td width='11%' align=center><%=Name1%></td>
								<td width='11%' align=center><%=Name2%></td>
								<td width='11%' align=center><%=Name1%></td>
								<td width='11%' align=center><%=Name2%></td>
								<td width='11%' align=center><%=Name1%></td>
								<td width='11%' align=center><%=Name2%></td>
								<td width='12%' align=center><%=Name1%></td>
							</tr>
							<%
							//ÿ������
							String Value_O     = Bean.getValue_O();
							String Value_O_Gas = Bean.getValue_O_Gas();
							String Value_I     = Bean.getValue_I();
							String Value_I_Gas = Bean.getValue_I_Gas();
							String Value_I_Cnt = Bean.getValue_I_Cnt();
							String Value_R     = Bean.getValue_R();
							String Value_R_Gas = Bean.getValue_R_Gas();
							double Value_P     = Double.parseDouble(Value_O) - Double.parseDouble(Value_I) - Double.parseDouble(Value_R);
					  	double Value_P_Gas = Double.parseDouble(Value_O_Gas) - Double.parseDouble(Value_I_Gas) - Double.parseDouble(Value_R_Gas);
							%>
							<tr height='30'>
								<td width='11%' align=center><%=Value_O%></td>
								<td width='11%' align=center><%=Value_O_Gas%></td>
								<td width='11%' align=center><%=Value_I%></td>
								<td width='11%' align=center><%=Value_I_Gas%></td>
								<td width='11%' align=center><%=Value_R%></td>
								<td width='11%' align=center><%=Value_R_Gas%></td>
								<td width='11%' align=center><%=new BigDecimal(Value_P).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></td>
								<td width='11%' align=center><%=new BigDecimal(Value_P_Gas).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></td>
								<td width='12%' align=center>\</td>
							</tr>
							<tr height='25'>
								<td width='100%' align=center colspan=9 class="table_deep_blue">
									<strong>��ҵ�����ע��</strong>
								</td>
							</tr>
							<tr height='100'>
								<td width='100%' align=center colspan=9 valign=top>
									<table width="100%" border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
										<tr height='25'>
											<td width='30%' align='center'><strong>��λ</strong></td>
											<td width='35%' align='center'><strong>��װ����</strong></td>
											<td width='35%' align='center'><strong>��ע����<%=Name3%></strong></td>
										</tr>
										<%
										int Value_I_Cnt_All = 0;
										double Value_I_All  = 0.0;
										if(null != Pro_L_Crm)
										{
											Iterator crmiter = Pro_L_Crm.iterator();
											while(crmiter.hasNext())
											{
												ProLCrmBean crmBean = (ProLCrmBean)crmiter.next();
												if(crmBean.getCpm_Id().equals(Bean.getCpm_Id()))
												{
													Value_I_Cnt_All = Value_I_Cnt_All + Integer.parseInt(crmBean.getValue_I_Cnt());
													Value_I_All     = Value_I_All     + Double.parseDouble(crmBean.getValue_I());
										%>
													<tr height='30'>
														<td width='30%' align='center'><%=crmBean.getCrm_Name()%></td>
														<td width='35%' align='center'><%=crmBean.getValue_I_Cnt()%></td>
														<td width='35%' align='center'><%=crmBean.getValue_I()%></td>
													</tr>
										<%
												}
											}
										}
										%>
										<tr height='30'>
											<td width='30%' align='center'><strong>�ϼ�</strong></td>
											<td width='35%' align='center'><strong><%=Value_I_Cnt_All%></strong></td>
											<td width='35%' align='center'><strong><%=new BigDecimal(Value_I_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></strong></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr height='30'>
								<td width='22%' align=center colspan=2><strong>��վԱ��(��)</strong></td>
								<td width='33%' align=center colspan=3><strong>�а���(��)</strong></td>
								<td width='22%' align=center colspan=2><strong>������(��)</strong></td>
								<td width='23%' align=center colspan=2><strong>ж������</strong></td>
							</tr>
							<tr height='30'>
								<td width='22%' align=center colspan=2>\</td>
								<td width='33%' align=center colspan=3>\</td>
								<td width='22%' align=center colspan=2>\</td>
								<td width='23%' align=center colspan=2><%=Value_I_Cnt%></td>
							</tr>
							<tr height='30'>
						    <td width='33%' align=center colspan=3><strong>�Ʊ�: </strong>ϵͳ</td>
						    <td width='33%' align=center colspan=3><strong>���: </strong><%=Operator_Name%></td>
						    <td width='34%' align=center colspan=3><strong>�ϱ�����: </strong><%=CommUtil.getDate()%></td>
						  </tr>
				<%
						}
						T_Cpm_Id = Bean.getCpm_Id();
					}
				}
				else
				{
				%>
					<tr height='30'>
						<td width='100%' align=center colspan=9>��!</td>
					</tr>
				<%
				}
				%>
				</table>
			</td>
		</tr>
	</table>
</div>
<input name="Cmd"    type="hidden" value="4">
<input name="Sid"    type="hidden" value="<%=Sid%>">
<input name="Cpm_Id" type="hidden" value="">
<input name="BTime"  type="hidden" value="">
<input type="button" id="CurrButton" onClick="doSelect()" style="display:none">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//ipad��������
if(1 == fBrowserRedirect() || 2 == fBrowserRedirect())
{
	document.getElementById('img2').style.display = 'none';
}

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Pro_L_D.jsp';

function doChangeSelect(pFunc_Sub_Id)
{
	switch(parseInt(pFunc_Sub_Id))
	{
		case 1://����
  			var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
			  var ETime = showPreviousLastDay().format("yyyy-MM-dd");
			  var Year  = BTime.substring(0,4);
			  var Month = BTime.substring(5,7);
				window.parent.frames.mFrame.location = "Pro_L.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&Func_Sub_Id="+pFunc_Sub_Id+"&Func_Corp_Id="+Pro_L_D.Func_Corp_Id.value+"&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month;
			break;
		case 2://����
				var TDay  = new Date().format("yyyy-MM-dd");
				var Year  = TDay.substring(0,4);
				var Month = TDay.substring(5,7);
				var Week  = "1";
				var BTime = TDay;
				var ETime = TDay;
				window.parent.frames.mFrame.location = "Pro_L.do?Cmd=3&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&Func_Sub_Id="+pFunc_Sub_Id+"&Func_Corp_Id="+Pro_L_D.Func_Corp_Id.value+"&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month+"&Week="+Week;
			break;
		case 3://����
				var BTime = showPreviousDay().format("yyyy-MM-dd");
				window.parent.frames.mFrame.location = "Pro_L.do?Cmd=4&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&Func_Sub_Id="+pFunc_Sub_Id+"&Func_Corp_Id="+Pro_L_D.Func_Corp_Id.value+"&BTime="+BTime;
			break;
	}
}

function doSelect()
{
	Pro_L_D.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
	Pro_L_D.BTime.value = Pro_L_D.BDate.value;
	Pro_L_D.submit();
}

var req = null;
function doExport()
{
	if(0 == <%=cnt%>)
	{
		alert('��ǰ�ޱ���!');
		return;
	}
	var BTime = Pro_L_D.BDate.value;
	if(confirm("ȷ������?"))
  {
		if(window.XMLHttpRequest)
	  {
			req = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			req = new ActiveXObject("Microsoft.XMLHTTP");
		}		
		//���ûص�����
		req.onreadystatechange = callbackForName;
		var url = "Pro_L_D_Export.do?Sid=<%=Sid%>&Operator_Name=<%=Operator_Name%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&BTime="+BTime+"&Func_Sub_Id="+Pro_L_D.Func_Sub_Id.value+"&Func_Corp_Id="+Pro_L_D.Func_Corp_Id.value;
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
			location.href = "../../files/excel/" + resp + ".xls";
		}
	}
}

function doGraph()
{
	//���·���
	var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
  var BYear  = BTime.substring(0,4);
  var BMonth = BTime.substring(5,7);
  var EYear  = BTime.substring(0,4);
  var EMonth = BTime.substring(5,7);
  window.parent.frames.mFrame.location = "Pro_G.do?Cmd=20&Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&Func_Corp_Id=3001&Func_Sub_Id=1&Func_Sel_Id=1&BYear="+BYear+"&BMonth="+BMonth+"&EYear="+EYear+"&EMonth="+EMonth;
}
</SCRIPT>
</html>