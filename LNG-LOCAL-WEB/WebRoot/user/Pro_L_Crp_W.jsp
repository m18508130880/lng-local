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
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script type="text/javascript" src="../skin/js/util.js"></script>
<script type="text/javascript" src="../skin/js/day.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus  = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	String BDate = currStatus.getVecDate().get(0).toString().substring(0,10);
	String EDate = currStatus.getVecDate().get(1).toString().substring(0,10);
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo  = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	String ManageId = UserInfo.getManage_Role();
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
	String Corp_Name = "";
	String Oil_Info = "";
	String Oil_Name = "";
	String Station_Info = "";
	String Car_Info = "";
	if(null != Corp_Info)
	{
		Corp_Name = Corp_Info.getCName();
		Oil_Info = Corp_Info.getOil_Info();
		Station_Info = Corp_Info.getStation_Info();
		Car_Info = Corp_Info.getCar_Info();
		if(null == Corp_Name){Corp_Name = "";}
		if(null == Oil_Info){Oil_Info = "";}
		if(null == Station_Info){Station_Info = "";}
		if(null == Car_Info){Car_Info = "";}
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
	
	int Year  = Integer.parseInt(CommUtil.getDate().substring(0,4));
  int Month = Integer.parseInt(CommUtil.getDate().substring(5,7));
  int Week = 1;
  if(null != (String)session.getAttribute("Year_" + Sid)  && ((String)session.getAttribute("Year_" + Sid)).trim().length() > 0) {Year = CommUtil.StrToInt((String)session.getAttribute("Year_" + Sid));}
  if(null != (String)session.getAttribute("Month_" + Sid) && ((String)session.getAttribute("Month_" + Sid)).trim().length() > 0){Month = CommUtil.StrToInt((String)session.getAttribute("Month_" + Sid));}
  if(null != (String)session.getAttribute("Week_" + Sid)  && ((String)session.getAttribute("Week_" + Sid)).trim().length() > 0) {Week = CommUtil.StrToInt((String)session.getAttribute("Week_" + Sid));}
  
  ArrayList Pro_L_Crp_W_C = (ArrayList)session.getAttribute("Pro_L_Crp_W_C_" + Sid);
  ArrayList Pro_L_Crp_W_Y = (ArrayList)session.getAttribute("Pro_L_Crp_W_Y_" + Sid);
  ArrayList Pro_L_Crp_W   = (ArrayList)session.getAttribute("Pro_L_Crp_W_" + Sid);
	double Value_O_All   = 0.0;
	double Value_O_Y_All = 0.0;
	int Car_Cnt_All      = 0;
	int cnt              = 0;
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
								String Dept_Id = UserInfo.getDept_Id();
								if(Dept_Id.length()>3){Manage_List = Dept_Id; }
	
%>
<body style="background:#CADFFF">
<form name="Pro_L_Crp_W"  action="Pro_L_Crp.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
				����վ��:
				<select  name='Func_Cpm_Id' style='width:100px;height:20px' onChange="doSelect()" >										
								<option value="<%=Manage_List%>" <%=currStatus.getFunc_Cpm_Id().equals(Manage_List)?"selected":""%>>ȫ��վ��</option>				
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
					<option value="0" <%=(currStatus.getFunc_Sub_Id() == 0 ?"SELECTED":"")%>>�걨��</option>
	        <option value="1" <%=(currStatus.getFunc_Sub_Id() == 1 ?"SELECTED":"")%>>�±���</option>
	        <option value="2" <%=(currStatus.getFunc_Sub_Id() == 2 ?"SELECTED":"")%>>�ܱ���</option>
	        <option value="3" <%=(currStatus.getFunc_Sub_Id() == 3 ?"SELECTED":"")%>>�ձ���</option>
	      </select>
	      <select name="Year" style="width:70px;height:20px;">
        <%
        for(int j=2012; j<=2030; j++)
        {
        %>
          <option value="<%=j%>" <%=(Year == j?"selected":"")%>><%=j%>��</option>
        <%
        }
        %>
        </select>
        <select name="Month" style="width:60px;height:20px;">
        <%
        for(int k=1; k<13; k++)
        {
       	%>
       		<option value="<%=k%>" <%=(Month == k?"selected":"")%>><%=k%>��</option>
       	<%
       	}
       	%>
        </select>
	      <select name="Week" style="width:70px;height:20px;">
        	<option value="1" <%=(Week == 1?"selected":"")%>>��һ��</option>
        	<option value="2" <%=(Week == 2?"selected":"")%>>�ڶ���</option>
        	<option value="3" <%=(Week == 3?"selected":"")%>>������</option>
        	<option value="4" <%=(Week == 4?"selected":"")%>>������</option>
        	<option value="5" <%=(Week == 5?"selected":"")%>>������</option>
        </select>
			</td>
			<td width='30%' align='right'>		
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style='cursor:hand;'>
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' >
			<!--	<img id="img3" src="../skin/images/tubiaofenxi.gif"        onClick='doGraph()'  style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='020503' ctype='1'/>">-->
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
				<%
				if(null != Pro_L_Crp_W)
				{
				%>
					<tr height='50'>
						<td width='100%' align=center colspan=9>
							<!--<font size=4><B><%=Corp_Name%>������Ӫ�ܱ����ܱ�[<%=Oil_Name%>]</B></font>-->
							<font size=4><B>�к����麣����Դ���޹�˾�����ܱ���Ӫ��</B></font>
						</td>
					</tr>
					<tr height='30'>
						<td width='100%' align=right colspan=9>
							<strong>��������: <%=BDate%> �� <%=EDate%></strong>
						</td>
					</tr>
					<tr height='30'>
						<td width='10%' align=center rowspan=2><strong>վ��</strong></td>
						<td width='30%' align=center colspan=3><strong>����վ</strong></td>
						<td width='20%' align=center colspan=2><strong>��������(L��kg)</strong></td>
						<td width='30%' align=center colspan=2><strong>����Ӫ����</strong></td>
						<td width='10%' align=center rowspan=2><strong>��ע</strong></td>
					</tr>
					<tr height='30'>
						<td width='10%' align=center><strong>վ����</strong></td>
						<td width='10%' align=center><strong>Ͷ��ʱ��</strong></td>
						<td width='10%' align=center><strong>վ����</strong></td>
						<td width='10%' align=center><strong>�����ۼ�</strong></td>
						<td width='10%' align=center><strong>�����ۼ�</strong></td>
						<td width='10%' align=center><strong>������</strong></td>
						<td width='20%' align=center><strong>��������</strong></td>
					</tr>
				<%
					Iterator iterator = Pro_L_Crp_W.iterator();
					while(iterator.hasNext())
					{
						ProLCrpBean Bean = (ProLCrpBean)iterator.next();
						cnt++;
						String Cpm_Id    = Bean.getCpm_Id();
						String Cpm_SubId = Cpm_Id.substring(7,10);
						String Cpm_Name  = Bean.getCpm_Name();
						String Cpm_CTime = Bean.getCpm_CTime();
						String Cpm_CType = Bean.getCpm_CType();
						String Value_O   = Bean.getValue_O();
						String str_Cpm_CType = "��";
						if(null != Cpm_CType && Station_Info.length() > 0)
						{
							String[] StationList = Station_Info.split(",");
							for(int i=0; i<StationList.length; i++)
							{
					    	if(Cpm_CType.equals(CommUtil.IntToStringLeftFillZero(i+1, 4)))
					    	{
							  	str_Cpm_CType = StationList[i];
							  }
							}
						}
						
						//�����ۼ�
						String Value_O_Y = "0";
						if(null != Pro_L_Crp_W_Y)
						{
							Iterator yeariter = Pro_L_Crp_W_Y.iterator();
							while(yeariter.hasNext())
							{
								ProLCrpBean yearBean = (ProLCrpBean)yeariter.next();
								if(yearBean.getCpm_Id().equals(Cpm_Id))
								{
									Value_O_Y = yearBean.getValue_O();
								}
							}
						}
						
						//�����ۼ�
						int Car_Cnt = 0;
						String Car_CType1    = "";
						String Car_CType2    = "";
						int    Car_CType_cnt = 0;
						String Car_CType_str = "";
						if(null != Pro_L_Crp_W_C)
						{
							Iterator cariter = Pro_L_Crp_W_C.iterator();
							while(cariter.hasNext())
							{
								ProOBean carBean = (ProOBean)cariter.next();
								if(carBean.getCpm_Id().equals(Cpm_Id))
								{
									Car_Cnt++;
									Car_CType1 += carBean.getCar_CType() + ",";
									if(!Car_CType2.contains(carBean.getCar_CType()))
									{
										Car_CType2 += carBean.getCar_CType() + ",";
									}
								}
							}
							if(Car_CType1.length() > 0 && Car_CType2.length() > 0)
							{
								String[] List = Car_CType2.split(",");
								for(int i=0; i<List.length; i++)
								{
									//��������
									String str_Car_Name = "";
									if(Car_Info.length() > 0)
									{
										String[] CarList = Car_Info.split(";");
										for(int k=0; k<CarList.length; k++)
										{
											String[] subCarList = CarList[k].split(",");
											if(List[i].equals(subCarList[0]))
											{
												str_Car_Name = subCarList[1];
											}
										}
									}
							
									Car_CType_cnt = 0;
									String[] sub_List = Car_CType1.split(",");
									for(int j=0; j<sub_List.length; j++)
									{
										if(List[i].equals(sub_List[j]))
										{
											Car_CType_cnt++;
										}
									}
									if(0 == i)
									{
										Car_CType_str += str_Car_Name + " " + Car_CType_cnt + " ��;";
									}
									else
									{
										Car_CType_str += "<br>" + str_Car_Name + " " + Car_CType_cnt + " ��;";
									}								
								}
							}
						}
						
						//�ϼ�
						Value_O_All   = Value_O_All + Double.parseDouble(Value_O);
						Value_O_Y_All = Value_O_Y_All + Double.parseDouble(Value_O_Y);
						Car_Cnt_All   = Car_Cnt_All + Car_Cnt;
						
				%>
						<tr height='30'>
					    <td align=center><%=Cpm_SubId%></td>
					    <td align=center><%=Cpm_Name%></td>
					    <td align=center><%=Cpm_CTime%></td>
					    <td align=center><%=str_Cpm_CType%></td>
					    <td align=center><%=Value_O%></td>
					    <td align=center><%=Value_O_Y%></td>
					    <td align=center><%=Car_Cnt%></td>
					    <td align=left><%=Car_CType_str%>&nbsp;</td>
					    <td align=left>&nbsp;</td>
					  </tr>
				<%		
					}
				%>
					<tr height='30'>
				    <td align=center><strong>�ϼ�</strong></td>
				    <td align=center><strong><%=cnt%></strong></td>
				    <td align=center><strong>/</strong></td>
				    <td align=center><strong>/</strong></td>
				    <td align=center><strong><%=new BigDecimal(Value_O_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></strong></td>
				    <td align=center><strong><%=new BigDecimal(Value_O_Y_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></strong></td>
				    <td align=center><strong><%=Car_Cnt_All%></strong></td>
				    <td align=center><strong>&nbsp;</strong></td>
				    <td align=center><strong>&nbsp;</strong></td>
				  </tr>
				  <tr height='30'>
				    <td width='30%' align=center colspan=3><strong>�Ʊ�: </strong>ϵͳ</td>
				    <td width='30%' align=center colspan=3><strong>���: </strong><%=Operator_Name%></td>
				    <td width='40%' align=center colspan=3><strong>�ϱ�����: </strong><%=CommUtil.getDate()%></td>
				  </tr>
				<%
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
<input name="Cmd"    type="hidden" value="2">
<input name="Sid"    type="hidden" value="<%=Sid%>">
<input name="Cpm_Id" type="hidden" value=""/>
<input name="BTime"  type="hidden" value="">
<input name="ETime"  type="hidden" value="">
<input type="button" id="CurrButton" onClick="doSelect()" style="display:none">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//ipad��������
if(1 == fBrowserRedirect() || 2 == fBrowserRedirect())
{
	document.getElementById('img2').style.display = 'none';
}

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Pro_L_Crp_W.jsp';

function doChangeSelect(pFunc_Sub_Id)
{
	switch(parseInt(pFunc_Sub_Id))
	{
		case 0://����
				var Year  = new Date().format("yyyy-MM-dd").substring(0,4);
				var BTime = Year + '-01-01';
				var ETime = Year + '-12-31';
				window.parent.frames.mFrame.location = "Pro_L_Crp.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id="+Pro_L_Crp_W.Func_Cpm_Id.value+"&Func_Sub_Id="+pFunc_Sub_Id+"&Func_Corp_Id="+Pro_L_Crp_W.Func_Corp_Id.value+"&BTime="+BTime+"&ETime="+ETime+"&Year="+Year;
			break;
		case 1://����
  			var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
			  var ETime = showPreviousLastDay().format("yyyy-MM-dd");
			  var Year  = BTime.substring(0,4);
			  var Month = BTime.substring(5,7);
				window.parent.frames.mFrame.location = "Pro_L_Crp.do?Cmd=1&Sid=<%=Sid%>&Cpm_Id="+Pro_L_Crp_W.Func_Cpm_Id.value+"&Func_Sub_Id="+pFunc_Sub_Id+"&Func_Corp_Id="+Pro_L_Crp_W.Func_Corp_Id.value+"&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month;
			break;
		case 2://����
				var TDay  = new Date().format("yyyy-MM-dd");
				var Year  = TDay.substring(0,4);
				var Month = TDay.substring(5,7);
				var Week  = "1";
				var BTime = TDay;
				var ETime = TDay;
				window.parent.frames.mFrame.location = "Pro_L_Crp.do?Cmd=2&Sid=<%=Sid%>&Cpm_Id="+Pro_L_Crp_W.Func_Cpm_Id.value+"&Func_Sub_Id="+pFunc_Sub_Id+"&Func_Corp_Id="+Pro_L_Crp_W.Func_Corp_Id.value+"&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month+"&Week="+Week;
			break;
		case 3://����
				var BTime = showPreviousDay().format("yyyy-MM-dd");
				window.parent.frames.mFrame.location = "Pro_L_Crp.do?Cmd=3&Sid=<%=Sid%>&Cpm_Id="+Pro_L_Crp_W.Func_Cpm_Id.value+"&Func_Sub_Id="+pFunc_Sub_Id+"&Func_Corp_Id="+Pro_L_Crp_W.Func_Corp_Id.value+"&BTime="+BTime;
			break;
	}
}

function doSelect()
{
	Pro_L_Crp_W.Cpm_Id.value = Pro_L_Crp_W.Func_Cpm_Id.value;
	Pro_L_Crp_W.BTime.value = new Date().format("yyyy-MM-dd");
  Pro_L_Crp_W.ETime.value = new Date().format("yyyy-MM-dd");
	Pro_L_Crp_W.submit();
}

var req = null;
function doExport()
{
	if(0 == <%=cnt%>)
	{
		alert('��ǰ�ޱ���!');
		return;
	}
	var BTime = new Date().format("yyyy-MM-dd");
	var ETime = new Date().format("yyyy-MM-dd");
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
		var url = "Pro_L_Crp_W_Export.do?Sid=<%=Sid%>&Operator_Name=<%=Operator_Name%>&Cpm_Id="+Pro_L_Crp_W.Func_Cpm_Id.value+"&BTime="+BTime+"&ETime="+ETime+"&Func_Sub_Id="+Pro_L_Crp_W.Func_Sub_Id.value+"&Func_Corp_Id="+Pro_L_Crp_W.Func_Corp_Id.value+"&Year="+Pro_L_Crp_W.Year.value+"&Month="+Pro_L_Crp_W.Month.value+"&Week="+Pro_L_Crp_W.Week.value;
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

function doGraph()
{
	//���·���
	var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
  var BYear  = BTime.substring(0,4);
  var BMonth = BTime.substring(5,7);
  window.parent.frames.mFrame.location = "Pro_Crp_G.do?Cmd=20&Sid=<%=Sid%>&Cpm_Id="+Pro_L_Crp_W.Func_Cpm_Id.value+"&Func_Corp_Id=3001&Func_Sub_Id=1&Func_Sel_Id=1&BYear="+BYear+"&BMonth="+BMonth;
}
</SCRIPT>
</html>