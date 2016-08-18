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
<link type='text/css' href='../skin/css/style.css' rel='stylesheet'/>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/util.js'    charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/My97DatePicker/WdatePicker.js'></script>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>

</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	String ManageId = UserInfo.getManage_Role();
	String FpId   = UserInfo.getFp_Role();
	String FpList = "";
	if(null != FpId && FpId.length() > 0 && null != User_FP_Role)
	{
		Iterator roleiter = User_FP_Role.iterator();
		while(roleiter.hasNext())
		{
			UserRoleBean roleBean = (UserRoleBean)roleiter.next();
			if(roleBean.getId().equals(FpId) && null != roleBean.getPoint())
			{
				FpList = roleBean.getPoint();
			}
		}
	}
	
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  String BDate = currStatus.getVecDate().get(0).toString().substring(0,10);
	String EDate = currStatus.getVecDate().get(1).toString().substring(0,10);
	
	ArrayList Sat_Danger_Type  = (ArrayList)session.getAttribute("Sat_Danger_Type_" + Sid);
	ArrayList Sat_Danger_Level = (ArrayList)session.getAttribute("Sat_Danger_Level_" + Sid);
	ArrayList User_User_Info   = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
  ArrayList Sat_Danger       = (ArrayList)session.getAttribute("Sat_Danger_" + Sid);
  int sn = 0;
  
