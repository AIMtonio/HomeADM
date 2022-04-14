package fira.servicio;

import credito.bean.RompimientoGrupoBean;
import fira.dao.RompimientoGrupoAgroDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class RompimientoGrupoAgroServicio extends BaseServicio {

	RompimientoGrupoAgroDAO rompimientoGrupoAgroDAO = null;

	public RompimientoGrupoAgroServicio() {
		super();
	}
		
	public static interface Enum_Transaccion {
		int rompimiento = 1;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, RompimientoGrupoBean rompimientoGrupoBean){
		MensajeTransaccionBean mensajeTransaccionBean = null;
		try{
			switch (tipoTransaccion) {		
				case Enum_Transaccion.rompimiento:
					mensajeTransaccionBean = rompimientoGrupoAgroDAO.rompimientoGrupo(rompimientoGrupoBean);					
				break;	
				default:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean.setNumero(999);
					mensajeTransaccionBean.setDescripcion("Tipo de Transacción desconocida.");
				break;
			}
		} catch(Exception exception){
			if(mensajeTransaccionBean == null){
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(999);
				mensajeTransaccionBean.setDescripcion("Ha ocurrido un Error al Grabar la Transacción");
			}
			loggerSAFI.error(mensajeTransaccionBean.getDescripcion(), exception);
			exception.printStackTrace();
		}
		return mensajeTransaccionBean;
	}

	public RompimientoGrupoAgroDAO getRompimientoGrupoAgroDAO() {
		return rompimientoGrupoAgroDAO;
	}

	public void setRompimientoGrupoAgroDAO(
			RompimientoGrupoAgroDAO rompimientoGrupoAgroDAO) {
		this.rompimientoGrupoAgroDAO = rompimientoGrupoAgroDAO;
	}
}
