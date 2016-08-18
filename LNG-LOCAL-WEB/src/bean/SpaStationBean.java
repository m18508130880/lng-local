package bean;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import rmi.Rmi;
import rmi.RmiBean;
import util.*;

public class SpaStationBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_SPA_STATION;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public SpaStationBean()
	{
		super.className = "SpaStationBean"; 
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
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		switch(currStatus.getCmd())
		{
			case 13://调整各站分配情况
				if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
					msgBean = pRmi.RmiExec(14, this, 0);
				
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(0, this, 0);
			case 0://查询
		    	request.getSession().setAttribute("Spa_Station_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Spa_Store.jsp?Sid=" + Sid);
		    	break;
			case 1://调整查询
				request.getSession().setAttribute("Spa_Station_Log_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Spa_Station_Log.jsp?Sid=" + Sid);
				break;
		}
		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
	   	response.sendRedirect(currStatus.getJsp());
	}
	
	public String getSql(int pCmd)
	{
		String Sql = "";
		switch (pCmd)
		{
			case 0://查询
				Sql = " select t.cpm_id, t.cpm_name, t.spa_type, t.spa_type_name, t.spa_mode, t.model, t.spa_i_cnt, t.spa_o_cnt, t.spa_s_cnt, '' as memo, t.ctime, t.operator, t.operator_name " +
					  " from view_spa_station t " +
					  " where t.spa_type like '"+ Func_Corp_Id +"%' " +
					  "   and t.ctype like '"+ Func_Sub_Id +"%' " +
					  "   order by t.cpm_id, t.spa_type, t.spa_mode asc ";
				break;
			case 1://调整查询
				Sql = " select t.cpm_id, t.cpm_name, t.spa_type, t.spa_type_name, t.spa_mode, t.model, t.spa_i_cnt, t.spa_o_cnt, t.spa_s_cnt, t.memo, t.ctime, t.operator, t.operator_name " +
				  	  " from view_spa_station_log t " +
				  	  " where t.spa_type like '"+ Func_Corp_Id +"%' " +
				  	  "   and t.ctype like '"+ Func_Sub_Id +"%' " +
				  	  "   order by t.ctime desc ";
				break;
			case 2://全部查询-检定维修
				Sql = " select t.cpm_id, t.cpm_name, t.spa_type, t.spa_type_name, t.spa_mode, t.model, t.spa_i_cnt, t.spa_o_cnt, t.spa_s_cnt, '' as memo, t.ctime, t.operator, t.operator_name " +
				  	  " from view_spa_station t " +
				  	  " order by t.cpm_id, t.spa_type, t.spa_mode asc ";
				break;
			case 13://各站分配情况调整
				Sql = " update spa_station t set t.spa_i_cnt = '"+ Spa_I_Cnt +"', t.spa_o_cnt = '"+ Spa_O_Cnt +"', t.spa_s_cnt = '"+ Spa_S_Cnt +"' where t.cpm_id = '"+ Cpm_Id +"' and t.spa_type = '"+ Spa_Type +"' and t.spa_mode = '"+ Spa_Mode +"' ";
				break;
			case 14://各站分配情况调整日志
				Sql = " insert into spa_station_log(cpm_id, spa_type, spa_mode, spa_i_cnt, spa_o_cnt, spa_s_cnt, memo, ctime, operator)" +
					  " values('"+ Cpm_Id +"', '"+ Spa_Type +"', '"+ Spa_Mode +"', '"+ Spa_I_Cnt +"', '"+ Spa_O_Cnt +"', '"+ Spa_S_Cnt +"', '"+ Memo +"', DATE_FORMAT(now(), '%Y-%m-%d %H:%i:%S'), '"+ Operator +"')";
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
			setModel(pRs.getString(6));
			setSpa_I_Cnt(pRs.getString(7));
			setSpa_O_Cnt(pRs.getString(8));
			setSpa_S_Cnt(pRs.getString(9));
			setMemo(pRs.getString(10));
			setCTime(pRs.getString(11));
			setOperator(pRs.getString(12));
			setOperator_Name(pRs.getString(13));
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
			setModel(CommUtil.StrToGB2312(request.getParameter("Model")));
			setSpa_I_Cnt(CommUtil.StrToGB2312(request.getParameter("Spa_I_Cnt")));
			setSpa_O_Cnt(CommUtil.StrToGB2312(request.getParameter("Spa_O_Cnt")));
			setSpa_S_Cnt(CommUtil.StrToGB2312(request.getParameter("Spa_S_Cnt")));
			setMemo(CommUtil.StrToGB2312(request.getParameter("Memo")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setOperator_Name(CommUtil.StrToGB2312(request.getParameter("Operator_Name")));
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
	private String Model;
	private String Spa_I_Cnt;
	private String Spa_O_Cnt;
	private String Spa_S_Cnt;
	private String Memo;
	private String CTime;
	private String Operator;
	private String Operator_Name;
	
	private String Sid;
	private String Func_Corp_Id;
	private String Func_Sub_Id;
	
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
	
	public String getModel() {
		return Model;
	}

	public void setModel(String model) {
		Model = model;
	}

	public String getSpa_I_Cnt() {
		return Spa_I_Cnt;
	}

	public void setSpa_I_Cnt(String spaICnt) {
		Spa_I_Cnt = spaICnt;
	}
	
	public String getSpa_O_Cnt() {
		return Spa_O_Cnt;
	}

	public void setSpa_O_Cnt(String spaOCnt) {
		Spa_O_Cnt = spaOCnt;
	}

	public String getSpa_S_Cnt() {
		return Spa_S_Cnt;
	}

	public void setSpa_S_Cnt(String spaSCnt) {
		Spa_S_Cnt = spaSCnt;
	}
	
	public String getMemo() {
		return Memo;
	}

	public void setMemo(String memo) {
		Memo = memo;
	}

	public String getCTime() {
		return CTime;
	}

	public void setCTime(String cTime) {
		CTime = cTime;
	}

	public String getOperator() {
		return Operator;
	}

	public void setOperator(String operator) {
		Operator = operator;
	}

	public String getOperator_Name() {
		return Operator_Name;
	}

	public void setOperator_Name(String operatorName) {
		Operator_Name = operatorName;
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
}