%>
<body style=" background:#CADFFF">
<form name="Sat_Danger"  action="Sat_Danger.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<!--<tr height='25px' class='sjtop'>
			<td width='75%' align='left'>
				����վ��:
				<select  name='Func_Cpm_Id' style='width:100px;height:20px' onChange="doSelect()" >					
						<%
								String Manage_List = "";
								if(ManageId.length() > 0 && null != User_Manage_Role)
								{
									Iterator iterator = User_Manage_Role.iterator();
									while(iterator.hasNext())
									{
										UserRoleBean statBean = (UserRoleBean)iterator.next();
										if(statBean.getId().substring(0,4).equals(ManageId) && statBean.getId().length() == 8)
										{
											String R_Point = statBean.getPoint();
											if(null == R_Point){R_Point = "";}
											Manage_List += R_Point;
										}
									}
								}
								
								if(Manage_List.length() > 0 && null != User_Device_Detail)
								{
									Iterator iterator = User_Device_Detail.iterator();
									while(iterator.hasNext())
									{
										DeviceDetailBean statBean = (DeviceDetailBean)iterator.next();
										if(Manage_List.contains(statBean.getId()))
										{
								%>
											<option value='<%=statBean.getId()%>' <%=currStatus.getFunc_Cpm_Id().equals(statBean.getId())?"selected":""%>><%=statBean.getBrief()%></option>
								<%
										}
									}
								}
								%>
				</select>
				��������:
				<select name='Func_Corp_Id' style='width:100px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>ȫ��</option>
					<%
					if(null != Sat_Danger_Type)
					{
						Iterator typeiter = Sat_Danger_Type.iterator();
						while(typeiter.hasNext())
						{
							AqscDangerTypeBean typeBean = (AqscDangerTypeBean)typeiter.next();
					%>
							<option value='<%=typeBean.getId()%>' <%=currStatus.getFunc_Corp_Id().equals(typeBean.getId())?"selected":""%>><%=typeBean.getCName()%></option>
					<%
						}
					}
					%>
				</select>
				��������:
				<select name='Func_Type_Id' style='width:80px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Type_Id().equals("9999")?"selected":""%>>ȫ��</option>
					<%
					if(null != Sat_Danger_Level)
					{
						Iterator typeiter = Sat_Danger_Level.iterator();
						while(typeiter.hasNext())
						{
							AqscDangerLevelBean levelBean = (AqscDangerLevelBean)typeiter.next();
					%>
							<option value='<%=levelBean.getId()%>' <%=currStatus.getFunc_Type_Id().equals(levelBean.getId())?"selected":""%>><%=levelBean.getCName()%></option>
					<%
						}
					}
					%>
				</select>
				��¼״̬:
				<select name='Func_Sub_Id' style='width:80px;height:20px' onChange="doSelect()">
					<option value='9' <%=currStatus.getFunc_Sub_Id() == 9 ? "selected":""%>>ȫ��</option>
					<option value='0' <%=currStatus.getFunc_Sub_Id() == 0 ? "selected":""%>>������</option>
					<option value='1' <%=currStatus.getFunc_Sub_Id() == 1 ? "selected":""%>>�ѹر�</option>
				</select>
				<input id='BDate' name='BDate' type='text' style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				-
				<input id='EDate' name='EDate' type='text' style='width:90px;height:18px;' value='<%=EDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
			</td>
			<td width='25%' align='right'>
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' >
				<!--<img id="img3" src="../skin/images/mini_button_add.gif"    onClick='doAdd()'    style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='090203' ctype='1'/>">
			</td>
		</tr> -->
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25' valign='middle'>
						<td width='5%'  align='center' class="table_deep_blue">���</td>
						<td width='20%' align='center' class="table_deep_blue">����������Ϣ</td>
						<td width='20%' align='center' class="table_deep_blue">ȷ������</td>
						<td width='20%' align='center' class="table_deep_blue">ʵʩ����</td>
						<td width='20%' align='center' class="table_deep_blue">�������</td>
					</tr>
					<%
					if(Sat_Danger != null)
					{
						Iterator iterator = Sat_Danger.iterator();
						while(iterator.hasNext())
						{
							SatDangerBean Bean = (SatDangerBean)iterator.next();
							
							//����������Ϣ
							String SN = Bean.getSN();
							String Danger_Type_Name = Bean.getDanger_Type_Name();
							String Danger_Level_Name = Bean.getDanger_Level_Name();
							String Danger_Des = Bean.getDanger_Des();
							String Cpm_Name = Bean.getCpm_Name();
							String Danger_BTime = Bean.getDanger_BTime();
							String Danger_ETime = Bean.getDanger_ETime();
							String Operator_Name = Bean.getOperator_Name();
							String Desc_1 = "<font color=green>��������: </font>" + Danger_Type_Name
														+ "<br>"
							              + "<font color=green>��������: </font>" + Danger_Level_Name
							              + "<br>"
							              + "<font color=green>��������: </font>" + Danger_Des
							              + "<br>"
							              + "<font color=green>���β���: </font>" + Cpm_Name
							              + "<br>"
							              + "<font color=green>��������: </font>" + Danger_BTime
							              + "<br>"
							              + "<font color=green>��������: </font>" + Danger_ETime
							              + "<br>"
							              + "<font color=green>¼����Ա: </font>" + Operator_Name;
							              
							//ȷ������
							String Danger_Plan = Bean.getDanger_Plan();
							String Danger_Plan_Des = Bean.getDanger_Plan_Des();
							String Danger_Plan_OP = Bean.getDanger_Plan_OP();
							if(null == Danger_Plan){Danger_Plan = "";}
							if(null == Danger_Plan_Des){Danger_Plan_Des = "";}
							if(null == Danger_Plan_OP){Danger_Plan_OP = "";}
							
							//ʵʩ����
							String Danger_Act = Bean.getDanger_Act();
							String Danger_Act_Des = Bean.getDanger_Act_Des();
							String Danger_Act_OP = Bean.getDanger_Act_OP();
							if(null == Danger_Act){Danger_Act = "";}
							if(null == Danger_Act_Des){Danger_Act_Des = "";}
							if(null == Danger_Act_OP){Danger_Act_OP = "";}
											
							//�������
							String Danger_Check = Bean.getDanger_Check();
							String Danger_Check_OP = Bean.getDanger_Check_OP();
							String Status = Bean.getStatus();
							String str_Status = "";
							if(null == Danger_Check){Danger_Check = "";}
							if(null == Danger_Check_OP){Danger_Check_OP = "";}							
							switch(Integer.parseInt(Status))
							{
								case 0:
										str_Status = "������";
									break;
								case 1:
										str_Status = "�ѹر�";
									break;
							}
							
							//¼����Ա
							String Danger_Plan_OP_Name = "";
							String Danger_Act_OP_Name = "";
							String Danger_Check_OP_Name = "";
							if(User_User_Info != null)
							{
								for(int i=0; i<User_User_Info.size(); i++)
								{
									UserInfoBean Info = (UserInfoBean)User_User_Info.get(i);
									if(Info.getId().equals(Danger_Plan_OP))
										Danger_Plan_OP_Name = Info.getCName();
									if(Info.getId().equals(Danger_Act_OP))
										Danger_Act_OP_Name = Info.getCName();
									if(Info.getId().equals(Danger_Check_OP))
										Danger_Check_OP_Name = Info.getCName();
								}
							}
							
							String Desc_2 = "";
							String Desc_3 = "";
							String Desc_4 = "";
							if(Danger_Plan_OP.trim().length() > 0)
							{
								String str_Danger_Plan = "��δ�ϴ��ĵ�!";
								if(Danger_Plan.length() > 0)
								{
									str_Danger_Plan = "<a href='../files/upfiles/"+ Danger_Plan +"' title='�������'>"+ Danger_Plan +"</a>";
								}
								Desc_2 = "<font color=green>ȷ������: </font>��ȷ��"
								       + "<br>"
								       + "<font color=green>��Ҫ����: </font>" + Danger_Plan_Des
								       + "<br>"
								       + "<font color=green>�����ĵ�: </font>" + str_Danger_Plan
								       + "<br>"
								       + "<font color=green>¼����Ա: </font>" + Danger_Plan_OP_Name;
							}
							else
							{
								String str_Danger_Plan = "��δ�ϴ��ĵ�!";
								if(Danger_Plan.length() > 0)
								{
									str_Danger_Plan = "<a href='../files/upfiles/"+ Danger_Plan +"' title='�������'>"+ Danger_Plan +"</a>";
								}
								Desc_2 = "<font color=red>ȷ������: </font>δȷ��"
								       + "<br>"
								       + "<font color=red>��Ҫ����: </font>" + Danger_Plan_Des
								       + "<br>"
								       + "<font color=red>�����ĵ�: </font>" + str_Danger_Plan
								       + "<br>"
								       + "<font color=red>¼����Ա: </font>" + Danger_Plan_OP_Name;
							}
							
							if(Danger_Act_OP.trim().length() > 0)
							{
								String str_Danger_Act = "��δ�ϴ��ĵ�!";
								if(Danger_Act.length() > 0)
								{
									str_Danger_Act = "<a href='../files/upfiles/"+ Danger_Act +"' title='�������'>"+ Danger_Act +"</a>";
								}
								Desc_3 = "<font color=green>ʵʩ����: </font>��ʵʩ"
								       + "<br>"
								       + "<font color=green>��Ҫ����: </font>" + Danger_Act_Des
								       + "<br>"
								       + "<font color=green>�����ĵ�: </font>" + str_Danger_Act
								       + "<br>"
								       + "<font color=green>¼����Ա: </font>" + Danger_Act_OP_Name;
							}
							else
							{
								String str_Danger_Act = "��δ�ϴ��ĵ�!";
								if(Danger_Act.length() > 0)
								{
									str_Danger_Act = "<a href='../files/upfiles/"+ Danger_Act +"' title='�������'>"+ Danger_Act +"</a>";
								}
								Desc_3 = "<font color=red>ʵʩ����: </font>δʵʩ"
								       + "<br>"
								       + "<font color=red>��Ҫ����: </font>" + Danger_Act_Des
								       + "<br>"
								       + "<font color=red>�����ĵ�: </font>" + str_Danger_Act
								       + "<br>"
								       + "<font color=red>¼����Ա: </font>" + Danger_Act_OP_Name;
							}
							
							if(Danger_Check_OP.trim().length() > 0)
							{
								Desc_4 = "<font color=green>�������: </font>�����"
								       + "<br>"
								       + "<font color=green>��Ҫ����: </font>" + Danger_Check
								       + "<br>"
								       + "<font color=green>״̬����: </font>" + str_Status
								       + "<br>"
								       + "<font color=green>¼����Ա: </font>" + Danger_Check_OP_Name;
							}
							else
							{
								Desc_4 = "<font color=red>�������: </font>δ���"
								       + "<br>"
								       + "<font color=red>��Ҫ����: </font>" + Danger_Check
								       + "<br>"
								       + "<font color=red>״̬����: </font>" + str_Status
								       + "<br>"
								       + "<font color=red>¼����Ա: </font>" + Danger_Check_OP_Name;
							}
							
							sn++;
					%>
						  <tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>						  
								<td align=center><%=sn%></td>
								<td align=left valign=top style='cursor:hand;' title='�༭����������Ϣ' onclick="doEdit01('<%=SN%>', '<%=Status%>', '<%=Danger_Plan_OP%>')"><%=Desc_1%></td>
						    <td align=left valign=top style='cursor:hand;' title='�༭ȷ������'     onclick="doEdit02('<%=SN%>', '<%=Status%>', '<%=Danger_Act_OP%>')"><%=Desc_2%></td>
						    <td align=left valign=top style='cursor:hand;' title='�༭ʵʩ����'     onclick="doEdit03('<%=SN%>', '<%=Status%>', '<%=Danger_Check_OP%>', '<%=Danger_Plan_OP%>')"><%=Desc_3%></td>
						    <td align=left valign=top style='cursor:hand;' title='�༭�������'     onclick="doEdit04('<%=SN%>', '<%=Status%>', '<%=Danger_Plan_OP%>', '<%=Danger_Act_OP%>')"><%=Desc_4%></td>
							</tr>
					<%
						}
					}
					/**for(int i=0;i<(MsgBean.CONST_PAGE_SIZE - sn);i++)
					{
						if(sn % 2 != 0)
					  {
					%>   				  
				      <tr <%=((i%2)==0?"class='table_blue'":"class='table_white_l'")%>>
				      	<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
				      </tr>  
					<%
						}
					  else
					  {
					%>				
		          <tr <%=((i%2)==0?"class='table_white_l'":"class='table_blue'")%>>
			          <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
			        </tr>      
					<%
       			}
     			}**/
					%> 
     		 <!--	<tr>
						<td colspan="5" class="table_deep_blue" >
				 			<table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0" >
			    			<tr valign="bottom">
			      			<td nowrap><%=currStatus.GetPageHtml("Sat_Danger")%></td>
			    			</tr>			    		
							</table>
						</td>
					</tr>-->
					
				</table>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="Cmd"    value="0">
