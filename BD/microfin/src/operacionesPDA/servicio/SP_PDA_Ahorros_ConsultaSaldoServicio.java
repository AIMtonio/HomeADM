package operacionesPDA.servicio;

import general.servicio.BaseServicio;
import operacionesPDA.beanWS.request.SP_PDA_Ahorros_ConsultaSaldoRequest;
import operacionesPDA.beanWS.response.SP_PDA_Ahorros_ConsultaSaldoResponse;
import operacionesPDA.dao.SP_PDA_Ahorros_ConsultaSaldoDAO;

public class SP_PDA_Ahorros_ConsultaSaldoServicio  extends BaseServicio{

	  SP_PDA_Ahorros_ConsultaSaldoDAO sP_PDA_Ahorros_ConsultaSaldoDAO =null;
	  
	  public SP_PDA_Ahorros_ConsultaSaldoServicio(){
		  super();
	  }
	  
		public static interface Enum_Lis_Consulta{
			int consulta =25;      
		}
	  
	  public SP_PDA_Ahorros_ConsultaSaldoResponse consultaSaldoServicio(SP_PDA_Ahorros_ConsultaSaldoRequest request){
		  SP_PDA_Ahorros_ConsultaSaldoResponse mensaje=null;
		  mensaje=sP_PDA_Ahorros_ConsultaSaldoDAO.consultaSaldoWS(request, Enum_Lis_Consulta.consulta);
		  return mensaje;
	  }

	public SP_PDA_Ahorros_ConsultaSaldoDAO getsP_PDA_Ahorros_ConsultaSaldoDAO() {
		return sP_PDA_Ahorros_ConsultaSaldoDAO;
	}

	public void setsP_PDA_Ahorros_ConsultaSaldoDAO(
			SP_PDA_Ahorros_ConsultaSaldoDAO sP_PDA_Ahorros_ConsultaSaldoDAO) {
		this.sP_PDA_Ahorros_ConsultaSaldoDAO = sP_PDA_Ahorros_ConsultaSaldoDAO;
	}
	  



}
