package psl.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import psl.bean.PSLConfigServicioBean;
import psl.bean.PSLProdBrokerBean;
import psl.dao.PSLConfigServicioDAO;
import psl.dao.PSLProdBrokerDAO;

public class PSLConfigServicioServicio extends BaseServicio {
	PSLConfigServicioDAO pslConfigServicioDAO;
	PSLProdBrokerDAO pslProdBrokerDAO;
	
	public static interface Enum_Tra_PSLConfigServicio {		
		int actualizaConfiguracionServicio 	= 1;
		int actualizaCatalogoProductos	    = 2;
	}
	
	public static interface Enum_Con_PSLConfigServicio {
		int principal 				= 1;
	}
	
	public static interface Enum_Lis_PSLConfigServicio {
		int ListaDescripcionServicio 				= 1;
		int listaTiposServicio						= 2;
		int listaServicios							= 4;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, PSLConfigServicioBean pslConfigServicioBean){
		loggerSAFI.info("PSLConfigServicioServicio.grabaTransaccion");

		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_PSLConfigServicio.actualizaConfiguracionServicio:
				mensaje = pslConfigServicioDAO.actualizaConfiguracionServicio(pslConfigServicioBean, tipoTransaccion);
				break;
	        case  Enum_Tra_PSLConfigServicio.actualizaCatalogoProductos:
	        	mensaje = pslProdBrokerDAO.actualizaCatalogoProductos(new PSLProdBrokerBean());
	        	break;
		}
		return mensaje;
	}
	
	public PSLConfigServicioBean consulta(int tipoConsulta, PSLConfigServicioBean pslConfigServicioBean) {
		loggerSAFI.info("PSLConfigServicioServicio.consulta");

		PSLConfigServicioBean result = null;		
		switch (tipoConsulta) {
	        case  Enum_Con_PSLConfigServicio.principal:
	        	result = pslConfigServicioDAO.consultaConfiguracionServicio(pslConfigServicioBean, tipoConsulta);
	        	break;
		}
		
		return result;		
	}

	public List lista(int tipoLista, PSLConfigServicioBean pslConfigServicioBean) {
		loggerSAFI.info("PSLConfigServicioServicio.lista");

		List listaConfiguracionServicios = null;
		switch(tipoLista){
			case (Enum_Lis_PSLConfigServicio.ListaDescripcionServicio): 
				listaConfiguracionServicios = pslConfigServicioDAO.listaDescripcionServicio(pslConfigServicioBean, tipoLista);
				break;
			case (Enum_Lis_PSLConfigServicio.listaTiposServicio):
				listaConfiguracionServicios = pslConfigServicioDAO.listaTiposServicio(pslConfigServicioBean, tipoLista);
				break;
			case (Enum_Lis_PSLConfigServicio.listaServicios):
				listaConfiguracionServicios = pslConfigServicioDAO.listaServicios(pslConfigServicioBean, tipoLista);
				break;
		}
		return listaConfiguracionServicios;
	}

	public PSLConfigServicioDAO getPslConfigServicioDAO() {
		return pslConfigServicioDAO;
	}

	public void setPslConfigServicioDAO(PSLConfigServicioDAO pslConfigServicioDAO) {
		this.pslConfigServicioDAO = pslConfigServicioDAO;
	}

	public PSLProdBrokerDAO getPslProdBrokerDAO() {
		return pslProdBrokerDAO;
	}

	public void setPslProdBrokerDAO(PSLProdBrokerDAO pslProdBrokerDAO) {
		this.pslProdBrokerDAO = pslProdBrokerDAO;
	}
}
