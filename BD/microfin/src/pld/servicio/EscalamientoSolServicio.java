package pld.servicio;

import pld.bean.EscalamientoSolBean;
import pld.dao.EscalamientoSolDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class EscalamientoSolServicio extends BaseServicio{

	private EscalamientoSolServicio(){
		super();
	}
	EscalamientoSolDAO escalamientoSolDAO = null;

	public static interface Enum_Tra_EscalamientoSol {
		int grabar = 1;
		int modificacion = 2;
		int baja = 3;
		
	}

	public static interface Enum_Con_EscalamientoSol{
		int principal = 1;
		int conRol = 2;
		int folioVigente = 3;
	
			
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, EscalamientoSolBean escalamientoSol){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_EscalamientoSol.grabar:
			mensaje = grabar(escalamientoSol);
			break;
		case Enum_Tra_EscalamientoSol.modificacion:
			mensaje = modificacion(escalamientoSol);
			break;
		case Enum_Tra_EscalamientoSol.baja:
			mensaje = baja(escalamientoSol, tipoTransaccion);
			break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean grabar(EscalamientoSolBean escalamientoSol){
		MensajeTransaccionBean mensaje = null;
		mensaje = escalamientoSolDAO.grabarParametrosEscala(escalamientoSol);	
		return mensaje;
	}
	
	public MensajeTransaccionBean modificacion(EscalamientoSolBean escalamientoSol){
		MensajeTransaccionBean mensaje = null;
		mensaje = escalamientoSolDAO.modificaParametrosEscala(escalamientoSol);		
		return mensaje;
	}	
	
	public MensajeTransaccionBean baja(EscalamientoSolBean escalamientosol, int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;
		mensaje = escalamientoSolDAO.bajaParametrosEscala(escalamientosol, tipoTransaccion);	
		return mensaje;
	}
	
	public EscalamientoSolBean consulta(int tipoConsulta, EscalamientoSolBean escalamientoSol){
		EscalamientoSolBean escalamientoSolBean = null;
		switch (tipoConsulta) {
			case Enum_Con_EscalamientoSol.principal:		
				escalamientoSolBean = escalamientoSolDAO.consultaPrincipal(escalamientoSol, tipoConsulta);				
				break;	
			case Enum_Con_EscalamientoSol.folioVigente:		
				escalamientoSolBean = escalamientoSolDAO.consultaFolioVigente(escalamientoSol, tipoConsulta);			
				break;		
			
		}
		
		
		
		return escalamientoSolBean;
	}
	
	
	public EscalamientoSolBean consultaRol(int tipoConsulta, EscalamientoSolBean escalamientoSol){
		EscalamientoSolBean escalamiento =null;
		
		escalamiento = escalamientoSolDAO.consultaRol(escalamientoSol, tipoConsulta);
		
		return escalamiento;
	}

	public void setEscalamientoSolDAO(EscalamientoSolDAO escalamientoSolDAO) {
		this.escalamientoSolDAO = escalamientoSolDAO;
	}

	public EscalamientoSolDAO getEscalamientoSolDAO() {
		return escalamientoSolDAO;
	}
	
	


}

