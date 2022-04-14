package originacion.servicio;

import java.util.List;

import originacion.bean.CalendarioProdBean;
import originacion.dao.CalendarioProdDAO;
import soporte.bean.SucursalesBean;
import soporte.servicio.SucursalesServicio.Enum_Lis_Sucursal;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;


public class CalendarioProdServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	CalendarioProdDAO calendarioProdDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Calendario{
		int principal = 1;
		int foranea = 2;
	
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Calendario {
		int principal = 1;

	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_Calendario {
		int alta = 1;
		int modificacion = 2;
	}
	
	public CalendarioProdServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CalendarioProdBean calendarioProdBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_Calendario.alta:		
				mensaje = altaCalendarioProducto(calendarioProdBean);								
				break;	
			case Enum_Tra_Calendario.modificacion:		
				mensaje = modificacionCalendarioProducto(calendarioProdBean);								
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaCalendarioProducto(CalendarioProdBean calendarioProdBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = calendarioProdDAO.altaCalendarioProducto(calendarioProdBean);		
		return mensaje;
	}
	
	public MensajeTransaccionBean modificacionCalendarioProducto(CalendarioProdBean calendarioProdBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = calendarioProdDAO.modificacionCalendarioProducto(calendarioProdBean);		
		return mensaje;
	}
	
	
	public CalendarioProdBean consulta(int tipoConsulta, CalendarioProdBean calendarioProdBean){
		CalendarioProdBean calendarioProd = null;
		switch (tipoConsulta) {
			case Enum_Con_Calendario.principal:	
				calendarioProd = calendarioProdDAO.consultaPrincipal(calendarioProdBean, tipoConsulta);				
			break;	
		
			
		}				
		return calendarioProd;
	}
	
	
		
	//------------------ Geters y Seters ------------------------------------------------------	
	public CalendarioProdDAO getCalendarioProdDAO() {
		return calendarioProdDAO;
	}



	public void setCalendarioProdDAO(CalendarioProdDAO calendarioProdDAO) {
		this.calendarioProdDAO = calendarioProdDAO;
	}

}


