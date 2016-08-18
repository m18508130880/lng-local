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

public class DevListCardBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_DEV_LIST_CARD;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public DevListCardBean()
	{
		super.className = "DevListCardBean";
	}
	 
	//操作
	public void DevCard(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		PrintWriter outprint = response.getWriter();
		String Resp = "9999";
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		msgBean = pRmi.RmiExec(40, this, 0);
		if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
		{
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
				Sql = " select t.sn, t.card_type, t.card_type_name, t.card_id, t.card_btime, t.card_etime, " +
					  " t.card_all_btime, t.card_all_etime, t.card_review, t.card_overall, t.ctime, t.operator, t.operator_name, t.overall_inteval " +
					  " from view_dev_list_card t " +
					  "   order by t.sn, t.card_type asc ";
				break;
			case 10://添加
				Sql = " insert into dev_list_card(sn, card_type, card_id, card_btime, card_etime, card_all_btime, card_all_etime, card_review, card_overall, ctime, operator)" +
					  " values('"+ SN +"', '"+ Card_Type +"', '"+ Card_Id +"', '"+ Card_BTime +"', '"+ Card_ETime +"', '"+ Card_All_BTime +"', '"+ Card_All_ETime +"', '"+ Card_Review +"', '"+ Card_Overall +"', DATE_FORMAT(now(), '%Y-%m-%d %H:%i:%S'), '"+ Operator +"')";
				break;
			case 11://修改
				Sql = " update dev_list_card t set t.card_id = '"+ Card_Id +"', t.card_btime = '"+ Card_BTime +"', t.card_etime = '"+ Card_ETime +"', " +
					  " t.card_all_btime = '"+ Card_All_BTime +"', t.card_all_etime = '"+ Card_All_ETime +"', t.card_review = '"+ Card_Review +"', t.card_overall = '"+ Card_Overall +"', t.operator = '"+ Operator +"' " +
					  " where t.sn = '"+ SN +"' and t.card_type = '"+ Card_Type +"'";
				break;
			case 12://删除
				Sql = " delete from dev_list_card where sn = '"+ SN +"' and card_type = '"+ Card_Type +"'";
				break;
			case 40:
				Sql = "{call pro_dev_remind()}";
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
			setCard_Type(pRs.getString(2));
			setCard_Type_Name(pRs.getString(3));
			setCard_Id(pRs.getString(4));
			setCard_BTime(pRs.getString(5));
			setCard_ETime(pRs.getString(6));
			setCard_All_BTime(pRs.getString(7));
			setCard_All_ETime(pRs.getString(8));
			setCard_Review(pRs.getString(9));
			setCard_Overall(pRs.getString(10));
			setCTime(pRs.getString(11));
			setOperator(pRs.getString(12));
			setOperator_Name(pRs.getString(13));
			setOverall_Inteval(pRs.getString(14));
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
			setCard_Type(CommUtil.StrToGB2312(request.getParameter("Card_Type")));
			setCard_Type_Name(CommUtil.StrToGB2312(request.getParameter("Card_Type_Name")));
			setCard_Id(CommUtil.StrToGB2312(request.getParameter("Card_Id")));
			setCard_BTime(CommUtil.StrToGB2312(request.getParameter("Card_BTime")));
			setCard_ETime(CommUtil.StrToGB2312(request.getParameter("Card_ETime")));
			setCard_All_BTime(CommUtil.StrToGB2312(request.getParameter("Card_All_BTime")));
			setCard_All_ETime(CommUtil.StrToGB2312(request.getParameter("Card_All_ETime")));
			setCard_Review(CommUtil.StrToGB2312(request.getParameter("Card_Review")));
			setCard_Overall(CommUtil.StrToGB2312(request.getParameter("Card_Overall")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setOperator_Name(CommUtil.StrToGB2312(request.getParameter("Operator_Name")));			
			setOverall_Inteval(CommUtil.StrToGB2312(request.getParameter("Overall_Inteval")));			
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String SN;
	private String Card_Type;
	private String Card_Type_Name;
	private String Card_Id;
	private String Card_BTime;
	private String Card_ETime;
	private String Card_All_BTime;
	private String Card_All_ETime;
	private String Card_Review;
	private String Card_Overall;
	private String CTime;
	private String Operator;
	private String Operator_Name;
	private String Overall_Inteval;
	
	private String Sid;
	
	public String getSN() {
		return SN;
	}

	public void setSN(String sN) {
		SN = sN;
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

	public String getCard_Id() {
		return Card_Id;
	}

	public void setCard_Id(String cardId) {
		Card_Id = cardId;
	}

	public String getCard_BTime() {
		return Card_BTime;
	}

	public void setCard_BTime(String cardBTime) {
		Card_BTime = cardBTime;
	}

	public String getCard_ETime() {
		return Card_ETime;
	}

	public void setCard_ETime(String cardETime) {
		Card_ETime = cardETime;
	}

	public String getCard_All_BTime() {
		return Card_All_BTime;
	}

	public void setCard_All_BTime(String cardAllBTime) {
		Card_All_BTime = cardAllBTime;
	}

	public String getCard_All_ETime() {
		return Card_All_ETime;
	}

	public void setCard_All_ETime(String cardAllETime) {
		Card_All_ETime = cardAllETime;
	}

	public String getCard_Review() {
		return Card_Review;
	}

	public void setCard_Review(String cardReview) {
		Card_Review = cardReview;
	}

	public String getCard_Overall() {
		return Card_Overall;
	}

	public void setCard_Overall(String cardOverall) {
		Card_Overall = cardOverall;
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