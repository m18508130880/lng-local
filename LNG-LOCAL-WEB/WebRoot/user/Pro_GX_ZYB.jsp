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
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
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
	ArrayList Pro_R_Type = (ArrayList)session.getAttribute("Pro_R_Type_" + Sid);
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
	
	int Year = Integer.parseInt(CommUtil.getDate().substring(0,4));
  int Month = Integer.parseInt(CommUtil.getLastMonth(CommUtil.getDate().substring(0,7)).substring(5,7));
  if(null != (String)session.getAttribute("Year_" + Sid) && ((String)session.getAttribute("Year_" + Sid)).trim().length() > 0){Year = CommUtil.StrToInt((String)session.getAttribute("Year_" + Sid));}
  if(null != (String)session.getAttribute("Month_" + Sid) && ((String)session.getAttribute("Month_" + Sid)).trim().length() > 0){Month = CommUtil.StrToInt((String)session.getAttribute("Month_" + Sid));}
  
  ArrayList Pro_GX_ZYB = (ArrayList)session.getAttribute("Pro_GX_ZYB_" + Sid);
  ArrayList Pro_O_ZYB = (ArrayList)session.getAttribute("Pro_O_ZYB_" + Sid);
  ArrayList Pro_Crm_User = (ArrayList)session.getAttribute("Pro_Crm_User_" + Sid);
  ArrayList Pro_Y = (ArrayList)session.getAttribute("Pro_Y_" + Sid);
  ArrayList CNameList   = new ArrayList();
  List<String> CrmVa       = new ArrayList<String>(); 
  String  Crm_ALL       = "";
  String T_Cpm_Id       = "";
  String T_Cpm_Name     = "";
	String CTime          = "";
	String Value_O        = "0";
	String Value_O_Gas    = "0";
	String Value_I        = "0";
	String Value_I_Gas    = "0";
	String Value_R        = "0";
	String Value_R_Gas    = "0";
	String Value_PAL        = "0";
	String Value_PAL_Gas    = "0";
	String Crm_Str        = "";
	
	//�����ۼ�
  double Value_O_All       = 0.0;
	double Value_O_Gas_All   = 0.0;
	double Value_I_All       = 0.0;
	double Value_I_Gas_All   = 0.0;	
	double Value_R_All       = 0.0;
	double Value_R_Gas_All   = 0.0;	
	double Value_PAL_All       = 0.0;
	double Value_PAL_Gas_All   = 0.0;	
	
	double Value_Crm_All     = 0.0;
	double Value_Crm_Gas_All = 0.0;	
	
	//ͳ������
	int cnt              = 0;
	int count            = 0;
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
<body style=" background:#CADFFF">
<form name="Pro_GX_ZYB"  action="Pro_GX_ZYB.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
				����վ��:
				<select  name='Func_Cpm_Id' style='width:100px;height:20px' onChange="doSelect()" >						
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
				<select name="Func_Sub_Id"  style="width:120px;height:20px" onChange="doChangeSelect(this.value)">		
	        <option value="1" <%=(currStatus.getFunc_Sub_Id() == 1 ?"SELECTED":"")%>>վ����ͳ��</option>
	        <option value="2" <%=(currStatus.getFunc_Sub_Id() == 2 ?"SELECTED":"")%>>վ����ͳ��</option>
	        <option id='OP1' value="3" <%=(currStatus.getFunc_Sub_Id() == 3 ?"SELECTED":"")%>>��˾��ͳ��</option>
	        <option id='OP2' value="4" <%=(currStatus.getFunc_Sub_Id() == 4 ?"SELECTED":"")%>>��˾��ͳ��</option>
	      </select>
	      <select name="Year" style="width:70px;height:20px;" onChange="doSelect()">
        <%
        for(int j=2012; j<=2030; j++)
        {
        %>
          <option value="<%=j%>" <%=(Year == j?"selected":"")%>><%=j%>��</option>
        <%
        }
        %>
        </select>
        <select name="Month" style="width:60px;height:20px;" onChange="doSelect()">
        <%
        for(int k=1; k<13; k++)
        {
       	%>
       		<option value="<%=k%>" <%=(Month == k?"selected":"")%>><%=k%>��</option>
       	<%
       	}
       	%>
        </select>
			</td>
			<td width='30%' align='right'>		
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style='cursor:hand;'>
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' >
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
				<%
				if(null != Pro_GX_ZYB)
				{
					Iterator iterator = Pro_GX_ZYB.iterator();
					while(iterator.hasNext())
					{
						ProLBean Bean = (ProLBean)iterator.next();
						cnt++;
						if(!T_Cpm_Id.equals(Bean.getCpm_Id()))
						{
							
							T_Cpm_Name = Bean.getCpm_Name();
							CTime = Bean.getCTime();
							Value_O = Bean.getValue_O();
							Value_O_Gas = Bean.getValue_O_Gas();
							Value_I = Bean.getValue_I();
							Value_I_Gas = Bean.getValue_I_Gas();
							Value_R = Bean.getValue_R();
							Value_R_Gas = Bean.getValue_R_Gas();
							Value_PAL = Bean.getValue_PAL();
							Value_PAL_Gas = Bean.getValue_PAL_Gas();
							
							Value_O_All     = Value_O_All + Double.parseDouble(Value_O);
							Value_O_Gas_All = Value_O_Gas_All + Double.parseDouble(Value_O_Gas);
							Value_I_All     = Value_I_All + Double.parseDouble(Value_I);
							Value_I_Gas_All = Value_I_Gas_All + Double.parseDouble(Value_I_Gas);
						  Value_R_All     = Value_R_All + Double.parseDouble(Value_R);
						  Value_R_Gas_All = Value_R_Gas_All + Double.parseDouble(Value_R_Gas);	
						  Value_PAL_All     = Value_PAL_All + Double.parseDouble(Value_PAL);
						  Value_PAL_Gas_All = Value_PAL_Gas_All + Double.parseDouble(Value_PAL_Gas);
				%>
							<tr height='50'>
								<td width='100%' align=center colspan=7><font size=4><B>����վ����ͳ���±���[<%=Oil_Name%>]</B></font></td>
							</tr>
							<tr height='30'>
								<td width='100%' align=center colspan=7>
									<table width="100%" border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
										<tr height='30'>
											<td width='10%' align=center>&nbsp;</td>
											<td width='65%' align=left><strong>վ������:�к����麣����Դ���޹�˾<%=T_Cpm_Name%>վ</strong></td>
											<td width='25%' align=left><strong>��������: <%=Year%>��<%=Month%>��</strong></td>
										</tr>
									</table>
								</td>
							</tr>
					</table>
				</table>
					<table width='100%'  border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
							<tr height='30' >
						    <td width='150px' align=center rowspan='2'><strong>����\��Ŀ</strong></td>
						    <td width='300px' align=center ><strong>��������</strong></td>					    
						    <td width='300px' align=center ><strong>ж������</strong></td>
						    <td width='300px' align=center ><strong>�������</strong></td>
						    <td width='300px' align=center ><strong>ӯ������</strong></td>						    
						    <td width='300px' align=center ><strong>��������</strong></td>						    
						 
						 <%
						 	if(null != Pro_Crm_User)
						 	{
						 		Iterator iters = Pro_Crm_User.iterator();
						 		while(iters.hasNext())
						 		{
						 			ProLCrmBean CrmBean =(ProLCrmBean)iters.next();
						 			String Crm_Name       =   CrmBean.getCrm_Name();
						 			count++;
						 			CNameList.add(Crm_Name);
						 	%>
						 	<td width='300px' align=center ><strong><%=Crm_Name%></strong></td>
						 	<%		
						 		}
						 	}
						 
						 
						 %>	    
						  </tr>
						  <tr height='30'>						  
								<td width='150px' align=center>LNGȼ����(kg)</td>

								<td width='150px' align=center>LNGȼ����(kg)</td>

								<td width='150px' align=center>LNGȼ����(kg)</td>

								<td width='150px' align=center>LNGȼ����(kg)</td>

								<td width='150px' align=center>LNGȼ����(kg)</td>
		
						<%		
								for(int k =0;k<count;k++)
								{
						%>		
								<td width='150px' align=center>LNGȼ����(kg)</td>

						<%	
								}
						%>								
						  </tr>
						  <tr height='30'>
						    <td width='150px' align=center><%=CTime.substring(5,10)%></td>
						    <td width='150px' align=center><%=Value_O%></td>

						    <td width='150px' align=center><%=Value_I%></td>

						    <td width='150px' align=center><%=Value_R%></td>

						    <td width='150px' align=center><%=Value_PAL%></td>

						    <td width='150px' align=center><%=Value_I%></td>
					    
					 
					 <%   								
						if(null != CNameList && null != Pro_O_ZYB)
						{
							Iterator cnamelist = CNameList.iterator();
							while(cnamelist.hasNext())
							{
								String cname =(String)cnamelist.next();
								String Crm_Value = "0.00";
								String Crm_Value_Gas = "0.00";
								String Crm_Value2      ="";
								String Crm_Value_Gas2  ="";
								Value_Crm_All = 0.00;
							  Value_Crm_Gas_All = 0.00;
								Iterator iter = Pro_O_ZYB.iterator();
								while(iter.hasNext())
								{
									ProLCrmBean pCrmBean =(ProLCrmBean)iter.next();
									String Crm_CTime      =   pCrmBean.getCTime();
									String CrmName       	=   pCrmBean.getCrm_Name();									
									if(cname.equals(CrmName) && CTime.substring(8,10).equals(Crm_CTime.substring(8,10)))
									{
										Crm_Value          =   pCrmBean.getValue_I();
										Crm_Value_Gas      =   pCrmBean.getValue_I_Gas();			
									}	
									if(cname.equals(CrmName))
									{
										Crm_Value2          =   pCrmBean.getValue_I();
										Crm_Value_Gas2      =   pCrmBean.getValue_I_Gas();
										Value_Crm_All       =  Value_Crm_All + Double.parseDouble(Crm_Value2); 	
										Value_Crm_Gas_All   =  Value_Crm_Gas_All + Double.parseDouble(Crm_Value_Gas2); 
										Crm_Str             = 	Value_Crm_All + "," +	Value_Crm_Gas_All;			
									}														
								}	
								CrmVa.add(Crm_Str);						   
						%>					
								
								<td width='150px' align=center><%=Crm_Value%></td>

						<%	 
							}
						}								
						 %> 
						 </tr>
				 <%
						}
						else
						{
							T_Cpm_Name = Bean.getCpm_Name();
						  CTime = Bean.getCTime();
							Value_O = Bean.getValue_O();
							Value_O_Gas = Bean.getValue_O_Gas();
							Value_I = Bean.getValue_I();
							Value_I_Gas = Bean.getValue_I_Gas();
							Value_R = Bean.getValue_R();
							Value_R_Gas = Bean.getValue_R_Gas();
							Value_PAL = Bean.getValue_PAL();
							Value_PAL_Gas = Bean.getValue_PAL_Gas();
							
							Value_O_All     = Value_O_All + Double.parseDouble(Value_O);
							Value_O_Gas_All = Value_O_Gas_All + Double.parseDouble(Value_O_Gas);
							Value_I_All     = Value_I_All + Double.parseDouble(Value_I);
							Value_I_Gas_All = Value_I_Gas_All + Double.parseDouble(Value_I_Gas);
							Value_R_All     = Value_R_All + Double.parseDouble(Value_R);
						  Value_R_Gas_All = Value_R_Gas_All + Double.parseDouble(Value_R_Gas);	
						  Value_PAL_All     = Value_PAL_All + Double.parseDouble(Value_PAL);
						  Value_PAL_Gas_All = Value_PAL_Gas_All + Double.parseDouble(Value_PAL_Gas);	
				%>
							<tr height='30'>
						    <td width='150px' align=center><%=CTime.substring(5,10)%></td>
						    <td width='150px' align=center><%=Value_O%></td>

						    <td width='150px' align=center><%=Value_I%></td>

						    <td width='150px' align=center><%=Value_R%></td>

						    <td width='150px' align=center><%=Value_PAL%></td>

						    <td width='150px' align=center><%=Value_I%></td>

				<%   								
						if(null != CNameList && null != Pro_O_ZYB)
						{
							Iterator cnamelist = CNameList.iterator();
							while(cnamelist.hasNext())
							{
								String cname =(String)cnamelist.next();
								String Crm_Value = "0.00";
								String Crm_Value_Gas = "0.00";
								Iterator iter = Pro_O_ZYB.iterator();
								while(iter.hasNext())
								{
									ProLCrmBean pCrmBean =(ProLCrmBean)iter.next();
									String Crm_CTime      =   pCrmBean.getCTime();
									String CrmName       	=   pCrmBean.getCrm_Name();									
									if(cname.equals(CrmName) && CTime.substring(8,10).equals(Crm_CTime.substring(8,10)))
									{
										Crm_Value          =   pCrmBean.getValue_I();
										Crm_Value_Gas      =   pCrmBean.getValue_I_Gas();											
															
									}								
								}									
						%>				
								
								<td width='150px' align=center><%=Crm_Value%></td>

						<%	 
							}
						}								
						 %> 
						  </tr>
				<%
						}
						T_Cpm_Id = Bean.getCpm_Id();
						if(cnt == Pro_GX_ZYB.size())
						{							
							
				%> 
							<tr height='30'>
							  <td width='150px' align=center><strong>�����ۼ�</strong></td>
							  <td width='150px' align=center><strong><%=new BigDecimal(Value_O_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></strong></td>
							  <td width='150px' align=center><strong><%=new BigDecimal(Value_I_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></strong></td>
							  <td width='150px' align=center><strong><%=new BigDecimal(Value_R_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></strong></td>
							  <td width='150px' align=center><strong><%=new BigDecimal(Value_PAL_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></strong></td>
								<td width='150px' align=center><strong><%=new BigDecimal(Value_I_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></strong></td>
	

		<%		  
						if(null != CrmVa)
						{							
							Iterator vator = CrmVa.iterator();
						
							while(vator.hasNext())
							{
							String vd1 = (String)vator.next();
							String[] vd2 =vd1.split(","); 							
					%>
							<td width='150px' align=center><strong><%=new BigDecimal(vd2[0]).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></strong></td>

					<%								  
							}
						}
					%>		  
						  
		
							</tr>	
					</table>
					<table width='100%'  border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">							
							<tr height='30'>
							  <td width='30%' align=center colspan=2><strong>�Ʊ�: </strong>ϵͳ</td>
							  <td width='30%' align=center colspan=2><strong>���: </strong><%=Operator_Name%></td>
							  <td width='40%' align=center colspan=3><strong>�ϱ�����: </strong><%=CommUtil.getDate()%></td>
							</tr>
				<%			
						}
					}
				}
				else
				{
				%>
					<tr height='30'>
						<td width='100%' align=center colspan=7>��!</td>
					</tr>
				<%
				}
				%>		
			</td>
		</tr>
	</table>
</div>
<input name="Cmd"    type="hidden" value="0">
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

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Pro_GX_ZYB.jsp';

function doChangeSelect(pFunc_Sub_Id)
{
	switch(parseInt(pFunc_Sub_Id))
	{
		case 1://����ͳ��վ���±���
  			var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
			  var ETime = showPreviousLastDay().format("yyyy-MM-dd");
			  var Year  = BTime.substring(0,4);
			  var Month = BTime.substring(5,7);
				window.parent.frames.mFrame.location = "Pro_GX_ZYB.do?Cmd=0&Sid=<%=Sid%>&Cpm_Id=0100000001&Func_Sub_Id=1&Func_Corp_Id="+Pro_GX_ZYB.Func_Corp_Id.value+"&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month;
			break;
		case 2://����ͳ��վ���걨��
				var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
			  var ETime = showPreviousLastDay().format("yyyy-MM-dd");
			  var Year  = BTime.substring(0,4);			
				window.parent.frames.mFrame.location = "Pro_GX_ZNB.do?Cmd=1&Sid=<%=Sid%>&Cpm_Id=0100000001&Func_Sub_Id=2&Func_Corp_Id="+Pro_GX_ZYB.Func_Corp_Id.value+"&BTime="+BTime+"&ETime="+ETime+"&Year="+Year;
			break;
		case 3://����ͳ�ƹ�˾�±���
				var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
			  var ETime = showPreviousLastDay().format("yyyy-MM-dd");
			  var Year  = BTime.substring(0,4);	
			  var Month = BTime.substring(5,7);
				window.parent.frames.mFrame.location = "Pro_GX_GYB.do?Cmd=2&Sid=<%=Sid%>&Cpm_Id=0100000001&Func_Sub_Id=3&Func_Corp_Id="+Pro_GX_ZYB.Func_Corp_Id.value+"&BTime="+BTime+"&ETime="+ETime+"&Year="+Year+"&Month="+Month;
			break;
		case 4: //����ͳ�ƹ�˾�걨��
				var BTime = showPreviousFirstDay().format("yyyy-MM-dd");
			  var ETime = showPreviousLastDay().format("yyyy-MM-dd");
			  var Year  = BTime.substring(0,4);	
		window.parent.frames.mFrame.location = "Pro_GX_GNB.do?Cmd=3&Sid=<%=Sid%>&Cpm_Id=0100000001&Func_Sub_Id=4&Func_Corp_Id="+Pro_GX_ZYB.Func_Corp_Id.value+"&BTime="+BTime+"&ETime="+ETime+"&Year="+Year;
			break;
	}
}

function doSelect()
{
	Pro_GX_ZYB.Cpm_Id.value = Pro_GX_ZYB.Func_Cpm_Id.value;
	Pro_GX_ZYB.BTime.value = Pro_GX_ZYB.Year.value + '-' + StrLeftFillZero(Pro_GX_ZYB.Month.value,2) + '-01';
  Pro_GX_ZYB.ETime.value = getFirstAndLastMonthDay(Pro_GX_ZYB.Year.value, StrLeftFillZero(Pro_GX_ZYB.Month.value,2));
	Pro_GX_ZYB.submit();
}

var req = null;
function doExport()
{
	if(0 == <%=cnt%>)
	{
		alert('��ǰ�ޱ���!');
		return;
	}	
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
		var url = "Pro_ZYB_Export.do?Sid=<%=Sid%>&Cpm_Id="+Pro_GX_ZYB.Func_Cpm_Id.value+"&Func_Corp_Id="+Pro_GX_ZYB.Func_Corp_Id.value+"&BTime="+Pro_GX_ZYB.Year.value + '-' + StrLeftFillZero(Pro_GX_ZYB.Month.value,2) + '-01'+"&ETime="+getFirstAndLastMonthDay(Pro_GX_ZYB.Year.value, StrLeftFillZero(Pro_GX_ZYB.Month.value,2))+"&Cpm_Name=<%=T_Cpm_Name%>&Year="+Pro_GX_ZYB.Year.value;
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