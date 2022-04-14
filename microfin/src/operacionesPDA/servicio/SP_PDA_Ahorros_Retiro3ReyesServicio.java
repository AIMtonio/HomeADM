package operacionesPDA.servicio;

import general.servicio.BaseServicio;
import operacionesPDA.beanWS.request.SP_PDA_Ahorros_Retiro3ReyesRequest;
import operacionesPDA.beanWS.response.SP_PDA_Ahorros_Retiro3ReyesResponse;
import operacionesPDA.dao.SP_PDA_Ahorros_Retiro3ReyesDAO;
 
public class SP_PDA_Ahorros_Retiro3ReyesServicio extends BaseServicio{

	SP_PDA_Ahorros_Retiro3ReyesDAO sp_PDA_Ahorros_Retiro3ReyesDAO = null;
		
		private SP_PDA_Ahorros_Retiro3ReyesServicio(){
			super();
		}
		
		
		
public SP_PDA_Ahorros_Retiro3ReyesResponse retiro(SP_PDA_Ahorros_Retiro3ReyesRequest requestBean){
		SP_PDA_Ahorros_Retiro3ReyesResponse mensaje = null;
		mensaje = sp_PDA_Ahorros_Retiro3ReyesDAO.retiroCuentaWS(requestBean);		
		return mensaje;
}


public SP_PDA_Ahorros_Retiro3ReyesDAO getSp_PDA_Ahorros_Retiro3ReyesDAO() {
	return sp_PDA_Ahorros_Retiro3ReyesDAO;
}


public void setSp_PDA_Ahorros_Retiro3ReyesDAO(
		SP_PDA_Ahorros_Retiro3ReyesDAO sp_PDA_Ahorros_Retiro3ReyesDAO) {
	this.sp_PDA_Ahorros_Retiro3ReyesDAO = sp_PDA_Ahorros_Retiro3ReyesDAO;
  }
}