<input type="hidden" name="Sid"    value="<%=Sid%>">
<input type="hidden" name="Cpm_Id" value="">
<input type="hidden" name="BTime"  value="">
<input type="hidden" name="ETime"  value="">
<input type="hidden" name="CurrPage" value="<%=currStatus.getCurrPage()%>">
<input type="button" id="CurrButton" onClick="doSelect()" style="display:none">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
if(<%=currStatus.getResult().length()%> > 0)
   alert("<%=currStatus.getResult()%>");
<%
currStatus.setResult("");
session.setAttribute("CurrStatus_" + Sid, currStatus);
%>

//ipad��������
if(1 == fBrowserRedirect() || 2 == fBrowserRedirect())
{
	document.getElementById('img2').style.display = 'none';
}

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Sat_Danger.jsp';
/**
switch(parseInt(<%=currStatus.getFunc_Sub_Id()%>))
{
	case 0:
			document.getElementById('BDate').style.display = 'none';
			document.getElementById('EDate').style.display = 'none';
		break;
	case 1:
	case 9:
			document.getElementById('BDate').style.display = '';
			document.getElementById('EDate').style.display = '';
		break;
}
**/
function doSelect()
{
	/**var days = new Date(Sat_Danger.EDate.value.replace(/-/g, "/")).getTime() - new Date(Sat_Danger.BDate.value.replace(/-/g, "/")).getTime();
	var dcnt = parseInt(days/(1000*60*60*24));
	if(dcnt < 0)
	{
		alert('��ֹ��������ڿ�ʼ����');
		return;
	}
	if((dcnt + 1) > 31)
	{
		alert('���ڿ�Խ������31��');
		return;
	}
	**/
	Sat_Danger.Cpm_Id.value = Sat_Danger.Func_Cpm_Id.value;
	Sat_Danger.BTime.value = Sat_Danger.BDate.value;
	Sat_Danger.ETime.value = Sat_Danger.EDate.value;
	Sat_Danger.submit();
}

