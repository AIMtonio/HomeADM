package contabilidad.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;


import contabilidad.bean.PermisosContablesBean;
import contabilidad.dao.PermisosContablesDAO;


public class PermisosContablesServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	PermisosContablesDAO permisosContablesDAO = null;

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_PermisosContables {
		int principal = 1;
	}

	public static interface Enum_Lis_PermisosContables {
		int principal = 1;
	}

	public static interface Enum_Tra_PermisosContables {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}
	
	public PermisosContablesServicio() {
		super();
	}
	
	//---------- Transacciones ------------------------------------------------------------------------------
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,
												   PermisosContablesBean permisosContables){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_PermisosContables.alta:		
				mensaje = altaConcepto(permisosContables);
				break;				
			case Enum_Tra_PermisosContables.modificacion:
				mensaje = modificaConcepto(permisosContables);
				break;
			case Enum_Tra_PermisosContables.baja:
				mensaje = bajaConcepto(permisosContables);	
				break;
			
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaConcepto(PermisosContablesBean permisosContablesBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = permisosContablesDAO.alta(permisosContablesBean);
		return mensaje;
	}

	public MensajeTransaccionBean modificaConcepto(PermisosContablesBean permisosContablesBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = permisosContablesDAO.modifica(permisosContablesBean);		
		return mensaje;
	}	
	public MensajeTransaccionBean bajaConcepto(PermisosContablesBean permisosContablesBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = permisosContablesDAO.baja(permisosContablesBean);
		return mensaje;
	}
	
	public PermisosContablesBean consulta(int tipoConsulta, PermisosContablesBean permisosContablesBean){
		PermisosContablesBean permisosContables = null;
		switch (tipoConsulta) {
			case Enum_Con_PermisosContables.principal:		
				permisosContables = permisosContablesDAO.consultaPrincipal(permisosContablesBean, tipoConsulta);				
				break;	
		}
				
		return permisosContables;
	}
	
	
	//------------------ Geters y Seters ------------------------------------------------------
	
	public void setPermisosContablesDAO(PermisosContablesDAO permisosContablesDAO) {
		this.permisosContablesDAO = permisosContablesDAO;
	}	
	
	
}
