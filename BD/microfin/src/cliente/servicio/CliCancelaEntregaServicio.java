package cliente.servicio;

import java.util.List;
import general.servicio.BaseServicio;
import cliente.bean.CliCancelaEntregaBean;
import cliente.dao.CliCancelaEntregaDAO;


public class CliCancelaEntregaServicio extends BaseServicio {
	
	// Variables 
	CliCancelaEntregaDAO cliCancelaEntregaDAO = null;
		
	public static interface Enum_Lis_CliCancelaEntregaBean {
		int porFolioCancel	= 1;
	}
	
	public CliCancelaEntregaServicio() {
		super();
	}
	
	public List lista(int tipoLista, CliCancelaEntregaBean cliCancelaEntregaBean){
		List listaClientesEntrega = null;
		switch (tipoLista) {
	        case  Enum_Lis_CliCancelaEntregaBean.porFolioCancel:
	        	listaClientesEntrega = cliCancelaEntregaDAO.listaPorFolio(cliCancelaEntregaBean, tipoLista);
	        break;	        
		}
		return listaClientesEntrega;
	}

	
	
	//------------------ Getters y Setters ------------------------------------------------------	
	public CliCancelaEntregaDAO getCliCancelaEntregaDAO() {
		return cliCancelaEntregaDAO;
	}

	public void setCliCancelaEntregaDAO(CliCancelaEntregaDAO cliCancelaEntregaDAO) {
		this.cliCancelaEntregaDAO = cliCancelaEntregaDAO;
	}
		
}

