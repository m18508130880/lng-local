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
<script type='text/javascript' src='../skin/js/util.js'></script>
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo  = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	String FpId = UserInfo.getFp_Role();
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
	
	ArrayList User_User_Info = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
	ArrayList Dev_List_Breed = (ArrayList)session.getAttribute("Dev_List_Breed_" + Sid);
	ArrayList Dev_List       = (ArrayList)session.getAttribute("Dev_List_" + Sid);
  ArrayList Fix_Trace      = (ArrayList)session.getAttribute("Fix_Trace_" + Sid);
  ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	String ManageId = UserInfo.getManage_Role();
  
  int sn = 0; 
  
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
%>
<body style="background:#CADFFF">
<form name="Fix_Trace"  action="Fix_Trace.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop' style="display:none">
			<td width='70%' align='left'>
				����վ��:
				<select  name='Func_Cpm_Id' style='width:100px;height:20px' onChange="doSelect()" >			
						<option value='<%=Manage_List%>' <%=currStatus.getFunc_Cpm_Id().equals(Manage_List)?"selected":""%>>ȫ��վ��</option>	
						<%
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
				�豸Ʒ��:
				<select name='Func_Corp_Id' style='width:120px;height:20px;' onchange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>ȫ��</option>
					<%
					if(null != Dev_List_Breed)
					{
						Iterator breediter = Dev_List_Breed.iterator();
						while(breediter.hasNext())
						{
							AqscDeviceBreedBean breedBean = (AqscDeviceBreedBean)breediter.next();
					%>
							<option value='<%=breedBean.getId()%>' <%=currStatus.getFunc_Corp_Id().equals(breedBean.getId())?"selected":""%>><%=breedBean.getCName()%></option>
					<%
						}
					}
					%>
				</select>
				��¼״̬:
				<select name='Func_Sub_Id' style='width:70px;height:20px' onChange="doSelect()">
					<option value='9' <%=currStatus.getFunc_Sub_Id() == 9 ? "selected":""%>>ȫ��</option>
					<option value='0' <%=currStatus.getFunc_Sub_Id() == 0 ? "selected":""%>>ά����</option>
					<option value='1' <%=currStatus.getFunc_Sub_Id() == 1 ? "selected":""%>>�ѹر�</option>
				</select>
				<input id='BDate' name='BDate' type='text' style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				-
				<input id='EDate' name='EDate' type='text' style='width:90px;height:18px;' value='<%=EDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
			</td>
			<td width='30%' align='right'>
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='160103' ctype='1'/>">
				<!--<img id="img3" src="../skin/images/mini_button_add.gif"    onClick='doAdd()' >-->
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25' valign='middle'>
						<td width='4%'  align='center' class="table_deep_blue">���</td>
						<td width='10%' align='center' class="table_deep_blue">���볡վ</td>
						<td width='10%' align='center' class="table_deep_blue">��������</td>
						<td width='19%' align='center' class="table_deep_blue">������Ϣ</td>
						<td width='19%' align='center' class="table_deep_blue">ά����Ϣ</td>
						<td width='19%' align='center' class="table_deep_blue">������Ϣ</td>
						<td width='19%' align='center' class="table_deep_blue">������Ϣ</td>
					</tr>
					<%
					if(Fix_Trace != null)
					{
						Iterator iterator = Fix_Trace.iterator();
						while(iterator.hasNext())
						{
							FixTraceBean Bean = (FixTraceBean)iterator.next();
							String SN         = Bean.getSN();
							String Cpm_Name   = Bean.getCpm_Name();
							String Apply_Time = Bean.getApply_Time();
							
							//������Ϣ
							String Dev_Name      = Bean.getDev_Name();
							String Apply_Des     = Bean.getApply_Des();
							String Apply_Man     = Bean.getApply_Man();
							String Apply_Pre     = Bean.getApply_Pre();
							String Apply_OP_Name = Bean.getApply_OP_Name();
							if(Apply_Des.length() > 10){Apply_Des = Apply_Des.substring(0,10) + "...";}
							if(Apply_Pre.length() > 10){Apply_Pre = Apply_Pre.substring(0,10) + "...";}
							String str_Des1 = "�����豸: " + Dev_Name
															+ "<br>"
															+ "��������: " + Apply_Des
								              + "<br>"
								              + "Ӧ����ʩ: " + Apply_Pre
								              + "<br>"
								              + "������Ա: " + Apply_Man
								              + "<br>"
								              + "¼����Ա: " + Apply_OP_Name;
								              
							//ά����Ϣ
							String Fix_Plan      = Bean.getFix_Plan();
							String Fix_Plan_File = Bean.getFix_Plan_File();
							String Fix_Corp      = Bean.getFix_Corp();
							String Fix_Des       = Bean.getFix_Des();
							String Fix_BTime     = Bean.getFix_BTime();
							String Fix_ETime     = Bean.getFix_ETime();
							String Fix_OP        = Bean.getFix_OP();
							if(null == Fix_Plan){Fix_Plan = "";}
							if(null == Fix_Plan_File){Fix_Plan_File = "";}
							if(null == Fix_Corp){Fix_Corp = "";}
							if(null == Fix_Des){Fix_Des = "";}
							if(null == Fix_BTime){Fix_BTime = "";}
							if(null == Fix_ETime){Fix_ETime = "";}
							if(null == Fix_OP){Fix_OP = "";}
							if(Fix_Plan.length() > 10){Fix_Plan = Fix_Plan.substring(0,10) + "...";}
							
							//������Ϣ
							String Rate_Des = Bean.getRate_Des();
							String Rate_OP  = Bean.getRate_OP();
							if(null == Rate_Des){Rate_Des = "";}
							if(null == Rate_OP){Rate_OP = "";}
							String Rate_str = "";
							if(Rate_Des.length() > 0)
							{
								String[] List = Rate_Des.split("\\~");
								for(int i=0; i<List.length && List[i].length()>0; i++)
								{
									Rate_str += "<br>" + (i+1) + "��" + List[i].split("\\^")[2];
								}
							}
							
							//������Ϣ
							String Check_Corp = Bean.getCheck_Corp();
							String Check_Time = Bean.getCheck_Time();
							String Check_Man  = Bean.getCheck_Man();
							String Check_Des  = Bean.getCheck_Des();
							String Check_OP   = Bean.getCheck_OP();
							String Status     = Bean.getStatus();
							if(null == Check_Corp){Check_Corp = "";}
							if(null == Check_Time){Check_Time = "";}
							if(null == Check_Man){Check_Man = "";}
							if(null == Check_Des){Check_Des = "";}
							if(null == Check_OP){Check_OP = "";}
							if(Check_Des.length() > 10){Check_Des = Check_Des.substring(0,10) + "...";}
						 	
						 	//¼����Ա
							String Fix_OP_Name   = "";
							String Rate_OP_Name  = "";
							String Check_OP_Name = "";
							if(User_User_Info != null)
							{
								for(int i=0; i<User_User_Info.size(); i++)
								{
									UserInfoBean Info = (UserInfoBean)User_User_Info.get(i);
									if(Info.getId().equals(Fix_OP))
										Fix_OP_Name   = Info.getCName();
									if(Info.getId().equals(Rate_OP))
										Rate_OP_Name  = Info.getCName();
									if(Info.getId().equals(Check_OP))
										Check_OP_Name = Info.getCName();
								}
							}
							
							String str_Fix_Plan_File = "��δ�ϴ��ĵ�!";
							if(Fix_Plan_File.length() > 0)
							{
								str_Fix_Plan_File = "<a href='../files/upfiles/"+ Fix_Plan_File +"' title='�������'>"+ Fix_Plan_File +"</a>";
							}
							String str_Fix_Des = "δ������Ʒ����!";
							if(Fix_Des.length() > 0)
							{
								str_Fix_Des = "�и�����Ʒ����!";
							}
							String str_Des2 = "ά�޴�ʩ: " + Fix_Plan
															+ "<br>"
								              + "ά���ĵ�: " + str_Fix_Plan_File
								              + "<br>"
								              + "��Ʒ�嵥: " + str_Fix_Des
								              + "<br>"
								              + "ά�޵�λ: " + Fix_Corp
								              + "<br>"
								              + "��������: " + Fix_BTime
								              + "<br>"
								              + "�깤����: " + Fix_ETime
								              + "<br>"
								              + "¼����Ա: " + Fix_OP_Name;
							
							String str_Des3 = "������Ϣ: " + Rate_str
															+ "<br>"
								              + "¼����Ա: " + Rate_OP_Name;
								              
							String str_Des4 = "";
							switch(Integer.parseInt(Status))
							{
								case 0:
										str_Des4 = "���յ�λ: " + Check_Corp
														 + "<br>"
								             + "��������: " + Check_Time
								             + "<br>"
								             + "������Ա: " + Check_Man
								             + "<br>"
								             + "�������: " + Check_Des
								             + "<br>"
								             + "״̬����: <font color=red>ά����</font>"
								             + "<br>"
								             + "¼����Ա: " + Check_OP_Name;
									break;
								case 1:
										str_Des4 = "���յ�λ: " + Check_Corp
														 + "<br>"
								             + "��������: " + Check_Time
								             + "<br>"
								             + "������Ա: " + Check_Man
								             + "<br>"
								             + "�������: " + Check_Des
								             + "<br>"
								             + "״̬����: <font color=green>�ѹر�</font>"
								             + "<br>"
								             + "¼����Ա: " + Check_OP_Name;
									break;
							}
							
							sn++;
					%>
						  <tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
								<td align=center><%=sn%></td>
								<td align=center><%=Cpm_Name%></td>
								<td align=center><%=Apply_Time%></td>
						    <td align=left valign=top style='cursor:hand;' title='�༭������Ϣ' onclick="doEdit01('<%=SN%>')"><%=str_Des1%></td>
						    <td align=left valign=top style='cursor:hand;' title='�༭ά����Ϣ' onclick="doEdit02('<%=SN%>')"><%=str_Des2%></td>
						    <td align=left valign=top style='cursor:hand;' title='�༭������Ϣ' onclick="doEdit03('<%=SN%>')"><%=str_Des3%></td>
						    <td align=left valign=top style='cursor:hand;' title='�༭������Ϣ' onclick="doEdit04('<%=SN%>')"><%=str_Des4%></td>
							</tr>
					<%				
						}
					}
					for(int i=0;i<(MsgBean.CONST_PAGE_SIZE - sn);i++)
					{
						if(sn % 2 != 0)
					  {
					%>   				  
				      <tr <%=((i%2)==0?"class='table_blue'":"class='table_white_l'")%>>
				      	<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
				      </tr>  
					<%
						}
					  else
					  {
					%>				
		          <tr <%=((i%2)==0?"class='table_white_l'":"class='table_blue'")%>>
			          <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
			        </tr>      
					<%
       			}
     			}
					%>
     		 	<tr>
						<td colspan="7" class="table_deep_blue">
				 			<table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0">
			    			<tr valign="bottom">
			      			<td nowrap><%=currStatus.GetPageHtml("Fix_Trace")%></td>
			    			</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="Cmd"      value="0">
