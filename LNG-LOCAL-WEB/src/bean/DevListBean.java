package bean;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

import com.jspsmart.upload.SmartUpload;

import rmi.Rmi;
import rmi.RmiBean;
import util.*;

public class DevListBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_DEV_LIST;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public DevListBean()
	{
		super.className = "DevListBean";
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
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		switch(currStatus.getCmd())
		{
			case 12://删除
			case 11://修改				
			case 10://添加
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));								
			case 14://设备状态修改
				msgBean = pRmi.RmiExec(0, this, 0);
			case 0://查询
		    	request.getSession().setAttribute("Dev_List_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Dev_List.jsp?Sid=" + Sid);
		    	
		    	//设备品种
		    	AqscDeviceBreedBean DeviceBreed = new AqscDeviceBreedBean();
		    	msgBean = pRmi.RmiExec(0, DeviceBreed, 0);
				request.getSession().setAttribute("Dev_List_Breed_" + Sid, (Object)msgBean.getMsg());
		    	
		    	//设备类型
		    	AqscDeviceTypeBean DeviceType = new AqscDeviceTypeBean();
		    	DeviceType.setCType("");
		    	msgBean = pRmi.RmiExec(0, DeviceType, 0);
				request.getSession().setAttribute("Dev_List_Type_" + Sid, (Object)msgBean.getMsg());
		    	
		    	//设备证件
		    	AqscDeviceCardBean DeviceCard = new AqscDeviceCardBean();
		    	msgBean = pRmi.RmiExec(0, DeviceCard, 0);
				request.getSession().setAttribute("Dev_List_Card_" + Sid, (Object)msgBean.getMsg());
				
				//已备证件
				DevListCardBean ListCard = new DevListCardBean();
				msgBean = pRmi.RmiExec(0, ListCard, 0);
				request.getSession().setAttribute("Dev_List_Card_List_" + Sid, (Object)msgBean.getMsg());
		    	break;
		}
		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
	   	response.sendRedirect(currStatus.getJsp());
	}
	//导出Excel 表
	public void DaoToExcel(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) 
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
		try {
			
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
			String ET = currStatus.getVecDate().get(1).toString().substring(5,10);
			String SheetName = "_" + BT + "," + ET;
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
			
			msgBean = pRmi.RmiExec(0, this, 0);
			ArrayList<?> temp = (ArrayList<?>)msgBean.getMsg();
			
			if(temp != null)
			{
				WritableWorkbook book = Workbook.createWorkbook(new File(UPLOAD_PATH + UPLOAD_NAME + ".xls"));
	            WritableSheet sheet = book.createSheet(SheetName, 0);
	            sheet.setColumnView(0, 20);
	            Label label1  = new Label(0, 0, "序号");
	            Label label2  = new Label(1, 0, "设备名称");
	            Label label3  = new Label(2, 0, "规格型号");            
	            Label label4  = new Label(3, 0, "厂家");
	            Label label5  = new Label(4, 0, "安装位置");	            
	            Label label6  = new Label(5, 0, "技术参数");
	            Label label7  = new Label(6, 0, "所属场站");
	            Label label8  = new Label(7, 0, "备注");	           
	            
	            sheet.addCell(label1);
	            sheet.addCell(label2);
	            sheet.addCell(label3);
	            sheet.addCell(label4);
	            sheet.addCell(label5);
	            sheet.addCell(label6);
	            sheet.addCell(label7);
	            sheet.addCell(label8);
	           
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
				int i = 0;
				while(iterator.hasNext())
				{
					
					
					i++;
					DevListBean Bean = (DevListBean)iterator.next();	
					String Dev_Type_Name = Bean.getDev_Type_Name();//设备名称
					String Dev_Name      = Bean.getDev_Name();					
					String WZhi          = Bean.getCpm_Name();
					String JiS           = Bean.getCraft();
					String changjia      = Bean.getAgent();
					String SN            = Bean.getSN();
					sheet.setColumnView(i, 20);
		            Label label = new Label(0,i,SN);    //序号
		            sheet.addCell(label);
		            label = new Label(1,i,Dev_Type_Name);         //设备名称
		            sheet.addCell(label);
		            label = new Label(2,i,Dev_Name);      //规格型号
		            sheet.addCell(label);
		            label = new Label(3,i,changjia); //厂家
		            sheet.addCell(label);
		            label = new Label(4,i,WZhi);      //安装位置
		            sheet.addCell(label);
		            label = new Label(5,i,JiS);          //技术参数
		            sheet.addCell(label);
		            label = new Label(6,i,WZhi);     //所属场站
		            sheet.addCell(label);		            
		            label = new Label(7,i,"");     //备注
		            sheet.addCell(label);		            
		            
		            
				}
				book.write();
	            book.close();
	            try
	    		{
	    			PrintWriter out = response.getWriter();
	    			out.print(UPLOAD_NAME);
	    		}
	    		catch(Exception exp)
	    		{
	    		   exp.printStackTrace();
	    		}
			}

			
		} catch (Exception e) {
			
		}
	

	
	
	}
	
	//文档上传
	public void SaveFile(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone, ServletConfig pConfig) 
	{
		try
		{
			SmartUpload mySmartUpload = new SmartUpload();
			mySmartUpload.initialize(pConfig, request, response);
			mySmartUpload.setAllowedFilesList("doc,docx,xls,xlsx,pdf,DOC,DOCX,XLS,XLSX,PDF,");
			mySmartUpload.upload();
			
			//获取参数
			Sid = mySmartUpload.getRequest().getParameter("Sid");
			SN = mySmartUpload.getRequest().getParameter("SN");
			Cpm_Id = mySmartUpload.getRequest().getParameter("Cpm_Id");
			Dev_Wendang = mySmartUpload.getRequest().getParameter("Dev_Wendang");
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.setCmd(CommUtil.StrToInt(mySmartUpload.getRequest().getParameter("Cmd")));
			currStatus.setFunc_Corp_Id(mySmartUpload.getRequest().getParameter("Func_Corp_Id"));
			switch(currStatus.getCmd())
			{	
				case 13://确定方案修改
					msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
					currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
					if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
					{
						if(mySmartUpload.getFiles().getCount() > 0 && mySmartUpload.getFiles().getFile(0).getFilePathName().trim().length() > 0)
						{
							if(mySmartUpload.getFiles().getFile(0).getSize()/1024 <= 3072)//最大3M
							{
								String FileSaveRoute = "/www/LNG-LOCAL/LNG-LOCAL-WEB/files/upfiles/";
								//删除原有文档
								File delfile = new File(FileSaveRoute + Dev_Wendang);
								if(delfile.isFile() && delfile.exists())
								{
									delfile.delete();
								}
						
								//上传现有文档
								com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);
								Dev_Wendang = new SimpleDateFormat("yyyyMMdd").format(new Date()) + CommUtil.Randon()+ "." + myFile.getFileExt();
								myFile.saveAs(FileSaveRoute + Dev_Wendang);
								
								msgBean = pRmi.RmiExec(13, this, currStatus.getCurrPage());														
							}
							else
							{
								currStatus.setResult("文档上传失败！文档过大，必须小于3M!");
							}
						}
					}
					break;								
				}	
			Func_Corp_Id = currStatus.getFunc_Corp_Id();
			if(null == Func_Corp_Id || Func_Corp_Id.equals("9999"))
			{
				Func_Corp_Id = "";
			}
			msgBean = pRmi.RmiExec(0, this, currStatus.getCurrPage());
			request.getSession().setAttribute("Dev_List_" + Sid, ((Object)msgBean.getMsg()));
			currStatus.setJsp("Dev_List.jsp?Sid=" + Sid);
			request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		   	response.sendRedirect(currStatus.getJsp());
		}
		catch(Exception exp)
		{
			exp.printStackTrace();
		}			
	}
	//ajx 查询设备
	public void ToDes(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone)
	{
		try 
		{
			getHtmlData(request);
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.getHtmlData(request, pFromZone);
			String str = "";					
			ArrayList Dev_Liset;
			PrintWriter outprint = response.getWriter();
			AqscDeviceTypeBean adtBean = new AqscDeviceTypeBean();			
			adtBean.setCType(CType);
			adtBean.setId(Dev_Type);
			msgBean = pRmi.RmiExec(1, adtBean, 0);		
			if(null != msgBean.getMsg())
			{
				Dev_Liset = (ArrayList)msgBean.getMsg();
				if(Dev_Liset != null)
				{
					Iterator  iterator = Dev_Liset.iterator();
					while(iterator.hasNext())
					{
						AqscDeviceTypeBean Bean = (AqscDeviceTypeBean)iterator.next();
						str = Bean.getDes();											
					}
				}
			}else
			{
			 str = "1";	
			 }				
			request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
			outprint.write(str);
		}
		catch (Exception Ex)
		{
			Ex.printStackTrace();
		}
	}
	
	
	
	
	public String getSql(int pCmd)
	{
		String Sql = "";
		switch (pCmd)
		{
			case 0://查询
				Sql = " select t.sn, t.cpm_id, t.cpm_name, t.dev_type, t.dev_type_name, t.dev_id, t.dev_name, t.dev_date, " +
					  " t.ctype, t.ctype_name, t.model, t.craft, t.technology, t.agent, t.agent_man, t.agent_tel, t.card_list, t.dev_wendang, t.dev_zhuangtai, t.dev_shuxing " +
					  " from view_dev_list t " +
					  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
					  "   and t.ctype like '"+ Func_Corp_Id +"%'" +
					  "   order by t.cpm_id, t.dev_type, t.sn asc ";
				break;
			case 1://全部设备
				Sql = " select t.sn, t.cpm_id, t.cpm_name, t.dev_type, t.dev_type_name, t.dev_id, t.dev_name, t.dev_date, " +
				  	  " t.ctype, t.ctype_name, t.model, t.craft, t.technology, t.agent, t.agent_man, t.agent_tel, t.card_list, t.dev_wendang, t.dev_zhuangtai, t.dev_shuxing " +
				  	  " from view_dev_list t " +
				  	  " order by t.cpm_id, t.dev_type, t.sn asc ";
				break;
			case 10://添加
				Sql = " insert into dev_list(cpm_id, dev_type, dev_id, dev_name, dev_date, dev_wendang, dev_zhuangtai, dev_shuxing )" +
					  " values('"+ Cpm_Id +"', '"+ Dev_Type +"', '"+ Dev_Id +"', '"+ Dev_Name +"', '"+ Dev_Date +"',  '"+ Dev_Wendang +"',  '"+ Dev_Zhuangtai +"',  '"+ Dev_ShuXing +"' )";
				break;
			case 11://修改
				Sql = " update dev_list t set t.dev_id = '"+ Dev_Id +"', t.dev_name = '"+ Dev_Name +"', t.dev_date = '"+ Dev_Date +"' , t.dev_shuxing = '"+ Dev_ShuXing +"'where t.sn = '"+ SN +"' ";
				break;
			case 12://删除
				Sql = " delete from dev_list where sn = '"+ SN +"' ";
				break;
			case 13:
				Sql = " update dev_list t set t.Dev_Wendang = '"+ Dev_Wendang +"' where t.sn = '"+ SN +"' ";				
				break;
			case 14://修改状态
				Sql = " update dev_list t set t.dev_zhuangtai = '"+ Dev_Zhuangtai +"' where cpm_Id = '"+ Cpm_Id +"' and dev_type = '"+ Dev_Type +"' and dev_name = '"+ Dev_Name +"' ";
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
			setCpm_Id(pRs.getString(2));
			setCpm_Name(pRs.getString(3));
			setDev_Type(pRs.getString(4));
			setDev_Type_Name(pRs.getString(5));
			setDev_Id(pRs.getString(6));
			setDev_Name(pRs.getString(7));
			setDev_Date(pRs.getString(8));
			setCType(pRs.getString(9));
			setCType_Name(pRs.getString(10));
			setModel(pRs.getString(11));
			setCraft(pRs.getString(12));
			setTechnology(pRs.getString(13));
			setAgent(pRs.getString(14));
			setAgent_Man(pRs.getString(15));
			setAgent_Tel(pRs.getString(16));
			setCard_List(pRs.getString(17));		
			setDev_Wendang(pRs.getString(18));
			setDev_Zhuangtai(pRs.getString(19));
			setDev_ShuXing(pRs.getString(20));
			
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
			setCpm_Id(CommUtil.StrToGB2312(request.getParameter("Cpm_Id")));
			setCpm_Name(CommUtil.StrToGB2312(request.getParameter("Cpm_Name")));
			setDev_Type(CommUtil.StrToGB2312(request.getParameter("Dev_Type")));
			setDev_Type_Name(CommUtil.StrToGB2312(request.getParameter("Dev_Type_Name")));
			setDev_Id(CommUtil.StrToGB2312(request.getParameter("Dev_Id")));
			setDev_Name(CommUtil.StrToGB2312(request.getParameter("Dev_Name")));
			setDev_Date(CommUtil.StrToGB2312(request.getParameter("Dev_Date")));
			setCType(CommUtil.StrToGB2312(request.getParameter("CType")));
			setCType_Name(CommUtil.StrToGB2312(request.getParameter("CType_Name")));
			setModel(CommUtil.StrToGB2312(request.getParameter("Model")));
			setCraft(CommUtil.StrToGB2312(request.getParameter("Craft")));
			setTechnology(CommUtil.StrToGB2312(request.getParameter("Technology")));
			setAgent(CommUtil.StrToGB2312(request.getParameter("Agent")));
			setAgent_Man(CommUtil.StrToGB2312(request.getParameter("Agent_Man")));
			setAgent_Tel(CommUtil.StrToGB2312(request.getParameter("Agent_Tel")));
			setCard_List(CommUtil.StrToGB2312(request.getParameter("Card_List")));
			setDev_Wendang(CommUtil.StrToGB2312(request.getParameter("Dev_Wendang")));
			setDev_Zhuangtai(CommUtil.StrToGB2312(request.getParameter("Dev_Zhuangtai")));
			setDev_ShuXing(CommUtil.StrToGB2312(request.getParameter("Dev_ShuXing")));
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String SN;
	private String Cpm_Id;
	private String Cpm_Name;
	private String Dev_Type;
	private String Dev_Type_Name;
	private String Dev_Id;
	private String Dev_Name;
	private String Dev_Date;
	private String Dev_Wendang;
	private String Dev_Zhuangtai;
	private String Dev_ShuXing;
	private String CType;
	

	private String CType_Name;
	private String Model;
	private String Craft;
	private String Technology;
	private String Agent;
	private String Agent_Man;
	private String Agent_Tel;
	private String Card_List;
	
	private String Sid;
	private String Func_Corp_Id;


	public String getDev_ShuXing() {
		return Dev_ShuXing;
	}

	public void setDev_ShuXing(String dev_ShuXing) {
		Dev_ShuXing = dev_ShuXing;
	}

	public String getDev_Zhuangtai() {
		return Dev_Zhuangtai;
	}

	public void setDev_Zhuangtai(String dev_Zhuangtai) {
		Dev_Zhuangtai = dev_Zhuangtai;
	}

	public String getDev_Wendang() {
		return Dev_Wendang;
	}

	public void setDev_Wendang(String dev_Wendang) {
		Dev_Wendang = dev_Wendang;
	}

	
	public String getSN() {
		return SN;
	}

	public void setSN(String sN) {
		SN = sN;
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

	public String getDev_Type() {
		return Dev_Type;
	}

	public void setDev_Type(String devType) {
		Dev_Type = devType;
	}

	public String getDev_Type_Name() {
		return Dev_Type_Name;
	}

	public void setDev_Type_Name(String devTypeName) {
		Dev_Type_Name = devTypeName;
	}

	public String getDev_Id() {
		return Dev_Id;
	}

	public void setDev_Id(String devId) {
		Dev_Id = devId;
	}

	public String getDev_Name() {
		return Dev_Name;
	}

	public void setDev_Name(String devName) {
		Dev_Name = devName;
	}

	public String getDev_Date() {
		return Dev_Date;
	}

	public void setDev_Date(String devDate) {
		Dev_Date = devDate;
	}

	public String getCType() {
		return CType;
	}

	public void setCType(String cType) {
		CType = cType;
	}
	
	public String getCType_Name() {
		return CType_Name;
	}

	public void setCType_Name(String cTypeName) {
		CType_Name = cTypeName;
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

	public String getFunc_Corp_Id() {
		return Func_Corp_Id;
	}

	public void setFunc_Corp_Id(String funcCorpId) {
		Func_Corp_Id = funcCorpId;
	}
}