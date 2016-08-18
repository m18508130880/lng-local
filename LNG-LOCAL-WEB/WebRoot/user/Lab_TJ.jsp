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
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);	 	
  CurrStatus currStatus    = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList Lab_Store_Time = (ArrayList)session.getAttribute("Lab_Store_Time_" + Sid);
  ArrayList Lab_Store_P     = (ArrayList)session.getAttribute("Lab_Store_P_" + Sid);
  ArrayList Lab_Store_PType     = (ArrayList)session.getAttribute("Lab_Store_PType_" + Sid);		
  double Lab_Fcnt_ALL = 0.00;
  double Lab_Icnt_ALL = 0.00;
  double Lab_Ocnt_ALL = 0.00;
  double Lab_Lcnt_ALL = 0.00;
  double Lab_Scnt_ALL = 0.00;
  double KYing        = 0.00;
  double KYing_ALL    = 0.00;
  double KYingL        = 0.00;
  double KYingL_ALL    = 0.00;
  String Lab_P_Oper   = "";
	String Operator     = "";
	String Opers        = "";
	String Operl        = "";
	
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
%>
<body style=" background:#CADFFF">
<form name="Lab_Store_P"  action="Lab_Store_P.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='70%' align='left'>
				盘点时间:
				<select name='Func_Corp_Id' style='width:120px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>全部</option>
					<%																
								if( null != Lab_Store_Time)
								{
									Iterator iterator = Lab_Store_Time.iterator();
									while(iterator.hasNext())
									{
										LabStorePBean statBean = (LabStorePBean)iterator.next();
										
								%>
											<option value='<%=statBean.getCTime()%>' <%=currStatus.getFunc_Corp_Id().equals(statBean.getCTime())?"selected":""%>><%=statBean.getCTime()%></option>
								<%
									}
								}
								%>
					
					
				</select>
				劳保名称:
				<select name='Func_Type_Id' style='width:120px;height:20px' onChange="doSelect()">
					<option value='6666' <%=currStatus.getFunc_Type_Id().equals("6666")?"selected":""%>>全部</option>
					<%																
								if( null != Lab_Store_PType)
								{
									Iterator iterat = Lab_Store_PType.iterator();
									while(iterat.hasNext())
									{
										LabStorePBean reBean = (LabStorePBean)iterat.next();
										
								%>
											<option value='<%=reBean.getLab_P_Name()%>' <%=currStatus.getFunc_Type_Id().equals(reBean.getLab_P_Name())?"selected":""%>><%=reBean.getLab_P_Name()%></option>
								<%
									}
								}
								%>										
				</select>
			</td>
			<td width='30%' align='right'>				
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">		
				<img src="../skin/images/pldr.gif" style='cursor:hand;' onClick='doDAORU()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='110402' ctype='1'/>">		
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='40'>
						<td colspan='10'> <strong>中海油珠海新能源有限公司存货盘点表(劳保用品)</strong></td>
					</tr>
					<tr height='30'>
		<%				
				String pTime = "";
				if(null != Lab_Store_P)
				{
					Iterator iterp = Lab_Store_P.iterator();
					while(iterp.hasNext())
					{	
						LabStorePBean lpBean = (LabStorePBean)iterp.next();
						pTime = lpBean.getCTime();
						break;
					}	
				}		
		%>			
						<td  id='PTime'colspan='10' align='center'> <strong>盘点日期：<%= pTime%></strong></td>
					</tr>
					<tr height='25' valign='middle'>
						<td width='10%'  align='center' ><strong>序号</strong></td>
						<td width='10%'  align='center' ><strong>名称</strong></td>
						<td width='10%' align='center' ><strong>月初库存</strong></td>
						<td width='10%'  align='center' ><strong>本月入库</strong></td>
						<td width='10%' align='center' ><strong>本月出库</strong></td>
						<td width='10%' align='center' ><strong>月末账面库存</strong></td>
						<td width='10%' align='center' ><strong>月末实际库存</strong></td>
						<td width='10%' align='center' ><strong>盈亏数量</strong></td>
						<td width='10%'  align='center' ><strong>盈亏%</strong></td>
						<td width='10%'  align='center' ><strong>备注</strong></td>						
					</tr>		
			<%		
				int cont = 0;
				if(null != Lab_Store_P)
				{
					Iterator iter = Lab_Store_P.iterator();
					while(iter.hasNext())
					{
					LabStorePBean pBean = (LabStorePBean)iter.next();
					String SN           =  pBean.getSN();
					String Lab_P_Name   = pBean.getLab_P_Name();
					String Lab_P_Fcnt   = pBean.getLab_P_Fcnt();
					String Lab_P_Icnt   = pBean.getLab_P_Icnt();
					String Lab_P_Ocnt   = pBean.getLab_P_Ocnt();
					String Lab_P_Lcnt   = pBean.getLab_P_Lcnt();
					String Lab_P_Scnt   = pBean.getLab_P_Scnt();
					String CTime        = pBean.getCTime();
					Lab_P_Oper   				= pBean.getLab_P_Oper();
					Operator    				= pBean.getOperator();
					Opers        				= pBean.getOpers();
					Operl        				= pBean.getOperl();
					String Memo         = pBean.getMemo();
					 KYing    	        =  Double.parseDouble(Lab_P_Scnt)-Double.parseDouble(Lab_P_Lcnt);
					 KYingL             =  KYing/(Double.parseDouble(Lab_P_Fcnt)+Double.parseDouble(Lab_P_Icnt)); 
					Lab_Fcnt_ALL        = Lab_Fcnt_ALL + Double.parseDouble(Lab_P_Fcnt);
					Lab_Icnt_ALL        = Lab_Icnt_ALL + Double.parseDouble(Lab_P_Icnt);
					Lab_Ocnt_ALL        = Lab_Ocnt_ALL + Double.parseDouble(Lab_P_Ocnt);
					Lab_Lcnt_ALL        = Lab_Lcnt_ALL + Double.parseDouble(Lab_P_Lcnt);
					Lab_Scnt_ALL        = Lab_Scnt_ALL + Double.parseDouble(Lab_P_Scnt);
					KYing_ALL           = KYing_ALL  + KYing;
					KYingL_ALL          = KYingL_ALL + KYingL ;
					cont++;
		%>			
			<tr height='30' valign='middle' <%=((cont%2)==0?"class='table_blue'":"class='table_white_l'")%>>
						<td  align='center' ><a href="#" onclick="DeSn('<%=SN%>')"><U><%=cont%></U></a></td>
						<td  align='center' ><%=Lab_P_Name%></td>
						<td  align='center' ><%=Lab_P_Fcnt%></td>
						<td  align='center' ><%=Lab_P_Icnt%></td>
						<td  align='center' ><%=Lab_P_Ocnt%></td>
						<td  align='center' ><%=Lab_P_Lcnt%></td>
						<td  align='center' ><%=Lab_P_Scnt%></td>
						<td  align='center' ><%=KYing%></td>
						<td  align='center' ><%=KYingL%></td>
						<td  align='center' ><%=Memo%>&nbsp;</td>						
					</tr>					
		<%			
					}
				}	
			%>				
			
					<tr height='25' valign='middle' <%=(((cont+1)%2)==0?"class='table_blue'":"class='table_white_l'")%>>
						<td colspan='2'>合计:</td>
						<td  align='center' ><%=new BigDecimal(Lab_Fcnt_ALL).divide(new BigDecimal(1),0,java.math.RoundingMode.HALF_UP)%></td>
						<td  align='center' ><%=new BigDecimal(Lab_Icnt_ALL).divide(new BigDecimal(1),0,java.math.RoundingMode.HALF_UP)%></td>
						<td  align='center' ><%=new BigDecimal(Lab_Ocnt_ALL).divide(new BigDecimal(1),0,java.math.RoundingMode.HALF_UP)%></td>
						<td  align='center' ><%=new BigDecimal(Lab_Lcnt_ALL).divide(new BigDecimal(1),0,java.math.RoundingMode.HALF_UP)%></td>
						<td  align='center' ><%=new BigDecimal(Lab_Scnt_ALL).divide(new BigDecimal(1),0,java.math.RoundingMode.HALF_UP)%></td>
						<td  align='center' ><%=new BigDecimal(KYing_ALL).divide(new BigDecimal(1),1,java.math.RoundingMode.HALF_UP)%></td>
						<td  align='center' ><%=new BigDecimal(KYingL_ALL).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)%></td>
						<td>&nbsp;</td>
					</tr>
					<tr height='25' valign='middle' <%=((cont%2)==0?"class='table_blue'":"class='table_white_l'")%>>
						<td align='center' colspan='3'><strong>盘点人:	&nbsp;<%=Lab_P_Oper%></strong></td>
						<td align='center' colspan='2'><strong>财务监盘:&nbsp;<%=Operator%></strong></td>
						<td align='center' colspan='2'><strong>部门审核:&nbsp;<%=Opers%></strong></td>
						<td align='center' colspan='3'><strong>主管领导:&nbsp;<%=Operl%></strong></td>					
					</tr>
			
				</table>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="Cmd" value="0">
<input type="hidden" name="Sid" value="<%=Sid%>">
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

	
function doSelect()
{	
	Lab_Store_P.submit();	
}
function DeSn(pSN)	
{
		if(confirm("是否删除本条记录?"))
	{
		location="Lab_Store_P.do?Cmd=13&Sid=<%=Sid%>&Func_Corp_Id="+Lab_Store_P.Func_Corp_Id.value+"&Func_Type_Id="+Lab_Store_P.Func_Type_Id.value+"&SN="+pSN;
	}		
		
}
function doDAORU()
{
	var Pdiag = new Dialog();
	Pdiag.Top = "50%";
	Pdiag.Width = 500;
	Pdiag.Height = 120;
	Pdiag.Title = "盘点表导入";
	Pdiag.URL = 'Lab_Store_P_File.jsp?Sid=<%=Sid%>';
	Pdiag.show();	
}

</SCRIPT>
</html>