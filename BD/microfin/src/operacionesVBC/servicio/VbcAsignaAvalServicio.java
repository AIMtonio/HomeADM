package operacionesVBC.servicio;

import operacionesVBC.beanWS.request.VbcAsignaAvalRequest;
import operacionesVBC.beanWS.response.VbcAsignaAvalResponse;
import operacionesVBC.dao.VbcAsignaAvalDAO;
import general.servicio.BaseServicio;

public class VbcAsignaAvalServicio extends BaseServicio{

	VbcAsignaAvalDAO vbcAsignaAvalDAO = null;
	public VbcAsignaAvalServicio(){
		super();
	}
	
	public VbcAsignaAvalResponse asignaAvales(VbcAsignaAvalRequest request){
		VbcAsignaAvalResponse mensaje=null;
		mensaje= vbcAsignaAvalDAO.procesoReferencia(request);
		return mensaje;
	}

	public VbcAsignaAvalDAO getVbcAsignaAvalDAO() {
		return vbcAsignaAvalDAO;
	}

	public void setVbcAsignaAvalDAO(VbcAsignaAvalDAO vbcAsignaAvalDAO) {
		this.vbcAsignaAvalDAO = vbcAsignaAvalDAO;
	}
	
	
}