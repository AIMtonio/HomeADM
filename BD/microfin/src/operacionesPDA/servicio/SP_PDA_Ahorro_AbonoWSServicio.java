package operacionesPDA.servicio;

import general.servicio.BaseServicio;
import operacionesPDA.beanWS.request.SP_PDA_Ahorros_AbonoRequest;
import operacionesPDA.beanWS.response.SP_PDA_Ahorros_AbonoResponse;
import operacionesPDA.dao.SP_PDA_Ahorro_AbonoWSDAO;

public class SP_PDA_Ahorro_AbonoWSServicio extends BaseServicio{
	SP_PDA_Ahorro_AbonoWSDAO sP_PDA_Ahorro_AbonoWSDAO = null;
	
	private SP_PDA_Ahorro_AbonoWSServicio(){
		super();
	}
	
	public static interface Enum_Act_Pda_WS {
		int ahorroAbonoWSYanga	= 1;
		int ahorroAbonoWS3Reyes	= 2;

	}
	
	
	public SP_PDA_Ahorros_AbonoResponse actualizacion(SP_PDA_Ahorros_AbonoRequest requestBean, int tipoActualizacion){
		SP_PDA_Ahorros_AbonoResponse mensaje = null;
		switch (tipoActualizacion) {
		case Enum_Act_Pda_WS.ahorroAbonoWSYanga:
		mensaje = sP_PDA_Ahorro_AbonoWSDAO.abonoCuentaWS(requestBean, tipoActualizacion);
		break;
		case Enum_Act_Pda_WS.ahorroAbonoWS3Reyes:
		mensaje = sP_PDA_Ahorro_AbonoWSDAO.abonoCuentaWS(requestBean, tipoActualizacion);
		break;

		}
		return mensaje;
	}


	public SP_PDA_Ahorro_AbonoWSDAO getsP_PDA_Ahorro_AbonoWSDAO() {
		return sP_PDA_Ahorro_AbonoWSDAO;
	}
	public void setsP_PDA_Ahorro_AbonoWSDAO(
			SP_PDA_Ahorro_AbonoWSDAO sP_PDA_Ahorro_AbonoWSDAO) {
		this.sP_PDA_Ahorro_AbonoWSDAO = sP_PDA_Ahorro_AbonoWSDAO;
	}

}
