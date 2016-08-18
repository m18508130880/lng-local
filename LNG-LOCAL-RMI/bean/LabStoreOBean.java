package bean;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
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

import com.jspsmart.upload.SmartUpload;

import jxl.Sheet;
import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import rmi.Rmi;
import rmi.RmiBean;
import util.*;

public class LabStoreOBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_LAB_STORE_O;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public LabStoreOBean()
	{
		super.className = "LabStoreOBean";
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
		
		//状态
		Func_Sub_Id = currStatus.getFunc_Sub_Id()+"";
		if(Func_Sub_Id.equals("9"))
		{
			Func_Sub_Id = "";
		}
		Func_Type_Id = currStatus.getFunc_Type_Id();
		if(null == Func_Type_Id || Func_Type_Id.equals("888"))
		{
			Func_Type_Id = "";
		}
		
		Func_Cpm_Id = currStatus.getFunc_Cpm_Id();
		if(null == Func_Cpm_Id || Func_Cpm_Id.equals("666"))
		{
			Func_Cpm_Id = "";
		}
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
		switch(currStatus.getCmd())
		{			
			case 13:
			case 10://添加
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(0, this, currStatus.getCurrPage());
			case 0://查询
		    	request.getSession().setAttribute("Lab_Store_O_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Lab_Store_O.jsp?Sid=" + Sid);
		    	
		    	//领用单位查询
		    	msgBean = pRmi.RmiExec(1, this, 0);
				request.getSession().setAttribute("Lab_Store_" + Sid, (Object)msgBean.getMsg());
				//劳保用品查询
		    	msgBean = pRmi.RmiExec(2, this, 0);
				request.getSession().setAttribute("Lab_Store_Type_" + Sid, (Object)msgBean.getMsg());
				
		    	break;
		}
		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
	   	response.sendRedirect(currStatus.getJsp());
	}
	
	//明细导出
	public void ExportToExcel(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) 
	{
		try
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
			
			//状态
			Func_Sub_Id = currStatus.getFunc_Sub_Id()+"";
			if(Func_Sub_Id.equals("9"))
			{
				Func_Sub_Id = "";
			}
			
			//清除历史
			
			//生成当前
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
			String ET = currStatus.getVecDate().get(1).toString().substring(5,10);
			String SheetName = "_" + BT + "," + ET;
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
			
			msgBean = pRmi.RmiExec(0, this, 0);
			ArrayList<?> temp = (ArrayList<?>)msgBean.getMsg();
			if(temp != null)
			{
				//创建文件
				WritableWorkbook book = Workbook.createWorkbook(new File(UPLOAD_PATH + UPLOAD_NAME + ".xls"));
	            WritableSheet sheet = book.createSheet(SheetName, 0);
	            
	            //字体格式1
	            WritableFont wf = new WritableFont(WritableFont.createFont("normal"), 18, WritableFont.BOLD , false);
				WritableCellFormat wff = new WritableCellFormat(wf);
				wf.setColour(Colour.BLACK);//字体颜色
				wff.setAlignment(Alignment.CENTRE);//设置居中
				wff.setBorder(Border.ALL, BorderLineStyle.THIN);//设置边框线
				wff.setBackground(jxl.format.Colour.TURQUOISE);//设置单元格的背景颜色			
				
				//字体格式2
				WritableFont wf2 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.BOLD , false);
				WritableCellFormat wff2 = new WritableCellFormat(wf2);
				wf2.setColour(Colour.BLACK);//字体颜色
				wff2.setAlignment(Alignment.CENTRE);//设置居中
				wff2.setBorder(Border.ALL, BorderLineStyle.THIN);//设置边框线
				
				//字体格式3
				WritableFont wf3 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff3 = new WritableCellFormat(wf3);
				wf3.setColour(Colour.BLACK);//字体颜色
				wff3.setAlignment(Alignment.CENTRE);//设置居中
				wff3.setBorder(Border.ALL, BorderLineStyle.THIN);//设置边框线
				
				sheet.setRowView(0, 600);
	            sheet.setColumnView(0, 20);
	            Label label = null;
	            label = new Label(0, 0, "劳保用品出库记录", wff);
	            sheet.addCell(label);
	            label = new Label(1, 0, "");
	            sheet.addCell(label);
	            label = new Label(2, 0, "");
	            sheet.addCell(label);
	            label = new Label(3, 0, "");
	            sheet.addCell(label);
	            label = new Label(4, 0, "");
	            sheet.addCell(label);
	            label = new Label(5, 0, "");
	            sheet.addCell(label);
	            label = new Label(6, 0, "");
	            sheet.addCell(label);
	            label = new Label(7, 0, "");
	            sheet.addCell(label);
	            label = new Label(8, 0, "");
	            sheet.addCell(label);
	            label = new Label(9, 0, "");
	            sheet.addCell(label);
	            label = new Label(10, 0, "");
	            sheet.addCell(label);
	            label = new Label(11, 0, "");
	            sheet.addCell(label);
	            label = new Label(12, 0, "");
	            sheet.addCell(label);
	            label = new Label(13, 0, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,0,13,0);
	            
	            sheet.setRowView(1, 400);
	            sheet.setColumnView(1, 20);
	            label  = new Label(0, 1, "序号", wff2);
	            sheet.addCell(label);
	            label  = new Label(1, 1, "产品名称", wff2);
	            sheet.addCell(label);
	            label  = new Label(2, 1, "规格型号", wff2);
	            sheet.addCell(label);
	            label  = new Label(3, 1, "出库日期", wff2);
	            sheet.addCell(label);
	            label  = new Label(4, 1, "去向场站", wff2);
	            sheet.addCell(label);
	            label  = new Label(5, 1, "出前数量", wff2);
	            sheet.addCell(label);
	            label  = new Label(6, 1, "出库数量", wff2);
	            sheet.addCell(label);
	            label  = new Label(7, 1, "出后数量", wff2);
	            sheet.addCell(label);
	            label  = new Label(8, 1, "领用人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(9, 1, "出库备注", wff2);
	            sheet.addCell(label);
	            label  = new Label(10, 1, "记录状态", wff2);
	            sheet.addCell(label);
	            label  = new Label(11, 1, "录入人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(12, 1, "作废人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(13, 1, "作废原因", wff2);
	            sheet.addCell(label);
	            
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
				int i = 1;
				while(iterator.hasNext())
				{
					i++;
					LabStoreOBean Bean = (LabStoreOBean)iterator.next();
					String D_Lab_Type_Name = Bean.getLab_Type_Name();
					String D_Lab_Mode      = Bean.getLab_Mode();
					String D_Model         = Bean.getModel();
					String D_Lab_O_Time    = Bean.getLab_O_Time();
					String D_Lab_Mode_Name = "/";
					if(null != D_Model && D_Model.length() > 0)
					{
						String[] List = D_Model.split(",");
						if(List.length >= Integer.parseInt(D_Lab_Mode))
							D_Lab_Mode_Name = List[Integer.parseInt(D_Lab_Mode)-1];
					}
					
					String D_Lab_O_Stat_Name = Bean.getLab_O_Stat_Name();
					String D_Lab_O_BCnt      = Bean.getLab_O_BCnt();
					String D_Lab_O_MCnt      = Bean.getLab_O_MCnt();
					String D_Lab_O_ACnt      = Bean.getLab_O_ACnt();
					String D_Lab_O_Man       = Bean.getLab_O_Man();
					String D_Lab_O_Memo      = Bean.getLab_O_Memo();
					
					String D_Operator_Name = Bean.getOperator_Name();
					String D_Status_OP_Name= Bean.getStatus_OP_Name();
					String D_Status_Memo   = Bean.getStatus_Memo();
					if(null == D_Status_OP_Name){D_Status_OP_Name = "";}
					if(null == D_Status_Memo){D_Status_Memo = "";}
					
					String str_Status = "";
					switch(Integer.parseInt(Bean.getStatus()))
					{
						case 1:
							str_Status = "有效";
							break;
						case 2:
							str_Status = "无效";
							break;
					}
									
					sheet.setRowView(i, 400);
					sheet.setColumnView(i, 20);
					label = new Label(0,i,(i-1)+"", wff3);
		            sheet.addCell(label);
		            label = new Label(1,i,D_Lab_Type_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(2,i,D_Lab_Mode_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(3,i,D_Lab_O_Time, wff3);
		            sheet.addCell(label);
		            label = new Label(4,i,D_Lab_O_Stat_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(5,i,D_Lab_O_BCnt, wff3);
		            sheet.addCell(label);
		            label = new Label(6,i,D_Lab_O_MCnt, wff3);
		            sheet.addCell(label);
		            label = new Label(7,i,D_Lab_O_ACnt, wff3);
		            sheet.addCell(label);
		            label = new Label(8,i,D_Lab_O_Man, wff3);
		            sheet.addCell(label);		
		            label = new Label(9,i,D_Lab_O_Memo, wff3);
		            sheet.addCell(label);	            
		            label = new Label(10,i,str_Status, wff3);
		            sheet.addCell(label);
		            label = new Label(11,i,D_Operator_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(12,i,D_Status_OP_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(13,i,D_Status_Memo, wff3);
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
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
	}
	
	//审核
	public void doStatus(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		PrintWriter outprint = response.getWriter();
		String Resp = "9999";
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		Resp = ((String)msgBean.getMsg());
    	
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		outprint.write(Resp);
	}
	//出库批量导入
	public void DaoLabOFile(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone, ServletConfig pConfig) 
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
				    for(int i=3; i<rsRows; i++)
				    {
				    	if(null==rs.getCell(1, i).getContents().trim()||"".equals(rs.getCell(1, i).getContents().trim()))
				    	{
				    
				    		break;//当excel文档第一行为空时，退出循环
				    		}
				    	Lab_Type    = rs.getCell(1, i).getContents().trim();	//备件名称				    	
				    	Lab_Mode    = rs.getCell(2, i).getContents().trim();	//规格型号	 
				    	Lab_O_Ycnt       = rs.getCell(3, i).getContents().trim();
				    	Lab_O_Scnt     = rs.getCell(4, i).getContents().trim();
				    	Operator   = rs.getCell(5, i).getContents().trim();
				    	Operator_Name     = rs.getCell(6, i).getContents().trim();				    	
				    	Foperator    = rs.getCell(7, i).getContents().trim();	
				    	CTime      = rs.getCell(8, i).getContents().trim();
				    	Status_Memo = rs.getCell(9, i).getContents().trim();				    	
				    	msgBean = pRmi.RmiExec(10, this, 0);
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
			if(null == Func_Type_Id || Func_Type_Id.equals("888"))
			{
				Func_Type_Id = "";
			}
			Func_Cpm_Id = currStatus.getFunc_Cpm_Id();
			if(null == Func_Cpm_Id || Func_Cpm_Id.equals("666"))
			{
				Func_Cpm_Id = "";
			}
			
			msgBean = pRmi.RmiExec(0, this, 0);			
			request.getSession().setAttribute("Lab_Store_O_" + Sid, ((Object)msgBean.getMsg()));
	    	currStatus.setTotalRecord(msgBean.getCount());
	    	currStatus.setJsp("Lab_Store_O.jsp?Sid=" + Sid);
	    	
	    	//领用单位查询
	    	msgBean = pRmi.RmiExec(1, this, 0);
			request.getSession().setAttribute("Lab_Store_" + Sid, (Object)msgBean.getMsg());
			//劳保用品查询
	    	msgBean = pRmi.RmiExec(2, this, 0);
			request.getSession().setAttribute("Lab_Store_Type_" + Sid, (Object)msgBean.getMsg());							
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
				Sql = " select t.sn,t.lab_type,t.lab_mode,t.lab_o_ycnt,t.lab_o_scnt,t.operator,t.operator_name,t.foperator,t.ctime,t.status_memo " +
		  	  	  	  " from lab_store_o t " +
		  	  	  	  " where t.operator  like '"+ Func_Cpm_Id +"%' " +
			  	  	  " and t.lab_type like '"+ Func_Corp_Id +"%' " +
			  	  	  " and t.lab_mode like '"+ Func_Type_Id +"%'" +
			  	  	  " and t.ctime >= date_format('"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"', '%Y-%m-%d')" +
			  	  	  " and t.ctime <= date_format('"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"', '%Y-%m-%d')" +
			  	  	  " order by t.lab_type, t.lab_mode, t.ctime desc ";
				break;
				
			case 1 ://领用单位查询
				Sql = " select t.sn,t.lab_type,t.lab_mode,t.lab_o_ycnt,t.lab_o_scnt,t.operator,t.operator_name,t.foperator,t.ctime,t.status_memo " +
					  "from lab_store_o t"+
					  " group by t.operator"+
					  " order by t.operator";
				break;
			case 2://劳保查询
				Sql = " select t.sn,t.lab_type,t.lab_mode,t.lab_o_ycnt,t.lab_o_scnt,t.operator,t.operator_name,t.foperator,t.ctime,t.status_memo " +
					  "from lab_store_o t "+
					  "group by t.lab_type";
				break;
			case 3://统计查询
				Sql = " select t.sn,t.lab_type,t.lab_mode,sum(t.lab_o_ycnt),sum(t.lab_o_scnt),t.operator,t.operator_name,t.foperator,t.ctime,t.status_memo " +
			  	  	  " from lab_store_o t " +			 	  	 
			  	  	  " where t.lab_type like '"+ Func_Corp_Id +"%' " +
			  	  	  " and t.lab_mode like '"+ Func_Type_Id +"%'" +
			  	  	  " and t.ctime >= '"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"'" +
					  " and t.ctime <= '"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"' " +
			  	  	  " group by t.operator,t.lab_type,t.lab_mode "+
					  " order by t.operator,t.lab_type,t.lab_mode";
				break;
			case 4://合计站点用量	
				Sql = " select t.sn,t.lab_type,t.lab_mode,t.lab_o_ycnt,sum(t.lab_o_scnt),t.operator,t.operator_name,t.foperator,t.ctime,t.status_memo " +
				  	  " from lab_store_o t " +	
				  	  " group by t.operator, t.lab_type, t.lab_mode "+
				  	  " ORDER BY t.operator, t.lab_type, t.lab_mode ";
				break;
				
			case 10://添加
				Sql = " insert into lab_store_o(lab_type, lab_mode,lab_o_ycnt, lab_o_scnt,operator,operator_name,foperator,ctime,status_memo)" +
					  " values('"+ Lab_Type +"', '"+ Lab_Mode +"', '"+ Lab_O_Ycnt +"', '"+ Lab_O_Scnt +"', '"+ Operator +"', '"+ Operator_Name +"', '"+ Foperator +"', '"+ CTime +"' , '"+ Status_Memo +"')";
				break;		
			case 13://删除
				Sql = " delete from lab_store_o where sn = '"+ SN +"' ";
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
			setLab_Type(pRs.getString(2));
			setLab_Mode(pRs.getString(3));	
			setLab_O_Ycnt(pRs.getString(4));
			setLab_O_Scnt(pRs.getString(5));			
			setOperator(pRs.getString(6));
			setOperator_Name(pRs.getString(7));
			setFoperator(pRs.getString(8));
			setCTime(pRs.getString(9));
			setStatus_Memo(pRs.getString(10));
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
			setLab_Type(CommUtil.StrToGB2312(request.getParameter("Lab_Type")));
			setLab_Mode(CommUtil.StrToGB2312(request.getParameter("Lab_Mode")));
			setLab_O_Ycnt(CommUtil.StrToGB2312(request.getParameter("Lab_O_Ycnt")));
			setLab_O_Scnt(CommUtil.StrToGB2312(request.getParameter("Lab_O_Scnt")));				
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setOperator_Name(CommUtil.StrToGB2312(request.getParameter("Operator_Name")));
			setFoperator(CommUtil.StrToGB2312(request.getParameter("Foperator")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setStatus_Memo(CommUtil.StrToGB2312(request.getParameter("Status_Memo")));
			
			setCpm_Id(CommUtil.StrToGB2312(request.getParameter("Cpm_Id")));
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String SN;
	private String Lab_Type;	
	private String Lab_Mode;
	private String Lab_O_Ycnt;
	private String Lab_O_Scnt;
	private String Operator;
	private String Operator_Name;
	private String Foperator;
	private String CTime;	
	private String Status_Memo;
	
	private String Model;
	private String Unit;
	private String Lab_O_Time;
	private String Lab_O_Stat;
	private String Lab_O_Stat_Name;
	private String Lab_O_BCnt;
	private String Lab_O_MCnt;
	private String Lab_O_ACnt;
	private String Lab_O_Man;
	private String Lab_O_Memo;
	private String Status;
	private String Status_OP;
	private String Status_OP_Name;
	private String Lab_Type_Name;
	private String Cpm_Id;
	private String Sid;
	private String Func_Corp_Id;
	private String Func_Sub_Id;
	private String Func_Type_Id;
	private String Func_Cpm_Id;
	public String getFunc_Cpm_Id() {
		return Func_Cpm_Id;
	}

	public void setFunc_Cpm_Id(String func_Cpm_Id) {
		Func_Cpm_Id = func_Cpm_Id;
	}

	public String getFunc_Type_Id() {
		return Func_Type_Id;
	}

	public void setFunc_Type_Id(String func_Type_Id) {
		Func_Type_Id = func_Type_Id;
	}

	public String getLab_O_Ycnt() {
		return Lab_O_Ycnt;
	}

	public void setLab_O_Ycnt(String lab_O_Ycnt) {
		Lab_O_Ycnt = lab_O_Ycnt;
	}

	public String getLab_O_Scnt() {
		return Lab_O_Scnt;
	}

	public void setLab_O_Scnt(String lab_O_Scnt) {
		Lab_O_Scnt = lab_O_Scnt;
	}

	public String getFoperator() {
		return Foperator;
	}

	public void setFoperator(String foperator) {
		Foperator = foperator;
	}

	public String getSN() {
		return SN;
	}

	public void setSN(String sN) {
		SN = sN;
	}

	public String getLab_Type() {
		return Lab_Type;
	}

	public void setLab_Type(String labType) {
		Lab_Type = labType;
	}

	public String getLab_Type_Name() {
		return Lab_Type_Name;
	}

	public void setLab_Type_Name(String labTypeName) {
		Lab_Type_Name = labTypeName;
	}

	public String getLab_Mode() {
		return Lab_Mode;
	}

	public void setLab_Mode(String labMode) {
		Lab_Mode = labMode;
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

	public String getLab_O_Time() {
		return Lab_O_Time;
	}

	public void setLab_O_Time(String labOTime) {
		Lab_O_Time = labOTime;
	}

	public String getLab_O_Stat() {
		return Lab_O_Stat;
	}

	public void setLab_O_Stat(String labOStat) {
		Lab_O_Stat = labOStat;
	}

	public String getLab_O_Stat_Name() {
		return Lab_O_Stat_Name;
	}

	public void setLab_O_Stat_Name(String labOStatName) {
		Lab_O_Stat_Name = labOStatName;
	}

	public String getLab_O_BCnt() {
		return Lab_O_BCnt;
	}

	public void setLab_O_BCnt(String labOBCnt) {
		Lab_O_BCnt = labOBCnt;
	}

	public String getLab_O_MCnt() {
		return Lab_O_MCnt;
	}

	public void setLab_O_MCnt(String labOMCnt) {
		Lab_O_MCnt = labOMCnt;
	}

	public String getLab_O_ACnt() {
		return Lab_O_ACnt;
	}

	public void setLab_O_ACnt(String labOACnt) {
		Lab_O_ACnt = labOACnt;
	}

	public String getLab_O_Man() {
		return Lab_O_Man;
	}

	public void setLab_O_Man(String labOMan) {
		Lab_O_Man = labOMan;
	}

	public String getLab_O_Memo() {
		return Lab_O_Memo;
	}

	public void setLab_O_Memo(String labOMemo) {
		Lab_O_Memo = labOMemo;
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

	public String getStatus() {
		return Status;
	}

	public void setStatus(String status) {
		Status = status;
	}

	public String getStatus_OP() {
		return Status_OP;
	}

	public void setStatus_OP(String statusOP) {
		Status_OP = statusOP;
	}

	public String getStatus_OP_Name() {
		return Status_OP_Name;
	}

	public void setStatus_OP_Name(String statusOPName) {
		Status_OP_Name = statusOPName;
	}

	public String getStatus_Memo() {
		return Status_Memo;
	}

	public void setStatus_Memo(String statusMemo) {
		Status_Memo = statusMemo;
	}

	public String getCpm_Id() {
		return Cpm_Id;
	}

	public void setCpm_Id(String cpmId) {
		Cpm_Id = cpmId;
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

	public String getFunc_Sub_Id() {
		return Func_Sub_Id;
	}

	public void setFunc_Sub_Id(String funcSubId) {
		Func_Sub_Id = funcSubId;
	}
}