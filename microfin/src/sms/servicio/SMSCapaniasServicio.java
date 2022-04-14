package sms.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import sms.bean.SMSCapaniasBean;
import sms.bean.SMSCodigosRespBean;
import sms.dao.SMSCapaniasDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class SMSCapaniasServicio extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	SMSCapaniasDAO smsCapaniasDAO = null;

	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_Camp {
		int principal   = 1;
		int clasSalidaCatCampaña = 2; // clasificacion=salida categoria=campaña
	}
	public static interface Enum_Tra_Camp {
		int alta = 1;
		int modificacion = 2;
		int grabarLista = 3;
		int elimina = 4;
		int modificacionLista = 5;
		int eliminarLista = 6;
	}

	public static interface Enum_Con_Camp {
		int principal = 1;
		int foranea =2;
		 int prinSalCamp=4;
	}
	
	public SMSCapaniasServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	// Transacciones
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SMSCapaniasBean smsCapaniasBean, String codigosResp) {
		MensajeTransaccionBean mensaje = null;
		ArrayList listaCodigosResp = (ArrayList) creaListaCodigos(codigosResp);
		switch(tipoTransaccion){		
		case Enum_Tra_Camp.grabarLista:
			mensaje = smsCapaniasDAO.grabaListaCodigosResp(smsCapaniasBean,listaCodigosResp);	
			break;
		
		case Enum_Tra_Camp.modificacionLista:
			mensaje = smsCapaniasDAO.modificaListaCodigosResp(smsCapaniasBean,listaCodigosResp);		
			break;
		case Enum_Tra_Camp.eliminarLista:
			mensaje = smsCapaniasDAO.eliminarListaCodigosResp(smsCapaniasBean,listaCodigosResp);		
			break;
		}
		return mensaje;
	}

		public SMSCapaniasBean consulta(int tipoConsulta, SMSCapaniasBean smsCapaniasBean){
			SMSCapaniasBean smsCapanias = null;
			switch (tipoConsulta) {
				case Enum_Con_Camp.principal:
					smsCapanias = smsCapaniasDAO.consultaPrincipal(smsCapaniasBean, tipoConsulta);				
					break;
				case Enum_Con_Camp.prinSalCamp:
					smsCapanias = smsCapaniasDAO.consultaPrincipal(smsCapaniasBean, tipoConsulta);				
					break;	
				case Enum_Con_Camp.foranea:
					smsCapanias = smsCapaniasDAO.consultaForanea(smsCapaniasBean, tipoConsulta);				
					break;
			}
					
			return smsCapanias;
		}

		
		private List creaListaCodigos(String codigosResp){		
			StringTokenizer tokensBean = new StringTokenizer(codigosResp, "[");
			String stringCampos;
			String tokensCampos[];
			ArrayList listaCodigosResp = new ArrayList();
			SMSCodigosRespBean smsCodigosRespBean;
			
			while(tokensBean.hasMoreTokens()){
				smsCodigosRespBean = new SMSCodigosRespBean();
				
				stringCampos = tokensBean.nextToken();		
				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
	
				smsCodigosRespBean.setCodigoRespID(tokensCampos[0]);
				smsCodigosRespBean.setDescripcion(tokensCampos[1]);
								
				listaCodigosResp.add(smsCodigosRespBean);
			
			}			
			return listaCodigosResp;
		}
		
		// Lista de campañas
		public List lista(int tipoLista, SMSCapaniasBean smsCapaniasBean){		
			List listaCampanias = null;
			switch (tipoLista) {
				case Enum_Lis_Camp.principal:		
					listaCampanias = smsCapaniasDAO.listaPrincipal(smsCapaniasBean, tipoLista);				
					break;	
					//para pantalla escribir SMS solo clasificacion=SALIDA categoria=CAMPAÑA
				case Enum_Lis_Camp.clasSalidaCatCampaña: 
					listaCampanias = smsCapaniasDAO.listaPrincipal(smsCapaniasBean, Enum_Lis_Camp.clasSalidaCatCampaña);				
					break;	
			}		
			return listaCampanias;
		}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	
		public SMSCapaniasDAO getSmsCapaniasDAO() {
			return smsCapaniasDAO;
		}

		public void setSmsCapaniasDAO(SMSCapaniasDAO smsCapaniasDAO) {
			this.smsCapaniasDAO = smsCapaniasDAO;
		}

	
}
