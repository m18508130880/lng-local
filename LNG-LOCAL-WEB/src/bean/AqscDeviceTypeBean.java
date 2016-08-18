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

public class AqscDeviceTypeBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_AQSC_DEVICE_TYPE;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public AqscDeviceTypeBean() 
	{
		super.className = "AqscDeviceTypeBean";
	}
	
	public void ExecCmd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		switch(currStatus.getCmd())
		{
			case 10://添加
			case 11://编辑
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(0, this, 0);
			case 0://查询
		    	request.getSession().setAttribute("Aqsc_Device_Type_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Aqsc_Device_Type.jsp?Sid=" + Sid + "&CType=" + CType);
		    	
		    	//设备证件
		    	AqscDeviceCardBean DeviceCardBean = new AqscDeviceCardBean();
		    	msgBean = pRmi.RmiExec(0, DeviceCardBean, 0);
				request.getSession().setAttribute("Aqsc_Device_Card_" + Sid, (Object)msgBean.getMsg());
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
				Sql = " select t.id, t.cname, t.status, t.des, t.ctype, t.model, t.craft, t.technology, t.agent, t.agent_man, t.agent_tel, t.card_list " +
					  " from aqsc_device_type t " +
					  " where t.ctype like '"+ CType +"%'" +
					  " order by t.id";
				break;
				
			case 1:
				Sql = " select t.id, t.cname, t.status, t.des, t.ctype, t.model, t.craft, t.technology, t.agent, t.agent_man, t.agent_tel, t.card_list " +
					  " from aqsc_device_type t " +
					  " where t.ctype = '"+ CType +"'" +
					  " and t.id = '"+ Id +"'" ;
				break;
			case 10://添加
				Sql = " insert into aqsc_device_type(id, cname, status, des, ctype, model, craft, technology, agent, agent_man, agent_tel, card_list)" +
					  " values('"+ Id +"', '"+ CName +"', '"+ Status +"', '"+ Des +"', '"+ CType +"', '"+ Model +"', '"+ Craft +"', '"+ Technology +"', '"+ Agent +"', '"+ Agent_Man +"', '"+ Agent_Tel +"', '"+ Card_List +"')";
				break;
			case 11://编辑
				Sql = " update aqsc_device_type t set t.cname = '"+ CName +"', t.status = '"+ Status +"', t.des = '"+ Des +"', t.ctype = '"+ CType +"', t.model = '"+ Model +"', " +
					  " t.craft = '"+ Craft +"', t.technology = '"+ Technology +"', t.agent = '"+ Agent +"', t.agent_man = '"+ Agent_Man +"', t.agent_tel = '"+ Agent_Tel +"', t.card_list = '"+ Card_List +"' " +
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
			setCType(pRs.getString(5));
			setModel(pRs.getString(6));
			setCraft(pRs.getString(7));
			setTechnology(pRs.getString(8));
			setAgent(pRs.getString(9));
			setAgent_Man(pRs.getString(10));
			setAgent_Tel(pRs.getString(11));			
			setCard_List(pRs.getString(12));
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
			setCType(CommUtil.StrToGB2312(request.getParameter("CType")));
			setModel(CommUtil.StrToGB2312(request.getParameter("Model")));
			setCraft(CommUtil.StrToGB2312(request.getParameter("Craft")));
			setTechnology(CommUtil.StrToGB2312(request.getParameter("Technology")));
			setAgent(CommUtil.StrToGB2312(request.getParameter("Agent")));
			setAgent_Man(CommUtil.StrToGB2312(request.getParameter("Agent_Man")));
			setAgent_Tel(CommUtil.StrToGB2312(request.getParameter("Agent_Tel")));
			setCard_List(CommUtil.StrToGB2312(request.getParameter("Card_List")));
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
	private String CType;
	private String Model;
	private String Craft;
	private String Technology;
	private String Agent;
	private String Agent_Man;
	private String Agent_Tel;
	private String Card_List;
	
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

	public String getCType() {
		return CType;
	}

	public void setCType(String cType) {
		CType = cType;
	}

	public String getModel() {
		return Model;
	}

	public void setModel(String model) {
		Model = model;
	}

	public String getCraft() {
		return Craft;
	}

	public void setCraft(String craft) {
		Craft = craft;
	}

	public String getTechnology() {
		return Technology;
	}

	public void setTechnology(String technology) {
		Technology = technology;
	}

	public String getAgent() {
		return Agent;
	}

	public void setAgent(String agent) {
		Agent = agent;
	}

	public String getAgent_Man() {
		return Agent_Man;
	}

	public void setAgent_Man(String agentMan) {
		Agent_Man = agentMan;
	}

	public String getAgent_Tel() {
		return Agent_Tel;
	}

	public void setAgent_Tel(String agentTel) {
		Agent_Tel = agentTel;
	}
	
	public String getCard_List() {
		return Card_List;
	}

	public void setCard_List(String cardList) {
		Card_List = cardList;
	}

	public String getSid() {
		return Sid;
	}

	public void setSid(String sid) {
		Sid = sid;
	}
}