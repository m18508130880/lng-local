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

////0全部查询 2插入 3修改 4删除 10～19单个查询
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
    		request.getSession().setAttribute("ErrMsg", CommUtil.StrToGB2312("RMI服务端未正常运行，无法登陆！"));
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
        
        //首页
        if(strUrl.equals("index.do"))
        {
        	CheckCode.CreateCheckCode(request, response, strSid);
        	return;
        }
        else if(strUrl.equalsIgnoreCase("AdminILogout.do"))                      //第二层:admin安全退出
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
        else if(strUrl.equalsIgnoreCase("ILogout.do"))                           //第二层:user安全退出
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
        else if(strUrl.equalsIgnoreCase("IILogout.do"))                          //第三层:user安全退出
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
        
        /**************************************公用***************************************************/
        else if (strUrl.equalsIgnoreCase("Login.do"))						     //登录
        	new UserInfoBean().Login(request, response, m_Rmi);
        else if (strUrl.equalsIgnoreCase("PwdEdit.do"))						 	 //密码修改
        	new UserInfoBean().PwdEdit(request, response, m_Rmi);
        
        /**************************************system**************************************************/
        /**************************************admin***************************************************/
        else if (strUrl.equalsIgnoreCase("Corp_Info.do"))				     	 //公司信息
        	new CorpInfoBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Device_Detail.do"))				     //站级信息
        	new DeviceDetailBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Device_doDragging.do"))				 //站级信息-地图拖拽接口
        	new DeviceDetailBean().doDragging(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("User_Info.do"))				         //人员信息
        	new UserInfoBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("IdCheck.do"))						 	 //人员信息-帐号检测
        	new UserInfoBean().IdCheck(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("User_Role.do"))				         //人员权限
        	new UserRoleBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("User_RoleOP.do"))				     	 //人员权限-编辑
        	new UserRoleBean().RoleOP(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("User_Position.do"))				 	 //人员信息-岗位管理
        	new UserPositionBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Exam_Type.do"))				 	 //安全生产-检查类型
        	new AqscExamTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Danger_Type.do"))				 //安全生产-隐患类型
        	new AqscDangerTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Danger_Level.do"))				 //安全生产-隐患级别
        	new AqscDangerLevelBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Train_Type.do"))				 	 //安全生产-培训类型
        	new AqscTrainTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Drill_Type.do"))				 	 //安全生产-演练类型
        	new AqscDrillTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Card_Type.do"))				 	 //证件管理-证件类型
        	new AqscCardTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Act_Type.do"))				 	 //证件管理-行为类型
        	new AqscActTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Labour_Type.do"))				 //劳保用品-用品类型
        	new AqscLabourTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Labour_File.do"))				 //劳保用品-类型批量导入
        	new AqscLabourTypeBean().DaoRFile(request, response, m_Rmi, false,Config);
        else if (strUrl.equalsIgnoreCase("Aqsc_Device_Breed.do"))				 //设备管理-设备品种
        	new AqscDeviceBreedBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Device_Type.do"))				 //设备管理-设备类型
        	new AqscDeviceTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Device_Card.do"))				 //设备管理-证件类型
        	new AqscDeviceCardBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Aqsc_Spare_Type.do"))				     //备品备件-备品类型
        	new AqscSpareTypeBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Crm_Info.do"))				     	 //客户信息-客户管理
        	new CrmInfoBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Ccm_Info.do"))				     	 //客户信息-车辆管理
        	new CcmInfoBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Ccm_Info_Card.do"))		       	 	 //车辆管理-卡号添加
        	new CcmInfoBean().CardAdd(request, response, m_Rmi, false);
        
        /**************************************user-ToPo**********************************************/
        else if (strUrl.equalsIgnoreCase("ToPo.do"))						     //GIS监控
        	new DeviceDetailBean().ToPo(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("GIS_Deal.do"))	                     //GIS监控-告警处理
        	new AlertInfoBean().GISDeal(request, response, m_Rmi, false);
        
        /**************************************user-env***************************************************/
        else if (strUrl.equalsIgnoreCase("Env.do"))						     	 //实时数据
        	new DataBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Env_His_Export.do"))	             	 //历史明细-导出
        	new DataBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Graph.do"))	                         //数据图表
        	new DataBean().Graph(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Env_File.do"))						 //图片上传
        	new DataBean().DaoFile(request, response, m_Rmi, false);
        
        /**************************************user-log***************************************************/ 
       	else if (strUrl.equalsIgnoreCase("Alarm_Info.do"))	                 	 //联动日志
        	new AlarmInfoBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Alarm_Info_Export.do"))	             //联动日志-导出
        	new AlarmInfoBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Alert_Info.do"))	                 	 //告警日志
        	new AlertInfoBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Alert_Info_Export.do"))	             //告警日志-导出
        	new AlertInfoBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Alert_Deal.do"))	                 	 //告警处理
        	new AlertInfoBean().Deal(request, response, m_Rmi, false);
       
        /**************************************user-pro***************************************************/
        else if (strUrl.equalsIgnoreCase("Pro_R.do"))	                         //实时库存
        	new ProRBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_R_Export.do"))	                 //实时库存-导出
        	new ProRBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_R_Date.do"))	                     //实时库存添加查询
        	new ProRBean().ExDate(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_I.do"))	                         //卸车记录
        	new ProIBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_I_Export.do"))	                 //卸车记录-导出
        	new ProIBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_I_Detail_Export.do"))	             //卸车记录-明细导出
        	new ProIBean().MxToExcel(request, response, m_Rmi, false);                 
        else if (strUrl.equalsIgnoreCase("Pro_I_Add.do"))	                     //卸车记录-添加
        	new ProIBean().ProIAdd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_O.do"))	                         //加注记录
        	new ProOBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_O_Export.do"))	                 //加注记录-导出
        	new ProOBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_O_Add.do"))	                     //加注记录-添加
        	new ProOBean().ProOAdd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_O_File.do"))	                     //加注记录-生成报表
        	new ProOBean().DoTJ(request, response, m_Rmi, false);       
        else if (strUrl.equalsIgnoreCase("Pro_O_Date.do"))	                     //加注记录-日报查询
        	new DateBaoBean().WxhDate(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_O_Del.do"))	                     //加注记录删除
        	new ProOBean().doDel(request, response, m_Rmi, false); 
        else if (strUrl.equalsIgnoreCase("Pro_Id_Car.do"))	                     //加注记录-车辆信息查询
        	new CcmInfoBean().IdCar(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L.do"))	                         //场站报表
        	new ProLBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_Y.do"))	                         //场站报表-年报表
        	new ProLBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Export.do"))	                 //场站报表-月报表
        	new ProLBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_W_Export.do"))	             	 //场站报表-周报表
        	new ProLBean().ExportToExcel_W(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_D_Export.do"))	             	 //场站报表-日报表
        	new ProLBean().ExportToExcel_D(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Y_Export.do"))	             	 //场站报表-年报表导出
        	new ProLBean().ExportToExcel_Y(request, response, m_Rmi, false);        
        else if (strUrl.equalsIgnoreCase("Pro_G.do"))	             	 		 //场站报表-图表分析
        	new ProLBean().Pro_G(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Crp.do"))	                     //公司报表
        	new ProLCrpBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Crp_Y_Export.do"))	             //公司报表-年报表
        	new ProLCrpBean().ExportToExcel_Y(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Crp_M_Export.do"))	             //公司报表-月报表
        	new ProLCrpBean().ExportToExcel_M(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Crp_W_Export.do"))	             //公司报表-周报表
        	new ProLCrpBean().ExportToExcel_W(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Crp_D_Export.do"))	             //公司报表-日报表
        	new ProLCrpBean().ExportToExcel_D(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_Crp_G.do"))	             	     //公司报表-图表分析
        	new ProLCrpBean().Pro_Crp_G(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Crm.do"))	                     //客户销售量确认
        	new ProLCrmBean().ExecCmd(request, response, m_Rmi, false); 
        else if (strUrl.equalsIgnoreCase("Pro_L_Crm_Export.do"))	             //次数对账表导出
        	new ProLCrmBean().DZBExcel(request, response, m_Rmi, false);                
        else if (strUrl.equalsIgnoreCase("Pro_GX_ZYB.do"))	                     //购销统计站级月报表
        	new ProGxtjBean().ExecCmd(request, response, m_Rmi, false);  
        else if (strUrl.equalsIgnoreCase("Pro_GX_ZNB.do"))	                     //购销统计站级年报表
        	new ProGxtjBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_GX_GYB.do"))	                     //购销统计公司月报表
        	new ProGxtjBean().ExecCmd(request, response, m_Rmi, false);  
        else if (strUrl.equalsIgnoreCase("Pro_GX_GNB.do"))	                     //购销统计公司年报表
        	new ProGxtjBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_L_Stat.do"))	                     //对账单
        	new ProOBean().ExecCmd(request, response, m_Rmi, false);  
        else if (strUrl.equalsIgnoreCase("Pro_I_CC.do"))	                     //槽车统计表
        	new ProIBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Pro_ZYB_Export.do"))	             	 //购销站级月报导出
        	new ProGxtjBean().ZYBToExcel(request, response, m_Rmi, false);       
        else if (strUrl.equalsIgnoreCase("Pro_ZNB_Export.do"))	             	 //购销站级年报导出
        	new ProGxtjBean().ZNBToExcel(request, response, m_Rmi, false);    
        else if (strUrl.equalsIgnoreCase("Pro_GYB_Export.do"))	             	 //购销公司月报导出
        	new ProGxtjBean().GYBToExcel(request, response, m_Rmi, false);    
        else if (strUrl.equalsIgnoreCase("Pro_GNB_Export.do"))	             	 //购销公司年报导出
        	new ProGxtjBean().GNBToExcel(request, response, m_Rmi, false);    
        else if (strUrl.equalsIgnoreCase("Pro_I_CC_Export.do"))	                 //槽车统计导出
        	new ProIBean().CaocheExcel(request, response, m_Rmi, false);              
        else if (strUrl.equalsIgnoreCase("Pro_Crm_XL_Export.do"))	             //销量确认表导出
        	new ProLCrmBean().XLQRExcel(request, response, m_Rmi, false);          
        else if (strUrl.equalsIgnoreCase("Pro_Stat_Export.do"))	                 //对账表导出
        	new ProOBean().DZBExcel(request, response, m_Rmi, false);              
        else if (strUrl.equalsIgnoreCase("Pro_L_D_Add.do"))	                     //场站报表日报表其他信息添加
        	new DateBaoBean().ExecCmd(request, response, m_Rmi, false);
        
        /**************************************user-sat***************************************************/
        else if (strUrl.equalsIgnoreCase("Sat_Check.do"))	                     //安全检查
        	new SatCheckBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Check_Export.do"))	             //安全检查-导出
        	new SatCheckBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Check_Add.do"))	             	 //安全检查-添加
        	new SatCheckBean().SatCheckAdd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Check_Del.do"))	             	 //安全检查-删除
        	new SatCheckBean().SatCheckDel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Check_L.do"))	                     //安全检查-统计
        	new SatCheckLBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Check_L_Export.do"))	             //安全检查-统计-导出
        	new SatCheckLBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Danger.do"))	                 	 //隐患跟踪
        	new SatDangerBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_To_Danger.do"))	                 //隐患跟踪连接点
        	new SatDangerBean().ToExecCmd(request, response, m_Rmi, false);      
        else if (strUrl.equalsIgnoreCase("Sat_Danger_Export.do"))	             //隐患跟踪-导出
        	new SatDangerBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Danger_Add.do"))	             	 //隐患跟踪-添加
        	new SatDangerBean().SatDangerAdd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Danger_File.do"))				   	 //隐患跟踪-文档
        	new SatDangerBean().SatDangerFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Sat_Danger_Edit.do"))				   	 //隐患跟踪-链接编辑
        	new SatDangerBean().SatDangerEdit(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Sat_Break.do"))	                     //违章记录
        	new SatBreakBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Break_Export.do"))	             //违章记录-导出
        	new SatBreakBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Break_Add.do"))	             	 //违章记录-添加
        	new SatBreakBean().SatBreakAdd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Break_Edit.do"))	             	 //违章记录-链接编辑
        	new SatBreakBean().SatBreakEdit(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Train.do"))	                     //安全培训
        	new SatTrainBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Diag_Train.do"))	                 //安全培训
        	new SatTrainBean().DiagCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Train_Export.do"))	             //安全培训-导出
        	new SatTrainBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Train_Add.do"))	             	 //安全培训-添加
        	new SatTrainBean().SatTrainAdd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Train_L.do"))	                     //安全培训-统计
        	new SatTrainLBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Train_L_Export.do"))	             //安全培训-统计-导出
        	new SatTrainLBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Drill.do"))	                     //应急演练
        	new SatDrillBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_To_Drill.do"))	                     //应急演练连接
        	new SatDrillBean().ToCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Drill_Export.do"))	             //应急演练-导出
        	new SatDrillBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Drill_Add.do"))	             	 //应急演练-添加
        	new SatDrillBean().SatDrillAdd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Drill_L.do"))	                     //应急演练-统计
        	new SatDrillLBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Sat_Drill_L_Export.do"))	             //应急演练-统计-导出
        	new SatDrillLBean().ExportToExcel(request, response, m_Rmi, false);
        
        /**************************************user-cad***************************************************/
        else if (strUrl.equalsIgnoreCase("Cad_Status.do"))	                     //持证现状
        	new CadStatusBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Cad_Remind.do"))	                     //持证提示
        	new CadRemindBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Cad_Action.do"))	                     //行为观察
        	new CadActionBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Card_Images.do"))	                     //图片上传
        	new CadStatusBean().DaoFile(request, response, m_Rmi, false);
        
        /**************************************user-lab***************************************************/
        else if (strUrl.equalsIgnoreCase("Lab_Store.do"))	                     //库存台账
        	new LabStoreBean().ExecCmd(request, response, m_Rmi, false);
//        else if (strUrl.equalsIgnoreCase("Lab_Store_File.do"))	                 //库存台账批量导入
//        	new LabStoreBean().DaoLabFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Lab_Store_Export.do"))	             //库存台账-导出
        	new LabStoreBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Lab_Store_Scrape.do"))	             //库存台账-报废
        	new LabStoreBean().doScrape(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Lab_Store_I.do"))	                     //申购记录
        	new LabStoreIBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Lab_Store_I_Export.do"))	             //申购记录-导出
        	new LabStoreIBean().ExportToExcel(request, response, m_Rmi, false);
//        else if (strUrl.equalsIgnoreCase("Lab_Store_IN_File.do"))	             //库存台账批量导入
//        	new LabStoreIBean().DaoLabIFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Lab_Store_IN_Export.do"))	             //入库记录-导出
        	new LabStoreIBean().IN_ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Lab_Store_O.do"))	                     //出入记录
        	new LabStoreOBean().ExecCmd(request, response, m_Rmi, false);
//        else if (strUrl.equalsIgnoreCase("Lab_Store_O_File.do"))	             //库存台账批量导入
//        	new LabStoreOBean().DaoLabOFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Lab_Store_O_Export.do"))	             //出入记录-导出
        	new LabStoreOBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Lab_Store_O_Status.do"))	             //出入记录-审核
        	new LabStoreOBean().doStatus(request, response, m_Rmi, false);        
        else if (strUrl.equalsIgnoreCase("Lab_Store_P.do"))	             //劳保盘点
        	new LabStorePBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Lab_Store_P_File.do"))	             //盘点导入
        	new LabStorePBean().DaoLabPFile(request, response, m_Rmi, false, Config);
        
        
        /**************************************user-dev***************************************************/
        else if (strUrl.equalsIgnoreCase("Dev_List.do"))	                     //设备明细
        	new DevListBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Dev_ToDes.do"))	                     //加注记录-车辆信息查询
        	new DevListBean().ToDes(request, response, m_Rmi, false);
        
        else if (strUrl.equalsIgnoreCase("Dev_List_File.do"))	                 //设备文档上传
        	new DevListBean().SaveFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Dev_List_Card.do"))	                 //设备明细-证件
        	new DevListCardBean().DevCard(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Dev_Remind.do"))	                     //持证提示
        	new DevRemindBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Dev_List_Export.do"))	                 //设备明细导出
        	new DevListBean().DaoToExcel(request, response, m_Rmi, false);
        
        /**************************************user-spa***************************************************/
        else if (strUrl.equalsIgnoreCase("Spa_Store.do"))	                     //库存台账
        	new SpaStoreBean().ExecCmd(request, response, m_Rmi, false);
//        else if (strUrl.equalsIgnoreCase("Spa_Store_File.do"))	                 //库存台账导入
//        	new SpaStoreBean().DaoSpaFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Spa_Store_Export.do"))	             //库存台账-导出       	
        	new SpaStoreBean().ExportToExcel(request, response, m_Rmi, false);  
        else if (strUrl.equalsIgnoreCase("Spa_Store_Scrape.do"))	             //库存台账-报废
        	new SpaStoreBean().doScrape(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Station.do"))	                     //库存台账-站点        	
        	new SpaStationBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_I.do"))	                     //申购记录
        	new SpaStoreIBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_I_Export.do"))	             //申购记录-导出
        	new SpaStoreIBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_IN_Export.do"))	             //入库记录-导出
        	new SpaStoreIBean().IN_ExportToExcel(request, response, m_Rmi, false);
//        else if (strUrl.equalsIgnoreCase("Spa_Store_IN_File.do"))	             //入库记录-导入
//        	new SpaStoreIBean().DaoSpaINFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Spa_Store_O.do"))	                     //出库记录
        	new SpaStoreOBean().ExecCmd(request, response, m_Rmi, false);
//        else if (strUrl.equalsIgnoreCase("Spa_Store_O_File.do"))	             //出库记录批量导入
//        	new SpaStoreOBean().DaoSpaOFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Spa_Store_O_Export.do"))	             //出库记录-导出
        	new SpaStoreOBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_O_Status.do"))	             //出库记录-审核
        	new SpaStoreOBean().doStatus(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_L.do"))	                     //统计报表
        	new SpaStoreLBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_L_Export.do"))	             //统计报表-导出
        	new SpaStoreLBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_L_Fix.do"))	                 //统计报表-维修队调整
        	new SpaStoreLBean().doLFix(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Station_L_Fix.do"))	             //统计报表-场站调整
        	new SpaStationLBean().doLFix(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Station_L.do"))	                 //统计报表-场站
        	new SpaStationLBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_P.do"))	                     //备品盘点
        	new SpaStorePBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Spa_Store_P_File.do"))	             //备品盘点导入
        	new SpaStorePBean().DaoLabPFile(request, response, m_Rmi, false, Config);
        /**************************************user-fix***************************************************/
        else if (strUrl.equalsIgnoreCase("Fix_Trace.do"))	                     //故障跟踪
        	new FixTraceBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Fix_To_Trace.do"))	                 //故障跟踪连接
        	new FixTraceBean().ToCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Fix_Trace_Export.do"))	             //故障跟踪-导出
        	new FixTraceBean().ExportToExcel(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Fix_Trace_File.do"))	                 //故障跟踪-文档
        	new FixTraceBean().FixTraceFile(request, response, m_Rmi, false, Config);
        else if (strUrl.equalsIgnoreCase("Fix_Ledger.do"))	                     //故障统计
        	new FixLedgerBean().ExecCmd(request, response, m_Rmi, false);
        else if (strUrl.equalsIgnoreCase("Fix_Ledger_Export.do"))	             //故障统计-导出
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