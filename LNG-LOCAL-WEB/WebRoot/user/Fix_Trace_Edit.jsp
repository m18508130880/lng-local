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

<style type='text/css'>
html,body {height:100%; margin:0px; font-size:12px;}
.mydiv
{
	background-color: #e0e6ed;
	border: 1px solid #3491D6;
	text-align: center;
	line-height: 40px;
	font-size: 12px;
	font-weight: bold;
	z-index:999;
	width: 600px;
	height:372px;
	left:0%;
	top: 0%;
	position:fixed!important;
	position:absolute;
	_top:expression(eval(document.compatMode && document.compatMode=='CSS1Compat') ? documentElement.scrollTop + (document.documentElement.clientHeight-this.offsetHeight)/2 : document.body.scrollTop + (document.body.clientHeight - this.clientHeight)/2);
}
</style>
</head>
<%
	
	String Sid   = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String CType = CommUtil.StrToGB2312(request.getParameter("CType"));
	String SN    = CommUtil.StrToGB2312(request.getParameter("SN"));
	
	CurrStatus currStatus        = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	ArrayList Fix_Trace          = (ArrayList)session.getAttribute("Fix_Trace_" + Sid);
	ArrayList Spa_Store_All      = (ArrayList)session.getAttribute("Spa_Store_All_" + Sid);
	ArrayList Spa_Station_All    = (ArrayList)session.getAttribute("Spa_Station_All_" + Sid);
	ArrayList Dev_List           = (ArrayList)session.getAttribute("Dev_List_" + Sid);
	ArrayList User_FP_Role       = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
	ArrayList User_User_Info     = (ArrayList)session.getAttribute("User_User_Info_" + Sid);
  UserInfoBean UserInfo        = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator      = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  String ManageId      = UserInfo.getManage_Role();
  String FpId          = UserInfo.getFp_Role();
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
  
	String Cpm_Id        = "";
	String Cpm_Name      = "";
	String Dev_SN        = "";
	String Apply_Time    = "";
	String Apply_Des     = "";
	String Apply_Man     = "";
	String Apply_Pre     = "";
	String Apply_OP_Name = "";
	
	String Fix_Plan      = "";
	String Fix_Plan_File = "";
	String Fix_Corp      = "";
	String Fix_Des       = "";
	String Fix_BTime     = "";
	String Fix_ETime     = "";
	String Fix_OP        = "";
	
	String Rate_Des      = "";
	String Rate_OP       = "";
	
	String Check_Corp    = "";
	String Check_Time    = "";
	String Check_Des     = "";
	String Check_Man     = "";
	String Check_OP      = "";
	String Status        = "";
	if(Fix_Trace != null)
	{
		Iterator iterator = Fix_Trace.iterator();
		while(iterator.hasNext())
		{
			FixTraceBean Bean = (FixTraceBean)iterator.next();
			if(Bean.getSN().equals(SN))
			{
				Cpm_Id        = Bean.getCpm_Id();
				Cpm_Name      = Bean.getCpm_Name();
				Dev_SN        = Bean.getDev_SN();
				Apply_Time    = Bean.getApply_Time();
				Apply_Des     = Bean.getApply_Des();
				Apply_Man     = Bean.getApply_Man();
				Apply_Pre     = Bean.getApply_Pre();
				Apply_OP_Name = Bean.getApply_OP_Name();
				
				Fix_Plan      = Bean.getFix_Plan();
				Fix_Plan_File = Bean.getFix_Plan_File();
				Fix_Corp      = Bean.getFix_Corp();
				Fix_Des       = Bean.getFix_Des();
				Fix_BTime     = Bean.getFix_BTime();
				Fix_ETime     = Bean.getFix_ETime();
				Fix_OP        = Bean.getFix_OP();
				if(null == Fix_Plan){Fix_Plan = "";}
				if(null == Fix_Plan_File){Fix_Plan_File = "";}
				if(null == Fix_Corp){Fix_Corp = "";}
				if(null == Fix_Des){Fix_Des = "";}
				if(null == Fix_BTime){Fix_BTime = "";}
				if(null == Fix_ETime){Fix_ETime = "";}
				if(null == Fix_OP){Fix_OP = "";}
				
				Rate_Des      = Bean.getRate_Des();
				Rate_OP       = Bean.getRate_OP();
				if(null == Rate_Des){Rate_Des = "";}
				if(null == Rate_OP){Rate_OP = "";}
				
				Check_Corp    = Bean.getCheck_Corp();
				Check_Time    = Bean.getCheck_Time();
				Check_Des     = Bean.getCheck_Des();
				Check_Man     = Bean.getCheck_Man();
				Check_OP      = Bean.getCheck_OP();
				Status        = Bean.getStatus();
				if(null == Check_Corp){Check_Corp = "";}
				if(null == Check_Time){Check_Time = "";}
				if(null == Check_Man){Check_Man = "";}
				if(null == Check_Des){Check_Des = "";}
				if(null == Check_OP){Check_OP = "";}
				
				break;
			}
		}
	}
	
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
	
