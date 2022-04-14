package aportaciones.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import aportaciones.bean.PlazosAportacionesBean;
import aportaciones.servicio.PlazosAportacionesServicio;

public class PlazosAportacionesGridControlador extends AbstractCommandController{
	
	PlazosAportacionesServicio plazosAportacionesServicio = null;

	public PlazosAportacionesGridControlador() {
		setCommandClass(PlazosAportacionesBean.class);
		setCommandName("plazosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		PlazosAportacionesBean plazos = (PlazosAportacionesBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List plazosLista =	plazosAportacionesServicio.lista(tipoLista, plazos);
		
		return new ModelAndView("aportaciones/plazosAportacionesGridVista", "plazosLista", plazosLista);
	}

	public PlazosAportacionesServicio getPlazosAportacionesServicio() {
		return plazosAportacionesServicio;
	}

	public void setPlazosAportacionesServicio(
			PlazosAportacionesServicio plazosAportacionesServicio) {
		this.plazosAportacionesServicio = plazosAportacionesServicio;
	}
	
	

}
