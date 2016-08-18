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
<script type='text/javascript' src='../skin/js/util.js' charset='gb2312'></script>
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
	
	ArrayList Spa_Store_O = (ArrayList)session.getAttribute("Spa_Store_O_" + Sid);
	ArrayList Spa_Store   = (ArrayList)session.getAttribute("Spa_Store_" + Sid);
	
	ArrayList Spa_Store_Cpm   = (ArrayList)session.getAttribute("Spa_Store_Cpm_" + Sid);
	ArrayList Spa_Store_Type   = (ArrayList)session.getAttribute("Spa_Store_Type_" + Sid);
	ArrayList Spa_Store_Mode   = (ArrayList)session.getAttribute("Spa_Store_Mode_" + Sid);
  int sn = 0;  	
  
%>
<body style="background:#CADFFF">
<form name="Spa_Store_O"  action="Spa_Store_O.do" method="post" target="mFrame">
<div id="down_bg_2">
	<table width="100%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='25px' class='sjtop'>
			<td width='80%' align='left'>
				&nbsp;����վ��:
				<select  name='Func_Cpm_Id' style='width:100px;height:20px' onChange="doSelect()" >		
					<option value='' <%=currStatus.getFunc_Cpm_Id().equals("")?"selected":""%>>ȫ��</option>		
						<%														
								if( null != Spa_Store_Cpm)
								{
									Iterator it = Spa_Store_Cpm.iterator();
									while(it.hasNext())
									{
										SpaStoreOBean statBean = (SpaStoreOBean)it.next();										
								%>
											<option value='<%=statBean.getCpm_Id()%>' <%=currStatus.getFunc_Cpm_Id().equals(statBean.getCpm_Id())?"selected":""%>><%=statBean.getCpm_Id()%></option>
								<%									
									}
								}
								%>
				</select>
				��Ʒ����:
				<select name='Func_Corp_Id' style='width:150px;height:20px' onChange="doSelect()">
					<option value='9999' <%=currStatus.getFunc_Corp_Id().equals("9999")?"selected":""%>>ȫ��</option>
					<%
					if(null != Spa_Store_Type)
					{						
						Iterator typeiter = Spa_Store_Type.iterator();
						while(typeiter.hasNext())
						{
							SpaStoreOBean typeBean = (SpaStoreOBean)typeiter.next();						
					%>
								<option value='<%=typeBean.getSpa_Type()%>' <%=currStatus.getFunc_Corp_Id().equals(typeBean.getSpa_Type())?"selected":""%>><%=typeBean.getSpa_Type()%></option>
					<%						
						}
					}
					%>
				</select>
				��Ʒ���:
				<select name='Func_Type_Id' style='width:120px;height:20px' onChange="doSelect()">
					<option value='888' <%=currStatus.getFunc_Type_Id().equals("888")?"selected":""%>>ȫ��</option>
					<%
					if(null != Spa_Store_Mode)
					{						
						Iterator titer = Spa_Store_Mode.iterator();
						while(titer.hasNext())
						{
							SpaStoreOBean tBean = (SpaStoreOBean)titer.next();						
					%>
								<option value='<%=tBean.getSpa_Mode()%>' <%=currStatus.getFunc_Type_Id().equals(tBean.getSpa_Mode())?"selected":""%>><%=tBean.getSpa_Mode()%></option>
					<%						
						}
					}
					%>					
				</select>				
				<input id='BDate' name='BDate' type='text' style='width:90px;height:18px;' value='<%=BDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
				-
				<input id='EDate' name='EDate' type='text' style='width:90px;height:18px;' value='<%=EDate%>' onClick='WdatePicker({readOnly:true})' class='Wdate' maxlength='10'>
			</td>
			<td width='30%' align='right'>
				<img id="img1" src="../skin/images/mini_button_search.gif" onClick='doSelect()' style="cursor:hand;">			
				<img id="img1" src="../skin/images/pldr.gif" onClick='doAllAdd()' style="cursor:hand;display:<Limit:limitValidate userrole='<%=FpList%>' fpid='140302' ctype='1'/>">
			</td>
		</tr>
		
		<tr height='30' valign='middle'>
			<td width='100%' align='center' colspan='2'>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
					<tr height='25' valign='middle'>
						<td width='5%'  align='center' class="table_deep_blue">���</td>
						<td width='15%' align='center' class="table_deep_blue">��Ʒ����</td>
						<td width='15%' align='center' class="table_deep_blue">����ͺ�</td>
						<td width='5%' align='center' class="table_deep_blue">��λ</td>
						<td width='5%' align='center' class="table_deep_blue">��������</td>
						<td width='5%' align='center' class="table_deep_blue">����</td>
						<td width='5%' align='center' class="table_deep_blue">���</td>					
						<td width='10%' align='center' class="table_deep_blue">����ʱ��</td>
						<td width='10%' align='center' class="table_deep_blue">���ϵ�λ</td>
						<td width='8%' align='center' class="table_deep_blue">������Ա</td>
						<td width='7%' align='center' class="table_deep_blue">������Ա</td>
						<td width='10%' align='center' class="table_deep_blue">��ע</td>
					</tr>
					<%
					if(Spa_Store_O != null)
					{
						Iterator iterator = Spa_Store_O.iterator();
						while(iterator.hasNext())
						{
							SpaStoreOBean Bean = (SpaStoreOBean)iterator.next();							
							String SN            = Bean.getSN();
							String Spa_Type = Bean.getSpa_Type();
							String Spa_Mode      = Bean.getSpa_Mode();
							String Unit      = Bean.getUnit();
							String Spa_Num      = Bean.getSpa_Num();
							String Spa_Price      = Bean.getSpa_Price();
							String Spa_Amt      = Bean.getSpa_Amt();
							String CTime      = Bean.getCTime();
							String Spa_Memo      = Bean.getSpa_Memo();
							String Cpm_Id      = Bean.getCpm_Id();
							String Spa_O_Oper     = Bean.getSpa_O_Oper();
							String OperatorL      = Bean.getOperator();
							sn++;
					%>
						  <tr <%=((sn%2)==0?"class='table_blue'":"class='table_white_l'")%>>
								<td align=center><%=sn%></td>
								<td align=center><%=Spa_Type%>&nbsp;</td>
						    <td align=center><%=Spa_Mode%>&nbsp;</td>
						    <td align=center><%=Unit%>&nbsp;</td>
						    <td align=center><%=Spa_Num%>&nbsp;</td>
						    <td align=center><%=Spa_Price%>&nbsp;</td> 
						    <td align=center><%=Spa_Amt%>&nbsp;</td>						    
						    <td align=center><%=CTime%>&nbsp;</td>
						    <td align=center ><%=Cpm_Id%>&nbsp;</td>	
						    <td align=center><%=Spa_O_Oper%>&nbsp;</td>
						    <td align=center><%=OperatorL%>&nbsp;</td>
						    <td align=center><%=Spa_Memo%>&nbsp;</td>				    	
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
				      	<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
				      </tr>  
					<%
						}
					  else
					  {
					%>				
		          <tr <%=((i%2)==0?"class='table_white_l'":"class='table_blue'")%>>
			          <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
			        </tr>      
					<%
       			}
     			}
					%> 
     		 	<tr>
						<td colspan="11" class="table_deep_blue" >
				 			<table width="100%" height="20"  border="0" cellpadding="0" cellspacing="0" >
			    			<tr valign="bottom">
			      			<td nowrap><%=currStatus.GetPageHtml("Spa_Store_O")%></td>
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

