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

public class SpaStoreIBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_SPA_STORE_I;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public SpaStoreIBean()
	{
		super.className = "SpaStoreIBean";
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
		
		//类别
		Func_Sub_Id = currStatus.getFunc_Sub_Id()+"";
		if(Func_Sub_Id.equals("9"))
		{
			Func_Sub_Id = "";
		}
		
		//状态
		Func_Sel_Id = currStatus.getFunc_Sel_Id()+"";
		if(Func_Sel_Id.equals("9"))
		{
			Func_Sel_Id = "";
		}
		
		//申购单号
		Func_Type_Id = currStatus.getFunc_Type_Id();
		if(null == Func_Type_Id)
		{
			Func_Type_Id = "";
		}
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
		switch(currStatus.getCmd())
		{			
		
		
		
			case 10://添加
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(0, this, currStatus.getCurrPage());
			case 0://查询
		    	request.getSession().setAttribute("Spa_Store_I_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Spa_Store_I.jsp?Sid=" + Sid);
		    	
		    	//库存台账
		    	SpaStoreBean Store = new SpaStoreBean();
		    	Store.setFunc_Corp_Id("");
		    	Store.setFunc_Sub_Id("");
		    	msgBean = pRmi.RmiExec(0, Store, 0);
				request.getSession().setAttribute("Spa_Store_" + Sid, (Object)msgBean.getMsg());
		    	break;
			
			case 1://入库查询
				request.getSession().setAttribute("Spa_Store_IN_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Spa_Store_IN.jsp?Sid=" + Sid);
		    	
		    	//库存台账
		    	/**SpaStoreBean Store2 = new SpaStoreBean();
		    	Store2.setFunc_Corp_Id("");
		    	Store2.setFunc_Sub_Id("");
		    	msgBean = pRmi.RmiExec(0, Store2, 0);
				request.getSession().setAttribute("Spa_Store_" + Sid, (Object)msgBean.getMsg());**/
		    	//备品查询
		    	msgBean = pRmi.RmiExec(2, this, 0);
		    	request.getSession().setAttribute("Spa_Store_MC_" + Sid, ((Object)msgBean.getMsg()));
		    	
		    	msgBean = pRmi.RmiExec(3, this, 0);
		    	request.getSession().setAttribute("Spa_Store_XH_" + Sid, ((Object)msgBean.getMsg()));
		    	//类型查询
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
			
			//类别
			Func_Sub_Id = currStatus.getFunc_Sub_Id()+"";
			if(Func_Sub_Id.equals("9"))
			{
				Func_Sub_Id = "";
			}
			
			//状态
			Func_Sel_Id = currStatus.getFunc_Sel_Id()+"";
			if(Func_Sel_Id.equals("9"))
			{
				Func_Sel_Id = "";
			}
			
			//申购单号
			Func_Type_Id = currStatus.getFunc_Type_Id();
			if(null == Func_Type_Id)
			{
				Func_Type_Id = "";
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
	            Label label = new Label(0, 0, "备品备件申购记录", wff);
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
	            sheet.mergeCells(0,0,12,0);
	            
	            sheet.setRowView(1, 400);
	            sheet.setColumnView(1, 20);
	            label  = new Label(0, 1, "序号", wff2);
	            sheet.addCell(label);
	            label  = new Label(1, 1, "备品备件", wff2);
	            sheet.addCell(label);
	            label  = new Label(2, 1, "规格型号", wff2);
	            sheet.addCell(label);
	            label  = new Label(3, 1, "申购时间", wff2);
	            sheet.addCell(label);
	            label  = new Label(4, 1, "申购单号", wff2);
	            sheet.addCell(label);
	            label  = new Label(5, 1, "申购数量", wff2);
	            sheet.addCell(label);
	            label  = new Label(6, 1, "申购单价", wff2);
	            sheet.addCell(label);
	            label  = new Label(7, 1, "申购金额", wff2);
	            sheet.addCell(label);
	            label  = new Label(8, 1, "申购备注", wff2);
	            sheet.addCell(label);
	            label  = new Label(9, 1, "申购人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(10, 1, "记录状态", wff2);
	            sheet.addCell(label);
	            label  = new Label(11, 1, "审核人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(12, 1, "审核备注", wff2);
	            sheet.addCell(label);
	            
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
				int i = 1;
				while(iterator.hasNext())
				{
					i++;
					//SpaStoreIBean Bean = (SpaStoreIBean)iterator.next();
	
					//String D_Spa_Mode      = Bean.getSpa_Mode();
				
				
					
				
					
				
					
					
					sheet.setRowView(i, 400);
					sheet.setColumnView(i, 20);
					label = new Label(0,i,(i-1)+"", wff3);
		            sheet.addCell(label);
		          /**  label = new Label(1,i,D_Spa_Type_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(2,i,Spa_Mode_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(3,i,D_Spa_I_Time, wff3);
		            sheet.addCell(label);
		            label = new Label(4,i,D_Spa_I_Numb, wff3);
		            sheet.addCell(label);
		            label = new Label(5,i,D_Spa_I_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(6,i,D_Spa_I_Price, wff3);
		            sheet.addCell(label);
		            label = new Label(7,i,D_Spa_I_Amt, wff3);
		            sheet.addCell(label);
		            label = new Label(8,i,D_Spa_I_Memo, wff3);
		            sheet.addCell(label);
		            label = new Label(9,i,D_Operator_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(10,i,str_Status, wff3);
		            sheet.addCell(label);
		            label = new Label(11,i,D_Status_OP_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(12,i,D_Status_Memo, wff3);**/
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
	
	//明细导出
	public void IN_ExportToExcel(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) 
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
			
			//类别
			Func_Sub_Id = currStatus.getFunc_Sub_Id()+"";
			if(Func_Sub_Id.equals("9"))
			{
				Func_Sub_Id = "";
			}
			
			//状态
			Func_Sel_Id = currStatus.getFunc_Sel_Id()+"";
			if(Func_Sel_Id.equals("9"))
			{
				Func_Sel_Id = "";
			}
			
			//申购单号
			Func_Type_Id = currStatus.getFunc_Type_Id();
			if(null == Func_Type_Id)
			{
				Func_Type_Id = "";
			}
			
			//清除历史
			
			//生成当前
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
			String ET = currStatus.getVecDate().get(1).toString().substring(5,10);
			String SheetName = "_" + BT + "," + ET;
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
			
			msgBean = pRmi.RmiExec(1, this, 0);
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
	            Label label = new Label(0, 0, "备品备件入库记录", wff);
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
	            label = new Label(14, 0, "");
	            sheet.addCell(label);
	            label = new Label(15, 0, "");
	            sheet.addCell(label);
	            label = new Label(16, 0, "");
	            sheet.addCell(label);
	            label = new Label(17, 0, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,0,17,0);
	            
	            sheet.setRowView(1, 400);
	            sheet.setColumnView(1, 20);
	            label  = new Label(0, 1, "序号", wff2);
	            sheet.addCell(label);
	            label  = new Label(1, 1, "备品备件", wff2);
	            sheet.addCell(label);
	            label  = new Label(2, 1, "规格型号", wff2);
	            sheet.addCell(label);
	            label  = new Label(3, 1, "申购时间", wff2);
	            sheet.addCell(label);
	            label  = new Label(4, 1, "申购单号", wff2);
	            sheet.addCell(label);
	            label  = new Label(5, 1, "申购数量", wff2);
	            sheet.addCell(label);
	            label  = new Label(6, 1, "申购单价", wff2);
	            sheet.addCell(label);
	            label  = new Label(7, 1, "申购金额", wff2);
	            sheet.addCell(label);
	            label  = new Label(8, 1, "申购备注", wff2);
	            sheet.addCell(label);
	            label  = new Label(9, 1, "申购人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(10, 1, "记录状态", wff2);
	            sheet.addCell(label);
	            label  = new Label(11, 1, "审核人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(12, 1, "审核备注", wff2);
	            sheet.addCell(label);
	            label  = new Label(13, 1, "入库状态", wff2);
	            sheet.addCell(label);
	            label  = new Label(14, 1, "交货单号", wff2);
	            sheet.addCell(label);
	            label  = new Label(15, 1, "交货数量", wff2);
	            sheet.addCell(label);
	            label  = new Label(16, 1, "交货日期", wff2);
	            sheet.addCell(label);
	            label  = new Label(17, 1, "经办人员", wff2);
	            sheet.addCell(label);
	            
	           // ArrayList<?> User_User_Info = (ArrayList<?>)request.getSession().getAttribute("User_User_Info_" + Sid);
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
				//int i = 1;
				while(iterator.hasNext())
				{
					//i++;
					//SpaStoreIBean Bean = (SpaStoreIBean)iterator.next();

					//String D_Spa_Mode      = Bean.getSpa_Mode();

					//String Spa_Mode_Name   = "/";
					/**if(null != D_Model && D_Model.length() > 0)
					{
						String[] List = D_Model.split(",");
						if(List.length >= Integer.parseInt(D_Spa_Mode))
							Spa_Mode_Name = List[Integer.parseInt(D_Spa_Mode)-1];
					}
					
					//申购信息
					String D_Spa_I_Numb    = Bean.getSpa_I_Numb();
					String D_Spa_I_Cnt     = Bean.getSpa_I_Cnt();
					String D_Spa_I_Price   = Bean.getSpa_I_Price();
					String D_Spa_I_Amt     = Bean.getSpa_I_Amt();
					String D_Spa_I_Memo    = Bean.getSpa_I_Memo(); 
					String D_Operator_Name = Bean.getOperator_Name();
					
					//审核信息
					String D_Status_OP_Name = Bean.getStatus_OP_Name();
					String D_Status_Memo    = Bean.getStatus_Memo();
					if(null == D_Status_OP_Name){D_Status_OP_Name = "";}
					if(null == D_Status_Memo){D_Status_Memo = "";}
					
					String str_Status = "";
					switch(Integer.parseInt(Bean.getStatus()))
					{
						case 0:
							str_Status = "未审核";
							break;
						case 1:
							str_Status = "审核有效";
							break;
						case 2:
							str_Status = "审核无效";
							break;
					}
					
					//入库信息
					String D_IN_Numb   = Bean.getIN_Numb();
					String D_IN_Cnt    = Bean.getIN_Cnt();
					String D_IN_Date   = Bean.getIN_Date();
					String D_IN_Oper   = Bean.getIN_Oper();
					String D_IN_Oper_N = "";
					if(null == D_IN_Numb){D_IN_Numb = "";}
					if(null == D_IN_Cnt){D_IN_Cnt = "";}
					if(null == D_IN_Date){D_IN_Date = "";}
					if(null == D_IN_Oper){D_IN_Oper = "";}
					if(D_IN_Oper.length() > 0 && User_User_Info != null)
					{
						for(int a=0; a<User_User_Info.size(); a++)
						{
							UserInfoBean Info = (UserInfoBean)User_User_Info.get(a);
							if(Info.getId().equals(D_IN_Oper))
							{
								D_IN_Oper_N = Info.getCName();
								break;
							}
						}
					}
					
					String str_IN_Status = "";
					switch(Integer.parseInt(Bean.getIN_Status()))
					{
						case 0:
							str_IN_Status = "待入库";
							break;
						case 1:
							str_IN_Status = "已入库";
							break;
					}
					
					sheet.setRowView(i, 400);
					sheet.setColumnView(i, 20);
					label = new Label(0,i,(i-1)+"", wff3);
		            sheet.addCell(label);
		            label = new Label(1,i,D_Spa_Type_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(2,i,Spa_Mode_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(3,i,D_Spa_I_Time, wff3);
		            sheet.addCell(label);
		            label = new Label(4,i,D_Spa_I_Numb, wff3);
		            sheet.addCell(label);
		            label = new Label(5,i,D_Spa_I_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(6,i,D_Spa_I_Price, wff3);
		            sheet.addCell(label);
		            label = new Label(7,i,D_Spa_I_Amt, wff3);
		            sheet.addCell(label);
		            label = new Label(8,i,D_Spa_I_Memo, wff3);
		            sheet.addCell(label);
		            label = new Label(9,i,D_Operator_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(10,i,str_Status, wff3);
		            sheet.addCell(label);
		            label = new Label(11,i,D_Status_OP_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(12,i,D_Status_Memo, wff3);
		            sheet.addCell(label);
		            label = new Label(13,i,str_IN_Status, wff3);
		            sheet.addCell(label);
		            label = new Label(14,i,D_IN_Numb, wff3);
		            sheet.addCell(label);
		            label = new Label(15,i,D_IN_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(16,i,D_IN_Date, wff3);
		            sheet.addCell(label);
		            label = new Label(17,i,D_IN_Oper_N, wff3);
		            sheet.addCell(label);**/
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
	//入库批量导入
	
	public void DaoSpaINFile(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone, ServletConfig pConfig) 
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
				    	Spa_Type     =  rs.getCell(1, i).getContents().trim();	//备件名称				    	
				    	Spa_Mode     =  rs.getCell(2, i).getContents().trim();	//规格型号	 
				    	Spa_Unit     =  rs.getCell(3, i).getContents().trim();    //单位
				    	Spa_Num      =  rs.getCell(4, i).getContents().trim();     //数量
				    	Spa_Price    =  rs.getCell(5, i).getContents().trim();   //单价
				    	Spa_Amt      =  rs.getCell(6, i).getContents().trim();		//	金额	    
				    	Spa_I_Oper   =  rs.getCell(7, i).getContents().trim();		//	采办人    
				    	Operator     =  rs.getCell(8, i).getContents().trim();		//	验收人  
				    	CTime        =  rs.getCell(9, i).getContents().trim();		//时间
				    	Spa_Memo     =  rs.getCell(10, i).getContents().trim();	//  备注	
				    	msgBean = pRmi.RmiExec(10, this, 0);
				    	if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
						{
				    		succCnt ++;
						}
				    }	
				    currStatus.setResult("成功导入[" + String.valueOf(succCnt) + "/" + String.valueOf(rsRows-1) + "]个");
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
			if(null == Func_Type_Id)
			{
				Func_Type_Id = "";
			}
			
			msgBean = pRmi.RmiExec(0, this, 0);			
			request.getSession().setAttribute("Spa_Store_IN_" + Sid, ((Object)msgBean.getMsg()));
	    	currStatus.setTotalRecord(msgBean.getCount());
	    	currStatus.setJsp("Spa_Store_IN.jsp?Sid=" + Sid);			
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
				Sql =  " select t.sn, t.spa_type, t.spa_mode, t.spa_unit, t.spa_num, t.spa_price, t.spa_amt, t.ctime, t.spa_memo, t.spa_i_oper, t.operator" +
					   " from spa_store_i t " +
					   " where t.spa_type like '"+ Func_Corp_Id +"%' " +
					   " and t.spa_mode like '%"+ Func_Type_Id +"%'" +
					   " and t.ctime >= date_format('"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"', '%Y-%m-%d')" +
					   " and t.ctime <= date_format('"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"', '%Y-%m-%d')" +
					   " order by t.ctime desc ";					
			
				break;
			case 1://入库查询
						Sql = " select t.sn, t.spa_type, t.spa_mode, t.spa_unit, t.spa_num, t.spa_price, t.spa_amt, t.ctime, t.spa_memo, t.spa_i_oper, t.operator" +
						      " from spa_store_i t " +
						  	  " where t.spa_type like '"+ Func_Corp_Id +"%' " +
						  	  " and t.spa_mode like '%"+ Func_Type_Id +"%'" +
						  	  " and t.ctime >= date_format('"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"', '%Y-%m-%d')" +
						  	  " and t.ctime <= date_format('"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"', '%Y-%m-%d')" +
						  	  " order by t.ctime desc ";
				break;
				
			case 2://查询所有备品
				Sql = " select t.sn, t.spa_type, t.spa_mode, t.spa_unit, t.spa_num, t.spa_price, t.spa_amt, t.ctime, t.spa_memo, t.spa_i_oper, t.operator" +
					  " from spa_store_i t " +
					  " group by t.spa_type ";					 
				break;
			case 3://根据备品查询型号
				Sql = " select t.sn, t.spa_type, t.spa_mode, t.spa_unit,t.spa_num,t.spa_price,t.spa_amt,t.ctime,t.spa_memo, t.spa_i_oper, t.operator" +
					  " from spa_store_i t " +
					  " where t.spa_type like '"+ Func_Corp_Id +"%' " +
					  " group by t.spa_mode ";	
				break;
			case 10://添加
				Sql = " insert into spa_store_i(spa_type, spa_mode,spa_unit,spa_num,spa_price,spa_amt,ctime,spa_memo, spa_i_oper, operator)" +
					  " values('"+ Spa_Type +"', '"+ Spa_Mode +"', '"+ Spa_Unit +"', '"+ Spa_Num +"', '"+ Spa_Price +"', '"+ Spa_Amt +"',  '"+ CTime +"', '"+ Spa_Memo +"', '"+ Spa_I_Oper +"', '"+ Operator +"' )";
				break;
			/**case 11://修改
				Sql = " update spa_store_i t set t.spa_type = '"+ Spa_Type +"', t.spa_mode = '"+ Spa_Mode +"',  t.spa_i_time = '"+ Spa_I_Time +"', t.spa_i_numb = '"+ Spa_I_Numb +"', " +
					  " t.spa_i_cnt = '"+ Spa_I_Cnt +"', t.spa_i_price = '"+ Spa_I_Price +"', t.spa_i_amt = '"+ Spa_I_Amt +"', t.spa_i_memo = '"+ Spa_I_Memo +"', t.operator = '"+ Operator +"' " +
					  " where t.sn = '"+ SN +"'";
				break;
			case 12://审核
				Sql = " update spa_store_i t set t.status = '"+ Status +"', t.status_op = '"+ Status_OP +"', t.status_memo = '"+ Status_Memo +"' " +
					  " where t.sn = '"+ SN +"'";
				break;
			case 13://一键审核
				Sql = " update spa_store_i t set t.status = '"+ Status +"', t.status_op = '"+ Status_OP +"', t.status_memo = '"+ Status_Memo +"' " +
				      " where t.spa_i_numb = '"+ Spa_I_Numb +"' " +
				      "   and t.status = '0' ";
				break;
			case 14://入库
				Sql = " update spa_store_i t set t.in_status = '"+ IN_Status +"', t.in_numb = '"+ IN_Numb +"', t.in_cnt = '"+ IN_Cnt +"', t.in_date = '"+ IN_Date +"', t.in_oper = '"+ IN_Oper +"' " +
				  	  " where t.sn = '"+ SN +"'";
				break;**/
		}
		return Sql;
	}
	
	public boolean getData(ResultSet pRs)
	{
		boolean IsOK = true;
		try
		{			
			setSN(pRs.getString(1));
			setSpa_Type(pRs.getString(2));			
			setSpa_Mode(pRs.getString(3));
			setSpa_Unit(pRs.getString(4));
			setSpa_Num(pRs.getString(5));
			setSpa_Price(pRs.getString(6));
			setSpa_Amt(pRs.getString(7));
			setCTime(pRs.getString(8));		
			setSpa_Memo(pRs.getString(9));
			setSpa_I_Oper(pRs.getString(10));
			setOperator(pRs.getString(11));
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
			setSpa_Type(CommUtil.StrToGB2312(request.getParameter("Spa_Type")));			
			setSpa_Mode(CommUtil.StrToGB2312(request.getParameter("Spa_Mode")));	
			setSpa_Unit(CommUtil.StrToGB2312(request.getParameter("Spa_Unit")));
			setSpa_Num(CommUtil.StrToGB2312(request.getParameter("Spa_Num")));
			setSpa_Price(CommUtil.StrToGB2312(request.getParameter("Spa_Price")));
			setSpa_Amt(CommUtil.StrToGB2312(request.getParameter("Spa_Amt")));	
			setSpa_I_Oper(CommUtil.StrToGB2312(request.getParameter("Spa_I_Oper")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));	
			setSpa_Memo(CommUtil.StrToGB2312(request.getParameter("Spa_Memo")));	
			
			
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String SN;
	private String Spa_Type;	//名称
	private String Spa_Mode;//型号
	private String Spa_Unit;//单位
	private String Spa_Num;//数量
	private String Spa_Price;//价格
	private String Spa_Amt;//金额
	private String CTime;//时间
	private String Spa_Memo;//备注
	private String Spa_I_Oper;//采办人
	private String Operator;//验收人		
	private String Sid;
	private String Func_Corp_Id;
	private String Func_Sub_Id;
	private String Func_Sel_Id;
	private String Func_Type_Id;
	
	
	public String getSpa_I_Oper() {
		return Spa_I_Oper;
	}

	public void setSpa_I_Oper(String spa_I_Oper) {
		Spa_I_Oper = spa_I_Oper;
	}

	public String getOperator() {
		return Operator;
	}

	public void setOperator(String operator) {
		Operator = operator;
	}

	public String getSpa_Unit() {
		return Spa_Unit;
	}

	public void setSpa_Unit(String spa_Unit) {
		Spa_Unit = spa_Unit;
	}

	public String getSpa_Num() {
		return Spa_Num;
	}

	public void setSpa_Num(String spa_Num) {
		Spa_Num = spa_Num;
	}

	public String getSpa_Price() {
		return Spa_Price;
	}

	public void setSpa_Price(String spa_Price) {
		Spa_Price = spa_Price;
	}

	public String getSpa_Amt() {
		return Spa_Amt;
	}

	public void setSpa_Amt(String spa_Amt) {
		Spa_Amt = spa_Amt;
	}

	public String getSpa_Memo() {
		return Spa_Memo;
	}

	public void setSpa_Memo(String spa_Memo) {
		Spa_Memo = spa_Memo;
	}

	public String getSN() {
		return SN;
	}

	public void setSN(String sN) {
		SN = sN;
	}

	public String getSpa_Type() {
		return Spa_Type;
	}

	public void setSpa_Type(String spaType) {
		Spa_Type = spaType;
	}

	

	public String getSpa_Mode() {
		return Spa_Mode;
	}

	public void setSpa_Mode(String spaMode) {
		Spa_Mode = spaMode;
	}

	public String getCTime() {
		return CTime;
	}

	public void setCTime(String cTime) {
		CTime = cTime;
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

	public String getFunc_Sel_Id() {
		return Func_Sel_Id;
	}

	public void setFunc_Sel_Id(String funcSelId) {
		Func_Sel_Id = funcSelId;
	}

	public String getFunc_Type_Id() {
		return Func_Type_Id;
	}

	public void setFunc_Type_Id(String funcTypeId) {
		Func_Type_Id = funcTypeId;
	}
}