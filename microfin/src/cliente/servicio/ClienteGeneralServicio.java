package cliente.servicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import cliente.bean.ClienteGeneralBean;
import cliente.dao.ClienteGeneralDAO;
import general.servicio.BaseServicio;

public class ClienteGeneralServicio extends BaseServicio {
	
	private ClienteGeneralDAO clienteGeneralDAO = null;
	
	public static interface Enum_Lis {
		int principal = 1;
	}
	
	public List lista(int tipoLista, ClienteGeneralBean clienteGeneralBean, HttpServletResponse response) {
		List lista = new ArrayList();
		switch(tipoLista){		
			case Enum_Lis.principal:
				lista = clienteGeneralDAO.listaPrincipal(clienteGeneralBean); 
				break;	
		}
		return lista;
	}

	public ClienteGeneralDAO getClienteGeneralDAO() {
		return clienteGeneralDAO;
	}

	public void setClienteGeneralDAO(ClienteGeneralDAO clienteGeneralDAO) {
		this.clienteGeneralDAO = clienteGeneralDAO;
	}
}
