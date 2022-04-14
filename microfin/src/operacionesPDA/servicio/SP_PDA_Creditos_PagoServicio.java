package operacionesPDA.servicio;

import general.servicio.BaseServicio;
import operacionesPDA.beanWS.request.SP_PDA_Creditos_PagoRequest;
import operacionesPDA.beanWS.response.SP_PDA_Creditos_PagoResponse;
import operacionesPDA.dao.SP_PDA_Creditos_PagoDAO;

public class SP_PDA_Creditos_PagoServicio extends BaseServicio{
	SP_PDA_Creditos_PagoDAO SP_PDA_Creditos_PagoDAO = null;
	
	private SP_PDA_Creditos_PagoServicio(){
		super();
	}
	
	
	public static interface Enum_Act_Pda_WS {
		int pagoCredWSYanga	    = 1;
		int pagoCredWSWS3Reyes	= 2;

	}
	
	public SP_PDA_Creditos_PagoResponse pagoCreditoWS(SP_PDA_Creditos_PagoRequest requestBean, int tipoTransaccion){
		SP_PDA_Creditos_PagoResponse mensaje = null;
		
		switch (tipoTransaccion) {
		case Enum_Act_Pda_WS.pagoCredWSYanga:
			mensaje = SP_PDA_Creditos_PagoDAO.pagoCreditoWS(requestBean,tipoTransaccion);		
		break;
		case Enum_Act_Pda_WS.pagoCredWSWS3Reyes:
			mensaje = SP_PDA_Creditos_PagoDAO.pagoCreditoWS(requestBean,tipoTransaccion);		
		break;

		}
		return mensaje;
	}


	public SP_PDA_Creditos_PagoDAO getSP_PDA_Creditos_PagoDAO() {
		return SP_PDA_Creditos_PagoDAO;
	}


	public void setSP_PDA_Creditos_PagoDAO(
			SP_PDA_Creditos_PagoDAO sP_PDA_Creditos_PagoDAO) {
		SP_PDA_Creditos_PagoDAO = sP_PDA_Creditos_PagoDAO;
	}


	

}
