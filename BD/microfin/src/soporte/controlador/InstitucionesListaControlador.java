package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.InstitucionesBean;
import soporte.servicio.InstitucionesServicio;

public class InstitucionesListaControlador extends AbstractCommandController {


	InstitucionesServicio institucionesServicio = null;
		
	public InstitucionesListaControlador() {
			setCommandClass(InstitucionesBean.class);
			setCommandName("institucion");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");
	
	InstitucionesBean instituciones = (InstitucionesBean) command;
	List institucion =	institucionesServicio.lista(tipoLista, instituciones);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(institucion);
		
	return new ModelAndView("soporte/institucionesListaVista", "listaResultado", listaResultado);
	}

	public void setInstitucionesServicio(InstitucionesServicio institucionesServicio) {
		this.institucionesServicio = institucionesServicio;
	}	
}
