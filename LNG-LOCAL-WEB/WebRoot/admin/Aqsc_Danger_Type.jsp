<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Aqsc_Danger_Type = (ArrayList)session.getAttribute("Aqsc_Danger_Type_" + Sid);
	
%>
<body  style=" background:#CADFFF">
<form name="Aqsc_Danger_Type" action="Aqsc_Danger_Type.do" method="post" target="mFrame">
<div id="down_bg_2">
  <div id="cap"><img src="../skin/images/aqsc_danger_type.gif"></div><br><br><br>
  <div id="right_table_center">
  	<table width="90%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			<tr height='30' valign='middle'>
				<td width='100%' align='right' colspan=2>
					<img src="../skin/images/mini_button_add.gif" style='cursor:hand;' onClick='doAdd()'>
				</td>
			</tr>
			<tr height='30' valign='middle'>
				<td width='100%' align='center' colspan=2>
					<table width="100%" style='margin:auto;' border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			 			<tr>
							<td width="10%" class="table_deep_blue">�� ��</td>
							<td width="20%" class="table_deep_blue">�� ��</td>
							<td width="10%" class="table_deep_blue">״ ̬</td>
							<td width="40%" class="table_deep_blue">�� ��</td>
						</tr>
						<%
						if(Aqsc_Danger_Type != null)
						{
							int sn = 0;
							Iterator iterator = Aqsc_Danger_Type.iterator();
							while(iterator.hasNext())
							{
								AqscDangerTypeBean statBean = (AqscDangerTypeBean)iterator.next();
								String Id = statBean.getId();
								String CName = statBean.getCName();
								String Status = statBean.getStatus();
								String Des = statBean.getDes();
								if(null == Des)
								{
									Des = "";
								}
								
								String str_Status = "";
								switch(Integer.parseInt(Status))
								{
									case 0:
											str_Status = "����";
										break;
									case 1:
											str_Status = "ע��";
										break;
								}
								
								sn++;
						%>
								<tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
									<%
									if(Status.equals("0"))
									{
									%>
										<td align=center><a href="#" title="����༭" onClick="doEdit('<%=Id%>')"><U><%=Id%></U></a></td>
										<td align=left><%=CName%></td>
									  <td align=center><%=str_Status%></td>
									  <td align=left><%=Des%>&nbsp;</td>
									<%
									}
									else
									{
									%>
										<td align=center><a href="#" title="����༭" onClick="doEdit('<%=Id%>')"><font color=gray><U><%=Id%></U></font></a></td>
										<td align=left><font color=gray><%=CName%></font></td>
									  <td align=center><font color=gray><%=str_Status%></font></td>
									  <td align=left><font color=gray><%=Des%>&nbsp;</font></td>
									<%
									}
									%>
								</tr>
						<%		
							}
						}
						%>
			 		</table>
				</td>
			</tr>
		</table>
	</div>   
</div>
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
	location = "Aqsc_Danger_Type_Add.jsp?Sid=<%=Sid%>";
}

function doEdit(pId)
{
	location = "Aqsc_Danger_Type_Edit.jsp?Sid=<%=Sid%>&Id="+pId;
}
</SCRIPT>
</html>