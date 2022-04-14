package pld.servicio;

import pld.bean.PLDCNBVopeInuBean;
import pld.dao.PLDCNBVopeInuDAO;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class PLDCNBVopeInuServicio extends BaseServicio{
	
	private PLDCNBVopeInuServicio(){
		super();
	}
	PLDCNBVopeInuDAO pldCNBVopeInuDAO=null;
	
	public static interface Enum_Tra_CNBC{
		int principal   = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, PLDCNBVopeInuBean pldCNBVopeInuBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_CNBC.principal:
				mensaje = pldCNBVopeInuDAO.actualiza(pldCNBVopeInuBean, Enum_Tra_CNBC.principal);
			break;
			
		}
		return mensaje;
	}

	//------------- setter y getter
	public PLDCNBVopeInuDAO getPldCNBVopeInuDAO() {
		return pldCNBVopeInuDAO;
	}

	public void setPldCNBVopeInuDAO(PLDCNBVopeInuDAO pldCNBVopeInuDAO) {
		this.pldCNBVopeInuDAO = pldCNBVopeInuDAO;
	}
	
	
	

}
