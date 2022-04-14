package operacionesPDA.servicio;

import operacionesPDA.beanWS.request.PagoCreditoRequest;
import operacionesPDA.beanWS.response.PagoCreditoResponse;
import operacionesPDA.dao.PagoCreditoDAO;

public class PagoCreditoServico {
	// PAGO DE CREDITO PARA SANA TUS FINANZAS
	public PagoCreditoDAO pagoCreditoDAO = null;
	
	public PagoCreditoServico(){
		super();
	}

	public PagoCreditoResponse pagoCreditoServcio(PagoCreditoRequest request){
		PagoCreditoResponse mensaje = null;
		mensaje = pagoCreditoDAO.pagoCreditoWS(request);
		return mensaje;
	}
	
	public PagoCreditoDAO getPagoCreditoDAO() {
		return pagoCreditoDAO;
	}

	public void setPagoCreditoDAO(PagoCreditoDAO pagoCreditoDAO) {
		this.pagoCreditoDAO = pagoCreditoDAO;
	}
	
}
