package soporte.servicio;

import java.util.List;

import general.servicio.BaseServicio;
import general.bean.MensajeTransaccionBean;

import soporte.bean.EdoCtaParamsBean;
import soporte.dao.EdoCtaParamsDAO;




public class EdoCtaParamsServicio extends BaseServicio {
	EdoCtaParamsDAO edoCtaParamsDAO=null;

	private EdoCtaParamsServicio(){
		super();		
	}
	
	public static interface Enum_Tra_EdoCtaParams{		
		int modificacion			= 1;		
	}
	
	public static interface Enum_Con_EdoCtaParams{
		int consultaPrincipal      = 1;
	}
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, EdoCtaParamsBean edoCtaParamsBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){			    	
	    	case Enum_Tra_EdoCtaParams.modificacion:
				mensaje = edoCtaParamsDAO.modificarEdoCtaParams(edoCtaParamsBean);
				break;	    
		}
		return mensaje;
	}
	
	public EdoCtaParamsBean consulta(int tipoConsulta){
		EdoCtaParamsBean edoCtaParams = null;
		switch (tipoConsulta) {
			case  Enum_Con_EdoCtaParams.consultaPrincipal:
				edoCtaParams = edoCtaParamsDAO.consultaPrincipal(tipoConsulta);
				break;				
		}
		return edoCtaParams;
	}	
	
	public EdoCtaParamsDAO getEdoCtaParamsDAO() {
		return edoCtaParamsDAO;
	}
	public void setEdoCtaParamsDAO(EdoCtaParamsDAO edoCtaParamsDAO) {
		this.edoCtaParamsDAO = edoCtaParamsDAO;
	}
	
	
	
}
