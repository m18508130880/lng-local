package bean;


import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.*;
import com.jspsmart.upload.SmartUpload;
import rmi.Rmi;
import rmi.RmiBean;
import util.*;

public class AqscLabourTypeBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_AQSC_LABOUR_TYPE;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public AqscLabourTypeBean()
	{
		super.className = "AqscLabourTypeBean"; 
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
		    	request.getSession().setAttribute("Aqsc_Labour_Type_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Aqsc_Labour_Type.jsp?Sid=" + Sid);
		    	break;
		}
		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
	   	response.sendRedirect(currStatus.getJsp());
	}
	//批量导入劳保数据
	public void DaoRFile(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone, ServletConfig pConfig) 
	{
		try
		{			
			SmartUpload mySmartUpload = new SmartUpload();
			mySmartUpload.initialize(pConfig, request, response);
			mySmartUpload.setAllowedFilesList("xls,xlsx,XLS,XLSX,");
			mySmartUpload.upload();
									
			Sid = mySmartUpload.getRequest().getParameter("Sid");
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);						
			System.out.println("Sid"+Sid+"[]"+"currStatus"+currStatus);
			if(mySmartUpload.getFiles().getCount() > 0 && mySmartUpload.getFiles().getFile(0).getFilePathName().trim().length() > 0)
			{
				if(mySmartUpload.getFiles().getFile(0).getSize()/1024 <= 3072)//最大3M
				{		
					String FileSaveRoute = "/www/LNG-LOCAL/LNG-LOCAL-WEB/files/upfiles/";										
					//上传现有文档			
					com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);		
					String File_Name = new SimpleDateFormat("yyyyMMdd").format(new Date()) + CommUtil.Randon()+ "." + myFile.getFileExt();			
					myFile.saveAs(FileSaveRoute + File_Name);						
					//录入数据库
					InputStream is = new FileInputStream(FileSaveRoute + File_Name);
					Workbook rwb = Workbook.getWorkbook(is);					
					Sheet rs = rwb.getSheet(0);					
				    int rsRows = rs.getRows();		
				    int succCnt = 0;	
				    for(int i=1; i<rsRows; i++)
				    {
				    	if(null==rs.getCell(0, i).getContents().trim()||"".equals(rs.getCell(0, i).getContents().trim()))
				    	{
				    
				    		break;//当excel文档第一行为空时，退出循环
				    		}
				    	CName  = rs.getCell(0, i).getContents().trim();	
				    	if(null==rs.getCell(1, i).getContents().trim()||"".equals(rs.getCell(1, i).getContents().trim()))
				    	{
				   
				    		break;//当excel文档所属监狱一行为空时，退出循环，或者做其他处理
				    		
				    		}
				    	Model  = rs.getCell(1, i).getContents().trim();
				    	if(null==rs.getCell(2, i).getContents().trim()||"".equals(rs.getCell(2, i).getContents().trim()))
				    	{
				 
				    		break;//当excel文档监区一行为空时，退出循环，或者做其他处理
				    		}
				  
				    	Unit   = rs.getCell(2, i).getContents().trim();
				    	Id     = "";
				    	Status = "0";
				    	Des    = "";
				    	Brand  = "";
				    	Seller = "";
				    	System.out.println("设置参数结束");
				    	msgBean = pRmi.RmiExec(10, this, 0);
				    	if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
						{
				    		succCnt ++;
						}
				    }	
				    System.out.println("导入数据结束");
				    currStatus.setResult("成功导入[" + String.valueOf(succCnt) + "/" + String.valueOf(rsRows-1) + "]个");
				}
				else
				{
					currStatus.setResult("文档上传失败！文档过大，必须小于3M!");
				}				
			}
			currStatus.setJsp("Aqsc_Labour_Type.jsp?Sid=" + Sid);
			msgBean = pRmi.RmiExec(0, this, 0);
			request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		   	response.sendRedirect(currStatus.getJsp());
		}
		catch(Exception exp)
		{
			exp.printStackTrace();
		}
	
	}
	
	public String getSql(int pCmd)
	{
		String Sql = "";
		switch (pCmd)
		{
			case 0://查询
				Sql = " select t.id, t.cname, t.status, t.des, t.model, t.unit, t.brand, t.seller " +
					  " from aqsc_labour_type t order by t.id";
				break;
			case 10://添加
				Sql = " insert into aqsc_labour_type(id, cname, status, des, model, unit, brand, seller)" +
					  " values('"+ Id +"', '"+ CName +"', '"+ Status +"', '"+ Des +"', '"+ Model +"', '"+ Unit +"', '"+ Brand +"', '"+ Seller +"')";
				break;
			case 11://编辑
				Sql = " update aqsc_labour_type t set t.cname = '"+ CName +"', t.status = '"+ Status +"', t.des = '"+ Des +"', t.model = '"+ Model +"', " +
					  " t.unit = '"+ Unit +"', t.brand = '"+ Brand +"', t.seller = '"+ Seller +"' " +
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
			setModel(pRs.getString(5));
			setUnit(pRs.getString(6));
			setBrand(pRs.getString(7));
			setSeller(pRs.getString(8));
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
	private String Model;
	private String Unit;
	private String Brand;
	private String Seller;
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
}