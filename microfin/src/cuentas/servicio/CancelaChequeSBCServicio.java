package cuentas.servicio;

import java.util.List;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cuentas.dao.CancelaChequeSBCDAO;
import cuentas.dao.CuentasAhoMovDAO;
import cuentas.bean.CancelaChequeSBCBean;
import cuentas.bean.CuentasAhoMovBean;
public class CancelaChequeSBCServicio extends BaseServicio {
	//::::::::::::variables::::::::::::::::::::
	CancelaChequeSBCDAO cancelaChequeSBCDAO = null;

	
	public static interface Enum_Tra_CancelaCheques {
		int actualiza = 1;

	}
	
	private CancelaChequeSBCServicio(){
		super();
	}
	

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CancelaChequeSBCBean  request){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_CancelaCheques.actualiza:
			mensaje = actualizaCancelaCheques(request);
			break; 
	
		}

		return mensaje;
	}

	public MensajeTransaccionBean actualizaCancelaCheques(CancelaChequeSBCBean cancela){
		MensajeTransaccionBean mensaje = null;
		mensaje = cancelaChequeSBCDAO.cancelaCheque(cancela);	
		return mensaje;
	}
	

	//.....GETTER....AND.....SETTER........ 
		
	public CancelaChequeSBCDAO getCancelaChequeSBCDAO() {
		return cancelaChequeSBCDAO;
	}


	public void setCancelaChequeSBCDAO(CancelaChequeSBCDAO cancelaChequeSBCDAO) {
		this.cancelaChequeSBCDAO = cancelaChequeSBCDAO;
	}

}
