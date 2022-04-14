package operacionesVBC.servicio;

import operacionesVBC.beanWS.request.VbcGeneraRFCRequest;
import operacionesVBC.beanWS.response.VbcGeneraRFCResponse;
import operacionesVBC.dao.VbcGeneraRFCDAO;
import general.servicio.BaseServicio;

public class VbcGeneraRFCServicio extends BaseServicio{

	VbcGeneraRFCDAO vbcGeneraRFCDAO = null;
	public VbcGeneraRFCServicio(){
		super();
	}
	
	public VbcGeneraRFCResponse generaRFCServicio(VbcGeneraRFCRequest request){
		VbcGeneraRFCResponse mensaje=null;
		  mensaje= vbcGeneraRFCDAO.generaRFC(request);
		  return mensaje;
	}

	public VbcGeneraRFCDAO getVbcGeneraRFCDAO() {
		return vbcGeneraRFCDAO;
	}

	public void setVbcGeneraRFCDAO(VbcGeneraRFCDAO vbcGeneraRFCDAO) {
		this.vbcGeneraRFCDAO = vbcGeneraRFCDAO;
	}	
}