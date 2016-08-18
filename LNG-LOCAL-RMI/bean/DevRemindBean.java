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

public class DevRemindBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_DEV_REMIND;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public DevRemindBean()
	{
		super.className = "DevRemindBean";
	}
	
	public void ExecCmd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		//品种
		Func_Corp_Id = currStatus.getFunc_Corp_Id();
		if(null == Func_Corp_Id || Func_Corp_Id.equals("9999"))
		{
			Func_Corp_Id = "";
		}
		
		//状态
		Func_Sel_Id = currStatus.getFunc_Sel_Id()+"";
		if(Func_Sel_Id.equals("9"))
		{
			Func_Sel_Id = "";
		}
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
		switch(currStatus.getCmd())
		{
			case 0://查询
		    	request.getSession().setAttribute("Dev_Remind_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Dev_Remind.jsp?Sid=" + Sid);
		    	
		    	//设备品种
		    	AqscDeviceBreedBean DeviceBreed = new AqscDeviceBreedBean();
		    	msgBean = pRmi.RmiExec(0, DeviceBreed, 0);
				request.getSession().setAttribute("Dev_List_Breed_" + Sid, (Object)msgBean.getMsg());
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
				Sql = " select t.sn, t.dev_sn, t.cpm_id, t.cpm_name, t.dev_type_name, t.dev_name, t.dev_ctype, t.dev_ctype_name, t.card_type, t.card_type_name, t.ctype, t.des, t.status, t.ctime, t.operator " +
					  " from view_dev_remind t " +
					  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
					  "  and t.dev_ctype like '"+ Func_Corp_Id +"%' " +
					  "  and t.status like '"+ Func_Sel_Id +"%' " +
					  "  order by t.dev_sn, t.cpm_id, t.card_type asc ";
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
			setDev_SN(pRs.getString(2));
			setCpm_Id(pRs.getString(3));
			setCpm_Name(pRs.getString(4));
			setDev_Type_Name(pRs.getString(5));
			setDev_Name(pRs.getString(6));
			setDev_CType(pRs.getString(7));
			setDev_CType_Name(pRs.getString(8));
			setCard_Type(pRs.getString(9));
			setCard_Type_Name(pRs.getString(10));
			setCType(pRs.getString(11));
			setDes(pRs.getString(12));
			setStatus(pRs.getString(13));
			setCTime(pRs.getString(14));
			setOperator(pRs.getString(15));
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
			setDev_SN(CommUtil.StrToGB2312(request.getParameter("Dev_SN")));
			setCpm_Id(CommUtil.StrToGB2312(request.getParameter("Cpm_Id")));
			setCpm_Name(CommUtil.StrToGB2312(request.getParameter("Cpm_Name")));
			setDev_Type_Name(CommUtil.StrToGB2312(request.getParameter("Dev_Type_Name")));
			setDev_Name(CommUtil.StrToGB2312(request.getParameter("Dev_Name")));
			setDev_CType(CommUtil.StrToGB2312(request.getParameter("Dev_CType")));
			setDev_CType_Name(CommUtil.StrToGB2312(request.getParameter("Dev_CType_Name")));
			setCard_Type(CommUtil.StrToGB2312(request.getParameter("Card_Type")));
			setCard_Type_Name(CommUtil.StrToGB2312(request.getParameter("Card_Type_Name")));
			setCType(CommUtil.StrToGB2312(request.getParameter("CType")));
			setDes(CommUtil.StrToGB2312(request.getParameter("Des")));
			setStatus(CommUtil.StrToGB2312(request.getParameter("Status")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String SN;
	private String Dev_SN;
	private String Cpm_Id;
	private String Cpm_Name;
	private String Dev_Type_Name;
	private String Dev_Name;
	private String Dev_CType;
	private String Dev_CType_Name;
	private String Card_Type;
	private String Card_Type_Name;
	private String CType;
	private String Des;
	private String Status;
	private String CTime;
	private String Operator;
	
	private String Sid;
	private String Func_Corp_Id;
	private String Func_Sel_Id;
	
	public String getSN() {
		return SN;
	}

	public void setSN(String sN) {
		SN = sN;
	}

	public String getDev_SN() {
		return Dev_SN;
	}

	public void setDev_SN(String devSN) {
		Dev_SN = devSN;
	}

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

	public String getDev_Type_Name() {
		return Dev_Type_Name;
	}

	public void setDev_Type_Name(String devTypeName) {
		Dev_Type_Name = devTypeName;
	}

	public String getDev_Name() {
		return Dev_Name;
	}

	public void setDev_Name(String devName) {
		Dev_Name = devName;
	}

	public String getDev_CType() {
		return Dev_CType;
	}

	public void setDev_CType(String devCType) {
		Dev_CType = devCType;
	}
	
	public String getDev_CType_Name() {
		return Dev_CType_Name;
	}

	public void setDev_CType_Name(String devCTypeName) {
		Dev_CType_Name = devCTypeName;
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

	public String getFunc_Corp_Id() {
		return Func_Corp_Id;
	}

	public void setFunc_Corp_Id(String funcCorpId) {
		Func_Corp_Id = funcCorpId;
	}

	public String getFunc_Sel_Id() {
		return Func_Sel_Id;
	}

	public void setFunc_Sel_Id(String funcSelId) {
		Func_Sel_Id = funcSelId;
	}
}