%>
<body style="background:#CADFFF">
<form name="Fix_Trace_Edit" action="Fix_Trace_File.do" method="post" target="mFrame" enctype="multipart/form-data">
	<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
	<%
	switch(Integer.parseInt(CType))
	{
		case 1:
	%>
				<tr height='30' class='table_blue'>
				  <td width='100%' align='center' colspan=4><B>������Ϣ(¼����Ա:<%=Apply_OP_Name%>)</B></td>
				</tr>
				<tr height='30'>
					<td width='20%' align='center'>���볡վ</td>
					<td width='30%' align='left'>							
						<select name="Cpm_Id" style="width:91%;height:20px" onchange="doChange(this.value)">
						<%
						String Role_List = "";
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
									Role_List += R_Point;
								}
							}
						}
						if(Role_List.length() > 0 && null != User_Device_Detail)
						{
							Iterator iterator = User_Device_Detail.iterator();
							while(iterator.hasNext())
							{
								DeviceDetailBean statBean = (DeviceDetailBean)iterator.next();
								if(Role_List.contains(statBean.getId()))
								{
						%>
									<option value='<%=statBean.getId()%>' <%=statBean.getId().equals(Cpm_Id)?"selected":""%>><%=statBean.getBrief()%></option>
						<%
								}
							}
						}
						%>
						</select>
					</td>
					<td width='20%' align='center'>�����豸</td>
					<td width='30%' align='left'>
						<select id="Dev_SN" name="Dev_SN" style="width:91%;height:20px">
						</select>
					</td>
				</tr>
				<tr height='30'>
					<td width='20%' align='center'>��������</td>
					<td width='30%' align='left'>
						<input name='Apply_Time' type='text' style='width:90%;height:18px;' value='<%=Apply_Time%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
					</td>
					<td width='20%' align='center'>������Ա</td>
					<td width='30%' align='left'>
						<input name='Apply_Man' type='text' style='width:90%;height:16px;' value='<%=Apply_Man%>' maxlength='10'>
					</td>
				</tr>
				<tr height='30'>
					<td width='20%' align='center'>��������</td>
					<td width='80%' align='left' colspan=3>
						<textarea name='Apply_Des' rows='4' cols='63' maxlength=128><%=Apply_Des%></textarea>
					</td>
				</tr>
				<tr height='30'>
					<td width='20%' align='center'>Ӧ����ʩ</td>
					<td width='80%' align='left' colspan=3>
						<textarea name='Apply_Pre' rows='4' cols='63' maxlength=128><%=Apply_Pre%></textarea>
					</td>
				</tr>
	<%
			break;
		case 2:
	%>
				<input type="hidden" name="Cpm_Id" value="<%=Cpm_Id%>">
				<tr height='30' class='table_blue'>
				  <td width='100%' align='center' colspan=4><B>ά����Ϣ(¼����Ա:<%=Fix_OP_Name%>)</B></td>
				</tr>
				<tr height='30'>
					<td width='20%' align='center'>ά�޴�ʩ</td>
					<td width='80%' align='left' colspan=3>
						<textarea name='Fix_Plan' rows='4' cols='63' maxlength=128><%=Fix_Plan%></textarea>
					</td>
				</tr>
				<tr height='30'>
					<td width='20%' align='center'>ԭ���ĵ�</td>
					<td width='80%' align='left' colspan=3>
						<%
						if(Fix_Plan_File.length() > 0)
						{
						%>
							<a href='../../files/upfiles/<%=Fix_Plan_File%>' title='�������'><%=Fix_Plan_File%></a>
						<%
						}
						else
						{
						%>
							��δ�ϴ��ĵ�!
						<%
						}
						%>
						<input type='hidden' name='Fix_Plan_File' value='<%=Fix_Plan_File%>'>
					</td>
				</tr>
				<tr height='30'>
					<td width='20%' align='center'>�ĵ��ϴ�</td>
					<td width='80%' align='left' colspan=3>
						<input name='file' type='file' style='width:97%;height:20px;' title='�ĵ��ϴ�'>
					</td>
				</tr>
				<tr height='100'>
					<td width='20%' align='center'>��Ʒ�嵥</td>
					<td width='80%' align='left' colspan=3 valign=top>
						<div style='width:100%;height:100px;overflow-x:no;overflow-y:auto;'>
							<input id='Fix_Des' name='Fix_Des' type='hidden' value='<%=Fix_Des%>'>
							<img src='../skin/images/device_cmdadd.png' style='cursor:hand;' title='��Ʒ���' onclick="doSpaAdd()">
							<%
							int i = 0;
							if(Fix_Des.length() > 0)
							{
								String[] List = Fix_Des.split(";");
								for(; i<List.length && List[i].length()>0; i++)
								{
									String[] subList = List[i].split(",");
									String Spa_Type = subList[0];
									String Spa_Mode = subList[1];
								/**	String Spa_From = subList[2];
									String Spa_Type_Name = "";
									String Spa_Mode_Name = "";
									String Spa_From_Name = "";
									if(Spa_From.equals("9999999999"))
									{
										if(null != Spa_Store_All)
										{
											Iterator storeiter = Spa_Store_All.iterator();
											while(storeiter.hasNext())
											{
												SpaStoreBean storeBean = (SpaStoreBean)storeiter.next();
												
													Spa_Type_Name = storeBean.getSpa_Type_Name();
													if(null != storeBean.getModel() && storeBean.getModel().length() > 0)
													{
														String[] modeList = storeBean.getModel().split(",");
														if(modeList.length >= Integer.parseInt(Spa_Mode))
															Spa_Mode_Name = modeList[Integer.parseInt(Spa_Mode)-1];
													}
													Spa_From_Name = "ά�޶ӿ��";
												}
												
											}
										}
									}
									else
									{
										if(null != Spa_Station_All)
										{
											Iterator stationiter = Spa_Station_All.iterator();
											while(stationiter.hasNext())
											{
												SpaStationBean stationBean = (SpaStationBean)stationiter.next();
												if(stationBean.getCpm_Id().equals(Spa_From) && stationBean.getSpa_Type().equals(Spa_Type) && stationBean.getSpa_Mode().equals(Spa_Mode))
												{
													Spa_Type_Name = stationBean.getSpa_Type_Name();
													if(null != stationBean.getModel() && stationBean.getModel().length() > 0)
													{
														String[] modeList = stationBean.getModel().split(",");
														if(modeList.length >= Integer.parseInt(Spa_Mode))
															Spa_Mode_Name = modeList[Integer.parseInt(Spa_Mode)-1];
													}
													Spa_From_Name = stationBean.getCpm_Name()+"����";
												}
											}
										}
									}
									**/
							%>
									<div id='ConD<%=i%>' style='display:'>
										<img src='../skin/images/cmddel.gif'    style='cursor:hand;' title='��Ʒɾ��' onclick="doSpaDel('<%=i%>')">
										<%=i+1%>��[<%=Spa_Type%>]  [<%=subList[2]%>] 
										<input type='hidden' id='ConDValue<%=i%>' name='ConDValue<%=i%>' value='<%=List[i]%>'>
									</div>
							<%
								}
							}
							for(int j=i; j<8; j++)
							{
							%>
								<div id='ConD<%=j%>' style='display:none'></div>
							<%
							}
							%>
						</div>
					</td>
				</tr>
				<tr height='30'>
					<td width='20%' align='center'>ά�޵�λ</td>
					<td width='80%' align='left' colspan=3>
						<input name='Fix_Corp' type='text' style='width:96%;height:16px;' value='<%=Fix_Corp%>' maxlength='32'>
					</td>
				</tr>
				<tr height='30'>
					<td width='20%' align='center'>��������</td>
					<td width='30%' align='left'>
						<input name='Fix_BTime' type='text' style='width:89%;height:18px;' value='<%=Fix_BTime%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
					</td>
					<td width='20%' align='center'>�깤����</td>
					<td width='30%' align='left'>
						<input name='Fix_ETime' type='text' style='width:89%;height:18px;' value='<%=Fix_ETime%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
					</td>
				</tr>
	<%
			break;
		case 3:
	%>
				<input type="hidden" name="Cpm_Id" value="<%=Cpm_Id%>">
				<tr height='30' class='table_blue'>
				  <td width='100%' align='center' colspan=4><B>������Ϣ(¼����Ա:<%=Rate_OP_Name%>)</B></td>
				</tr>
				<tr height='200'>
					<td width='20%' align='center'>������Ŀ</td>
					<td width='80%' align='left' colspan=3 valign=top>
						<div style='width:100%;height:200px;overflow-x:no;overflow-y:auto;'>
							<input id='Rate_Des' name='Rate_Des' type='hidden' value='<%=Rate_Des%>'>
							<img src='../skin/images/device_cmdadd.png' style='cursor:hand;' title='�������' onclick="doRateAdd()">
							<%
							int a = 0;
							if(Rate_Des.length() > 0)
							{
								String[] List = Rate_Des.split("\\~");
								for(; a<List.length && List[a].length()>0; a++)
								{
									String[] subList = List[a].split("\\^");
									String str_BTime = subList[0];
									String str_ETime = subList[1];
									String str_Memo  = subList[2];
							%>
									<div id='RatD<%=a%>' style='display:'>
										<img src='../skin/images/cmddel.gif'  style='cursor:hand;' title='����ɾ��' onclick="doRateDel('<%=a%>')">
										<%=a+1%>��[<%=str_BTime%> - <%=str_ETime%>] [<%=str_Memo%>]
										<input type='hidden' id='RatDValue<%=a%>' name='RatDValue<%=a%>' value='<%=List[a]%>'>
									</div>
							<%
								}
							}
							for(int b=a; b<16; b++)
							{
							%>
								<div id='RatD<%=b%>' style='display:none'></div>
							<%
							}
							%>
						</div>
					</td>
				</tr>
	<%
			break;
		case 4:
	%>
				<input type="hidden" name="Cpm_Id" value="<%=Cpm_Id%>">
				<tr height='30' class='table_blue'>
				  <td width='100%' align='center' colspan=4><B>������Ϣ(¼����Ա:<%=Check_OP_Name%>)</B></td>
				</tr>
				<tr height='30'>
					<td width='20%' align='center'>���յ�λ</td>
					<td width='80%' align='left' colspan=3>
						<input name='Check_Corp' type='text' style='width:96%;height:16px;' value='<%=Check_Corp%>' maxlength='32'>
					</td>
				</tr>
				<tr height='30'>
					<td width='20%' align='center'>��������</td>
					<td width='80%' align='left' colspan=3>
						<input name='Check_Time' type='text' style='width:96%;height:18px;' value='<%=Check_Time%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
					</td>
				</tr>
				<tr height='30'>
					<td width='20%' align='center'>������Ա</td>
					<td width='80%' align='left' colspan=3>
						<input name='Check_Man'  type='text' style='width:96%;height:16px;' value='<%=Check_Man%>'  maxlength='10'>
					</td>
				</tr>
				<tr height='30'>
					<td width='20%' align='center'>�������</td>
					<td width='80%' align='left' colspan=3>
						<textarea name='Check_Des' rows='4' cols='63' maxlength=128><%=Check_Des%></textarea>
					</td>
				</tr>
				<tr height='30'>
					<td width='20%' align='center'>״̬����</td>
					<td width='80%' align='left' colspan=3>
						<select name='Status' style='width:97%;height:20px'>
							<option value='0' <%=Status.equals("0")?"selected":""%>>ά����</option>
							<option value='1' <%=Status.equals("1")?"selected":""%>>�ѹر�</option>
						</select>
					</td>
				</tr>
	<%
			break;
	}
	%>
		<tr height='40'>
			<td width='100%' align='center' colspan=4>
				<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doEdit()'>
			</td>
		</tr>
	</table>
	<input type="hidden" name="Cmd"          value="11">
	<input type="hidden" name="Sid"          value="<%=Sid%>">
	<input type="hidden" name="SN"           value="<%=SN%>">
	<input type="hidden" name="Apply_OP"     value="<%=Operator%>">
	<input type="hidden" name="Fix_OP"       value="<%=Operator%>">
	<input type="hidden" name="Rate_OP"      value="<%=Operator%>">
	<input type="hidden" name="Check_OP"     value="<%=Operator%>">
	<input type="hidden" name="BTime"        value="<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>">
	<input type="hidden" name="ETime"        value="<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>">
	<input type="hidden" name="Func_Corp_Id" value="<%=currStatus.getFunc_Corp_Id()%>">
	<input type="hidden" name="Func_Sub_Id"  value="<%=currStatus.getFunc_Sub_Id()%>">
	<input type="hidden" name="CurrPage"     value="<%=currStatus.getCurrPage()%>">
	<div id='popDiv' class='mydiv' style='display:none;margin:auto'></div>
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function closeDiv()
{
	document.getElementById('popDiv').style.display = 'none';
}

