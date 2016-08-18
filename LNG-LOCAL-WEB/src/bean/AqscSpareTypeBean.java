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

public class AqscSpareTypeBean extends RmiBean
{
	public final static long serialVersionUID = RmiBean.RMI_AQSC_SPARE_TYPE;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public AqscSpareTypeBean()
	{
		super.className = "AqscSpareTypeBean";
	} 
	
	public void ExecCmd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		//类型
		Func_Sub_Id = currStatus.getFunc_Sub_Id()+"";
		if(Func_Sub_Id.equals("9"))
		{
			Func_Sub_Id = "";
		}
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		switch(currStatus.getCmd())
		{
			case 10://添加
			case 11://编辑
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(0, this, 0);
			case 0://查询
		    	request.getSession().setAttribute("Aqsc_Spare_Type_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Aqsc_Spare_Type.jsp?Sid=" + Sid);
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
				Sql = " select t.id, t.cname, t.status, t.des, t.ctype, t.model, t.unit, t.brand, t.seller " +
					  " from aqsc_spare_type t " +
					  " where t.ctype like '"+ Func_Sub_Id +"%'" +
					  " order by t.id";
				break;
			case 10://添加
				Sql = " insert into aqsc_spare_type(id, cname, status, des, ctype, model, unit, brand, seller)" +
					  " values('"+ Id +"', '"+ CName +"', '"+ Status +"', '"+ Des +"', '"+ CType +"', '"+ Model +"', '"+ Unit +"', '"+ Brand +"', '"+ Seller +"')";
				break;
			case 11://编辑
				Sql = " update aqsc_spare_type t set t.cname = '"+ CName +"', t.status = '"+ Status +"', t.des = '"+ Des +"', t.ctype = '"+ CType +"', " +
					  " t.model = '"+ Model +"', t.unit = '"+ Unit +"', t.brand = '"+ Brand +"', t.seller = '"+ Seller +"' " +
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
			setUnit(pRs.getString(7));
			setBrand(pRs.getString(8));
			setSeller(pRs.getString(9));
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
			setUnit(CommUtil.StrToGB2312(request.getParameter("Unit")));
			setBrand(CommUtil.StrToGB2312(request.getParameter("Brand")));
			setSeller(CommUtil.StrToGB2312(request.getParameter("Seller")));
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
	private String Unit;
	private String Brand;
	private String Seller;
	
	private String Sid;
	private String Func_Sub_Id;
	
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

	public String getUnit() {
		return Unit;
	}

	public void setUnit(String unit) {
		Unit = unit;
	}

	public String getBrand() {
		return Brand;
	}

	public void setBrand(String brand) {
		Brand = brand;
	}

	public String getSeller() {
		return Seller;
	}

	public void setSeller(String seller) {
		Seller = seller;
	}

	public String getSid() {
		return Sid;
	}

	public void setSid(String sid) {
		Sid = sid;
	}

	public String getFunc_Sub_Id() {
		return Func_Sub_Id;
	}

	public void setFunc_Sub_Id(String funcSubId) {
		Func_Sub_Id = funcSubId;
	}
}