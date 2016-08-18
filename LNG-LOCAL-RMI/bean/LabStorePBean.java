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

import com.jspsmart.upload.SmartUpload;

import jxl.Sheet;
import jxl.Workbook;
import rmi.Rmi;
import rmi.RmiBean;
import util.*;

public class LabStorePBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_LAB_STORE_P;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public LabStorePBean()
	{
		super.className = "LabStorePBean";
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
		
		
		Func_Type_Id = currStatus.getFunc_Type_Id();
		if(null == Func_Type_Id || Func_Type_Id.equals("6666"))
		{
			Func_Type_Id = "";
		}
				
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		switch(currStatus.getCmd())
		{
			case 13://删除
				msgBean = pRmi.RmiExec(0, this, 0);
			case 0://查询
		    	request.getSession().setAttribute("Lab_Store_P_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Lab_TJ.jsp?Sid=" + Sid);		    
		    	
		    	msgBean = pRmi.RmiExec(1, this, 0);//盘点日期
		    	request.getSession().setAttribute("Lab_Store_Time_" + Sid, ((Object)msgBean.getMsg()));
		    	
		    	msgBean = pRmi.RmiExec(2, this, 0);//物品类型
		    	request.getSession().setAttribute("Lab_Store_PType_" + Sid, ((Object)msgBean.getMsg()));
		    	break;		    	 	
		}
		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
	   	response.sendRedirect(currStatus.getJsp());
	}
		
	public void DaoLabPFile(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone, ServletConfig pConfig) 
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
				    CTime = rs.getCell(0, 1).getContents().trim();
				    Lab_P_Oper = rs.getCell(2, 1).getContents().trim();
				    Operator   = rs.getCell(4, 1).getContents().trim();
				    Opers      = rs.getCell(6, 1).getContents().trim();
				    Operl      = rs.getCell(8, 1).getContents().trim();
				    Func_Corp_Id = CTime;
				    Func_Type_Id = "6666";
				    for(int i=3; i<rsRows; i++)
				    {
				    	if(null==rs.getCell(1, i).getContents().trim()||"".equals(rs.getCell(1, i).getContents().trim()))
				    	{
				    
				    		break;//当excel文档第一行为空时，退出循环
				    		}
				    	Lab_P_Name    = rs.getCell(0, i).getContents().trim();	//备件名称				    	
				    	Lab_P_Fcnt    = rs.getCell(1, i).getContents().trim();	
				    	Lab_P_Icnt    = rs.getCell(2, i).getContents().trim();	
				    	Lab_P_Ocnt    = rs.getCell(3, i).getContents().trim();	
				    	Lab_P_Lcnt    = rs.getCell(4, i).getContents().trim();	
				    	Lab_P_Scnt    = rs.getCell(5, i).getContents().trim();	
				    	if(null==rs.getCell(8, i).getContents().trim()||"".equals(rs.getCell(8, i).getContents().trim()))
				    	{Memo = "无备注";}else{Memo          = rs.getCell(8, i).getContents().trim();}					    		
				    	
				    	msgBean = pRmi.RmiExec(10, this, 0);
				    	System.out.println(msgBean.getStatus());
				    	if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
						{
				    		succCnt ++;
						}
				    }	
				    currStatus.setResult("成功导入[" + String.valueOf(succCnt) + "/" + String.valueOf(rsRows-3) + "]个");				    				   
				}
				else
				{
					currStatus.setResult("文档上传失败！文档过大，必须小于3M!");
				}				
			}
			
			Func_Corp_Id = currStatus.getFunc_Corp_Id();
			if(null == Func_Corp_Id || Func_Corp_Id.equals("9999"))
			{
				Func_Corp_Id = "";
			}						
			Func_Type_Id = currStatus.getFunc_Type_Id();
			if(null == Func_Type_Id || Func_Type_Id.equals("6666"))
			{
				Func_Type_Id = "";
			}
			msgBean = pRmi.RmiExec(0, this, 0);
			request.getSession().setAttribute("Lab_Store_P_" + Sid, ((Object)msgBean.getMsg()));
	    	currStatus.setJsp("Lab_TJ.jsp?Sid=" + Sid);
	    	
	    	msgBean = pRmi.RmiExec(1, this, 0);//盘点日期
	    	request.getSession().setAttribute("Lab_Store_Time_" + Sid, ((Object)msgBean.getMsg()));	  
	    	
	    	msgBean = pRmi.RmiExec(2, this, 0);//物品类型
	    	request.getSession().setAttribute("Lab_Store_PType_" + Sid, ((Object)msgBean.getMsg()));
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
			case 0:
				Sql = " select t.sn, t.lab_p_name, t.lab_p_fcnt, t.lab_p_icnt, t.lab_p_ocnt, t.lab_p_lcnt, t.lab_p_scnt, t.ctime,  t.lab_p_oper, t.operator, t.opers, t.operl, t.memo"+
					  " from lab_store_p t"+
					  " where t.ctime like '"+ Func_Corp_Id +"%'" +
					  " and t.lab_p_name like '"+ Func_Type_Id +"%'" +
					  " order by t.ctime, t.lab_p_name desc";
				break;
				
			case 1://查询盘点时间
				Sql = " select t.sn, t.lab_p_name, t.lab_p_fcnt, t.lab_p_icnt, t.lab_p_ocnt, t.lab_p_lcnt, t.lab_p_scnt, t.ctime,  t.lab_p_oper, t.operator, t.opers, t.operl, t.memo"+
					  " from lab_store_p t"+
					  " group by t.ctime "+
					  " order by t.ctime desc";
				break;
			case 2://查询劳保类型
				Sql = " select t.sn, t.lab_p_name, t.lab_p_fcnt, t.lab_p_icnt, t.lab_p_ocnt, t.lab_p_lcnt, t.lab_p_scnt, t.ctime,  t.lab_p_oper, t.operator, t.opers, t.operl, t.memo"+
					  " from lab_store_p t"+
					  " group by t.lab_p_name "+
					  " order by t.lab_p_name desc";								
				break;
			case 10://添加
				Sql = " insert into lab_store_p(lab_p_name, lab_p_fcnt, lab_p_icnt, lab_p_ocnt, lab_p_lcnt, lab_p_scnt, ctime, lab_p_oper, operator, opers, operl, memo) values('"+ Lab_P_Name +"'," +
						"'"+ Lab_P_Fcnt +"', '"+ Lab_P_Icnt +"', '"+ Lab_P_Ocnt +"', '"+ Lab_P_Lcnt +"', '"+ Lab_P_Scnt +"', '"+ CTime +"', '"+ Lab_P_Oper +"', '"+ Operator +"', '"+ Opers +"', '"+ Operl +"', '"+ Memo +"')";
				break;
			case 13://删除
				Sql = " delete from lab_store_p where sn = '"+ SN +"' ";
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
			setLab_P_Name(pRs.getString(2));			
			setLab_P_Fcnt(pRs.getString(3));
			setLab_P_Icnt(pRs.getString(4));
			setLab_P_Ocnt(pRs.getString(5));
			setLab_P_Lcnt(pRs.getString(6));
			setLab_P_Scnt(pRs.getString(7));
			setCTime(pRs.getString(8));				
			setLab_P_Oper(pRs.getString(9));
			setOperator(pRs.getString(10));
			setOpers(pRs.getString(11));
			setOperl(pRs.getString(12));
			setMemo(pRs.getString(13));
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
			setLab_P_Name(CommUtil.StrToGB2312(request.getParameter("Lab_P_Name")));
			setLab_P_Fcnt(CommUtil.StrToGB2312(request.getParameter("Lab_P_Fcnt")));
			setLab_P_Icnt(CommUtil.StrToGB2312(request.getParameter("Lab_P_Icnt")));
			setLab_P_Ocnt(CommUtil.StrToGB2312(request.getParameter("Lab_P_Ocnt")));
			setLab_P_Lcnt(CommUtil.StrToGB2312(request.getParameter("Lab_P_Lcnt")));
			setLab_P_Scnt(CommUtil.StrToGB2312(request.getParameter("Lab_P_Scnt")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setLab_P_Oper(CommUtil.StrToGB2312(request.getParameter("Lab_P_Oper")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setOpers(CommUtil.StrToGB2312(request.getParameter("Opers")));
			setOperl(CommUtil.StrToGB2312(request.getParameter("Operl")));
			setMemo(CommUtil.StrToGB2312(request.getParameter("Memo")));			
			
			
			
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
			setFunc_Corp_Id(CommUtil.StrToGB2312(request.getParameter("Func_Corp_Id")));
			setFunc_Type_Id(CommUtil.StrToGB2312(request.getParameter("Func_Type_Id")));
			
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String SN;
	private String Lab_P_Name;
	private String Lab_P_Fcnt;
	private String Lab_P_Icnt;
	private String Lab_P_Ocnt;
	private String Lab_P_Lcnt;
	private String Lab_P_Scnt;
	private String CTime;
	private String Lab_P_Oper;
	private String Operator;
	private String Opers;
	private String Operl;
	private String Memo;	
	
	
	private String Sid;
	private String Func_Corp_Id;
	private String Func_Type_Id;
	
	
	
	
	public String getSN() {
		return SN;
	}

	public void setSN(String sN) {
		SN = sN;
	}

	public String getMemo() {
		return Memo;
	}

	public void setMemo(String memo) {
		Memo = memo;
	}

	public String getLab_P_Name() {
		return Lab_P_Name;
	}

	public void setLab_P_Name(String lab_P_Name) {
		Lab_P_Name = lab_P_Name;
	}

	public String getLab_P_Fcnt() {
		return Lab_P_Fcnt;
	}

	public void setLab_P_Fcnt(String lab_P_Fcnt) {
		Lab_P_Fcnt = lab_P_Fcnt;
	}

	public String getLab_P_Icnt() {
		return Lab_P_Icnt;
	}

	public void setLab_P_Icnt(String lab_P_Icnt) {
		Lab_P_Icnt = lab_P_Icnt;
	}

	public String getLab_P_Ocnt() {
		return Lab_P_Ocnt;
	}

	public void setLab_P_Ocnt(String lab_P_Ocnt) {
		Lab_P_Ocnt = lab_P_Ocnt;
	}

	public String getLab_P_Lcnt() {
		return Lab_P_Lcnt;
	}

	public void setLab_P_Lcnt(String lab_P_Lcnt) {
		Lab_P_Lcnt = lab_P_Lcnt;
	}

	public String getLab_P_Scnt() {
		return Lab_P_Scnt;
	}

	public void setLab_P_Scnt(String lab_P_Scnt) {
		Lab_P_Scnt = lab_P_Scnt;
	}

	public String getCTime() {
		return CTime;
	}

	public void setCTime(String cTime) {
		CTime = cTime;
	}

	public String getLab_P_Oper() {
		return Lab_P_Oper;
	}

	public void setLab_P_Oper(String lab_P_Oper) {
		Lab_P_Oper = lab_P_Oper;
	}

	public String getOperator() {
		return Operator;
	}

	public void setOperator(String operator) {
		Operator = operator;
	}

	public String getOpers() {
		return Opers;
	}

	public void setOpers(String opers) {
		Opers = opers;
	}

	public String getOperl() {
		return Operl;
	}

	public void setOperl(String operl) {
		Operl = operl;
	}

	public String getFunc_Type_Id() {
		return Func_Type_Id;
	}

	public void setFunc_Type_Id(String func_Type_Id) {
		Func_Type_Id = func_Type_Id;
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
}