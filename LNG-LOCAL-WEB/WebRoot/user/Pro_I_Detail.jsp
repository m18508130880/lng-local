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
</head>
<%	
	String Sid = CommUtil.StrToGB2312(request.getParameter("Sid"));
	CurrStatus currStatus = (CurrStatus)session.getAttribute("CurrStatus_" + Sid);
	String BDate = CommUtil.getDate();
	
	ArrayList User_Manage_Role   = (ArrayList)session.getAttribute("User_Manage_Role_" + Sid);
	ArrayList User_Device_Detail = (ArrayList)session.getAttribute("User_Device_Detail_" + Sid);
  UserInfoBean UserInfo = (UserInfoBean)session.getAttribute("UserInfo_" + Sid);
  String Operator = UserInfo.getId();
  String Operator_Name = UserInfo.getCName();
  String ManageId = UserInfo.getManage_Role();
  
  ArrayList Pro_R_Buss = (ArrayList)session.getAttribute("Pro_R_Buss_" + Sid);
  CorpInfoBean Corp_Info = (CorpInfoBean)session.getAttribute("User_Corp_Info_" + Sid);
	String Oil_Info = "";
	if(null != Corp_Info)
	{
		Oil_Info = Corp_Info.getOil_Info();
		if(null == Oil_Info){Oil_Info = "";}
	}
	 
  
  ArrayList Pro_I = (ArrayList)session.getAttribute("Pro_I_" + Sid);
  String SN = request.getParameter("SN");

	 String Cpm_Id= "";
	 String Cpm_Name= "";
	 String CTime= "";
	 String Order_Id= "";
	 String Order_Value= "";
	 String Value= "";
	 String Value_Gas= "";
	 String Car_Id= "";
	 String Car_Owner= "";
	 String Memo= "";
	 String Status= "";
	 String Oil_CType= "";
	 String Oil_CName = "��";
	 String Worker= "";
	 String Checker= "";
	 String Checker_Name= "";
	 String Car_Corp= "";

	 String Tank_No= "";         //���޹޺�
	 String Pre_Check= "";   		//ж��ǰ���
	 String Pro_Check= "";   		//ж�����̼��
	 String Lat_Check= ""; 			//ж������
	 String Pre_Tank_V= "";			//ж��ǰ����
	 String Lat_Tank_V= "";			//ж�������
	 String Pre_Temper= "";			//ж��ǰ�¶�
	 String Lat_Temper= "";			//ж�����¶�
	 String Pre_Press= ""; 			//ж��ǰѹ��
	 String Lat_Press= ""; 			//ж����ѹ��
	 String Pre_Weight= "";			//ж��ǰ����
	 String Lat_Weight= "";			//ж��������
	 String Unload= "";      		//ж������
	 String Gross_Weight= "";		//װ��ë��
	 String Tear_Weight= ""; 		//װ��Ƥ��
	 String Ture_Weight= ""; 		//װ������
	 String Trailer_No= "";  		//�ҳ�����
	 String Forward_Unit= "";		//������λ
	 String Temper_Report= "";   //���ʱ��浥��
	 String Arrive_Time= "";     //��վʱ��
	 String Depart_Time= "";     //��վʱ��
	 
	 if(Pro_I != null)
	{
		Iterator iterator = Pro_I.iterator();
		while(iterator.hasNext())
		{
			ProIBean Bean = (ProIBean)iterator.next();
			if(Bean.getSN().equals(SN))
			{
				Cpm_Name    = Bean.getCpm_Name();
				Oil_CType = Bean.getOil_CType();
				
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
	  		Cpm_Id					=	Bean.getCpm_Id();
	  		Cpm_Name				=	Bean.getCpm_Name();
	  		CTime						=	Bean.getCTime();
	  		Order_Id				=	Bean.getOrder_Id();
	  		Order_Value			=	Bean.getOrder_Value();
	  		Value						=	Bean.getValue();
	  		Value_Gas				= Bean.getValue_Gas();
	  		Car_Id					= Bean.getCar_Id();
	  		Car_Owner				= Bean.getCar_Owner();
	  		Operator				= Bean.getOperator();
	  		Operator_Name		= Bean.getOperator_Name();
	  		Memo						= Bean.getMemo();
	  		Status					= Bean.getStatus();
	  		Oil_CType				= Bean.getOil_CType();
	  		Worker					= Bean.getWorker();
	  		Checker					= Bean.getChecker();
	  		Checker_Name		= Bean.getChecker_Name();
	  		Car_Corp				= Bean.getCar_Corp();

	  		Tank_No					= Bean.getTank_No();     		//���޹޺�
	  		Pre_Check				= Bean.getPre_Check();   		//ж��ǰ���
	  		Pro_Check				= Bean.getPro_Check();   		//ж�����̼��
	 			Lat_Check				= Bean.getLat_Check(); 			//ж������
	 			Pre_Tank_V			= Bean.getPre_Tank_V();			//ж��ǰ����
	 			Lat_Tank_V			= Bean.getLat_Tank_V();			//ж�������
	 			Pre_Temper			= Bean.getPre_Temper();			//ж��ǰ�¶�
	 			Lat_Temper			= Bean.getLat_Temper();			//ж�����¶�
	 			Pre_Press				= Bean.getPre_Press(); 			//ж��ǰѹ��
	 			Lat_Press				= Bean.getLat_Press(); 			//ж����ѹ��
	 			Pre_Weight			= Bean.getPre_Weight();			//ж��ǰ����
	 			Lat_Weight			= Bean.getLat_Weight();			//ж��������
	 			Unload					= Bean.getUnload();     		//ж������
	 			Gross_Weight		= Bean.getGross_Weight();		//װ��ë��
	 			Tear_Weight			= Bean.getTear_Weight(); 		//װ��Ƥ��
	 			Ture_Weight			= Bean.getTure_Weight(); 		//װ������
	 			Trailer_No			= Bean.getTrailer_No();  		//�ҳ�����
	 			Forward_Unit		= Bean.getForward_Unit();		//������λ
	 			Temper_Report		= Bean.getTemper_Report();  //���ʱ��浥��
	 			Arrive_Time			= Bean.getArrive_Time();    //��վʱ��
	 			Depart_Time			= Bean.getDepart_Time();    //��վʱ��
			
				
			}
		}
 	}  	
