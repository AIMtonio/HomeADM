package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;

import java.util.List;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.OpcionesRolBean;
import soporte.bean.PlazasBean;
import soporte.bean.RolesBean;
import soporte.dao.RolesDAO;
import soporte.servicio.PlazasServicio.Enum_Tra_Plaza;


public class RolesServicio extends BaseServicio {
	
	//---------- Variables ------------------------------------------------------------------------
	RolesDAO rolesDAO = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Roles {
		int principal = 1;
		int foranea = 2;
		int autTimbrado = 3;
				
	}
	public static interface Enum_Tra_Roles {
		int alta = 1;
		int modificacion = 2;
				
	}

	public static interface Enum_Lis_Roles {
		int principal = 1;
		int todosRoles	 = 2;
		int opcionesRol= 3;
		int todosRolesPrin	=	4;
	}

	
	public RolesServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, RolesBean roles){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Roles.alta:		
				mensaje = altaRol(roles);				
			break;				
			case Enum_Tra_Roles.modificacion:
				mensaje = modificaRol(roles);				
			break;
			
		}
		return mensaje;
	}
	
	
	
	
	public MensajeTransaccionBean altaRol(RolesBean roles){
		MensajeTransaccionBean mensaje = null;
		mensaje = rolesDAO.altaRoles(roles);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaRol(RolesBean roles){
		MensajeTransaccionBean mensaje = null;
		mensaje = rolesDAO.modificaRoles(roles);
		return mensaje;
	}
	public MensajeTransaccionBean altaOpcionesRol(RolesBean roles){
		MensajeTransaccionBean mensaje = null;
		mensaje = rolesDAO.alta(roles);		
		return mensaje;
	}
	
	
	public RolesBean consultaRoles(int tipoConsulta, RolesBean rolBean){
		RolesBean rol = null;
		switch (tipoConsulta) {
			case Enum_Con_Roles.principal:	
				rol = rolesDAO.consultaRoles(rolBean,Enum_Con_Roles.principal);
			break;
			case Enum_Con_Roles.foranea:	
				rol = rolesDAO.consultaRolesForanea(rolBean,Enum_Con_Roles.foranea);
			break;
			case Enum_Con_Roles.autTimbrado:	
				rol = rolesDAO.consultaAutTimbrado(rolBean,tipoConsulta);
			break;
		}
		return rol;
		
	}
	

	
	public List lista(int tipoLista, RolesBean rolBean){		
		List listaRoles = null;
		switch (tipoLista) {
			case Enum_Lis_Roles.principal:		
				listaRoles=  rolesDAO.listaRoles(rolBean,Enum_Lis_Roles.principal);				
				break;
			case Enum_Lis_Roles.todosRoles:
				listaRoles=  rolesDAO.listaTodosRoles(rolBean,Enum_Lis_Roles.todosRoles);
				break;
			case Enum_Lis_Roles.todosRolesPrin:
				listaRoles=  rolesDAO.listaTodosRolesPrincipal(rolBean,Enum_Lis_Roles.todosRoles);
				break;	
		}		
		return listaRoles;
	}

	public List listaOpcionesRol(int tipoLista, OpcionesRolBean opcionesRolBean){	
		List listaOpcionesRol = null;
		listaOpcionesRol = rolesDAO.listaOpcionesPorRol(opcionesRolBean,Enum_Lis_Roles.opcionesRol);
		
		return listaOpcionesRol;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	
	public void setRolesDAO(RolesDAO rolesDAO) {
		this.rolesDAO = rolesDAO;
	}

}
