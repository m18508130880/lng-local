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

public class CadRemindBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_CAD_REMIND;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public CadRemindBean()
	{
		super.className = "CadRemindBean";
	}
	 
	public void ExecCmd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		//×´Ì¬
		Func_Sub_Id = currStatus.getFunc_Sub_Id()+"";
		if(Func_Sub_Id.equals("9"))
		{
			Func_Sub_Id = "";
		}
		
		//msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
		switch(currStatus.getCmd())
		{
			case 0://²éÑ¯
				if( Func_Type_Id.equals("999"))
		    	{
					Func_Type_Id = "";
		    		msgBean = pRmi.RmiExec(1, this, currStatus.getCurrPage());
		    	}else
		    	{
		    		msgBean = pRmi.RmiExec(0, this, currStatus.getCurrPage());
		    	}		    	
					
		    	request.getSession().setAttribute("Cad_Remind_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Cad_Remind.jsp?Sid=" + Sid);
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
			case 0://²éÑ¯
				Sql = " select t.sn, t.sys_id, t.sys_name, t.dept_id, t.position_name, t.card_type, t.card_type_name, t.ctype, t.des, t.status, t.ctime, t.operator " +
					  " from view_cad_remind t " +
					  " where instr('"+ UId +"', t.sys_id) > 0 " +
					  " and t.status like '"+ Func_Sub_Id +"%' " +
					  " and t.dept_id = '"+Func_Type_Id+"' "+
					  " and t.ctime >= date_format('"+currStatus.getVecDate().get(0).toString()+"', '%Y-%m-%d %H-%i-%S')" +
					  " and t.ctime <= date_format('"+currStatus.getVecDate().get(1).toString()+"', '%Y-%m-%d %H-%i-%S')" +
					  " order by t.ctime desc ";
				break;
				
			case 1:
				Sql = " select t.sn, t.sys_id, t.sys_name, t.dept_id, t.position_name, t.card_type, t.card_type_name, t.ctype, t.des, t.status, t.ctime, t.operator " +
					  " from view_cad_remind t " +
					  " where instr('"+ UId +"', t.sys_id) > 0 " +
					  " and t.status like '"+ Func_Sub_Id +"%' " +
					  " and t.dept_id like '"+Func_Type_Id+"%' "+
					  " and t.ctime >= date_format('"+currStatus.getVecDate().get(0).toString()+"', '%Y-%m-%d %H-%i-%S')" +
					  " and t.ctime <= date_format('"+currStatus.getVecDate().get(1).toString()+"', '%Y-%m-%d %H-%i-%S')" +
					  " order by  t.ctime desc ";
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
			setSys_Id(pRs.getString(2));
			setSys_Name(pRs.getString(3));
			setDept_Id(pRs.getString(4));
			setPosition_Name(pRs.getString(5));
			setCard_Type(pRs.getString(6));
			setCard_Type_Name(pRs.getString(7));			
			setCType(pRs.getString(8));
			setDes(pRs.getString(9));
			setStatus(pRs.getString(10));
			setCTime(pRs.getString(11));
			setOperator(pRs.getString(12));
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
			setSys_Id(CommUtil.StrToGB2312(request.getParameter("Sys_Id")));
			setSys_Name(CommUtil.StrToGB2312(request.getParameter("Sys_Name")));
			setDept_Id(CommUtil.StrToGB2312(request.getParameter("Dept_Id")));
			setPosition_Name(CommUtil.StrToGB2312(request.getParameter("Position_Name")));
			setCard_Type(CommUtil.StrToGB2312(request.getParameter("Card_Type")));
			setCard_Type_Name(CommUtil.StrToGB2312(request.getParameter("Card_Type_Name")));
			setCType(CommUtil.StrToGB2312(request.getParameter("CType")));
			setDes(CommUtil.StrToGB2312(request.getParameter("Des")));
			setStatus(CommUtil.StrToGB2312(request.getParameter("Status")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
			setUId(CommUtil.StrToGB2312(request.getParameter("UId")));
			setFunc_Type_Id(CommUtil.StrToGB2312(request.getParameter("Func_Type_Id")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String SN;
	private String Sys_Id;
	private String Sys_Name;
	private String Dept_Id;
	private String Position_Name;
	private String Card_Type;
	private String Card_Type_Name;
	private String CType;
	private String Des;
	private String Status;
	private String CTime;
	private String Operator;
	
	private String Sid;
	private String UId;
	private String Func_Sub_Id;
	private String Func_Type_Id;
	

	
	public String getFunc_Type_Id() {
		return Func_Type_Id;
	}

	public void setFunc_Type_Id(String func_Type_Id) {
		Func_Type_Id = func_Type_Id;
	}

	public String getSN() {
		return SN;
	}

	public void setSN(String sN) {
		SN = sN;
	}

	public String getSys_Id() {
		return Sys_Id;
	}

	public void setSys_Id(String sysId) {
		Sys_Id = sysId;
	}

	public String getSys_Name() {
		return Sys_Name;
	}

	public void setSys_Name(String sysName) {
		Sys_Name = sysName;
	}

	public String getDept_Id() {
		return Dept_Id;
	}

	public void setDept_Id(String deptId) {
		Dept_Id = deptId;
	}

	public String getPosition_Name() {
		return Position_Name;
	}

	public void setPosition_Name(String positionName) {
		Position_Name = positionName;
	}

	public String getCard_Type() {
		return Card_Type;
	}

	public void setCard_Type(String cardType) {
		Card_Type = cardType;
	}

	public String getCard_Type_Name() {
		return Card_Type_Name;
	}

	public void setCard_Type_Name(String cardTypeName) {
		Card_Type_Name = cardTypeName;
	}

	public String getCType() {
		return CType;
	}

	public void setCType(String cType) {
		CType = cType;
	}

	public String getDes() {
		return Des;
	}

	public void setDes(String des) {
		Des = des;
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