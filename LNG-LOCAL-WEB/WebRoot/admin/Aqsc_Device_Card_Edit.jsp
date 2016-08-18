<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
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
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Aqsc_Device_Card = (ArrayList)session.getAttribute("Aqsc_Device_Card_" + Sid);
	
 	String Id = request.getParameter("Id");
  String CName = "";
	String Status = "0";
	String Des = "";
	String Manag_Dept = "";
	String Lssue_Dept = "";
	String Review_Inteval = "";
	String Overall_Inteval = "";
	if(Aqsc_Device_Card != null)
	{
		Iterator iterator = Aqsc_Device_Card.iterator();
		while(iterator.hasNext())
		{
			AqscDeviceCardBean statBean = (AqscDeviceCardBean)iterator.next();
			if(statBean.getId().equals(Id))
			{
				CName = statBean.getCName();
				Status = statBean.getStatus();
				Des = statBean.getDes();
				Manag_Dept = statBean.getManag_Dept();
				Lssue_Dept = statBean.getLssue_Dept();				
				Review_Inteval = statBean.getReview_Inteval();
				Overall_Inteval = statBean.getOverall_Inteval();
				if(null == Des)
				{
					Des = "";
				}
			}
		}
 	}
 	
%>
<body style="background:#CADFFF">
<form name="Aqsc_Device_Card_Edit" action="Aqsc_Device_Card.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/aqsc_device_card.gif"></div><br><br><br>
	<div id="right_table_center">
		<table width="60%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			<tr height='30'>
				<td width='100%' align='right'>
					<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doEdit()'>
					<img src="../skin/images/button10.gif"           style='cursor:hand;' onclick='doNO()'>
				</td>
			</tr>
			<tr height='30'>
				<td width='100%' align='center'>
					<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
						<tr height='30'>
							<td width='20%' align='center'>编&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号</td>
							<td width='30%' align='left'>
								<%=Id%>
							</td>
							<td width='20%' align='center'>状&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;态</td>
							<td width='30%' align='left'>
							  <select name="Status" style="width:92%;height:20px;">
							  	<option value='0' <%=Status.equals("0")?"selected":""%>>启用</option>
							  	<option value='1' <%=Status.equals("1")?"selected":""%>>注销</option>
							  </select>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称</td>
							<td width='80%' align='left' colspan=3>
								<input type='text' name='CName' style='width:96%;height:18px;' value='<%=CName%>' maxlength='32'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>主管部门</td>
							<td width='80%' align='left' colspan=3>
								<input type='text' name='Manag_Dept' style='width:96%;height:18px;' value='<%=Manag_Dept%>' maxlength='32'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>发证单位</td>
							<td width='80%' align='left' colspan=3>
								<input type='text' name='Lssue_Dept' style='width:96%;height:18px;' value='<%=Lssue_Dept%>' maxlength='32'>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>复审提醒</td>
							<td width='80%' align='left' colspan=3>
								<select name='Review_Inteval' style='width:70px;height:20px;'>
									<option value='15'  <%=Review_Inteval.equals("15")?"selected":""%>>15天</option>
									<option value='30'  <%=Review_Inteval.equals("30")?"selected":""%>>30天</option>
									<option value='60'  <%=Review_Inteval.equals("60")?"selected":""%>>60天</option>
									<option value='90'  <%=Review_Inteval.equals("90")?"selected":""%>>90天</option>
									<option value='120' <%=Review_Inteval.equals("120")?"selected":""%>>120天</option>
									<option value='150' <%=Review_Inteval.equals("150")?"selected":""%>>150天</option>
									<option value='180' <%=Review_Inteval.equals("180")?"selected":""%>>180天</option>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>全面复审提醒</td>
							<td width='80%' align='left' colspan=3>
								<select name='Overall_Inteval' style='width:70px;height:20px;'>
									<option value='0'   <%=Overall_Inteval.equals("0")?"selected":""%>>无</option>
									<option value='15'  <%=Overall_Inteval.equals("15")?"selected":""%>>15天</option>
									<option value='30'  <%=Overall_Inteval.equals("30")?"selected":""%>>30天</option>
									<option value='60'  <%=Overall_Inteval.equals("60")?"selected":""%>>60天</option>
									<option value='90'  <%=Overall_Inteval.equals("90")?"selected":""%>>90天</option>
									<option value='120' <%=Overall_Inteval.equals("120")?"selected":""%>>120天</option>
									<option value='150' <%=Overall_Inteval.equals("150")?"selected":""%>>150天</option>
									<option value='180' <%=Overall_Inteval.equals("180")?"selected":""%>>180天</option>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='20%' align='center'>描&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;述</td>
							<td width='80%' align='left' colspan=3>
								<textarea name='Des' rows='8' cols='69' maxlength=128><%=Des%></textarea>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>
<input name="Cmd" type="hidden" value="11">
<input name="Id"  type="hidden" value="<%=Id%>">
<input name="Sid" type="hidden" value="<%=Sid%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doNO()
{
	location = "Aqsc_Device_Card.jsp?Sid=<%=Sid%>";
}

function doEdit()
{
  if(Aqsc_Device_Card_Edit.CName.value.Trim().length < 1)
  {
    alert("请输入名称!");
    return;
  }
  if(Aqsc_Device_Card_Edit.Manag_Dept.value.Trim().length < 1)
  {
    alert("请输入主管部门!");
    return;
  }
  if(Aqsc_Device_Card_Edit.Lssue_Dept.value.Trim().length < 1)
  {
    alert("请输入发证单位!");
    return;
  }
  if(Aqsc_Device_Card_Edit.Des.value.Trim().length > 128)
  {
    alert("描述过长，请简化!");
    return;
  }
  if(confirm("信息无误,确定提交?"))
  {
  	Aqsc_Device_Card_Edit.submit();
  }
}
</SCRIPT>
</html>