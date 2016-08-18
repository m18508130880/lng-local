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
import com.jspsmart.upload.SmartUpload;
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

public class FixTraceBean extends RmiBean 
{
	public final static long serialVersionUID = RmiBean.RMI_FIX_TRACE;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public FixTraceBean()
	{
		super.className = "FixTraceBean";
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
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
		switch(currStatus.getCmd())
		{
			case 14://验收信息修改
			case 13://进度信息修改
			case 11://申请信息修改
			case 10://申请信息添加
				currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
				msgBean = pRmi.RmiExec(0, this, currStatus.getCurrPage());
			case 0://查询
		    	request.getSession().setAttribute("Fix_Trace_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Fix_Trace.jsp?Sid=" + Sid);
		    	
		    	//设备品种
		    	AqscDeviceBreedBean DeviceBreed = new AqscDeviceBreedBean();
		    	msgBean = pRmi.RmiExec(0, DeviceBreed, 0);
				request.getSession().setAttribute("Dev_List_Breed_" + Sid, (Object)msgBean.getMsg());
				
		    	//设备信息
		    	DevListBean DevList = new DevListBean();
		    	msgBean = pRmi.RmiExec(1, DevList, 0);
				request.getSession().setAttribute("Dev_List_" + Sid, (Object)msgBean.getMsg());
				
				//维修队备品备件				
				SpaStoreBean StoreBean = new SpaStoreBean();
				msgBean = pRmi.RmiExec(3, StoreBean, 0);
				request.getSession().setAttribute("Spa_Store_All_" + Sid, (Object)msgBean.getMsg());
				
				//场站备品备件
				SpaStationBean StationBean = new SpaStationBean();
				msgBean = pRmi.RmiExec(2, StationBean, 0);
				request.getSession().setAttribute("Spa_Station_All_" + Sid, (Object)msgBean.getMsg());
				
				break;
			case 1://查询
		    	request.getSession().setAttribute("Fix_Trace_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Fix_Trace.jsp?Sid=" + Sid);
		    	break;
			case 2:				
				request.getSession().setAttribute("Fix_GZ_Trace_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Fix_GZ_Trace.jsp?Sid=" + Sid);
				break;
			case 3:
				request.getSession().setAttribute("Fix_XH_Trace_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setJsp("Fix_XH_Trace.jsp?Sid=" + Sid);
		    	
		    	SpaStoreBean StoBean = new SpaStoreBean();
				msgBean = pRmi.RmiExec(2, StoBean, 0);
				request.getSession().setAttribute("Spa_Store_All_" + Sid, (Object)msgBean.getMsg());
		    	SpaStationBean StatBean = new SpaStationBean();
				msgBean = pRmi.RmiExec(2, StatBean, 0);
				request.getSession().setAttribute("Spa_Station_All_" + Sid, (Object)msgBean.getMsg());
				break;
		}
		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
	   	response.sendRedirect(currStatus.getJsp());
	}
	
	public void ToCmd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
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
		
		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, currStatus.getCurrPage());
		switch(currStatus.getCmd())
		{			
			case 0://查询
		    	request.getSession().setAttribute("Fix_To_Trace_" + Sid, ((Object)msgBean.getMsg()));
		    	currStatus.setTotalRecord(msgBean.getCount());
		    	currStatus.setJsp("Fix_To_Trace.jsp?Sid=" + Sid);
		    	
		    	//设备品种
		    	AqscDeviceBreedBean DeviceBreed = new AqscDeviceBreedBean();
		    	msgBean = pRmi.RmiExec(0, DeviceBreed, 0);
				request.getSession().setAttribute("Dev_List_Breed_" + Sid, (Object)msgBean.getMsg());
				
		    	//设备信息
		    	DevListBean DevList = new DevListBean();
		    	msgBean = pRmi.RmiExec(1, DevList, 0);
				request.getSession().setAttribute("Dev_List_" + Sid, (Object)msgBean.getMsg());
				
				//维修队备品备件
				SpaStoreBean StoreBean = new SpaStoreBean();
				msgBean = pRmi.RmiExec(3, StoreBean, 0);
				request.getSession().setAttribute("Spa_Store_All_" + Sid, (Object)msgBean.getMsg());
				
			/**	//场站备品备件
				SpaStationBean StationBean = new SpaStationBean();
				msgBean = pRmi.RmiExec(2, StationBean, 0);
				request.getSession().setAttribute("Spa_Station_All_" + Sid, (Object)msgBean.getMsg());
				**/
		}
		
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
	   	response.sendRedirect(currStatus.getJsp());
	}
	
	
	//文档上传
	public void FixTraceFile(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone, ServletConfig pConfig) 
	{
		try
		{
			SmartUpload mySmartUpload = new SmartUpload();
			mySmartUpload.initialize(pConfig, request, response);
			mySmartUpload.setAllowedFilesList("doc,docx,xls,xlsx,pdf,DOC,DOCX,XLS,XLSX,PDF,");
			mySmartUpload.upload();
			
			//获取参数
			Sid           = mySmartUpload.getRequest().getParameter("Sid");
			SN            = mySmartUpload.getRequest().getParameter("SN");
			Cpm_Id        = mySmartUpload.getRequest().getParameter("Cpm_Id");
			Fix_OP        = mySmartUpload.getRequest().getParameter("Fix_OP");
			Fix_Plan      = mySmartUpload.getRequest().getParameter("Fix_Plan");
			Fix_Plan_File = mySmartUpload.getRequest().getParameter("Fix_Plan_File");
			Fix_Des       = mySmartUpload.getRequest().getParameter("Fix_Des");
			Fix_Corp      = mySmartUpload.getRequest().getParameter("Fix_Corp");
			Fix_BTime     = mySmartUpload.getRequest().getParameter("Fix_BTime");
			Fix_ETime     = mySmartUpload.getRequest().getParameter("Fix_ETime");
			
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.setCmd(CommUtil.StrToInt(mySmartUpload.getRequest().getParameter("Cmd")));
			currStatus.setFunc_Corp_Id(mySmartUpload.getRequest().getParameter("Func_Corp_Id"));
			currStatus.setFunc_Sub_Id(CommUtil.StrToInt(mySmartUpload.getRequest().getParameter("Func_Sub_Id")));
			currStatus.setCurrPage(CommUtil.StrToInt(mySmartUpload.getRequest().getParameter("CurrPage")));
			currStatus.setVecDate(CommUtil.getDate(mySmartUpload.getRequest().getParameter("BTime"), mySmartUpload.getRequest().getParameter("ETime")));
			switch(currStatus.getCmd())
			{
				case 12://确定方案修改
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
								File delfile = new File(FileSaveRoute + Fix_Plan_File);
								if(delfile.isFile() && delfile.exists())
								{
									delfile.delete();
							    }
								
								//上传现有文档
								com.jspsmart.upload.File myFile = mySmartUpload.getFiles().getFile(0);
								Fix_Plan_File = new SimpleDateFormat("yyyyMMdd").format(new Date()) + CommUtil.Randon()+ "." + myFile.getFileExt();
								myFile.saveAs(FileSaveRoute + Fix_Plan_File);
								
								//更新数据库
								msgBean = pRmi.RmiExec(15, this, currStatus.getCurrPage());
								currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
							}
							else
							{
								currStatus.setResult("文档上传失败！文档过大，必须小于3M!");
							}
						}
					}
					break;
			}
			
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
			
			//重新查询
			msgBean = pRmi.RmiExec(0, this, currStatus.getCurrPage());
			request.getSession().setAttribute("Fix_Trace_" + Sid, ((Object)msgBean.getMsg()));
	    	currStatus.setTotalRecord(msgBean.getCount());
	    	currStatus.setJsp("Fix_Trace.jsp?Sid=" + Sid);
	    	
			request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		   	response.sendRedirect(currStatus.getJsp());
		}
		catch(Exception exp)
		{
			exp.printStackTrace();
		}
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
				ArrayList<?> User_User_Info  = (ArrayList<?>)request.getSession().getAttribute("User_User_Info_" + Sid);
				ArrayList<?> Spa_Store_All   = (ArrayList<?>)request.getSession().getAttribute("Spa_Store_All_" + Sid);
				ArrayList<?> Spa_Station_All = (ArrayList<?>)request.getSession().getAttribute("Spa_Station_All_" + Sid);
				
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
	            Label label = new Label(0, 0, "故障跟踪维修记录", wff);
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
	            label = new Label(18, 0, "");
	            sheet.addCell(label);
	            label = new Label(19, 0, "");
	            sheet.addCell(label);
	            label = new Label(20, 0, "");
	            sheet.addCell(label);
	            label = new Label(21, 0, "");
	            sheet.addCell(label);
	            sheet.mergeCells(0,0,21,0);
	            
	            sheet.setRowView(1, 400);
	            sheet.setColumnView(1, 20);
	            label  = new Label(0, 1, "序号", wff2);
	            sheet.addCell(label);
	            label  = new Label(1, 1, "申请场站", wff2);
	            sheet.addCell(label);
	            label  = new Label(2, 1, "申请日期", wff2);
	            sheet.addCell(label);
	            label  = new Label(3, 1, "申请信息", wff2);
	            sheet.addCell(label);
	            label  = new Label(4, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(5, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(6, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(7, 1, "", wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(3,1,7,1);     
	            label  = new Label(8, 1, "维修信息", wff2);
	            sheet.addCell(label);
	            label  = new Label(9, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(10, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(11, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(12, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(13, 1, "", wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(8,1,13,1);
	            label  = new Label(14, 1, "进度信息", wff2);
	            sheet.addCell(label);
	            label  = new Label(15, 1, "", wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(14,1,15,1);
	            label  = new Label(16, 1, "验收信息", wff2);
	            sheet.addCell(label);
	            label  = new Label(17, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(18, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(19, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(20, 1, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(21, 1, "", wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(16,1,21,1);
	            
	            sheet.setRowView(2, 400);
	            sheet.setColumnView(2, 20);
	            label  = new Label(0, 2, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(1, 2, "", wff2);
	            sheet.addCell(label);
	            label  = new Label(2, 2, "", wff2);
	            sheet.addCell(label);
	            sheet.mergeCells(0,1,0,2);
	            sheet.mergeCells(1,1,1,2);
	            sheet.mergeCells(2,1,2,2);
	            label  = new Label(3, 2, "故障设备", wff2);
	            sheet.addCell(label);
	            label  = new Label(4, 2, "问题描述", wff2);
	            sheet.addCell(label);
	            label  = new Label(5, 2, "应急措施", wff2);
	            sheet.addCell(label);
	            label  = new Label(6, 2, "申请人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(7, 2, "录入人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(8, 2, "维修措施", wff2);
	            sheet.addCell(label);
	            label  = new Label(9, 2, "耗品清单", wff2);
	            sheet.addCell(label);
	            label  = new Label(10, 2, "维修单位", wff2);
	            sheet.addCell(label);
	            label  = new Label(11, 2, "开工日期", wff2);
	            sheet.addCell(label);
	            label  = new Label(12, 2, "完工日期", wff2);
	            sheet.addCell(label);
	            label  = new Label(13, 2, "录入人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(14, 2, "进度信息", wff2);
	            sheet.addCell(label);
	            label  = new Label(15, 2, "录入人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(16, 2, "验收单位", wff2);
	            sheet.addCell(label);
	            label  = new Label(17, 2, "验收日期", wff2);
	            sheet.addCell(label);
	            label  = new Label(18, 2, "验收人员", wff2);
	            sheet.addCell(label);
	            label  = new Label(19, 2, "验收意见", wff2);
	            sheet.addCell(label);
	            label  = new Label(20, 2, "状态跟踪", wff2);
	            sheet.addCell(label);
	            label  = new Label(21, 2, "录入人员", wff2);
	            sheet.addCell(label);
	            
	            Iterator<?> iterator = (Iterator<?>)temp.iterator();
				int i = 2;
				while(iterator.hasNext())
				{
					i++;
					FixTraceBean Bean = (FixTraceBean)iterator.next();
					String D_Cpm_Name      = Bean.getCpm_Name();
					String D_Apply_Time    = Bean.getApply_Time();
					
					String D_Dev_Name      = Bean.getDev_Name();
					String D_Apply_Des     = Bean.getApply_Des();
					String D_Apply_Man     = Bean.getApply_Man();
					String D_Apply_Pre     = Bean.getApply_Pre();
					String D_Apply_OP_Name = Bean.getApply_OP_Name();
					
					String D_Fix_Plan      = Bean.getFix_Plan();
					String D_Fix_Corp      = Bean.getFix_Corp();
					String D_Fix_Des       = Bean.getFix_Des();
					String D_Fix_BTime     = Bean.getFix_BTime();
					String D_Fix_ETime     = Bean.getFix_ETime();
					String D_Fix_OP        = Bean.getFix_OP();
					if(null == D_Fix_Plan){D_Fix_Plan = "";}
					if(null == D_Fix_Corp){D_Fix_Corp = "";}
					if(null == D_Fix_Des){D_Fix_Des = "";}
					if(null == D_Fix_BTime){D_Fix_BTime = "";}
					if(null == D_Fix_ETime){D_Fix_ETime = "";}
					if(null == D_Fix_OP){D_Fix_OP = "";}
					String Fix_str = "";
					if(D_Fix_Des.length() > 0)
					{
						String[] List = D_Fix_Des.split(";");
						for(int a=0; a<List.length && List[a].length()>0; a++)
						{
							String[] subList = List[a].split(",");
							String D_Spa_Type = subList[0];
							String D_Spa_Mode = subList[1];
							String D_Spa_From = subList[2];
							String D_Spa_Type_Name = "";
							String D_Spa_Mode_Name = "";
							String D_Spa_From_Name = "";
							if(D_Spa_From.equals("9999999999"))
							{
								if(null != Spa_Store_All)
								{
									Iterator<?> storeiter = Spa_Store_All.iterator();
									while(storeiter.hasNext())
									{
										SpaStoreBean storeBean = (SpaStoreBean)storeiter.next();
										if(storeBean.getSpa_Type().equals(D_Spa_Type) && storeBean.getSpa_Mode().equals(D_Spa_Mode))
										{
											D_Spa_Type_Name = storeBean.getSpa_Type_Name();
											if(null != storeBean.getModel() && storeBean.getModel().length() > 0)
											{
												String[] modeList = storeBean.getModel().split(",");
												if(modeList.length >= Integer.parseInt(D_Spa_Mode))
													D_Spa_Mode_Name = modeList[Integer.parseInt(D_Spa_Mode)-1];
											}
											D_Spa_From_Name = "维修队库存";
										}
									}
								}
							}
							else
							{
								if(null != Spa_Station_All)
								{
									Iterator<?> stationiter = Spa_Station_All.iterator();
									while(stationiter.hasNext())
									{
										SpaStationBean stationBean = (SpaStationBean)stationiter.next();
										if(stationBean.getCpm_Id().equals(D_Spa_From) && stationBean.getSpa_Type().equals(D_Spa_Type) && stationBean.getSpa_Mode().equals(D_Spa_Mode))
										{
											D_Spa_Type_Name = stationBean.getSpa_Type_Name();
											if(null != stationBean.getModel() && stationBean.getModel().length() > 0)
											{
												String[] modeList = stationBean.getModel().split(",");
												if(modeList.length >= Integer.parseInt(D_Spa_Mode))
													D_Spa_Mode_Name = modeList[Integer.parseInt(D_Spa_Mode)-1];
											}
											D_Spa_From_Name = stationBean.getCpm_Name()+"备用";
										}
									}
								}
							}
							
							Fix_str += "\012" + (a+1) + "、[" + D_Spa_Type_Name + "] [" + D_Spa_Mode_Name + "] [" + subList[3] + "] [" + D_Spa_From_Name + "]";
						}
					}
					
					String D_Rate_Des = Bean.getRate_Des();
					String D_Rate_OP  = Bean.getRate_OP();
					if(null == D_Rate_Des){D_Rate_Des = "";}
					if(null == D_Rate_OP){D_Rate_OP = "";}
					String Rate_str = "";
					if(D_Rate_Des.length() > 0)
					{
						String[] List = D_Rate_Des.split("\\~");
						for(int j=0; j<List.length && List[j].length()>0; j++)
						{
							Rate_str += "\012" + (j+1) + "、[" + List[j].split("\\^")[0] + " - " + List[j].split("\\^")[1] + "] [" + List[j].split("\\^")[2] + "]";
						}
					}
					
					String D_Check_Corp = Bean.getCheck_Corp();
					String D_Check_Time = Bean.getCheck_Time();
					String D_Check_Man  = Bean.getCheck_Man();
					String D_Check_Des  = Bean.getCheck_Des();
					String D_Check_OP   = Bean.getCheck_OP();
					String D_Status     = Bean.getStatus();
					String str_Status   = "";
					if(null == D_Check_Corp){D_Check_Corp = "";}
					if(null == D_Check_Time){D_Check_Time = "";}
					if(null == D_Check_Man){D_Check_Man = "";}
					if(null == D_Check_Des){D_Check_Des = "";}
					if(null == D_Check_OP){D_Check_OP = "";}
					switch(Integer.parseInt(D_Status))
					{
						case 0:
							str_Status = "维修中";
							break;
						case 1:
							str_Status = "已关闭";
							break;
					}
					
					//录入人员
					String D_Fix_OP_Name   = "";
					String D_Rate_OP_Name  = "";
					String D_Check_OP_Name = "";
					if(User_User_Info != null)
					{
						for(int k=0; k<User_User_Info.size(); k++)
						{
							UserInfoBean Info = (UserInfoBean)User_User_Info.get(k);
							if(Info.getId().equals(D_Fix_OP))
								D_Fix_OP_Name   = Info.getCName();
							if(Info.getId().equals(D_Rate_OP))
								D_Rate_OP_Name  = Info.getCName();
							if(Info.getId().equals(D_Check_OP))
								D_Check_OP_Name = Info.getCName();
						}
					}
					
					sheet.setRowView(i, 400);
					sheet.setColumnView(i, 20);
					label = new Label(0,i,(i-2)+"", wff3);
		            sheet.addCell(label);
		            label = new Label(1,i,D_Cpm_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(2,i,D_Apply_Time, wff3);
		            sheet.addCell(label);
		            label = new Label(3,i,D_Dev_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(4,i,D_Apply_Des, wff3);
		            sheet.addCell(label);
		            label = new Label(5,i,D_Apply_Pre, wff3);
		            sheet.addCell(label);
		            label = new Label(6,i,D_Apply_Man, wff3);
		            sheet.addCell(label);
		            label = new Label(7,i,D_Apply_OP_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(8,i,D_Fix_Plan, wff3);
		            sheet.addCell(label);
		            label = new Label(9,i,Fix_str, wff3);
		            sheet.addCell(label);
		            label = new Label(10,i,D_Fix_Corp, wff3);
		            sheet.addCell(label);
		            label = new Label(11,i,D_Fix_BTime, wff3);
		            sheet.addCell(label);
		            label = new Label(12,i,D_Fix_ETime, wff3);
		            sheet.addCell(label);
		            label = new Label(13,i,D_Fix_OP_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(14,i,Rate_str, wff3);
		            sheet.addCell(label);
		            label = new Label(15,i,D_Rate_OP_Name, wff3);
		            sheet.addCell(label);
		            label = new Label(16,i,D_Check_Corp, wff3);
		            sheet.addCell(label);
		            label = new Label(17,i,D_Check_Time, wff3);
		            sheet.addCell(label);
		            label = new Label(18,i,D_Check_Man, wff3);
		            sheet.addCell(label);
		            label = new Label(19,i,D_Check_Des, wff3);
		            sheet.addCell(label);
		            label = new Label(20,i,str_Status, wff3);
		            sheet.addCell(label);
		            label = new Label(21,i,D_Check_OP_Name, wff3);
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
	
	public String getSql(int pCmd)
	{
		String Sql = "";
		switch (pCmd)
		{
			case 0://查询
				switch(currStatus.getFunc_Sub_Id())
				{
					case 0:
						Sql = " select t.sn, t.cpm_id, t.cpm_name, t.dev_sn, t.dev_type, t.dev_name, t.apply_time, t.apply_des, t.apply_man, t.apply_pre, t.apply_op, t.apply_op_name, " +
						  	  " t.fix_plan, t.fix_plan_file, t.fix_corp, t.fix_des, t.fix_btime, t.fix_etime, t.fix_op, " +
						  	  " t.rate_des, t.rate_op, " +
						  	  " t.check_corp, t.check_time, t.check_des, t.check_man, t.check_op, t.status " +
						  	  " from view_fix_trace t " +
						  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
						  	  "   and t.dev_type like '"+ Func_Corp_Id +"%'" +
						  	  "   and t.status like '"+ Func_Sub_Id +"%'" +
						  	  "   order by t.apply_time desc ";
						break;
					default:
						Sql = " select t.sn, t.cpm_id, t.cpm_name, t.dev_sn, t.dev_type, t.dev_name, t.apply_time, t.apply_des, t.apply_man, t.apply_pre, t.apply_op, t.apply_op_name, " +
					  	  	  " t.fix_plan, t.fix_plan_file, t.fix_corp, t.fix_des, t.fix_btime, t.fix_etime, t.fix_op, " +
					  	  	  " t.rate_des, t.rate_op, " +
					  	  	  " t.check_corp, t.check_time, t.check_des, t.check_man, t.check_op, t.status " +
						  	  " from view_fix_trace t " +
						  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
						  	  "   and t.dev_type like '"+ Func_Corp_Id +"%'" +
						  	  "   and t.status like '"+ Func_Sub_Id +"%'" +
						  	  "   and t.apply_time >= date_format('"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"', '%Y-%m-%d')" +
						  	  "   and t.apply_time <= date_format('"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"', '%Y-%m-%d')" +
						  	  "   order by t.apply_time desc ";
						break;
				}
				break;
				
			case 1://单个查询
				Sql = " select t.sn, t.cpm_id, t.cpm_name, t.dev_sn, t.dev_type, t.dev_name, t.apply_time, t.apply_des, t.apply_man, t.apply_pre, t.apply_op, t.apply_op_name, " +
					  	  " t.fix_plan, t.fix_plan_file, t.fix_corp, t.fix_des, t.fix_btime, t.fix_etime, t.fix_op, " +
					  	  " t.rate_des, t.rate_op, " +
					  	  " t.check_corp, t.check_time, t.check_des, t.check_man, t.check_op, t.status " +
					  	  " from view_fix_trace t " +
					  	  " where t.sn = '"+ SN +"'";			  						  					
				break;
			case 2 ://设备故障统计详细查询
				
				Sql = " select t.sn, t.cpm_id, t.cpm_name, t.dev_sn, t.dev_type, t.dev_name, t.apply_time, t.apply_des, t.apply_man, t.apply_pre, t.apply_op, t.apply_op_name, " +
				  	  	  " t.fix_plan, t.fix_plan_file, t.fix_corp, t.fix_des, t.fix_btime, t.fix_etime, t.fix_op, " +
				  	  	  " t.rate_des, t.rate_op, " +
				  	  	  " t.check_corp, t.check_time, t.check_des, t.check_man, t.check_op, t.status " +
					  	  " from view_fix_trace t " +
					  	  " where  t.cpm_id= '"+ Cpm_Id+"'" +
					  	  " and t.dev_sn= '"+ Dev_SN +"'" +
					  	  " and t.apply_time >= '"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"'" +
					  	  " and t.apply_time <= '"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"'" +
					  	  " order by t.apply_time desc ";			
				break;		
			case 3:
				Sql = " select t.sn, t.cpm_id, t.cpm_name, t.dev_sn, t.dev_type, t.dev_name, t.apply_time, t.apply_des, t.apply_man, t.apply_pre, t.apply_op, t.apply_op_name, " +
				  	  " t.fix_plan, t.fix_plan_file, t.fix_corp, t.fix_des, t.fix_btime, t.fix_etime, t.fix_op, " +
				  	  " t.rate_des, t.rate_op, " +
				  	  " t.check_corp, t.check_time, t.check_des, t.check_man, t.check_op, t.status " +
					  " from view_fix_trace t " +
					  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +					  	 
					  " and t.apply_time >= '"+currStatus.getVecDate().get(0).toString().substring(0, 10)+"'" +
					  " and t.apply_time <= '"+currStatus.getVecDate().get(1).toString().substring(0, 10)+"'" +
					  " order by t.apply_time, t.dev_type asc ";				
				break;
			case 10://申请信息添加
				Sql = " insert into fix_trace(cpm_id, dev_sn, apply_time, apply_des, apply_man, apply_pre, apply_op)" +
					  " values('"+ Cpm_Id +"', '"+ Dev_SN +"', '"+ Apply_Time +"', '"+ Apply_Des +"', '"+ Apply_Man +"', '"+ Apply_Pre +"', '"+ Apply_OP +"')";
				break;
			case 11://申请信息修改
				Sql = " update fix_trace t set t.cpm_id = '"+ Cpm_Id +"', t.dev_sn = '"+ Dev_SN +"', t.apply_time = '"+ Apply_Time +"', t.apply_des = '"+ Apply_Des +"', t.apply_man = '"+ Apply_Man +"', t.apply_pre = '"+ Apply_Pre +"', t.apply_op = '"+ Apply_OP +"' " +
					  " where t.sn = '"+ SN +"' ";
				break;
			case 12://维修信息修改
				Sql = " update fix_trace t set t.fix_plan = '"+ Fix_Plan +"', t.fix_corp = '"+ Fix_Corp +"', t.fix_des = '"+ Fix_Des +"', t.fix_btime = '"+ Fix_BTime +"', t.fix_etime = '"+ Fix_ETime +"', t.fix_op = '"+ Fix_OP +"' " +
				  	  " where t.sn = '"+ SN +"' ";
				break;
			case 13://进度信息修改
				Sql = " update fix_trace t set t.rate_des = '"+ Rate_Des +"', t.rate_op = '"+ Rate_OP +"' " +
			  	  	  " where t.sn = '"+ SN +"' ";
				break;
			case 14://验收信息修改
				Sql = " update fix_trace t set t.check_corp = '"+ Check_Corp +"', t.check_time = '"+ Check_Time +"', t.check_des = '"+ Check_Des +"', t.check_man = '"+ Check_Man +"', t.check_op = '"+ Check_OP +"', t.status = '"+ Status +"' " +
		  	  	  	  " where t.sn = '"+ SN +"' ";
				break;
			case 15://维修信息文档
				Sql = " update fix_trace t set t.fix_plan_file  = '"+ Fix_Plan_File +"' " +
					  " where t.sn = '"+ SN +"' ";
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
			setDev_SN(pRs.getString(4));
			setDev_Type(pRs.getString(5));
			setDev_Name(pRs.getString(6));
			setApply_Time(pRs.getString(7));
			setApply_Des(pRs.getString(8));
			setApply_Man(pRs.getString(9));
			setApply_Pre(pRs.getString(10));
			setApply_OP(pRs.getString(11));
			setApply_OP_Name(pRs.getString(12));
			setFix_Plan(pRs.getString(13));
			setFix_Plan_File(pRs.getString(14));
			setFix_Corp(pRs.getString(15));
			setFix_Des(pRs.getString(16));
			setFix_BTime(pRs.getString(17));
			setFix_ETime(pRs.getString(18));
			setFix_OP(pRs.getString(19));
			setRate_Des(pRs.getString(20));
			setRate_OP(pRs.getString(21));
			setCheck_Corp(pRs.getString(22));
			setCheck_Time(pRs.getString(23));
			setCheck_Des(pRs.getString(24));
			setCheck_Man(pRs.getString(25));
			setCheck_OP(pRs.getString(26));
			setStatus(pRs.getString(27));
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
			setDev_SN(CommUtil.StrToGB2312(request.getParameter("Dev_SN")));
			setDev_Type(CommUtil.StrToGB2312(request.getParameter("Dev_Type")));
			setDev_Name(CommUtil.StrToGB2312(request.getParameter("Dev_Name")));
			setApply_Time(CommUtil.StrToGB2312(request.getParameter("Apply_Time")));
			setApply_Des(CommUtil.StrToGB2312(request.getParameter("Apply_Des")));
			setApply_Man(CommUtil.StrToGB2312(request.getParameter("Apply_Man")));
			setApply_Pre(CommUtil.StrToGB2312(request.getParameter("Apply_Pre")));
			setApply_OP(CommUtil.StrToGB2312(request.getParameter("Apply_OP")));
			setApply_OP_Name(CommUtil.StrToGB2312(request.getParameter("Apply_OP_Name")));
			setFix_Plan(CommUtil.StrToGB2312(request.getParameter("Fix_Plan")));
			setFix_Plan_File(CommUtil.StrToGB2312(request.getParameter("Fix_Plan_File")));
			setFix_Corp(CommUtil.StrToGB2312(request.getParameter("Fix_Corp")));
			setFix_Des(CommUtil.StrToGB2312(request.getParameter("Fix_Des")));
			setFix_BTime(CommUtil.StrToGB2312(request.getParameter("Fix_BTime")));
			setFix_ETime(CommUtil.StrToGB2312(request.getParameter("Fix_ETime")));
			setFix_OP(CommUtil.StrToGB2312(request.getParameter("Fix_OP")));
			setRate_Des(CommUtil.StrToGB2312(request.getParameter("Rate_Des")));
			setRate_OP(CommUtil.StrToGB2312(request.getParameter("Rate_OP")));
			setCheck_Corp(CommUtil.StrToGB2312(request.getParameter("Check_Corp")));
			setCheck_Time(CommUtil.StrToGB2312(request.getParameter("Check_Time")));
			setCheck_Des(CommUtil.StrToGB2312(request.getParameter("Check_Des")));
			setCheck_Man(CommUtil.StrToGB2312(request.getParameter("Check_Man")));
			setCheck_OP(CommUtil.StrToGB2312(request.getParameter("Check_OP")));
			setStatus(CommUtil.StrToGB2312(request.getParameter("Status")));
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
	private String Dev_SN;
	private String Dev_Type;
	private String Dev_Name;
	private String Apply_Time;
	private String Apply_Des;
	private String Apply_Man;
	private String Apply_Pre;
	private String Apply_OP;
	private String Apply_OP_Name;
	private String Fix_Plan;
	private String Fix_Plan_File;
	private String Fix_Corp;
	private String Fix_Des;
	private String Fix_BTime;
	private String Fix_ETime;
	private String Fix_OP;
	private String Rate_Des;
	private String Rate_OP;
	private String Check_Corp;
	private String Check_Time;
	private String Check_Des;
	private String Check_Man;
	private String Check_OP;
	private String Status;
	
	private String Sid;
	private String Func_Corp_Id;
	private String Func_Sub_Id;
	
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

	public String getDev_SN() {
		return Dev_SN;
	}

	public void setDev_SN(String devSN) {
		Dev_SN = devSN;
	}

	public String getDev_Type() {
		return Dev_Type;
	}

	public void setDev_Type(String devType) {
		Dev_Type = devType;
	}

	public String getDev_Name() {
		return Dev_Name;
	}

	public void setDev_Name(String devName) {
		Dev_Name = devName;
	}

	public String getApply_Time() {
		return Apply_Time;
	}

	public void setApply_Time(String applyTime) {
		Apply_Time = applyTime;
	}

	public String getApply_Des() {
		return Apply_Des;
	}

	public void setApply_Des(String applyDes) {
		Apply_Des = applyDes;
	}

	public String getApply_Man() {
		return Apply_Man;
	}

	public void setApply_Man(String applyMan) {
		Apply_Man = applyMan;
	}

	public String getApply_Pre() {
		return Apply_Pre;
	}

	public void setApply_Pre(String applyPre) {
		Apply_Pre = applyPre;
	}

	public String getApply_OP() {
		return Apply_OP;
	}

	public void setApply_OP(String applyOP) {
		Apply_OP = applyOP;
	}

	public String getApply_OP_Name() {
		return Apply_OP_Name;
	}

	public void setApply_OP_Name(String applyOPName) {
		Apply_OP_Name = applyOPName;
	}

	public String getFix_Plan() {
		return Fix_Plan;
	}

	public void setFix_Plan(String fixPlan) {
		Fix_Plan = fixPlan;
	}

	public String getFix_Plan_File() {
		return Fix_Plan_File;
	}

	public void setFix_Plan_File(String fixPlanFile) {
		Fix_Plan_File = fixPlanFile;
	}

	public String getFix_Corp() {
		return Fix_Corp;
	}

	public void setFix_Corp(String fixCorp) {
		Fix_Corp = fixCorp;
	}

	public String getFix_Des() {
		return Fix_Des;
	}

	public void setFix_Des(String fixDes) {
		Fix_Des = fixDes;
	}

	public String getFix_BTime() {
		return Fix_BTime;
	}

	public void setFix_BTime(String fixBTime) {
		Fix_BTime = fixBTime;
	}

	public String getFix_ETime() {
		return Fix_ETime;
	}

	public void setFix_ETime(String fixETime) {
		Fix_ETime = fixETime;
	}

	public String getFix_OP() {
		return Fix_OP;
	}

	public void setFix_OP(String fixOP) {
		Fix_OP = fixOP;
	}

	public String getRate_Des() {
		return Rate_Des;
	}

	public void setRate_Des(String rateDes) {
		Rate_Des = rateDes;
	}

	public String getRate_OP() {
		return Rate_OP;
	}

	public void setRate_OP(String rateOP) {
		Rate_OP = rateOP;
	}

	public String getCheck_Corp() {
		return Check_Corp;
	}

	public void setCheck_Corp(String checkCorp) {
		Check_Corp = checkCorp;
	}

	public String getCheck_Time() {
		return Check_Time;
	}

	public void setCheck_Time(String checkTime) {
		Check_Time = checkTime;
	}

	public String getCheck_Des() {
		return Check_Des;
	}

	public void setCheck_Des(String checkDes) {
		Check_Des = checkDes;
	}

	public String getCheck_Man() {
		return Check_Man;
	}

	public void setCheck_Man(String checkMan) {
		Check_Man = checkMan;
	}

	public String getCheck_OP() {
		return Check_OP;
	}

	public void setCheck_OP(String checkOP) {
		Check_OP = checkOP;
	}

	public String getStatus() {
		return Status;
	}

	public void setStatus(String status) {
		Status = status;
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