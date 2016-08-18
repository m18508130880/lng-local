<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid   = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String CType = CommUtil.StrToGB2312(request.getParameter("CType"));
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Aqsc_Device_Type = (ArrayList)session.getAttribute("Aqsc_Device_Type_" + Sid);
	ArrayList Aqsc_Device_Card = (ArrayList)session.getAttribute("Aqsc_Device_Card_" + Sid);
	
%>
<body style="background:#CADFFF">
<form name="Aqsc_Device_Type" action="Aqsc_Device_Type.do" method="post" target="_self">
	<table width="100%" style='margin:auto;' border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr>
			<td width="10%" class="table_deep_blue">
				<img src='../skin/images/diyBtn1.gif' style='cursor:hand' title='点击添加' onclick="doAdd()">
				类型编号
			</td>
			<td width="15%" class="table_deep_blue">类型名称</td>
			<td width="10%" class="table_deep_blue">类型型号</td>
			<td width="15%" class="table_deep_blue">类型厂家</td>
			<td width="10%" class="table_deep_blue">类型状态</td>
			<td width="30%" class="table_deep_blue">必备证件</td>
		</tr>
		<%
		if(Aqsc_Device_Type != null)
		{
			int sn = 0;
			Iterator iterator = Aqsc_Device_Type.iterator();
			while(iterator.hasNext())
			{
				AqscDeviceTypeBean statBean = (AqscDeviceTypeBean)iterator.next();
				String Id = statBean.getId();
				String CName = statBean.getCName();
				String Model = statBean.getModel();
				String Agent = statBean.getAgent();
				String Status = statBean.getStatus();							
				String Card_List = statBean.getCard_List();
				if(null == Card_List){Card_List = "";}
				
				String str_Status = "";
				switch(Integer.parseInt(Status))
				{
					case 0:
							str_Status = "启用";
						break;
					case 1:
							str_Status = "注销";
						break;
				}
				
				String str_Card_List = "";
				if(Card_List.length() > 0 && Aqsc_Device_Card != null)
				{
					int index = 0;
					for(int i=0; i<Aqsc_Device_Card.size(); i++)
					{
						AqscDeviceCardBean DeviceCard = (AqscDeviceCardBean)Aqsc_Device_Card.get(i);
						if(Card_List.contains(DeviceCard.getId()))
						{
							index++;
							if(1 == index)
								str_Card_List += index + "、" +  DeviceCard.getCName();
							else
								str_Card_List += "<br>" + index + "、" +  DeviceCard.getCName();
						}
					}
				}
				
				sn++;
		%>
				<tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
					<%
					if(Status.equals("0"))
					{
					%>
						<td align=center><a href="#" title="点击编辑" onClick="doEdit('<%=Id%>')"><U><%=Id%></U></a></td>
						<td align=left><%=CName%></td>
						<td align=left><%=Model%></td>
					  <td align=left><%=Agent%></td>
					  <td align=center><%=str_Status%>&nbsp;</td>
					  <td align=left><%=str_Card_List%>&nbsp;</td>
					<%
					}
					else
					{
					%>
						<td align=center><a href="#" title="点击编辑" onClick="doEdit('<%=Id%>')"><font color=gray><U><%=Id%></U></font></a></td>
						<td align=left><font color=gray><%=CName%></font></td>
						<td align=left><font color=gray><%=Model%></font></td>
					  <td align=left><font color=gray><%=Agent%></font></td>
					  <td align=center><font color=gray><%=str_Status%>&nbsp;</font></td>
					  <td align=left><font color=gray><%=str_Card_List%>&nbsp;</font></td>
					<%
					}
					%>
				</tr>
		<%
			}
		}
		%>
	</table>
	<input name="Cmd"   type="hidden" value="0">
	<input name="Sid"   type="hidden" value="<%=Sid%>">
	<input name="CType" type="hidden" value="<%=CType%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
if(<%=currStatus.getResult().length()%> > 0)
   alert("<%=currStatus.getResult()%>");
<%
currStatus.setResult("");
session.setAttribute("CurrStatus_" + Sid, currStatus);
%>

function doAdd()
{
	location = "Aqsc_Device_Type_Add.jsp?Sid=<%=Sid%>&CType=<%=CType%>";
}

function doEdit(pId)
{
	location = "Aqsc_Device_Type_Edit.jsp?Sid=<%=Sid%>&CType=<%=CType%>&Id="+pId;
}
</SCRIPT>
</html>