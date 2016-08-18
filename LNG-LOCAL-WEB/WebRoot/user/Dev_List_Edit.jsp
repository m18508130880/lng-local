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
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../skin/js/util.js"></script>

</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String SN  = CommUtil.StrToGB2312(request.getParameter("SN"));
	
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Dev_List    = (ArrayList)session.getAttribute("Dev_List_" + Sid);
	
	String Cpm_Name      = "";
	String CType_Name    = "";
	String Dev_Type_Name = "";
	String Dev_Id        = "";
	String Dev_Name      = "";
	String Dev_Date      = "";
	String Model         = "";
	String Craft         = "";
	String Technology    = "";
	String Cpm_Id        = "";
	String Dev_ShuXing   = "";

	if(Dev_List != null)
	{
		Iterator iterator = Dev_List.iterator();
		while(iterator.hasNext())
		{
			DevListBean Bean = (DevListBean)iterator.next();
			if(Bean.getSN().equals(SN))
			{
				Cpm_Id        = Bean.getCpm_Id();
				Cpm_Name      = Bean.getCpm_Name();
				CType_Name    = Bean.getCType_Name();
				Dev_Type_Name = Bean.getDev_Type_Name();
				Dev_Id        = Bean.getDev_Id();
				Dev_Name      = Bean.getDev_Name();
				Dev_Date      = Bean.getDev_Date();
				
				Dev_ShuXing   = Bean.getDev_ShuXing();
				Model         = Bean.getModel();
				Craft         = Bean.getCraft();
				Technology    = Bean.getTechnology();
				if(null == Model){Model = "";}
				if(null == Craft){Craft = "";}
				if(null == Technology){Technology = "";}
			}
		}
	}
	
%>
<body style="background:#CADFFF">
<form name="Dev_List_Edit" action="Dev_List.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/dev_list_edit.gif"></div><br><br><br>
	<div id="right_table_center">
		<table width="50%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
			<tr height='30'>
				<td width='100%' align='right'>
					<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doAdd()'>
					<img src="../skin/images/button10.gif"           style='cursor:hand;' onclick='doNO()'>
				</td>
			</tr>
			<tr height='30'>
				<td width='100%' align='center'>
					<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
						<tr height='30'>
							<td width='25%' align='center'>场站名称</td>
							<td width='75%' align='left'>
								<%=Cpm_Name%>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>设备品种</td>
							<td width='75%' align='left'>
								<%=CType_Name%>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>设备类型</td>
							<td width='75%' align='left'>
								<%=Dev_Type_Name%>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>设备名称</td>
							<td width='75%' align='left'>
								<input type='text' name='Dev_Name' style="width:90%;height:16px" value='<%=Dev_Name%>' maxlength=32>&nbsp;	
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>设备位号</td>
							<td width='75%' align='left'>
								<input type='text' name='Dev_Id' style="width:90%;height:16px" value='<%=Dev_Id%>' maxlength=20>&nbsp;	
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>出产日期</td>
							<td width='75%' align='left'>
								<input type='text' name='Dev_Date' style='width:91%;height:18px;' value='<%=Dev_Date%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
							</td>
						</tr>
						<!--<tr height='30'>
							<td width='25%' align='center'>其他属性</td>
							<td width='75%' align='left'>
								<input type='text' name='Dev_ShuXing' style="width:90%;height:16px" value='<%=Dev_ShuXing%>' maxlength=20>&nbsp;&nbsp;							
							</td>
					</tr>			-->
<%
			if( Dev_ShuXing.trim().length() > 0)
			{
				String[] List = Dev_ShuXing.split(";");
			 for(int i=0; i<List.length && List[i].length()>0; i++)
				{
					String[] subList = List[i].split(",");				
					if(subList.length > 1)
					{
	%>				
				<tr height='30'>
							<td  width='25%' align='center'>
								<%=subList[0]%>&nbsp;								
							</td>
							<td  width='75%' align='left'>
								<input type='text' name='value_<%=i%>' style="width:90%;height:16px" value='<%=subList[1]%>' maxlength=20>&nbsp;&nbsp;								
							</td>
					</tr>											
	<%				
					}
				}

		}
%>												
						<tr height='30'>
							<td width='25%' align='center'>规格型号</td>
							<td width='75%' align='left'>
								<%=Model%>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>工艺参数</td>
							<td width='75%' align='left'>
								<%=Craft%>&nbsp;	
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>技术参数</td>
							<td width='75%' align='left'>
								<%=Technology%>&nbsp;	
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>
<input type="hidden" name="Cmd"    value="11">
<input type="hidden" name="Sid"    value="<%=Sid%>">
<input type="hidden" name="SN"     value="<%=SN%>">
<input type="hidden" name="Cpm_Id" value="<%=Cpm_Id%>">
<input type="hidden" name="Dev_ShuXing"     value="">
<input type="hidden" name="Func_Corp_Id" value="<%=currStatus.getFunc_Corp_Id()%>">
<input type="hidden" name="Func_Sel_Id"  value="<%=currStatus.getFunc_Sel_Id()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Dev_List_Edit.jsp';

function doNO()
{
	location = "Dev_List.jsp?Sid=<%=Sid%>";
}

function doAdd()
{
	var str = '';
<%	
	if( Dev_ShuXing.trim().length() > 0)
	{	
			String[] Listvalue = Dev_ShuXing.split(";");
			 for(int i=0; i<Listvalue.length && Listvalue[i].length()>0; i++)
				{
					String[] subListvalue = Listvalue[i].split(",");				
					if(subListvalue.length > 1)
					{
						if(i == 0)
						{ 
	%>					
						str = '<%=subListvalue[0]%>' + ',' + Dev_List_Edit.value_<%=i%>.value; 
	<%					
					}else{
						
%>	
			 str = str+ ';'+'<%=subListvalue[0]%>' +','+ Dev_List_Edit.value_<%=i%>.value;
	

<%	
						}
					}
				}	
	}
%>	
  if(Dev_List_Edit.Dev_Name.value.Trim().length < 1)
  {
  	alert('请填写名称!');
  	return;
  }
  if(Dev_List_Edit.Dev_Id.value.Trim().length < 1)
  {
  	alert('请填写出厂编号!');
  	return;
  }
  if(Dev_List_Edit.Dev_Date.value.Trim().length < 1)
  {
  	alert('请选择出厂日期!');
  	return;
  }
  if(confirm("信息无误,确定提交?"))
  {
  	//Dev_List_Edit.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
  	
  	
  	Dev_List_Edit.Dev_ShuXing.value = str ;
  	Dev_List_Edit.submit();
  }
}
</SCRIPT>
</html>