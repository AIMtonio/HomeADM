package psl.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import psl.bean.PSLParamBrokerBean;
import psl.dao.PSLParamBrokerDAO;
import psl.dao.PSLProdBrokerDAO;

public class PSLParamBrokerServicio extends BaseServicio {
	PSLParamBrokerDAO pslParamBrokerDAO = null;
	PSLProdBrokerDAO pslProdBrokerDAO = null;
	
	public static interface Enum_Tra_ParamBroker {
		int actualizaParametro	    = 1;
	}
	
	public static interface Enum_Con_ParamBroker {
		int principal 				= 1;
	}
	
	public static interface Enum_Lis_ParamBroker {
		int principal 				= 1;
		int listaProductos			= 2;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, PSLParamBrokerBean paramBrokerBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case(Enum_Tra_ParamBroker.actualizaParametro):
				mensaje = pslParamBrokerDAO.actualizacionPrincipal(paramBrokerBean, tipoTransaccion);
				break;				
		}
				
		return mensaje;
	}
	
	public PSLParamBrokerBean consulta(int tipoConsulta, PSLParamBrokerBean paramBrokerBean){
		PSLParamBrokerBean result = null;		
		switch (tipoConsulta) {
	        case  Enum_Lis_ParamBroker.principal:
	        	result = pslParamBrokerDAO.consultaPrincipal(paramBrokerBean, tipoConsulta);
	        	break;
		}
		return result;		
	}

	public List lista(int tipoLista, PSLParamBrokerBean paramBrokerBean){
		List lista = null;
		switch(tipoLista){
			case (Enum_Lis_ParamBroker.listaProductos):
				lista = pslProdBrokerDAO.consumeListaProductosBroker(paramBrokerBean);
				break;
		}
		return lista;
	}	

	public PSLParamBrokerDAO getPslParamBrokerDAO() {
		return pslParamBrokerDAO;
	}

	public void setPslParamBrokerDAO(PSLParamBrokerDAO pslParamBrokerDAO) {
		this.pslParamBrokerDAO = pslParamBrokerDAO;
	}

	public PSLProdBrokerDAO getPslProdBrokerDAO() {
		return pslProdBrokerDAO;
	}

	public void setPslProdBrokerDAO(PSLProdBrokerDAO pslProdBrokerDAO) {
		this.pslProdBrokerDAO = pslProdBrokerDAO;
	}
}
