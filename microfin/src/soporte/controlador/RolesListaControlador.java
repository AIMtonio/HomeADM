package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.RolesBean;
import soporte.servicio.RolesServicio;



public class RolesListaControlador extends AbstractCommandController{

	
	RolesServicio rolesServicio = null;
		
	public RolesListaControlador() {
			setCommandClass(RolesBean.class);
			setCommandName("roles");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	RolesBean rol = (RolesBean) command;
	List roles =	rolesServicio.lista(tipoLista, rol);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(roles);
			
	return new ModelAndView("soporte/rolesListaVista", "listaResultado", listaResultado);
	}

	public void setRolesServicio(RolesServicio rolesServicio) {
		this.rolesServicio = rolesServicio;
	}

	
}
