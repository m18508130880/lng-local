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

public class CadActionBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_CAD_ACTION;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public CadActionBean()
	{
		super.className = "CadActionBean";
	}
	
	public void ExecCmd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		//状态
		Func_Sub_Id = currStatus.getFunc_Sub_Id()+"";
		if(Func_Sub_Id.equals("9"))
		{
			Func_Sub_Id = "";
		}
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
		switch(currStatus.getCmd())
		{
			case 10://添加
			case 11://修改
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(0, this, currStatus.getCurrPage());
			case 0://查询
		    	request.getSession().setAttribute("Cad_Action_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Cad_Action.jsp?Sid=" + Sid);
		    	
		    	//行为类型
		    	AqscActTypeBean ActType = new AqscActTypeBean();
		    	msgBean = pRmi.RmiExec(0, ActType, 0);
				request.getSession().setAttribute("Cad_Action_Type_" + Sid, (Object)msgBean.getMsg());
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
				switch(currStatus.getFunc_Sub_Id())
				{
					case 0:
						Sql = " select t.sn, t.observe_op, t.observe_op_name, t.observe_op_pos, t.observe_by, t.observe_by_name, t.observe_by_pos, t.observe_time, t.observe_addr, " +
					  	  	  " t.observe_act, t.observe_des, t.act_plan, t.act_plan_op, t.act_sugg, t.act_sugg_op, t.status, t.ctime, t.operator, t.operator_name " +
					  	  	  " from view_cad_action t " +
					  	  	  " where instr('"+ UId +"', t.observe_by) > 0 " +
					  	  	  " and t.status like '"+ Func_Sub_Id +"%' " +
					  	  	  " order by t.observe_time desc ";
						break;
					default:
						Sql = " select t.sn, t.observe_op, t.observe_op_name, t.observe_op_pos, t.observe_by, t.observe_by_name, t.observe_by_pos, t.observe_time, t.observe_addr, " +
						  	  " t.observe_act, t.observe_des, t.act_plan, t.act_plan_op, t.act_sugg, t.act_sugg_op, t.status, t.ctime, t.operator, t.operator_name " +
						  	  " from view_cad_action t " +
						  	  " where instr('"+ UId +"', t.observe_by) > 0 " +
						  	  " and t.status like '"+ Func_Sub_Id +"%' " +
						  	  " and t.observe_time >= date_format('"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"', '%Y-%m-%d')" +
						  	  " and t.observe_time <= date_format('"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"', '%Y-%m-%d')" +
						  	  " order by t.observe_time desc ";
						break;
				}
				break;
			case 10://添加
				Sql = " insert into cad_action(observe_op, observe_by, observe_time, observe_addr, observe_act, observe_des, act_plan, act_sugg, status, ctime, operator)" +
					  " values('"+ Observe_OP +"', '"+ Observe_BY +"', '"+ Observe_Time +"', '"+ Observe_Addr +"', '"+ Observe_Act +"', '"+ Observe_Des +"', '"+ Act_Plan +"', '"+ Act_Sugg +"', '"+ Status +"', DATE_FORMAT(now(), '%Y-%m-%d %H:%i:%S'), '"+ Operator +"')";
				break;
			case 11://修改
				Sql = " update cad_action t set t.observe_op = '"+ Observe_OP +"', t.observe_by = '"+ Observe_BY +"', t.observe_time = '"+ Observe_Time +"', t.observe_addr = '"+ Observe_Addr +"', t.observe_act = '"+ Observe_Act +"', " +
					  " t.observe_des = '"+ Observe_Des +"', t.act_plan = '"+ Act_Plan +"', t.act_sugg = '"+ Act_Sugg +"', t.status = '"+ Status +"', t.ctime = DATE_FORMAT(now(), '%Y-%m-%d %H:%i:%S'), t.operator = '"+ Operator +"' " +
					  " where t.sn = '"+ SN +"'";
				break;
		}
		return Sql;
	}
	
	public boolean getData(ResultSet pRs)
	{
		boolean IsOK = true;
		try
		{
			setSN(pRs.getString(1));
			setObserve_OP(pRs.getString(2));
			setObserve_OP_Name(pRs.getString(3));
			setObserve_OP_Pos(pRs.getString(4));
			setObserve_BY(pRs.getString(5));
			setObserve_BY_Name(pRs.getString(6));
			setObserve_BY_Pos(pRs.getString(7));
			setObserve_Time(pRs.getString(8));
			setObserve_Addr(pRs.getString(9));
			setObserve_Act(pRs.getString(10));
			setObserve_Des(pRs.getString(11));
			setAct_Plan(pRs.getString(12));
			setAct_Plan_OP(pRs.getString(13));
			setAct_Sugg(pRs.getString(14));
			setAct_Sugg_OP(pRs.getString(15));
			setStatus(pRs.getString(16));
			setCTime(pRs.getString(17));
			setOperator(pRs.getString(18));
			setOperator_Name(pRs.getString(19));
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
			setSN(CommUtil.StrToGB2312(request.getParameter("SN")));
			setObserve_OP(CommUtil.StrToGB2312(request.getParameter("Observe_OP")));
			setObserve_OP_Name(CommUtil.StrToGB2312(request.getParameter("Observe_OP_Name")));
			setObserve_OP_Pos(CommUtil.StrToGB2312(request.getParameter("Observe_OP_Pos")));
			setObserve_BY(CommUtil.StrToGB2312(request.getParameter("Observe_BY")));
			setObserve_BY_Name(CommUtil.StrToGB2312(request.getParameter("Observe_BY_Name")));
			setObserve_BY_Pos(CommUtil.StrToGB2312(request.getParameter("Observe_BY_Pos")));
			setObserve_Time(CommUtil.StrToGB2312(request.getParameter("Observe_Time")));
			setObserve_Addr(CommUtil.StrToGB2312(request.getParameter("Observe_Addr")));
			setObserve_Act(CommUtil.StrToGB2312(request.getParameter("Observe_Act")));
			setObserve_Des(CommUtil.StrToGB2312(request.getParameter("Observe_Des")));
			setAct_Plan(CommUtil.StrToGB2312(request.getParameter("Act_Plan")));
			setAct_Plan_OP(CommUtil.StrToGB2312(request.getParameter("Act_Plan_OP")));
			setAct_Sugg(CommUtil.StrToGB2312(request.getParameter("Act_Sugg")));
			setAct_Sugg_OP(CommUtil.StrToGB2312(request.getParameter("Act_Sugg_OP")));
			setStatus(CommUtil.StrToGB2312(request.getParameter("Status")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setOperator_Name(CommUtil.StrToGB2312(request.getParameter("Operator_Name")));
			
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
			setUId(CommUtil.StrToGB2312(request.getParameter("UId")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String SN;
	private String Observe_OP;
	private String Observe_OP_Name;
	private String Observe_OP_Pos;
	private String Observe_BY;
	private String Observe_BY_Name;
	private String Observe_BY_Pos;
	private String Observe_Time;
	private String Observe_Addr;
	private String Observe_Act;
	private String Observe_Des;
	private String Act_Plan;
	private String Act_Plan_OP;
	private String Act_Sugg;
	private String Act_Sugg_OP;
	private String Status;
	private String CTime;
	private String Operator;
	private String Operator_Name;
	
	private String Sid;
	private String UId;
	private String Func_Sub_Id;
	
	public String getSN() {
		return SN;
	}

	public void setSN(String sN) {
		SN = sN;
	}

	public String getObserve_OP() {
		return Observe_OP;
	}

	public void setObserve_OP(String observeOP) {
		Observe_OP = observeOP;
	}

	public String getObserve_OP_Name() {
		return Observe_OP_Name;
	}

	public void setObserve_OP_Name(String observeOPName) {
		Observe_OP_Name = observeOPName;
	}

	public String getObserve_OP_Pos() {
		return Observe_OP_Pos;
	}

	public void setObserve_OP_Pos(String observeOPPos) {
		Observe_OP_Pos = observeOPPos;
	}

	public String getObserve_BY() {
		return Observe_BY;
	}

	public void setObserve_BY(String observeBY) {
		Observe_BY = observeBY;
	}

	public String getObserve_BY_Name() {
		return Observe_BY_Name;
	}

	public void setObserve_BY_Name(String observeBYName) {
		Observe_BY_Name = observeBYName;
	}

	public String getObserve_BY_Pos() {
		return Observe_BY_Pos;
	}

	public void setObserve_BY_Pos(String observeBYPos) {
		Observe_BY_Pos = observeBYPos;
	}

	public String getObserve_Time() {
		return Observe_Time;
	}

	public void setObserve_Time(String observeTime) {
		Observe_Time = observeTime;
	}

	public String getObserve_Addr() {
		return Observe_Addr;
	}

	public void setObserve_Addr(String observeAddr) {
		Observe_Addr = observeAddr;
	}

	public String getObserve_Act() {
		return Observe_Act;
	}

	public void setObserve_Act(String observeAct) {
		Observe_Act = observeAct;
	}

	public String getObserve_Des() {
		return Observe_Des;
	}

	public void setObserve_Des(String observeDes) {
		Observe_Des = observeDes;
	}

	public String getAct_Plan() {
		return Act_Plan;
	}

	public void setAct_Plan(String actPlan) {
		Act_Plan = actPlan;
	}

	public String getAct_Plan_OP() {
		return Act_Plan_OP;
	}

	public void setAct_Plan_OP(String actPlanOP) {
		Act_Plan_OP = actPlanOP;
	}

	public String getAct_Sugg() {
		return Act_Sugg;
	}

	public void setAct_Sugg(String actSugg) {
		Act_Sugg = actSugg;
	}

	public String getAct_Sugg_OP() {
		return Act_Sugg_OP;
	}

	public void setAct_Sugg_OP(String actSuggOP) {
		Act_Sugg_OP = actSuggOP;
	}

	public String getStatus() {
		return Status;
	}

	public void setStatus(String status) {
		Status = status;
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

	public String getUId() {
		return UId;
	}

	public void setUId(String uId) {
		UId = uId;
	}

	public String getFunc_Sub_Id() {
		return Func_Sub_Id;
	}

	public void setFunc_Sub_Id(String funcSubId) {
		Func_Sub_Id = funcSubId;
	}
}