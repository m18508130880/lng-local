<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中海油LNG加气站公司级信息化管理平台</title>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Aqsc_Labour_Type = (ArrayList)session.getAttribute("Aqsc_Labour_Type_" + Sid);
	
%>
<body  style=" background:#CADFFF">
<form name="Aqsc_Labour_Type" action="Aqsc_Labour_Type.do" method="post" target="mFrame">
<div id="down_bg_2">
  <div id="cap"><img src="../skin/images/aqsc_labour_type.gif"></div><br><br><br>
  <div id="right_table_center">
  	<table width="90%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			<tr height='30' valign='middle'>
				<td width='100%' align='right' colspan=2>
					<img src="../skin/images/mini_button_add.gif" style='cursor:hand;' onClick='doAdd()'>
					<img src="../skin/images/pldr.gif" style='cursor:hand;' onClick='doDAORU()'>					
				</td>
			</tr>
			<tr height='30' valign='middle'>
				<td width='100%' align='center' colspan=2>
					<table width="100%" style='margin:auto;' border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			 			<tr>
							<td width="10%" class="table_deep_blue">编 号</td>
							<td width="15%" class="table_deep_blue">名 称</td>
							<td width="25%" class="table_deep_blue">型 号</td>
							<td width="10%" class="table_deep_blue">单 位</td>					
							<td width="10%" class="table_deep_blue">品 牌</td>
							<td width="10%" class="table_deep_blue">供货单位</td>
							<td width="10%" class="table_deep_blue">状 态</td>
						</tr>
						<%
						if(Aqsc_Labour_Type != null)
						{
							int sn = 0;
							Iterator iterator = Aqsc_Labour_Type.iterator();
							while(iterator.hasNext())
							{
								AqscLabourTypeBean statBean = (AqscLabourTypeBean)iterator.next();
								String Id = statBean.getId();
								String CName = statBean.getCName();
								String Status = statBean.getStatus();
								String Des = statBean.getDes();
								String Model = statBean.getModel();
								String Unit = statBean.getUnit();
								String Brand = statBean.getBrand();
								String Seller = statBean.getSeller();
								
								if(null == Des)
								{
									Des = "";
								}
								
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
								
								sn++;
						%>
								<tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%> title='<%=Des%>'>
									<%
									if(Status.equals("0"))
									{
									%>
										<td align=center><a href="#" title="点击编辑" onClick="doEdit('<%=Id%>')"><U><%=Id%></U></a></td>
										<td align=left><%=CName%></td>
										<td align=left><%=Model%></td>
										<td align=center><%=Unit%></td>
										<td align=left><%=Brand%></td>
										<td align=left><%=Seller%></td>
									  <td align=center><%=str_Status%></td>
									<%
									}
									else
									{
									%>
										<td align=center><a href="#" title="点击编辑" onClick="doEdit('<%=Id%>')"><font color=gray><U><%=Id%></U></font></a></td>
										<td align=left><font color=gray><%=CName%></font></td>
										<td align=left><font color=gray><%=Model%></font></td>
										<td align=center><font color=gray><%=Unit%></font></td>
										<td align=left><font color=gray><%=Brand%></font></td>
										<td align=left><font color=gray><%=Seller%></font></td>
									  <td align=center><font color=gray><%=str_Status%></font></td>
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
	location = "Aqsc_Labour_Type_Add.jsp?Sid=<%=Sid%>";
}

function doEdit(pId)
{
	location = "Aqsc_Labour_Type_Edit.jsp?Sid=<%=Sid%>&Id="+pId;
}

function doDAORU()
{
	var Pdiag = new Dialog();
	Pdiag.Top = "50%";
	Pdiag.Width = 500;
	Pdiag.Height = 120;
	Pdiag.Title = "劳保批量导入";
	Pdiag.URL = 'Aqsc_Labour_File.jsp?Sid=<%=Sid%>';
	Pdiag.show();
}
</SCRIPT>
</html>