package util;
public class Cmd_Sta 
{
//	==================ͨ��========================================================
	public static final int COMM_LOGON 					= 0x00000001;	//�����½
	public static final int COMM_LOGOUT 				= 0x00000002;	//��ֹ��½
	public static final int COMM_ACTIVE_TEST 			= 0x00000003;	//���Ӳ���
	public static final int COMM_SUBMMIT 				= 0x00000004;	//�ͻ����ύ
	public static final int COMM_DELIVER 				= 0x00000005;	//�������ɷ�
	public static final int COMM_RESP 					= 0x80000000; 	//��Ӧ���

//	==================��������=====================================================	
	public static final int CONST_MAX_BUFF_SIZE = 2048; //���ջ���������
	public static final int CONST_MSGHDRLEN     = 20;   //��ͷ����
	public static final int CONST_TEST_START    = 3;    //���԰����Կ�ʼ����
	public static final int CONST_TEST_END      = 6;    //���԰����Խ�������
	
//	==================DeCode�����ķ���ֵ===========================================	
	public static final byte CODEC_CMD       = 0;
	public static final byte CODEC_RESP      = 1;
	public static final byte CODEC_TRANS     = 2;
	public static final byte CODEC_NEED_DATA = 3;
	public static final byte CODEC_ERR       = 4;

//	==========================AppSvr ~ CPM========================================
	public static final int CMD_SUBMIT_1000	 				= 1000;
	public static final int CMD_SUBMIT_1001	 				= 1001;
	public static final int CMD_SUBMIT_1003	 				= 1003;
	public static final int CMD_SUBMIT_1004	 				= 1004;
	public static final int CMD_SUBMIT_1011	 				= 1011;

//	==========================AppSvr ~ CPM========================================
	public static final String DATA_1011_20                 = "0321020001";
	public static final String DATA_1011_21                 = "0321010001";
	public static final String DATA_1011_22                 = "0321030001";
	public static final String DATA_1011_23                 = "0321040001";
	public static final String DATA_1011_24                 = "0321050001";
	public static final String DATA_1011_25                 = "0321060001";
	
//	==================ϵͳ״̬=====================================================
	public static final int STA_SUCCESS						= 0000;	//�ɹ�
	public static final int STA_ERROR						= 3006;	//ʧ��
	public static final int STA_NET_ERROR					= 9993;	//�������
	public static final int STA_SYSTEM_BUSY					= 9994;	//ϵͳæ
	public static final int STA_DATA_FORMAT_ERROR			= 9995;	//��ʽ����
	public static final int STA_UNKHOWN_DEAL_TYPE			= 9996;	//δ֪ҵ������	
	public static final int STA_DB_ERROR					= 9997; //���ݿ����	
	public static final int STA_SYSTEM_ERROR				= 9998;	//ϵͳæ	
	public static final int STA_UNKHOWN_ERROR				= 9999;	//δ֪����
	public static final int STA_DEAL_SUBMIT_SUCCESS			= 3000;	//�ύ�ɹ�
	public static final int STA_DEAL_SEND_SUCCESS			= 3001;	//���ͳɹ�
	
	public static String GetErrorMsg(String strCode)
	{
		String RetVal = "";
		int Code = Integer.parseInt(strCode);
		switch(Code)
		{
			case STA_SUCCESS: 
			 	RetVal = "�ɹ�";	
			 	break;
			case STA_NET_ERROR:
				RetVal = "�������";
				break;
			case STA_SYSTEM_BUSY:
				RetVal = "ϵͳæ";
				break;	
			case STA_DATA_FORMAT_ERROR:
				RetVal = "��ʽ����";
				break;
			case STA_UNKHOWN_DEAL_TYPE:
				RetVal = "δ֪ҵ������";
				break;
			case STA_DB_ERROR:
				RetVal = "���ݿ����";
				break;
			case STA_SYSTEM_ERROR:
				RetVal = "ϵͳæ";
				break;
			case STA_UNKHOWN_ERROR:
				RetVal = "δ֪����";
				break;
			case STA_DEAL_SUBMIT_SUCCESS:
				RetVal = "�ύ�ɹ�";	
				break;
			default:
				RetVal = "δ֪����";
				break;
		}
		return RetVal;
	}
}