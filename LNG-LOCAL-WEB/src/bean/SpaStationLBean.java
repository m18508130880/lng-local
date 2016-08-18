package bean;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import rmi.Rmi;
import rmi.RmiBean;
import util.*;

public class SpaStationLBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_SPA_STATION_L;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public SpaStationLBean()
	{
		super.className = "SpaStationLBean";
	}
	 
	public void ExecCmd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		//类型
		Func_Corp_Id = currStatus.getFunc_Corp_Id();
		if(null == Func_Corp_Id || Func_Corp_Id.equals("9999"))
		{
			Func_Corp_Id = "";
		}
		
		//类别
		Func_Sub_Id = currStatus.getFunc_Sub_Id()+"";
		if(Func_Sub_Id.equals("9"))
		{
			Func_Sub_Id = "";
		}
		
		//模式
		Func_Sel_Id = currStatus.getFunc_Sel_Id()+"";
		if(Func_Sel_Id.equals("9"))
		{
			Func_Sel_Id = "";
		}
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		switch(currStatus.getCmd())
		{
			case 0://查询
		    	request.getSession().setAttribute("Spa_Station_L_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Spa_Station_L.jsp?Sid=" + Sid);
		    	break;
			case 1://调整查询
				request.getSession().setAttribute("Spa_Station_L_Log_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Spa_Station_L_Log.jsp?Sid=" + Sid);
				break;
		}
		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
	   	response.sendRedirect(currStatus.getJsp());
	}
	
	//调整
	public void doLFix(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		PrintWriter outprint = response.getWriter();
		String Resp = "9999";
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
    	if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
    	{
    		msgBean = pRmi.RmiExec(12, this, 0);
    		if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
    			Resp = "0000";
    	}
    	
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		outprint.write(Resp);
	}
	
	public String getSql(int pCmd)
	{
		String Sql = "";
		switch (pCmd)
		{
			case 0://查询
				Sql = " select t.cpm_id, t.cpm_name, t.spa_type, t.spa_type_name, t.spa_mode, t.ctype, t.ctime, t.old_r_cnt, t.now_r_cnt, t.dev_type, t.model, '' as memo, '' as itime, '' as operator " +
					  " from view_spa_station_l t " +
					  " where t.spa_type like '"+ Func_Corp_Id +"%' " +
					  "   and t.dev_type like '"+ Func_Sub_Id +"%' " +
					  "   and t.ctype like '"+ Func_Sel_Id +"%'" +
					  "   and t.ctime = date_format('"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"', '%Y-%m-%d')" +
					  "   order by t.cpm_id, t.spa_type, t.spa_mode asc ";
				break;
			case 1://调整查询
				Sql = " select t.cpm_id, t.cpm_name, t.spa_type, t.spa_type_name, t.spa_mode, t.ctype, t.ctime, t.old_r_cnt, t.now_r_cnt, t.dev_type, t.model, t.memo, t.itime, t.operator " +
				  	  " from view_spa_station_l_log t " +
				  	  " where t.spa_type like '"+ Func_Corp_Id +"%' " +
				  	  "   and t.dev_type like '"+ Func_Sub_Id +"%' " +
				  	  "   and t.ctype like '"+ Func_Sel_Id +"%'" +
				  	  "   order by t.itime desc ";
				break;
			case 11://调整
				Sql = " update spa_station_l t set t.old_r_cnt = '"+ Old_R_Cnt +"', t.now_r_cnt = '"+ Now_R_Cnt +"' " +
					  " where t.cpm_id = '"+ Cpm_Id +"' " +
					  "   and t.spa_type = '"+ Spa_Type +"' " +
					  "   and t.spa_mode = '"+ Spa_Mode +"' " +
					  "   and t.ctype = '"+ CType +"' " +
					  "   and t.ctime = '"+ CTime +"' ";
				break;
			case 12://调整日志
				Sql = " insert into spa_station_l_log(cpm_id, spa_type, spa_mode, ctype, ctime, old_r_cnt, now_r_cnt, memo, itime, operator)" +
					  " values('"+Cpm_Id+"', '"+Spa_Type+"', '"+Spa_Mode+"', '"+CType+"', '"+CTime+"', '"+Old_R_Cnt+"', '"+Now_R_Cnt+"', '"+Memo+"', DATE_FORMAT(now(), '%Y-%m-%d %H:%i:%S'), '"+Operator+"')";
				break;
		}
		return Sql;
	}
	
	public boolean getData(ResultSet pRs)
	{
		boolean IsOK = true;
		try
		{
			setCpm_Id(pRs.getString(1));
			setCpm_Name(pRs.getString(2));
			setSpa_Type(pRs.getString(3));
			setSpa_Type_Name(pRs.getString(4));
			setSpa_Mode(pRs.getString(5));
			setCType(pRs.getString(6));
			setCTime(pRs.getString(7));
			setOld_R_Cnt(pRs.getString(8));
			setNow_R_Cnt(pRs.getString(9));
			setDev_Type(pRs.getString(10));
			setModel(pRs.getString(11));
			setMemo(pRs.getString(12));
			setITime(pRs.getString(13));
			setOperator(pRs.getString(14));
		}
		catch (SQLException sqlExp)
		{
			sqlExp.printStackTrace();
		}
		return IsOK;
	}
	
	public boolean getHtmlData(HttpServletRequest request)
	{
		boolean IsOK = true;
		try
		{
			setCpm_Id(CommUtil.StrToGB2312(request.getParameter("Cpm_Id")));
			setCpm_Name(CommUtil.StrToGB2312(request.getParameter("Cpm_Name")));
			setSpa_Type(CommUtil.StrToGB2312(request.getParameter("Spa_Type")));
			setSpa_Type_Name(CommUtil.StrToGB2312(request.getParameter("Spa_Type_Name")));
			setSpa_Mode(CommUtil.StrToGB2312(request.getParameter("Spa_Mode")));
			setCType(CommUtil.StrToGB2312(request.getParameter("CType")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setOld_R_Cnt(CommUtil.StrToGB2312(request.getParameter("Old_R_Cnt")));
			setNow_R_Cnt(CommUtil.StrToGB2312(request.getParameter("Now_R_Cnt")));
			setDev_Type(CommUtil.StrToGB2312(request.getParameter("Dev_Type")));
			setModel(CommUtil.StrToGB2312(request.getParameter("Model")));
			setMemo(CommUtil.StrToGB2312(request.getParameter("Memo")));
			setITime(CommUtil.StrToGB2312(request.getParameter("ITime")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String Cpm_Id;
	private String Cpm_Name;
	private String Spa_Type;
	private String Spa_Type_Name;
	private String Spa_Mode;
	private String CType;
	private String CTime;
	private String Old_R_Cnt;
	private String Now_R_Cnt;
	private String Dev_Type;
	private String Model;
	private String Memo;
	private String ITime;
	private String Operator;
	
	private String Sid;
	private String Func_Corp_Id;
	private String Func_Sub_Id;
	private String Func_Sel_Id;
	
	public String getCpm_Id() {
		return Cpm_Id;
	}

	public void setCpm_Id(String cpmId) {
		Cpm_Id = cpmId;
	}

	public String getCpm_Name() {
		return Cpm_Name;
	}

	public void setCpm_Name(String cpmName) {
		Cpm_Name = cpmName;
	}

	public String getSpa_Type() {
		return Spa_Type;
	}

	public void setSpa_Type(String spaType) {
		Spa_Type = spaType;
	}

	public String getSpa_Type_Name() {
		return Spa_Type_Name;
	}

	public void setSpa_Type_Name(String spaTypeName) {
		Spa_Type_Name = spaTypeName;
	}

	public String getSpa_Mode() {
		return Spa_Mode;
	}

	public void setSpa_Mode(String spaMode) {
		Spa_Mode = spaMode;
	}

	public String getCType() {
		return CType;
	}

	public void setCType(String cType) {
		CType = cType;
	}

	public String getCTime() {
		return CTime;
	}

	public void setCTime(String cTime) {
		CTime = cTime;
	}
	
	public String getOld_R_Cnt() {
		return Old_R_Cnt;
	}

	public void setOld_R_Cnt(String oldRCnt) {
		Old_R_Cnt = oldRCnt;
	}

	public String getNow_R_Cnt() {
		return Now_R_Cnt;
	}

	public void setNow_R_Cnt(String nowRCnt) {
		Now_R_Cnt = nowRCnt;
	}

	public String getDev_Type() {
		return Dev_Type;
	}

	public void setDev_Type(String devType) {
		Dev_Type = devType;
	}
	
	public String getModel() {
		return Model;
	}

	public void setModel(String model) {
		Model = model;
	}

	public String getMemo() {
		return Memo;
	}

	public void setMemo(String memo) {
		Memo = memo;
	}

	public String getITime() {
		return ITime;
	}

	public void setITime(String iTime) {
		ITime = iTime;
	}

	public String getOperator() {
		return Operator;
	}

	public void setOperator(String operator) {
		Operator = operator;
	}

	public String getSid() {
		return Sid;
	}

	public void setSid(String sid) {
		Sid = sid;
	}

	public String getFunc_Corp_Id() {
		return Func_Corp_Id;
	}

	public void setFunc_Corp_Id(String funcCorpId) {
		Func_Corp_Id = funcCorpId;
	}

	public String getFunc_Sub_Id() {
		return Func_Sub_Id;
	}

	public void setFunc_Sub_Id(String funcSubId) {
		Func_Sub_Id = funcSubId;
	}

	public String getFunc_Sel_Id() {
		return Func_Sel_Id;
	}

	public void setFunc_Sel_Id(String funcSelId) {
		Func_Sel_Id = funcSelId;
	}
}