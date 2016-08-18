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
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
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
	
	ArrayList Sat_Train_Type = (ArrayList)session.getAttribute("Sat_Train_Type_" + Sid);
  ArrayList Sat_Diag_Train      = (ArrayList)session.getAttribute("Sat_Diag_Train_" + Sid);
  int sn = 0; 
  
%>
<body style=" background:#CADFFF">
<form name="Sat_Diag_Train"  action="Sat_Diag_Train.do" method="post" target="mFrame">
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25' valign='middle'>
						<td width='17%'  align='center' class="table_deep_blue">培训类型</td>
						<td width='17%' align='center' class="table_deep_blue">培训主题</td>
						<td width='17%' align='center' class="table_deep_blue">培训单位</td>
						<td width='17%' align='center' class="table_deep_blue">培训对象</td>
						<td width='17%' align='center' class="table_deep_blue">培训人数</td>
						<td width='15%' align='center' class="table_deep_blue">培训课时</td>						
					</tr>
					<%
					if(Sat_Diag_Train != null)
					{
						Iterator iterator = Sat_Diag_Train.iterator();
						while(iterator.hasNext())
						{
							SatTrainBean Bean = (SatTrainBean)iterator.next();
							String SN = Bean.getSN();
							String Train_BTime = Bean.getTrain_BTime();
							String Train_ETime = Bean.getTrain_ETime();
							String Train_Dept = Bean.getTrain_Dept();						
							String Train_Type_Name = Bean.getTrain_Type_Name();
							String Train_Title = Bean.getTrain_Title();
							String Train_Corp = Bean.getTrain_Corp();
							String Train_Object = Bean.getTrain_Object();
							String Train_Cnt = Bean.getTrain_Cnt();
							String Train_Hour = Bean.getTrain_Hour();							
							String Train_Assess = Bean.getTrain_Assess();
							String Operator_Name = Bean.getOperator_Name();
																			
							/**String str_Train_Desc = "培训类型: " + Train_Type_Name
																		+ "<br>"
											              + "培训主题: " + Train_Title
											              + "<br>"
											              + "培训单位: " + Train_Corp
											              + "<br>"
											              + "培训对象: " + Train_Object
											              + "<br>"
											              + "培训人数: " + Train_Cnt
											              + "<br>"
											              + "培训课时: " + Train_Hour;**/
							String str_Train_Desc = Train_Type_Name;

					%>
						  <tr height='25' valign='middle'>						  
								<td align=center><%=Train_Type_Name%></td>
								<td align=center><%=Train_Title%></td>
						    <td align=center><%=Train_Corp%></td>
						    <td align=center><%=Train_Object%></td>		    						    
								<td align=center><%=Train_Cnt%>人</td>
								<td align=center><%=Train_Hour%>小时</td>
							</tr>
					<%				
						}
					}				
					%>  	
				</table>		
</form>
</body>
</html>