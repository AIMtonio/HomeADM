package operacionesVBC.servicio;

import operacionesVBC.beanWS.request.VbcGeneraCurpRequest;
import operacionesVBC.beanWS.response.VbcGeneraCurpResponse;
import operacionesVBC.dao.VbcGeneraCurpDAO;
import general.servicio.BaseServicio;

public class VbcGeneraCurpServicio extends BaseServicio{

	VbcGeneraCurpDAO vbcGeneraCurpDAO = null;
	public VbcGeneraCurpServicio(){
		super();
	}
	
	public VbcGeneraCurpResponse generaCurpServicio(VbcGeneraCurpRequest request){
		VbcGeneraCurpResponse mensaje=null;
		  mensaje= vbcGeneraCurpDAO.generarCurp(request);
		  return mensaje;
	}
	
	public VbcGeneraCurpDAO getVbcGeneraCurpDAO() {
		return vbcGeneraCurpDAO;
	}
	public void setVbcGeneraCurpDAO(VbcGeneraCurpDAO vbcGeneraCurpDAO) {
		this.vbcGeneraCurpDAO = vbcGeneraCurpDAO;
	}	
}