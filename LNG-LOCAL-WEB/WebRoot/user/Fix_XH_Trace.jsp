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
<script type='text/javascript' src='../skin/js/util.js'></script>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));	
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  ArrayList Fix_XH_Trace      = (ArrayList)session.getAttribute("Fix_XH_Trace_" + Sid);
  ArrayList Spa_Store_All      = (ArrayList)session.getAttribute("Spa_Store_All_" + Sid);
	ArrayList Spa_Station_All    = (ArrayList)session.getAttribute("Spa_Station_All_" + Sid);
	Map map         =  new HashMap<String, Integer>();
	String key      = "";
	String  Fix_Des = "";
	Integer    in     = 0;
  
  int sn = 0; 
  
%>
<body style="background:#CADFFF">
<form name="Fix_XH_Trace"  action="Fix_Trace.do" method="post" target="mFrame">	
<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
	<tr height='25' >
		<td width='5%'  align='center' class="table_deep_blue">序号</td>
		<td width='15%' align='center' class="table_deep_blue">发现日期</td>				
		<td width='15%' align='center' class="table_deep_blue">故障设备</td>
		<td width='20%' align='center' class="table_deep_blue">耗费器材</td>		
		<td width='15%' align='center' class="table_deep_blue">耗材数量</td>
	</tr>
	<%
	if(Fix_XH_Trace != null)
	{
		Iterator iterator = Fix_XH_Trace.iterator();
		while(iterator.hasNext())
		{
			FixTraceBean Bean = (FixTraceBean)iterator.next();
			String SN         = Bean.getSN();
			String Apply_Time = Bean.getApply_Time();
			String Dev_Name      = Bean.getDev_Name();
						 Fix_Des       = Bean.getFix_Des();									
			if(Fix_Des.length() > 0)
			{
				String[] List = Fix_Des.split(";");
				for(int i = 0; i<List.length && List[i].length()>0; i++)
				{
				sn++;
					String[] subList = List[i].split(",");
					String Spa_Type = subList[0];					
						
			
			%>
				<tr height='25' >
					<td  align='center' ><%=sn%></td>
					<td  align='center' ><%=Apply_Time%></td>				
					<td  align='center' ><%=Dev_Name%></td>
					<td  align='center' ><%=Spa_Type%></td>		
					<td  align='center' ><%=subList[2]%></td>
			</tr>														
			<%							
					}
			}	
		}
	}			
	%>   				
<!--	<tr height='25' >
		备注:		
		<td colspan="6">
				<%
				Iterator<Map.Entry<String, String>> iter = map.entrySet().iterator();
				while (iter.hasNext()) 
				{
   				Map.Entry<String, String> entry = iter.next();
   				System.out.println("key= " + entry.getKey() + " and value= " + entry.getValue());
   		%>		
   			<%=map.get(key)%>	
   		<%		
 				 }	
			%>			
		</td>	
	</tr>	 	-->	
</table>
</form>
</body>
</html>