function GoPage(pPage)
{
	/**var days = new Date(Sat_Danger.EDate.value.replace(/-/g, "/")).getTime() - new Date(Sat_Danger.BDate.value.replace(/-/g, "/")).getTime();
	var dcnt = parseInt(days/(1000*60*60*24));
	if(dcnt < 0)
	{
		alert('��ֹ��������ڿ�ʼ����');
		return;
	}
	if((dcnt + 1) > 31)
	{
		alert('���ڿ�Խ������31��');
		return;
	}
	**/
	if(pPage == "")
	{
		 alert("������Ŀ��ҳ�����ֵ!");
		 return;
	}
	if(pPage < 1)
	{
	   	alert("������ҳ������1");
		  return;	
	}
	if(pPage > <%=currStatus.getTotalPages()%>)
	{
		pPage = <%=currStatus.getTotalPages()%>;
	}
	Sat_Danger.Cpm_Id.value = Sat_Danger.Func_Cpm_Id.value;
	Sat_Danger.BTime.value = Sat_Danger.BDate.value;
	Sat_Danger.ETime.value = Sat_Danger.EDate.value;
	Sat_Danger.CurrPage.value = pPage;
	Sat_Danger.submit();
}

var req = null;
/**function doExport()
{
	var days = new Date(Sat_Danger.EDate.value.replace(/-/g, "/")).getTime() - new Date(Sat_Danger.BDate.value.replace(/-/g, "/")).getTime();
	var dcnt = parseInt(days/(1000*60*60*24));
	if(dcnt < 0)
	{
		alert('��ֹ��������ڿ�ʼ����');
		return;
	}
	if((dcnt + 1) > 31)
	{
		alert('���ڿ�Խ������31��');
		return;
	}
	
	if(0 == <%=sn%>)
	{
		alert('��ǰ�޼�¼!');
		return;
	}
	if(65000 <= <%=currStatus.getTotalRecord()%>)
	{
		alert('��¼���࣬���������!');
		return;
	}
	if(confirm("ȷ������?"))
  {
		if(window.XMLHttpRequest)
	  {
			req = new XMLHttpRequest();
		}
		else if(window.ActiveXObject)
		{
			req = new ActiveXObject("Microsoft.XMLHTTP");
		}
		//���ûص�����
		req.onreadystatechange = callbackForName;
		var url = "Sat_Danger_Export.do?Sid=<%=Sid%>&Cpm_Id="+Sat_Danger.Func_Cpm_Id.value+"&BTime="+Sat_Danger.BDate.value+"&ETime="+Sat_Danger.EDate.value+"&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Type_Id=<%=currStatus.getFunc_Type_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>";
		req.open("post",url,true);
		req.send(null);
		return true;
	}
}

function callbackForName()
{
	var state = req.readyState;
	if(state==4)
	{
		var resp = req.responseText;
		var str = "";
		if(resp != null)
		{
			location.href = "../files/excel/" + resp + ".xls";
		}
	}
}

function doAdd()
{
	location = "Sat_Danger_Add.jsp?Sid=<%=Sid%>";
}**/

