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

public class AqscCardTypeBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_AQSC_CARD_TYPE;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public AqscCardTypeBean() 
	{
		super.className = "AqscCardTypeBean";
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
		    	request.getSession().setAttribute("Aqsc_Card_Type_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Aqsc_Card_Type.jsp?Sid=" + Sid);
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
				Sql = " select t.id, t.cname, t.status, t.des, t.train_dept, t.manag_dept, t.lssue_dept, t.review_inteval " +
					  " from aqsc_card_type t order by t.id";
				break;
			case 10://ÃÌº”
				Sql = " insert into aqsc_card_type(id, cname, status, des, train_dept, manag_dept, lssue_dept, review_inteval)" +
					  " values('"+ Id +"', '"+ CName +"', '"+ Status +"', '"+ Des +"', '"+ Train_Dept +"', '"+ Manag_Dept +"', '"+ Lssue_Dept +"', '"+ Review_Inteval +"')";
				break;
			case 11://±‡º≠
				Sql = " update aqsc_card_type t set t.cname = '"+ CName +"', t.status = '"+ Status +"', t.des = '"+ Des +"', " +
					  " t.train_dept = '"+ Train_Dept +"', t.manag_dept = '"+ Manag_Dept +"', t.lssue_dept = '"+ Lssue_Dept +"', t.review_inteval = '"+ Review_Inteval +"' " +
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
			setTrain_Dept(pRs.getString(5));
			setManag_Dept(pRs.getString(6));
			setLssue_Dept(pRs.getString(7));
			setReview_Inteval(pRs.getString(8));
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
			setTrain_Dept(CommUtil.StrToGB2312(request.getParameter("Train_Dept")));
			setManag_Dept(CommUtil.StrToGB2312(request.getParameter("Manag_Dept")));
			setLssue_Dept(CommUtil.StrToGB2312(request.getParameter("Lssue_Dept")));
			setReview_Inteval(CommUtil.StrToGB2312(request.getParameter("Review_Inteval")));
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
	private String Train_Dept;
	private String Manag_Dept;
	private String Lssue_Dept;
	private String Review_Inteval;
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
	
	public String getTrain_Dept() {
		return Train_Dept;
	}

	public void setTrain_Dept(String trainDept) {
		Train_Dept = trainDept;
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

	public String getSid() {
		return Sid;
	}

	public void setSid(String sid) {
		Sid = sid;
	}
}