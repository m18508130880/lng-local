package bean;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

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

public class ProOBean extends RmiBean {
	public final static long serialVersionUID = RmiBean.RMI_PRO_O;

	public long getClassId() {
		return serialVersionUID;
	}

	public ProOBean() {
		super.className = "ProOBean";
	}

	public void ExecCmd(HttpServletRequest request,
			HttpServletResponse response, Rmi pRmi, boolean pFromZone)
			throws ServletException, IOException {
		getHtmlData(request);
		currStatus = (CurrStatus) request.getSession().getAttribute(
				"CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);

		// ����
		Func_Corp_Id = currStatus.getFunc_Corp_Id();
		if (null == Func_Corp_Id || Func_Corp_Id.equals("9999")) {
			Func_Corp_Id = "";
		}

		// ״̬
		Func_Sub_Id = currStatus.getFunc_Sub_Id() + "";
		if (Func_Sub_Id.equals("9")) {
			Func_Sub_Id = "";
		}

		// ����
		Func_Type_Id = currStatus.getFunc_Type_Id();
		if (null == Func_Type_Id) {
			Func_Type_Id = "";
		}

		switch (currStatus.getCmd()) {
		case 13:// ɾ��
		case 12: // �޸�
		case 11:// �༭
			currStatus.setResult(MsgBean.GetResult(msgBean.getStatus()));
			msgBean = pRmi.RmiExec(currStatus.getCmd(), this,currStatus.getCurrPage());
			// msgBean = pRmi.RmiExec(0, this, currStatus.getCurrPage());
		case 0:// ��ѯ
			msgBean = pRmi.RmiExec(0, this, currStatus.getCurrPage());
			request.getSession().setAttribute("Pro_O_" + Sid,((Object) msgBean.getMsg()));
			currStatus.setTotalRecord(msgBean.getCount());
			currStatus.setJsp("Pro_O.jsp?Sid=" + Sid);
			// ��ѯ�ܺϼ�
			msgBean = pRmi.RmiExec(4, this, 0);
			request.getSession().setAttribute("Pro_O_ALL" + Sid,((Object) msgBean.getMsg()));

			// ����ҵ��
			ProRBean RBean = new ProRBean();
			msgBean = pRmi.RmiExec(1, RBean, 0);
			request.getSession().setAttribute("Pro_R_Buss_" + Sid,
					((Object) msgBean.getMsg()));

			// ��������
			msgBean = pRmi.RmiExec(2, RBean, 0);
			request.getSession().setAttribute("Pro_R_Type_" + Sid,
					((Object) msgBean.getMsg()));
			// ��ѯ����
			CorpInfoBean corpBean = new CorpInfoBean();
			msgBean = pRmi.RmiExec(0, corpBean, 0);
			request.getSession().setAttribute("Pro_O_Corp_" + Sid,
					((Object) msgBean.getMsg()));

			// ���������ز�ѯ
			CcmInfoBean cmBean = new CcmInfoBean();
			msgBean = pRmi.RmiExec(1, cmBean, 0);
			request.getSession().setAttribute("Ccm_Id_" + Sid,
					((Object) msgBean.getMsg()));
			// ��ѯ�Ƿ��������ձ���Ϣ
			ProLBean plBean = new ProLBean();
			plBean.setCpm_Id(Cpm_Id);
			plBean.currStatus = currStatus;
			msgBean = pRmi.RmiExec(0, plBean, 0);
			request.getSession().setAttribute("Pro_Status" + Sid,
					((Object) msgBean.getMsg()));
			break;

		case 1:// ���˱�
			msgBean = pRmi.RmiExec(1, this, 0);
			request.getSession().setAttribute("Pro_L_Stat_" + Sid,
					((Object) msgBean.getMsg()));
			// currStatus.setTotalRecord(msgBean.getCount());

			// ��ѯ����
			msgBean = pRmi.RmiExec(2, this, 0);
			request.getSession().setAttribute("Pro_L_Stat_Day_" + Sid,
					((Object) msgBean.getMsg()));
			// ��ѯ����

			msgBean = pRmi.RmiExec(3, this, 0);
			request.getSession().setAttribute("Pro_L_Stat_Car_" + Sid,
					((Object) msgBean.getMsg()));

			// ȼ�����Ͳ�ѯ
			ProRBean prBean = new ProRBean();
			msgBean = pRmi.RmiExec(2, prBean, 0);
			request.getSession().setAttribute("Pro_R_Type_" + Sid,
					((Object) msgBean.getMsg()));

			currStatus.setJsp("Pro_L_Stat.jsp?Sid=" + Sid);
			break;

		}

		// �ͻ���Ϣ

		CrmInfoBean crmBean = new CrmInfoBean();
		msgBean = pRmi.RmiExec(1, crmBean, 0);
		request.getSession().setAttribute("Crm_Info_" + Sid,((Object) msgBean.getMsg()));

		CorpInfoBean ifBean = new CorpInfoBean();
		msgBean = pRmi.RmiExec(0, ifBean, 0);
		request.getSession().setAttribute("Pro_R_Info_" + Sid,((Object) msgBean.getMsg()));

		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		response.sendRedirect(currStatus.getJsp());
	}

	// ��ϸ����
	public void ExportToExcel(HttpServletRequest request,
			HttpServletResponse response, Rmi pRmi, boolean pFromZone) {
		try {
			getHtmlData(request);
			currStatus = (CurrStatus) request.getSession().getAttribute(
					"CurrStatus_" + Sid);
			currStatus.getHtmlData(request, pFromZone);

			// ����
			Func_Corp_Id = currStatus.getFunc_Corp_Id();
			if (null == Func_Corp_Id || Func_Corp_Id.equals("9999")) {
				Func_Corp_Id = "";
			}

			// ״̬
			Func_Sub_Id = currStatus.getFunc_Sub_Id() + "";
			if (Func_Sub_Id.equals("9")) {
				Func_Sub_Id = "";
			}

			// ���ƺ�|����
			Func_Type_Id = currStatus.getFunc_Type_Id();
			if (null == Func_Type_Id) {
				Func_Type_Id = "";
			}

			// �����ʷ

			// ���ɵ�ǰ
			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString()
					.substring(5, 10);
			String ET = currStatus.getVecDate().get(1).toString()
					.substring(5, 10);
			String SheetName = "_" + BT + "," + ET;
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + ","
					+ ET;
			msgBean = pRmi.RmiExec(0, this, 0);
			ArrayList<?> temp = (ArrayList<?>) msgBean.getMsg();

			DeviceDetailBean dBean = new DeviceDetailBean();
			msgBean = pRmi.RmiExec(1, dBean, 0);
			ArrayList<?> dtemp = (ArrayList<?>) msgBean.getMsg();

			UserInfoBean uBean = new UserInfoBean();
			msgBean = pRmi.RmiExec(4, uBean, 0);
			ArrayList<?> utemp = (ArrayList<?>) msgBean.getMsg();

			if (temp != null) {
				WritableWorkbook book = Workbook.createWorkbook(new File(
						UPLOAD_PATH + UPLOAD_NAME + ".xls"));
				WritableSheet sheet = book.createSheet(SheetName, 0);
				WritableFont wf = new WritableFont(
						WritableFont.createFont("normal"), 18,
						WritableFont.BOLD, false);
				WritableCellFormat wff = new WritableCellFormat(wf);
				wf.setColour(Colour.BLACK);// ������ɫ
				wff.setAlignment(Alignment.CENTRE);// ���þ���
				wff.setBorder(Border.ALL, BorderLineStyle.THIN);// ���ñ߿���
				wff.setBackground(jxl.format.Colour.TURQUOISE);// ���õ�Ԫ��ı�����ɫ

				// �����ʽ2
				WritableFont wf2 = new WritableFont(
						WritableFont.createFont("normal"), 10,
						WritableFont.BOLD, false);
				WritableCellFormat wff2 = new WritableCellFormat(wf2);
				wf2.setColour(Colour.BLACK);// ������ɫ
				wff2.setAlignment(Alignment.CENTRE);// ���þ���
				wff2.setBorder(Border.ALL, BorderLineStyle.THIN);// ���ñ߿���
				int D_Index = -1;
				Label label = null;

				D_Index++;
				sheet.setRowView(D_Index, 400);
				sheet.setColumnView(D_Index, 12);
				label = new Label(0, D_Index, "�к����麣����Դ���޹�˾��ע��¼��", wff);
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
				label = new Label(11, D_Index, "");
				sheet.addCell(label);
				label = new Label(12, D_Index, "");
				sheet.addCell(label);
				label = new Label(13, D_Index, "");
				sheet.addCell(label);
				label = new Label(14, D_Index, "");
				sheet.addCell(label);
				label = new Label(15, D_Index, "");
				sheet.addCell(label);
				label = new Label(16, D_Index, "");
				sheet.addCell(label);
				label = new Label(17, D_Index, "");
				sheet.addCell(label);
				sheet.mergeCells(0, D_Index, 17, D_Index);

				D_Index++;
				sheet.setRowView(D_Index, 400);
				sheet.setColumnView(D_Index, 12);
				Label label1 = new Label(0, D_Index, "��עվ��", wff2);
				Label label2 = new Label(1, D_Index, "ȼ������", wff2);
				Label label3 = new Label(2, D_Index, "��עʱ��", wff2);
				Label label4 = new Label(3, D_Index, "��ע����", wff2);
				Label label5 = new Label(4, D_Index, "�ۺ�����/��̬", wff2);
				Label label6 = new Label(5, D_Index, "��ע����", wff2);
				Label label7 = new Label(6, D_Index, "��ע���", wff2);
				Label label8 = new Label(7, D_Index, "��ע��Ա", wff2);
				Label label9 = new Label(8, D_Index, "��������", wff2);
				Label label10 = new Label(9, D_Index, "�����ִ�", wff2);
				Label label11 = new Label(10, D_Index, "��������", wff2);
				Label label12 = new Label(11, D_Index, "����˾��", wff2);
				Label label13 = new Label(12, D_Index, "����ƿ��", wff2);
				Label label14 = new Label(13, D_Index, "������λ", wff2);
				Label label15 = new Label(14, D_Index, "¼����Ա", wff2);
				Label label16 = new Label(15, D_Index, "�����Ա", wff2);
				Label label17 = new Label(16, D_Index, "��¼״̬", wff2);
				Label label18 = new Label(17, D_Index, "��ע", wff2);

				sheet.addCell(label1);
				sheet.addCell(label2);
				sheet.addCell(label3);
				sheet.addCell(label4);
				sheet.addCell(label5);
				sheet.addCell(label6);
				sheet.addCell(label7);
				sheet.addCell(label8);
				sheet.addCell(label9);
				sheet.addCell(label10);
				sheet.addCell(label11);
				sheet.addCell(label12);
				sheet.addCell(label13);
				sheet.addCell(label14);
				sheet.addCell(label15);
				sheet.addCell(label16);
				sheet.addCell(label17);
				sheet.addCell(label18);
				Iterator<?> iterator = (Iterator<?>) temp.iterator();
				int i = 0;
				while (iterator.hasNext()) {
					i++;
					ProOBean Bean = (ProOBean) iterator.next();
					String D_Cpm_Id = Bean.getCpm_Id();
					String D_Cpm_Name = "";
					if (null != dtemp) {
						Iterator<?> diterator = (Iterator<?>) dtemp.iterator();

						while (diterator.hasNext()) {
							DeviceDetailBean dlBean = (DeviceDetailBean) diterator
									.next();
							if (dlBean.getId().equals(D_Cpm_Id)) {
								D_Cpm_Name = dlBean.getBrief();
							}
						}
					}

					String D_Oil_CType = Bean.getOil_CType();
					String D_CTime = Bean.getCTime();
					String D_Memo = Bean.getMemo();

					// ��ע��Ϣ
					String D_Value = Bean.getValue();
					String D_Value_Gas = Bean.getValue_Gas();
					String D_Price = Bean.getPrice();
					String D_Amt = Bean.getAmt();
					String D_Worker = Bean.getWorker();

					// �ͻ���Ϣ
					String D_Unq_Flag = Bean.getUnq_Flag();
					String D_Unq_Str = Bean.getUnq_Str();
					// String D_Car_More = Bean.getCar_More();
					String D_Car_CType = Bean.getCar_CType();
					String D_Car_Owner = Bean.getCar_Owner();
					String D_Car_BH = Bean.getCar_BH();
					String D_Car_DW = Bean.getCar_DW();

					// �����Ϣ
					String D_Status = Bean.getStatus();
					String D_Checker = Bean.getChecker();
					String D_Operator = Bean.getOperator();
					String D_Checker_Name = "";
					String D_Operator_Name = "";
					if (null != utemp) {
						Iterator<?> uiterator = (Iterator<?>) utemp.iterator();
						while (uiterator.hasNext()) {
							UserInfoBean uiBean = (UserInfoBean) uiterator
									.next();
							if (uiBean.getId().equals(D_Checker)) {
								D_Checker_Name = uiBean.getCName();
							}
							if (uiBean.getId().equals(D_Operator)) {
								D_Operator_Name = uiBean.getCName();
							}
						}
					}

					if (null == D_Oil_CType || D_Oil_CType.trim().length() < 1) {
						D_Oil_CType = "1000";
					}
					if (null == D_Memo) {
						D_Memo = "";
					}
					if (null == D_Value) {
						D_Value = "";
					}
					if (null == D_Value_Gas) {
						D_Value_Gas = "";
					}
					if (null == D_Price) {
						D_Price = "";
					}
					if (null == D_Amt) {
						D_Amt = "";
					}
					if (null == D_Worker) {
						D_Worker = "";
					}
					if (null == D_Unq_Flag) {
						D_Unq_Flag = "0";
					}
					if (null == D_Unq_Str) {
						D_Unq_Str = "";
					}
					if (null == D_Checker_Name) {
						D_Checker_Name = "";
					}
					if (null == D_Operator_Name) {
						D_Operator_Name = "";
					}
					if (null == D_Car_CType) {
						D_Car_CType = "";
					}
					if (null == D_Car_Owner) {
						D_Car_Owner = "";
					}
					if (null == D_Car_BH) {
						D_Car_BH = "";
					}
					if (null == D_Car_DW) {
						D_Car_DW = "";
					}

					String str_Unq_Flag = "";
					switch (Integer.parseInt(D_Unq_Flag)) {
					case 0:
						str_Unq_Flag = "IC����";
						break;
					case 1:
						str_Unq_Flag = "���ƺ�";
						break;
					}

					String str_Status = "";
					switch (Integer.parseInt(D_Status)) {
					case 0:
						str_Status = "��Ч";
						break;
					case 1:
						str_Status = "��Ч";
						break;
					}

					CorpInfoBean Corp_Info = (CorpInfoBean) request
							.getSession().getAttribute("User_Corp_Info_" + Sid);
					String Car_Info = "";
					String Oil_Info = "";
					if (null != Corp_Info) {
						Car_Info = Corp_Info.getCar_Info();
						Oil_Info = Corp_Info.getOil_Info();
						if (null == Car_Info) {
							Car_Info = "";
						}
						if (null == Oil_Info) {
							Oil_Info = "";
						}
					}

					String D_Oil_CName = "��";
					if (Oil_Info.trim().length() > 0) {
						String[] List = Oil_Info.split(";");
						for (int j = 0; j < List.length && List[j].length() > 0; j++) {
							String[] subList = List[j].split(",");
							if (subList[0].equals(D_Oil_CType)) {
								D_Oil_CName = subList[1];
								break;
							}
						}
					}

					String D_Car_CType_Name = "δ֪";
					if (Car_Info.trim().length() > 0) {
						String[] List = Car_Info.split(";");
						for (int k = 0; k < List.length && List[k].length() > 0; k++) {
							String[] subList = List[k].split(",");
							if (subList[0].equals(D_Car_CType)) {
								D_Car_CType_Name = subList[1];
								break;
							}
						}
					}

					String D_Value_Unit = "";
					String D_Value_Gas_Unit = "";
					String D_Price_Unit = "";
					try {
						switch (Integer.parseInt(D_Oil_CType)) {
						default:
						case 1000:// ����
						case 1010:// 90#����
						case 1011:// 90#��Ǧ����
						case 1012:// 90#�������
						case 1020:// 92#����
						case 1021:// 92#��Ǧ����
						case 1022:// 92#�������
						case 1030:// 93#����
						case 1031:// 93����Ǧ����
						case 1032:// 93#�������
						case 1040:// 95#����
						case 1041:// 95#��Ǧ����
						case 1042:// 95#�������
						case 1050:// 97#����
						case 1051:// 97#��Ǧ����
						case 1052:// 97#�������
						case 1060:// 120������
						case 1080:// ������������
						case 1090:// 98#����
						case 1091:// 98#��Ǧ����
						case 1092:// 98���������
						case 1100:// ��������
						case 1200:// ��������
						case 1201:// 75#��������
						case 1202:// 95#��������
						case 1203:// 100#��������
						case 1204:// ������������
						case 1300:// ��������
						case 2000:// ����
						case 2001:// 0#����
						case 2002:// +5#����
						case 2003:// +10#����
						case 2004:// +15#����
						case 2005:// +20#����
						case 2006:// -5#����
						case 2007:// -10#����
						case 2008:// -15#����
						case 2009:// -20#����
						case 2010:// -30#����
						case 2011:// -35#����
						case 2015:// -50#����
						case 2100:// �����
						case 2016:// ���������
						case 2200:// �ز���
						case 2012:// 10#�ز���
						case 2013:// 20#�ز���
						case 2014:// �����ز���
						case 2300:// ���ò���
						case 2301:// -10#���ò���
						case 2900:// ��������
							D_Value_Unit = "L";
							D_Value_Gas_Unit = "kg";
							D_Price_Unit = "Ԫ/L";
							break;
						case 3001:// CNG
						case 3002:// LNG
							D_Value_Unit = "kg";
							D_Value_Gas_Unit = "Nm3";
							D_Price_Unit = "Ԫ/kg";
							break;
						}
					} catch (Exception Exp) {
						D_Value_Unit = "kg";
						D_Value_Gas_Unit = "Nm3";
						D_Price_Unit = "Ԫ/kg";
						Exp.printStackTrace();
					}
					D_Index++;
					sheet.setRowView(D_Index, 400);
					sheet.setColumnView(D_Index, 12);
					label = new Label(0, D_Index, D_Cpm_Name, wff2);
					sheet.addCell(label);
					label = new Label(1, D_Index, D_Oil_CName, wff2);
					sheet.addCell(label);
					label = new Label(2, D_Index, D_CTime, wff2);
					sheet.addCell(label);

					label = new Label(3, D_Index, D_Value + D_Value_Unit, wff2);
					sheet.addCell(label);
					label = new Label(4, D_Index, D_Value_Gas
							+ D_Value_Gas_Unit, wff2);
					sheet.addCell(label);
					label = new Label(5, D_Index, D_Price + D_Price_Unit, wff2);
					sheet.addCell(label);
					label = new Label(6, D_Index, D_Amt + "Ԫ", wff2);
					sheet.addCell(label);
					label = new Label(7, D_Index, D_Worker, wff2);
					sheet.addCell(label);

					label = new Label(8, D_Index, str_Unq_Flag, wff2);
					sheet.addCell(label);
					label = new Label(9, D_Index, D_Unq_Str, wff2);
					sheet.addCell(label);

					label = new Label(10, D_Index, D_Car_CType_Name, wff2);
					sheet.addCell(label);
					label = new Label(11, D_Index, D_Car_Owner, wff2);
					sheet.addCell(label);
					label = new Label(12, D_Index, D_Car_BH, wff2);
					sheet.addCell(label);
					label = new Label(13, D_Index, D_Car_DW, wff2);
					sheet.addCell(label);

					label = new Label(14, D_Index, D_Operator_Name, wff2);
					sheet.addCell(label);
					label = new Label(15, D_Index, D_Checker_Name, wff2);
					sheet.addCell(label);
					label = new Label(16, D_Index, str_Status, wff2);
					sheet.addCell(label);
					label = new Label(17, D_Index, D_Memo, wff2);
					sheet.addCell(label);
				}
				book.write();
				book.close();
				try {
					PrintWriter out = response.getWriter();
					out.print(UPLOAD_NAME);
				} catch (Exception exp) {
					exp.printStackTrace();
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	// ����
	public void ProOAdd(HttpServletRequest request,
			HttpServletResponse response, Rmi pRmi, boolean pFromZone)
			throws ServletException, IOException {
		getHtmlData(request);
		currStatus = (CurrStatus) request.getSession().getAttribute(
				"CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);

		// ����
		Func_Corp_Id = currStatus.getFunc_Corp_Id();
		if (null == Func_Corp_Id || Func_Corp_Id.equals("9999")) {
			Func_Corp_Id = "";
		}

		// ״̬
		Func_Sub_Id = currStatus.getFunc_Sub_Id() + "";
		if (Func_Sub_Id.equals("9")) {
			Func_Sub_Id = "";
		}

		// ���ƺ�|����
		Func_Type_Id = currStatus.getFunc_Type_Id();
		if (null == Func_Type_Id) {
			Func_Type_Id = "";
		}

		msgBean = pRmi.RmiExec(currStatus.getCmd(), this, 0);

		msgBean = pRmi.RmiExec(0, this, 0);
		request.getSession().setAttribute("Pro_O_" + Sid,
				((Object) msgBean.getMsg()));
		// currStatus.setTotalRecord(msgBean.getCount());

		msgBean = pRmi.RmiExec(4, this, 0);
		request.getSession().setAttribute("Pro_O_ALL" + Sid,
				((Object) msgBean.getMsg()));
		currStatus.setJsp("Pro_O_Add_New.jsp?Sid=" + Sid);

		ProLBean plBean = new ProLBean();
		plBean.setCpm_Id(Cpm_Id);
		plBean.currStatus = currStatus;
		msgBean = pRmi.RmiExec(0, plBean, 0);
		request.getSession().setAttribute("Pro_Status" + Sid,
				((Object) msgBean.getMsg()));

		CrmInfoBean crBean = new CrmInfoBean();
		msgBean = pRmi.RmiExec(1, crBean, 0);
		request.getSession().setAttribute("Crm_Id_" + Sid,
				((Object) msgBean.getMsg()));

		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		response.sendRedirect(currStatus.getJsp());

	}

	// �����ձ�
	public void DoTJ(HttpServletRequest request, HttpServletResponse response,
			Rmi pRmi, boolean pFromZone) throws ServletException, IOException {
		getHtmlData(request);
		currStatus = (CurrStatus) request.getSession().getAttribute(
				"CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);

		// ����
		Func_Corp_Id = currStatus.getFunc_Corp_Id();
		if (null == Func_Corp_Id || Func_Corp_Id.equals("9999")) {
			Func_Corp_Id = "";
		}

		// ״̬
		Func_Sub_Id = currStatus.getFunc_Sub_Id() + "";
		if (Func_Sub_Id.equals("9")) {
			Func_Sub_Id = "";
		}

		// ����
		Func_Type_Id = currStatus.getFunc_Type_Id();
		if (null == Func_Type_Id) {
			Func_Type_Id = "";
		}
		msgBean = pRmi.RmiExec(40, this, 0);

		// ��ӻ����޸��ձ�������Ϣ
		DateBaoBean dbBean = new DateBaoBean();
		dbBean.setCpm_Id(Cpm_Id);
		dbBean.setCTime(CTime);
		dbBean.setZ_Person(Z_Person);
		dbBean.setC_Person(C_Person);
		dbBean.setDanger(Danger);
		dbBean.setPeccancy(Peccancy);
		dbBean.setXiaoFang(XiaoFang);
		dbBean.setBaoJing(BaoJing);
		dbBean.setTongXun(TongXun);
		dbBean.setJiJiu(JiJiu);
		if (Status.equals("999")) {
			msgBean = pRmi.RmiExec(11, dbBean, 0);
		} else {
			msgBean = pRmi.RmiExec(10, dbBean, 0);
		}

		// ��ӵ��տ��ֵ
		ProLBean plBean = new ProLBean();
		plBean.setCpm_Id(Cpm_Id);
		plBean.setCTime(CTime);
		plBean.currStatus = currStatus;
		plBean.setValue_R(Value);
		plBean.setValue_R_Gas(Value_Gas);
		msgBean = pRmi.RmiExec(10, plBean, 0);

		// ͳ��
		msgBean = pRmi.RmiExec(40, this, 0);
		System.out.println("��ͳ�Ƴ�");
		msgBean = pRmi.RmiExec(41, this, 0);

		if (msgBean.getStatus() == MsgBean.STA_SUCCESS) {
			msgBean = pRmi.RmiExec(0, this, currStatus.getCurrPage());
			request.getSession().setAttribute("Pro_O_" + Sid,
					((Object) msgBean.getMsg()));
			currStatus.setTotalRecord(msgBean.getCount());
			currStatus.setJsp("Pro_O.jsp?Sid=" + Sid);

			msgBean = pRmi.RmiExec(4, this, 0);
			request.getSession().setAttribute("Pro_O_ALL" + Sid,
					((Object) msgBean.getMsg()));
			// ����ҵ��
			ProRBean RBean = new ProRBean();
			msgBean = pRmi.RmiExec(1, RBean, 0);
			request.getSession().setAttribute("Pro_R_Buss_" + Sid,
					((Object) msgBean.getMsg()));

			// ��������
			msgBean = pRmi.RmiExec(2, RBean, 0);
			request.getSession().setAttribute("Pro_R_Type_" + Sid,
					((Object) msgBean.getMsg()));
			// ��ѯ����
			CorpInfoBean corpBean = new CorpInfoBean();
			msgBean = pRmi.RmiExec(0, corpBean, 0);
			request.getSession().setAttribute("Pro_O_Corp_" + Sid,
					((Object) msgBean.getMsg()));

			// ���������ز�ѯ
			CcmInfoBean cmBean = new CcmInfoBean();
			msgBean = pRmi.RmiExec(1, cmBean, 0);
			request.getSession().setAttribute("Ccm_Id_" + Sid,
					((Object) msgBean.getMsg()));

			ProLBean stBean = new ProLBean();
			stBean.setCpm_Id(Cpm_Id);
			stBean.currStatus = currStatus;
			msgBean = pRmi.RmiExec(0, stBean, 0);
			request.getSession().setAttribute("Pro_Status" + Sid,
					((Object) msgBean.getMsg()));

			currStatus.setResult("�ɹ����ɱ���!");
		}
		CorpInfoBean ifBean = new CorpInfoBean();
		msgBean = pRmi.RmiExec(0, ifBean, 0);
		request.getSession().setAttribute("Pro_R_Info_" + Sid,
				((Object) msgBean.getMsg()));

		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		response.sendRedirect(currStatus.getJsp());

	}

	// ���˱���
	public void DZBExcel(HttpServletRequest request,
			HttpServletResponse response, Rmi pRmi, boolean pFromZone) {
		try {
			getHtmlData(request);
			currStatus = (CurrStatus) request.getSession().getAttribute(
					"CurrStatus_" + Sid);
			currStatus.getHtmlData(request, pFromZone);

			// ����
			Func_Corp_Id = currStatus.getFunc_Corp_Id();
			if (null == Func_Corp_Id || Func_Corp_Id.equals("9999")) {
				Func_Corp_Id = "";
			}

			// ״̬
			Func_Sub_Id = currStatus.getFunc_Sub_Id() + "";
			if (Func_Sub_Id.equals("9")) {
				Func_Sub_Id = "";
			}

			// ����
			Func_Type_Id = currStatus.getFunc_Type_Id();
			if (null == Func_Type_Id) {
				Func_Type_Id = "";
			}

			String BDate = currStatus.getVecDate().get(0).toString()
					.substring(0, 10);
			String EDate = currStatus.getVecDate().get(1).toString()
					.substring(0, 10);

			SimpleDateFormat SimFormat = new SimpleDateFormat("yyyyMMddHHmmss");
			String BT = currStatus.getVecDate().get(0).toString()
					.substring(5, 10);
			String ET = currStatus.getVecDate().get(1).toString()
					.substring(5, 10);
			String SheetName = Car_DW;
			String UPLOAD_NAME = SimFormat.format(new Date()) + "_" + BT + ","
					+ ET;

			WritableWorkbook book = Workbook.createWorkbook(new File(
					UPLOAD_PATH + UPLOAD_NAME + ".xls"));
			WritableSheet sheet = book.createSheet(SheetName, 0);
			WritableFont wf = new WritableFont(
					WritableFont.createFont("normal"), 18, WritableFont.BOLD,
					false);
			WritableCellFormat wff = new WritableCellFormat(wf);
			// wf.setColour(Colour.BLACK);//������ɫ
			wff.setAlignment(Alignment.CENTRE);// ���þ���
			wff.setBorder(Border.ALL, BorderLineStyle.THIN);// ���ñ߿���
			// �����ʽ2
			WritableFont wf2 = new WritableFont(
					WritableFont.createFont("normal"), 10, WritableFont.BOLD,
					false);
			WritableCellFormat wff2 = new WritableCellFormat(wf2);
			// wf2.setColour(Colour.BLACK);//������ɫ
			wff2.setAlignment(Alignment.CENTRE);// ���þ���
			wff2.setBorder(Border.ALL, BorderLineStyle.THIN);// ���ñ߿���

			int D_Index = -1;
			int Cnt_Car = 0;
			int cell = 1;
			int j = 1;
			int num = 0;
			Double Total_Value_All = 0.00;
			Label label = null;
			List<String> Pro_L_Day = new ArrayList<String>();
			List<Double> Pro_Value_Day = new ArrayList<Double>();

			msgBean = pRmi.RmiExec(1, this, 0);// ����
			ArrayList<?> temp0 = (ArrayList<?>) msgBean.getMsg();

			msgBean = pRmi.RmiExec(2, this, 0);// ����
			ArrayList<?> temp2 = (ArrayList<?>) msgBean.getMsg();

			msgBean = pRmi.RmiExec(3, this, 0);// ����
			ArrayList<?> temp3 = (ArrayList<?>) msgBean.getMsg();
			if (null != temp2) {
				Iterator ri = temp2.iterator();
				while (ri.hasNext()) {

					ProOBean dBean = (ProOBean) ri.next();
					num++;
				}
			}

			if (null != temp0) {
				Iterator staIter = temp0.iterator();
				ProOBean OBean = (ProOBean) staIter.next();
				// Cpm_Name = OBean.getCpm_Name();

			}
			D_Index++;
			sheet.setRowView(D_Index, 400);
			sheet.setColumnView(D_Index, 20);
			label = new Label(0, D_Index, Cpm_Name + "վ���˱�" + BDate + "��"
					+ EDate, wff);
			sheet.addCell(label);
			label = new Label(1, D_Index, "");
			sheet.addCell(label);
			for (int a = 1; a < num; a++) {
				label = new Label(a, D_Index, "", wff2);
				sheet.addCell(label);

			}
			sheet.mergeCells(0, D_Index, 2 + num, D_Index);

			D_Index++;
			sheet.setRowView(D_Index, 400);
			sheet.setColumnView(D_Index, 20);
			label = new Label(0, D_Index, "���ƺ�", wff2);
			sheet.addCell(label);
			label = new Label(1, D_Index, "", wff2);
			sheet.addCell(label);
			sheet.mergeCells(0, D_Index, 1, D_Index);

			if (null != temp2) {
				Iterator riter = temp2.iterator();
				while (riter.hasNext()) {
					cell++;
					ProOBean dayBean = (ProOBean) riter.next();
					Pro_L_Day.add(dayBean.getCTime().substring(5, 10));
					Pro_Value_Day.add(0.00);
					dayBean.getCTime().substring(8, 10);

					label = new Label(cell, D_Index, dayBean.getCTime()
							.substring(8, 10) + "��", wff2);
					sheet.addCell(label);

				}
			}
			label = new Label(cell + 1, D_Index, "�ϼ�", wff2);
			sheet.addCell(label);

			// **********************�������г���********************************************************************************/
			if (null != temp3) {
				Iterator riter = temp3.iterator();
				while (riter.hasNext()) {
					ProOBean carBean = (ProOBean) riter.next();
					String carName = carBean.getUnq_Str();
					// Car_More = carBean.getCar_More();
					// String Car_Str = Car_More.split("\\$")[4];
					String Car_Str = carBean.getCar_DW();

					Double Total_Value_Car = 0.00;
					Cnt_Car++;

					D_Index++;
					sheet.setRowView(D_Index, 400);
					sheet.setColumnView(D_Index, 20);
					label = new Label(0, D_Index, Car_Str, wff2);
					sheet.addCell(label);
					label = new Label(1, D_Index, carName, wff2);
					sheet.addCell(label);

					if (null != Pro_L_Day) {
						Iterator dayIter = Pro_L_Day.iterator();
						int i = 0;
						j = 2;
						while (dayIter.hasNext()) {

							boolean flagHaveData = false; // �жϸó������Ƿ������ݣ����������td������ӿհ�td
							String tmpDay = (String) dayIter.next();
							if (null != temp0) {
								Iterator valueIter = temp0.iterator();
								while (valueIter.hasNext()) {

									ProOBean valueBean = (ProOBean) valueIter
											.next();
									String CValue = valueBean.getValue(); // ��ǰProOBean��Value
									String CDay = valueBean.getCTime()
											.substring(5, 10); // ��ǰProOBean������
									String CUnqStr = valueBean.getUnq_Str();

									// ��ǰProOBean�ĳ��ƺ�
									if (tmpDay.equals(CDay)
											&& carName.equals(CUnqStr)) {
										flagHaveData = true;
										Total_Value_Car += Double
												.parseDouble(CValue);
										Total_Value_All += Double
												.parseDouble(CValue);
										Pro_Value_Day
												.set(i,
														Pro_Value_Day.get(i)
																+ Double.parseDouble(CValue));
										label = new Label(j, D_Index, CValue,
												wff2);
										sheet.addCell(label);
									}
								}
							}
							if (!flagHaveData) {
								label = new Label(j, D_Index, "0.00", wff2);
								sheet.addCell(label);
							}
							j++;
							i++;
						}
					}
					label = new Label(j, D_Index, (new BigDecimal(
							Double.toString(Total_Value_Car)).divide(
							new BigDecimal(1), 2,
							java.math.RoundingMode.HALF_UP))
							+ "", wff2);
					sheet.addCell(label);
				}
			}

			D_Index++;
			sheet.setRowView(D_Index, 400);
			sheet.setColumnView(D_Index, 20);
			label = new Label(0, D_Index, "", wff2);
			sheet.addCell(label);
			label = new Label(1, D_Index, String.valueOf(Cnt_Car) + "��", wff2);
			sheet.addCell(label);
			int a = 1;
			if (null != Pro_Value_Day) {
				Iterator dayIter = Pro_Value_Day.iterator();
				while (dayIter.hasNext()) {
					a++;
					Double Value_Day = (Double) dayIter.next();
					label = new Label(a, D_Index,
							(new BigDecimal(Value_Day).divide(
									new BigDecimal(1), 2,
									java.math.RoundingMode.HALF_UP))
									+ "", wff2);
					sheet.addCell(label);
				}
			}
			label = new Label(a + 1, D_Index,
					(new BigDecimal(Total_Value_All).divide(new BigDecimal(1),
							2, java.math.RoundingMode.HALF_UP)) + "", wff2);
			sheet.addCell(label);
			sheet.mergeCells(0, 2, 0, Cnt_Car + 2);

			book.write();
			book.close();
			try {
				PrintWriter out = response.getWriter();
				out.print(UPLOAD_NAME);
			} catch (Exception exp) {
				exp.printStackTrace();
			}

		} catch (Exception e) {

		}
	}

	// ����ɾ��
	public void doDel(HttpServletRequest request, HttpServletResponse response,
			Rmi pRmi, boolean pFromZone) throws ServletException, IOException {
		getHtmlData(request);
		currStatus = (CurrStatus) request.getSession().getAttribute(
				"CurrStatus_" + Sid);
		currStatus.getHtmlData(request, pFromZone);

		// ����
		Func_Corp_Id = currStatus.getFunc_Corp_Id();
		if (null == Func_Corp_Id || Func_Corp_Id.equals("9999")) {
			Func_Corp_Id = "";
		}

		// ״̬
		Func_Sub_Id = currStatus.getFunc_Sub_Id() + "";
		if (Func_Sub_Id.equals("9")) {
			Func_Sub_Id = "";
		}

		// ���ƺ�|����
		Func_Type_Id = currStatus.getFunc_Type_Id();
		if (null == Func_Type_Id) {
			Func_Type_Id = "";
		}

		PrintWriter outprint = response.getWriter();
		String Resp = "9999";
		System.out.println(JiJiu);
		String[] strs = JiJiu.split(";");
		System.out.println("[" + currStatus.getVecDate().get(0).toString()
				+ "]" + "[" + currStatus.getVecDate().get(1).toString() + "]");
		for (int a = 0; a < strs.length; a++) {
			SN = strs[a];
			System.out.println(SN);
			msgBean = pRmi.RmiExec(13, this, 0);

		}

		if (msgBean.getStatus() == MsgBean.STA_SUCCESS) {

			Resp = "0000";
			currStatus.setCmd(0);
			msgBean = pRmi.RmiExec(currStatus.getCmd(), this,
					currStatus.getCurrPage());
			request.getSession().setAttribute("Pro_O_" + Sid,
					((Object) msgBean.getMsg()));
			currStatus.setTotalRecord(msgBean.getCount());
			currStatus.setJsp("Pro_O.jsp?Sid=" + Sid);
			// ��ѯ�ܺϼ�
			msgBean = pRmi.RmiExec(4, this, 0);
			request.getSession().setAttribute("Pro_O_ALL" + Sid,
					((Object) msgBean.getMsg()));

		}

		request.getSession().setAttribute("CurrStatus_" + Sid, currStatus);
		outprint.write(Resp);
		response.sendRedirect(currStatus.getJsp());
	}

	public String getSql(int pCmd) {
		String Sql = "";
		switch (pCmd) {
		case 0:// ��ѯ
			Sql = " select t.sn, t.cpm_id,  t.oil_ctype, t.ctime, t.Fill_Number, t.value, t.value_gas, t.price, t.amt, t.worker, t.unq_flag, t.unq_str, t.car_ctype, t.car_owner, t.car_bh, t.car_dw, t.memo, t.status, t.operator, t.checker, t.dw_id "
					+ " from pro_o t "
					+ " where instr('"
					+ Cpm_Id
					+ "', t.cpm_id) > 0 "
					+ "   and t.oil_ctype like '"
					+ Func_Corp_Id
					+ "%'"
					+ "   and t.status like '"
					+ Func_Sub_Id
					+ "%'"
					+ "   and t.Fill_Number like '"
					+ Func_Type_Id
					+ "%'"
					+ "   and t.ctime >= date_format('"
					+ currStatus.getVecDate().get(0).toString()
					+ "', '%Y-%m-%d %H-%i-%S')"
					+ "   and t.ctime <= date_format('"
					+ currStatus.getVecDate().get(1).toString()
					+ "', '%Y-%m-%d %H-%i-%S')" + "   order by t.sn desc ";
			break;
		case 1:// ���˱�����
			Sql = " select t.sn, t.cpm_id,  t.oil_ctype, t.ctime, t.Fill_Number, ROUND(SUM(t.value),2) AS VALUE , ROUND((t.value_gas),2) AS value_gas, t.price, t.amt, t.worker, t.unq_flag, t.unq_str, t.car_ctype,t.car_owner, t.car_bh, t.car_dw, t.memo, t.status, t.operator, t.checker, t.dw_id "
					+ " from pro_o t "
					+ " where instr('"
					+ Cpm_Id
					+ "', t.cpm_id) > 0 "
					+ " and t.dw_id like '"
					+ DW_ID
					+ "%'"
					+ " and t.oil_ctype like '"
					+ Func_Corp_Id
					+ "%'"
					+ " and t.ctime >= date_format('"
					+ currStatus.getVecDate().get(0).toString()
					+ "', '%Y-%m-%d %H-%i-%S')"
					+ " and t.ctime <= date_format('"
					+ currStatus.getVecDate().get(1).toString()
					+ "', '%Y-%m-%d %H-%i-%S')"
					+ " group by t.unq_str, substr(t.ctime, 1, 10) order by  t.ctime";
			break;
		case 2:// ���˱�-��ѯ����
			Sql = " select t.sn, t.cpm_id,  t.oil_ctype, t.ctime, t.Fill_Number, t.value, t.value_gas, t.price, t.amt, t.worker, t.unq_flag, t.unq_str, t.car_ctype,t.car_owner, t.car_bh, t.car_dw, t.memo, t.status, t.operator, t.checker, t.dw_id "
					+ " from pro_o t "
					+ " where instr('"
					+ Cpm_Id
					+ "', t.cpm_id) > 0 "
					+ " and t.dw_id like '"
					+ DW_ID
					+ "%'"
					+ " and t.oil_ctype like '"
					+ Func_Corp_Id
					+ "%'"
					+ " and t.ctime >= date_format('"
					+ currStatus.getVecDate().get(0).toString()
					+ "', '%Y-%m-%d %H-%i-%S')"
					+ " and t.ctime <= date_format('"
					+ currStatus.getVecDate().get(1).toString()
					+ "', '%Y-%m-%d %H-%i-%S')"
					+ " group by substr(t.ctime, 1, 10) order by t.ctime";
			break;
		case 3:// ��ѯ����ROUND(SUM(t.value_i),2) AS value_i
			Sql = " select t.sn, t.cpm_id,  t.oil_ctype, t.ctime, t.Fill_Number, t.value, t.value_gas, t.price, t.amt, t.worker, t.unq_flag, t.unq_str, t.car_ctype,t.car_owner, t.car_bh, t.car_dw, t.memo, t.status, t.operator, t.checker, t.dw_id "
					+ " from pro_o t "
					+ " where instr('"
					+ Cpm_Id
					+ "', t.cpm_id) > 0 "
					+ " and t.dw_id like '"
					+ DW_ID
					+ "%'"
					+ " and t.oil_ctype like '"
					+ Func_Corp_Id
					+ "%'"
					+ " and t.ctime >= date_format('"
					+ currStatus.getVecDate().get(0).toString()
					+ "', '%Y-%m-%d %H-%i-%S')"
					+ " and t.ctime <= date_format('"
					+ currStatus.getVecDate().get(1).toString()
					+ "', '%Y-%m-%d %H-%i-%S')"
					+ " group by t.unq_str order by  t.unq_str";
			break;

		case 4:// ��ѯ�ܺ�
			Sql = " select t.sn, t.cpm_id,  t.oil_ctype, t.ctime, t.Fill_Number, ROUND(SUM(t.value),2) AS VALUE , ROUND(SUM(t.value_gas),2) AS value_gas, t.price, t.amt, t.worker, t.unq_flag, t.unq_str, t.car_ctype,t.car_owner, t.car_bh, t.car_dw, t.memo, t.status, t.operator, t.checker, t.dw_id "
					+ " from pro_o t "
					+ " where instr('"
					+ Cpm_Id
					+ "', t.cpm_id) > 0 "
					+ " and t.oil_ctype like '"
					+ Func_Corp_Id
					+ "%'"
					+ " and t.Fill_Number like '"
					+ Func_Type_Id
					+ "%'"
					+ " and t.ctime >= date_format('"
					+ currStatus.getVecDate().get(0).toString()
					+ "', '%Y-%m-%d %H-%i-%S')"
					+ " and t.ctime <= date_format('"
					+ currStatus.getVecDate().get(1).toString()
					+ "', '%Y-%m-%d %H-%i-%S')" + " order by t.ctime desc ";
			break;

		case 5:// ������

			Sql = " select t.sn, t.cpm_id,  t.oil_ctype, t.ctime, t.Fill_Number, t.value, t.value_gas, t.price, t.amt, t.worker, t.unq_flag, t.unq_str, t.car_ctype,t.car_owner, t.car_bh, t.car_dw, t.memo, t.status, t.operator, t.checker, t.dw_id "
					+ " from pro_o t "
					+ " where instr('"
					+ Cpm_Id
					+ "', t.cpm_id) > 0 "
					+ " and t.oil_ctype = '"
					+ currStatus.getFunc_Corp_Id()
					+ "' "
					+ " and t.status = '0' "
					+ " and t.ctime >= '"
					+ currStatus.getVecDate().get(0).toString()
							.substring(0, 10)
					+ " 08:30:00"
					+ "' "
					+ " and t.ctime <= '"
					+ CommUtil.getNextStrDate(currStatus.getVecDate().get(1)
							.toString().substring(0, 10))
					+ " 08:30:00"
					+ "' "
					+ " group by t.cpm_id,  t.unq_str  "
					+ " order by t.cpm_id ";
			break;
		case 6:// ������
			Sql = " select t.sn, t.cpm_id,  t.oil_ctype, t.ctime, t.Fill_Number, t.value, t.value_gas, t.price, t.amt, t.worker, t.unq_flag, t.unq_str, t.car_ctype,t.car_owner, t.car_bh, t.car_dw, t.memo, t.status, t.operator, t.checker, t.dw_id "
					+ " from pro_o t "
					+ " where instr('"
					+ Cpm_Id
					+ "', t.cpm_id) > 0 "
					+ " and t.oil_ctype = '"
					+ currStatus.getFunc_Corp_Id()
					+ "' "
					+ " and t.status = '0' "
					+ " and t.ctime >= '"
					+ currStatus.getVecDate().get(0).toString()
							.substring(0, 10)
					+ " 08:30:00"
					+ "' "
					+ " and t.ctime <= '"
					+ CommUtil.getNextStrDate(currStatus.getVecDate().get(1)
							.toString().substring(0, 10))
					+ " 08:30:00"
					+ "' "
					+ " AND INSTR(t.car_ctype, '������') <= 0   "
					+ " AND INSTR(t.car_ctype, '������') <= 0  "
					+ " group by t.cpm_id,  t.unq_str  "
					+ " order by t.cpm_id ";
			break;

		case 10:// ���
			Sql = " insert into pro_o(cpm_id, oil_ctype, ctime, Fill_Number, value, price, amt, worker, unq_flag, unq_str, memo, operator, car_ctype, car_owner, car_bh, car_dw,dw_id)"
					+ " values('"
					+ Cpm_Id
					+ "', '"
					+ Oil_CType
					+ "', '"
					+ CTime
					+ "', '"
					+ Fill_Number
					+ "', '"
					+ Value
					+ "', '"
					+ Price
					+ "', '"
					+ Amt
					+ "', '"
					+ Worker
					+ "', '"
					+ Unq_Flag
					+ "', '"
					+ Unq_Str
					+ "', '"
					+ Memo
					+ "', '"
					+ Operator
					+ "', '"
					+ Car_CType
					+ "', '"
					+ Car_Owner
					+ "', '"
					+ Car_BH
					+ "', '"
					+ Car_DW + "','" + DW_ID + "')";
			break;
		case 11:// �༭
			Sql = " update pro_o t set t.status = '" + Status
					+ "', t.checker = '" + Checker + "' where t.sn = '" + SN
					+ "' ";
			break;
		case 12:// �޸�
			Sql = " update pro_o t set t.ctime='"+ CTime +"',t.Fill_Number = '" + Fill_Number
					+ "', t.Value = '" + Value + "', t.unq_str= '" + Unq_Str
					+ "', t.car_ctype= '" + Car_CType + "', t.car_owner='"
					+ Car_Owner + "', t.car_bh='" + Car_BH + "', t.car_dw='"
					+ Car_DW + "', t.dw_id = '" + DW_ID + "' where t.sn = '"
					+ SN + "' ";
			break;
		case 13:// ɾ��
			Sql = " delete from pro_o where sn = '" + SN + "' ";
			break;
		case 40:// ���ô洢����			
			Sql = "{call pro_ledger_day_news('" + CTime.substring(0, 10)
					+ "','" + Cpm_Id + "','" + Value + "','" + Value_Gas
					+ "')}";
			break;
		case 41:// ���ô洢����
			Sql = "{call pro_ledger_crm_Day('" + CTime.substring(0, 10) + "')}";
			break;
		}
		return Sql;
	}

	public boolean getData(ResultSet pRs) {
		boolean IsOK = true;
		try {
			setSN(pRs.getString(1));
			setCpm_Id(pRs.getString(2));
			setOil_CType(pRs.getString(3));
			setCTime(pRs.getString(4));
			setFill_Number(pRs.getString(5));
			setValue(pRs.getString(6));
			setValue_Gas(pRs.getString(7));
			setPrice(pRs.getString(8));
			setAmt(pRs.getString(9));
			setWorker(pRs.getString(10));
			setUnq_Flag(pRs.getString(11));
			setUnq_Str(pRs.getString(12));
			setCar_CType(pRs.getString(13));
			setCar_Owner(pRs.getString(14));
			setCar_BH(pRs.getString(15));
			setCar_DW(pRs.getString(16));
			setMemo(pRs.getString(17));
			setStatus(pRs.getString(18));
			setOperator(pRs.getString(19));
			setChecker(pRs.getString(20));
			setDW_ID(pRs.getString(21));
		} catch (SQLException sqlExp) {
			sqlExp.printStackTrace();
		}
		return IsOK;
	}

	public boolean getHtmlData(HttpServletRequest request) {
		boolean IsOK = true;
		try {
			setSN(CommUtil.StrToGB2312(request.getParameter("SN")));
			setCpm_Id(CommUtil.StrToGB2312(request.getParameter("Cpm_Id")));
			setCpm_Name(CommUtil.StrToGB2312(request.getParameter("Cpm_Name")));
			setOil_CType(CommUtil
					.StrToGB2312(request.getParameter("Oil_CType")));
			setCTime(CommUtil.StrToGB2312(request.getParameter("CTime")));
			setValue(CommUtil.StrToGB2312(request.getParameter("Value")));
			setValue_Gas(CommUtil
					.StrToGB2312(request.getParameter("Value_Gas")));
			setPrice(CommUtil.StrToGB2312(request.getParameter("Price")));
			setAmt(CommUtil.StrToGB2312(request.getParameter("Amt")));
			setWorker(CommUtil.StrToGB2312(request.getParameter("Worker")));
			setUnq_Flag(CommUtil.StrToGB2312(request.getParameter("Unq_Flag")));
			setUnq_Str(CommUtil.StrToGB2312(request.getParameter("Unq_Str")));
			setMemo(CommUtil.StrToGB2312(request.getParameter("Memo")));
			setStatus(CommUtil.StrToGB2312(request.getParameter("Status")));
			setOperator(CommUtil.StrToGB2312(request.getParameter("Operator")));
			setOperator_Name(CommUtil.StrToGB2312(request
					.getParameter("Operator_Name")));
			setChecker(CommUtil.StrToGB2312(request.getParameter("Checker")));
			setChecker_Name(CommUtil.StrToGB2312(request
					.getParameter("Checker_Name")));
			setCar_More(CommUtil.StrToGB2312(request.getParameter("Car_More")));
			setCar_CType(CommUtil
					.StrToGB2312(request.getParameter("Car_CType")));// ��������
			setCar_Owner(CommUtil
					.StrToGB2312(request.getParameter("Car_Owner")));// ����˾��
			setCar_BH(CommUtil.StrToGB2312(request.getParameter("Car_BH")));// ��������
			setCar_DW(CommUtil.StrToGB2312(request.getParameter("Car_DW")));// ������λ
			setDW_ID(CommUtil.StrToGB2312(request.getParameter("DW_ID")));// ������λID
			setSid(CommUtil.StrToGB2312(request.getParameter("Sid")));
			setFill_Number(CommUtil.StrToGB2312(request
					.getParameter("Fill_Number")));

			setZ_Person(CommUtil.StrToGB2312(request.getParameter("Z_Person")));
			setC_Person(CommUtil.StrToGB2312(request.getParameter("C_Person")));
			setDanger(CommUtil.StrToGB2312(request.getParameter("Danger")));
			setPeccancy(CommUtil.StrToGB2312(request.getParameter("Peccancy")));
			setXiaoFang(CommUtil.StrToGB2312(request.getParameter("XiaoFang")));
			setBaoJing(CommUtil.StrToGB2312(request.getParameter("BaoJing")));
			setTongXun(CommUtil.StrToGB2312(request.getParameter("TongXun")));
			setJiJiu(CommUtil.StrToGB2312(request.getParameter("JiJiu")));
		} catch (Exception Exp) {
			Exp.printStackTrace();
		}
		return IsOK;
	}

	private String SN;
	private String Cpm_Id;
	private String Cpm_Name;
	private String Oil_CType;
	private String CTime;
	private String Value;
	private String Value_Gas;
	private String Price;
	private String Amt;
	private String Worker;
	private String Unq_Flag;
	private String Unq_Str;
	private String Memo;
	private String Status;
	private String Operator;
	private String Operator_Name;
	private String Checker;
	private String Checker_Name;
	private String Car_More;
	private String Car_CType;
	private String Car_Owner;
	private String Car_BH;
	private String Car_DW;
	private String DW_ID;
	private String Fill_Number;

	private String Sid;
	private String Func_Sub_Id;
	private String Func_Corp_Id;
	private String Func_Type_Id;

	private String Z_Person;
	private String C_Person;
	private String Danger;
	private String Peccancy;
	private String XiaoFang;
	private String BaoJing;
	private String TongXun;
	private String JiJiu;

	public String getZ_Person() {
		return Z_Person;
	}

	public void setZ_Person(String z_Person) {
		Z_Person = z_Person;
	}

	public String getC_Person() {
		return C_Person;
	}

	public void setC_Person(String c_Person) {
		C_Person = c_Person;
	}

	public String getDanger() {
		return Danger;
	}

	public void setDanger(String danger) {
		Danger = danger;
	}

	public String getPeccancy() {
		return Peccancy;
	}

	public void setPeccancy(String peccancy) {
		Peccancy = peccancy;
	}

	public String getXiaoFang() {
		return XiaoFang;
	}

	public void setXiaoFang(String xiaoFang) {
		XiaoFang = xiaoFang;
	}

	public String getBaoJing() {
		return BaoJing;
	}

	public void setBaoJing(String baoJing) {
		BaoJing = baoJing;
	}

	public String getTongXun() {
		return TongXun;
	}

	public void setTongXun(String tongXun) {
		TongXun = tongXun;
	}

	public String getJiJiu() {
		return JiJiu;
	}

	public void setJiJiu(String jiJiu) {
		JiJiu = jiJiu;
	}

	public String getDW_ID() {
		return DW_ID;
	}

	public void setDW_ID(String dW_ID) {
		DW_ID = dW_ID;
	}

	public String getFill_Number() {
		return Fill_Number;
	}

	public void setFill_Number(String fill_Number) {
		Fill_Number = fill_Number;
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

	public String getOil_CType() {
		return Oil_CType;
	}

	public void setOil_CType(String oilCType) {
		Oil_CType = oilCType;
	}

	public String getCTime() {
		return CTime;
	}

	public void setCTime(String cTime) {
		CTime = cTime;
	}

	public String getValue() {
		return Value;
	}

	public void setValue(String value) {
		Value = value;
	}

	public String getValue_Gas() {
		return Value_Gas;
	}

	public void setValue_Gas(String valueGas) {
		Value_Gas = valueGas;
	}

	public String getPrice() {
		return Price;
	}

	public void setPrice(String price) {
		Price = price;
	}

	public String getAmt() {
		return Amt;
	}

	public void setAmt(String amt) {
		Amt = amt;
	}

	public String getWorker() {
		return Worker;
	}

	public void setWorker(String worker) {
		Worker = worker;
	}

	public String getUnq_Flag() {
		return Unq_Flag;
	}

	public void setUnq_Flag(String unqFlag) {
		Unq_Flag = unqFlag;
	}

	public String getUnq_Str() {
		return Unq_Str;
	}

	public void setUnq_Str(String unqStr) {
		Unq_Str = unqStr;
	}

	public String getMemo() {
		return Memo;
	}

	public void setMemo(String memo) {
		Memo = memo;
	}

	public String getStatus() {
		return Status;
	}

	public void setStatus(String status) {
		Status = status;
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

	public String getChecker() {
		return Checker;
	}

	public void setChecker(String checker) {
		Checker = checker;
	}

	public String getChecker_Name() {
		return Checker_Name;
	}

	public void setChecker_Name(String checkerName) {
		Checker_Name = checkerName;
	}

	public String getCar_More() {
		return Car_More;
	}

	public void setCar_More(String carMore) {
		Car_More = carMore;
	}

	public String getCar_CType() {
		return Car_CType;
	}

	public void setCar_CType(String carCType) {
		Car_CType = carCType;
	}

	public String getCar_Owner() {
		return Car_Owner;
	}

	public void setCar_Owner(String carOwner) {
		Car_Owner = carOwner;
	}

	public String getCar_BH() {
		return Car_BH;
	}

	public void setCar_BH(String carBH) {
		Car_BH = carBH;
	}

	public String getCar_DW() {
		return Car_DW;
	}

	public void setCar_DW(String carDW) {
		Car_DW = carDW;
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

	public String getFunc_Corp_Id() {
		return Func_Corp_Id;
	}

	public void setFunc_Corp_Id(String funcCorpId) {
		Func_Corp_Id = funcCorpId;
	}

	public String getFunc_Type_Id() {
		return Func_Type_Id;
	}

	public void setFunc_Type_Id(String funcTypeId) {
		Func_Type_Id = funcTypeId;
	}
}