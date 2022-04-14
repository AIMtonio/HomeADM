package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.MenuAplicacionBean;
import soporte.bean.OpcionesRolBean;
import soporte.bean.RolesBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.RolesServicio;
import soporte.servicio.RolesServicio.Enum_Lis_Roles;

public class PantallasPorPerfilGridControlador extends AbstractCommandController{
		
	RolesServicio rolesServicio = null;
	public PantallasPorPerfilGridControlador() {
		setCommandClass(OpcionesRolBean.class);
		setCommandName("opcionesRolBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {			
		OpcionesRolBean opRolesBean = (OpcionesRolBean) command;
		List opciones = rolesServicio.listaOpcionesRol(Enum_Lis_Roles.opcionesRol, opRolesBean);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(opciones);
	
		
		return new ModelAndView("soporte/pantallasRolGridVista", "listaResultado", listaResultado);
		
		
	}

	public void setRolesServicio(RolesServicio rolesServicio) {
		this.rolesServicio = rolesServicio;
	}



}

