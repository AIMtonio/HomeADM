package cedes.controlador;

import inversiones.bean.DiasInversionBean;
import inversiones.servicio.DiasInversionServicio;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cedes.bean.PlazosCedesBean;
import cedes.servicio.PlazosCedesServicio;

public class PlazosCedesGridControlador extends AbstractCommandController{

	PlazosCedesServicio plazosCedesServicio = null;

	public PlazosCedesGridControlador() {
		setCommandClass(PlazosCedesBean.class);
		setCommandName("plazosBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		PlazosCedesBean plazos = (PlazosCedesBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List plazosLista =	plazosCedesServicio.lista(tipoLista, plazos);
				
		return new ModelAndView("cedes/plazosCedesGridVista", "plazosLista", plazosLista);
	}

	public void setPlazosCedesServicio(PlazosCedesServicio plazosCedesServicio) {
		this.plazosCedesServicio = plazosCedesServicio;
	}	
	 
}