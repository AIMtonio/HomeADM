package cliente.servicio;

import cliente.bean.ConvenSecPreinsBean;
import cliente.bean.ConvencionSeccionalBean;
import cliente.dao.ConvenSecPreinsDAO;
import cliente.servicio.ConvencionSeccionalServicio.Enum_Con_ConvencionSeccional;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ConvenSecPreinsServicio extends BaseServicio{
	ConvenSecPreinsDAO convenSecPreinsDAO = null;
	
	public ConvenSecPreinsServicio(){
		super();
	}
	
	public static interface Enum_Tra_ConvenSecPreins {
		int alta =1;
		int altaIns =2;
	}
	public static interface Enum_Con_ConvenSecPreins{
		int consultaCantPre = 1;
		int consultaCantIns = 2;
	}

	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ConvenSecPreinsBean convenSecPreins){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){		
	    	case Enum_Tra_ConvenSecPreins.alta:
	    		mensaje = convenSecPreinsDAO.altaConvenSecPreins(convenSecPreins);
	    		break;
	    	case Enum_Tra_ConvenSecPreins.altaIns:
	    		mensaje = convenSecPreinsDAO.altaConvenSecIns(convenSecPreins);
	    		break;
	    	
		}
		return mensaje;
	}
	
	public ConvenSecPreinsBean consulta(int tipoConsulta, ConvenSecPreinsBean convenSecPreins){
		ConvenSecPreinsBean convenSecPreinsBean = null;
		switch (tipoConsulta) {
		
			case Enum_Con_ConvenSecPreins.consultaCantPre:		
				convenSecPreinsBean = convenSecPreinsDAO.consultaCantPre(convenSecPreins, tipoConsulta);				
				break;
			case Enum_Con_ConvenSecPreins.consultaCantIns:		
				convenSecPreinsBean = convenSecPreinsDAO.consultaCantIns(convenSecPreins, tipoConsulta);				
				break;
	
		}
				
		return convenSecPreinsBean;
	}
	
	
	/* setters y getters*/
	public ConvenSecPreinsDAO getConvenSecPreinsDAO() {
		return convenSecPreinsDAO;
	}


	public void setConvenSecPreinsDAO(ConvenSecPreinsDAO convenSecPreinsDAO) {
		this.convenSecPreinsDAO = convenSecPreinsDAO;
	}

	
}
