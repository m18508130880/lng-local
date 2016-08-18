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
<link type="text/css" href="../../skin/css/style.css" rel="stylesheet"/>
<script type='text/javascript' src='../../skin/js/browser.js' charset='gb2312'></script>
<script type="text/javascript" src="../../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="../../skin/js/util.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	ArrayList User_FP_Role = (ArrayList)session.getAttribute("User_FP_Role_" + Sid);
	UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
	String Operator = UserInfo.getId();
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
	
	ArrayList Pro_R_Type = (ArrayList)session.getAttribute("Pro_R_Type_" + Sid);
	CorpInfoBean Corp_Info = (CorpInfoBean)session.getAttribute("User_Corp_Info_" + Sid);
	String Oil_Info = "";
	String Car_Info = "";
	if(null != Corp_Info)
	{
		Oil_Info = Corp_Info.getOil_Info();
		Car_Info = Corp_Info.getCar_Info();
		if(null == Oil_Info){Oil_Info = "";}
		if(null == Car_Info){Car_Info = "";}
	}
	
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  String BDate = currStatus.getVecDate().get(0).toString().substring(0,10);
	String EDate = currStatus.getVecDate().get(1).toString().substring(0,10);
	
  ArrayList Pro_O = (ArrayList)session.getAttribute("Pro_O_" + Sid);
  int sn = 0; 
  
