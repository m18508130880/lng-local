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
<script type='text/javascript' src='../skin/js/browser.js' charset='gb2312'></script>
<script type="text/javascript" src="../skin/js/My97DatePicker/WdatePicker.js"></script>
<script type='text/javascript' src='../skin/js/zDrag.js'   charset='gb2312'></script>
<script type='text/javascript' src='../skin/js/zDialog.js' charset='gb2312'></script>
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
 	
  CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
  String BDate = currStatus.getVecDate().get(0).toString().substring(0,10);
	String EDate = currStatus.getVecDate().get(1).toString().substring(0,10);
	
	ArrayList Spa_Store_I = (ArrayList)session.getAttribute("Spa_Store_I_" + Sid);
	ArrayList Spa_Store   = (ArrayList)session.getAttribute("Spa_Store_" + Sid);
  int sn = 0;
  
%>
<body style=" background:#CADFFF">
<form name="Spa_Store_I"  action="Spa_Store_I.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='80%' align='left'>
				��Ʒ����:
				<select name='Func_Corp_Id' style='width:150px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>ȫ��</option>
					<%
					if(null != Spa_Store)
					{
						String c_Type = "";
						Iterator typeiter = Spa_Store.iterator();
						while(typeiter.hasNext())
						{
							SpaStoreBean typeBean = (SpaStoreBean)typeiter.next();
							if(!typeBean.getSpa_Type().equals(c_Type))
							{
					%>
								<option value='<%=typeBean.getSpa_Type()%>' <%=currStatus.getFunc_Corp_Id().equals(typeBean.getSpa_Type())?"selected":""%>><%=typeBean.getSpa_Type_Name()%></option>
					<%
							}
							c_Type = typeBean.getSpa_Type();
						}
					}
					%>
				</select>
				��Ʒ���:
				<select name='Func_Sub_Id' style='width:60px;height:20px' onChange="doSelect()">
					<option value='1' <%=currStatus.getFunc_Sub_Id() == 1 ? "selected":""%>>������</option>
					<option value='2' <%=currStatus.getFunc_Sub_Id() == 2 ? "selected":""%>>������</option>
				</select>
				��¼״̬:
				<select name='Func_Sel_Id' style='width:70px;height:20px' onChange="doSelect()">
					<option value='9' <%=currStatus.getFunc_Sel_Id() == 9 ? "selected":""%>>ȫ��</option>
					<option value='0' <%=currStatus.getFunc_Sel_Id() == 0 ? "selected":""%>>�����</option>
					<option value='1' <%=currStatus.getFunc_Sel_Id() == 1 ? "selected":""%>>�����Ч</option>
					<option value='2' <%=currStatus.getFunc_Sel_Id() == 2 ? "selected":""%>>�����Ч</option>
				</select>
				<input id='BDate' name='BDate' type='text' style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				-
				<input id='EDate' name='EDate' type='text' style='width:90px;height:18px;' value='<%=EDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				�깺����:<input type='text' name='Func_Type_Id' style='width:70px;height:16px;' value='<%=currStatus.getFunc_Type_Id()%>'>
			</td>
			<td width='20%' align='right'>
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">
				<img id="img2" src="../skin/images/excel.gif"              onClick='doExport()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='140202' ctype='1'/>">
				<img id="img3" src="../skin/images/mini_button_add.gif"    onClick='doAdd()'    style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='140203' ctype='1'/>">
			</td>
		</tr>
		<tr height='30'>
			<td width='100%' align='center' colspan=2>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25'>
						<td width='5%'  align='center' class="table_deep_blue">���</td>
						<td width='8%' align='center' class="table_deep_blue">��Ʒ����</td>
						<td width='18%' align='center' class="table_deep_blue">����ͺ�</td>
						<td width='8%' align='center' class="table_deep_blue">�깺ʱ��</td>
						<td width='37%' align='center' class="table_deep_blue">�깺��Ϣ</td>
						<td width='24%' align='center' class="table_deep_blue">�����Ϣ</td>
					</tr>
					<%
					if(Spa_Store_I != null)
					{
						Iterator iterator = Spa_Store_I.iterator();
						while(iterator.hasNext())
						{
							SpaStoreIBean Bean = (SpaStoreIBean)iterator.next();
							String SN            = Bean.getSN();
							String Spa_Type_Name = Bean.getSpa_Type_Name();
							String Spa_Mode      = Bean.getSpa_Mode();
							String Model         = Bean.getModel();
							String Spa_I_Time    = Bean.getSpa_I_Time();
							String Spa_Mode_Name = "/";
							if(null != Model && Model.length() > 0)
							{
								String[] List = Model.split(",");
								if(List.length >= Integer.parseInt(Spa_Mode))
									Spa_Mode_Name = List[Integer.parseInt(Spa_Mode)-1];
							}
							
							//�깺��Ϣ
							String Spa_I_Numb    = Bean.getSpa_I_Numb();
							String Spa_I_Cnt     = Bean.getSpa_I_Cnt();
							String Spa_I_Price   = Bean.getSpa_I_Price();
							String Spa_I_Amt     = Bean.getSpa_I_Amt();
							String Spa_I_Memo    = Bean.getSpa_I_Memo();
							String Operator_Name = Bean.getOperator_Name();
							String str_Des1    =  "����: <font color=red>" + Spa_I_Cnt+"��</font>"
							                   + "&nbsp;&nbsp;&nbsp;"
							                   + "����: " + Spa_I_Price+"Ԫ"
							                   + "&nbsp;&nbsp;&nbsp;"
							                   + "���: " + Spa_I_Amt+"Ԫ"
							                   + "&nbsp;&nbsp;&nbsp;"
							                   + "��ע: " + Spa_I_Memo;
							
							//�����Ϣ
							String Status         = Bean.getStatus();
							String Status_OP_Name = Bean.getStatus_OP_Name();
							String Status_Memo    = Bean.getStatus_Memo();
							if(null == Status_OP_Name){Status_OP_Name = "";}
							if(null == Status_Memo){Status_Memo = "";}
							
							String str_Des2       = "";
							switch(Integer.parseInt(Status))
							{
								case 0:
										str_Des2 = "״̬: " + "<font color=red>�����</font>"
										         + "&nbsp;&nbsp;&nbsp;"
										         + "�����Ա: " + Status_OP_Name
										         + "&nbsp;&nbsp;&nbsp;"
										         + "��ע: " + Status_Memo;
									break;
								case 1:
										str_Des2 = "״̬: " + "<font color=green>��Ч</font>"
										         + "&nbsp;&nbsp;&nbsp;"
										         + "�����Ա: " + Status_OP_Name
										         + "&nbsp;&nbsp;&nbsp;"
										         + "��ע: " + Status_Memo;
									break;
								case 2:
										str_Des2 = "״̬: " + "<font color=gray>��Ч</font>"
										         + "&nbsp;&nbsp;&nbsp;"
										         + "�����Ա: " + Status_OP_Name
										         + "&nbsp;&nbsp;&nbsp;"
										         + "��ע: " + Status_Memo;
									break;
							}
							
							sn++;
					%>
						  <tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
								<td align=center><%=sn%></td>
								<td align=left><%=Spa_Type_Name%></td>
						    <td align=left><%=Spa_Mode_Name%></td>
						    <td align=center><%=Spa_I_Time%></td>
						    <td align='center' style='cursor:hand;' title='�༭�깺��Ϣ' onclick="doEdit01('<%=SN%>', '<%=Status%>')"><%=str_Des1%></td>
						    <td align='center' style='cursor:hand;' title='����깺��Ϣ' onclick="doEdit02('<%=SN%>', '<%=Status%>')"><%=str_Des2%></td>
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
				      	<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
				      </tr>  
					<%
						}
					  else
					  {
					%>				
		          <tr <%=((i%2)==0?"class='table_white_l'":"class='table_blue'")%>>
			          <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
			        </tr>      
					<%
       			}
     			}
					%> 
     		 	<tr>
						<td colspan="6" class="table_deep_blue" >
				 			<table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0" >
			    			<tr valign="bottom">
			      			<td nowrap><%=currStatus.GetPageHtml("Spa_Store_I")%></td>
			    			</tr>			    		
							</table>
						</td>
					</tr>
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

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Spa_Store_I.jsp';

