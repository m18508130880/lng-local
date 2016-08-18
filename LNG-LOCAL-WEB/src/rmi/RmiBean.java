package rmi;

import java.io.Serializable;
import java.sql.ResultSet;
import util.*;

public abstract class RmiBean implements Serializable
{
	public final static String UPLOAD_PATH = "/www/LNG-LOCAL/LNG-LOCAL-WEB/files/excel/";
	
	/**************************system**********************/
	public static final int RMI_MANUFACTURER            = 1;
	public static final int RMI_DEVICE_INFO             = 2;
	public static final int RMI_DEVICE_CMD              = 3;
	public static final int RMI_DEVICE_ATTR             = 4;
	public static final int RMI_DATA_TYPE               = 5;
	
	/**************************admin***********************/
	public static final int RMI_CORP_INFO			    = 11;
	public static final int RMI_DEVICE_DETAIL			= 12;
	public static final int RMI_USER_INFO			 	= 13;
	public static final int RMI_USER_ROLE		   	    = 14;
	public static final int RMI_AQSC_EXAM_TYPE		   	= 15;
	public static final int RMI_AQSC_DANGER_TYPE		= 16;
	public static final int RMI_AQSC_DANGER_LEVEL		= 17;
	public static final int RMI_USER_POSITION			= 18;
	public static final int RMI_AQSC_TRAIN_TYPE		   	= 19;
	public static final int RMI_AQSC_DRILL_TYPE		   	= 20;
	public static final int RMI_AQSC_CARD_TYPE		   	= 21;
	public static final int RMI_AQSC_LABOUR_TYPE		= 22;
	public static final int RMI_AQSC_ACT_TYPE			= 23;
	public static final int RMI_AQSC_DEVICE_TYPE		= 24;
	public static final int RMI_AQSC_DEVICE_CARD		= 25;
	public static final int RMI_AQSC_SPARE_TYPE		    = 26;
	public static final int RMI_CRM_INFO		    	= 27;
	public static final int RMI_CCM_INFO		    	= 28;
	public static final int RMI_AQSC_DEVICE_BREED		= 29;
	
	/**************************user-data*******************/
	public static final int RMI_DATA			        = 30;
	public static final int RMI_ALARM			        = 31;
	public static final int RMI_ALERT			        = 32;
	public static final int RMI_PRO_I			        = 33;
	public static final int RMI_PRO_O			        = 34;
	public static final int RMI_PRO_L			        = 35;
	public static final int RMI_SAT_CHECK			    = 36;
	public static final int RMI_SAT_DANGER			    = 37;
	public static final int RMI_SAT_BREAK			    = 38;
	public static final int RMI_SAT_TRAIN			    = 39;
	public static final int RMI_SAT_DRILL			    = 40;
	public static final int RMI_SAT_CHECK_L			    = 41;
	public static final int RMI_SAT_TRAIN_L			    = 42;
	public static final int RMI_SAT_DRILL_L			    = 43;
	public static final int RMI_CAD_STATUS			    = 44;
	public static final int RMI_CAD_REMIND			    = 45;
	public static final int RMI_CAD_ACTION			    = 46;
	public static final int RMI_LAB_STORE			    = 47;
	public static final int RMI_LAB_STORE_I			    = 48;
	public static final int RMI_LAB_STORE_O			    = 49;
	public static final int RMI_PRO_R			        = 50;
	public static final int RMI_DEV_LIST			    = 51;
	public static final int RMI_DEV_REMIND			    = 52;
	public static final int RMI_DEV_LIST_CARD			= 53;
	public static final int RMI_SPA_STORE			    = 54;
	public static final int RMI_SPA_STORE_I			    = 55;
	public static final int RMI_SPA_STORE_O			    = 56;
	public static final int RMI_SPA_STATION			    = 57;
	public static final int RMI_SPA_STORE_L			    = 58;
	public static final int RMI_SPA_STATION_L			= 59;
	public static final int RMI_FIX_TRACE			    = 60;
	public static final int RMI_FIX_LEDGER			    = 61;
	public static final int RMI_PRO_L_CRM			    = 62;
	public static final int RMI_PRO_L_CRP			    = 63;
	public static final int RMI_P_L_CRM                 = 64;
	public static final int RMI_LAB_STORE_P 		    = 65;//新加劳保盘点表
	public static final int RMI_SPA_STORE_P 		    = 66;//新加备品盘点表
	public static final int RMI_DATE_BAO		        = 67;//新加场站日报信息表
	public static final int RMI_PRO_I_TANK		        = 68;//新加卸车储罐表
	
	
	
	public MsgBean msgBean = null;
	public String className;
	public CurrStatus currStatus = null;
	
	public RmiBean()
	{
		msgBean = new MsgBean(); 		
	}
	public String getClassName()
	{
		return className;
	}
	
	public abstract long getClassId();
	public abstract String getSql(int pCmd);
	public abstract boolean getData(ResultSet pRs);
}
