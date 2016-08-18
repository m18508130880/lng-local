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
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%

	String Sid      = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String Lab_Type = CommUtil.StrToGB2312(request.getParameter("Lab_Type"));
	String Lab_Mode = CommUtil.StrToGB2312(request.getParameter("Lab_Mode"));
	
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Lab_Store   = (ArrayList)session.getAttribute("Lab_Store_" + Sid);
	
	String Lab_Type_Name = "";
	String Model = "";
	String Lab_Mode_Name = "/";
	String Lab_I_Cnt = "";
	String Lab_O_Cnt = "";
	String Lab_S_Cnt = "";
	String Unit = "";
	String Brand = "";
	String Seller = "";
	
	if(Lab_Store != null)
	{
		Iterator iterator = Lab_Store.iterator();
		while(iterator.hasNext())
		{
			LabStoreBean Bean = (LabStoreBean)iterator.next();
			if(Bean.getLab_Type().equals(Lab_Type) && Bean.getLab_Mode().equals(Lab_Mode))
			{
				Lab_Type_Name = Bean.getLab_Type_Name();
				Model = Bean.getModel();
				Lab_I_Cnt = Bean.getLab_I_Cnt();
				Lab_O_Cnt = Bean.getLab_O_Cnt();
				Lab_S_Cnt = Bean.getLab_S_Cnt();
				Unit = Bean.getUnit();
				Brand = Bean.getBrand();
				Seller = Bean.getSeller();
				
				if(null != Model && Model.length() > 0)
				{
					String[] List = Model.split(",");
					if(List.length >= Integer.parseInt(Lab_Mode))
						Lab_Mode_Name = List[Integer.parseInt(Lab_Mode)-1];
				}			
			}
		}
	}
	
%>
<body style="background:#CADFFF">
<form name="Lab_Store_Edt" action="Lab_Store.do" method="post" target="mFrame">
	<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">					
		<tr height='30'>
			<td width='25%' align='center'>用品名称</td>
			<td width='75%' align='left'>
				<%=Lab_Type_Name%>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>规格型号</td>
			<td width='75%' align='left'>
				<%=Lab_Mode_Name%>
			</td>
		</tr>						
		<tr height='30'>
			<td width='25%' align='center'>在库数量</td>
			<td width='75%' align='left'>
				<%=Lab_I_Cnt%>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>出库数量</td>
			<td width='75%' align='left'>
				<%=Lab_O_Cnt%>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>已 报 废</td>
			<td width='75%' align='left'>
				<%=Lab_S_Cnt%>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>此次报废</td>
			<td width='75%' align='left'>
				<input type='text' name='Lab_S_Cnt' style='width:40px;height:16px;' maxlength=4>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>单&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;位</td>
			<td width='75%' align='left'>
				<%=Unit%>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>品牌信息</td>
			<td width='75%' align='left'>
				<%=Brand%>
			</td>
		</tr>
		<tr height='30'>
			<td width='25%' align='center'>供货单位</td>
			<td width='75%' align='left'>
				<%=Seller%>
			</td>
		</tr>
		<tr height='40'>
			<td width='100%' align='center' colspan=2>
				<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doEdit()'>
			</td>
		</tr>
	</table>
</form>
</body>
<SCRIPT LANGUAGE=javascript>
var reqScrape = null;
function doEdit()
{
	if(Lab_Store_Edt.Lab_S_Cnt.value.Trim().length < 1 || Lab_Store_Edt.Lab_S_Cnt.value <= 0)
  {
  	alert("此次报废数量输入错误,可能的原因：\n\n  1.为空。\n\n  2.不是正值。");
		return;
  }
  for(var i=0; i<Lab_Store_Edt.Lab_S_Cnt.value.length; i++)
	{
		if(isNaN(Lab_Store_Edt.Lab_S_Cnt.value.charAt(i)))
	  {
	    alert("此次报废数量输入有误，请重新输入!");
	    return;
	  }
	}
	if(parseInt(Lab_Store_Edt.Lab_S_Cnt.value.Trim()) > parseInt('<%=Lab_I_Cnt%>'))
	{
		alert("此次报废的数量已超过当前在库的总数量!");
		return;
	}
  if(confirm("信息无误，确认提交?"))
  {
  	if(window.XMLHttpRequest)
	  {
			reqScrape = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqScrape = new ActiveXObject("Microsoft.XMLHTTP");
		}		
		//设置回调函数
		reqScrape.onreadystatechange = function()
		{
			var state = reqScrape.readyState;
			if(state == 4)
			{
				if(reqScrape.status == 200)
				{
					var resp = reqScrape.responseText;
					if(resp != null && resp.substring(0,4) == '0000')
					{
						alert('成功');
						parent.location = "Lab_Store.jsp?Sid=<%=Sid%>";
						return;
					}
					else if(resp != null && resp.substring(0,4) == '3006')
					{
						alert('失败，您即将报废的数量超过当前在库总数!');
						return;
					}
					else
					{
						alert('失败，请重新操作');
						return;
					}
				}
				else
				{
					alert("失败，请重新操作");
					return;
				}
			}
		};
		var url = "Lab_Store_Scrape.do?Cmd=20&Sid=<%=Sid%>&Lab_Type=<%=Lab_Type%>&Lab_Mode=<%=Lab_Mode%>&Lab_S_Cnt="+Lab_Store_Edt.Lab_S_Cnt.value.Trim()
						+ "&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>"
						+ "&currtime="+new Date();
		reqScrape.open("post",url,true);
		reqScrape.send(null);
		return true;
  }
}
</SCRIPT>
</html>