//�������
function doRateAdd()
{
	var cnt_a = 0;
	var cnt_n = 0;
	var cnt_y = 0;
	for(var i=0; i<16; i++)
	{
	  if(document.getElementById('RatD'+i).style.display == '')
	  {
	    cnt_y++;
	  }
	  else
	  {
	  	if(0 == cnt_n)
	  	{
	  		cnt_a = i;
	  	}
	  	cnt_n++;
	  }
	}
	if(cnt_y == 16)
	{
		alert('���֧��16��Ŀ¼!');
		return;
	}
	
	document.getElementById('popDiv').style.display = 'block';
	var url = "Fix_Trace_Edit_Rat.jsp?Sid=<%=Sid%>&Index="+cnt_a;
	document.getElementById('popDiv').innerHTML = "<iframe id='divFrame' name='divFrame' src='"+url+"' style='width:100%;height:100%' frameborder=0 scrolling='no'></iframe>";
}

//����ɾ��
function doRateDel(pIndex)
{
	document.getElementById('RatD'+pIndex).style.display = 'none';
}

//��Ʒ���
function doSpaAdd()
{
	var cnt_a = 0;
	var cnt_n = 0;
	var cnt_y = 0;
	for(var i=0; i<8; i++)
	{
	  if(document.getElementById('ConD'+i).style.display == '')
	  {
	    cnt_y++;
	  }
	  else
	  {
	  	if(0 == cnt_n)
	  	{
	  		cnt_a = i;
	  	}
	  	cnt_n++;
	  }
	}
	if(cnt_y == 8)
	{
		alert('���֧��8��Ŀ¼!');
		return;
	}
	
	document.getElementById('popDiv').style.display = 'block';
	var url = "Fix_Trace_Edit_Add.jsp?Sid=<%=Sid%>&Cpm_Id=<%=Cpm_Id%>&Cpm_Name=<%=Cpm_Name%>&Index="+cnt_a;
	document.getElementById('popDiv').innerHTML = "<iframe id='divFrame' name='divFrame' src='"+url+"' style='width:100%;height:100%' frameborder=0 scrolling='no'></iframe>";
}

