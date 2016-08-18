package bean;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Iterator;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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

public class ProLBean extends RmiBean 
{	
	public final static long serialVersionUID = RmiBean.RMI_PRO_L;
	public long getClassId()
	{
		return serialVersionUID;
	}
	
	public ProLBean()
	{
		super.className = "ProLBean";
	}	
	public void ExecCmd(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) throws ServletException, IOException
	{
		getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);
		
		System.out.println(Year);
	//	msgBean = pRmi.RmiExec(21, this, 0);

		switch(currStatus.getFunc_Sub_Id())
		{
			case 1://�±���
		    	msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
				switch(currStatus.getCmd())
				{
					case 0://�±���
				    	request.getSession().setAttribute("Pro_L_" + Sid, ((Object)msgBean.getMsg()));
				    	currStatus.setJsp("Pro_L.jsp?Sid=" + Sid);
				    	
				    	//���ۼ�
				    	msgBean = pRmi.RmiExec(1, this, 0);
				    	request.getSession().setAttribute("Pro_Y_" + Sid, ((Object)msgBean.getMsg()));
				    	break;
				}
		    	request.getSession().setAttribute("Month_" + Sid, Month);
		    	request.getSession().setAttribute("Year_" + Sid, Year);
		    	break;
		    case 2://�ܱ���
		    	//�жϵ���1�������ڼ������������죬��Ϊ��һ�ܵ�һ�죬�����������
		    	String pBTime = "";
				String pETime = "";
	    		switch(Integer.parseInt(CommUtil.getWeekDayString(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-01")))
	    		{
		    		case 0://������
		    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-01 00:00:00", (Integer.parseInt(Week)-1)*7);
				    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-01 00:00:00", (Integer.parseInt(Week))*7-1);
		    			break;
		    		case 1://����һ
		    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-07 00:00:00", (Integer.parseInt(Week)-1)*7);
				    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-07 00:00:00", (Integer.parseInt(Week))*7-1);
		    			break;
		    		case 2://���ڶ�
		    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-06 00:00:00", (Integer.parseInt(Week)-1)*7);
				    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-06 00:00:00", (Integer.parseInt(Week))*7-1);
		    			break;
		    		case 3://������
		    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-05 00:00:00", (Integer.parseInt(Week)-1)*7);
				    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-05 00:00:00", (Integer.parseInt(Week))*7-1);
		    			break;
		    		case 4://������
		    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-04 00:00:00", (Integer.parseInt(Week)-1)*7);
				    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-04 00:00:00", (Integer.parseInt(Week))*7-1);
		    			break;
		    		case 5://������
		    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-03 00:00:00", (Integer.parseInt(Week)-1)*7);
				    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-03 00:00:00", (Integer.parseInt(Week))*7-1);
		    			break;
		    		case 6://������
		    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-02 00:00:00", (Integer.parseInt(Week)-1)*7);
				    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-02 00:00:00", (Integer.parseInt(Week))*7-1);
		    			break;
	    		}
	    		
	    		//�ж�pBTime�Ƿ��ڱ�����
	    		if(Integer.parseInt(pBTime.substring(5,7)) == Integer.parseInt(Month))
	    		{
	    			pBTime = pBTime.substring(0,10);
	    			pETime = pETime.substring(0,10);
	    			currStatus.setVecDate(CommUtil.getDate(pBTime, pETime));
	    		}
	    		else
	    		{
	    			pBTime = "1970-01-01";
	    			pETime = "1970-01-01";
	    			currStatus.setVecDate(CommUtil.getDate(pBTime, pETime));
	    		}
	    		
		    	msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
				switch(currStatus.getCmd())
				{
					case 3://�ܱ���
				    	request.getSession().setAttribute("Pro_L_W_" + Sid, ((Object)msgBean.getMsg()));
				    	currStatus.setJsp("Pro_L_W.jsp?Sid=" + Sid);
				    	
				    	//���ۼ�
				    	msgBean = pRmi.RmiExec(1, this, 0);
				    	request.getSession().setAttribute("Pro_Y_W_" + Sid, ((Object)msgBean.getMsg()));
				    	
				    	//������
				    	//msgBean = pRmi.RmiExec(2, this, 0);
				    	
				    	ProOBean poBean =new ProOBean();
				    	poBean.setCpm_Id(Cpm_Id);
				    	poBean.currStatus = currStatus;
				    	msgBean = pRmi.RmiExec(5, poBean, 0);
				    	request.getSession().setAttribute("Pro_C_W_" + Sid, ((Object)msgBean.getMsg()));
				    	break;
				}
				request.getSession().setAttribute("Month_" + Sid, Month);
		    	request.getSession().setAttribute("Year_" + Sid, Year);
				request.getSession().setAttribute("Week_" + Sid, Week);
		    	break;
		    	
		    	
		    case 3://�ձ���				    	
				switch(currStatus.getCmd())
				{
					//�޸�ӯ������
					case 11:
						msgBean = pRmi.RmiExec(11, this, 0);
					case 4://�ձ���		
						msgBean = pRmi.RmiExec(4, this, 0);
				    	request.getSession().setAttribute("Pro_L_D_" + Sid, ((Object)msgBean.getMsg()));
				    	currStatus.setJsp("Pro_L_D.jsp?Sid=" + Sid);
				    	
				    	//�ͻ���Ϣ��ѯ
				    	PLCrmBean cBean = new PLCrmBean();
				    	cBean.setCpm_Id(Cpm_Id);
				    	cBean.setFunc_Corp_Id(currStatus.getFunc_Corp_Id());
				    	cBean.setVecDa(currStatus.getVecDate());
				    	msgBean = pRmi.RmiExec(0, cBean, 0);
				    	request.getSession().setAttribute("Pro_L_Crm_" + Sid, ((Object)msgBean.getMsg()));
				    	//��ѯ�ձ�������Ϣ
				    	DateBaoBean baoBean = new DateBaoBean();
				    	baoBean.setCpm_Id(Cpm_Id);
				    	baoBean.currStatus = currStatus;
				    	msgBean = pRmi.RmiExec(0, baoBean, 0);
				    	request.getSession().setAttribute("Pro_L_Bao_" + Sid, ((Object)msgBean.getMsg()));
				    	
				}
		    	break;
		    case 4://վ���걨��
				
				msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
				switch(currStatus.getCmd())
				{
					case 5://�걨��					
						request.getSession().setAttribute("Pro_Y_N_" + Sid, ((Object)msgBean.getMsg()));											
						currStatus.setJsp("Pro_Y.jsp?Sid=" + Sid);			    			    	
						break;
				}	    			
	    		request.getSession().setAttribute("Year_" + Sid, Year);
	    		break;
		}
		
		//����ҵ��
    	ProRBean RBean = new ProRBean();
    	msgBean = pRmi.RmiExec(1, RBean, 0);
    	request.getSession().setAttribute("Pro_R_Buss_" + Sid, ((Object)msgBean.getMsg()));
    	//��ѯ����
    	CorpInfoBean ifBean  = new CorpInfoBean();
    	msgBean = pRmi.RmiExec(0, ifBean, 0);
    	request.getSession().setAttribute("Pro_R_Info_" + Sid, ((Object)msgBean.getMsg()));
    	//��������
    	msgBean = pRmi.RmiExec(2, RBean, 0);
    	request.getSession().setAttribute("Pro_R_Type_" + Sid, ((Object)msgBean.getMsg()));
    	
		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
	   	response.sendRedirect(currStatus.getJsp());
	}
	
	//�±���
	public void ExportToExcel(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone)
	{
		try
		{
			getHtmlData(request);
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.getHtmlData(request, pFromZone);
			
			switch(currStatus.getFunc_Sub_Id())
			{
				case 0://�걨��
					break;
			    case 1://�±���
			    	request.getSession().setAttribute("Month_" + Sid, Month);
			    	request.getSession().setAttribute("Year_" + Sid, Year);
			    	break;
			    case 2://�ܱ���
			    	break;
			    case 3://�ձ���
			    	break;
			    
			}
			
			//�����ʷ
			
			//���ɵ�ǰ
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
			String ET = currStatus.getVecDate().get(1).toString().substring(5,10);
			String SheetName = "�����±���";
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
			
			//��˾����
			CorpInfoBean Corp_Info = (CorpInfoBean)request.getSession().getAttribute("User_Corp_Info_" + Sid);
			String D_Oil_Info = "";
			String D_Oil_Name = "";
			if(null != Corp_Info)
			{	
				D_Oil_Info = Corp_Info.getOil_Info();
				if(null == D_Oil_Info){D_Oil_Info = "";}				
				if(null != currStatus.getFunc_Corp_Id() && D_Oil_Info.length() > 0)
				{
					String[] List = D_Oil_Info.split(";");
					for(int i=0; i<List.length && List[i].length()>0; i++)
					{
					  	String[] subList = List[i].split(",");
					  	if(currStatus.getFunc_Corp_Id().equals(subList[0]))
					  	{
					  		D_Oil_Name = subList[1];
					  		break;
					  	}
			  		}
				}
			}
			
			//�±���
			msgBean = pRmi.RmiExec(0, this, 0);
			ArrayList<?> temp0 = (ArrayList<?>)msgBean.getMsg();
			
			//���ۼ�
			msgBean = pRmi.RmiExec(1, this, 0);
			ArrayList<?> temp1 = (ArrayList<?>)msgBean.getMsg();
			
			//�±���
			String D_T_Cpm_Id       = "";
			String D_T_Cpm_Name     = "";
			String D_CTime          = "";
			String D_Value_O        = "0";
			String D_Value_O_Gas    = "0";
			String D_Value_I        = "0";
			String D_Value_I_Gas    = "0";
			String D_Value_R        = "0";
			String D_Value_R_Gas    = "0";
				
			//�����ۼ�
			double D_Value_O_All     = 0.0;
			double D_Value_O_Gas_All = 0.0;
			double D_Value_I_All     = 0.0;
			double D_Value_I_Gas_All = 0.0;
			
			//�����ۼ�
			String D_Value_O_Y     = "0";
			String D_Value_O_Gas_Y = "0";
			String D_Value_I_Y     = "0";
			String D_Value_I_Gas_Y = "0";
			//String D_Value_R_Y     = "0";
			//String D_Value_R_Gas_Y = "0";
			
			//ͳ������
			int D_cnt              = 0;
			
			//����
			int D_Index            = -1;
			
			if(null != temp0)
			{
				//�����ļ�
				WritableWorkbook book = Workbook.createWorkbook(new File(UPLOAD_PATH + UPLOAD_NAME + ".xls"));
	            WritableSheet sheet = book.createSheet(SheetName, 0);
	            
	            //�����ʽ1
	            WritableFont wf = new WritableFont(WritableFont.createFont("normal"), 18, WritableFont.BOLD , false);
				WritableCellFormat wff = new WritableCellFormat(wf);
				wf.setColour(Colour.BLACK);//������ɫ
				wff.setAlignment(Alignment.CENTRE);//���þ���
				wff.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				wff.setBackground(jxl.format.Colour.TURQUOISE);//���õ�Ԫ��ı�����ɫ			
				
				//�����ʽ2
				WritableFont wf2 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.BOLD , false);
				WritableCellFormat wff2 = new WritableCellFormat(wf2);
				wf2.setColour(Colour.BLACK);//������ɫ
				wff2.setAlignment(Alignment.CENTRE);//���þ���
				wff2.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				
				//�����ʽ3
				WritableFont wf3 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff3 = new WritableCellFormat(wf3);
				wf3.setColour(Colour.BLACK);//������ɫ
				wff3.setAlignment(Alignment.CENTRE);//���þ���
				wff3.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				
				//�����ʽ4
				WritableFont wf4 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff4 = new WritableCellFormat(wf4);
				wf4.setColour(Colour.BLACK);//������ɫ
				wff4.setAlignment(Alignment.LEFT);//���þ���
				wff4.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				wff4.setWrap(true);
				
				Iterator<?> iterator = temp0.iterator();
				while(iterator.hasNext())
				{
					ProLBean Bean = (ProLBean)iterator.next();
					D_cnt++;
					if(!D_T_Cpm_Id.equals(Bean.getCpm_Id()))
					{
						if(D_T_Cpm_Id.length() > 0)
						{
							//�����ۼ�
							if(null != temp1)
							{
								Iterator<?> yeariter = temp1.iterator();
								while(yeariter.hasNext())
								{
									ProLBean yearBean = (ProLBean)yeariter.next();
									if(D_T_Cpm_Id.equals(yearBean.getCpm_Id()))
									{
										D_Value_O_Y = yearBean.getValue_O();
										D_Value_O_Gas_Y = yearBean.getValue_O_Gas();
										D_Value_I_Y = yearBean.getValue_I();
										D_Value_I_Gas_Y = yearBean.getValue_I_Gas();
									}
								}
							}
							
							D_Index++;
							sheet.setRowView(D_Index, 400);
							sheet.setColumnView(D_Index, 12);
							Label label = new Label(0, D_Index, "�����ۼ�", wff2);
				            sheet.addCell(label);
				            label = new Label(1, D_Index, (new BigDecimal(D_Value_O_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
				            sheet.addCell(label);
				            label = new Label(2, D_Index, (new BigDecimal(D_Value_O_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
				            sheet.addCell(label);
				            label = new Label(3, D_Index, (new BigDecimal(D_Value_I_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
				            sheet.addCell(label);
				            label = new Label(4, D_Index, (new BigDecimal(D_Value_I_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
				            sheet.addCell(label);
				            label = new Label(5, D_Index, "", wff2);
				            sheet.addCell(label);
				            label = new Label(6, D_Index, "", wff2);
				            sheet.addCell(label);
				            			            
				            D_Index++;
				            sheet.setRowView(D_Index, 400);
				            sheet.setColumnView(D_Index, 12);
				            label = new Label(0, D_Index, "�����ۼ�", wff2);
				            sheet.addCell(label);
				            label = new Label(1, D_Index, D_Value_O_Y, wff2);
				            sheet.addCell(label);
				            label = new Label(2, D_Index, D_Value_O_Gas_Y, wff2);
				            sheet.addCell(label);
				            label = new Label(3, D_Index, D_Value_I_Y, wff2);
				            sheet.addCell(label);
				            label = new Label(4, D_Index, D_Value_I_Gas_Y, wff2);
				            sheet.addCell(label);
				            label = new Label(5, D_Index, "", wff2);
				            sheet.addCell(label);
				            label = new Label(6, D_Index, "", wff2);
				            sheet.addCell(label);
				            
				            D_Index++;
				            sheet.setRowView(D_Index, 400);
				            sheet.setColumnView(D_Index, 12);
				            label = new Label(0, D_Index, "�Ʊ�: ϵͳ", wff2);
				            sheet.addCell(label);
				            label = new Label(1, D_Index, "", wff4);
				            sheet.addCell(label);
				            sheet.mergeCells(0,D_Index,1,D_Index);
				            label = new Label(2, D_Index, "���: " + Operator_Name, wff2);
				            sheet.addCell(label);
				            label = new Label(3, D_Index, "", wff4);
				            sheet.addCell(label);
				            sheet.mergeCells(2,D_Index,3,D_Index);
				            label = new Label(4, D_Index, "�ϱ�����: " + CommUtil.getDate(), wff2);
				            sheet.addCell(label);
				            label = new Label(5, D_Index, "", wff4);
				            sheet.addCell(label);
				            label = new Label(6, D_Index, "", wff4);
				            sheet.addCell(label);
				            sheet.mergeCells(4,D_Index,6,D_Index);
				            
							D_Value_O_All = 0;
							D_Value_O_Gas_All = 0;
							D_Value_I_All = 0;
							D_Value_I_Gas_All = 0;	
						}
						
						D_T_Cpm_Name = Bean.getCpm_Name();
						D_CTime = Bean.getCTime();
						D_Value_O = Bean.getValue_O();
						D_Value_O_Gas = Bean.getValue_O_Gas();
						D_Value_I = Bean.getValue_I();
						D_Value_I_Gas = Bean.getValue_I_Gas();
						D_Value_R = Bean.getValue_R();
						D_Value_R_Gas = Bean.getValue_R_Gas();
						
						D_Value_O_All     = D_Value_O_All + Double.parseDouble(D_Value_O);
						D_Value_O_Gas_All = D_Value_O_Gas_All + Double.parseDouble(D_Value_O_Gas);
						D_Value_I_All     = D_Value_I_All + Double.parseDouble(D_Value_I);
						D_Value_I_Gas_All = D_Value_I_Gas_All + Double.parseDouble(D_Value_I_Gas);
						
						D_Index++;
			            sheet.setRowView(D_Index, 600);
			            sheet.setColumnView(D_Index, 12);
			            Label label = new Label(0, D_Index, "LNG��עվ������Ӫ�±���", wff);
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
			            sheet.mergeCells(0,D_Index,6,D_Index);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 12);
			            label = new Label(0, D_Index, "վ������: " + D_T_Cpm_Name, wff2);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(2, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(3, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,3,D_Index);
			            label = new Label(4, D_Index, "��������: "+ Year +"��"+ Month +"��", wff2);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(4,D_Index,6,D_Index);
			            		       
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 12);
			            label = new Label(0, D_Index, "����", wff2);
			            sheet.addCell(label);			            
			            label = new Label(1, D_Index, "��������", wff2);
			            sheet.addCell(label);			   
			            label = new Label(2, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(1,D_Index,2,D_Index);		            
			            label = new Label(3, D_Index, "��������", wff2);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(3,D_Index,4,D_Index);			            
			            label = new Label(5, D_Index, "�������", wff2);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(5,D_Index,6,D_Index);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 12);
			            label = new Label(0, D_Index, " ", wff2);
			            sheet.addCell(label);
			            sheet.mergeCells( 0 , 2 , 0 , 3 );  
			            switch(Integer.parseInt(currStatus.getFunc_Corp_Id()))
						{
							default:
							case 1000://����
							case 1010://90#����
							case 1011://90#��Ǧ����
							case 1012://90#�������
							case 1020://92#����
							case 1021://92#��Ǧ����
							case 1022://92#�������
							case 1030://93#����
							case 1031://93����Ǧ����
							case 1032://93#�������
							case 1040://95#����
							case 1041://95#��Ǧ����
							case 1042://95#�������
							case 1050://97#����
							case 1051://97#��Ǧ����
							case 1052://97#�������
							case 1060://120������
							case 1080://������������
							case 1090://98#����
							case 1091://98#��Ǧ����
							case 1092://98���������
							case 1100://��������
							case 1200://��������
							case 1201://75#��������
							case 1202://95#��������
							case 1203://100#��������
							case 1204://������������
							case 1300://��������
							case 2000://����
							case 2001://0#����
							case 2002://+5#����
							case 2003://+10#����
							case 2004://+15#����
							case 2005://+20#����
							case 2006://-5#����
							case 2007://-10#����
							case 2008://-15#����
							case 2009://-20#����
							case 2010://-30#����
							case 2011://-35#����
							case 2015://-50#����
							case 2100://�����
							case 2016://���������
							case 2200://�ز���
							case 2012://10#�ز���
							case 2013://20#�ز���
							case 2014://�����ز���
							case 2300://���ò���
							case 2301://-10#���ò���
							case 2900://��������
								label = new Label(1, D_Index, "ȼ����(L)", wff2);
					            sheet.addCell(label);			   
					            label = new Label(2, D_Index, "�ۺ�����(kg)", wff2);
					            sheet.addCell(label);    
					            label = new Label(3, D_Index, "ȼ����(L)", wff2);
					            sheet.addCell(label);
					            label = new Label(4, D_Index, "�ۺ�����(kg)", wff2);
					            sheet.addCell(label);        
					            label = new Label(5, D_Index, "ȼ����(L)", wff2);
					            sheet.addCell(label);
					            label = new Label(6, D_Index, "�ۺ�����(kg)", wff2);
					            sheet.addCell(label);
								break;
							case 3001://CNG
							case 3002://LNG
								label = new Label(1, D_Index, "ȼ����(kg)", wff2);
					            sheet.addCell(label);			   
					            label = new Label(2, D_Index, "�ۺ���̬(m3)", wff2);
					            sheet.addCell(label);    
					            label = new Label(3, D_Index, "ȼ����(kg)", wff2);
					            sheet.addCell(label);
					            label = new Label(4, D_Index, "�ۺ���̬(m3)", wff2);
					            sheet.addCell(label);        
					            label = new Label(5, D_Index, "ȼ����(kg)", wff2);
					            sheet.addCell(label);
					            label = new Label(6, D_Index, "�ۺ���̬(m3)", wff2);
					            sheet.addCell(label);
								break;
						}		            
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 12);
			            label = new Label(0, D_Index, Integer.parseInt(D_CTime.substring(8,10))+"", wff3);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, D_Value_O, wff3);
			            sheet.addCell(label);			   
			            label = new Label(2, D_Index, D_Value_O_Gas, wff3);
			            sheet.addCell(label);    
			            label = new Label(3, D_Index, D_Value_I, wff3);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, D_Value_I_Gas, wff3);
			            sheet.addCell(label);        
			            label = new Label(5, D_Index, D_Value_R, wff3);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, D_Value_R_Gas, wff3);
			            sheet.addCell(label);						
					}
					else
					{
						D_T_Cpm_Name = Bean.getCpm_Name();
						D_CTime = Bean.getCTime();
						D_Value_O = Bean.getValue_O();
						D_Value_O_Gas = Bean.getValue_O_Gas();
						D_Value_I = Bean.getValue_I();
						D_Value_I_Gas = Bean.getValue_I_Gas();
						D_Value_R = Bean.getValue_R();
						D_Value_R_Gas = Bean.getValue_R_Gas();
						
						D_Value_O_All     = D_Value_O_All + Double.parseDouble(D_Value_O);
						D_Value_O_Gas_All = D_Value_O_Gas_All + Double.parseDouble(D_Value_O_Gas);
						D_Value_I_All     = D_Value_I_All + Double.parseDouble(D_Value_I);
						D_Value_I_Gas_All = D_Value_I_Gas_All + Double.parseDouble(D_Value_I_Gas);
						
						D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 12);
			            Label label = new Label(0, D_Index, Integer.parseInt(D_CTime.substring(8,10))+"", wff3);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, D_Value_O, wff3);
			            sheet.addCell(label);			   
			            label = new Label(2, D_Index, D_Value_O_Gas, wff3);
			            sheet.addCell(label);    
			            label = new Label(3, D_Index, D_Value_I, wff3);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, D_Value_I_Gas, wff3);
			            sheet.addCell(label);        
			            label = new Label(5, D_Index, D_Value_R, wff3);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, D_Value_R_Gas, wff3);
			            sheet.addCell(label);			
					}
					D_T_Cpm_Id = Bean.getCpm_Id();
					if(D_cnt == temp0.size())
					{
						//�����ۼ�
						if(null != temp1)
						{
							Iterator<?> yeariter = temp1.iterator();
							while(yeariter.hasNext())
							{
								ProLBean yearBean = (ProLBean)yeariter.next();
								if(D_T_Cpm_Id.equals(yearBean.getCpm_Id()))
								{
									D_Value_O_Y = yearBean.getValue_O();
									D_Value_O_Gas_Y = yearBean.getValue_O_Gas();
									D_Value_I_Y = yearBean.getValue_I();
									D_Value_I_Gas_Y = yearBean.getValue_I_Gas();
								}
							}
						}
						
						D_Index++;
						sheet.setRowView(D_Index, 400);
						sheet.setColumnView(D_Index, 12);
						Label label = new Label(0, D_Index, "�����ۼ�", wff2);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, (new BigDecimal(D_Value_O_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
			            sheet.addCell(label);
			            label = new Label(2, D_Index, (new BigDecimal(D_Value_O_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, (new BigDecimal(D_Value_I_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, (new BigDecimal(D_Value_I_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, "", wff2);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "", wff2);
			            sheet.addCell(label);
			            			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 12);
			            label = new Label(0, D_Index, "�����ۼ�", wff2);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, D_Value_O_Y, wff2);
			            sheet.addCell(label);
			            label = new Label(2, D_Index, D_Value_O_Gas_Y, wff2);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, D_Value_I_Y, wff2);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, D_Value_I_Gas_Y, wff2);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, "", wff2);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "", wff2);
			            sheet.addCell(label);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 12);
			            label = new Label(0, D_Index, "�Ʊ�: ϵͳ", wff2);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "", wff4);
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,1,D_Index);
			            label = new Label(2, D_Index, "���: " + Operator_Name, wff2);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, "", wff4);
			            sheet.addCell(label);
			            sheet.mergeCells(2,D_Index,3,D_Index);
			            label = new Label(4, D_Index, "�ϱ�����: " + CommUtil.getDate(), wff2);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, "", wff4);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "", wff4);
			            sheet.addCell(label);
			            sheet.mergeCells(4,D_Index,6,D_Index);
					}
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
	
	//�ܱ���
	public void ExportToExcel_W(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) 
	{
		try
		{
			getHtmlData(request);
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.getHtmlData(request, pFromZone);
			
			switch(currStatus.getFunc_Sub_Id())
			{
				case 0://�걨��
					break;
			    case 1://�±���
			    	break;
			    case 2://�ܱ���
			    	request.getSession().setAttribute("Week_" + Sid, Week);
			    	request.getSession().setAttribute("Month_" + Sid, Month);
			    	request.getSession().setAttribute("Year_" + Sid, Year);
			    	break;
			    case 3://�ձ���
			    	break;
			}
			
			//�жϵ���1�������ڼ������������죬��Ϊ��һ�ܵ�һ�죬�����������
	    	String pBTime = "";
			String pETime = "";
			switch(Integer.parseInt(CommUtil.getWeekDayString(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-01")))
			{
	    		case 0://������
	    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-01 00:00:00", (Integer.parseInt(Week)-1)*7);
			    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-01 00:00:00", (Integer.parseInt(Week))*7-1);
	    			break;
	    		case 1://����һ
	    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-07 00:00:00", (Integer.parseInt(Week)-1)*7);
			    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-07 00:00:00", (Integer.parseInt(Week))*7-1);
	    			break;
	    		case 2://���ڶ�
	    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-06 00:00:00", (Integer.parseInt(Week)-1)*7);
			    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-06 00:00:00", (Integer.parseInt(Week))*7-1);
	    			break;
	    		case 3://������
	    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-05 00:00:00", (Integer.parseInt(Week)-1)*7);
			    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-05 00:00:00", (Integer.parseInt(Week))*7-1);
	    			break;
	    		case 4://������
	    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-04 00:00:00", (Integer.parseInt(Week)-1)*7);
			    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-04 00:00:00", (Integer.parseInt(Week))*7-1);
	    			break;
	    		case 5://������
	    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-03 00:00:00", (Integer.parseInt(Week)-1)*7);
			    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-03 00:00:00", (Integer.parseInt(Week))*7-1);
	    			break;
	    		case 6://������
	    			pBTime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-02 00:00:00", (Integer.parseInt(Week)-1)*7);
			    	pETime = CommUtil.getDateAfter(Year + "-" + CommUtil.StrLeftFillZero(Month, 2) + "-02 00:00:00", (Integer.parseInt(Week))*7-1);
	    			break;
			}
			
			//�ж�pBTime�Ƿ��ڱ�����
			if(Integer.parseInt(pBTime.substring(5,7)) == Integer.parseInt(Month))
			{
				pBTime = pBTime.substring(0,10);
				pETime = pETime.substring(0,10);
				currStatus.setVecDate(CommUtil.getDate(pBTime, pETime));
			}
			else
			{
				pBTime = "1970-01-01";
				pETime = "1970-01-01";
				currStatus.setVecDate(CommUtil.getDate(pBTime, pETime));
			}
			
			//�����ʷ
			
			//���ɵ�ǰ
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
			String ET = currStatus.getVecDate().get(1).toString().substring(5,10);
			String SheetName = "��վ�ܱ����ܱ�";
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
			
			//��˾����
			CorpInfoBean Corp_Info = (CorpInfoBean)request.getSession().getAttribute("User_Corp_Info_" + Sid);
			String D_Oil_Info = "";
			String D_Oil_Name = "";
			if(null != Corp_Info)
			{
				D_Oil_Info = Corp_Info.getOil_Info();
				if(null == D_Oil_Info){D_Oil_Info = "";}
				if(null != currStatus.getFunc_Corp_Id() && D_Oil_Info.length() > 0)
				{
					String[] List = D_Oil_Info.split(";");
					for(int i=0; i<List.length && List[i].length()>0; i++)
					{
					  	String[] subList = List[i].split(",");
					  	if(currStatus.getFunc_Corp_Id().equals(subList[0]))
					  	{
					  		D_Oil_Name = subList[1];
					  		break;
					  	}
			  		}
				}				
			}
			
			//�ܱ���
			msgBean = pRmi.RmiExec(3, this, 0);
			ArrayList<?> temp0 = (ArrayList<?>)msgBean.getMsg();
			
			//���ۼ�
			msgBean = pRmi.RmiExec(1, this, 0);
			ArrayList<?> temp1 = (ArrayList<?>)msgBean.getMsg();
			
			//������
			//msgBean = pRmi.RmiExec(2, this, 0);
			ProOBean pBean =new ProOBean();
	    	pBean.setCpm_Id(Cpm_Id);
	    	pBean.currStatus = currStatus;
	    	msgBean = pRmi.RmiExec(5, pBean, 0);
			ArrayList<?> temp2 = (ArrayList<?>)msgBean.getMsg();
			String D_T_Cpm_Id   = "";
			String D_T_Cpm_Name = "";
			int D_cnt           = 0;
			int D_Index         = -1;
			Label label         = null;
			double Value_O_All     = 0.0;
		  	double Value_O_Gas_All = 0.0;
		  	double Value_I_All     = 0.0;
		  	double Value_I_Gas_All = 0.0;
		  	double Value_R_All     = 0.0;
		  	double Value_R_Gas_All = 0.0;
			if(null != temp0)
			{
				//�����ļ�
				WritableWorkbook book = Workbook.createWorkbook(new File(UPLOAD_PATH + UPLOAD_NAME + ".xls"));
	            WritableSheet sheet = book.createSheet(SheetName, 0);
	            
	            //�����ʽ1
	            WritableFont wf = new WritableFont(WritableFont.createFont("normal"), 18, WritableFont.BOLD , false);
				WritableCellFormat wff = new WritableCellFormat(wf);
				wf.setColour(Colour.BLACK);//������ɫ
				wff.setAlignment(Alignment.CENTRE);//���þ���
				wff.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				wff.setBackground(jxl.format.Colour.TURQUOISE);//���õ�Ԫ��ı�����ɫ
				
				//�����ʽ2
				WritableFont wf2 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.BOLD , false);
				WritableCellFormat wff2 = new WritableCellFormat(wf2);
				wf2.setColour(Colour.BLACK);//������ɫ
				wff2.setAlignment(Alignment.CENTRE);//���þ���
				wff2.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				
				//�����ʽ3
				WritableFont wf3 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff3 = new WritableCellFormat(wf3);
				wf3.setColour(Colour.BLACK);//������ɫ
				wff3.setAlignment(Alignment.CENTRE);//���þ���
				wff3.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				
				//�����ʽ4
				WritableFont wf4 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff4 = new WritableCellFormat(wf4);
				wf4.setColour(Colour.BLACK);//������ɫ
				wff4.setAlignment(Alignment.LEFT);//���þ���
				wff4.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				wff4.setWrap(true);
				
				Iterator<?> iterator = temp0.iterator();
				while(iterator.hasNext())
				{
					ProLBean Bean = (ProLBean)iterator.next();
					D_cnt++;
					if(!D_T_Cpm_Id.equals(Bean.getCpm_Id()))
					{
						if(D_T_Cpm_Id.length() > 0)
						{
							//�����������С��
							int D_Car_Cnt = 0;
							if(null != temp2)
							{
								Iterator<?> cariter = temp2.iterator();
								while(cariter.hasNext())
								{
									ProOBean carBean = (ProOBean)cariter.next();
									if(carBean.getCpm_Id().equals(D_T_Cpm_Id))
									{
										D_Car_Cnt++;
									}
								}
							}
							String Summary = "1����վ����Ӫ������"+ D_Car_Cnt +"̨;";
							
							D_Index++;
				            sheet.setRowView(D_Index, 1200);
				            sheet.setColumnView(D_Index, 20);
				            label = new Label(0, D_Index, "�����������С��", wff2);
				            sheet.addCell(label);
				            label = new Label(1, D_Index, "");
				            sheet.addCell(label);
				            sheet.mergeCells(0,D_Index,1,D_Index);
				            label = new Label(2, D_Index, Summary, wff4);
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
				            label = new Label(9, D_Index, "");
				            sheet.addCell(label);
				            label = new Label(10, D_Index, "");
				            sheet.addCell(label);
				            sheet.mergeCells(2,D_Index,10,D_Index);
				            
				            D_Index++;
				            sheet.setRowView(D_Index, 400);
				            sheet.setColumnView(D_Index, 20);
				            label = new Label(0, D_Index, "�Ʊ�: ϵͳ", wff3);
				            sheet.addCell(label);
				            label = new Label(1, D_Index, "");
				            sheet.addCell(label);
				            label = new Label(2, D_Index, "");
				            sheet.addCell(label);
				            sheet.mergeCells(0,D_Index,2,D_Index);
				            label = new Label(3, D_Index, "���: " + Operator_Name, wff3);
				            sheet.addCell(label);
				            label = new Label(4, D_Index, "");
				            sheet.addCell(label);
				            label = new Label(5, D_Index, "");
				            sheet.addCell(label);
				            sheet.mergeCells(3,D_Index,5,D_Index);
				            label = new Label(6, D_Index, "�ϱ�����: " + CommUtil.getDate(), wff3);
				            sheet.addCell(label);
				            label = new Label(7, D_Index, "");
				            sheet.addCell(label);
				            label = new Label(8, D_Index, "");
				            sheet.addCell(label);
				            label = new Label(9, D_Index, "");
				            sheet.addCell(label);
				            label = new Label(10, D_Index, "");
				            sheet.addCell(label);
				            sheet.mergeCells(6,D_Index,10,D_Index);
						}
						
						D_T_Cpm_Name = Bean.getCpm_Name();
						
						D_Index++;
			            sheet.setRowView(D_Index, 600);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "����վ������Ӫ�ܱ���[" + D_Oil_Name + "]", wff);
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
			            label = new Label(9, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(10, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,10,D_Index);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "վ������: " + D_T_Cpm_Name, wff2);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(2, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(3, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,3,D_Index);
			            label = new Label(4, D_Index, "��������: "+ currStatus.getVecDate().get(0).toString().substring(0,10) +" �� "+ currStatus.getVecDate().get(1).toString().substring(0,10), wff2);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(7, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(8, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(9, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(10, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(4,D_Index,10,D_Index);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "����", wff2);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,1,D_Index);
			            label = new Label(2, D_Index, "������", wff2);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, "����һ", wff2);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, "���ڶ�", wff2);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, "������", wff2);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "������", wff2);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, "������", wff2);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, "������", wff2);
			            sheet.addCell(label);
			            label = new Label(9, D_Index, "�����ۼ�", wff2);
			            sheet.addCell(label);
			            label = new Label(10, D_Index, "�����ۼ�", wff2);
			            sheet.addCell(label);
			            
						String Name1 = "";
						String Name2 = "";
					  	switch(Integer.parseInt(currStatus.getFunc_Corp_Id()))
						{
							default:
							case 1000://����
							case 1010://90#����
							case 1011://90#��Ǧ����
							case 1012://90#�������
							case 1020://92#����
							case 1021://92#��Ǧ����
							case 1022://92#�������
							case 1030://93#����
							case 1031://93����Ǧ����
							case 1032://93#�������
							case 1040://95#����
							case 1041://95#��Ǧ����
							case 1042://95#�������
							case 1050://97#����
							case 1051://97#��Ǧ����
							case 1052://97#�������
							case 1060://120������
							case 1080://������������
							case 1090://98#����
							case 1091://98#��Ǧ����
							case 1092://98���������
							case 1100://��������
							case 1200://��������
							case 1201://75#��������
							case 1202://95#��������
							case 1203://100#��������
							case 1204://������������
							case 1300://��������
							case 2000://����
							case 2001://0#����
							case 2002://+5#����
							case 2003://+10#����
							case 2004://+15#����
							case 2005://+20#����
							case 2006://-5#����
							case 2007://-10#����
							case 2008://-15#����
							case 2009://-20#����
							case 2010://-30#����
							case 2011://-35#����
							case 2015://-50#����
							case 2100://�����
							case 2016://���������
							case 2200://�ز���
							case 2012://10#�ز���
							case 2013://20#�ز���
							case 2014://�����ز���
							case 2300://���ò���
							case 2301://-10#���ò���
							case 2900://��������
								Name1 = "ȼ����(L)";
							    Name2 = "�ۺ�����(kg)";
								break;
							case 3001://CNG
							case 3002://LNG
								Name1 = "ȼ����(kg)";
							    Name2 = "�ۺ���̬(m3)";
								break;
						}
					  	
					  	//���� - ����
					  	String a_Value_O     = "0";
					  	String a_Value_O_Gas = "0";
					  	String a_Value_I     = "0";
					  	String a_Value_I_Gas = "0";
					  	String a_Value_R     = "0";
					  	String a_Value_R_Gas = "0";
					  
					  	String b_Value_O     = "0";
					  	String b_Value_O_Gas = "0";
					  	String b_Value_I     = "0";
					  	String b_Value_I_Gas = "0";
					  	String b_Value_R     = "0";
					  	String b_Value_R_Gas = "0";
					  
					  	String c_Value_O     = "0";
					  	String c_Value_O_Gas = "0";
					  	String c_Value_I     = "0";
					  	String c_Value_I_Gas = "0";
					  	String c_Value_R     = "0";
					  	String c_Value_R_Gas = "0";
					  
					  	String d_Value_O     = "0";
					  	String d_Value_O_Gas = "0";
					  	String d_Value_I     = "0";
					  	String d_Value_I_Gas = "0";
					  	String d_Value_R     = "0";
					  	String d_Value_R_Gas = "0";
					  
					  	String e_Value_O     = "0";
					  	String e_Value_O_Gas = "0";
					  	String e_Value_I     = "0";
					  	String e_Value_I_Gas = "0";
					  	String e_Value_R     = "0";
					  	String e_Value_R_Gas = "0";
					  
					  	String f_Value_O     = "0";
					  	String f_Value_O_Gas = "0";
					  	String f_Value_I     = "0";
					  	String f_Value_I_Gas = "0";
					  	String f_Value_R     = "0";
					  	String f_Value_R_Gas = "0";
					  
					  	String g_Value_O     = "0";
					  	String g_Value_O_Gas = "0";
					  	String g_Value_I     = "0";
					  	String g_Value_I_Gas = "0";
					  	String g_Value_R     = "0";
					  	String g_Value_R_Gas = "0";
					  	
					  	if(null != temp0)
						{
							Iterator<?> dataiter = temp0.iterator();
							while(dataiter.hasNext())
							{
								ProLBean dataBean = (ProLBean)dataiter.next();
								if(dataBean.getCpm_Id().equals(Bean.getCpm_Id()))
								{
									if(0 == CommUtil.getCompareDay(dataBean.getCTime(), currStatus.getVecDate().get(0).toString().substring(0,10)))
									{
										a_Value_O     = dataBean.getValue_O();
										a_Value_O_Gas = dataBean.getValue_O_Gas();
										a_Value_I     = dataBean.getValue_I();
										a_Value_I_Gas = dataBean.getValue_I_Gas();
										a_Value_R     = dataBean.getValue_R();
										a_Value_R_Gas = dataBean.getValue_R_Gas();
									}
									if(0 == CommUtil.getCompareDay(dataBean.getCTime(), CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 1).substring(0,10)))
									{
										b_Value_O     = dataBean.getValue_O();
										b_Value_O_Gas = dataBean.getValue_O_Gas();
										b_Value_I     = dataBean.getValue_I();
										b_Value_I_Gas = dataBean.getValue_I_Gas();
										b_Value_R     = dataBean.getValue_R();
										b_Value_R_Gas = dataBean.getValue_R_Gas();
									}
									if(0 == CommUtil.getCompareDay(dataBean.getCTime(), CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 2).substring(0,10)))
									{
										c_Value_O     = dataBean.getValue_O();
										c_Value_O_Gas = dataBean.getValue_O_Gas();
										c_Value_I     = dataBean.getValue_I();
										c_Value_I_Gas = dataBean.getValue_I_Gas();
										c_Value_R     = dataBean.getValue_R();
										c_Value_R_Gas = dataBean.getValue_R_Gas();
									}
									if(0 == CommUtil.getCompareDay(dataBean.getCTime(), CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 3).substring(0,10)))
									{
										d_Value_O     = dataBean.getValue_O();
										d_Value_O_Gas = dataBean.getValue_O_Gas();
										d_Value_I     = dataBean.getValue_I();
										d_Value_I_Gas = dataBean.getValue_I_Gas();
										d_Value_R     = dataBean.getValue_R();
										d_Value_R_Gas = dataBean.getValue_R_Gas();
									}
									if(0 == CommUtil.getCompareDay(dataBean.getCTime(), CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 4).substring(0,10)))
									{
										e_Value_O     = dataBean.getValue_O();
										e_Value_O_Gas = dataBean.getValue_O_Gas();
										e_Value_I     = dataBean.getValue_I();
										e_Value_I_Gas = dataBean.getValue_I_Gas();
										e_Value_R     = dataBean.getValue_R();
										e_Value_R_Gas = dataBean.getValue_R_Gas();
									}
									if(0 == CommUtil.getCompareDay(dataBean.getCTime(), CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 5).substring(0,10)))
									{
										f_Value_O     = dataBean.getValue_O();
										f_Value_O_Gas = dataBean.getValue_O_Gas();
										f_Value_I     = dataBean.getValue_I();
										f_Value_I_Gas = dataBean.getValue_I_Gas();
										f_Value_R     = dataBean.getValue_R();
										f_Value_R_Gas = dataBean.getValue_R_Gas();
									}
									if(0 == CommUtil.getCompareDay(dataBean.getCTime(), currStatus.getVecDate().get(1).toString().substring(0,10)))
									{
										g_Value_O     = dataBean.getValue_O();
										g_Value_O_Gas = dataBean.getValue_O_Gas();
										g_Value_I     = dataBean.getValue_I();
										g_Value_I_Gas = dataBean.getValue_I_Gas();
										g_Value_R     = dataBean.getValue_R();
										g_Value_R_Gas = dataBean.getValue_R_Gas();
									}
								}
							}
						}
					  	
					 
						  
					  	Value_O_All = Double.parseDouble(a_Value_O) 
						          	+ Double.parseDouble(b_Value_O) 
						          	+ Double.parseDouble(c_Value_O) 
						          	+ Double.parseDouble(d_Value_O) 
						          	+ Double.parseDouble(e_Value_O) 
						          	+ Double.parseDouble(f_Value_O) 
						          	+ Double.parseDouble(g_Value_O);
						              
					  	Value_O_Gas_All = Double.parseDouble(a_Value_O_Gas) 
						             	+ Double.parseDouble(b_Value_O_Gas) 
						             	+ Double.parseDouble(c_Value_O_Gas) 
						             	+ Double.parseDouble(d_Value_O_Gas) 
						             	+ Double.parseDouble(e_Value_O_Gas) 
						             	+ Double.parseDouble(f_Value_O_Gas) 
						             	+ Double.parseDouble(g_Value_O_Gas);
						  
					  	Value_I_All = Double.parseDouble(a_Value_I) 
						           	+ Double.parseDouble(b_Value_I) 
						           	+ Double.parseDouble(c_Value_I) 
						           	+ Double.parseDouble(d_Value_I) 
						           	+ Double.parseDouble(e_Value_I) 
						           	+ Double.parseDouble(f_Value_I) 
						           	+ Double.parseDouble(g_Value_I);
						              
					  	Value_I_Gas_All = Double.parseDouble(a_Value_I_Gas) 
						             	+ Double.parseDouble(b_Value_I_Gas) 
						             	+ Double.parseDouble(c_Value_I_Gas) 
						             	+ Double.parseDouble(d_Value_I_Gas) 
						             	+ Double.parseDouble(e_Value_I_Gas) 
						             	+ Double.parseDouble(f_Value_I_Gas) 
						             	+ Double.parseDouble(g_Value_I_Gas);
						              		
					  	Value_R_All = Double.parseDouble(a_Value_R) 
						           	+ Double.parseDouble(b_Value_R) 
						           	+ Double.parseDouble(c_Value_R) 
						           	+ Double.parseDouble(d_Value_R) 
						           	+ Double.parseDouble(e_Value_R) 
						           	+ Double.parseDouble(f_Value_R) 
						           	+ Double.parseDouble(g_Value_R);
						              
					  	Value_R_Gas_All = Double.parseDouble(a_Value_R_Gas) 
						             	+ Double.parseDouble(b_Value_R_Gas) 
						             	+ Double.parseDouble(c_Value_R_Gas) 
						             	+ Double.parseDouble(d_Value_R_Gas) 
						             	+ Double.parseDouble(e_Value_R_Gas) 
						             	+ Double.parseDouble(f_Value_R_Gas) 
						             	+ Double.parseDouble(g_Value_R_Gas);
					  	
					  	//�����ۼ�
					  	String Value_O_Y     = "0";
					  	String Value_O_Gas_Y = "0";
					  	String Value_I_Y     = "0";
					  	String Value_I_Gas_Y = "0";
					  	String Value_R_Y     = "0";
					  	String Value_R_Gas_Y = "0";
						if(null != temp1)
						{
							Iterator<?> yeariter = temp1.iterator();
							while(yeariter.hasNext())
							{
								ProLBean yearBean = (ProLBean)yeariter.next();
								if(yearBean.getCpm_Id().equals(Bean.getCpm_Id()))
								{
									Value_O_Y     = yearBean.getValue_O();
									Value_O_Gas_Y = yearBean.getValue_O_Gas();
									Value_I_Y     = yearBean.getValue_I();
									Value_I_Gas_Y = yearBean.getValue_I_Gas();
									Value_R_Y     = yearBean.getValue_R();
									Value_R_Gas_Y = yearBean.getValue_R_Gas();
								}
							}
						}
						
						D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "��Ŀ", wff2);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,1,D_Index);
			            label = new Label(2, D_Index, "("+ currStatus.getVecDate().get(0).toString().substring(5,10) +")", wff2);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, "("+ CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 1).substring(5,10) +")", wff2);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, "("+ CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 2).substring(5,10) +")", wff2);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, "("+ CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 3).substring(5,10) +")", wff2);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "("+ CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 4).substring(5,10) +")", wff2);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, "("+ CommUtil.getDateAfter(currStatus.getVecDate().get(0).toString().substring(0,10) + " 00:00:00", 5).substring(5,10) +")", wff2);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, "("+ currStatus.getVecDate().get(1).toString().substring(5,10) +")", wff2);
			            sheet.addCell(label);
			            label = new Label(9, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(10, D_Index, "");
			            sheet.mergeCells(9,D_Index-1,9,D_Index);
			            sheet.mergeCells(10,D_Index-1,10,D_Index);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "��������", wff3);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, Name1, wff3);
			            sheet.addCell(label);
			            label = new Label(2, D_Index, a_Value_O, wff3);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, b_Value_O, wff3);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, c_Value_O, wff3);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, d_Value_O, wff3);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, e_Value_O, wff3);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, f_Value_O, wff3);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, g_Value_O, wff3);
			            sheet.addCell(label);
			            label = new Label(9, D_Index, new BigDecimal(Value_O_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff3);
			            sheet.addCell(label);
			            label = new Label(10, D_Index, Value_O_Y, wff3);
			            sheet.addCell(label);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "", wff3);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, Name2, wff3);
			            sheet.addCell(label);
			            label = new Label(2, D_Index, a_Value_O_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, b_Value_O_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, c_Value_O_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, d_Value_O_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, e_Value_O_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, f_Value_O_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, g_Value_O_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(9, D_Index, new BigDecimal(Value_O_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff3);
			            sheet.addCell(label);
			            label = new Label(10, D_Index, Value_O_Gas_Y, wff3);
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index-1,0,D_Index);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "��������", wff3);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, Name1, wff3);
			            sheet.addCell(label);
			            label = new Label(2, D_Index, a_Value_I, wff3);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, b_Value_I, wff3);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, c_Value_I, wff3);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, d_Value_I, wff3);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, e_Value_I, wff3);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, f_Value_I, wff3);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, g_Value_I, wff3);
			            sheet.addCell(label);
			            label = new Label(9, D_Index, new BigDecimal(Value_I_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff3);
			            sheet.addCell(label);
			            label = new Label(10, D_Index, Value_I_Y, wff3);
			            sheet.addCell(label);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "", wff3);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, Name2, wff3);
			            sheet.addCell(label);
			            label = new Label(2, D_Index, a_Value_I_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, b_Value_I_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, c_Value_I_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, d_Value_I_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, e_Value_I_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, f_Value_I_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, g_Value_I_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(9, D_Index, new BigDecimal(Value_I_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff3);
			            sheet.addCell(label);
			            label = new Label(10, D_Index, Value_I_Gas_Y, wff3);
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index-1,0,D_Index);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "�������", wff3);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, Name1, wff3);
			            sheet.addCell(label);
			            label = new Label(2, D_Index, a_Value_R, wff3);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, b_Value_R, wff3);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, c_Value_R, wff3);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, d_Value_R, wff3);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, e_Value_R, wff3);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, f_Value_R, wff3);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, g_Value_R, wff3);
			            sheet.addCell(label);
			            label = new Label(9, D_Index, new BigDecimal(Value_R_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff3);
			            sheet.addCell(label);
			            label = new Label(10, D_Index, Value_R_Y, wff3);
			            sheet.addCell(label);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "", wff3);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, Name2, wff3);
			            sheet.addCell(label);
			            label = new Label(2, D_Index, a_Value_R_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, b_Value_R_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, c_Value_R_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, d_Value_R_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, e_Value_R_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, f_Value_R_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, g_Value_R_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(9, D_Index, new BigDecimal(Value_R_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff3);
			            sheet.addCell(label);
			            label = new Label(10, D_Index, Value_R_Gas_Y, wff3);
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index-1,0,D_Index);
					}
					
					D_T_Cpm_Id = Bean.getCpm_Id();
					if(D_cnt == temp0.size())
					{
						//�����������С��
						int D_Car_Cnt = 0;
						if(null != temp2)
						{
							Iterator<?> cariter = temp2.iterator();
							while(cariter.hasNext())
							{
								ProOBean carBean = (ProOBean)cariter.next();
								if(carBean.getCpm_Id().equals(D_T_Cpm_Id))
								{
									D_Car_Cnt++;
								}
							}
						}
						String Summary = "1����վ����Ӫ��������"+ D_Car_Cnt +" ̨;"+"2����������Ϊ��"+ new BigDecimal(Value_I_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+
								"kg"+"3�����ܽ���������"+new BigDecimal(Value_R_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"kg";
						
						D_Index++;
			            sheet.setRowView(D_Index, 1200);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "�����������С��", wff2);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,1,D_Index);
			            label = new Label(2, D_Index, Summary, wff4);
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
			            label = new Label(9, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(10, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(2,D_Index,10,D_Index);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "�Ʊ�: ϵͳ", wff3);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(2, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,2,D_Index);
			            label = new Label(3, D_Index, "���: " + Operator_Name, wff3);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(5, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(3,D_Index,5,D_Index);
			            label = new Label(6, D_Index, "�ϱ�����: " + CommUtil.getDate(), wff3);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(8, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(9, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(10, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(6,D_Index,10,D_Index);
					}
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
	
	//�ձ���
	public void ExportToExcel_D(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) 
	{
		try
		{
			getHtmlData(request);
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.getHtmlData(request, pFromZone);		
			
			switch(currStatus.getFunc_Sub_Id())
			{
				case 0://�걨��
					break;
			    case 1://�±���
			    	break;
			    case 2://�ܱ���
			    	break;
			    case 3://�ձ���
			    	break;
			}
			
			//�����ʷ		
			
			//���ɵ�ǰ
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
			String ET = currStatus.getVecDate().get(0).toString().substring(5,10);
			String SheetName = "�ձ���";
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
			
			//��˾����
			CorpInfoBean Corp_Info = (CorpInfoBean)request.getSession().getAttribute("User_Corp_Info_" + Sid);
			String D_Oil_Info = "";
			String D_Oil_Name = "";
			if(null != Corp_Info)
			{
				D_Oil_Info = Corp_Info.getOil_Info();				
				if(null == D_Oil_Info){D_Oil_Info = "";}
				if(null != currStatus.getFunc_Corp_Id() && D_Oil_Info.length() > 0)
				{
					String[] List = D_Oil_Info.split(";");
					for(int i=0; i<List.length && List[i].length()>0; i++)
					{
					  	String[] subList = List[i].split(",");
					  	if(currStatus.getFunc_Corp_Id().equals(subList[0]))
					  	{
					  		D_Oil_Name = subList[1];
					  		break;
					  	}
			  		}
				}				
			}
			
			//�ձ���
			msgBean = pRmi.RmiExec(4, this, 0);
			ArrayList<?> temp0 = (ArrayList<?>)msgBean.getMsg();
			
			//�ͻ�ͳ��
	    	PLCrmBean PLCrm = new PLCrmBean();	    
	    	PLCrm.setCpm_Id(Cpm_Id);
	    	PLCrm.setFunc_Corp_Id(currStatus.getFunc_Corp_Id());
	    	PLCrm.setVecDa(currStatus.getVecDate());
	    	PLCrm.currStatus = currStatus;
	    	msgBean = pRmi.RmiExec(0, PLCrm, 0);
	    	ArrayList<?> temp1 = (ArrayList<?>)msgBean.getMsg();
	    	
	    	DateBaoBean dbBean = new DateBaoBean();
	    	dbBean.setCpm_Id(Cpm_Id);
	    	dbBean.currStatus = currStatus;
	    	msgBean = pRmi.RmiExec(0, dbBean, 0);
	    	ArrayList<?> Date_P = (ArrayList<?>)msgBean.getMsg();
	    	
	    	
			String D_T_Cpm_Id = "";
			//int D_cnt         = 0;
			int D_Index       = -1;
			Label label       = null;
			if(null != temp0)
			{
				//�����ļ�
				WritableWorkbook book = Workbook.createWorkbook(new File(UPLOAD_PATH + UPLOAD_NAME + ".xls"));
	            WritableSheet sheet = book.createSheet(SheetName, 0);
	            
	            //�����ʽ1
	            WritableFont wf = new WritableFont(WritableFont.createFont("normal"), 18, WritableFont.BOLD , false);
				WritableCellFormat wff = new WritableCellFormat(wf);
				wf.setColour(Colour.BLACK);//������ɫ
				wff.setAlignment(Alignment.CENTRE);//���þ���
				wff.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				wff.setBackground(jxl.format.Colour.TURQUOISE);//���õ�Ԫ��ı�����ɫ
				
				//�����ʽ2
				WritableFont wf2 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.BOLD , false);
				WritableCellFormat wff2 = new WritableCellFormat(wf2);
				wf2.setColour(Colour.BLACK);//������ɫ
				wff2.setAlignment(Alignment.CENTRE);//���þ���
				wff2.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				
				//�����ʽ3
				WritableFont wf3 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
				WritableCellFormat wff3 = new WritableCellFormat(wf3);
				wf3.setColour(Colour.BLACK);//������ɫ
				wff3.setAlignment(Alignment.CENTRE);//���þ���
				wff3.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				
				//�����ʽ4
	            WritableFont wf4 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.BOLD , false);
				WritableCellFormat wff4 = new WritableCellFormat(wf4);
				wf4.setColour(Colour.BLACK);//������ɫ
				wff4.setAlignment(Alignment.CENTRE);//���þ���
				wff4.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
				wff4.setBackground(jxl.format.Colour.ORANGE);//���õ�Ԫ��ı�����ɫ
				
				Iterator<?> iterator = temp0.iterator();
				while(iterator.hasNext())
				{
					ProLBean Bean = (ProLBean)iterator.next();
					//D_cnt++;
					if(!D_T_Cpm_Id.equals(Bean.getCpm_Id()))
					{
						D_Index++;
			            sheet.setRowView(D_Index, 600);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "����վ������Ӫ�ձ���[" + D_Oil_Name + "]", wff);
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
			            label = new Label(0, D_Index, "վ������: " + Bean.getCpm_Name(), wff2);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(2, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(3, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,3,D_Index);
			            label = new Label(4, D_Index, "��������: "+ currStatus.getVecDate().get(0).toString().substring(0,10), wff2);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(7, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(8, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(4,D_Index,8,D_Index);
						
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "��������", wff2);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,1,D_Index);
			            label = new Label(2, D_Index, "ж������", wff2);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(2,D_Index,3,D_Index);
			            label = new Label(4, D_Index, "�������", wff2);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(4,D_Index,5,D_Index);
			            label = new Label(6, D_Index, "ӯ������", wff2);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(6,D_Index,7,D_Index);
			            label = new Label(8, D_Index, "�ɹ�����", wff2);
			            sheet.addCell(label);
			            
			            String Name1 = "";
			            String Name2 = "";
			            String Name3 = "";
			            switch(Integer.parseInt(currStatus.getFunc_Corp_Id()))
			            {
			            	default:
			            	case 1000://����
			            	case 1010://90#����
			            	case 1011://90#��Ǧ����
			            	case 1012://90#�������
			            	case 1020://92#����
			            	case 1021://92#��Ǧ����
			            	case 1022://92#�������
			            	case 1030://93#����
			            	case 1031://93����Ǧ����
			            	case 1032://93#�������
			            	case 1040://95#����
			            	case 1041://95#��Ǧ����
			            	case 1042://95#�������
			            	case 1050://97#����
			            	case 1051://97#��Ǧ����
			            	case 1052://97#�������
			            	case 1060://120������
			            	case 1080://������������
			            	case 1090://98#����
			            	case 1091://98#��Ǧ����
			            	case 1092://98���������
			            	case 1100://��������
			            	case 1200://��������
			            	case 1201://75#��������
			            	case 1202://95#��������
			            	case 1203://100#��������
			            	case 1204://������������
			            	case 1300://��������
			            	case 2000://����
			            	case 2001://0#����
			            	case 2002://+5#����
			            	case 2003://+10#����
			            	case 2004://+15#����
			            	case 2005://+20#����
			            	case 2006://-5#����
			            	case 2007://-10#����
			            	case 2008://-15#����
			            	case 2009://-20#����
			            	case 2010://-30#����
			            	case 2011://-35#����
			            	case 2015://-50#����
			            	case 2100://�����
			            	case 2016://���������
			            	case 2200://�ز���
			            	case 2012://10#�ز���
			            	case 2013://20#�ز���
			            	case 2014://�����ز���
			            	case 2300://���ò���
			            	case 2301://-10#���ò���
			            	case 2900://��������
			            		Name1 = "ȼ����(L)";
			            	    Name2 = "�ۺ�����(kg)";
			            	    Name3 = "(L)";
			            		break;
			            	case 3001://CNG
			            	case 3002://LNG
			            		Name1 = "ȼ����(kg)";
			            	    Name2 = "�ۺ���̬(m3)";
			            	    Name3 = "(kg)";
			            		break;
			            }
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, Name1, wff3);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, Name2, wff3);
			            sheet.addCell(label);
			            label = new Label(2, D_Index, Name1, wff3);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, Name2, wff3);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, Name1, wff3);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, Name2, wff3);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, Name1, wff3);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, Name2, wff3);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, Name1, wff3);
			            sheet.addCell(label);
			            
			            //ÿ������
			            String D_Value_O     = Bean.getValue_O();
			            String D_Value_O_Gas = Bean.getValue_O_Gas();
			            String D_Value_I     = Bean.getValue_I();
			            String D_Value_I_Gas = Bean.getValue_I_Gas();
			            String D_Value_I_Cnt = Bean.getValue_I_Cnt();
			            String D_Value_R     = Bean.getValue_R();
			            String D_Value_R_Gas = Bean.getValue_R_Gas();
			            String D_Value_PAL     = Bean.getValue_PAL();
			            String D_Value_PAL_Gas = Bean.getValue_PAL_Gas();
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, D_Value_O, wff3);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, D_Value_O_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(2, D_Index, D_Value_I, wff3);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, D_Value_I_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, D_Value_R, wff3);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, D_Value_R_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, D_Value_PAL, wff3);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, D_Value_PAL_Gas, wff3);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, D_Value_I, wff3);
			            sheet.addCell(label);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "��ҵ�����ע��", wff4);
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
			            label = new Label(0, D_Index, "��λ", wff2);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(2, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,2,D_Index);
			            label = new Label(3, D_Index, "��װ����", wff2);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(5, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(3,D_Index,5,D_Index);
			            label = new Label(6, D_Index, "��ע����" + Name3, wff2);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(8, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(6,D_Index,8,D_Index);
			            
			            int D_Value_I_Cnt_All = 0;
						double D_Value_I_All  = 0.0;
						if(null != temp1)
						{
							Iterator<?> crmiter = temp1.iterator();
							while(crmiter.hasNext())
							{
								PLCrmBean crmBean = (PLCrmBean)crmiter.next();
								if(crmBean.getCpm_Id().equals(Bean.getCpm_Id()))
								{
									D_Value_I_Cnt_All = D_Value_I_Cnt_All + Integer.parseInt(crmBean.getValue_I_Cnt());
									D_Value_I_All     = D_Value_I_All     + Double.parseDouble(crmBean.getValue_I());
									
									D_Index++;
						            sheet.setRowView(D_Index, 400);
						            sheet.setColumnView(D_Index, 20);
						            label = new Label(0, D_Index, crmBean.getCrm_Name(), wff3);
						            sheet.addCell(label);
						            label = new Label(1, D_Index, "");
						            sheet.addCell(label);
						            label = new Label(2, D_Index, "");
						            sheet.addCell(label);
						            sheet.mergeCells(0,D_Index,2,D_Index);
						            label = new Label(3, D_Index, crmBean.getValue_I_Cnt(), wff3);
						            sheet.addCell(label);
						            label = new Label(4, D_Index, "");
						            sheet.addCell(label);
						            label = new Label(5, D_Index, "");
						            sheet.addCell(label);
						            sheet.mergeCells(3,D_Index,5,D_Index);
						            label = new Label(6, D_Index, crmBean.getValue_I(), wff3);
						            sheet.addCell(label);
						            label = new Label(7, D_Index, "");
						            sheet.addCell(label);
						            label = new Label(8, D_Index, "");
						            sheet.addCell(label);
						            sheet.mergeCells(6,D_Index,8,D_Index);
								}
							}
						}
			            
						D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "�ϼ�", wff2);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(2, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,2,D_Index);
			            label = new Label(3, D_Index, D_Value_I_Cnt_All+"", wff2);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(5, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(3,D_Index,5,D_Index);
			            label = new Label(6, D_Index, new BigDecimal(D_Value_I_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP)+"", wff2);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(8, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(6,D_Index,8,D_Index);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "��վԱ��(��)", wff2);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,1,D_Index);
			            label = new Label(2, D_Index, "�а���(��)", wff2);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(4, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(2,D_Index,4,D_Index);
			            label = new Label(5, D_Index, "������(��)", wff2);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(5,D_Index,6,D_Index);
			            label = new Label(7, D_Index, "ж������", wff2);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(7,D_Index,8,D_Index);
			            
			            String Z_Person="";
			        	String C_Person="";
			        	String Danger="";
			        	String Peccancy="";
			        	String XiaoFang="";
			        	String BaoJing="";
			        	String TongXun="";
			        	String JiJiu="";
			          if(null != Date_P)
			          {
			        	  Iterator<?> Dter = Date_P.iterator();
							while(Dter.hasNext())
							{
								DateBaoBean dBean = (DateBaoBean)Dter.next();
								Z_Person          = dBean.getZ_Person();
								C_Person          = dBean.getC_Person();
								Danger            = dBean.getDanger();
								Peccancy          = dBean.getPeccancy();
								XiaoFang		  = dBean.getXiaoFang();
								BaoJing			  = dBean.getBaoJing();
								TongXun			  = dBean.getTongXun();
								JiJiu             = dBean.getJiJiu();
								
								
							}			        	  
			          }  
			            
			          Integer num = Integer.parseInt(Z_Person) + Integer.parseInt(C_Person);

			            
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, Z_Person, wff3);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,1,D_Index);
			            label = new Label(2, D_Index, C_Person, wff3);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(4, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(2,D_Index,4,D_Index);
			            label = new Label(5, D_Index, num+"", wff3);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(5,D_Index,6,D_Index);
			            label = new Label(7, D_Index, D_Value_I_Cnt, wff3);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(7,D_Index,8,D_Index);
			            
			            //����
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "�¹ʡ�����", wff2);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "");
			            sheet.addCell(label);			            
			            label = new Label(2, D_Index, "", wff2);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(4, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,4,D_Index);
			            label = new Label(5, D_Index, "Υ�����", wff2);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(7, D_Index, "", wff2);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(5,D_Index,8,D_Index);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, Danger, wff2);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "");
			            sheet.addCell(label);			            
			            label = new Label(2, D_Index, "", wff2);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(4, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,4,D_Index);
			            label = new Label(5, D_Index, Peccancy, wff2);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(7, D_Index, "", wff2);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(5,D_Index,8,D_Index);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "����ϵͳ״̬", wff2);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,1,D_Index);
			            label = new Label(2, D_Index, "̽�ⱨ��ϵͳ״̬", wff2);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(4, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(2,D_Index,4,D_Index);
			            label = new Label(5, D_Index, "ͨѶϵͳ", wff2);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(5,D_Index,6,D_Index);
			            label = new Label(7, D_Index, "ҽ�Ƽ�����ʩ", wff2);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(7,D_Index,8,D_Index);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, XiaoFang, wff3);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,1,D_Index);
			            label = new Label(2, D_Index, BaoJing, wff3);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(4, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(2,D_Index,4,D_Index);
			            label = new Label(5, D_Index, TongXun, wff3);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(5,D_Index,6,D_Index);
			            label = new Label(7, D_Index, JiJiu, wff3);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(7,D_Index,8,D_Index);
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "��ע:", wff3);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "", wff3);
			            sheet.addCell(label);
			            label = new Label(2, D_Index, "", wff3);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, "", wff3);
			            sheet.addCell(label);
			            label = new Label(4, D_Index, "", wff3);
			            sheet.addCell(label);
			            label = new Label(5, D_Index, "", wff3);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "", wff3);
			            sheet.addCell(label);
			            label = new Label(7, D_Index, "", wff3);
			            sheet.addCell(label);
			            label = new Label(8, D_Index, "", wff3);
			            sheet.addCell(label);
			            sheet.mergeCells(1,D_Index,8,D_Index);
			            
			            
			            
			            D_Index++;
			            sheet.setRowView(D_Index, 400);
			            sheet.setColumnView(D_Index, 20);
			            label = new Label(0, D_Index, "�Ʊ�: ϵͳ", wff3);
			            sheet.addCell(label);
			            label = new Label(1, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(0,D_Index,1,D_Index);
			            label = new Label(2, D_Index, "���: " + Operator_Name, wff3);
			            sheet.addCell(label);
			            label = new Label(3, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(4, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(2,D_Index,4,D_Index);
			            label = new Label(5, D_Index, "�ϱ�����: " + CommUtil.getDate(), wff3);
			            sheet.addCell(label);
			            label = new Label(6, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(7, D_Index, "");
			            sheet.addCell(label);
			            label = new Label(8, D_Index, "");
			            sheet.addCell(label);
			            sheet.mergeCells(5,D_Index,8,D_Index);
					}
					D_T_Cpm_Id = Bean.getCpm_Id();
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
	//�걨����
	public void ExportToExcel_Y(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) 
	{
		try{getHtmlData(request);
		currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_"+Sid);
		currStatus.getHtmlData(request, pFromZone);
		switch(currStatus.getFunc_Sub_Id())
		{
			case 0://�걨��
				break;
		    case 1://�±���
		    	request.getSession().setAttribute("Month_" + Sid, Month);
		    	request.getSession().setAttribute("Year_" + Sid, Year);
		    	break;
		    case 2://�ܱ���
		    	break;
		    case 3://�ձ���
		    	break;
		    
		}
		SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		String BT = currStatus.getVecDate().get(0).toString().substring(5,10);
		String ET = currStatus.getVecDate().get(1).toString().substring(5,10);
		String SheetName = "�����±���";
		String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + "," + ET;
		CorpInfoBean Corp_Info = (CorpInfoBean)request.getSession().getAttribute("User_Corp_Info_" + Sid);
		String D_Oil_Info = "";
		String D_Oil_Name = "";
		if(null != Corp_Info)
		{	
			D_Oil_Info = Corp_Info.getOil_Info();
			if(null == D_Oil_Info){D_Oil_Info = "";}				
			if(null != currStatus.getFunc_Corp_Id() && D_Oil_Info.length() > 0)
			{
				String[] List = D_Oil_Info.split(";");
				for(int i=0; i<List.length && List[i].length()>0; i++)
				{
				  	String[] subList = List[i].split(",");
				  	if(currStatus.getFunc_Corp_Id().equals(subList[0]))
				  	{
				  		D_Oil_Name = subList[1];
				  		break;
				  	}
		  		}
			}
		}
		//��վ�걨��
		msgBean = pRmi.RmiExec(5, this, 0);
		ArrayList<?> temp0 = (ArrayList<?>)msgBean.getMsg();		
		String T_Cpm_Id       = "";
		String T_Cpm_Name     = "";
		String CTime          = "";
		String Value_O        = "0";
		String Value_O_Gas    = "0";
		String Value_I        = "0";
		String Value_I_Gas    = "0";
		String Value_R        = "0";
		String Value_R_Gas    = "0";
		String Value_PAL        = "0";
		String Value_PAL_Gas    = "0";
		
		//�����ۼ�
		double Value_O_All     = 0.00;
		double Value_O_Gas_All = 0.00;
		double Value_I_All     = 0.00;
		double Value_I_Gas_All = 0.00;
		double Value_R_All 	   = 0.00;
		double Value_R_Gas_All = 0.00;	
		double Value_PAL_All 	   = 0.00;
		double Value_PAL_Gas_All = 0.00;	
		
		//ͳ������
		int D_Index            = -1;
		if(null != temp0)
		{
			//�����ļ�
			WritableWorkbook book = Workbook.createWorkbook(new File(UPLOAD_PATH + UPLOAD_NAME + ".xls"));
            WritableSheet sheet = book.createSheet(SheetName, 0);
            
            //�����ʽ1
            WritableFont wf = new WritableFont(WritableFont.createFont("normal"), 18, WritableFont.BOLD , false);
			WritableCellFormat wff = new WritableCellFormat(wf);
			wf.setColour(Colour.BLACK);//������ɫ
			wff.setAlignment(Alignment.CENTRE);//���þ���
			wff.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
			wff.setBackground(jxl.format.Colour.TURQUOISE);//���õ�Ԫ��ı�����ɫ			
			
			//�����ʽ2
			WritableFont wf2 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.BOLD , false);
			WritableCellFormat wff2 = new WritableCellFormat(wf2);
			wf2.setColour(Colour.BLACK);//������ɫ
			wff2.setAlignment(Alignment.CENTRE);//���þ���
			wff2.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
			
			//�����ʽ3
			WritableFont wf3 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
			WritableCellFormat wff3 = new WritableCellFormat(wf3);
			wf3.setColour(Colour.BLACK);//������ɫ
			wff3.setAlignment(Alignment.CENTRE);//���þ���
			wff3.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
			
			//�����ʽ4
			WritableFont wf4 = new WritableFont(WritableFont.createFont("normal"), 10, WritableFont.NO_BOLD , false);
			WritableCellFormat wff4 = new WritableCellFormat(wf4);
			wf4.setColour(Colour.BLACK);//������ɫ
			wff4.setAlignment(Alignment.LEFT);//���þ���
			wff4.setBorder(Border.ALL, BorderLineStyle.THIN);//���ñ߿���
			wff4.setWrap(true);						
			
			
			System.out.println(temp0);
			Iterator<?> iterator = temp0.iterator();
			while(iterator.hasNext())
			{
				ProLBean pBean = (ProLBean)iterator.next();				
				if(null !=pBean.getCpm_Name())
				{
					T_Cpm_Name      =   pBean.getCpm_Name();				
				}
			}
			D_Index++;
            sheet.setRowView(D_Index, 800);
            sheet.setColumnView(D_Index, 20);
            Label label = new Label(0, D_Index, "����վ������Ӫ�걨��[" + D_Oil_Name + "]", wff);
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
            sheet.setRowView(D_Index, 600);
            sheet.setColumnView(D_Index, 20);
            label = new Label(0, D_Index, "վ������: " + T_Cpm_Name, wff2);
            sheet.addCell(label);
            label = new Label(1, D_Index, "");
            sheet.addCell(label);
            label = new Label(2, D_Index, "");
            sheet.addCell(label);
            label = new Label(3, D_Index, "");
            sheet.addCell(label);
            label = new Label(4, D_Index, "");
            sheet.addCell(label);
            sheet.mergeCells(0,D_Index,4,D_Index);
            label = new Label(5, D_Index, "��������: "+ Year +"��", wff2);
            sheet.addCell(label);
            label = new Label(6, D_Index, "");
            sheet.addCell(label);
            label = new Label(7, D_Index, "");
            sheet.addCell(label);
            label = new Label(8, D_Index, "");
            sheet.addCell(label);
            sheet.mergeCells(5,D_Index,8,D_Index);
            		       
            D_Index++;
            sheet.setRowView(D_Index, 600);
            sheet.setColumnView(D_Index, 20);
            label = new Label(0, D_Index, "��Ŀ", wff2);
            sheet.addCell(label);			            
            label = new Label(1, D_Index, "��������", wff2);
            sheet.addCell(label);			   
            label = new Label(2, D_Index, "");
            sheet.addCell(label);
            sheet.mergeCells(1,D_Index,2,D_Index);		            
            label = new Label(3, D_Index, "��������", wff2);
            sheet.addCell(label);
            label = new Label(4, D_Index, "");
            sheet.addCell(label);
            sheet.mergeCells(3,D_Index,4,D_Index);			            
            label = new Label(5, D_Index, "�������", wff2);
            sheet.addCell(label);
            label = new Label(6, D_Index, "");
            sheet.addCell(label);
            sheet.mergeCells(5,D_Index,6,D_Index);
            label = new Label(7, D_Index, "ӯ������", wff2);
            sheet.addCell(label);
            label = new Label(8, D_Index, "");
            sheet.addCell(label);
            sheet.mergeCells(7,D_Index,8,D_Index);
            D_Index++;
            sheet.setRowView(D_Index, 600);
            sheet.setColumnView(D_Index, 20);
            label = new Label(0, D_Index, "����", wff2);
            sheet.addCell(label);
            
            switch(Integer.parseInt(currStatus.getFunc_Corp_Id()))
			{
				default:
				case 1000://����
				case 1010://90#����
				case 1011://90#��Ǧ����
				case 1012://90#�������
				case 1020://92#����
				case 1021://92#��Ǧ����
				case 1022://92#�������
				case 1030://93#����
				case 1031://93����Ǧ����
				case 1032://93#�������
				case 1040://95#����
				case 1041://95#��Ǧ����
				case 1042://95#�������
				case 1050://97#����
				case 1051://97#��Ǧ����
				case 1052://97#�������
				case 1060://120������
				case 1080://������������
				case 1090://98#����
				case 1091://98#��Ǧ����
				case 1092://98���������
				case 1100://��������
				case 1200://��������
				case 1201://75#��������
				case 1202://95#��������
				case 1203://100#��������
				case 1204://������������
				case 1300://��������
				case 2000://����
				case 2001://0#����
				case 2002://+5#����
				case 2003://+10#����
				case 2004://+15#����
				case 2005://+20#����
				case 2006://-5#����
				case 2007://-10#����
				case 2008://-15#����
				case 2009://-20#����
				case 2010://-30#����
				case 2011://-35#����
				case 2015://-50#����
				case 2100://�����
				case 2016://���������
				case 2200://�ز���
				case 2012://10#�ز���
				case 2013://20#�ز���
				case 2014://�����ز���
				case 2300://���ò���
				case 2301://-10#���ò���
				case 2900://��������
					label = new Label(1, D_Index, "ȼ����(L)", wff2);
		            sheet.addCell(label);			   
		            label = new Label(2, D_Index, "�ۺ�����(kg)", wff2);
		            sheet.addCell(label);    
		            label = new Label(3, D_Index, "ȼ����(L)", wff2);
		            sheet.addCell(label);
		            label = new Label(4, D_Index, "�ۺ�����(kg)", wff2);
		            sheet.addCell(label);        
		            label = new Label(5, D_Index, "ȼ����(L)", wff2);
		            sheet.addCell(label);
		            label = new Label(6, D_Index, "�ۺ�����(kg)", wff2);
		            sheet.addCell(label);
		            label = new Label(7, D_Index, "ȼ����(L)", wff2);
		            sheet.addCell(label);
		            label = new Label(8, D_Index, "�ۺ�����(kg)", wff2);
		            sheet.addCell(label);
					break;
				case 3001://CNG
				case 3002://LNG
					label = new Label(1, D_Index, "ȼ����(kg)", wff2);
		            sheet.addCell(label);			   
		            label = new Label(2, D_Index, "�ۺ���̬(m3)", wff2);
		            sheet.addCell(label);    
		            label = new Label(3, D_Index, "ȼ����(kg)", wff2);
		            sheet.addCell(label);
		            label = new Label(4, D_Index, "�ۺ���̬(m3)", wff2);
		            sheet.addCell(label);        
		            label = new Label(5, D_Index, "ȼ����(kg)", wff2);
		            sheet.addCell(label);
		            label = new Label(6, D_Index, "�ۺ���̬(m3)", wff2);
		            sheet.addCell(label);
		            label = new Label(7, D_Index, "ȼ����(kg)", wff2);
		            sheet.addCell(label);
		            label = new Label(8, D_Index, "�ۺ���̬(m3)", wff2);
		            sheet.addCell(label);
					break;
			}
                 System.out.println("��ͷ����");    
            Iterator<?> iter = temp0.iterator();
			while(iter.hasNext())
			{	
				ProLBean pBean = (ProLBean)iter.next();	
				if( !T_Cpm_Id.equals(pBean.getCpm_Id()));
				{
					CTime 			= 	pBean.getCTime();				
					Value_O 		= 	pBean.getValue_O();
					Value_O_Gas 	= 	pBean.getValue_O_Gas();
					Value_I 		= 	pBean.getValue_I();
					Value_I_Gas 	= 	pBean.getValue_I_Gas();
					Value_R 		= 	pBean.getValue_R();
					Value_R_Gas 	= 	pBean.getValue_R_Gas();
					Value_PAL 		= 	pBean.getValue_PAL();
					Value_PAL_Gas 	= 	pBean.getValue_PAL_Gas();
					if(null !=Value_O)
					{
						Value_O_All     = 	Value_O_All + Double.parseDouble(Value_O);						
					}else{Value_O = "0.00";}
					if(null !=Value_O_Gas)
					{
						Value_O_Gas_All = 	Value_O_Gas_All + Double.parseDouble(Value_O_Gas);
					}else{Value_O_Gas = "0.00";}
					if(null !=Value_I)
					{
						Value_I_All     = 	Value_I_All + Double.parseDouble(Value_I);
					}else{Value_I = "0.00";}
					if(null !=Value_I_Gas)
					{
						Value_I_Gas_All = 	Value_I_Gas_All + Double.parseDouble(Value_I_Gas);
					}else{Value_I_Gas = "0.00";}
					if(null !=Value_R)
					{
						Value_R_All     = 	Value_R_All + Double.parseDouble(Value_R);
					}else{Value_R = "0.00";}
					if(null !=Value_R_Gas)
					{
						Value_R_Gas_All = 	Value_R_Gas_All + Double.parseDouble(Value_R_Gas);
					}else{Value_R_Gas = "0.00";}
					if(null !=Value_PAL)
					{
						Value_PAL_All     = 	Value_PAL_All + Double.parseDouble(Value_PAL);
					}else{Value_PAL = "0.00";}
					if(null !=Value_PAL_Gas)
					{
						Value_PAL_Gas_All = 	Value_PAL_Gas_All + Double.parseDouble(Value_PAL_Gas);
					}else{Value_PAL_Gas = "0.00";}
					//Value_O_All     = 	Value_O_All + Double.parseDouble(Value_O);
					//Value_O_Gas_All = 	Value_O_Gas_All + Double.parseDouble(Value_O_Gas);
					//Value_I_All     = 	Value_I_All + Double.parseDouble(Value_I);
					//Value_I_Gas_All = 	Value_I_Gas_All + Double.parseDouble(Value_I_Gas);
					//Value_R_All     = 	Value_R_All + Double.parseDouble(Value_R);
					//Value_R_Gas_All = 	Value_R_Gas_All + Double.parseDouble(Value_R_Gas);
					
					D_Index++;
		            sheet.setRowView(D_Index, 600);
		            sheet.setColumnView(D_Index, 20);
		            Label labe2 = new Label(0, D_Index, Integer.parseInt(CTime.substring(4,6))+"", wff3);
		            sheet.addCell(labe2);
		            labe2 = new Label(1, D_Index, Value_O, wff3);
		            sheet.addCell(labe2);			   
		            labe2 = new Label(2, D_Index, Value_O_Gas, wff3);
		            sheet.addCell(labe2);    
		            labe2 = new Label(3, D_Index, Value_I, wff3);
		            sheet.addCell(labe2);
		            labe2 = new Label(4, D_Index, Value_I_Gas, wff3);
		            sheet.addCell(labe2);        
		            labe2 = new Label(5, D_Index, Value_R, wff3);
		            sheet.addCell(labe2);
		            labe2 = new Label(6, D_Index, Value_R_Gas, wff3);
		            sheet.addCell(labe2);
		            labe2 = new Label(7, D_Index, Value_PAL, wff3);
		            sheet.addCell(labe2);
		            labe2 = new Label(8, D_Index, Value_PAL_Gas, wff3);
		            sheet.addCell(labe2);
				}
			}
			D_Index++;
			sheet.setRowView(D_Index, 600);
			sheet.setColumnView(D_Index, 20);
			Label labe3 = new Label(0, D_Index, "�����ۼ�", wff2);
            sheet.addCell(labe3);
            labe3 = new Label(1, D_Index, (new BigDecimal(Value_O_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
            sheet.addCell(labe3);
            labe3 = new Label(2, D_Index, (new BigDecimal(Value_O_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
            sheet.addCell(labe3);
            labe3 = new Label(3, D_Index, (new BigDecimal(Value_I_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
            sheet.addCell(labe3);
            labe3 = new Label(4, D_Index, (new BigDecimal(Value_I_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
            sheet.addCell(labe3);
            labe3 = new Label(5, D_Index, (new BigDecimal(Value_R_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
            sheet.addCell(labe3);
            labe3 = new Label(6, D_Index, (new BigDecimal(Value_R_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
            sheet.addCell(labe3);
            labe3 = new Label(7, D_Index, (new BigDecimal(Value_PAL_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
            sheet.addCell(labe3);
            labe3 = new Label(8, D_Index, (new BigDecimal(Value_PAL_Gas_All).divide(new BigDecimal(1),2,java.math.RoundingMode.HALF_UP))+"", wff2);
            sheet.addCell(labe3);
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
	
		}catch(Exception ex)
		{
			ex.printStackTrace();
		}
		
		
	}
	
	//ͼ�����
	public void Pro_G(HttpServletRequest request, HttpServletResponse response, Rmi pRmi, boolean pFromZone) 
	{
		try
		{
			getHtmlData(request);
			currStatus = (CurrStatus)request.getSession().getAttribute("CurrStatus_" + Sid);
			currStatus.getHtmlData(request, pFromZone);
			
			TimeAll = "";
			switch(currStatus.getFunc_Sel_Id())
			{
				case 0://�������
					request.getSession().setAttribute("BYear_" + Sid, BYear);
			    	request.getSession().setAttribute("EYear_" + Sid, EYear);
			    	for(int i=0; i<(Integer.parseInt(EYear) - Integer.parseInt(BYear) + 1); i++)
			    	{
			    		TimeAll += (Integer.parseInt(BYear) + i)
			    		         + ","
			    				 + (Integer.parseInt(BYear) + i) + "-01-01"
			    				 + ","
			    				 + (Integer.parseInt(BYear) + i) + "-12-31"
			    				 + ";";
			    	}
					break;
			    case 1://���·���
			    	request.getSession().setAttribute("BYear_" + Sid, BYear);
			    	request.getSession().setAttribute("BMonth_" + Sid, BMonth);
			    	request.getSession().setAttribute("EYear_" + Sid, EYear);
			    	request.getSession().setAttribute("EMonth_" + Sid, EMonth);
					Calendar c_BMonth = new GregorianCalendar();
					Calendar c_EMonth = new GregorianCalendar();
					c_BMonth.set(Integer.parseInt(BYear), Integer.parseInt(BMonth)-1, 1);
					c_EMonth.set(Integer.parseInt(EYear), Integer.parseInt(EMonth), 1);
					while (c_BMonth.before(c_EMonth))
					{
						int y = c_BMonth.get(Calendar.YEAR);
						int m = c_BMonth.get(Calendar.MONTH) + 1;
						c_BMonth.add(Calendar.MONTH, 1);
						TimeAll += CommUtil.IntToStringLeftFillZero(y, 4) + CommUtil.IntToStringLeftFillZero(m, 2)
						         + ","
							     + CommUtil.IntToStringLeftFillZero(y, 4) + "-" + CommUtil.IntToStringLeftFillZero(m, 2) + "-01"
			    				 + ","
			    				 + CommUtil.IntToStringLeftFillZero(y, 4) + "-" + CommUtil.IntToStringLeftFillZero(m, 2) + "-31"
			    				 + ";";
					}
			    	break;
			    case 2://���ܷ���
			    	request.getSession().setAttribute("BYear_" + Sid, BYear);
			    	request.getSession().setAttribute("BMonth_" + Sid, BMonth);
			    	request.getSession().setAttribute("BWeek_" + Sid, BWeek);
			    	request.getSession().setAttribute("EYear_" + Sid, EYear);
			    	request.getSession().setAttribute("EMonth_" + Sid, EMonth);
			    	request.getSession().setAttribute("EWeek_" + Sid, EWeek);
			    	Calendar w_BMonth = new GregorianCalendar();
					Calendar w_EMonth = new GregorianCalendar();
					w_BMonth.set(Integer.parseInt(BYear), Integer.parseInt(BMonth)-1, 1);
					w_EMonth.set(Integer.parseInt(EYear), Integer.parseInt(EMonth), 1);
					while (w_BMonth.before(w_EMonth))
					{
						int y = w_BMonth.get(Calendar.YEAR);
						int m = w_BMonth.get(Calendar.MONTH) + 1;
						w_BMonth.add(Calendar.MONTH, 1);
						
						int i = 1;
						int j = 5;
						if(Integer.parseInt(BYear) == Integer.parseInt(EYear) && Integer.parseInt(BMonth) == Integer.parseInt(EMonth) && y == Integer.parseInt(BYear) && m == Integer.parseInt(BMonth))
						{
							//System.out.println("11111111111111111111");
							i = Integer.parseInt(BWeek);
							j = Integer.parseInt(EWeek);						
						}
						else if((Integer.parseInt(BYear) != Integer.parseInt(EYear) || Integer.parseInt(BMonth) != Integer.parseInt(EMonth)) && y == Integer.parseInt(BYear) && m == Integer.parseInt(BMonth))
						{
							//System.out.println("22222222222222222222");
							i = Integer.parseInt(BWeek);
							j = 5;
						}
						else if((Integer.parseInt(BYear) != Integer.parseInt(EYear) || Integer.parseInt(BMonth) != Integer.parseInt(EMonth)) && y == Integer.parseInt(EYear) && m == Integer.parseInt(EMonth))
						{
							//System.out.println("33333333333333333333");
							i = 1;
							j = Integer.parseInt(EWeek);
						}
						else
						{
							//System.out.println("44444444444444444444");
							i = 1;
							j = 5;
						}
						for(; i<=j; i++)
						{
							String pBTime = "";
							String pETime = "";
							switch(Integer.parseInt(CommUtil.getWeekDayString(CommUtil.IntToStringLeftFillZero(y, 4) + "-" + CommUtil.IntToStringLeftFillZero(m, 2) + "-01")))
							{
								case 0://������
									pBTime = CommUtil.getDateAfter(CommUtil.IntToStringLeftFillZero(y, 4) + "-" + CommUtil.IntToStringLeftFillZero(m, 2) + "-01 00:00:00", (i-1)*7);
									pETime = CommUtil.getDateAfter(CommUtil.IntToStringLeftFillZero(y, 4) + "-" + CommUtil.IntToStringLeftFillZero(m, 2) + "-01 00:00:00", i*7-1);
									break;
								case 1://����һ
									pBTime = CommUtil.getDateAfter(CommUtil.IntToStringLeftFillZero(y, 4) + "-" + CommUtil.IntToStringLeftFillZero(m, 2) + "-07 00:00:00", (i-1)*7);
									pETime = CommUtil.getDateAfter(CommUtil.IntToStringLeftFillZero(y, 4) + "-" + CommUtil.IntToStringLeftFillZero(m, 2) + "-07 00:00:00", i*7-1);
									break;
								case 2://���ڶ�
									pBTime = CommUtil.getDateAfter(CommUtil.IntToStringLeftFillZero(y, 4) + "-" + CommUtil.IntToStringLeftFillZero(m, 2) + "-06 00:00:00", (i-1)*7);
									pETime = CommUtil.getDateAfter(CommUtil.IntToStringLeftFillZero(y, 4) + "-" + CommUtil.IntToStringLeftFillZero(m, 2) + "-06 00:00:00", i*7-1);
									break;
								case 3://������
									pBTime = CommUtil.getDateAfter(CommUtil.IntToStringLeftFillZero(y, 4) + "-" + CommUtil.IntToStringLeftFillZero(m, 2) + "-05 00:00:00", (i-1)*7);
									pETime = CommUtil.getDateAfter(CommUtil.IntToStringLeftFillZero(y, 4) + "-" + CommUtil.IntToStringLeftFillZero(m, 2) + "-05 00:00:00", i*7-1);
									break;
								case 4://������
									pBTime = CommUtil.getDateAfter(CommUtil.IntToStringLeftFillZero(y, 4) + "-" + CommUtil.IntToStringLeftFillZero(m, 2) + "-04 00:00:00", (i-1)*7);
									pETime = CommUtil.getDateAfter(CommUtil.IntToStringLeftFillZero(y, 4) + "-" + CommUtil.IntToStringLeftFillZero(m, 2) + "-04 00:00:00", i*7-1);
									break;
								case 5://������
									pBTime = CommUtil.getDateAfter(CommUtil.IntToStringLeftFillZero(y, 4) + "-" + CommUtil.IntToStringLeftFillZero(m, 2) + "-03 00:00:00", (i-1)*7);
									pETime = CommUtil.getDateAfter(CommUtil.IntToStringLeftFillZero(y, 4) + "-" + CommUtil.IntToStringLeftFillZero(m, 2) + "-03 00:00:00", i*7-1);
									break;
								case 6://������
									pBTime = CommUtil.getDateAfter(CommUtil.IntToStringLeftFillZero(y, 4) + "-" + CommUtil.IntToStringLeftFillZero(m, 2) + "-02 00:00:00", (i-1)*7);
									pETime = CommUtil.getDateAfter(CommUtil.IntToStringLeftFillZero(y, 4) + "-" + CommUtil.IntToStringLeftFillZero(m, 2) + "-02 00:00:00", i*7-1);
									break;
							}
							//�ж�pBTime�Ƿ��ڱ�����
							if(Integer.parseInt(pBTime.substring(5,7)) == m)
							{
								pBTime = pBTime.substring(0,10);
								pETime = pETime.substring(0,10);
								TimeAll += CommUtil.IntToStringLeftFillZero(y, 4) + CommUtil.IntToStringLeftFillZero(m, 2) + "��" + i + "��"
									     + ","
									     + pBTime 
									     + "," 
									     + pETime 
									     + ";";
							}
						}
					}
			    	break;
			    case 3://���շ���
			    	request.getSession().setAttribute("BDate_" + Sid, BDate);
			    	request.getSession().setAttribute("EDate_" + Sid, EDate);
			    	SimpleDateFormat SimFormat = new SimpleDateFormat("yyyy-MM-dd");
					Calendar B_Date = new GregorianCalendar();
					Calendar E_Date = new GregorianCalendar();
					B_Date.setTime(SimFormat.parse(BDate));
					E_Date.setTime(SimFormat.parse(EDate));
					Calendar temp = (Calendar)B_Date.clone();
					temp.add(Calendar.DAY_OF_YEAR, 0);
					while (temp.before(E_Date) || temp.equals(E_Date))
					{
						TimeAll += SimFormat.format(temp.getTime())
						         + ","
							     + SimFormat.format(temp.getTime())
				 		 		 + ","
				 		 		 + SimFormat.format(temp.getTime())
				 		 		 + ";";
						temp.add(Calendar.DAY_OF_YEAR, 1);
					}
			    	break;
			}
			
			System.out.println("TimeAll:" + TimeAll);
			
			msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);
			switch(currStatus.getCmd())
			{
				case 20://ͼ�����
			    	request.getSession().setAttribute("Pro_G_" + Sid, (Object)msgBean.getMsg());
					currStatus.setJsp("Pro_G.jsp?Sid=" + Sid);
					
					//����ҵ��
			    	ProRBean RBean = new ProRBean();
			    	msgBean = pRmi.RmiExec(2, RBean, 0);
			    	request.getSession().setAttribute("Pro_R_Type_" + Sid, ((Object)msgBean.getMsg()));
					break;
			}
			
			request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		   	response.sendRedirect(currStatus.getJsp());
		}
		catch(Exception Ex)
		{
			Ex.printStackTrace();
		}
	}
	
	public String getSql(int pCmd)
	{
		String Sql = "";
		switch (pCmd) 
		{			
			case 0://�±�-ÿ����ϸ
				Sql = " select t.cpm_id, t.cpm_name, t.ctime, t.value_i, t.value_i_gas, t.value_i_cnt, t.value_o, t.value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, t.value_pal, t.value_pal_gas  " +
					  " from view_pro_l t " +
					  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
					  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
					  "   and t.ctime >= '"+currStatus.getVecDate().get(0).toString().substring(0,10)+"' " +
					  "   and t.ctime <= '"+currStatus.getVecDate().get(1).toString().substring(0,10)+"' " +
					  "   order by t.cpm_id, t.ctime asc ";
				break;
			case 1://�±�-�����ۼ�
				Sql = " select t.cpm_id, t.cpm_name, '' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, '' as cpm_ctime, '' as cpm_ctype , ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
				  	  " from view_pro_l t " +
				      " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
				      "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
				      "   and substr(t.ctime, 1, 4) = '"+ currStatus.getVecDate().get(0).toString().substring(0,4) +"' " +
				      "   and t.ctime <= '"+currStatus.getVecDate().get(1).toString().substring(0,10)+"' " +
				      "   group by t.cpm_id, t.cpm_name " +
				      "   order by t.cpm_id ";
				break;
			case 2://������
				Sql = " select t.cpm_id, t.cpm_name, '' as ctime, '' as value_i, '' as value_i_gas, '' as value_i_cnt, '' as value_o, '' as value_o_gas, '' AS value_r, t.unq_flag AS value_r_gas, t.unq_str AS cpm_ctime, t.car_more AS cpm_ctype " +
				  	  " from view_pro_o t " +
				      " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
				      "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
				      "   and t.status = '0' " +
				      "   and t.ctime >= '"+currStatus.getVecDate().get(0).toString().substring(0,10) + " 08:30:00" +"' " +
				      "   and t.ctime <= '"+CommUtil.getNextStrDate(currStatus.getVecDate().get(1).toString().substring(0,10)) + " 08:30:00" +"' " +
				      "   group by t.cpm_id, t.cpm_name, t.unq_flag, t.unq_str, t.car_more " +
				      "   order by t.cpm_id ";
				break;
			case 3://�ܱ�-ÿ����ϸ
				Sql = " select t.cpm_id, t.cpm_name, t.ctime, t.value_i, t.value_i_gas, t.value_i_cnt, t.value_o, t.value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, t.value_pal, t.value_pal_gas " +
				  	  " from view_pro_l t " +
				  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
				  	  "   and t.oil_ctype = '"+ currStatus.getFunc_Corp_Id() +"' " +
				  	  "   and t.ctime >= '"+currStatus.getVecDate().get(0).toString().substring(0,10)+"' " +
				  	  "   and t.ctime <= '"+currStatus.getVecDate().get(1).toString().substring(0,10)+"' " +
				  	  "   order by t.cpm_id, t.ctime asc ";
				break;
			case 4://�ձ�-ĳ��ͳ��
				Sql = " select t.cpm_id, t.cpm_name, t.ctime, t.value_i, t.value_i_gas, t.value_i_cnt, t.value_o, t.value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, t.value_pal, t.value_pal_gas" +
				  	  " from view_pro_l t " +
			  	  	  " where instr('"+ Cpm_Id +"', t.cpm_id) > 0 " +
			  	  	  " and t.oil_ctype like '"+ currStatus.getFunc_Corp_Id() +"%'" +
			  	  	  " and t.ctime = '"+currStatus.getVecDate().get(0).toString().substring(0,10)+"' " +
			  	  	  " order by t.cpm_id ";
				break;
			case 5: //��˾�걨��   ����,������ÿ����ϸ
				Sql = " select t.cpm_id, t.cpm_name, '"+ Year +"01' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from ( select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0 and a.oil_ctype= '"+ currStatus.getFunc_Corp_Id() +"' and a.ctime >= '"+Year+"-01-01' and a.ctime <= '"+Year+"-01-31' ORDER BY a.ctime DESC ) t " +		  	  	  	  
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"02' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from ( select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0 and a.oil_ctype= '"+ currStatus.getFunc_Corp_Id() +"' and a.ctime >= '"+Year+"-02-01' and a.ctime <= '"+Year+"-02-31' ORDER BY a.ctime DESC ) t " +	
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"03' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from ( select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0 and a.oil_ctype= '"+ currStatus.getFunc_Corp_Id() +"' and a.ctime >= '"+Year+"-03-01' and a.ctime <= '"+Year+"-03-31' ORDER BY a.ctime DESC ) t " +	
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"04' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from ( select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0 and a.oil_ctype= '"+ currStatus.getFunc_Corp_Id() +"' and a.ctime >= '"+Year+"-04-01' and a.ctime <= '"+Year+"-04-31' ORDER BY a.ctime DESC ) t " +	
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"05' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from ( select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0 and a.oil_ctype= '"+ currStatus.getFunc_Corp_Id() +"' and a.ctime >= '"+Year+"-05-01' and a.ctime <= '"+Year+"-05-31' ORDER BY a.ctime DESC ) t " +	
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"06' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from ( select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0 and a.oil_ctype= '"+ currStatus.getFunc_Corp_Id() +"' and a.ctime >= '"+Year+"-06-01' and a.ctime <= '"+Year+"-06-31' ORDER BY a.ctime DESC ) t " +	
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"07' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from ( select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0 and a.oil_ctype= '"+ currStatus.getFunc_Corp_Id() +"' and a.ctime >= '"+Year+"-07-01' and a.ctime <= '"+Year+"-07-31' ORDER BY a.ctime DESC ) t " +	
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"08' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from ( select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0 and a.oil_ctype= '"+ currStatus.getFunc_Corp_Id() +"' and a.ctime >= '"+Year+"-08-01' and a.ctime <= '"+Year+"-08-31' ORDER BY a.ctime DESC ) t " +	
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"09' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from ( select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0 and a.oil_ctype= '"+ currStatus.getFunc_Corp_Id() +"' and a.ctime >= '"+Year+"-09-01' and a.ctime <= '"+Year+"-09-31' ORDER BY a.ctime DESC ) t " +	
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"10' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from ( select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0 and a.oil_ctype= '"+ currStatus.getFunc_Corp_Id() +"' and a.ctime >= '"+Year+"-10-01' and a.ctime <= '"+Year+"-10-31' ORDER BY a.ctime DESC ) t " +	
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"11' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from ( select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0 and a.oil_ctype= '"+ currStatus.getFunc_Corp_Id() +"' and a.ctime >= '"+Year+"-11-01' and a.ctime <= '"+Year+"-11-31' ORDER BY a.ctime DESC ) t " +	
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"12' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from ( select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0 and a.oil_ctype= '"+ currStatus.getFunc_Corp_Id() +"' and a.ctime >= '"+Year+"-12-01' and a.ctime <= '"+Year+"-12-31' ORDER BY a.ctime DESC ) t " +	
			  	  	  ")" +
			  	  	  "order by ctime";
				break;
			case 6: //�걨��  
				Sql = " select t.cpm_id, t.cpm_name, '"+ Year +"01' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from (select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0  and a.oil_ctype = '"+ Func_Corp_Id +"' and a.ctime >= '"+Year+"-01-01' and a.ctime <= '"+Year+"-01-31' order by a.ctime desc )  t " +			  	  	  
			  	  	  " group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"02' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from (select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0  and a.oil_ctype = '"+ Func_Corp_Id +"' and a.ctime >= '"+Year+"-02-01' and a.ctime <= '"+Year+"-02-31' order by a.ctime desc )  t " +			  	  	  
			  	  	  " group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"03' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from (select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0  and a.oil_ctype = '"+ Func_Corp_Id +"' and a.ctime >= '"+Year+"-03-01' and a.ctime <= '"+Year+"-03-31' order by a.ctime desc )  t " +			  	  	  
			  	  	  " group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"04' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from (select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0  and a.oil_ctype = '"+ Func_Corp_Id +"' and a.ctime >= '"+Year+"-04-01' and a.ctime <= '"+Year+"-04-31' order by a.ctime desc )  t " +			  	  	  
			  	  	  " group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"05' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from (select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0  and a.oil_ctype = '"+ Func_Corp_Id +"' and a.ctime >= '"+Year+"-05-01' and a.ctime <= '"+Year+"-05-31' order by a.ctime desc )  t " +			  	  	  
			  	  	  " group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"06' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from (select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0  and a.oil_ctype = '"+ Func_Corp_Id +"' and a.ctime >= '"+Year+"-06-01' and a.ctime <= '"+Year+"-06-31' order by a.ctime desc )  t " +			  	  	  
			  	  	  " group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"07' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from (select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0  and a.oil_ctype = '"+ Func_Corp_Id +"' and a.ctime >= '"+Year+"-07-01' and a.ctime <= '"+Year+"-07-31' order by a.ctime desc )  t " +			  	  	  
			  	  	  " group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"08' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from (select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0  and a.oil_ctype = '"+ Func_Corp_Id +"' and a.ctime >= '"+Year+"-08-01' and a.ctime <= '"+Year+"-08-31' order by a.ctime desc )  t " +			  	  	  
			  	  	  " group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"09' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from (select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0  and a.oil_ctype = '"+ Func_Corp_Id +"' and a.ctime >= '"+Year+"-09-01' and a.ctime <= '"+Year+"-09-31' order by a.ctime desc )  t " +			  	  	  
			  	  	  " group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"10' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from (select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0  and a.oil_ctype = '"+ Func_Corp_Id +"' and a.ctime >= '"+Year+"-10-01' and a.ctime <= '"+Year+"-10-31' order by a.ctime desc )  t " +			  	  	  
			  	  	  " group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"11' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from (select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0  and a.oil_ctype = '"+ Func_Corp_Id +"' and a.ctime >= '"+Year+"-11-01' and a.ctime <= '"+Year+"-11-31' order by a.ctime desc )  t " +			  	  	  
			  	  	  " group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "UNION" +
			  	  	  "(" +
			  	  	" select t.cpm_id, t.cpm_name, '"+ Year +"12' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, t.value_r, t.value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
		  	  	  	  " from (select * from view_pro_l a where instr('"+ Cpm_Id +"', a.cpm_id) > 0  and a.oil_ctype = '"+ Func_Corp_Id +"' and a.ctime >= '"+Year+"-12-01' and a.ctime <= '"+Year+"-12-31' order by a.ctime desc )  t " +			  	  	  
			  	  	  " group by t.cpm_id, t.cpm_name, t.cpm_ctime, t.cpm_ctype " +
			  	  	  ")" +
			  	  	  "order by cpm_id,ctime";
				break;
				
			case 7://��˾��������ͳ�����ۣ��������ݲ�ѯ
				Sql = " select t.cpm_id, t.cpm_name, '"+ Year +"01' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
			  	  	  " from view_pro_l t " +
				  	  " where t.oil_ctype = '"+ Func_Corp_Id +"' " +
				  	  " and t.ctime >= '"+Year+"-01-01' " +
				  	  " and t.ctime <= '"+Year+"-01-31' " +
				  	  "UNION" +
				  	  	  "(" +
				  	  	  " select t.cpm_id, t.cpm_name, '"+ Year +"02' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
				  	  	  " from view_pro_l t " +
				  	  	  " where t.oil_ctype = '"+ Func_Corp_Id +"' " +
				  	  	  " and t.ctime >= '"+Year+"-02-01' " +
				  	  	  " and t.ctime <= '"+Year+"-02-31' " +
				  	  	  ")" +
				  	  	  "UNION" +
				  	  	  "(" +
				  	  	  " select t.cpm_id, t.cpm_name, '"+ Year +"03' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
				  	  	  " from view_pro_l t " +
				  	  	  " where t.oil_ctype = '"+ Func_Corp_Id +"' " +
				  	  	  " and t.ctime >= '"+Year+"-03-01' " +
				  	  	  " and t.ctime <= '"+Year+"-03-31' " +
				  	  	  ")" +
				  	  	  "UNION" +
				  	  	  "(" +
				  	  	  " select t.cpm_id, t.cpm_name, '"+ Year +"04' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
				  	  	  " from view_pro_l t " +
				  	  	  " where t.oil_ctype = '"+ Func_Corp_Id +"' " +
				  	  	  " and t.ctime >= '"+Year+"-04-01' " +
				  	  	  " and t.ctime <= '"+Year+"-04-31' " +
				  	  	  ")" +
				  	  	  "UNION" +
				  	  	  "(" +
				  	  	  " select t.cpm_id, t.cpm_name, '"+ Year +"05' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
				  	  	  " from view_pro_l t " +
				  	  	  " where t.oil_ctype = '"+ Func_Corp_Id +"' " +
				  	  	  " and t.ctime >= '"+Year+"-05-01' " +
				  	  	  " and t.ctime <= '"+Year+"-05-31' " +
				  	  	  ")" +
				  	  	  "UNION" +
				  	  	  "(" +
				  	  	  " select t.cpm_id, t.cpm_name, '"+ Year +"06' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
				  	  	  " from view_pro_l t " +
				  	  	  " where t.oil_ctype = '"+ Func_Corp_Id +"' " +
				  	  	  " and t.ctime >= '"+Year+"-06-01' " +
				  	  	  " and t.ctime <= '"+Year+"-06-31' " +
				  	  	  ")" +
				  	  	  "UNION" +
				  	  	  "(" +
				  	  	  " select t.cpm_id, t.cpm_name, '"+ Year +"07' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
				  	  	  " from view_pro_l t " +
				  	  	  " where t.oil_ctype = '"+ Func_Corp_Id +"' " +
				  	  	  " and t.ctime >= '"+Year+"-07-01' " +
				  	  	  " and t.ctime <= '"+Year+"-07-31' " +
				  	  	  ")" +
				  	  	  "UNION" +
				  	  	  "(" +
				  	  	  " select t.cpm_id, t.cpm_name, '"+ Year +"08' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
				  	  	  " from view_pro_l t " +
				  	  	  " where t.oil_ctype = '"+ Func_Corp_Id +"' " +
				  	  	  " and t.ctime >= '"+Year+"-08-01' " +
				  	  	  " and t.ctime <= '"+Year+"-08-31' " +
				  	  	  ")" +
				  	  	  "UNION" +
				  	  	  "(" +
				  	  	  " select t.cpm_id, t.cpm_name, '"+ Year +"09' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
				  	  	  " from view_pro_l t " +
				  	  	  " where t.oil_ctype = '"+ Func_Corp_Id +"' " +
				  	  	  " and t.ctime >= '"+Year+"-09-01' " +
				  	  	  " and t.ctime <= '"+Year+"-09-31' " +
				  	  	  ")" +
				  	  	  "UNION" +
				  	  	  "(" +
				  	  	  " select t.cpm_id, t.cpm_name, '"+ Year +"10' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
				  	  	  " from view_pro_l t " +
				  	  	  " where t.oil_ctype = '"+ Func_Corp_Id +"' " +
				  	  	  " and t.ctime >= '"+Year+"-10-01' " +
				  	  	  " and t.ctime <= '"+Year+"-10-31' " +
				  	  	  ")" +
				  	  	  "UNION" +
				  	  	  "(" +
				  	  	  " select t.cpm_id, t.cpm_name, '"+ Year +"11' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
				  	  	  " from view_pro_l t " +
				  	  	  " where t.oil_ctype = '"+ Func_Corp_Id +"' " +
				  	  	  " and t.ctime >= '"+Year+"-11-01' " +
				  	  	  " and t.ctime <= '"+Year+"-11-31' " +
				  	  	  ")" +
				  	  	  "UNION" +
				  	  	  "(" +
				  	  	  " select t.cpm_id, t.cpm_name, '"+ Year +"12' as ctime, ROUND(SUM(t.value_i),2) AS value_i, ROUND(SUM(t.value_i_gas),2) AS value_i_gas, sum(t.value_i_cnt) as value_i_cnt, ROUND(SUM(t.value_o),2) AS value_o, ROUND(SUM(t.value_o_gas),2) AS value_o_gas, ROUND(SUM(t.value_r),2) AS value_r, ROUND(SUM(t.value_r_gas),2) AS value_r_gas, t.cpm_ctime, t.cpm_ctype, ROUND(SUM(t.value_pal),2) AS value_pal, ROUND(SUM(t.value_pal_gas),2) AS value_pal_gas " +
				  	  	  " from view_pro_l t " +
				  	  	  " where t.oil_ctype = '"+ Func_Corp_Id +"' " +
				  	  	  " and t.ctime >= '"+Year+"-12-01' " +
				  	  	  " and t.ctime <= '"+Year+"-12-31' " +
				  	  	  ")" +
				  	  	  "order by ctime";
			break;			
		
			
			
			case 10:				
				Sql = " update pro_l t set t.value_r = '"+ Value_R +"', t.value_r_gas = '"+ Value_R_Gas +"' where t.cpm_id = '"+ Cpm_Id +"' and t.oil_ctype = '"+  currStatus.getFunc_Corp_Id() +"'  and t.ctime = '"+ CTime +"' ";			
			break;
			case 11:				
				Sql = " update pro_l t set t.value_pal = '"+ Value_PAL +"', t.value_pal_gas = '"+ Value_PAL_Gas +"' where t.cpm_id = '"+ Cpm_Id +"' and t.oil_ctype = '"+  currStatus.getFunc_Corp_Id() +"'  and t.ctime = '"+ CTime +"' ";			
			break;
			
			case 20://ͼ�����
				Sql = " {? = call rmi_pro_graph('"+ currStatus.getFunc_Corp_Id() +"', '"+ currStatus.getFunc_Sub_Id() +"', '"+ currStatus.getFunc_Sel_Id() +"', '"+ Cpm_Id +"', '"+ TimeAll +"')}";
				break;
			case 21://ͳ�Ƶ�������
				Sql = " {? = call Func_Pro_Today()}";
				break;
		}
		return Sql;
	}
	
	public boolean getData(ResultSet pRs) 
	{
		boolean IsOK = true;
		try
		{
			setCpm_Id(pRs.getString(1));
			setCpm_Name(pRs.getString(2));
			setCTime(pRs.getString(3));
			setValue_I(pRs.getString(4));
			setValue_I_Gas(pRs.getString(5));
			setValue_I_Cnt(pRs.getString(6));
			setValue_O(pRs.getString(7));
			setValue_O_Gas(pRs.getString(8));
			setValue_R(pRs.getString(9));
			setValue_R_Gas(pRs.getString(10));
			setCpm_CTime(pRs.getString(11));
			setCpm_CType(pRs.getString(12));
			setValue_PAL(pRs.getString(13));
			setValue_PAL_Gas(pRs.getString(14));
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
			setCpm_Id(CommUtil.StrToGB2312(request.getParameter("Cpm_Id")));
			setCpm_Name(CommUtil.StrToGB2312(request.getParameter("Cpm_Name")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setValue_I(CommUtil.StrToGB2312(request.getParameter("Value_I")));
			setValue_I_Gas(CommUtil.StrToGB2312(request.getParameter("Value_I_Gas")));
			setValue_I_Cnt(CommUtil.StrToGB2312(request.getParameter("Value_I_Cnt")));
			setValue_O(CommUtil.StrToGB2312(request.getParameter("Value_O")));
			setValue_O_Gas(CommUtil.StrToGB2312(request.getParameter("Value_O_Gas")));
			setValue_R(CommUtil.StrToGB2312(request.getParameter("Value_R")));
			setValue_R_Gas(CommUtil.StrToGB2312(request.getParameter("Value_R_Gas")));
			setValue_PAL(CommUtil.StrToGB2312(request.getParameter("Value_PAL")));
			setValue_PAL_Gas(CommUtil.StrToGB2312(request.getParameter("Value_PAL_Gas")));
			setCpm_CTime(CommUtil.StrToGB2312(request.getParameter("Cpm_CTime")));
			setCpm_CType(CommUtil.StrToGB2312(request.getParameter("Cpm_CType")));
			
			setYear(CommUtil.StrToGB2312(request.getParameter("Year")));
			setMonth(CommUtil.StrToGB2312(request.getParameter("Month")));
			setWeek(CommUtil.StrToGB2312(request.getParameter("Week")));
			setOperator_Name(CommUtil.StrToGB2312(request.getParameter("Operator_Name")));
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
			
			setBYear(CommUtil.StrToGB2312(request.getParameter("BYear")));
			setBMonth(CommUtil.StrToGB2312(request.getParameter("BMonth")));
			setEYear(CommUtil.StrToGB2312(request.getParameter("EYear")));
			setEMonth(CommUtil.StrToGB2312(request.getParameter("EMonth")));
			setBWeek(CommUtil.StrToGB2312(request.getParameter("BWeek")));
			setEWeek(CommUtil.StrToGB2312(request.getParameter("EWeek")));
			setBDate(CommUtil.StrToGB2312(request.getParameter("BDate")));
			setEDate(CommUtil.StrToGB2312(request.getParameter("EDate")));
			setValue_PLR(CommUtil.StrToGB2312(request.getParameter("Value_PLR")));
			
			
		}
		catch (Exception Exp)
		{
			Exp.printStackTrace();
		}
		return IsOK;
	}
	
	private String Cpm_Id;
	private String Cpm_Name;
	private String CTime;
	private String Value_I;
	private String Value_I_Gas;
	private String Value_I_Cnt;
	private String Value_O;
	private String Value_O_Gas;
	private String Value_R;
	private String Value_R_Gas;
	private String Value_PAL;
	private String Value_PAL_Gas;
	private String Cpm_CTime;
	private String Cpm_CType;
	private String Value_PLR;
	
	
	private String Year;
	private String Month;
	private String Week;
	private String Operator_Name;
	private String Sid;
		
	private String Func_Corp_Id;
	
	//ͼ�����
	String BYear   = "";
	String BMonth  = "";
	String EYear   = "";
	String EMonth  = "";
	String BWeek   = "";
	String EWeek   = "";
	String BDate   = "";
	String EDate   = "";
	String TimeAll = "";
	
	

	public String getValue_PAL() {
		return Value_PAL;
	}

	public void setValue_PAL(String value_PAL) {
		Value_PAL = value_PAL;
	}

	public String getValue_PAL_Gas() {
		return Value_PAL_Gas;
	}

	public void setValue_PAL_Gas(String value_PAL_Gas) {
		Value_PAL_Gas = value_PAL_Gas;
	}

	public String getValue_PLR() {
		return Value_PLR;
	}

	public void setValue_PLR(String value_PLR) {
		Value_PLR = value_PLR;
	}

	public String getFunc_Corp_Id() {
		return Func_Corp_Id;
	}

	public void setFunc_Corp_Id(String func_Corp_Id) {
		Func_Corp_Id = func_Corp_Id;
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

	public String getCTime() {
		return CTime;
	}

	public void setCTime(String cTime) {
		CTime = cTime;
	}

	public String getValue_I() {
		return Value_I;
	}

	public void setValue_I(String valueI) {
		Value_I = valueI;
	}

	public String getValue_I_Gas() {
		return Value_I_Gas;
	}

	public void setValue_I_Gas(String valueIGas) {
		Value_I_Gas = valueIGas;
	}
	
	public String getValue_I_Cnt() {
		return Value_I_Cnt;
	}

	public void setValue_I_Cnt(String valueICnt) {
		Value_I_Cnt = valueICnt;
	}

	public String getValue_O() {
		return Value_O;
	}

	public void setValue_O(String valueO) {
		Value_O = valueO;
	}

	public String getValue_O_Gas() {
		return Value_O_Gas;
	}

	public void setValue_O_Gas(String valueOGas) {
		Value_O_Gas = valueOGas;
	}

	public String getValue_R() {
		return Value_R;
	}

	public void setValue_R(String valueR) {
		Value_R = valueR;
	}

	public String getValue_R_Gas() {
		return Value_R_Gas;
	}

	public void setValue_R_Gas(String valueRGas) {
		Value_R_Gas = valueRGas;
	}
	
	public String getCpm_CTime() {
		return Cpm_CTime;
	}

	public void setCpm_CTime(String cpmCTime) {
		Cpm_CTime = cpmCTime;
	}

	public String getCpm_CType() {
		return Cpm_CType;
	}

	public void setCpm_CType(String cpmCType) {
		Cpm_CType = cpmCType;
	}

	public String getYear() {
		return Year;
	}

	public void setYear(String year) {
		Year = year;
	}

	public String getMonth() {
		return Month;
	}

	public void setMonth(String month) {
		Month = month;
	}

	public String getWeek() {
		return Week;
	}

	public void setWeek(String week) {
		Week = week;
	}

	public String getOperator_Name() {
		return Operator_Name;
	}

	public void setOperator_Name(String operatorName) {
		Operator_Name = operatorName;
	}

	public String getSid() {
		return Sid;
	}

	public void setSid(String sid) {
		Sid = sid;
	}

	public String getBYear() {
		return BYear;
	}

	public void setBYear(String bYear) {
		BYear = bYear;
	}

	public String getBMonth() {
		return BMonth;
	}

	public void setBMonth(String bMonth) {
		BMonth = bMonth;
	}

	public String getEYear() {
		return EYear;
	}

	public void setEYear(String eYear) {
		EYear = eYear;
	}

	public String getEMonth() {
		return EMonth;
	}

	public void setEMonth(String eMonth) {
		EMonth = eMonth;
	}

	public String getBWeek() {
		return BWeek;
	}

	public void setBWeek(String bWeek) {
		BWeek = bWeek;
	}

	public String getEWeek() {
		return EWeek;
	}

	public void setEWeek(String eWeek) {
		EWeek = eWeek;
	}

	public String getBDate() {
		return BDate;
	}

	public void setBDate(String bDate) {
		BDate = bDate;
	}

	public String getEDate() {
		return EDate;
	}

	public void setEDate(String eDate) {
		EDate = eDate;
	}

	public String getTimeAll() {
		return TimeAll;
	}

	public void setTimeAll(String timeAll) {
		TimeAll = timeAll;
	}
}