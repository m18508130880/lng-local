<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="bean.*"%>
<%@ page import="util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>�к���LNG����վ��˾����Ϣ������ƽ̨</title>
<meta http-equiv="x-ua-compatible" content="ie=7"/>
<link type="text/css" href="../skin/css/style.css" rel="stylesheet"/>
<script type="text/javascript" src="../skin/js/util.js"></script>
<script language=javascript>document.oncontextmenu=function(){window.event.returnValue=false;};</script>
</head>
<%
	
	String Sid    = CommUtil.StrToGB2312(request.getParameter("Sid"));
	String Crm_Id = CommUtil.StrToGB2312(request.getParameter("Crm_Id"));
	String Cmd    = CommUtil.StrToGB2312(request.getParameter("Cmd"));
 	String Id     = CommUtil.StrToGB2312(request.getParameter("Id"));
 	
	CurrStatus currStatus  = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	CorpInfoBean Corp_Info = (CorpInfoBean)session.getAttribute("Corp_Info_" + Sid);
	ArrayList Ccm_Info     = (ArrayList)session.getAttribute("Ccm_Info_" + Sid);
	String Car_Info = "";
	if(null != Corp_Info)
	{
		Car_Info = Corp_Info.getCar_Info();
		if(null == Car_Info)
		{
			Car_Info = "";
		}
	}
 	
  String CType  = "";
	String Owner  = "";
	String Bottle = "";
	if(Ccm_Info != null && Cmd.equals("11"))
	{
		Iterator iterator = Ccm_Info.iterator();
		while(iterator.hasNext())
		{
			CcmInfoBean statBean = (CcmInfoBean)iterator.next();
			if(statBean.getId().equals(Id))
			{
				CType  = statBean.getCType();
				Owner  = statBean.getOwner();
				Bottle = statBean.getBottle();
			}
		}
 	}
 	
