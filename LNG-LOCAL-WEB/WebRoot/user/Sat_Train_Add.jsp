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
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../skin/js/util.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String BDate = CommUtil.getDate();
	
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
 	
 	CurrStatus currStatus    = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Sat_Train_Type = (ArrayList)session.getAttribute("Sat_Train_Type_" + Sid);
  UserInfoBean UserInfo    = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
	
%>
<body style="background:#CADFFF">
<form name="Sat_Train_Add" action="Sat_Train.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/sat_train_add.gif"></div><br><br><br>
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
							<td width='25%' align='center'>��ʼ����</td>
							<td width='75%' align='left'>
								<input name='Train_BTime' type='text' style='width:118px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>��������</td>
							<td width='75%' align='left'>
								<input name='Train_ETime' type='text' style='width:118px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>��֯����</td>
							<td width='75%' align='left'>
								<select name="Train_Dept" style="width:120px;height:20px">
								<%
								if(Dept.trim().length() > 0)
								{
									String[] DeptList = Dept.split(",");
								  String pDept_Id = "";
								  String pDept_Name = "";
								  for(int i=0; i<DeptList.length; i++)
								  {
										pDept_Id = CommUtil.IntToStringLeftFillZero(i+1, 2);
										pDept_Name = DeptList[i];
								%>
								    <option value="<%=pDept_Id%>"><%=pDept_Name%></option>
								<%
		    					}
								}
								%>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>��ѵ����</td>
							<td width='75%' align='left'>
								<select name="Train_Type" style="width:120px;height:20px">
								<%
								if(null != Sat_Train_Type)
								{
									Iterator typeiter = Sat_Train_Type.iterator();
									while(typeiter.hasNext())
									{
										AqscTrainTypeBean typeBean = (AqscTrainTypeBean)typeiter.next();
										if(typeBean.getStatus().equals("0"))
										{
								%>
											<option value='<%=typeBean.getId()%>'><%=typeBean.getCName()%></option>
								<%
										}
									}
								}
								%>
								</select>
							</td>
						</tr>					
						<tr height='30'>
							<td width='25%' align='center'>��ѵ����</td>
							<td width='75%' align='left'>
								<input type='text' name='Train_Title' style="width:99%;height:18px" value='' maxlength=32>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>��ѵ��λ</td>
							<td width='75%' align='left'>
								<input type='text' name='Train_Corp' style="width:99%;height:18px" value='' maxlength=32>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>��ѵ����</td>
							<td width='75%' align='left'>
								<input type='text' name='Train_Object' style="width:99%;height:18px" value='' maxlength=128>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>��ѵ����</td>
							<td width='75%' align='left'>
								<input type='text' name='Train_Cnt' style="width:118px;height:18px" value='' maxlength=4> ��
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>��ѵ��ʱ</td>
							<td width='75%' align='left'>
								<input type='text' name='Train_Hour' style="width:118px;height:18px" value='' maxlength=4> Сʱ
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>�Ƿ񿼺�</td>
							<td width='75%' align='left'>
								<select name="Train_Assess" style="width:120px;height:20px">
									<option value='0'>��</option>
									<option value='1'>��</option>
								</select>
							</td>
						</tr>
						<tr height='30'>
							<td width='25%' align='center'>¼����Ա</td>
							<td width='75%' align='left'>
								<%=Operator_Name%>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>
</form>
</body>
<SCRIPT LANGUAGE=javascript>
//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Sat_Train_Add.jsp';

function doNO()
{
	location = "Sat_Train.jsp?Sid=<%=Sid%>";
}

var reqAdd = null;
function doAdd()
{
  if(Sat_Train_Add.Train_BTime.value.length < 1)
  {
  	alert('��ѡ����ѵ��ʼ����!');
  	return;
  }
  if(Sat_Train_Add.Train_ETime.value.length < 1)
  {
  	alert('��ѡ����ѵ��������!');
  	return;
  }
  if(Sat_Train_Add.Train_BTime.value > Sat_Train_Add.Train_ETime.value)
  {
  	alert('��ʼ�������ڽ�������֮ǰ!');
  	return;
  }
  if(Sat_Train_Add.Train_Type.value.length < 1)
  {
  	alert('��ѡ����ѵ����!');
  	return;
  }
 	if(Sat_Train_Add.Train_Title.value.Trim().length < 1)
	{
		alert('��������ѵ����!');
		return;
	}
  if(Sat_Train_Add.Train_Corp.value.Trim().length < 1)
	{
		alert('��������ѵ��λ!');
		return;
	}
  if(Sat_Train_Add.Train_Object.value.Trim().length < 1)
	{
		alert('��������ѵ����!');
		return;
	}
  if(Sat_Train_Add.Train_Cnt.value.Trim().length < 1 || Sat_Train_Add.Train_Cnt.value <= 0)
  {
  	alert("��ѵ�����������,���ܵ�ԭ��\n\n  1.Ϊ�ա�\n\n  2.������ֵ��");
		return;
  }
  for(var i=0; i<Sat_Train_Add.Train_Cnt.value.length; i++)
	{
		if(isNaN(Sat_Train_Add.Train_Cnt.value.charAt(i)))
	  {
	    alert("��ѵ����������������������!");
	    return;
	  }
	}
  if(Sat_Train_Add.Train_Hour.value.Trim().length < 1 || Sat_Train_Add.Train_Hour.value <= 0)
  {
  	alert("��ѵ��ʱ�������,���ܵ�ԭ��\n\n  1.Ϊ�ա�\n\n  2.������ֵ��");
		return;
  }
	for(var i=0; i<Sat_Train_Add.Train_Hour.value.length; i++)
	{
		if(isNaN(Sat_Train_Add.Train_Hour.value.charAt(i)))
	  {
	    alert("������ѵ��ʱ��������������!");
	    return;
	  }
	}
  if(confirm("��Ϣ����,ȷ���ύ?"))
  {
  	if(window.XMLHttpRequest)
	  {
			reqAdd = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			reqAdd = new ActiveXObject("Microsoft.XMLHTTP");
		}		
		//���ûص�����
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
						alert('�ɹ�');
						Sat_Train_Add.Train_Title.value  = '';
						Sat_Train_Add.Train_Corp.value   = '';
						Sat_Train_Add.Train_Object.value = '';
						Sat_Train_Add.Train_Cnt.value    = '';
						Sat_Train_Add.Train_Hour.value   = '';
						return;
					}
					else
					{
						alert('ʧ�ܣ������²���');
						return;
					}
				}
				else
				{
					alert("ʧ�ܣ������²���");
					return;
				}
			}
		};
		var url = 'Sat_Train_Add.do?Cmd=10&Sid=<%=Sid%>&Train_BTime='+Sat_Train_Add.Train_BTime.value+'&Train_ETime='+Sat_Train_Add.Train_ETime.value+'&Train_Dept='+Sat_Train_Add.Train_Dept.value+'&Train_Type='+Sat_Train_Add.Train_Type.value+'&Train_Title='+Sat_Train_Add.Train_Title.value.Trim()+'&Train_Corp='+Sat_Train_Add.Train_Corp.value.Trim()+'&Train_Object='+Sat_Train_Add.Train_Object.value.Trim()+'&Train_Cnt='+Sat_Train_Add.Train_Cnt.value.Trim()+'&Train_Hour='+Sat_Train_Add.Train_Hour.value.Trim()+'&Train_Assess='+Sat_Train_Add.Train_Assess.value+'&Operator=<%=Operator%>&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>&currtime='+new Date();
		reqAdd.open("post",url,true);
		reqAdd.send(null);
		return true;
  }
}
</SCRIPT>
</html>