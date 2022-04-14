package gestionComecial.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import gestionComecial.bean.EmpleadosBean;

import gestionComecial.dao.EmpleadosDAO;

import java.util.List;

public class EmpleadosServicio extends BaseServicio {

	private EmpleadosServicio(){
		super();
	}

	EmpleadosDAO empleadosDAO = null;

	public static interface Enum_Lis_Empleados{
		int alfanumerica = 1;
		int todos=2;
	}
	
	public static interface Enum_Con_Empleados{
		int principal = 1;
		int foranea = 2;
		int rfc =3;
		int principalExterna=4;
		int sinEst=5;
		int empOrganigrama = 6;
	}
	
	public static interface Enum_Tra_Empleados {
		int alta = 1;
		int baja = 2;
		int modificacion=3;
		
		
	}

	
	public EmpleadosBean consulta(int tipoConsulta, EmpleadosBean empleados){
		EmpleadosBean empleadosBean = null;
		switch(tipoConsulta){
			case Enum_Con_Empleados.principal:
				empleadosBean = empleadosDAO.consultaPrincipal(empleados, Enum_Con_Empleados.principal);
			break;
			case Enum_Con_Empleados.foranea:
				empleadosBean = empleadosDAO.consultaForanea(empleados, Enum_Con_Empleados.foranea);
			break;
			case Enum_Con_Empleados.rfc:
				empleadosBean = empleadosDAO.consultaRFC(empleados, Enum_Con_Empleados.rfc);
			break;
			case Enum_Con_Empleados.principalExterna:
				empleadosBean = empleadosDAO.consultaPrincipalExterna(empleados, Enum_Con_Empleados.principal);
			break;
			case Enum_Con_Empleados.sinEst:
				empleadosBean = empleadosDAO.consultaPrincipal(empleados, Enum_Con_Empleados.principalExterna);
			break;
			case Enum_Con_Empleados.empOrganigrama:
				empleadosBean = empleadosDAO.conOrganigrama(empleados, tipoConsulta);
			break;
		}
		return empleadosBean;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, EmpleadosBean empleados){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_Empleados.alta:
			mensaje = alta(empleados);
			break;
		case Enum_Tra_Empleados.baja:
			mensaje = baja(empleados);
			break;
		case Enum_Tra_Empleados.modificacion:
			mensaje = modifica(empleados);
			break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean alta(EmpleadosBean empleados){
		MensajeTransaccionBean mensaje = null;
		mensaje = empleadosDAO.alta(empleados);		
		return mensaje;
	}
	
	public MensajeTransaccionBean baja(EmpleadosBean empleados){
		MensajeTransaccionBean mensaje = null;
		mensaje = empleadosDAO.actualizacion(empleados);		
		return mensaje;
	}
	
	public MensajeTransaccionBean modifica(EmpleadosBean empleados){
		MensajeTransaccionBean mensaje = null;
		mensaje = empleadosDAO.modifica(empleados);		
		return mensaje;
	}
	
	public List lista(int tipoLista, EmpleadosBean empleados){		
		List listaEmpleados = null;
		switch (tipoLista) {
			case Enum_Lis_Empleados.alfanumerica:		
				listaEmpleados=  empleadosDAO.listaAlfanumerica(empleados, Enum_Lis_Empleados.alfanumerica);				
				break;		
			case Enum_Lis_Empleados.todos:		
				listaEmpleados=  empleadosDAO.listaAlfanumerica(empleados, Enum_Lis_Empleados.todos);				
				break;	
		}		
		return listaEmpleados;
	}
	
		
	public void setEmpleadosDAO(EmpleadosDAO empleadosDAO ){
		this.empleadosDAO = empleadosDAO;
	}

	public EmpleadosDAO getEmpleadosDAO() {
		return empleadosDAO;
	}

}