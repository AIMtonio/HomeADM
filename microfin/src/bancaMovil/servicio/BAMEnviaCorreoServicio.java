package bancaMovil.servicio;

import bancaMovil.bean.BAMEnviaCorreoBean;
import bancaMovil.dao.BAMEnviaCorreoDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class BAMEnviaCorreoServicio extends BaseServicio{
	BAMEnviaCorreoDAO correoDAO=null;
	
	public MensajeTransaccionBean altaCorreo(BAMEnviaCorreoBean correoBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = correoDAO.altaCorreo(correoBean);		
		return mensaje;
	}

	public BAMEnviaCorreoDAO getCorreoDAO() {
		return correoDAO;
	}

	public void setCorreoDAO(BAMEnviaCorreoDAO correoDAO) {
		this.correoDAO = correoDAO;
	}

	
}
