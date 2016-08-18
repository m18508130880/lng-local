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
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Aqsc_Spare_Type = (ArrayList)session.getAttribute("Aqsc_Spare_Type_" + Sid);
	
%>
<body style="background:#CADFFF">
<form name="Aqsc_Spare_Type" action="Aqsc_Spare_Type.do" method="post" target="mFrame">
<div id="down_bg_2">
  <div id="cap"><img src="../skin/images/aqsc_spare_type.gif"></div><br><br><br>
  <div id="right_table_center">
  	<table width="90%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			<tr height='30' valign='middle'>
				<td width='70%' align='left'>
					<select name='Func_Sub_Id' style='width:120px;height:20px;' onchange="doSelect()">
						<option value='9' <%=currStatus.getFunc_Sub_Id() == 9?"selected":""%>>全部</option>
						<option value='1' <%=currStatus.getFunc_Sub_Id() == 1?"selected":""%>>电气类</option>
						<option value='2' <%=currStatus.getFunc_Sub_Id() == 2?"selected":""%>>工艺类</option>						
					</select>
				</td>
				<td width='30%' align='right'>
					<img src="../skin/images/mini_button_add.gif" style='cursor:hand;' onClick='doAdd()'>
				</td>
			</tr>
			<tr height='30' valign='middle'>
				<td width='100%' align='center' colspan=2>
					<table width="100%" style='margin:auto;' border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			 			<tr>
							<td width="10%" class="table_deep_blue">编 号</td>
							<td width="20%" class="table_deep_blue">名 称</td>
							<td width="10%" class="table_deep_blue">类 别</td>
							<td width="20%" class="table_deep_blue">型 号</td>
							<td width="10%" class="table_deep_blue">单 位</td>
							<td width="10%" class="table_deep_blue">品 牌</td>
							<td width="10%" class="table_deep_blue">供货单位</td>
							<td width="10%" class="table_deep_blue">状 态</td>
						</tr>
						<%
						if(Aqsc_Spare_Type != null)
						{
							int sn = 0;
							Iterator iterator = Aqsc_Spare_Type.iterator();
							while(iterator.hasNext())
							{
								AqscSpareTypeBean statBean = (AqscSpareTypeBean)iterator.next();
								String Id = statBean.getId();
								String CName = statBean.getCName();
								String CType = statBean.getCType();
								String Model = statBean.getModel();
								String Unit = statBean.getUnit();
								String Brand = statBean.getBrand();
								String Seller = statBean.getSeller();
								String Status = statBean.getStatus();							
																
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
								
								String str_CType = "";
								switch(Integer.parseInt(CType))
								{								
									case 1:
											str_CType = "电气类";
										break;
									case 2:
											str_CType = "工艺类";
										break;								
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
										<td align=center><%=str_CType%></td>
										<td align=left><%=Model%></td>
									  <td align=left><%=Unit%></td>
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
										<td align=center><font color=gray><%=str_CType%></font></td>
										<td align=left><font color=gray><%=Model%></font></td>
									  <td align=left><font color=gray><%=Unit%></font></td>
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
<input name="Cmd" type="hidden" value="0">
<input name="Sid" type="hidden" value="<%=Sid%>">
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
	Aqsc_Spare_Type.submit();
}

function doAdd()
{
	location = "Aqsc_Spare_Type_Add.jsp?Sid=<%=Sid%>";
}

function doEdit(pId)
{
	location = "Aqsc_Spare_Type_Edit.jsp?Sid=<%=Sid%>&Id="+pId;
}
</SCRIPT>
</html>