switch(parseInt(<%=currStatus.getFunc_Sel_Id()%>))
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
	/**var days = new Date(Spa_Store_I.EDate.value.replace(/-/g, "/")).getTime() - new Date(Spa_Store_I.BDate.value.replace(/-/g, "/")).getTime();
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
	//Spa_Store_I.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
	Spa_Store_I.BTime.value = Spa_Store_I.BDate.value;
	Spa_Store_I.ETime.value = Spa_Store_I.EDate.value;
	Spa_Store_I.submit();
}

function GoPage(pPage)
{
	/**var days = new Date(Spa_Store_I.EDate.value.replace(/-/g, "/")).getTime() - new Date(Spa_Store_I.BDate.value.replace(/-/g, "/")).getTime();
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
	//Spa_Store_I.Cpm_Id.value = window.parent.frames.lFrame.document.getElementById('id').value;
	Spa_Store_I.BTime.value = Spa_Store_I.BDate.value;
	Spa_Store_I.ETime.value = Spa_Store_I.EDate.value;
	Spa_Store_I.CurrPage.value = pPage;
	Spa_Store_I.submit();
}

//����깺��Ϣ
function doAdd()
{
	location = "Spa_Store_I_Add.jsp?Sid=<%=Sid%>";
}

//�༭�깺��Ϣ
function doEdit01(pSN, pStatus)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='140204' ctype='1'/>' == 'none')
	{
		alert('����Ȩ���޸��깺��Ϣ!');
		return;
	}
	
	if('0' != pStatus)
	{
		alert('��ǰ��¼����ˣ��������޸��깺��Ϣ!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 349;
	diag.Title = "�༭�깺��Ϣ";
	diag.URL = "Spa_Store_I_Edt.jsp?Sid=<%=Sid%>&CType=1&SN=" + pSN;
	diag.show();
}

//����깺��Ϣ
function doEdit02(pSN, pStatus)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='140205' ctype='1'/>' == 'none')
	{
		alert('����Ȩ���޸������Ϣ!');
		return;
	}
	
	if('0' != pStatus)
	{
		alert('��ǰ��¼����ˣ�����������깺��Ϣ!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 600;
	diag.Height = 350;
	diag.Title = "����깺��Ϣ";
	diag.URL = "Spa_Store_I_Edt.jsp?Sid=<%=Sid%>&CType=2&SN=" + pSN;
	diag.show();
}

var req = null;
function doExport()
{
	var days = new Date(Spa_Store_I.EDate.value.replace(/-/g, "/")).getTime() - new Date(Spa_Store_I.BDate.value.replace(/-/g, "/")).getTime();
	var dcnt = parseInt(days/(1000*60*60*24));
	/**if(dcnt < 0)
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
		var url = "Spa_Store_I_Export.do?Sid=<%=Sid%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>&Func_Sel_Id=<%=currStatus.getFunc_Sel_Id()%>&Func_Type_Id=<%=currStatus.getFunc_Type_Id()%>";
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
</SCRIPT>
</html>