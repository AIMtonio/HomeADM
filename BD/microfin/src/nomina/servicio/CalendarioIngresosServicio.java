package nomina.servicio;

import java.util.List;
import java.util.ArrayList;

import nomina.bean.CalendarioIngresosBean;
import nomina.dao.CalendarioIngresosDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class CalendarioIngresosServicio  extends BaseServicio{
	CalendarioIngresosDAO calendarioIngresosDAO = null;
	
	public CalendarioIngresosServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	public static interface Enum_Trans_Calendario{
		int actualizar = 1;
		int autorizar = 2;
		int desautorizar = 3;
	}
	// -------------- Tipo Lista ----------------
	public static interface Enum_Lis_Calendario{
		int lisCalendarioIng	= 1;
		int lisAniosCalendar	= 2;
		
	}
	
	// -------------- Tipo Lista ----------------
		public static interface Enum_Con_Calendario{
			int principal			= 1;
			int conEstatusCalendar	= 2;
			int conFechaLimEnv		= 3;
			
			
		}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	CalendarioIngresosBean calendarioIngresosBean){
		ArrayList listaCalendarioIng = (ArrayList) creaListaDetalle(calendarioIngresosBean);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Trans_Calendario.actualizar:	
				mensaje = calendarioIngresosDAO.grabarCalendarioIng(calendarioIngresosBean,listaCalendarioIng);
			break ;	
			case Enum_Trans_Calendario.autorizar:	
				mensaje = calendarioIngresosDAO.autorizarCalendIng(calendarioIngresosBean,tipoTransaccion);
			break ;	
			case Enum_Trans_Calendario.desautorizar:	
				mensaje = calendarioIngresosDAO.desautorizarCalendIng(calendarioIngresosBean,tipoTransaccion);
			break ;	
			
			
		}
		return mensaje;
		
		}
	
	public List listaCombo(int tipoLista,CalendarioIngresosBean calendarioIngresosBean){
		List cargaAnioC = null;
		switch (tipoLista) {
	        case Enum_Lis_Calendario.lisAniosCalendar:
	        	cargaAnioC = calendarioIngresosDAO.lisAniosCalendar(tipoLista);
			break;
	       
		}
		return cargaAnioC;
	}
	
	public List lista(int tipoLista,CalendarioIngresosBean calendarioIngresosBean){
		List cargalisCalendarioIn = null;
		switch (tipoLista) {
	        case Enum_Lis_Calendario.lisCalendarioIng:
	        	cargalisCalendarioIn = calendarioIngresosDAO.listaCalendarioIng(calendarioIngresosBean,tipoLista);
			break;
		}
		return cargalisCalendarioIn;
	}

	public CalendarioIngresosBean consulta(int tipoConsulta, CalendarioIngresosBean calendarioIngresos){
		CalendarioIngresosBean calendIng = null;
		switch(tipoConsulta){
			case Enum_Con_Calendario.principal:
				calendIng = calendarioIngresosDAO.consultaPrincipal(calendarioIngresos, tipoConsulta);
			break;
			case Enum_Con_Calendario.conEstatusCalendar:
				calendIng = calendarioIngresosDAO.consultaEstatus(calendarioIngresos, tipoConsulta);
			break;
			case Enum_Con_Calendario.conFechaLimEnv:
				calendIng = calendarioIngresosDAO.consultaFechaLimEnvio(calendarioIngresos, tipoConsulta);
			break;
		}
		return calendIng;
	}
	
	public List creaListaDetalle(CalendarioIngresosBean calendarioIngresosBean) {
		List<String> calend1  = calendarioIngresosBean.getLisFechaLimiteEnvio();
		List<String> calend2  = calendarioIngresosBean.getLisFechaPrimerDesc();
		List<String> calend4  = calendarioIngresosBean.getLisFechaLimiteRecep();
		List<String> calend3  = calendarioIngresosBean.getLisNumCuotas();
		ArrayList listaDetalle = new ArrayList();
		CalendarioIngresosBean CalendarioIng = null;	
			if(calend1 != null){
				int tamanio = calend1.size();			
				for (int i = 0; i < tamanio; i++) {
					CalendarioIng = new CalendarioIngresosBean();
					CalendarioIng.setFechaLimiteEnvio(calend1.get(i));
					CalendarioIng.setFechaPrimerDesc(calend2.get(i));
					CalendarioIng.setNumCuotas(calend3.get(i));
					if (calend4.get(i).isEmpty()){
						CalendarioIng.setFechaLimiteRecep(calend2.get(i));
					} else {
						CalendarioIng.setFechaLimiteRecep(calend4.get(i));
					}
					listaDetalle.add(CalendarioIng);
				}
				
			}
		return listaDetalle;
			
		}
	
	
	public CalendarioIngresosDAO getCalendarioIngresosDAO() {
		return calendarioIngresosDAO;
	}

	public void setCalendarioIngresosDAO(CalendarioIngresosDAO calendarioIngresosDAO) {
		this.calendarioIngresosDAO = calendarioIngresosDAO;
	}

}