//window.parent.frames.lFrame.document.getElementById('CurrJsp').innerText = 'Spa_Store_O.jsp';

function doSelect()
{
	var days = new Date(Spa_Store_O.EDate.value.replace(/-/g, "/")).getTime() - new Date(Spa_Store_O.BDate.value.replace(/-/g, "/")).getTime();
	/**var dcnt = parseInt(days/(1000*60*60*24));
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
	Spa_Store_O.Cpm_Id.value = Spa_Store_O.Func_Cpm_Id.value;
	Spa_Store_O.BTime.value = Spa_Store_O.BDate.value;
	Spa_Store_O.ETime.value = Spa_Store_O.EDate.value;
	Spa_Store_O.submit();
}

function GoPage(pPage)
{
	var days = new Date(Spa_Store_O.EDate.value.replace(/-/g, "/")).getTime() - new Date(Spa_Store_O.BDate.value.replace(/-/g, "/")).getTime();
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
	Spa_Store_O.Cpm_Id.value = Spa_Store_O.Func_Cpm_Id.value;
	Spa_Store_O.BTime.value = Spa_Store_O.BDate.value;
	Spa_Store_O.ETime.value = Spa_Store_O.EDate.value;
	Spa_Store_O.CurrPage.value = pPage;
	Spa_Store_O.submit();
}

function doAdd()
{
	location = "Spa_Store_O_Add.jsp?Sid=<%=Sid%>";
}

function doEdit(pSN, pSpa_O_Time)
{
	if('<Limit:limitValidate userrole='<%=FpList%>' fpid='140404' ctype='1'/>' == 'none')
	{
		alert('����Ȩ�����ϳ����¼!');
		return;
	}
	
	var TDay = new Date().format("yyyy-MM-dd");
	if(pSpa_O_Time != TDay)
	{
		alert('ֻ�ɲ���������ˮ��¼!');
		return;
	}
	
	var diag = new Dialog();
	diag.Top = "50%";
	diag.Width = 400;
	diag.Height = 140;
	diag.Title = "��¼����";
	diag.URL = "Spa_Store_O_Edt.jsp?Sid=<%=Sid%>&SN=" + pSN;
	diag.show();
}

var req = null;
function doExport()
{
	var days = new Date(Spa_Store_O.EDate.value.replace(/-/g, "/")).getTime() - new Date(Spa_Store_O.BDate.value.replace(/-/g, "/")).getTime();
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
		var url = "Spa_Store_O_Export.do?Sid=<%=Sid%>&BTime=<%=currStatus.getVecDate().get(0).toString().substring(0,10)%>&ETime=<%=currStatus.getVecDate().get(1).toString().substring(0,10)%>&CurrPage=<%=currStatus.getCurrPage()%>&Func_Corp_Id=<%=currStatus.getFunc_Corp_Id()%>&Func_Sel_Id=<%=currStatus.getFunc_Sel_Id()%>&Func_Sub_Id=<%=currStatus.getFunc_Sub_Id()%>";
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
function doAllAdd()
{
	var Pdiag = new Dialog();
	Pdiag.Top = "50%";
	Pdiag.Width = 500;
	Pdiag.Height = 120;
	Pdiag.Title = "��Ʒ�������⵼��";
	Pdiag.URL = 'Spa_Store_O_File.jsp?Sid=<%=Sid%>&Func_Corp_Id=9999&Func_Sub_Id=9';
	Pdiag.show();

}

</SCRIPT>
</html>