package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import soporte.bean.ParamCreditPaymentBean;
import soporte.dao.ParamCreditPaymentDAO;

public class ParamCreditPaymentServicio extends BaseServicio{
	ParamCreditPaymentDAO paramCreditPaymentDAO = null;
	
	public ParamCreditPaymentServicio (){
		super();
	}
	
	public static interface Enum_Tra_ParCredPaymet {
		int alta    = 1;
		int modifica = 2;
	}

	public static interface Enum_Con_ParCredPaymet {
		int paramCreditPaymet = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParamCreditPaymentBean paramCreditPaymentBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		switch(tipoTransaccion){
			case Enum_Tra_ParCredPaymet.alta:
				mensaje = paramCreditPaymentDAO.alta(paramCreditPaymentBean);
				break;
				
			case Enum_Tra_ParCredPaymet.modifica:
				mensaje = paramCreditPaymentDAO.modifica(paramCreditPaymentBean);
				break;
		}
		return mensaje;
	}
	
	
	public ParamCreditPaymentBean consulta(ParamCreditPaymentBean paramCreditPaymentBean, int tipoConsulta){
		ParamCreditPaymentBean paramCreditPayment= null;
		
		switch(tipoConsulta){
			case Enum_Con_ParCredPaymet.paramCreditPaymet:
				paramCreditPayment = paramCreditPaymentDAO.paramCreditPaymet(paramCreditPaymentBean, tipoConsulta);
			break;

		}
		return paramCreditPayment;
	}


	public ParamCreditPaymentDAO getParamCreditPaymentDAO() {
		return paramCreditPaymentDAO;
	}


	public void setParamCreditPaymentDAO(ParamCreditPaymentDAO paramCreditPaymentDAO) {
		this.paramCreditPaymentDAO = paramCreditPaymentDAO;
	}
	
}
