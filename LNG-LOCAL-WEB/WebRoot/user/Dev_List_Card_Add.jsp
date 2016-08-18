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
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%

	String Sid         = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String SN          = CommUtil.StrToGB2312(request.getParameter("SN"));
	String Card_Type   = CommUtil.StrToGB2312(request.getParameter("Card_Type"));
	String Cpm_Name    = CommUtil.StrToGB2312(request.getParameter("Cpm_Name"));
	String Dev_Name    = CommUtil.StrToGB2312(request.getParameter("Dev_Name"));
	String BDate       = CommUtil.getDate();
	
	CurrStatus currStatus   = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Dev_List_Card = (ArrayList)session.getAttribute("Dev_List_Card_" + Sid);
	UserInfoBean UserInfo   = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  
  String Card_Type_N = "";
  String Overall_Inteval = "";
  if(null != Dev_List_Card)
	{
		Iterator typeiter = Dev_List_Card.iterator();
		while(typeiter.hasNext())
		{
			AqscDeviceCardBean typeBean = (AqscDeviceCardBean)typeiter.next();
			if(typeBean.getId().equals(Card_Type))
			{
				Card_Type_N = typeBean.getCName();
				Overall_Inteval = typeBean.getOverall_Inteval();
				break;
			}
		}
	}
	
%>
<body style="background:#CADFFF">
<form name="Dev_List_Card_Add" action="Dev_List_Card.do" method="post" target="mFrame">
<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
	<tr height='40'>
		<td width='20%' align='center'>站&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;点</td>
		<td width='30%' align='left'>
			<%=Cpm_Name%>
		</td>
		<td width='20%' align='center'>名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称</td>
		<td width='30%' align='left'>
		  <%=Dev_Name%>
		</td>
	</tr>
	<tr height='40'>
		<td width='20%' align='center'>证件类型</td>
		<td width='30%' align='left'>
			<%=Card_Type_N%>
		</td>
		<td width='20%' align='center'>证件编号</td>
		<td width='30%' align='left'>
			<input type='text' name='Card_Id' style='width:96%;height:16px;' value='' maxlength='32'>
		</td>
	</tr>
	<tr height='40'>		
		<td width='20%' align='center'>检定日期</td>
		<td width='30%' align='left'>
		  <input name='Card_BTime' type='text' style='width:96%;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
		</td>
		<td width='20%' align='center'>复检年限</td>
		<td width='30%' align='left'>
			<select name='Card_Review' style='width:98%;height:20px;'>
				<option value='1'>1年</option>
				<option value='2'>2年</option>
				<option value='3'>3年</option>
				<option value='4'>4年</option>
				<option value='5'>5年</option>
				<option value='6'>6年</option>
				<option value='7'>7年</option>
				<option value='8'>8年</option>
			</select>
		</td>
	</tr>
	<tr height='40' id='Overall'>		
		<td width='20%' align='center'>全面检定日期</td>
		<td width='30%' align='left'>
		  <input name='Card_All_BTime' type='text' style='width:96%;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
		</td>
		<td width='20%' align='center'>全面复检年限</td>
		<td width='30%' align='left'>
			<select name='Card_Overall' style='width:98%;height:20px;'>
				<option value='1'>1年</option>
				<option value='2'>2年</option>
				<option value='3'>3年</option>
				<option value='4' selected>4年</option>
				<option value='5'>5年</option>
				<option value='6'>6年</option>
				<option value='7'>7年</option>
				<option value='8'>8年</option>
			</select>
		</td>
	</tr>
	<tr height='40'>
		<td width='20%' align='center'>录入人员</td>
		<td width='80%' align='left' colspan=3>
		  <%=Operator_Name%>
		</td>
	</tr>
	<tr height='40'>
		<td width='100%' align='center' colspan=4>
			<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doAdd()'>
		</td>
	</tr>
</table>
</form>
</body>
<SCRIPT LANGUAGE=javascript>
if(parseInt('<%=Overall_Inteval%>') <= 0)
{
	document.getElementById('Overall').style.display = 'none';
}

function doAdd()
{
  if(Dev_List_Card_Add.Card_Id.value.Trim().length < 1)
  {
    alert("请填写证件编号!");
    return;
  }
  if(Dev_List_Card_Add.Card_BTime.value.length < 1)
  {
    alert("请选择检定日期!");
    return;
  }
  
  var Card_ETime = (parseInt(Dev_List_Card_Add.Card_BTime.value.substring(0,4)) + parseInt(Dev_List_Card_Add.Card_Review.value)) + Dev_List_Card_Add.Card_BTime.value.substring(4,10);
  var Card_All_BTime = '';
  var Card_All_ETime = '';
  var Card_Overall = 0;
  if(document.getElementById('Overall').style.display == '')
  {
  	Card_All_BTime = Dev_List_Card_Add.Card_All_BTime.value;
  	Card_All_ETime = (parseInt(Dev_List_Card_Add.Card_All_BTime.value.substring(0,4)) + parseInt(Dev_List_Card_Add.Card_Overall.value)) + Dev_List_Card_Add.Card_All_BTime.value.substring(4,10);
  	Card_Overall = Dev_List_Card_Add.Card_Overall.value;
  }
  else
  {
  	Card_All_BTime = '<%=BDate%>';
  	Card_All_ETime = '<%=BDate%>';
  	Card_Overall = 0;
  }
  
  if(confirm("信息无误,确定提交?"))
  {
  	if(window.XMLHttpRequest)
	  {
			reqAdd = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqAdd = new ActiveXObject("Microsoft.XMLHTTP");
		}		
		//设置回调函数
		reqAdd.onreadystatechange = function()
		{
			var state = reqAdd.readyState;
			if(state == 4)
			{
				if(reqAdd.status == 200)
				{
					var resp = reqAdd.responseText;			
					if(resp != null && resp.substring(0,4) == '0000')
					{
						alert('成功');
						parent.doSelect();
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
		
		var url = 'Dev_List_Card.do?Cmd=10&Sid=<%=Sid%>&SN=<%=SN%>&Operator=<%=Operator%>&Card_Type=<%=Card_Type%>'
		        + '&Card_Id='+Dev_List_Card_Add.Card_Id.value
		        + '&Card_BTime='+Dev_List_Card_Add.Card_BTime.value
		        + '&Card_ETime='+Card_ETime
		        + '&Card_Review='+Dev_List_Card_Add.Card_Review.value
		        + '&Card_All_BTime='+Card_All_BTime
		        + '&Card_All_ETime='+Card_All_ETime
		        + '&Card_Overall='+Card_Overall
		        + '&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sel_Id=<%=currStatus.getFunc_Sel_Id()%>&currtime='+new Date();
		reqAdd.open("post",url,true);
		reqAdd.send(null);
		return true;
  }
}
</SCRIPT>
</html>