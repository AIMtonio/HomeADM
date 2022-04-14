package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import ventanilla.bean.OpcionesPorCajaBean;
import ventanilla.dao.OpcionesPorCajaDAO;

public class OpcionesCajaPLDServicio extends BaseServicio{
	OpcionesPorCajaDAO opcionesPorCajaDAO = null;
			
	public OpcionesCajaPLDServicio () {
		super();
		// TODO Auto-generated constructor stub
	}	
	public static interface Enum_Tra_OpcionPorCajaPLD{
		int actualizar =1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(OpcionesPorCajaBean opcionesPorCajaBean, int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
		case Enum_Tra_OpcionPorCajaPLD.actualizar:
			mensaje = opcionesPorCajaDAO.actualizaOpcPLD(opcionesPorCajaBean, tipoTransaccion);
			break;
		}
		return mensaje;
	}		
		
	//---------------Getter y Setter-------------
	public OpcionesPorCajaDAO getOpcionesPorCajaDAO() {
		return opcionesPorCajaDAO;
	}

	public void setOpcionesPorCajaDAO(OpcionesPorCajaDAO opcionesPorCajaDAO) {
		this.opcionesPorCajaDAO = opcionesPorCajaDAO;
	}


}