%>
<body style="background:#CADFFF">
<form name="Ccm_Info_Edit" action="Ccm_Info.do" method="post" target="_self">
	<br><br><br>
	<table width="80%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">
		<tr height='30'>
			<td width='100%' align='center'>
				<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
					<tr height='40px'>
						<td width='20%' align='center'>�����ƺ�</td>
						<td width='30%' align='left'>
							<%
							if(Cmd.equals("10"))
							{
							%>
								<select name="Car_Id" style="width:65%;height:20px">
									<option value='-1'>====�㶫ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-' selected>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='��S-'>��S-</option>
									<option value='��T-'>��T-</option>
									<option value='��U-'>��U-</option>
									<option value='��V-'>��V-</option>
									<option value='-1'>====�ӱ�ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='��S-'>��S-</option>
									<option value='��T-'>��T-</option>
									<option value='-1'>====����ʡ(ԥ)====</option>
									<option value='ԥA-'>ԥA-</option>
									<option value='ԥB-'>ԥB-</option>
									<option value='ԥC-'>ԥC-</option>
									<option value='ԥD-'>ԥD-</option>
									<option value='ԥE-'>ԥE-</option>
									<option value='ԥF-'>ԥF-</option>
									<option value='ԥG-'>ԥG-</option>
									<option value='ԥH-'>ԥH-</option>
									<option value='ԥJ-'>ԥJ-</option>
									<option value='ԥK-'>ԥK-</option>
									<option value='ԥL-'>ԥL-</option>
									<option value='ԥM-'>ԥM-</option>
									<option value='ԥN-'>ԥN-</option>
									<option value='ԥP-'>ԥP-</option>
									<option value='ԥQ-'>ԥQ-</option>
									<option value='ԥR-'>ԥR-</option>
									<option value='ԥS-'>ԥS-</option>
									<option value='-1'>====����ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='��S-'>��S-</option>								
									<option value='-1'>====����ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='-1'>====������ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='-1'>====����ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='-1'>====����ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='-1'>====ɽ��ʡ(³)====</option>
									<option value='³A-'>³A-</option>
									<option value='³B-'>³B-</option>
									<option value='³C-'>³C-</option>
									<option value='³D-'>³D-</option>
									<option value='³E-'>³E-</option>
									<option value='³F-'>³F-</option>
									<option value='³G-'>³G-</option>
									<option value='³H-'>³H-</option>
									<option value='³J-'>³J-</option>
									<option value='³K-'>³K-</option>
									<option value='³L-'>³L-</option>
									<option value='³M-'>³M-</option>
									<option value='³N-'>³N-</option>
									<option value='³P-'>³P-</option>
									<option value='³Q-'>³Q-</option>
									<option value='³R-'>³R-</option>
									<option value='³S-'>³S-</option>
									<option value='-1'>====�½�ά���(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='-1'>====����ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='-1'>====�㽭ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='-1'>====����ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='-1'>====����ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='-1'>====����׳��(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='-1'>====����ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='-1'>====ɽ��ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='-1'>====���ɹ�(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='-1'>====����ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='-1'>====����ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='-1'>====����ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='-1'>====����ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='-1'>====�Ĵ�ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='��J-'>��J-</option>
									<option value='��K-'>��K-</option>
									<option value='��L-'>��L-</option>
									<option value='��M-'>��M-</option>
									<option value='��N-'>��N-</option>
									<option value='��P-'>��P-</option>
									<option value='��Q-'>��Q-</option>
									<option value='��R-'>��R-</option>
									<option value='��S-'>��S-</option>
									<option value='��T-'>��T-</option>
									<option value='��U-'>��U-</option>
									<option value='��V-'>��V-</option>
									<option value='��W-'>��W-</option>
									<option value='-1'>====�ຣʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='-1'>====����(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='-1'>====����ʡ(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='-1'>====���Ļ���(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='-1'>====������(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��F-'>��F-</option>
									<option value='��G-'>��G-</option>
									<option value='��H-'>��H-</option>
									<option value='-1'>====������(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='-1'>====�����(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
									<option value='��E-'>��E-</option>
									<option value='-1'>====�Ϻ���(��)====</option>
									<option value='��A-'>��A-</option>
									<option value='��B-'>��B-</option>
									<option value='��C-'>��C-</option>
									<option value='��D-'>��D-</option>
								</select>
								<input type='text' name='Car_Id_Num' style='width:29%;height:16px;' value='' maxlength='5'>
							<%
							}
							else
							{
							%>
								<%=Id%>
							<%
							}
							%>
						</td>
						<td width='20%' align='center'>��������</td>
						<td width='30%' align='left'>
							<select name="CType" style="width:99%;height:20px">
							<%
							if(Car_Info.trim().length() > 0)
							{
								String[] CarList = Car_Info.split(";");
								for(int i=0; i<CarList.length && CarList[i].length()>0; i++)
								{
									String[] subCarList = CarList[i].split(",");
							%>
									<option value='<%=subCarList[0]%>' <%=subCarList[0].equals(CType)?"selected":""%>><%=subCarList[1]%></option>
							<%
								}
							}
							%>
							</select>
						</td>
					</tr>
					<tr height='40px'>
						<td width='20%' align='center'>����˾��</td>
						<td width='30%' align='left'>
							<input type='text' name='Owner'  style='width:97%;height:18px;' value='<%=Owner%>'  maxlength='10'>
						</td>
						<td width='20%' align='center'>����ƿ��</td>
						<td width='30%' align='left'>
							<input type='text' name='Bottle' style='width:97%;height:18px;' value='<%=Bottle%>' maxlength='20'>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr height='40px'>
			<td width='100%' align='center'>
				<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doEdit()'>
				<img src="../skin/images/button10.gif"           style='cursor:hand;' onclick='doNO()'>
			</td>
		</tr>
	</table>
	<input name="Cmd"         type="hidden" value="<%=Cmd%>">
	<input name="Sid"         type="hidden" value="<%=Sid%>">
	<input name="Crm_Id"      type="hidden" value="<%=Crm_Id%>">
	<input name="Id"          type="hidden" value="<%=Id%>">
	<input name="Func_Sub_Id" type="hidden" value="<%=currStatus.getFunc_Sub_Id()%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doNO()
{
	
	location = "Ccm_Info.jsp?Sid=<%=Sid%>&Crm_Id=<%=Crm_Id%>";
}

function doEdit()
{
	
	switch(parseInt(<%=Cmd%>))
	{
		case 10:
				if(Ccm_Info_Edit.Car_Id.value.length < 1 || Ccm_Info_Edit.Car_Id.value == '-1')
			  {
			  	alert('��ѡ�������ڵ�!');
			  	return;
			  }
			  if(Ccm_Info_Edit.Car_Id_Num.value.Trim().length != 5)
			  {
			  	alert('����β����д����!');
			  	return;
			  }
			  Ccm_Info_Edit.Id.value = Ccm_Info_Edit.Car_Id.value + Ccm_Info_Edit.Car_Id_Num.value;
			break;
		case 11:
				Ccm_Info_Edit.Id.value = '<%=Id%>';
			break;
	}
	if(Ccm_Info_Edit.Id.value.Trim().length != 8)
	{
		alert('�����ƺ���д����!');
		return;
	}
	if(Ccm_Info_Edit.CType.value.length < 1)
  {
  	
  	alert('��ѡ��������!');
  	return;
  }
  if(Ccm_Info_Edit.Owner.value.Trim().length < 1)
  {
  	alert('����д����˾������!');
  	return;
  }
  if(Ccm_Info_Edit.Bottle.value.Trim().length < 1)
  {
  	alert('����д����ƿ��!');
  	return;
  }
  if(confirm("��Ϣ����,ȷ���ύ?"))
  {
  	Ccm_Info_Edit.submit();
  }
}
</SCRIPT>
</html>