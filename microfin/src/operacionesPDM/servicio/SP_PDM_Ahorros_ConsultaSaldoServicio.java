package operacionesPDM.servicio;

import operacionesPDM.beanWS.request.SP_PDM_Ahorros_ConsultaSaldoRequest;
import operacionesPDM.beanWS.response.SP_PDM_Ahorros_ConsultaSaldoResponse;
import operacionesPDM.dao.SP_PDM_Ahorros_ConsultaSaldoDAO;
import general.servicio.BaseServicio;

public class SP_PDM_Ahorros_ConsultaSaldoServicio extends BaseServicio {
	
	SP_PDM_Ahorros_ConsultaSaldoDAO sP_PDM_Ahorros_ConsultaSaldoDAO =null;
	
	public SP_PDM_Ahorros_ConsultaSaldoServicio(){
		super();
	}
	
	public static interface Enum_Lis_Consulta{
		int consulta =25;      
	}
  
	public SP_PDM_Ahorros_ConsultaSaldoResponse consultaSaldoServicio(SP_PDM_Ahorros_ConsultaSaldoRequest request){
		SP_PDM_Ahorros_ConsultaSaldoResponse mensaje=null;
		mensaje=sP_PDM_Ahorros_ConsultaSaldoDAO.consultaSaldoWS(request, Enum_Lis_Consulta.consulta);
		return mensaje;
	}

	public SP_PDM_Ahorros_ConsultaSaldoDAO getSP_PDM_Ahorros_ConsultaSaldoDAO() {
		return sP_PDM_Ahorros_ConsultaSaldoDAO;
	}
	
	public void setSP_PDM_Ahorros_ConsultaSaldoDAO(SP_PDM_Ahorros_ConsultaSaldoDAO sP_PDM_Ahorros_ConsultaSaldoDAO) {
		this.sP_PDM_Ahorros_ConsultaSaldoDAO = sP_PDM_Ahorros_ConsultaSaldoDAO;
	}

}
