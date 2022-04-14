package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import pld.bean.EscalamientoPrevioBean;
import pld.dao.EscalamientoPrevioDAO;


public class EscalamientoPrevioServicio extends BaseServicio{

	private EscalamientoPrevioServicio(){
		super();
	}
	EscalamientoPrevioDAO escalamientoPrevioDAO = null;

	public static interface Enum_Tra_EscalamientoPrevio {
		int grabar = 1;
		int modificacion = 2;
		int baja = 3;
		
	}

	public static interface Enum_Con_EscalamientoPrevio{
		int principal = 1;
		int folioVig  = 2;
			
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, EscalamientoPrevioBean escalamientoPrevioBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_EscalamientoPrevio.grabar:
			mensaje = grabar(escalamientoPrevioBean);
			break;
		case Enum_Tra_EscalamientoPrevio.modificacion:
			mensaje = modificacion(escalamientoPrevioBean);
			break;
		case Enum_Tra_EscalamientoPrevio.baja:
			mensaje = baja(escalamientoPrevioBean, tipoTransaccion);
			break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean grabar(EscalamientoPrevioBean escalamientoPrevio){
		MensajeTransaccionBean mensaje = null;
		mensaje = escalamientoPrevioDAO.grabarEscalPrev(escalamientoPrevio);		
		return mensaje;
	}
	

	public MensajeTransaccionBean modificacion(EscalamientoPrevioBean escalamientoPrevio){
		MensajeTransaccionBean mensaje = null;
		mensaje = escalamientoPrevioDAO.modificaEscalPrev(escalamientoPrevio);		
		return mensaje;
	}
	
	public MensajeTransaccionBean baja(EscalamientoPrevioBean escalamientoPrevio, int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;
		mensaje = escalamientoPrevioDAO.bajaEscalPrev(escalamientoPrevio, tipoTransaccion);		
		return mensaje;
	}
	

	public EscalamientoPrevioBean consulta(int tipoConsulta, EscalamientoPrevioBean escalamientoPrevio){
		EscalamientoPrevioBean escalamientoPrevioBean = null;
		switch (tipoConsulta) {
			case Enum_Con_EscalamientoPrevio.principal:		
				escalamientoPrevioBean = escalamientoPrevioDAO.consultaPrincipal(escalamientoPrevio, tipoConsulta);				
				break;	
			case Enum_Con_EscalamientoPrevio.folioVig:		
				escalamientoPrevioBean = escalamientoPrevioDAO.consultaFolioVigente(escalamientoPrevio, tipoConsulta);				
				break;	
			
		}
		return escalamientoPrevioBean;
	}
	
	public EscalamientoPrevioBean consultaRol(int tipoConsulta, EscalamientoPrevioBean escalamientoPrevio){
		EscalamientoPrevioBean escalamiento =null;
		
		escalamiento = escalamientoPrevioDAO.consultaRol(escalamientoPrevio, tipoConsulta);
		
		return escalamiento;
	}
	
	
	public void setEscalamientoPrevioDAO(EscalamientoPrevioDAO escalamientoPrevioDAO) {
		this.escalamientoPrevioDAO = escalamientoPrevioDAO;
	}

	public EscalamientoPrevioDAO getEscalamientoPrevioDAO() {
		return escalamientoPrevioDAO;
	}
	
	


}