%>
<body style="background:#CADFFF">
<form name="Pro_O"  action="Pro_O.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='80%' align='left'>
				ȼ������:
				<select name='Func_Corp_Id' style='width:150px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>ȫ��</option>
					<%
					if(null != Pro_R_Type)
					{
						Iterator typeiter = Pro_R_Type.iterator();
						while(typeiter.hasNext())
						{
							ProRBean typeBean = (ProRBean)typeiter.next();
							String type_Id = typeBean.getOil_CType();
							String type_Name = "��";
													
							if(Oil_Info.trim().length() > 0)
							{
							  String[] List = Oil_Info.split(";");
							  for(int i=0; i<List.length && List[i].length()>0; i++)
							  {
							  	String[] subList = List[i].split(",");
							  	if(type_Id.equals(subList[0]))
							  	{
							  		type_Name = subList[1];
							  		break;
							  	}
					  		}
					  	}
					%>
					  	<option value='<%=type_Id%>' <%=currStatus.getFunc_Corp_Id().equals(type_Id)?"selected":""%>><%=type_Id%>|<%=type_Name%></option>
					<%				  	
						}
					}
					%>
				</select>
				��¼״̬:
				<select name='Func_Sub_Id' style='width:90px;height:20px' onChange="doSelect()">
					<option value='0' <%=currStatus.getFunc_Sub_Id() == 0 ? "selected":""%>>�����Ч</option>
					<option value='1' <%=currStatus.getFunc_Sub_Id() == 1 ? "selected":""%>>�����Ч</option>
				</select>
				<input name='BDate' type='text' style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				-
				<input name='EDate' type='text' style='width:90px;height:18px;' value='<%=EDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				���ƺ�|����:<input type='text' name='Func_Type_Id' style='width:100px;height:16px;' value='<%=currStatus.getFunc_Type_Id()%>'>
			</td>
			<td width='20%' align='right'>		
				<img id="img1" src="../../skin/images/mini_button_search.gif" onClick='doSelect()' style='cursor:hand;'>
				<img id="img2" src="../../skin/images/excel.gif"              onClick='doExport()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='020302' ctype='1'/>">
				<img id="img3" src="../../skin/images/mini_button_add.gif"    onClick='doAdd()'    style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='020303' ctype='1'/>">
			</td>
		</tr>
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25' valign='middle'>
						<td width='4%'  align='center' class="table_deep_blue">���</td>
						<td width='10%' align='center' class="table_deep_blue">��עվ��</td>
						<td width='10%' align='center' class="table_deep_blue">ȼ������</td>
						<td width='12%' align='center' class="table_deep_blue">��עʱ��</td>
						<td width='20%' align='center' class="table_deep_blue">��ע��Ϣ</td>
						<td width='20%' align='center' class="table_deep_blue">�ͻ���Ϣ</td>
						<td width='16%' align='center' class="table_deep_blue">��¼��Ϣ</td>
					</tr>
					<%
					 if(Pro_O != null)
					 {
						Iterator iterator = Pro_O.iterator();
						while(iterator.hasNext())
						{
							ProOBean Bean = (ProOBean)iterator.next();
							String SN        = Bean.getSN();
							String Cpm_Name  = Bean.getCpm_Name();
							String Oil_CType = Bean.getOil_CType();
							String CTime     = Bean.getCTime();
							String Memo      = Bean.getMemo();
							
							//��ע��Ϣ
							String Value     = Bean.getValue();
							String Value_Gas = Bean.getValue_Gas();
							String Price     = Bean.getPrice();
						  String Amt       = Bean.getAmt();
							String Worker    = Bean.getWorker();
							
							//�ͻ���Ϣ
							String Unq_Flag  = Bean.getUnq_Flag();
							String Unq_Str   = Bean.getUnq_Str();
							String Car_More  = Bean.getCar_More();
							String Car_CType = Bean.getCar_CType();
							String Car_Owner = Bean.getCar_Owner();
							String Car_BH 	 = Bean.getCar_BH();
							String Car_DW 	 = Bean.getCar_DW();
							
							//�����Ϣ
							String Status        = Bean.getStatus();
							String Checker_Name  = Bean.getChecker_Name();
							String Operator_Name = Bean.getOperator_Name();
							
							if(null == Oil_CType || Oil_CType.trim().length() < 1){Oil_CType = "1000";}
							if(null == Memo){Memo = "";}
							if(null == Value){Value = "";}
							if(null == Value_Gas){Value_Gas = "";}
							if(null == Price){Price = "";}
							if(null == Amt){Amt = "";}
							if(null == Worker){Worker = "";}
							if(null == Unq_Flag){Unq_Flag = "0";}
							if(null == Unq_Str){Unq_Str = "";}
							if(null == Checker_Name){Checker_Name = "";}
							if(null == Operator_Name){Operator_Name = "";}
							if(null == Car_CType){Car_CType = "";}
							if(null == Car_Owner){Car_Owner = "";}
							if(null == Car_BH){Car_BH = "";}
							if(null == Car_DW){Car_DW = "";}
							
							String Oil_CName = "��";
							if(Oil_Info.trim().length() > 0)
							{
							  String[] List = Oil_Info.split(";");
							  for(int i=0; i<List.length && List[i].length()>0; i++)
							  {
							  	String[] subList = List[i].split(",");
							  	if(subList[0].equals(Oil_CType))
							  	{
							  		Oil_CName = subList[1];
							  		break;
							  	}
							  }
							}
							
							String Oil_Detail = "";
							try
							{
								switch(Integer.parseInt(Oil_CType))
								{
									default:
									case 1000://����
									case 1010://90#����
									case 1011://90#��Ǧ����
									case 1012://90#�������
									case 1020://92#����
									case 1021://92#��Ǧ����
									case 1022://92#�������
									case 1030://93#����
									case 1031://93����Ǧ����
									case 1032://93#�������
									case 1040://95#����
									case 1041://95#��Ǧ����
									case 1042://95#�������
									case 1050://97#����
									case 1051://97#��Ǧ����
									case 1052://97#�������
									case 1060://120������
									case 1080://������������
									case 1090://98#����
									case 1091://98#��Ǧ����
									case 1092://98���������
									case 1100://��������
									case 1200://��������
									case 1201://75#��������
									case 1202://95#��������
									case 1203://100#��������
									case 1204://������������
									case 1300://��������
									case 2000://����
									case 2001://0#����
									case 2002://+5#����
									case 2003://+10#����
									case 2004://+15#����
									case 2005://+20#����
									case 2006://-5#����
									case 2007://-10#����
									case 2008://-15#����
									case 2009://-20#����
									case 2010://-30#����
									case 2011://-35#����
									case 2015://-50#����
									case 2100://�����
									case 2016://���������
									case 2200://�ز���
									case 2012://10#�ز���
									case 2013://20#�ز���
									case 2014://�����ز���
									case 2300://���ò���
									case 2301://-10#���ò���
									case 2900://��������
											Oil_Detail = "��ע����: " + Value + "L<br>"
								                 + "�ۺ�����: " + Value_Gas + "kg<br>"
								                 + "��ע����: " + Price + "Ԫ/L<br>"
								                 + "��ע���: " + Amt + "Ԫ<br>"
								                 + "��ע��Ա: " + Worker;
										break;
									case 3001://CNG
									case 3002://LNG
											Oil_Detail = "��ע����: " + Value + "kg<br>"
								                 + "�ۺ���̬: " + Value_Gas + "m3<br>"
								                 + "��ע����: " + Price + "Ԫ/kg<br>"
								                 + "��ע���: " + Amt + "Ԫ<br>"
								                 + "��ע��Ա: " + Worker;
										break;
								}
							}
							catch(Exception Exp)
							{
								Oil_Detail = "��ע����: " + Value + "kg<br>"
								           + "�ۺ���̬: " + Value_Gas + "m3<br>"
								           + "��ע����: " + Price + "Ԫ/kg<br>"
								           + "��ע���: " + Amt + "Ԫ<br>"
								           + "��ע��Ա: " + Worker;
								Exp.printStackTrace();
							}
							
							String Car_CType_Name = "δ֪";
							if(Car_Info.trim().length() > 0)
							{
								String[] List = Car_Info.split(";");
							  for(int i=0; i<List.length && List[i].length()>0; i++)
							  {
							  	String[] subList = List[i].split(",");
							  	if(subList[0].equals(Car_CType))
							  	{
							  		Car_CType_Name = subList[1];
							  		break;
							  	}
							  }
							}
							
							String Car_Detail = "";
							switch(Integer.parseInt(Unq_Flag))
							{
								case 0:
										Car_Detail = "��������: IC����<br>"
							                 + "�����ִ�: " + Unq_Str + "<br>"
							                 + "��������: " + Car_CType_Name + "<br>"
							                 + "����˾��: " + Car_Owner +"<br>"
							                 + "����ƿ��: " + Car_BH +"<br>"
							                 + "������λ: " + Car_DW;
									break;
								case 1:
										Car_Detail = "��������: ���ƺ�<br>"
							                 + "�����ִ�: " + Unq_Str + "<br>"
							                 + "��������: " + Car_CType_Name + "<br>"
							                 + "����˾��: " + Car_Owner +"<br>"
							                 + "����ƿ��: " + Car_BH +"<br>"
							                 + "������λ: " + Car_DW;
									break;
							}
							
							/*
							String Car_Type = "δ֪";
							if(Car_Info.trim().length() > 0)
							{
								String[] List = Car_Info.split(";");
							  for(int i=0; i<List.length && List[i].length()>0; i++)
							  {
							  	String[] subList = List[i].split(",");
							  	if(subList[0].equals(Car_More.split("\\$")[1]))
							  	{
							  		Car_Type = subList[1];
							  		break;
							  	}
							  }
							}
							
							String Car_Detail = "";
							switch(Integer.parseInt(Unq_Flag))
							{
								case 0:
										Car_Detail = "��������: IC����<br>"
							                 + "�����ִ�: " + Unq_Str + "<br>"
							                 + "�����ƺ�: " + Car_More.split("\\$")[0] + "<br>"
							                 + "��������: " + Car_Type + "<br>"
							                 + "����˾��: " + Car_More.split("\\$")[2] +"<br>"
							                 + "����ƿ��: " + Car_More.split("\\$")[3] +"<br>"
							                 + "������λ: " + Car_More.split("\\$")[4];
									break;
								case 1:
										Car_Detail = "��������: ���ƺ�<br>"
							                 + "�����ִ�: " + Unq_Str + "<br>"
							                 + "�����ƺ�: " + Car_More.split("\\$")[0] + "<br>"
							                 + "��������: " + Car_Type + "<br>"
							                 + "����˾��: " + Car_More.split("\\$")[2] +"<br>"
							                 + "����ƿ��: " + Car_More.split("\\$")[3] +"<br>"
							                 + "������λ: " + Car_More.split("\\$")[4];
									break;
							}
							*/
							
							String Rcd_Detail = "";
							switch(Integer.parseInt(Status))
							{
								case 0:
										Rcd_Detail = "¼����Ա: " + Operator_Name + "<br>"
															 + "�����Ա: " + Checker_Name + "<br>"
															 + "��¼״̬: " + "<a href='#' onClick=\"doAbandon('"+SN+"', '"+CTime+"', '1')\">��Ч</a>";
									break;
								case 1:
										Rcd_Detail = "¼����Ա: " + Operator_Name + "<br>"
															 + "�����Ա: " + Checker_Name + "<br>"
															 + "��¼״̬: " + "��Ч";
									break;
							}
							
							sn++;
					%>
				  <tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%> title='<%=Memo%>'>
						<%
						if(Status.equals("0"))
						{
						%>
							<td align=center><%=sn%></td>
							<td align=center><%=Cpm_Name%></td>
							<td align=center><%=Oil_CName%></td>
							<td align=center><%=CTime%></td>
							<td align=left valign=top><%=Oil_Detail%></td>
							<td align=left valign=top><%=Car_Detail%></td>
							<td align=left valign=top><%=Rcd_Detail%></td>
						<%
						}
						else if(Status.equals("1"))
						{
						%>
							<td align=center><font color=gray><%=sn%></font></td>
							<td align=center><font color=gray><%=Cpm_Name%></font></td>
							<td align=center><font color=gray><%=Oil_CName%></font></td>
							<td align=center><font color=gray><%=CTime%></font></td>					
							<td align=left valign=top><font color=gray><%=Oil_Detail%></font></td>
							<td align=left valign=top><font color=gray><%=Car_Detail%></font></td>
							<td align=left valign=top><font color=gray><%=Rcd_Detail%></font></td>
						<%
						}
						else
						{
						%>
							<td align=center><%=sn%></td>
							<td align=center><%=Cpm_Name%></td>
							<td align=center><%=Oil_CName%></td>
							<td align=center><%=CTime%></td>
							<td align=left valign=top><%=Oil_Detail%></td>
							<td align=left valign=top><%=Car_Detail%></td>
							<td align=left valign=top><%=Rcd_Detail%></td>
						<%
						}
						%>
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
						<td colspan="7" class="table_deep_blue" >
				 			<table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0" >
			    			<tr valign="bottom">
			      			<td nowrap><%=currStatus.GetPageHtml("Pro_O")%></td>
			    			</tr>			    		
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<input name="Cmd"      type="hidden" value="0">
<input name="Sid"      type="hidden" value="<%=Sid%>">
<input name="Cpm_Id"   type="hidden" value=""/>
<input name="SN"       type="hidden" value=""/>
<input name="Status"   type="hidden" value=""/>
<input name="Checker"  type="hidden" value="<%=Operator%>"/>
<input name="BTime"    type="hidden" value="">
<input name="ETime"    type="hidden" value="">
<input name="CurrPage" type="hidden" value="<%=currStatus.getCurrPage()%>">
<input type="button"   id="CurrButton" onClick="doSelect()" style="display:none">
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

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Pro_O.jsp';

function doSelect()
{
	var days = new Date(Pro_O.EDate.value.replace(/-/g, "/")).getTime() - new Date(Pro_O.BDate.value.replace(/-/g, "/")).getTime();
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
	
	Pro_O.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
	Pro_O.BTime.value = Pro_O.BDate.value + " 00:00:00";
	Pro_O.ETime.value = Pro_O.EDate.value + " 23:59:59";
	Pro_O.submit();
}

function GoPage(pPage)
{
	var days = new Date(Pro_O.EDate.value.replace(/-/g, "/")).getTime() - new Date(Pro_O.BDate.value.replace(/-/g, "/")).getTime();
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
	Pro_O.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
	Pro_O.BTime.value = Pro_O.BDate.value + " 00:00:00";
	Pro_O.ETime.value = Pro_O.EDate.value + " 23:59:59";
	Pro_O.CurrPage.value = pPage;
	Pro_O.submit();
}

function doAbandon(pSN, pCTime, pStatus)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='020304' ctype='1'/>' == 'none')
	{
		alert('����Ȩ����˼�ע��¼!');
		return;
	}
	
	var TDay = new Date().format("yyyy-MM-dd");
	if(pCTime.substring(0,10) != TDay)
	{
		alert('ֻ�ɲ���������ˮ��¼!');
		return;
	}
	
	if(confirm('ȷ�Ͻ���ǰ��ע��¼��Ϊ��Ч?'))
	{
		Pro_O.Cmd.value = 11;
		Pro_O.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
		Pro_O.SN.value = pSN;
		Pro_O.Status.value = pStatus;
		Pro_O.BTime.value = Pro_O.BDate.value + " 00:00:00";
		Pro_O.ETime.value = Pro_O.EDate.value + " 23:59:59";
		Pro_O.submit();
	}
}

var req = null;
function doExport()
{	
	var days = new Date(Pro_O.EDate.value.replace(/-/g, "/")).getTime() - new Date(Pro_O.BDate.value.replace(/-/g, "/")).getTime();
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
		var url = "Pro_O_Export.do?Sid=<%=Sid%>&Cpm_Id="+window.parent.frames.lFrame.document.getElementById('id').value+"&BTime="+Pro_O.BDate.value+" 00:00:00"+"&ETime="+Pro_O.EDate.value+" 23:59:59" + "&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Type_Id=<%=currStatus.getFunc_Type_Id()%>&CurrPage=<%=currStatus.getCurrPage()%>";
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
			location.href = "../../files/excel/" + resp + ".xls";
		}
	}
}

function doAdd()
{
	location = "Pro_O_Add.jsp?Sid=<%=Sid%>";
}
</SCRIPT>
</html>