package sms.servicio;

import sms.bean.ParametrosSMSBean;
import sms.dao.ParametrosSMSDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ParametrosSMSServicio extends BaseServicio{

	ParametrosSMSDAO parametrosSMSDAO = null;
	
	public ParametrosSMSServicio(){
		super();
	}
	

	public static interface Enum_Tra_Param{
		int modificacion		= 1;
	}
	public static interface Enum_Con_Param{
		int principal 	= 1;
		int conNumInt1  = 3;
		int conRuta 	= 4;
		int principalWS = 5;
	}
	


	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParametrosSMSBean parametrosSMSBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {				
			case Enum_Tra_Param.modificacion:
				mensaje = modificaParametrosSMS(parametrosSMSBean);				
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean modificaParametrosSMS(ParametrosSMSBean parametrosSMSBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = parametrosSMSDAO.modificaParametrosSMS(parametrosSMSBean);		
		return mensaje;
	}
	
	public ParametrosSMSBean consulta(int tipoConsulta,ParametrosSMSBean parametrosSMSBean){
		ParametrosSMSBean paramSms = null;
		switch(tipoConsulta){
		case Enum_Con_Param.principal:
			paramSms = parametrosSMSDAO.consultaPrincipal(parametrosSMSBean, tipoConsulta);
		break;
		case Enum_Con_Param.principalWS:
			paramSms = parametrosSMSDAO.consultaPrincipalWS(parametrosSMSBean, tipoConsulta);
		break;
			case Enum_Con_Param.conRuta:
				paramSms = parametrosSMSDAO.consultaRuta(parametrosSMSBean, tipoConsulta);
			break;
			case Enum_Con_Param.conNumInt1:
				paramSms = parametrosSMSDAO.obtieneDestinatario(parametrosSMSBean, tipoConsulta);
			break;
		}
		return paramSms;
	}
	
	
	//------------------ Getters y Setters ------------------------------------------------------
	public ParametrosSMSDAO getParametrosSMSDAO() {
		return parametrosSMSDAO;
	}
	public void setParametrosSMSDAO(ParametrosSMSDAO parametrosSMSDAO) {
		this.parametrosSMSDAO = parametrosSMSDAO;
	}
	
	
	
	
}
