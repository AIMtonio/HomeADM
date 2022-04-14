package sms.servicio;

import java.util.ArrayList;
import java.util.List;
import sms.bean.SMSTiposCampaniasBean;
import sms.dao.SMSTiposCampaniasDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;


public class SMSTiposCampaniasServicio extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	SMSTiposCampaniasDAO smsTiposCampaniasDAO = null;

	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_TCamp {
		int principal   = 1;
	}
	public static interface Enum_Tra_TCamp {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_TCamp {
		int principal = 1;
		int foranea =2;
	}
	public SMSTiposCampaniasServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	// Transacciones
		public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SMSTiposCampaniasBean smsTiposCampaniasBean) {
			MensajeTransaccionBean mensaje = null;
			switch(tipoTransaccion){
			case Enum_Tra_TCamp.alta:
				mensaje = altaTipoCampania(smsTiposCampaniasBean);	
				break;	
			case Enum_Tra_TCamp.modificacion:
				mensaje = modificaTipoCampaña(smsTiposCampaniasBean);				
				break;
			case Enum_Tra_TCamp.baja:
				mensaje = bajaTiposCampania(smsTiposCampaniasBean);				
				break;
			}
			return mensaje;
		}
		
		// Alta de Tipos de Campaña sms
		public MensajeTransaccionBean altaTipoCampania(SMSTiposCampaniasBean smsTiposCampaniasBean){
			MensajeTransaccionBean mensaje = null;
			mensaje = smsTiposCampaniasDAO.altaTipoCampania(smsTiposCampaniasBean);
			return mensaje;
		}
		
		public MensajeTransaccionBean modificaTipoCampaña(SMSTiposCampaniasBean smsTiposCampaniasBean){
			MensajeTransaccionBean mensaje = null;
			mensaje = smsTiposCampaniasDAO.modificaTipoCampaña(smsTiposCampaniasBean);		
			return mensaje;
		}
		
		public MensajeTransaccionBean bajaTiposCampania(SMSTiposCampaniasBean smsTiposCampaniasBean){
			MensajeTransaccionBean mensaje = null;
			mensaje = smsTiposCampaniasDAO.bajaTiposCampania(smsTiposCampaniasBean);		
			return mensaje;
		}

	// consulta de tipos de campanias
	public SMSTiposCampaniasBean consulta(int tipoConsulta, SMSTiposCampaniasBean smsTiposCampaniasBean){
		SMSTiposCampaniasBean smsTiposCampanias = null;
		switch (tipoConsulta) {
			case Enum_Con_TCamp.principal:
				smsTiposCampanias = smsTiposCampaniasDAO.consultaPrincipal(smsTiposCampaniasBean, tipoConsulta);				
				break;	
			case Enum_Con_TCamp.foranea:
				smsTiposCampanias = smsTiposCampaniasDAO.consultaForanea(smsTiposCampaniasBean, tipoConsulta);				
				break;	
		
		}
				
		return smsTiposCampanias;
	}

	// Lista de tipos de campaña
	public List lista(int tipoLista, SMSTiposCampaniasBean smsTiposCampaniasBean){		
		List listaTiposCampanias = null;
		switch (tipoLista) {
			case Enum_Lis_TCamp.principal:		
				listaTiposCampanias = smsTiposCampaniasDAO.listaPrincipal(smsTiposCampaniasBean, tipoLista);				
				break;				
		}		
		return listaTiposCampanias;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public SMSTiposCampaniasDAO getSmsTiposCampaniasDAO() {
		return smsTiposCampaniasDAO;
	}


	public void setSmsTiposCampaniasDAO(SMSTiposCampaniasDAO smsTiposCampaniasDAO) {
		this.smsTiposCampaniasDAO = smsTiposCampaniasDAO;
	}
	
}
