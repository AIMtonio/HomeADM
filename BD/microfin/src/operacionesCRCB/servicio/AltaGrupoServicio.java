package operacionesCRCB.servicio;


import operacionesCRCB.beanWS.request.AltaGrupoRequest;
import operacionesCRCB.beanWS.response.AltaGrupoResponse;
import operacionesCRCB.dao.AltaGrupoDAO;
import general.servicio.BaseServicio;

public class AltaGrupoServicio extends BaseServicio{
	
	AltaGrupoDAO altaGrupoDAO = null;
	
	public AltaGrupoServicio (){
		super();
	}
	
	public AltaGrupoResponse altaGrupo(AltaGrupoRequest requestBean){
		
		AltaGrupoResponse response = null;
		
		response = altaGrupoDAO.altaGrupoWS(requestBean);
		
		return response;
	}

	// ========== GETTER & SETTER ============

	public AltaGrupoDAO getAltaGrupoDAO() {
		return altaGrupoDAO;
	}

	public void setAltaGrupoDAO(AltaGrupoDAO altaGrupoDAO) {
		this.altaGrupoDAO = altaGrupoDAO;
	}
}
