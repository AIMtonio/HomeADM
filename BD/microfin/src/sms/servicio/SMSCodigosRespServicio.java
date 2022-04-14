package sms.servicio;

import java.util.List;

import contabilidad.bean.DetallePolizaBean;
import contabilidad.servicio.DetallePolizaServicio.Enum_Lis_DetallePoliza;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import sms.bean.SMSCapaniasBean;
import sms.bean.SMSCodigosRespBean;
import sms.dao.SMSCodigosRespDAO;
import sms.servicio.SMSCapaniasServicio.Enum_Con_Camp;
import sms.servicio.SMSCapaniasServicio.Enum_Tra_Camp;

public class SMSCodigosRespServicio extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	SMSCodigosRespDAO smsCodigosRespDAO = null;

	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_Codigo {
		int principal		= 1;
		int porCampania		= 2;
		int codResResAct	= 3;
	}
	public static interface Enum_Tra_Codigo {
		int alta = 1;
		int modificacion = 2;
	}

	public static interface Enum_Con_Codigo {
		int principal = 1;
		int foranea =2;
	}
	
	
	public SMSCodigosRespServicio () {
		super();
		// TODO Auto-generated constructor stub
	}


		
		public SMSCodigosRespBean consulta(int tipoConsulta, SMSCodigosRespBean smsCodigosRespBean){
			SMSCodigosRespBean smsCodigosResp = null;
			switch (tipoConsulta) {
				case Enum_Con_Camp.principal:
					//smsCodigosResp = smsCodigosRespDAO.consultaPrincipal(smsCodigosRespBean, tipoConsulta);				
					break;	
			
			}
					
			return smsCodigosResp;
		}

		public List lista(int tipoLista, SMSCodigosRespBean smsCodigosRespBean){
			List codigosRespLista = null;
			switch (tipoLista) {
		        case  Enum_Lis_Codigo.principal:
		        	//codigosRespLista = smsCodigosRespDAO.lista(smsCodigosRespBean, tipoLista);
		        break;
		        case  Enum_Lis_Codigo.porCampania:
		        	codigosRespLista = smsCodigosRespDAO.listaPorCampania(smsCodigosRespBean, tipoLista);
		        break;
		        case  Enum_Lis_Codigo.codResResAct:
		        	codigosRespLista = smsCodigosRespDAO.listaCodigosResumenAct(smsCodigosRespBean, tipoLista);
		        break;		    
			}
			return codigosRespLista;
		}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	
		public SMSCodigosRespDAO getSmsCodigosRespDAO() {
			return smsCodigosRespDAO;
		}

		public void setSmsCodigosRespDAO(SMSCodigosRespDAO smsCodigosRespDAO) {
			this.smsCodigosRespDAO = smsCodigosRespDAO;
		}

	
}


