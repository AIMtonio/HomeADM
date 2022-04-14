package ventanilla.servicio;

import ventanilla.bean.CancelacionChequesBean;
import ventanilla.dao.CancelacionChequesDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CancelacionChequesServicio extends BaseServicio {
	
	CancelacionChequesDAO cancelacionChequesDAO = null;
	public CancelacionChequesServicio(){
		super();
	}
	
	public static interface Enum_Transaccion{
		int cancelarCheque = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(CancelacionChequesBean cancelacionChequesBean, int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			switch (tipoTransaccion) {						
			case Enum_Transaccion.cancelarCheque:		
				mensaje = cancelaCheque(cancelacionChequesBean, tipoTransaccion);				
				break;
			}
		return mensaje;
	}
	
	public MensajeTransaccionBean cancelaCheque(CancelacionChequesBean cancelacionChequesBean, int tipoTransaccion ){		
		MensajeTransaccionBean mensaje = null;
	    mensaje = cancelacionChequesDAO.cancelarCheque(cancelacionChequesBean, tipoTransaccion);
		return mensaje;
	}

	public CancelacionChequesDAO getCancelacionChequesDAO() {
		return cancelacionChequesDAO;
	}

	public void setCancelacionChequesDAO(CancelacionChequesDAO cancelacionChequesDAO) {
		this.cancelacionChequesDAO = cancelacionChequesDAO;
	}
	
	
	
}