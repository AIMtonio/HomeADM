package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import soporte.bean.IndiceNaPreConsumidorBean;
import soporte.dao.IndiceNaPreConsumidorDAO;

public class IndiceNaPreConsumidorServicio extends BaseServicio{

	IndiceNaPreConsumidorDAO indiceNaPreConsumidorDAO = null;
	
	private IndiceNaPreConsumidorServicio(){
		super();		
	}
	
	// Transacciones Indice Nacional de Precios al Consumidor
	public static interface Enum_Tra_IndiceNaPreConsumidor{		
		int alta			= 1;		
		int modifica		= 2;		
	}
	
	// Consulta Indice Nacional de Precios al Consumidor
	public static interface Enum_Con_IndiceNaPreConsumidor{
		int consultaPrincipal      = 1;
	}
	
	// Lista Indice Nacional de Precios al Consumidor
	public static interface Enum_Lis_IndiceNaPreConsumidor{
		int listaPrincipal      = 1;
	}
	
	// Transacciones Indice Nacional de Precios al Consumidor
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, IndiceNaPreConsumidorBean bean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){			    	
	    	case Enum_Tra_IndiceNaPreConsumidor.alta:
				mensaje = indiceNaPreConsumidorDAO.registroIndiceNaPreConsumidor(bean);
			break;	    		    	
	    	case Enum_Tra_IndiceNaPreConsumidor.modifica:
				mensaje = indiceNaPreConsumidorDAO.modificaIndiceNaPreConsumidor(bean);
			break;	    
		}
		return mensaje;
	}
	
	// Consulta Indice Nacional de Precios al Consumidor
	public IndiceNaPreConsumidorBean consulta(int tipoConsulta,IndiceNaPreConsumidorBean bean){
		IndiceNaPreConsumidorBean indiceNaPreConsumidor = null;	
		switch (tipoConsulta) {
			case  Enum_Con_IndiceNaPreConsumidor.consultaPrincipal:
				indiceNaPreConsumidor = indiceNaPreConsumidorDAO.consultaPrincipal(tipoConsulta,bean);
			break;				
		}
		return indiceNaPreConsumidor;
	}		
				
	/* ============ SETTER's Y GETTER's =============== */	
	public IndiceNaPreConsumidorDAO getIndiceNaPreConsumidorDAO() {
		return indiceNaPreConsumidorDAO;
	}

	public void setIndiceNaPreConsumidorDAO(
			IndiceNaPreConsumidorDAO indiceNaPreConsumidorDAO) {
		this.indiceNaPreConsumidorDAO = indiceNaPreConsumidorDAO;
	}
}