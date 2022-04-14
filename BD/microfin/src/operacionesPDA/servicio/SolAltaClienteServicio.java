package operacionesPDA.servicio;

import general.servicio.BaseServicio;
import operacionesPDA.beanWS.request.SolAltaClienteRequest;
import operacionesPDA.beanWS.response.SolAltaClienteResponse;
import operacionesPDA.dao.SolAltaClienteDAO;

public class SolAltaClienteServicio extends BaseServicio{
	SolAltaClienteDAO solAltaClienteDAO = new SolAltaClienteDAO();
	
	private SolAltaClienteServicio(){
		super();
	}
	
	public SolAltaClienteResponse solAltaCliente(SolAltaClienteRequest requestBean){
		SolAltaClienteResponse response = null;
		response = solAltaClienteDAO.solAltaClienteWS(requestBean);
		return response;
	}

	public SolAltaClienteDAO getSolAltaClienteDAO() {
		return solAltaClienteDAO;
	}

	public void setSolAltaClienteDAO(SolAltaClienteDAO solAltaClienteDAO) {
		this.solAltaClienteDAO = solAltaClienteDAO;
	}
	
}
