package servlet;

import java.io.IOException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import rmi.*;
import util.*;
import bean.*;

////0ȫ����ѯ 2���� 3�޸� 4ɾ�� 10��19������ѯ
public class MainServlet extends HttpServlet
{
	public final static long serialVersionUID = 1000;
	private Rmi m_Rmi = null;
	private String rmiUrl = null;
	private Connect connect = null;
	public ServletConfig Config;
	
	public final ServletConfig getServletConfig() 
	{
		return Config;
	}
	
	public void init(ServletConfig pConfig) throws ServletException
	{	
		Config = pConfig;
		connect = new Connect();
		connect.config = pConfig;
		connect.ReConnect();
	}		
    protected void doGet(HttpServletRequest request,
        HttpServletResponse response) throws ServletException, IOException
    {
        this.processRequest(request, response);
    }
    protected void doPost(HttpServletRequest request,
        HttpServletResponse response) throws ServletException, IOException
    {
        this.processRequest(request, response);
    }
    protected void doPut(HttpServletRequest request,
        HttpServletResponse response) throws ServletException, IOException
    {
        this.processRequest(request, response);
    }
    protected void doTrace(HttpServletRequest request,
        HttpServletResponse response) throws ServletException, IOException
    {
        this.processRequest(request, response);
    }
    