//��Ʒɾ��
function doSpaDel(pIndex)
{
	document.getElementById('ConD'+pIndex).style.display = 'none';
}

function doChange(pCpm_Id)
{
	//��ɾ��
	var length = document.getElementById('Dev_SN').length;
	for(var i=0; i<length; i++)
	{
		document.getElementById('Dev_SN').remove(0);
	}
	
	//�����
	if(pCpm_Id.length > 0)
	{
		<%
		if(null != Dev_List)
		{
			Iterator deviter = Dev_List.iterator();
			while(deviter.hasNext())
			{
				DevListBean devBean = (DevListBean)deviter.next();
				String dev_sn   = devBean.getSN();
				String dev_id   = devBean.getCpm_Id();
				String dev_name = devBean.getDev_Name();
		%>
				if('<%=dev_id%>' == pCpm_Id)
				{
					var objOption = document.createElement('OPTION');
					objOption.value = '<%=dev_sn%>';
					objOption.text  = '<%=dev_name%>';
					document.getElementById('Dev_SN').add(objOption);
					if('<%=dev_sn%>' == '<%=Dev_SN%>')
					{
						objOption.selected = true;
					}
				}
		<%
			}
		}
		%>
	}
}
if('<%=CType%>' == '1')
	doChange(Fix_Trace_Edit.Cpm_Id.value);

