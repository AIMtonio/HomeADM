package tarjetas.servicio;

import java.util.List;

import general.servicio.BaseServicio;
import general.bean.MensajeTransaccionBean;

import soporte.servicio.EdoCtaParamsServicio.Enum_Con_EdoCtaParams;
import soporte.servicio.EdoCtaParamsServicio.Enum_Tra_EdoCtaParams;

import tarjetas.bean.EdoCtaParamsTarBean;
import tarjetas.dao.EdoCtaParamsTarDAO;

public class EdoCtaParamsTarServicio extends BaseServicio {
	
	EdoCtaParamsTarDAO edoCtaParamsTarDAO=null;
	
	private EdoCtaParamsTarServicio(){
		super();
	}
	
	public static interface Enum_Tra_EdoCtaParamsTar{		
		int modificacion			= 1;		
	}
	
	public static interface Enum_Con_EdoCtaParamsTar{
		int consultaPrincipal      = 2;
	}
	
	//metodos para llamar al dao.
	//...
	//...
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, EdoCtaParamsTarBean edoCtaParamsTarBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){			    	
	    	case Enum_Tra_EdoCtaParamsTar.modificacion:
				mensaje = edoCtaParamsTarDAO.modificarEdoCtaParamsTar(edoCtaParamsTarBean);
				break;	    
		}
		return mensaje;
	}
	
	public EdoCtaParamsTarBean consulta(int tipoConsulta){
		EdoCtaParamsTarBean edoCtaParamsTar = null;
		switch (tipoConsulta) {
			case  Enum_Con_EdoCtaParamsTar.consultaPrincipal:
				edoCtaParamsTar = edoCtaParamsTarDAO.consultaPrincipal(tipoConsulta);
				break;				
		}
		return edoCtaParamsTar;
	}
	
	public EdoCtaParamsTarDAO getEdoCtaParamsTarDAO() {
		return edoCtaParamsTarDAO;
	}
	public void setEdoCtaParamsTarDAO(EdoCtaParamsTarDAO edoCtaParamsTarDAO) {
		this.edoCtaParamsTarDAO = edoCtaParamsTarDAO;
	}
	
}