    protected void processRequest(HttpServletRequest request,
        HttpServletResponse response) throws ServletException, IOException
    {
    	if(connect.Test()== false)
    	{   
    		request.getSession().setAttribute("ErrMsg", CommUtil.StrToGB2312("RMI�����δ�������У��޷���½��"));
    		response.sendRedirect(getUrl(request) + "error.jsp");
    		return;
    	}
    	
        response.setContentType("text/html; charset=gb2312");
        String strUrl = request.getRequestURI();
        String strSid = request.getParameter("Sid");
        String[] str = strUrl.split("/");
        strUrl = str[str.length - 1];
        
        System.out.println("Sid:" + strSid);
        System.out.println("====================" + strUrl);
        
        //��ҳ
        if(strUrl.equals("index.do"))
        {
        	CheckCode.CreateCheckCode(request, response, strSid);
        	return;
        }
        else if(strUrl.equalsIgnoreCase("AdminILogout.do"))                      //�ڶ���:admin��ȫ�˳�
        {
        	request.getSession().removeAttribute("CurrStatus_" + strSid);
        	request.getSession().removeAttribute("Admin_" + strSid);
        	request.getSession().removeAttribute("Corp_Info_" + strSid);
        	request.getSession().removeAttribute("Device_Detail_" + strSid);
        	request.getSession().removeAttribute("User_Info_" + strSid);
        	request.getSession().removeAttribute("User_Stat_" + strSid);
        	request.getSession().removeAttribute("FP_Role_" + strSid);
        	request.getSession().removeAttribute("Manage_Role_" + strSid);
        	request.getSession().removeAttribute("FP_Info_" + strSid);
        	request.getSession().removeAttribute("Aqsc_Exam_Type_" + strSid);
        	request.getSession().removeAttribute("Aqsc_Danger_Type_" + strSid);
        	request.getSession().removeAttribute("Aqsc_Danger_Level_" + strSid);
        	request.getSession().removeAttribute("User_Position_" + strSid);
        	request.getSession().removeAttribute("Aqsc_Train_Type_" + strSid);
        	request.getSession().removeAttribute("Aqsc_Drill_Type_" + strSid);
        	request.getSession().removeAttribute("Aqsc_Card_Type_" + strSid);
        	request.getSession().removeAttribute("Aqsc_Act_Type_" + strSid);
        	request.getSession().removeAttribute("Aqsc_Labour_Type_" + strSid);
        	request.getSession().removeAttribute("Aqsc_Device_Breed_" + strSid);
        	request.getSession().removeAttribute("Aqsc_Device_Type_" + strSid);
        	request.getSession().removeAttribute("Aqsc_Device_Card_" + strSid);
        	request.getSession().removeAttribute("Aqsc_Spare_Type_" + strSid);
        	request.getSession().removeAttribute("Crm_Info_" + strSid);
        	request.getSession().removeAttribute("Ccm_Info_" + strSid);
        	//request.getSession().invalidate();
        	response.getWriter().write("<script language = javascript>window.parent.location.href='../index.jsp'</script>");
        }
        else if(strUrl.equalsIgnoreCase("ILogout.do"))                           //�ڶ���:user��ȫ�˳�
        {
        	request.getSession().removeAttribute("CurrStatus_" + strSid);
        	request.getSession().removeAttribute("UserInfo_" + strSid);
        	request.getSession().removeAttribute("User_Corp_Info_" + strSid);
        	request.getSession().removeAttribute("User_Device_Detail_" + strSid);
        	request.getSession().removeAttribute("User_Data_Device_" + strSid);
        	request.getSession().removeAttribute("User_Data_Attr_" + strSid);
        	request.getSession().removeAttribute("User_User_Info_" + strSid);
        	request.getSession().removeAttribute("User_FP_Role_" + strSid);
        	request.getSession().removeAttribute("User_Manage_Role_" + strSid);
        	request.getSession().removeAttribute("Env_" + strSid);
        	request.getSession().removeAttribute("Env_His_" + strSid);
        	request.getSession().removeAttribute("Week_" + strSid);
        	request.getSession().removeAttribute("Month_" + strSid);
        	request.getSession().removeAttribute("Year_" + strSid);
        	request.getSession().removeAttribute("Graph_" + strSid);
        	request.getSession().removeAttribute("Alarm_Info_" + strSid);
        	request.getSession().removeAttribute("Alert_Info_" + strSid);    	
        	request.getSession().removeAttribute("Pro_R_" + strSid);       	
        	request.getSession().removeAttribute("Pro_R_Buss_" + strSid);
        	request.getSession().removeAttribute("Pro_R_Type_" + strSid);
        	request.getSession().removeAttribute("Pro_I_" + strSid);
        	request.getSession().removeAttribute("Pro_O_" + strSid);
        	request.getSession().removeAttribute("Pro_L_" + strSid);
        	request.getSession().removeAttribute("Pro_Y_" + strSid);
        	request.getSession().removeAttribute("Pro_L_W_" + strSid);
        	request.getSession().removeAttribute("Pro_Y_W_" + strSid);
        	request.getSession().removeAttribute("Pro_C_W_" + strSid);
        	request.getSession().removeAttribute("Pro_L_D_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crm_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_M_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_M_C_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_M_Y_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_Y_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_Y_C_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_W_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_W_C_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_W_Y_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_D_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_D_Crm_" + strSid);
        	request.getSession().removeAttribute("BYear_" + strSid);
        	request.getSession().removeAttribute("BMonth_" + strSid);
        	request.getSession().removeAttribute("BWeek_" + strSid);
        	request.getSession().removeAttribute("EYear_" + strSid);
        	request.getSession().removeAttribute("EMonth_" + strSid);
        	request.getSession().removeAttribute("EWeek_" + strSid);
        	request.getSession().removeAttribute("BDate_" + strSid);
        	request.getSession().removeAttribute("EDate_" + strSid);
        	request.getSession().removeAttribute("Pro_G_" + strSid);
        	request.getSession().removeAttribute("Sat_Check_" + strSid);
        	request.getSession().removeAttribute("Sat_Check_Type_" + strSid);
        	request.getSession().removeAttribute("Sat_Danger_" + strSid);
        	request.getSession().removeAttribute("Sat_Danger_Type_" + strSid);
        	request.getSession().removeAttribute("Sat_Danger_Level_" + strSid);
        	request.getSession().removeAttribute("Sat_Break_" + strSid);
        	request.getSession().removeAttribute("Sat_Train_" + strSid);
        	request.getSession().removeAttribute("Sat_Train_Type_" + strSid);
        	request.getSession().removeAttribute("Sat_Drill_" + strSid);
        	request.getSession().removeAttribute("Sat_Drill_Type_" + strSid);
        	request.getSession().removeAttribute("Sat_Check_L_" + strSid);
        	request.getSession().removeAttribute("Sat_Train_L_" + strSid);
        	request.getSession().removeAttribute("Sat_Drill_L_" + strSid);
        	request.getSession().removeAttribute("Cad_Status_" + strSid);
        	request.getSession().removeAttribute("Cad_Status_Type_" + strSid);
        	request.getSession().removeAttribute("Cad_Status_Position_" + strSid);
        	request.getSession().removeAttribute("Cad_Remind_" + strSid);
        	request.getSession().removeAttribute("Cad_Action_" + strSid);
        	request.getSession().removeAttribute("Cad_Action_Type_" + strSid);
        	request.getSession().removeAttribute("Lab_Store_" + strSid);
        	request.getSession().removeAttribute("Lab_Store_Type_" + strSid);
        	request.getSession().removeAttribute("Lab_Store_I_" + strSid);
        	request.getSession().removeAttribute("Lab_Store_IN_" + strSid);
        	request.getSession().removeAttribute("Lab_Store_O_" + strSid);
        	request.getSession().removeAttribute("Dev_List_" + strSid);
        	request.getSession().removeAttribute("Dev_List_Breed_" + strSid);
        	request.getSession().removeAttribute("Dev_List_Type_" + strSid);
        	request.getSession().removeAttribute("Dev_List_Card_" + strSid);
        	request.getSession().removeAttribute("Dev_List_Card_List_" + strSid);
        	request.getSession().removeAttribute("Dev_Remind_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_Type_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_Log_" + strSid);
        	request.getSession().removeAttribute("Spa_Station_Log_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_I_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_IN_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_O_" + strSid);
        	request.getSession().removeAttribute("Spa_Station_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_L_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_L_Log_" + strSid);
        	request.getSession().removeAttribute("Spa_Station_L_" + strSid);
        	request.getSession().removeAttribute("Spa_Station_L_Log_" + strSid);
        	request.getSession().removeAttribute("Fix_Trace_" + strSid);
        	request.getSession().removeAttribute("Fix_Ledger_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_All_" + strSid);
        	request.getSession().removeAttribute("Spa_Station_All_" + strSid);
        	//request.getSession().invalidate();
        	response.getWriter().write("<script language = javascript>window.parent.location.href='../index.jsp'</script>");
        }
        else if(strUrl.equalsIgnoreCase("IILogout.do"))                          //������:user��ȫ�˳�
        {
        	request.getSession().removeAttribute("CurrStatus_" + strSid);
        	request.getSession().removeAttribute("UserInfo_" + strSid);
        	request.getSession().removeAttribute("User_Corp_Info_" + strSid);
        	request.getSession().removeAttribute("User_Device_Detail_" + strSid);
        	request.getSession().removeAttribute("User_Data_Device_" + strSid);
        	request.getSession().removeAttribute("User_Data_Attr_" + strSid);
        	request.getSession().removeAttribute("User_User_Info_" + strSid);
        	request.getSession().removeAttribute("User_FP_Role_" + strSid);
        	request.getSession().removeAttribute("User_Manage_Role_" + strSid);
        	request.getSession().removeAttribute("Env_" + strSid);
        	request.getSession().removeAttribute("Env_His_" + strSid);
        	request.getSession().removeAttribute("Week_" + strSid);
        	request.getSession().removeAttribute("Month_" + strSid);
        	request.getSession().removeAttribute("Year_" + strSid);
        	request.getSession().removeAttribute("Graph_" + strSid);
        	request.getSession().removeAttribute("Alarm_Info_" + strSid);
        	request.getSession().removeAttribute("Alert_Info_" + strSid);
        	request.getSession().removeAttribute("Pro_R_" + strSid);
        	request.getSession().removeAttribute("Pro_R_Buss_" + strSid);
        	request.getSession().removeAttribute("Pro_R_Type_" + strSid);
        	request.getSession().removeAttribute("Pro_I_" + strSid);
        	request.getSession().removeAttribute("Pro_O_" + strSid);
        	request.getSession().removeAttribute("Pro_L_" + strSid);
        	request.getSession().removeAttribute("Pro_Y_" + strSid);
        	request.getSession().removeAttribute("Pro_L_W_" + strSid);
        	request.getSession().removeAttribute("Pro_Y_W_" + strSid);
        	request.getSession().removeAttribute("Pro_C_W_" + strSid);
        	request.getSession().removeAttribute("Pro_L_D_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crm_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_M_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_M_C_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_M_Y_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_Y_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_Y_C_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_W_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_W_C_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_W_Y_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_D_" + strSid);
        	request.getSession().removeAttribute("Pro_L_Crp_D_Crm_" + strSid);
        	request.getSession().removeAttribute("BYear_" + strSid);
        	request.getSession().removeAttribute("BMonth_" + strSid);
        	request.getSession().removeAttribute("BWeek_" + strSid);
        	request.getSession().removeAttribute("EYear_" + strSid);
        	request.getSession().removeAttribute("EMonth_" + strSid);
        	request.getSession().removeAttribute("EWeek_" + strSid);
        	request.getSession().removeAttribute("BDate_" + strSid);
        	request.getSession().removeAttribute("EDate_" + strSid);
        	request.getSession().removeAttribute("Pro_G_" + strSid);
        	request.getSession().removeAttribute("Sat_Check_" + strSid);
        	request.getSession().removeAttribute("Sat_Check_Type_" + strSid);
        	request.getSession().removeAttribute("Sat_Danger_" + strSid);
        	request.getSession().removeAttribute("Sat_Danger_Type_" + strSid);
        	request.getSession().removeAttribute("Sat_Danger_Level_" + strSid);
        	request.getSession().removeAttribute("Sat_Break_" + strSid);
        	request.getSession().removeAttribute("Sat_Train_" + strSid);
        	request.getSession().removeAttribute("Sat_Train_Type_" + strSid);       	
        	request.getSession().removeAttribute("Sat_Drill_" + strSid);
        	request.getSession().removeAttribute("Sat_Drill_Type_" + strSid);
        	request.getSession().removeAttribute("Sat_Check_L_" + strSid);
        	request.getSession().removeAttribute("Sat_Train_L_" + strSid);
        	request.getSession().removeAttribute("Sat_Drill_L_" + strSid);
        	request.getSession().removeAttribute("Cad_Status_" + strSid);
        	request.getSession().removeAttribute("Cad_Status_Type_" + strSid);
        	request.getSession().removeAttribute("Cad_Status_Position_" + strSid);
        	request.getSession().removeAttribute("Cad_Remind_" + strSid);
        	request.getSession().removeAttribute("Cad_Action_" + strSid);
        	request.getSession().removeAttribute("Cad_Action_Type_" + strSid);
        	request.getSession().removeAttribute("Lab_Store_" + strSid);
        	request.getSession().removeAttribute("Lab_Store_Type_" + strSid);
        	request.getSession().removeAttribute("Lab_Store_I_" + strSid);
        	request.getSession().removeAttribute("Lab_Store_IN_" + strSid);
        	request.getSession().removeAttribute("Lab_Store_O_" + strSid);
        	request.getSession().removeAttribute("Dev_List_" + strSid);
        	request.getSession().removeAttribute("Dev_List_Breed_" + strSid);
        	request.getSession().removeAttribute("Dev_List_Type_" + strSid);
        	request.getSession().removeAttribute("Dev_List_Card_" + strSid);
        	request.getSession().removeAttribute("Dev_List_Card_List_" + strSid);
        	request.getSession().removeAttribute("Dev_Remind_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_Type_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_Log_" + strSid);
        	request.getSession().removeAttribute("Spa_Station_Log_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_I_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_IN_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_O_" + strSid);
        	request.getSession().removeAttribute("Spa_Station_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_L_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_L_Log_" + strSid);
        	request.getSession().removeAttribute("Spa_Station_L_" + strSid);
        	request.getSession().removeAttribute("Spa_Station_L_Log_" + strSid);
        	request.getSession().removeAttribute("Fix_Trace_" + strSid);
        	request.getSession().removeAttribute("Fix_Ledger_" + strSid);
        	request.getSession().removeAttribute("Spa_Store_All_" + strSid);
        	request.getSession().removeAttribute("Spa_Station_All_" + strSid);
        	//request.getSession().invalidate();
        	response.getWriter().write("<script language = javascript>window.parent.location.href='../../index.jsp'</script>");
        }
        
        /**************************************����***************************************************/
        else if (strUrl.equalsIgnoreCase("Login.do"))						     //��¼
        	new UserInfoBean().Login(request, response, m_Rmi);
        else if (strUrl.equalsIgnoreCase("PwdEdit.do"))						 	 //�����޸�
        	new UserInfoBean().PwdEdit(request, response, m_Rmi);
        
        /**************************************system**************************************************/
        /**************************************admin***************************************************/
        else if (strUrl.equalsIgnoreCase("Corp_Info.do"))				     	 //��˾��Ϣ
        	new CorpInfoBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Device_Detail.do"))				     //վ����Ϣ
        	new DeviceDetailBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Device_doDragging.do"))				 //վ����Ϣ-��ͼ��ק�ӿ�
        	new DeviceDetailBean().doDragging(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("User_Info.do"))				         //��Ա��Ϣ
        	new UserInfoBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("IdCheck.do"))						 	 //��Ա��Ϣ-�ʺż��
        	new UserInfoBean().IdCheck(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("User_Role.do"))				         //��ԱȨ��
        	new UserRoleBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("User_RoleOP.do"))				     	 //��ԱȨ��-�༭
        	new UserRoleBean().RoleOP(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("User_Position.do"))				 	 //��Ա��Ϣ-��λ����
        	new UserPositionBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Exam_Type.do"))				 	 //��ȫ����-�������
        	new AqscExamTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Danger_Type.do"))				 //��ȫ����-��������
        	new AqscDangerTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Danger_Level.do"))				 //��ȫ����-��������
        	new AqscDangerLevelBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Train_Type.do"))				 	 //��ȫ����-��ѵ����
        	new AqscTrainTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Drill_Type.do"))				 	 //��ȫ����-��������
        	new AqscDrillTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Card_Type.do"))				 	 //֤������-֤������
        	new AqscCardTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Act_Type.do"))				 	 //֤������-��Ϊ����
        	new AqscActTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Labour_Type.do"))				 //�ͱ���Ʒ-��Ʒ����
        	new AqscLabourTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Labour_File.do"))				 //�ͱ���Ʒ-������������
        	new AqscLabourTypeBean().DaoRFile(request, response, m_Rmi, false,Config);
        else if (strUrl.equalsIgnoreCase("Aqsc_Device_Breed.do"))				 //�豸����-�豸Ʒ��
        	new AqscDeviceBreedBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Device_Type.do"))				 //�豸����-�豸����
        	new AqscDeviceTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Device_Card.do"))				 //�豸����-֤������
        	new AqscDeviceCardBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Spare_Type.do"))				     //��Ʒ����-��Ʒ����
        	new AqscSpareTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Crm_Info.do"))				     	 //�ͻ���Ϣ-�ͻ�����
        	new CrmInfoBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Ccm_Info.do"))				     	 //�ͻ���Ϣ-��������
        	new CcmInfoBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Ccm_Info_Card.do"))		       	 	 //��������-�������
        	new CcmInfoBean().CardAdd(request, response, m_Rmi, false);
        
        /**************************************user-ToPo**********************************************/
        else if (strUrl.equalsIgnoreCase("ToPo.do"))						     //GIS���
        	new DeviceDetailBean().ToPo(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("GIS_Deal.do"))	                     //GIS���-�澯����
        	new AlertInfoBean().GISDeal(request, response, m_Rmi, false);
        
        /**************************************user-env***************************************************/
        else if (strUrl.equalsIgnoreCase("Env.do"))						     	 //ʵʱ����
        	new DataBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Env_His_Export.do"))	             	 //��ʷ��ϸ-����
        	new DataBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Graph.do"))	                         //����ͼ��
        	new DataBean().Graph(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Env_File.do"))						 //ͼƬ�ϴ�
        	new DataBean().DaoFile(request, response, m_Rmi, false);
        
        /**************************************user-log***************************************************/ 
       	else if (strUrl.equalsIgnoreCase("Alarm_Info.do"))	                 	 //������־
        	new AlarmInfoBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Alarm_Info_Export.do"))	             //������־-����
        	new AlarmInfoBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Alert_Info.do"))	                 	 //�澯��־
        	new AlertInfoBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Alert_Info_Export.do"))	             //�澯��־-����
        	new AlertInfoBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Alert_Deal.do"))	                 	 //�澯����
        	new AlertInfoBean().Deal(request, response, m_Rmi, false);
       
        /**************************************user-pro***************************************************/
        else if (strUrl.equalsIgnoreCase("Pro_R.do"))	                         //ʵʱ���
        	new ProRBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_R_Export.do"))	                 //ʵʱ���-����
        	new ProRBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_R_Date.do"))	                     //ʵʱ���-��Ӳ�ѯ
        	new ProRBean().ExDate(request, response, m_Rmi, false);
        
        
        else if (strUrl.equalsIgnoreCase("Pro_I.do"))	                         //ж����¼
        	new ProIBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_I_Export.do"))	                 //ж����¼-����
        	new ProIBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_I_Detail_Export.do"))	             //ж����¼-��ϸ����
        	new ProIBean().MxToExcel(request, response, m_Rmi, false);                 
        else if (strUrl.equalsIgnoreCase("Pro_I_Add.do"))	                     //ж����¼-���
        	new ProIBean().ProIAdd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_O.do"))	                         //��ע��¼
        	new ProOBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_O_Export.do"))	                 //��ע��¼-����
        	new ProOBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_O_Add.do"))	                     //��ע��¼-���
        	new ProOBean().ProOAdd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_O_File.do"))	                     //��ע��¼-���ɱ���
        	new ProOBean().DoTJ(request, response, m_Rmi, false);       
        else if (strUrl.equalsIgnoreCase("Pro_O_Date.do"))	                     //��ע��¼-�ձ���ѯ
        	new DateBaoBean().WxhDate(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_O_Del.do"))	                     //��ע��¼ɾ��
        	new ProOBean().doDel(request, response, m_Rmi, false);
        
        
        else if (strUrl.equalsIgnoreCase("Pro_Id_Car.do"))	                     //��ע��¼-������Ϣ��ѯ
        	new CcmInfoBean().IdCar(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L.do"))	                         //��վ����
        	new ProLBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_Y.do"))	                         //��վ����-�걨��
        	new ProLBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Export.do"))	                 //��վ����-�±���
        	new ProLBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_W_Export.do"))	             	 //��վ����-�ܱ���
        	new ProLBean().ExportToExcel_W(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_D_Export.do"))	             	 //��վ����-�ձ���
        	new ProLBean().ExportToExcel_D(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Y_Export.do"))	             	 //��վ����-�걨����
        	new ProLBean().ExportToExcel_Y(request, response, m_Rmi, false);        
        else if (strUrl.equalsIgnoreCase("Pro_G.do"))	             	 		 //��վ����-ͼ�����
        	new ProLBean().Pro_G(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Crp.do"))	                     //��˾����
        	new ProLCrpBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Crp_Y_Export.do"))	             //��˾����-�걨��
        	new ProLCrpBean().ExportToExcel_Y(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Crp_M_Export.do"))	             //��˾����-�±���
        	new ProLCrpBean().ExportToExcel_M(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Crp_W_Export.do"))	             //��˾����-�ܱ���
        	new ProLCrpBean().ExportToExcel_W(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Crp_D_Export.do"))	             //��˾����-�ձ���
        	new ProLCrpBean().ExportToExcel_D(request, response, m_Rmi, false);
        
        
        
        
        else if (strUrl.equalsIgnoreCase("Pro_Crp_G.do"))	             	     //��˾����-ͼ�����
        	new ProLCrpBean().Pro_Crp_G(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Crm.do"))	                     //�ͻ�������ȷ��
        	new ProLCrmBean().ExecCmd(request, response, m_Rmi, false); 
        else if (strUrl.equalsIgnoreCase("Pro_L_Crm_Export.do"))	             //�������˱���
        	new ProLCrmBean().DZBExcel(request, response, m_Rmi, false);                
        else if (strUrl.equalsIgnoreCase("Pro_GX_ZYB.do"))	                     //����ͳ��վ���±���
        	new ProGxtjBean().ExecCmd(request, response, m_Rmi, false);  
        else if (strUrl.equalsIgnoreCase("Pro_GX_ZNB.do"))	                     //����ͳ��վ���걨��
        	new ProGxtjBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_GX_GYB.do"))	                     //����ͳ�ƹ�˾�±���
        	new ProGxtjBean().ExecCmd(request, response, m_Rmi, false);  
        else if (strUrl.equalsIgnoreCase("Pro_GX_GNB.do"))	                     //����ͳ�ƹ�˾�걨��
        	new ProGxtjBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Stat.do"))	                     //���˵�
        	new ProOBean().ExecCmd(request, response, m_Rmi, false);  
        else if (strUrl.equalsIgnoreCase("Pro_I_CC.do"))	                     //�۳�ͳ�Ʊ�
        	new ProIBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_ZYB_Export.do"))	             	 //����վ���±�����
        	new ProGxtjBean().ZYBToExcel(request, response, m_Rmi, false);       
        else if (strUrl.equalsIgnoreCase("Pro_ZNB_Export.do"))	             	 //����վ���걨����
        	new ProGxtjBean().ZNBToExcel(request, response, m_Rmi, false);    
        else if (strUrl.equalsIgnoreCase("Pro_GYB_Export.do"))	             	 //������˾�±�����
        	new ProGxtjBean().GYBToExcel(request, response, m_Rmi, false);    
        else if (strUrl.equalsIgnoreCase("Pro_GNB_Export.do"))	             	 //������˾�걨����
        	new ProGxtjBean().GNBToExcel(request, response, m_Rmi, false);    
        else if (strUrl.equalsIgnoreCase("Pro_I_CC_Export.do"))	                 //�۳�ͳ�Ƶ���
        	new ProIBean().CaocheExcel(request, response, m_Rmi, false);              
        else if (strUrl.equalsIgnoreCase("Pro_Crm_XL_Export.do"))	             //����ȷ�ϱ���
        	new ProLCrmBean().XLQRExcel(request, response, m_Rmi, false);          
        else if (strUrl.equalsIgnoreCase("Pro_Stat_Export.do"))	                 //���˱���
        	new ProOBean().DZBExcel(request, response, m_Rmi, false);              
        else if (strUrl.equalsIgnoreCase("Pro_L_D_Add.do"))	                     //��վ�����ձ���������Ϣ���
        	new DateBaoBean().ExecCmd(request, response, m_Rmi, false);
        /**************************************user-sat***************************************************/
        else if (strUrl.equalsIgnoreCase("Sat_Check.do"))	                     //��ȫ���
        	new SatCheckBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Check_Export.do"))	             //��ȫ���-����
        	new SatCheckBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Check_Add.do"))	             	 //��ȫ���-���
        	new SatCheckBean().SatCheckAdd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Check_Del.do"))	             	 //��ȫ���-ɾ��
        	new SatCheckBean().SatCheckDel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Check_L.do"))	                     //��ȫ���-ͳ��
        	new SatCheckLBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Check_L_Export.do"))	             //��ȫ���-ͳ��-����
        	new SatCheckLBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Danger.do"))	                 	 //��������
        	new SatDangerBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_To_Danger.do"))	                 //�����������ӵ�
        	new SatDangerBean().ToExecCmd(request, response, m_Rmi, false);      
        else if (strUrl.equalsIgnoreCase("Sat_Danger_Export.do"))	             //��������-����
        	new SatDangerBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Danger_Add.do"))	             	 //��������-���
        	new SatDangerBean().SatDangerAdd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Danger_File.do"))				   	 //��������-�ĵ�
        	new SatDangerBean().SatDangerFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Sat_Danger_Edit.do"))				   	 //��������-���ӱ༭
        	new SatDangerBean().SatDangerEdit(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Sat_Break.do"))	                     //Υ�¼�¼
        	new SatBreakBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Break_Export.do"))	             //Υ�¼�¼-����
        	new SatBreakBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Break_Add.do"))	             	 //Υ�¼�¼-���
        	new SatBreakBean().SatBreakAdd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Break_Edit.do"))	             	 //Υ�¼�¼-���ӱ༭
        	new SatBreakBean().SatBreakEdit(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Train.do"))	                     //��ȫ��ѵ
        	new SatTrainBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Diag_Train.do"))	                 //��ȫ��ѵ
        	new SatTrainBean().DiagCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Train_Export.do"))	             //��ȫ��ѵ-����
        	new SatTrainBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Train_Add.do"))	             	 //��ȫ��ѵ-���
        	new SatTrainBean().SatTrainAdd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Train_L.do"))	                     //��ȫ��ѵ-ͳ��
        	new SatTrainLBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Train_L_Export.do"))	             //��ȫ��ѵ-ͳ��-����
        	new SatTrainLBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Drill.do"))	                     //Ӧ������
        	new SatDrillBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_To_Drill.do"))	                 //Ӧ����������
        	new SatDrillBean().ToCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Drill_Export.do"))	             //Ӧ������-����
        	new SatDrillBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Drill_Add.do"))	             	 //Ӧ������-���
        	new SatDrillBean().SatDrillAdd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Drill_L.do"))	                     //Ӧ������-ͳ��
        	new SatDrillLBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Drill_L_Export.do"))	             //Ӧ������-ͳ��-����
        	new SatDrillLBean().ExportToExcel(request, response, m_Rmi, false);
        
        /**************************************user-cad***************************************************/
        else if (strUrl.equalsIgnoreCase("Cad_Status.do"))	                     //��֤��״
        	new CadStatusBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Cad_Remind.do"))	                     //��֤��ʾ
        	new CadRemindBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Cad_Action.do"))	                     //��Ϊ�۲�
        	new CadActionBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Card_Images.do"))	                     //ͼƬ�ϴ�
        	new CadStatusBean().DaoFile(request, response, m_Rmi, false);
        
        /**************************************user-lab***************************************************/
        else if (strUrl.equalsIgnoreCase("Lab_Store.do"))	                     //���̨��
        	new LabStoreBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Lab_Store_File.do"))	                 //���̨����������
        	new LabStoreBean().DaoLabFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Lab_Store_Export.do"))	             //���̨��-����
        	new LabStoreBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Lab_Store_Scrape.do"))	             //���̨��-����
        	new LabStoreBean().doScrape(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Lab_Store_I.do"))	                     //�깺��¼
        	new LabStoreIBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Lab_Store_I_Export.do"))	             //�깺��¼-����
        	new LabStoreIBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Lab_Store_IN_File.do"))	             //���̨����������
        	new LabStoreIBean().DaoLabIFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Lab_Store_IN_Export.do"))	             //����¼-����
        	new LabStoreIBean().IN_ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Lab_Store_O.do"))	                     //�����¼
        	new LabStoreOBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Lab_Store_O_File.do"))	             //���̨����������
        	new LabStoreOBean().DaoLabOFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Lab_Store_O_Export.do"))	             //�����¼-����
        	new LabStoreOBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Lab_Store_O_Status.do"))	             //�����¼-���
        	new LabStoreOBean().doStatus(request, response, m_Rmi, false);        
        else if (strUrl.equalsIgnoreCase("Lab_Store_P.do"))	                     //�ͱ��̵�
        	new LabStorePBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Lab_Store_P_File.do"))	             //�̵㵼��
        	new LabStorePBean().DaoLabPFile(request, response, m_Rmi, false, Config);
        
        
        /**************************************user-dev***************************************************/
        else if (strUrl.equalsIgnoreCase("Dev_List.do"))	                     //�豸��ϸ
        	new DevListBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Dev_ToDes.do"))	                     //��ע��¼-������Ϣ��ѯ
        	new DevListBean().ToDes(request, response, m_Rmi, false);
        
        else if (strUrl.equalsIgnoreCase("Dev_List_File.do"))	                 //�豸�ĵ��ϴ�
        	new DevListBean().SaveFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Dev_List_Card.do"))	                 //�豸��ϸ-֤��
        	new DevListCardBean().DevCard(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Dev_Remind.do"))	                     //��֤��ʾ
        	new DevRemindBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Dev_List_Export.do"))	                 //�豸��ϸ����
        	new DevListBean().DaoToExcel(request, response, m_Rmi, false);
        
        /**************************************user-spa***************************************************/
        else if (strUrl.equalsIgnoreCase("Spa_Store.do"))	                     //���̨��
        	new SpaStoreBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_File.do"))	                 //���̨�˵���
        	new SpaStoreBean().DaoSpaFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Spa_Store_Export.do"))	             //���̨��-����       	
        	new SpaStoreBean().ExportToExcel(request, response, m_Rmi, false);     
        else if (strUrl.equalsIgnoreCase("Spa_Station.do"))	                     //���̨��-վ��        	
        	new SpaStationBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_I.do"))	                     //�깺��¼
        	new SpaStoreIBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_I_Export.do"))	             //�깺��¼-����
        	new SpaStoreIBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_IN_Export.do"))	             //����¼-����
        	new SpaStoreIBean().IN_ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_IN_File.do"))	             //����¼-����
        	new SpaStoreIBean().DaoSpaINFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Spa_Store_O.do"))	                     //�����¼
        	new SpaStoreOBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_O_File.do"))	             //�����¼��������
        	new SpaStoreOBean().DaoSpaOFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Spa_Store_O_Export.do"))	             //�����¼-����
        	new SpaStoreOBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_O_Status.do"))	             //�����¼-���
        	new SpaStoreOBean().doStatus(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_L.do"))	                     //ͳ�Ʊ���
        	new SpaStoreLBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_L_Export.do"))	             //ͳ�Ʊ���-����
        	new SpaStoreLBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_L_Fix.do"))	                 //ͳ�Ʊ���-ά�޶ӵ���
        	new SpaStoreLBean().doLFix(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Station_L_Fix.do"))	             //ͳ�Ʊ���-��վ����
        	new SpaStationLBean().doLFix(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Station_L.do"))	                 //ͳ�Ʊ���-��վ
        	new SpaStationLBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_P.do"))	                     //��Ʒ�̵�
        	new SpaStorePBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_P_File.do"))	             //��Ʒ�̵㵼��
        	new SpaStorePBean().DaoLabPFile(request, response, m_Rmi, false, Config);
        /**************************************user-fix***************************************************/
        else if (strUrl.equalsIgnoreCase("Fix_Trace.do"))	                     //���ϸ���
        	new FixTraceBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Fix_To_Trace.do"))	                 //���ϸ�������
        	new FixTraceBean().ToCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Fix_Trace_Export.do"))	             //���ϸ���-����
        	new FixTraceBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Fix_Trace_File.do"))	                 //���ϸ���-�ĵ�
        	new FixTraceBean().FixTraceFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Fix_Ledger.do"))	                     //����ͳ��
        	new FixLedgerBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Fix_Ledger_Export.do"))	             //����ͳ��-����
        	new FixLedgerBean().ExportToExcel(request, response, m_Rmi, false);
        
    }
    private class Connect extends Thread
	{
    	private ServletConfig config = null;
    	public boolean Test()
    	{
    		int i = 0;
        	boolean ok = false;
        	while(3 > i)
    		{        		
    	    	try
    			{   
    	    		if(i != 0) sleep(500);
    	    		ok = m_Rmi.Test();
    	    		i = 3;
    	    		ok = true;
    			}
    	    	catch(Exception e)
    			{    	    		
    	    		ReConnect();
    	    		i++;
    			}
    		}
    		return ok;
    	}
    	private void ReConnect()
    	{
    		try
    		{
    			rmiUrl = config.getInitParameter("rmiUrl");
    			Context context = new InitialContext();
    			m_Rmi = (Rmi) context.lookup(rmiUrl);
    		}
    		catch(Exception e)
    		{	
    			e.printStackTrace();
    		}
    	}
    }
	public final static String getUrl(HttpServletRequest request)
	{
		String url = "http://" + request.getServerName() + ":"
				+ request.getServerPort() + request.getContextPath() + "/";
		return url;
	}
	
} 