function doEdit()
{
	switch(parseInt(<%=CType%>))
	{
		case 1:
				/**if('<Limit:limitValidate userrole='<%=FpList%>' fpid='160105' ctype='1'/>' == 'none')
				{
					alert('����Ȩ���޸�������ϸ��Ϣ!');
					return;
				}**/
				if('1' == '<%=Status%>')
				{
					alert('��ǰ���ϸ����ѹر�!');
					return;
				}
				if('<%=Fix_OP%>'.Trim().length > 0)
				{
					alert('��Ե�ǰ������ȷ����ά����Ϣ���������ٴ��޸�������Ϣ!');
					return;
				}
				if(Fix_Trace_Edit.Cpm_Id.value.length < 1)
			  {
			  	alert('��ѡ�����볡վ!');
			  	return;
			  }
			  if(Fix_Trace_Edit.Dev_SN.value.length < 1)
			  {
			  	alert('��ѡ������豸!');
			  	return;
			  }
			  if(Fix_Trace_Edit.Apply_Time.value.length < 1)
			  {
			  	alert('��ѡ����������!');
			  	return;
			  }
			  if(Fix_Trace_Edit.Apply_Des.value.Trim().length < 1)
				{
					alert('����д��������!');
					return;
				}
				if(Fix_Trace_Edit.Apply_Des.value.Trim().length > 128)
			  {
			    alert("�����������������!");
			    return;
			  }
			  if(Fix_Trace_Edit.Apply_Pre.value.Trim().length < 1)
				{
					alert('����дӦ����ʩ!');
					return;
				}
				if(Fix_Trace_Edit.Apply_Pre.value.Trim().length > 128)
			  {
			    alert("Ӧ����ʩ���������!");
			    return;
			  }
			  if(Fix_Trace_Edit.Apply_Man.value.Trim().length < 1)
			  {
			  	alert('����д������Ա!');
			  	return;
			  }
			  Fix_Trace_Edit.Cmd.value = 11;
			  if(confirm("��Ϣ����,ȷ���ύ?"))
			  {
					parent.location = "Fix_Trace.do?Cmd=11&Sid=<%=Sid%>&SN=<%=SN%>&Apply_OP=<%=Operator%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&CurrPage=<%=currStatus.getCurrPage()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>"
			  	         		    + "&Cpm_Id=" + Fix_Trace_Edit.Cpm_Id.value
			  	         			  + "&Dev_SN=" + Fix_Trace_Edit.Dev_SN.value
			  	         			  + "&Apply_Time=" + Fix_Trace_Edit.Apply_Time.value
			  	         			  + "&Apply_Man=" + Fix_Trace_Edit.Apply_Man.value.Trim()
			  	         			  + "&Apply_Des=" + Fix_Trace_Edit.Apply_Des.value.Trim()
			  	        	 		  + "&Apply_Pre=" + Fix_Trace_Edit.Apply_Pre.value.Trim();
			  }
			break;
		case 2:
				/**if('<Limit:limitValidate userrole='<%=FpList%>' fpid='160107' ctype='1'/>' == 'none')
				{
					alert('����Ȩ���޸�ά����ϸ��Ϣ!');
					return;
				}**/
				if('1' == '<%=Status%>')
				{
					alert('��ǰ���ϸ����ѹر�!');
					return;
				}
				if('<%=Check_OP%>'.Trim().length > 0)
				{
					alert('��Ե�ǰ������������ϣ��������ٴ��޸�ά����Ϣ!');
					return;
				}
				if(Fix_Trace_Edit.Fix_Plan.value.Trim().length < 1)
				{
					alert('����дά�޴�ʩ!');
					return;
				}
				if(Fix_Trace_Edit.Fix_Plan.value.Trim().length > 128)
			  {
			    alert("ά�޴�ʩ���������!");
			    return;
			  }
			  if(Fix_Trace_Edit.Fix_Corp.value.Trim().length < 1)
				{
					alert('����дά�޵�λ!');
					return;
				}
			  if(Fix_Trace_Edit.Fix_BTime.value.Trim().length < 1)
				{
					alert('��ѡ�񿪹�����!');
					return;
				}
				if(Fix_Trace_Edit.Fix_ETime.value.Trim().length < 1)
				{
					alert('��ѡ���깤����!');
					return;
				}
				if(Fix_Trace_Edit.Fix_BTime.value > Fix_Trace_Edit.Fix_ETime.value)
				{
					alert('�깤���ڲ����ڿ�������֮ǰ!');
					return;
				}
				if(Fix_Trace_Edit.file.value.Trim().length > 0)
			  {
			  	if(Fix_Trace_Edit.file.value.indexOf('.doc') == -1 
			  	&& Fix_Trace_Edit.file.value.indexOf('.DOC') == -1 
			  	&& Fix_Trace_Edit.file.value.indexOf('.docx') == -1 
			  	&& Fix_Trace_Edit.file.value.indexOf('.DOCX') == -1 
			  	&& Fix_Trace_Edit.file.value.indexOf('.xls') == -1 
			  	&& Fix_Trace_Edit.file.value.indexOf('.XLS') == -1 
			  	&& Fix_Trace_Edit.file.value.indexOf('.xlsx') == -1 
			  	&& Fix_Trace_Edit.file.value.indexOf('.XLSX') == -1 
			  	&& Fix_Trace_Edit.file.value.indexOf('.pdf') == -1 
			  	&& Fix_Trace_Edit.file.value.indexOf('.PDF') == -1)
					{
						alert('��ȷ���ĵ���ʽ,֧��doc,docx,xls,xlsx,pdf��ʽ!');
						return;
					}
			  }
			  
			  var Fix_Des = '';
			  for(var i=0; i<8; i++)
				{
				  if(document.getElementById('ConD'+i).style.display == '')
				  {
				    Fix_Des += document.getElementById('ConDValue'+i).value + ';';
				  }
				}
			  
			  Fix_Trace_Edit.Fix_Des.value = Fix_Des;
				Fix_Trace_Edit.Cmd.value = 12;
				var currFirm = '��Ϣ����,ȷ���ύ?';
				if('<%=Fix_Plan_File%>'.length > 0 && Fix_Trace_Edit.file.value.Trim().length > 0)
				{
					currFirm = 'ԭ���ĵ��Ѵ���,ȷ���滻?';
				}
				if(confirm(currFirm))
			  {
					Fix_Trace_Edit.submit();
			  }
			break;
		case 3:
				/**if('<Limit:limitValidate userrole='<%=FpList%>' fpid='160109' ctype='1'/>' == 'none')
				{
					alert('����Ȩ���޸Ľ�����ϸ��Ϣ!');
					return;
				}**/
				if('1' == '<%=Status%>')
				{
					alert('��ǰ���ϸ����ѹر�!');
					return;
				}
				if('<%=Check_OP%>'.Trim().length > 0)
				{
					alert('��Ե�ǰ������������ϣ��������ٴ��޸Ľ�����Ϣ!');
					return;
				}
				
				var Rate_Des = '';
			  for(var i=0; i<16; i++)
				{
				  if(document.getElementById('RatD'+i).style.display == '')
				  {
				    Rate_Des += document.getElementById('RatDValue'+i).value + '~';
				  }
				}
			  if(Rate_Des.length < 1)
			  {
			  	alert('����ӽ�����Ŀ!');
			  	return;
			  }
			  
			  Fix_Trace_Edit.Rate_Des.value = Rate_Des;
				Fix_Trace_Edit.Cmd.value = 13;
				if(confirm('��Ϣ����,ȷ���ύ?'))
			  {
			  	parent.location = "Fix_Trace.do?Cmd=13&Sid=<%=Sid%>&SN=<%=SN%>&Rate_OP=<%=Operator%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&CurrPage=<%=currStatus.getCurrPage()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>"
			  	         		    + "&Cpm_Id=" + Fix_Trace_Edit.Cpm_Id.value
			  	         			  + "&Rate_Des=" + Fix_Trace_Edit.Rate_Des.value;
			  }
			break;
		case 4:
				/**if('<Limit:limitValidate userrole='<%=FpList%>' fpid='160111' ctype='1'/>' == 'none')
				{
					alert('����Ȩ���޸�������ϸ��Ϣ!');
					return;
				}**/
				if('1' == '<%=Status%>')
				{
					alert('��ǰ���ϸ����ѹر�!');
					return;
				}
				if('<%=Fix_OP%>'.Trim().length < 1)
				{
					alert('��δ��дά����Ϣ�������ɽ������չ���!');
					return;
				}
				if('<%=Rate_OP%>'.Trim().length < 1)
				{
					alert('��δ��д������Ϣ�������ɽ������չ���!');
					return;
				}
				if(Fix_Trace_Edit.Check_Corp.value.Trim().length < 1)
				{
					alert('����д���յ�λ!');
					return;
				}
				if(Fix_Trace_Edit.Check_Time.value.length < 1)
			  {
			  	alert('��ѡ����������!');
			  	return;
			  }
			  if(Fix_Trace_Edit.Check_Man.value.Trim().length < 1)
				{
					alert('����д������Ա!');
					return;
				}
				if(Fix_Trace_Edit.Check_Des.value.Trim().length < 1)
				{
					alert('����д�������!');
					return;
				}
				if(Fix_Trace_Edit.Check_Des.value.Trim().length > 128)
			  {
			    alert("����������������!");
			    return;
			  }
				
				Fix_Trace_Edit.Cmd.value = 14;
				if(confirm('��Ϣ����,ȷ���ύ?'))
			  {
			  	parent.location = "Fix_Trace.do?Cmd=14&Sid=<%=Sid%>&SN=<%=SN%>&Check_OP=<%=Operator%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&CurrPage=<%=currStatus.getCurrPage()%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>"
			  	         		    + "&Cpm_Id=" + Fix_Trace_Edit.Cpm_Id.value
			  	         			  + "&Check_Corp=" + Fix_Trace_Edit.Check_Corp.value.Trim()
			  	         			  + "&Check_Time=" + Fix_Trace_Edit.Check_Time.value
			  	         			  + "&Check_Man=" + Fix_Trace_Edit.Check_Man.value.Trim()
			  	         			  + "&Check_Des=" + Fix_Trace_Edit.Check_Des.value.Trim()
			  	         			  + "&Status=" + Fix_Trace_Edit.Status.value;
			  }
			break;
	}
}
</SCRIPT>
</html>