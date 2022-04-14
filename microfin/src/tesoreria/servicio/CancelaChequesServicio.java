package tesoreria.servicio;


import tesoreria.bean.CancelaChequesBean;
import tesoreria.dao.CancelaChequesDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CancelaChequesServicio extends BaseServicio{
	
	CancelaChequesDAO cancelaChequesDAO = null;
	public CancelaChequesServicio(){
		super();
	}
	
	public static interface Enum_Transaccion{
		int cancelaCheque = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(CancelaChequesBean cancelaChequesBean,int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();	
		switch (tipoTransaccion) {	
			case Enum_Transaccion.cancelaCheque:		
				mensaje = cancelacionCheque(cancelaChequesBean, tipoTransaccion);	
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean cancelacionCheque(CancelaChequesBean cancelaChequesBean,int tipoTransaccion ){		
		MensajeTransaccionBean mensaje = null;
	    mensaje = cancelaChequesDAO.cancelarChequeTeso(cancelaChequesBean);
		return mensaje;
	}

	public CancelaChequesDAO getCancelaChequesDAO() {
		return cancelaChequesDAO;
	}

	public void setCancelaChequesDAO(CancelaChequesDAO cancelaChequesDAO) {
		this.cancelaChequesDAO = cancelaChequesDAO;
	}
	
	

}
