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

public class SpaStoreBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_SPA_STORE;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public SpaStoreBean()
	{
		super.className = "SpaStoreBean";
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
		
		Func_Type_Id = currStatus.getFunc_Type_Id();
		if(null == Func_Type_Id || Func_Type_Id.equals("888") )
		{
			Func_Type_Id = "";
		}
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
		switch(currStatus.getCmd())
		{
			
			
			case 10://添加
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(0, this, 0);
			case 0://查询
		    	request.getSession().setAttribute("Spa_Store_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Spa_Store.jsp?Sid=" + Sid);
		    	msgBean = pRmi.RmiExec(3, this, 0);
		    	request.getSession().setAttribute("Spa_Store_Type_" + Sid, ((Object)msgBean.getMsg()));
		    	msgBean = pRmi.RmiExec(4, this, 0);
		    	request.getSession().setAttribute("Spa_Store_Mode_" + Sid, ((Object)msgBean.getMsg()));
		    			    	
		    	//在出库查询站点备用
		    	SpaStoreOBean oBean = new SpaStoreOBean();
		    	msgBean = pRmi.RmiExec(1, oBean, 0);
		    	request.getSession().setAttribute("Spa_Store_Cpm_" + Sid, ((Object)msgBean.getMsg()));
		    	
		    	//在出库查询站点名称
		    	msgBean = pRmi.RmiExec(4, oBean, 0);
		    	request.getSession().setAttribute("Spa_Store_All_" + Sid, ((Object)msgBean.getMsg()));
		    	break;
			case 1://调整查询
				request.getSession().setAttribute("Spa_Store_Log_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Spa_Store_Log.jsp?Sid=" + Sid);
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
			Func_Type_Id = currStatus.getFunc_Type_Id();
			if(null == Func_Type_Id || Func_Type_Id.equals("888")  )
			{
				Func_Type_Id = "";
			}
			//清除历史		
			
			//生成当前
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
			String ET = currStatus.getVecDate().get(0).toString().substring(5,10);
			String SheetName = "_" + BT + "," + ET;
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
			
			//库存台帐
			msgBean = pRmi.RmiExec(0, this, 0);
			ArrayList<?> temp0 = (ArrayList<?>)msgBean.getMsg();//数据			
			//出库数据
			SpaStoreOBean oBean = new SpaStoreOBean();			
	    	msgBean = pRmi.RmiExec(1, oBean, 0);
			ArrayList<?> temp1 = (ArrayList<?>)msgBean.getMsg();//去向站点
			msgBean = pRmi.RmiExec(4, oBean, 0);
			//ArrayList<?> temp4 = (ArrayList<?>)msgBean.getMsg();//出库信息
			if(null != temp0)
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
				
				//字体格式4
				WritableFont wf4 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff4 = new WritableCellFormat(wf4);
				wf4.setColour(Colour.BLACK);//字体颜色
				wff4.setAlignment(Alignment.CENTRE);//设置居中
				wff4.setBorder(Border.ALL, BorderLineStyle.THIN);//设置边框线
				wff4.setBackground(jxl.format.Colour.RED);//设置单元格的背景颜色
				
				ArrayList<?> User_Manage_Role = (ArrayList<?>)request.getSession().getAttribute("User_Manage_Role_" + Sid);
				UserInfoBean UserInfo         = (UserInfoBean)request.getSession().getAttribute("UserInfo_" + Sid);
				String ManageId  = UserInfo.getManage_Role();
				String D_Spa_Chg = "";
				int Chg_cnt      = 0;
				String Role_List = "";
				if(ManageId.length() > 0 && null != User_Manage_Role)
				{
					Iterator<?> iterator = User_Manage_Role.iterator();
					while(iterator.hasNext())
					{
						UserRoleBean statBean = (UserRoleBean)iterator.next();
						if(statBean.getId().substring(0,4).equals(ManageId) && statBean.getId().length() == 8)
						{
							String R_Point = statBean.getPoint();
							if(null == R_Point){R_Point = "";}
							Role_List += R_Point;
						}
					}
				}
		
				
				int D_Index = -1;
				Label label = null;
				
				D_Index++;
	            sheet.setRowView(D_Index, 600);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "备品备件库存台帐", wff);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(4, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(6, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "");
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,D_Index,8,D_Index);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "序号", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "备件名称", wff2);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "规格型号", wff2);
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "单位", wff2);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, "维修队实时库存", wff2);
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(6, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "", wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(4,D_Index,7,D_Index);
	            label = new Label(8, D_Index, "各站分配情况", wff2);
	            sheet.addCell(label);
	            
	            D_Index++;
	            sheet.setRowView(D_Index, 400);
	            sheet.setColumnView(D_Index, 20);
	            label = new Label(0, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(1, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(2, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(3, D_Index, "", wff2);
	            sheet.addCell(label);
	            label = new Label(4, D_Index, "在库", wff2);
	            sheet.addCell(label);
	            label = new Label(5, D_Index, "出库", wff2);
	            sheet.addCell(label);
	            label = new Label(6, D_Index, "报废", wff2);
	            sheet.addCell(label);
	            label = new Label(7, D_Index, "保底存量", wff2);
	            sheet.addCell(label);
	            label = new Label(8, D_Index, "", wff2);
	            sheet.addCell(label);
			    sheet.mergeCells(0,D_Index-1,0,D_Index);
			    sheet.mergeCells(1,D_Index-1,1,D_Index);
			    sheet.mergeCells(2,D_Index-1,2,D_Index);
			    sheet.mergeCells(3,D_Index-1,3,D_Index);
			    sheet.mergeCells(8,D_Index-1,8,D_Index);
			    
				Iterator<?> iterator = temp0.iterator();
				while(iterator.hasNext())
				{
					SpaStoreBean Bean = (SpaStoreBean)iterator.next();
					String D_Spa_Type = Bean.getSpa_Type();
					String D_Spa_Type_Name = Bean.getSpa_Type_Name();
					String D_Spa_Mode = Bean.getSpa_Mode();
					String D_Model = Bean.getModel();
					String D_Unit = Bean.getUnit();
					String D_Spa_I_Cnt = Bean.getSpa_I_Cnt();
					String D_Spa_O_Cnt = Bean.getSpa_O_Cnt();
					String D_Spa_S_Cnt = Bean.getSpa_S_Cnt();
					String D_Spa_R_Cnt = Bean.getSpa_R_Cnt();					
					String D_Spa_Mode_Name = "/";
					if(null != D_Model && D_Model.length() > 0)
					{
						String[] List = D_Model.split(",");
						if(List.length >= Integer.parseInt(D_Spa_Mode))
							D_Spa_Mode_Name = List[Integer.parseInt(D_Spa_Mode)-1];
					}
					
					String stat_Des = "";
					if(null != temp1)
					{
						Iterator<?> statiter = temp1.iterator();
						while(statiter.hasNext())
						{
							SpaStationBean stationBean = (SpaStationBean)statiter.next();
							if(Role_List.contains(stationBean.getCpm_Id()) && stationBean.getSpa_Type().equals(D_Spa_Type) && stationBean.getSpa_Mode().equals(D_Spa_Mode))
							{
								stat_Des += stationBean.getCpm_Name()
								         + "    "
									     + "备用: " + stationBean.getSpa_I_Cnt()
								 		 + "    "
								 		 + "在用: " + stationBean.getSpa_O_Cnt()
								 		 + "    "
								 		 + "报废: " + stationBean.getSpa_S_Cnt()
								 		+ "\012";
							}
						}
					}
					
					if(2 == D_Index)
					{
						D_Spa_Chg = D_Spa_Type;
					}
					
					if(!D_Spa_Chg.equals(D_Spa_Type))
					{
						//纵向合并
						sheet.mergeCells(1,(D_Index-Chg_cnt+1),1,D_Index);
						sheet.mergeCells(3,(D_Index-Chg_cnt+1),3,D_Index);
						
						Chg_cnt = 1;
						D_Spa_Chg = D_Spa_Type;
					}
					else
					{
						Chg_cnt++;
					}
					
					D_Index++;
		            sheet.setRowView(D_Index, 400);
		            sheet.setColumnView(D_Index, 20);
		            label = new Label(0, D_Index, (D_Index-2)+"", wff3);
		            sheet.addCell(label);
		            label = new Label(1, D_Index, D_Spa_Type_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(2, D_Index, D_Spa_Mode_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(3, D_Index, D_Unit, wff3);
		            sheet.addCell(label);            
		            label = new Label(4, D_Index, D_Spa_I_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(5, D_Index, D_Spa_O_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(6, D_Index, D_Spa_S_Cnt, wff3);
		            sheet.addCell(label);
		            label = new Label(7, D_Index, D_Spa_R_Cnt, (Integer.parseInt(D_Spa_I_Cnt)-Integer.parseInt(D_Spa_R_Cnt))<0?wff4:wff3);
		            sheet.addCell(label);
		            label = new Label(8, D_Index, stat_Des, wff3);
		            sheet.addCell(label);
				}
				
				//纵向合并
				sheet.mergeCells(1,(D_Index-Chg_cnt+1),1,D_Index);
				sheet.mergeCells(3,(D_Index-Chg_cnt+1),3,D_Index);
				
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
	
	//批量导入
	public void DaoSpaFile(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone, ServletConfig pConfig) 
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
				    for(int i=4; i<rsRows; i++)
				    {
				    	if(null==rs.getCell(1, i).getContents().trim()||"".equals(rs.getCell(1, i).getContents().trim()))
				    	{
				    
				    		break;//当excel文档第一行为空时，退出循环
				    		}
				    	Spa_Type    = rs.getCell(1, i).getContents().trim();	//备件名称				    	
				    	Spa_Mode    = rs.getCell(2, i).getContents().trim();	//规格型号	    				  
				    	Unit        = rs.getCell(3, i).getContents().trim();	//单位
				    	if(null==rs.getCell(4, i).getContents().trim()||"".equals(rs.getCell(4, i).getContents().trim()))
				    	{Spa_I_Cnt ="0";}else{Spa_I_Cnt   = rs.getCell(4, i).getContents().trim();}   //结存	数量				    
				    	if(null==rs.getCell(5, i).getContents().trim()||"".equals(rs.getCell(5, i).getContents().trim()))
				    	{Spa_R_Cnt = "0";}else{Spa_R_Cnt   = rs.getCell(5, i).getContents().trim();} //保底存量				    					    				    					    	
				    	Operator    = "系统";                               //操作人员
				    	msgBean = pRmi.RmiExec(10, this, 0);
				    	if(msgBean.getStatus() == MsgBean.STA_SUCCESS)
						{
				    		succCnt ++;
						}
				    }	
				    currStatus.setResult("成功导入[" + String.valueOf(succCnt) + "/" + String.valueOf(rsRows-5) + "]个");
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
			msgBean = pRmi.RmiExec(0, this, 0);
			request.getSession().setAttribute("Spa_Store_" + Sid, ((Object)msgBean.getMsg()));
			currStatus.setJsp("Spa_Store.jsp?Sid=" + Sid);
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
				Sql = " select t.spa_type, t.spa_mode, t.spa_i_cnt, t.spa_r_cnt, t.ctime, t.operator, t.Unit " +
					  " from (select a.spa_type, a.spa_mode, a.spa_i_cnt, a.spa_r_cnt, a.ctime, a.operator, a.Unit  from spa_store a  where a.spa_type like '"+ Func_Corp_Id +"%' and a.spa_mode like '"+ Func_Type_Id +"%'order by a.ctime desc) as t" +					  
					  " GROUP BY t.spa_type,t.spa_mode";
				break;
			case 1://调整查询
				Sql = "select t.spa_type, t.spa_mode, t.spa_i_cnt, t.spa_r_cnt, t.ctime, t.operator, t.Unit " +
				  	  " from spa_store_log t " +
				  	  " where t.spa_type like '"+ Func_Corp_Id +"%' " +
				  	  "   and t.ctype like '"+ Func_Sub_Id +"%' " +
				  	  "   order by t.ctime desc ";
				break;			
			case 2://全部查询-检定维修
				Sql = " select t.spa_type, t.spa_type_name, t.spa_mode, t.spa_i_cnt, t.spa_o_cnt, t.spa_s_cnt, t.spa_r_cnt, t.ctype, t.model, t.unit, t.brand, t.seller, t.ctime, t.operator, t.operator_name, '' as memo " +
				  	  " from view_spa_store t " +
				  	  " order by t.spa_type, t.spa_mode asc ";
				break;
			case 3: // 查询所有备品
				Sql = " select t.spa_type, t.spa_mode, t.spa_i_cnt, t.spa_r_cnt, t.ctime, t.operator, t.Unit " +
					  " from (select a.spa_type, a.spa_mode, a.spa_i_cnt, a.spa_r_cnt, a.ctime, a.operator, a.Unit  from spa_store a  where a.spa_type like '"+""+"%' order by a.ctime desc) as t" +					  
					  " GROUP BY t.spa_type,t.spa_mode";
				break;
			case 4:
				Sql = " select t.spa_type, t.spa_mode, t.spa_i_cnt, t.spa_r_cnt, t.ctime, t.operator, t.Unit " +
					  "from spa_store t" +
					  " where t.spa_type like '"+ Func_Corp_Id +"%' " +
					  "group by t.spa_mode";
				break;
			case 5://统计表查询
				Sql = " select t.spa_type, t.spa_mode, t.spa_i_cnt, t.spa_r_cnt, t.ctime, t.operator, t.Unit " +
					  " from (select a.spa_type, a.spa_mode, a.spa_i_cnt, a.spa_r_cnt, a.ctime, a.operator, a.Unit  " +
					  " from spa_store a  " +
					  " where a.spa_type like '"+ Func_Corp_Id +"%' " +
					  " and a.spa_mode like '"+ Func_Type_Id +"%' " +
					  " and a.ctime >= '"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"' " +
					  " and a.ctime <= '"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"' " +
					  " order by a.ctime desc) as t" +					  
					  " GROUP BY t.spa_type,t.spa_mode";
				break;
			case 10://添加
				Sql = " insert into spa_store(spa_type, spa_mode,spa_i_cnt, spa_r_cnt, ctime, operator,Unit)values('"+ Spa_Type +"', '"+ Spa_Mode +"', '"+ Spa_I_Cnt +"',  '"+ Spa_R_Cnt +"', DATE_FORMAT(now(), '%Y-%m-%d %H:%i:%S'), '"+ Operator +"','"+ Unit +"')";
				break;	
			case 20://报废
				Sql = " {? = call Func_Spare(1, '"+ Spa_Type +"', '"+ Spa_Mode +"', '"+ Spa_S_Cnt +"')}";
				break;
		}
		return Sql;
	}
	
	public boolean getData(ResultSet pRs)
	{
		boolean IsOK = true;
		try
		{
			setSpa_Type(pRs.getString(1));			
			setSpa_Mode(pRs.getString(2));
			setSpa_I_Cnt(pRs.getString(3));			
			setSpa_R_Cnt(pRs.getString(4));
			setCTime(pRs.getString(5));
			setOperator(pRs.getString(6));
			setUnit(pRs.getString(7));
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
			setSpa_Type(CommUtil.StrToGB2312(request.getParameter("Spa_Type")));
			setSpa_Mode(CommUtil.StrToGB2312(request.getParameter("Spa_Mode")));
			setSpa_I_Cnt(CommUtil.StrToGB2312(request.getParameter("Spa_I_Cnt")));
			setSpa_R_Cnt(CommUtil.StrToGB2312(request.getParameter("Spa_R_Cnt")));
			setUnit(CommUtil.StrToGB2312(request.getParameter("Unit")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String Spa_Type;
	private String Spa_Type_Name;
	private String Spa_Mode;
	private String Spa_I_Cnt;
	private String Spa_O_Cnt;
	private String Spa_S_Cnt;
	private String Spa_R_Cnt;
	private String CType;
	private String Model;
	private String Unit;
	private String Brand;
	private String Seller;
	private String CTime;
	private String Operator;
	private String Memo;
	
	private String Sid;
	private String Func_Corp_Id;
	private String Func_Sub_Id;
	private String Func_Type_Id;
	public String getFunc_Type_Id() {
		return Func_Type_Id;
	}

	public void setFunc_Type_Id(String func_Type_Id) {
		Func_Type_Id = func_Type_Id;
	}

	public String getSpa_Type() {
		return Spa_Type;
	}

	public void setSpa_Type(String spaType) {
		Spa_Type = spaType;
	}

	public String getSpa_Type_Name() {
		return Spa_Type_Name;
	}

	public void setSpa_Type_Name(String spaTypeName) {
		Spa_Type_Name = spaTypeName;
	}

	public String getSpa_Mode() {
		return Spa_Mode;
	}

	public void setSpa_Mode(String spaMode) {
		Spa_Mode = spaMode;
	}

	public String getSpa_I_Cnt() {
		return Spa_I_Cnt;
	}

	public void setSpa_I_Cnt(String spaICnt) {
		Spa_I_Cnt = spaICnt;
	}

	public String getSpa_O_Cnt() {
		return Spa_O_Cnt;
	}

	public void setSpa_O_Cnt(String spaOCnt) {
		Spa_O_Cnt = spaOCnt;
	}

	public String getSpa_S_Cnt() {
		return Spa_S_Cnt;
	}

	public void setSpa_S_Cnt(String spaSCnt) {
		Spa_S_Cnt = spaSCnt;
	}

	public String getSpa_R_Cnt() {
		return Spa_R_Cnt;
	}

	public void setSpa_R_Cnt(String spaRCnt) {
		Spa_R_Cnt = spaRCnt;
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



	public String getSid() {
		return Sid;
	}

	public void setSid(String sid) {
		Sid = sid;
	}

	public String getFunc_Corp_Id() {
		return Func_Corp_Id;
	}

	public String getMemo() {
		return Memo;
	}

	public void setMemo(String memo) {
		Memo = memo;
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