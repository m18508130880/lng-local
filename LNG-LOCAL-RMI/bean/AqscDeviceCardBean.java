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

public class AqscDeviceCardBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_AQSC_DEVICE_CARD;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public AqscDeviceCardBean() 
	{
		super.className = "AqscDeviceCardBean";
	}
	
	public void ExecCmd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		switch(currStatus.getCmd())
		{
			case 10://ÃÌº”
			case 11://±‡º≠
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(0, this, 0);
			case 0://≤È—Ø
		    	request.getSession().setAttribute("Aqsc_Device_Card_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Aqsc_Device_Card.jsp?Sid=" + Sid);
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
			case 0://≤È—Ø
				Sql = " select t.id, t.cname, t.status, t.des, t.manag_dept, t.lssue_dept, t.review_inteval, t.overall_inteval " +
					  " from aqsc_device_card t " +
					  " order by t.id";
				break;
			case 10://ÃÌº”
				Sql = " insert into aqsc_device_card(id, cname, status, des, manag_dept, lssue_dept, review_inteval, overall_inteval)" +
					  " values('"+ Id +"', '"+ CName +"', '"+ Status +"', '"+ Des +"', '"+ Manag_Dept +"', '"+ Lssue_Dept +"', '"+ Review_Inteval +"', '"+ Overall_Inteval +"')";
				break;
			case 11://±‡º≠
				Sql = " update aqsc_device_card t set t.cname = '"+ CName +"', t.status = '"+ Status +"', t.des = '"+ Des +"', " +
					  " t.manag_dept = '"+ Manag_Dept +"', t.lssue_dept = '"+ Lssue_Dept +"', t.review_inteval = '"+ Review_Inteval +"', t.overall_inteval = '"+ Overall_Inteval +"' " +
					  " where t.id = '"+ Id +"'";
				break;
		}
		return Sql;
	}
	
	public boolean getData(ResultSet pRs)
	{
		boolean IsOK = true;
		try
		{
			setId(pRs.getString(1));
			setCName(pRs.getString(2));
			setStatus(pRs.getString(3));
			setDes(pRs.getString(4));
			setManag_Dept(pRs.getString(5));
			setLssue_Dept(pRs.getString(6));
			setReview_Inteval(pRs.getString(7));
			setOverall_Inteval(pRs.getString(8));
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
			setId(CommUtil.StrToGB2312(request.getParameter("Id")));
			setCName(CommUtil.StrToGB2312(request.getParameter("CName")));
			setStatus(CommUtil.StrToGB2312(request.getParameter("Status")));
			setDes(CommUtil.StrToGB2312(request.getParameter("Des")));
			setManag_Dept(CommUtil.StrToGB2312(request.getParameter("Manag_Dept")));
			setLssue_Dept(CommUtil.StrToGB2312(request.getParameter("Lssue_Dept")));
			setReview_Inteval(CommUtil.StrToGB2312(request.getParameter("Review_Inteval")));
			setOverall_Inteval(CommUtil.StrToGB2312(request.getParameter("Overall_Inteval")));
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String Id;
	private String CName;
	private String Status;
	private String Des;
	private String Manag_Dept;
	private String Lssue_Dept;
	private String Review_Inteval;
	private String Overall_Inteval;
	private String Sid;
	
	public String getId() {
		return Id;
	}

	public void setId(String id) {
		Id = id;
	}

	public String getCName() {
		return CName;
	}

	public void setCName(String cName) {
		CName = cName;
	}

	public String getStatus() {
		return Status;
	}

	public void setStatus(String status) {
		Status = status;
	}

	public String getDes() {
		return Des;
	}

	public void setDes(String des) {
		Des = des;
	}

	public String getManag_Dept() {
		return Manag_Dept;
	}

	public void setManag_Dept(String managDept) {
		Manag_Dept = managDept;
	}

	public String getLssue_Dept() {
		return Lssue_Dept;
	}

	public void setLssue_Dept(String lssueDept) {
		Lssue_Dept = lssueDept;
	}

	public String getReview_Inteval() {
		return Review_Inteval;
	}

	public void setReview_Inteval(String reviewInteval) {
		Review_Inteval = reviewInteval;
	}

	public String getOverall_Inteval() {
		return Overall_Inteval;
	}

	public void setOverall_Inteval(String overallInteval) {
		Overall_Inteval = overallInteval;
	}

	public String getSid() {
		return Sid;
	}

	public void setSid(String sid) {
		Sid = sid;
	}
}