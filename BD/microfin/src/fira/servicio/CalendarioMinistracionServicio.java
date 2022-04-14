package fira.servicio;

import fira.bean.CalendarioMinistracionBean;
import fira.dao.CalendarioMinistracionDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CalendarioMinistracionServicio extends BaseServicio {

	CalendarioMinistracionDAO calendarioMinistracionDAO = null;

	public CalendarioMinistracionServicio() {
		// TODO Auto-generated constructor stub
		super();
	}

	public static interface Enum_Con_Calendario{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_Calendario {
		int principal = 1;
	}

	public static interface Enum_Tra_Calendario {
		int alta = 1;
		int modificacion = 2;
	}
	
	/**
	 * Graba la transacción dependiendo si es un registro nuevo o se trata de una modificación.
	 * @param tipoTransaccion : Número de la transacción [1. Alta] [2. Modificación].
	 * @param calendarioMinistracionBean : Clase bean con los valores de los parámetros de entrada a los SPs.
	 * @return MensajeTransaccionBean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CalendarioMinistracionBean calendarioMinistracionBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
		case Enum_Tra_Calendario.alta:		
			mensaje = calendarioMinistracionDAO.alta(calendarioMinistracionBean);								
			break;	
		case Enum_Tra_Calendario.modificacion:		
			mensaje = calendarioMinistracionDAO.modificacion(calendarioMinistracionBean);								
			break;
		}
		return mensaje;
	}
	
	/**
	 * Consulta información del Calendario de Ministraciones de un Producto de Crédito Agropecuario.
	 * @param tipoConsulta : Número de consulta.
	 * @param calendarioMinistracionBean : Clase bean con los valores a los parámetros de entrada al SP-CALENDARIOMINISTRACON.
	 * @return CalendarioMinistracionBean con el resultado de la consulta.
	 * @author avelasco
	 */
	public CalendarioMinistracionBean consulta(int tipoConsulta, CalendarioMinistracionBean calendarioMinistracionBean){
		CalendarioMinistracionBean calendarioMinistracion = null;
		switch (tipoConsulta) {
		case Enum_Con_Calendario.principal:	
			calendarioMinistracion = calendarioMinistracionDAO.consultaPrincipal(calendarioMinistracionBean, tipoConsulta);				
			break;	
		}				
		return calendarioMinistracion;
	}

	public CalendarioMinistracionDAO getCalendarioMinistracionDAO() {
		return calendarioMinistracionDAO;
	}

	public void setCalendarioMinistracionDAO(CalendarioMinistracionDAO calendarioMinistracionDAO) {
		this.calendarioMinistracionDAO = calendarioMinistracionDAO;
	}

}