//�޸�����������Ϣ
function doEdit01(pSN, pStatus, pDanger_Plan_OP)
{
	/**if('<Limit:limitValidate userrole='<%=FpList%>' fpid='0708' ctype='1'/>' == 'none')
	{
		alert('����Ȩ���޸�����������Ϣ!');
		return;
	}
	**/
	if('1' == pStatus)
	{
		alert('��ǰ���������ѹر�!');
		return;
	}
	if(pDanger_Plan_OP.Trim().length > 0)
	{
		alert('��Ե�ǰ����������ȷ�������ķ������������ٴ��޸�����������Ϣ!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 350;
	diag.Title = "����������Ϣ�༭";
	diag.URL = 'Sat_Danger_Edit.jsp?Sid=<%=Sid%>&CType=1&SN='+pSN;
	diag.show();
}

//�޸�ȷ������
function doEdit02(pSN, pStatus, pDanger_Act_OP)
{
	/**if('<Limit:limitValidate userrole='<%=FpList%>' fpid='0710' ctype='1'/>' == 'none')
	{
		alert('����Ȩ���޸�����ȷ������!');
		return;
	}**/
	if('1' == pStatus)
	{
		alert('��ǰ���������ѹر�!');
		return;
	}
	if(pDanger_Act_OP.Trim().length > 0)
	{
		alert('��Ե�ǰ����ȷ�������ķ�����ʵʩ���������ٴ��޸ķ���!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 350;
	diag.Title = "ȷ�������༭";
	diag.URL = 'Sat_Danger_Edit.jsp?Sid=<%=Sid%>&CType=2&SN='+pSN;
	diag.show();
}

//�޸�ʵʩ����
function doEdit03(pSN, pStatus, pDanger_Check_OP, pDanger_Plan_OP)
{
	/**if('<Limit:limitValidate userrole='<%=FpList%>' fpid='0712' ctype='1'/>' == 'none')
	{
		alert('����Ȩ���޸�����ʵʩ����!');
		return;
	}**/
	if('1' == pStatus)
	{
		alert('��ǰ���������ѹر�!');
		return;
	}
	if(pDanger_Check_OP.Trim().length > 0)
	{
		alert('��ǰ����������������գ��������ٴ��޸�ʵʩ���Ĵ�ʩ!');
		return;
	}
	if(pDanger_Plan_OP.Trim().length < 1)
	{
		alert('��ǰ�����������ķ�����δȷ��!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 350;
	diag.Title = "ʵʩ���ı༭";
	diag.URL = 'Sat_Danger_Edit.jsp?Sid=<%=Sid%>&CType=3&SN='+pSN;
	diag.show();
}

//�޸��������
function doEdit04(pSN, pStatus, pDanger_Plan_OP, pDanger_Act_OP)
{
	/**if('<Limit:limitValidate userrole='<%=FpList%>' fpid='0714' ctype='1'/>' == 'none')
	{
		alert('����Ȩ���޸������������!');
		return;
	}**/
	if('1' == pStatus)
	{
		alert('��ǰ���������ѹر�!');
		return;
	}
	if(pDanger_Plan_OP.Trim().length < 1)
	{
		alert('��ǰ�����������ķ�����δȷ��!');
		return;
	}
	if(pDanger_Act_OP.Trim().length < 1)
	{
		alert('��ǰ�����������ķ�����δʵʩ!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 350;
	diag.Title = "������ձ༭";
	diag.URL = 'Sat_Danger_Edit.jsp?Sid=<%=Sid%>&CType=4&SN='+pSN;
	diag.show();
}



</SCRIPT>
</html>