%>
<body style="background:#CADFFF">
<form name="Pro_I_Detail" action="Pro_I.do" method="post" target="mFrame">
<div id="down_bg_2">
	<div id="cap"><img src="../skin/images/pro_i_Detail.gif"></div><br><br>
	<div id="right_table_center">
		<table width="60%" style='margin:auto;' border=0 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">			
			<tr>
				<td align='right'>
					<img src="../skin/images/mini_button_submit.gif" style='cursor:hand;' onClick='doEdit()'>
					<img id="img2" src="../skin/images/excel.gif"   onClick='doExport()'  >
					</td>
				</tr>
			<tr height='30'>
				<td width='100%' align='center'>
					<table width="100%" border=1 cellPadding=0 cellSpacing=0 bordercolor="#3491D6" borderColorDark="#ffffff">		
						<tr height='30'>
							  <td width='15%' align='center'>ж��վ��</td>
								<td width='35%' align='left' ><%=Cpm_Name%></td>
								<td width='15%' align='center'>ж��޺�</td>
							  <td width='35%' align='left'><%= Tank_No%></td>				
						</tr>
					  <tr height='30'>
					  	  <td width='15%' align='center'>ж������</td>
								<td width='35%' align='left'><%= Order_Id%></td>
								<td width='15%' align='center'>��ʼж��ʱ��</td>
								<td width='35%' align='left'><%= CTime%></td>
						</tr>
						<tr height='30'>
							<td width='15%' align='center'>ж��ǰ���</td>						
							<td width='35%' align='left'>
								<input type='text' name='Pre_Check' style='width:80%;height:18px;' value='<%= Pre_Check%>' maxlength='20'>
							</td>
							<td width='15%' align='center'>װ��ë��</td>
                <td width='35%' align='left'>
                	<input type='text' name='Gross_Weight' style='width:80%;height:18px;' value='<%= Gross_Weight%>' maxlength='20'>
                	Kg</td>
							</td>
						</tr>
						<tr height='30'>
							<td width='15%' align='center'>ж�����̼��</td>
							<td width='35%' align='left'>
								<input type='text' name='Pro_Check' style='width:80%;height:18px;' value='<%= Pro_Check%>' maxlength='20'>
								</td>
							<td width='15%' align='center'>װ��Ƥ��</td>
							<td width='35%' align='left'>
								<input type='text' name='Tear_Weight' style='width:80%;height:18px;' value='<%= Tear_Weight%>' maxlength='20'>
								Kg</td>
						</tr>
						<tr height='30'>
							<td width='15%' align='center'>ж������</td>
							<td width='35%' align='left'>
								<input type='text' name='Lat_Check' style='width:80%;height:18px;' value='<%= Lat_Check%>' maxlength='20'>
							</td>
							<td width='15%' align='center'>װ������</td>
							<td width='35%' align='left'>
								<input type='text' name='Ture_Weight' style='width:80%;height:18px;' value='<%= Ture_Weight%>' maxlength='20'>
								Kg</td>
						</tr>
						<tr height='30'>
							<td width='15%' align='center'>ж��ǰ����</td>
							<td width='35%' align='left'>
								<input type='text' name='Pre_Tank_V' style='width:80%;height:18px;' value='<%= Pre_Tank_V%>' maxlength='20'>
								L</td>
							<td width='15%' align='center'>���䳵��</td>
							<td width='35%' align='left'><%= Car_Id%></td>
						</tr>
						<tr height='30'>
							<td width='15%' align='center'>ж�������</td>
							<td width='35%' align='left'>
								<input type='text' name='Lat_Tank_V' style='width:80%;height:18px;' value='<%= Lat_Tank_V%>' maxlength='20'>
								L</td>
							<td width='15%' align='center'>�ҳ�����</td>
							<td width='35%' align='left'><%= Trailer_No%></td>
						<tr height='30'>
							<td width='15%' align='center'>ж���ݻ�</td>
							<td width='35%' align='left'>
								<input type='text' name='Unload' style='width:80%;height:18px;' value='<%= Unload%>' maxlength='20'>
								L</td>
							<td width='15%' align='center'>���˵�λ</td>
							<td width='35%' align='left'><%= Car_Corp%></td>	
						</tr>
						<tr height='30'>
							<td width='15%' align='center'>ж��ǰ�¶�</td>
							<td width='35%' align='left'>
								<input type='text' name='Pre_Temper' style='width:80%;height:18px;' value='<%= Pre_Temper%>' maxlength='20'>
								��</td>
							<td width='15%' align='center'>�۳�˾��</td>
							<td width='35%' align='left'><%= Car_Owner%></td>
						</tr>
						<tr height='30'>
							<td width='15%' align='center'>ж�����¶�</td>
							<td width='35%' align='left'>
								<input type='text' name='Lat_Temper' style='width:80%;height:18px;' value='<%= Lat_Temper%>' maxlength='20'>
								��</td>
							<td width='15%' align='center'>������λ</td>
							<td width='35%' align='left'><%= Forward_Unit%></td>
						</tr>
						<tr height='30'>
							<td width='15%' align='center'>ж��ǰѹ��</td>
							<td width='35%' align='left'>
								<input type='text' name='Pre_Press' style='width:80%;height:18px;' value='<%= Pre_Press%>' maxlength='20'>
								MPa</td>
							<td width='15%' align='center'>ȼ������</td>
							<td width='35%' align='left'><%= Oil_CName%></td>
						</tr>
						<tr height='30'>
							<td width='15%' align='center'>ж����ѹ��</td>
							<td width='35%' align='left'>
								<input type='text' name='Lat_Press' style='width:80%;height:18px;' value='<%= Lat_Press%>' maxlength='20'>
								MPa</td>
							<td width='15%' align='center'>���ʱ��浥��</td>
							<td width='35%' align='left'><%= Temper_Report%></td>
						</tr>
						<tr height='30'>
							<td width='15%' align='center'>ж��ǰ����</td>
							<td width='35%' align='left'>
								<input type='text' name='Pre_Weight' style='width:80%;height:18px;' value='<%= Pre_Weight%>' maxlength='20'>
								Kg</td>
							<td width='15%' align='center'>��վʱ��</td>
							<td width='35%' align='left'><%= Arrive_Time%></td>
						</tr>
						<tr height='30'>
							<td width='15%' align='center'>ж��������</td>
							<td width='35%' align='left'>
								<input type='text' name='Lat_Weight' style='width:80%;height:18px;' value='<%= Lat_Weight%>' maxlength='20'>
								Kg</td>
							<td width='15%' align='center'>��վʱ��</td>
							<td width='35%' align='left'><%= Depart_Time%></td>
						</tr>
						<tr height='30'>
							<td width='15%' align='center'>ж������</td>
							<td width='35%' align='left'>
								<input type='text' name='Value' style='width:80%;height:18px;' value='<%= Value%>' maxlength='20'>
								Kg</td>
							<td width='15%' align='center'>��ҵ��Ա</td>
							<td width='35%' align='left'><%= Worker%></td>
						</tr>
						<tr height='30'>
							<td width='15%' align='center'>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ע</td>
							<td width='35%' align='left' colspan='3'>&nbsp;<%= Memo%></td>
						</tr>
						
					</table>
				</td>
			</tr>			
		</table>
	</div>
</div>
<input name="SN" type="hidden" value="<%=SN%>" />
<input name="Cmd"      type="hidden" value="12">
<input name="Sid"      type="hidden" value="<%=Sid%>">
<input name="Cpm_Id"      type="hidden" value="<%=Cpm_Id%>">
</form>
</body>
<SCRIPT LANGUAGE=javascript>
function doEdit()
{
		Pro_I_Detail.submit();
}



function doExport()
{	
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
		var url = "Pro_I_Detail_Export.do?Cmd=5&Sid=<%=Sid%>&SN="+Pro_I_Detail.SN.value;
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