<input type="hidden" name="Sid"      value="<%=Sid%>">
<input type="hidden" name="Cpm_Id"   value="">
<input type="hidden" name="BTime"    value="">
<input type="hidden" name="ETime"    value="">
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

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Fix_Trace.jsp';

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

function doSelect()
{
	/**var days = new Date(Fix_Trace.EDate.value.replace(/-/g, "/")).getTime() - new Date(Fix_Trace.BDate.value.replace(/-/g, "/")).getTime();
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
	Fix_Trace.Cpm_Id.value = Fix_Trace.Func_Cpm_Id.value;
	Fix_Trace.BTime.value = Fix_Trace.BDate.value;
	Fix_Trace.ETime.value = Fix_Trace.EDate.value;
	Fix_Trace.submit();
}

function GoPage(pPage)
{
	var days = new Date(Fix_Trace.EDate.value.replace(/-/g, "/")).getTime() - new Date(Fix_Trace.BDate.value.replace(/-/g, "/")).getTime();
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
	Fix_Trace.Cpm_Id.value = Fix_Trace.Func_Cpm_Id.value;
	Fix_Trace.BTime.value = Fix_Trace.BDate.value;
	Fix_Trace.ETime.value = Fix_Trace.EDate.value;
	Fix_Trace.CurrPage.value = pPage;
	Fix_Trace.submit();
}

//���������Ϣ
function doAdd()
{
	location = "Fix_Trace_Add.jsp?Sid=<%=Sid%>";
}

//�༭������Ϣ
function doEdit01(pSN)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='160104' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�༭������Ϣ!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 272;
	diag.Title = "������Ϣ�༭";
	diag.URL = 'Fix_Trace_Edit.jsp?Sid=<%=Sid%>&CType=1&SN='+pSN;
	diag.show();
}

//�༭ά����Ϣ
function doEdit02(pSN)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='160105' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�༭ά����Ϣ!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 372;
	diag.Title = "ά����Ϣ�༭";
	diag.URL = 'Fix_Trace_Edit.jsp?Sid=<%=Sid%>&CType=2&SN='+pSN;
	diag.show();
}

//�༭������Ϣ
function doEdit03(pSN)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='160106' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�༭������Ϣ!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 278;
	diag.Title = "ά����Ϣ�༭";
	diag.URL = 'Fix_Trace_Edit.jsp?Sid=<%=Sid%>&CType=3&SN='+pSN;
	diag.show();
}

//�༭������Ϣ
function doEdit04(pSN)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='160107' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�༭������Ϣ!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 278;
	diag.Title = "ά����Ϣ�༭";
	diag.URL = 'Fix_Trace_Edit.jsp?Sid=<%=Sid%>&CType=4&SN='+pSN;
	diag.show();
}

/**var req = null;
function doExport()
{
	var days = new Date(Fix_Trace.EDate.value.replace(/-/g, "/")).getTime() - new Date(Fix_Trace.BDate.value.replace(/-/g, "/")).getTime();
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
		var url = "Fix_Trace_Export.do?Sid=<%=Sid%>&Cpm_Id="+Fix_Trace.Func_Cpm_Id.value+"&BTime="+Fix_Trace.BDate.value+"&ETime="+Fix_Trace.EDate.value+"&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>";
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
}**/
</SCRIPT>
</html>