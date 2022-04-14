package operacionesCRCB.servicio;

import operacionesCRCB.beanWS.request.ActualizaClienteRequest;
import operacionesCRCB.beanWS.response.ActualizaClienteResponse;
import operacionesCRCB.dao.ActualizaClienteDAO;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import general.servicio.BaseServicio;

public class ActualizaClienteServicio extends BaseServicio{
	ActualizaClienteDAO actualizaClienteDAO = null;
	ParametrosSisServicio		parametrosSisServicio	= null;
	public ActualizaClienteServicio () {
		super();
	}
	
	public static interface Enum_Tran_Cliente {
		int actualizaCte	= 1;
	}
	
	public ActualizaClienteResponse actualizaCliente(int tipoActualizacion,ActualizaClienteRequest requestBean){
		ActualizaClienteResponse response = null;
		switch (tipoActualizacion) {
			case Enum_Tran_Cliente.actualizaCte:
				response = actualizaClienteWs(tipoActualizacion,requestBean);
				break;
			}
		return response;
	}

	
	private ActualizaClienteResponse actualizaClienteWs(int tipoActualizacion,ActualizaClienteRequest requestBean) {
		ActualizaClienteResponse response = null;
		response = actualizaClienteDAO.actualizaClienteWS(tipoActualizacion,requestBean);

		
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		parametrosSisBean.setEmpresaID("1");
		parametrosSisBean = parametrosSisServicio.consulta(1, parametrosSisBean);
		
		if(response.getCodigoRespuesta().contentEquals("0")) {
			if(parametrosSisBean.getReplicaAct().equalsIgnoreCase("S")) {
				response = actualizaClienteDAO.actualizaClienteWSReplica(tipoActualizacion, requestBean, parametrosSisBean.getOrigenReplica());
			}
		}
		
		return response;
	}
	
	// ========== GETTER & SETTER ============

	public ActualizaClienteDAO getActualizaClienteDAO() {
		return actualizaClienteDAO;
	}

	public void setActualizaClienteDAO(ActualizaClienteDAO actualizaClienteDAO) {
		this.actualizaClienteDAO = actualizaClienteDAO;
	}
	
	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
}
