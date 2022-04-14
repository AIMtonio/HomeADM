package seguridad.servicio;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.security.authentication.encoding.PasswordEncoder;
import org.springframework.security.authentication.encoding.ShaPasswordEncoder;

import seguridad.bean.BitacoraAccesoBean;
import seguridad.bean.RolesPorRecursoBean;
import seguridad.dao.BitacoraAccesoDAO;
import soporte.bean.OpcionesRolBean;
import soporte.bean.RolesBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.OpcionesRolServicio;
import soporte.servicio.RolesServicio;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class SeguridadRecursosServicio {
	
	private RolesPorRecursoBean rolesPorRecursoBean;
	private RolesServicio rolesServicio;
	private OpcionesRolServicio opcionesRolServicio;
	private BitacoraAccesoDAO bitacoraAccesoDAO;
	
	public void consultaRolesPorRecurso(){
		String listaRolesStr = new String();
		String listaRolesyAnonimoStr = new String();
		List listaRecursoAsegurado;
							 		
		listaRolesStr = consultaRoles();		
		listaRolesyAnonimoStr = "ANONYMOUS," + listaRolesStr;
		
		//Establecemos los Roles en el Esquema de Seguridad
		rolesPorRecursoBean.setListaRoles(listaRolesStr);
		
		//Recursos De Acceso General
		//A los que no se Da Acceso en la Plataforma SAFI, cuando se asignan las opciones al Perfil
		//Es decir no son opciones o recursos del Negocio
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/cerrarSessionUsuarios.htm", listaRolesyAnonimoStr); //Al dar click a Salir del Sistema
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/invalidaSession.htm", listaRolesyAnonimoStr); //TimeOut del Servidor
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/sesionExpirada.htm", listaRolesyAnonimoStr); //Session Expirada por Time Out Cliente
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/sesionExpiradaConcurrente.htm", listaRolesyAnonimoStr); //Session Expirada por Doble Login
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/accesoDenegado.htm", listaRolesyAnonimoStr); //Acceso No Autorizado
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/menuAplicacion.htm", listaRolesStr);  //Es el menu de la Aplicacion
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/consultaSession.htm", listaRolesyAnonimoStr);  //Es para Consulta de la Session por AJAX
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/olvidoUsuario.htm", listaRolesyAnonimoStr); //Recurso en Olvido de Clave
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/logout", listaRolesyAnonimoStr); //Recurso en Olvido de Clave
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/activaPantallasRol.htm",listaRolesyAnonimoStr); //Pantalla que recarga todos los roles
		
		//Utilizados en la Pantalla de Login, cuando el usuario todavia no ha ingresado a la Aplicacion y PLD
		
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/engine.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/util.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/call/plaincall/__System.generateId.dwr", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/interface/usuarioServicio.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/interface/companiaServicio.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/call/plaincall/usuarioServicio.consulta.dwr", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/call/plaincall/companiaServicio.consulta.dwr", listaRolesyAnonimoStr);
		
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/interface/huellaDigitalServicio.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/call/plaincall/huellaDigitalServicio.consulta.dwr", listaRolesyAnonimoStr);		
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/soporte/ServerHuella.js", listaRolesyAnonimoStr);
		
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/call/plaincall/usuarioServicio.consultaUsuarioLogeado.dwr", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/call/plaincall/__System.pageLoaded.dwr", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/jquery-1.5.1.min.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/jquery.inlineFieldLabel.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/slide.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/forma.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/soporte/entrada.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/soporte/entrada_look.js", listaRolesyAnonimoStr);

			// PLD captura de operaciones internas preocupantes e inusuales
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/jquery.ui.datepicker-es.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/jquery-ui-1.8.13.custom.min.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/jquery-ui-1.8.13.min.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/jquery.validate.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/jquery.jmpopups-0.5.1.js", listaRolesyAnonimoStr);		
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/jquery.blockUI.js", listaRolesyAnonimoStr);						
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/jquery.hoverIntent.minified.js", listaRolesyAnonimoStr);
		
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/jquery.plugin.tracer.js", listaRolesyAnonimoStr);				 				
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/pld/capturaOpIntPreocupantes.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/interface/companiasServicio.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/call/plaincall/companiasServicio.listaCombo.dwr", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/formaPLD.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/pld/capturaOpeInusuales.js", listaRolesyAnonimoStr);  

		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/capturaOpIntPreocupantesVista.htm", listaRolesyAnonimoStr); 		
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/capturaOpInusualesVista.htm", listaRolesyAnonimoStr);
		
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/interface/controlClaveServicio.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/call/plaincall/controlClaveServicio.consulta.dwr", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/interface/parametrosSisServicio.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/call/plaincall/parametrosSisServicio.consulta.dwr", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/js/soporte/capturaClaves.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/capturaClavesVista.htm", listaRolesyAnonimoStr);
		
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/listaMotivos.htm", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/listaProcedimientos.htm", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/listaCategorias.htm", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/listaPersonaInv.htm", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/listaCliente.htm", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/listaEmpleadosNombre.htm", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/listaMotivosInu.htm", listaRolesyAnonimoStr);				
		
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/interface/procInternosServicio.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/call/plaincall/procInternosServicio.consulta.dwr", listaRolesyAnonimoStr);

		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/interface/motivosPreoServicio.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/call/plaincall/motivosPreoServicio.consulta.dwr", listaRolesyAnonimoStr);

		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/interface/empleadosServicio.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/call/plaincall/empleadosServicio.consulta.dwr", listaRolesyAnonimoStr);

		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/interface/sucursalesServicio.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/call/plaincall/sucursalesServicio.consultaSucursal.dwr", listaRolesyAnonimoStr);

		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/interface/puestosServicio.js", listaRolesyAnonimoStr); 
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/call/plaincall/puestosServicio.consulta.dwr", listaRolesyAnonimoStr); 

		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/interface/opIntPreocupantesServicio.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/call/plaincall/opIntPreocupantesServicio.consulta.dwr", listaRolesyAnonimoStr);

		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/interface/motivosInuServicio.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/call/plaincall/motivosInuServicio.consulta.dwr", listaRolesyAnonimoStr);		

		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/interface/clienteServicio.js", listaRolesyAnonimoStr);
		rolesPorRecursoBean.getRolesPorRecursoMapa().put("/dwr/call/plaincall/clienteServicio.consulta.dwr", listaRolesyAnonimoStr);

		
		//Consulta de los Recursos Asegurados por la Aplicacion
		OpcionesRolBean opcionesRolBean = new OpcionesRolBean();
		opcionesRolBean.setRolID(Constantes.STRING_CERO);
		
		listaRecursoAsegurado = opcionesRolServicio.consultaRolesPorOpcion(
										OpcionesRolServicio.Enum_Con_OpRol.accesosPorRol, opcionesRolBean);
		
		for(int i=0; i<listaRecursoAsegurado.size(); i++){
			opcionesRolBean = (OpcionesRolBean)listaRecursoAsegurado.get(i);
			rolesPorRecursoBean.getRolesPorRecursoMapa().put(opcionesRolBean.getRecurso(), opcionesRolBean.getRolID());
		}
	}
	
	// ---------------- METODOS DE APOYO ----------------------------
	
	//Consulta los Roles en la BD y devuelve un String separado por comas con los Roles o Perfiles de Usuario Disponibles
	private String consultaRoles(){
		String listaRolesStr = Constantes.STRING_VACIO;
		List listaRoles;
		RolesBean rolBean = new RolesBean();
		rolBean.setNombreRol(Constantes.STRING_VACIO);
		listaRoles = rolesServicio.lista(RolesServicio.Enum_Lis_Roles.todosRolesPrin, rolBean);

		if (listaRoles!= null){
			for(int i=0; i<listaRoles.size(); i++){
				rolBean = (RolesBean)listaRoles.get(i);
				
				if(i == listaRoles.size() -1){
					listaRolesStr = listaRolesStr + rolBean.getNombreRol();
				}else{
					listaRolesStr = listaRolesStr + rolBean.getNombreRol() + ",";
				}
			}
		}
		
		return listaRolesStr;
		
	}
			
	public static String encriptaPass(String clave, String pass){
		PasswordEncoder encoder = new ShaPasswordEncoder();
		String encriptado = null;
		try {
			encriptado = encoder.encodePassword(pass, clave);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
		return encriptado;
	}

	public static String generaTokenHuella(String clave){
		String pass = "";
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
		Date date = new Date();

		pass = encriptaPass(clave,encriptaPass(clave,dateFormat.format(date)));
		
		return pass;
	}
	
	public MensajeTransaccionBean altaBitacoraAcceso(BitacoraAccesoBean bitacoraAcceso){
		MensajeTransaccionBean mensaje = null;
		
		mensaje = bitacoraAccesoDAO.AltaBitacoraAcceso(bitacoraAcceso);
		
		if(mensaje == null){
			mensaje = new MensajeTransaccionBean();
		}
		
		return mensaje;
		
	}
	
	public MensajeTransaccionBean altaBitacoraAccesoLogin(BitacoraAccesoBean bitacoraAcceso){		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		UsuarioBean userBean = new UsuarioBean();
		//CONSULTA ORIGEN DE DATOS DEL USUARIO EN BD PRINCIPAL
		userBean.setClave(bitacoraAcceso.getClaveUsuario());
		userBean = bitacoraAccesoDAO.consultaPorClaveLoginBDPrincipal(userBean, 3);	
		
		if(userBean != null){
			bitacoraAccesoDAO.getParametrosAuditoriaBean().setOrigenDatos(userBean.getOrigenDatos());
			
			mensaje = bitacoraAccesoDAO.AltaBitacoraAcceso(bitacoraAcceso);
			
			if(mensaje == null){
				mensaje = new MensajeTransaccionBean();
			}
			
		}		
		
		
		return mensaje;
		
	}
	
	// ----------------- Getters y Setters -------------------------------------------
	public void setRolesPorRecursoBean(RolesPorRecursoBean rolesPorRecursoBean) {
		this.rolesPorRecursoBean = rolesPorRecursoBean;
	}
	
	

	public RolesPorRecursoBean getRolesPorRecursoBean() {
		return rolesPorRecursoBean;
	}

	public void setRolesServicio(RolesServicio rolesServicio) {
		this.rolesServicio = rolesServicio;
	}

	public void setOpcionesRolServicio(OpcionesRolServicio opcionesRolServicio) {
		this.opcionesRolServicio = opcionesRolServicio;
	}

	public BitacoraAccesoDAO getBitacoraAccesoDAO() {
		return bitacoraAccesoDAO;
	}

	public void setBitacoraAccesoDAO(BitacoraAccesoDAO bitacoraAccesoDAO) {
		this.bitacoraAccesoDAO = bitacoraAccesoDAO;
	}
	
	
}
