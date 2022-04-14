package pld.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.PLDListasPersBloqBean;
import pld.bean.SeguimientoPersonaListaBean;
import pld.servicio.SeguimientoPersonaListaServicio;

public class SegPersonaListaPermiteControlador extends AbstractCommandController {
	
	private SeguimientoPersonaListaServicio seguimientoPersonaListaServicio=null;
	public String successView = null;

	public SegPersonaListaPermiteControlador() {
		setCommandClass(SeguimientoPersonaListaBean.class);
		setCommandName("seguimientoPersonaListaBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		int tipoConsulta = 2;
		SeguimientoPersonaListaBean seguimientoPersonaListaBean = (SeguimientoPersonaListaBean) command;		
		return new ModelAndView(getSuccessView(), "seguimientoPersonaLista",
		seguimientoPersonaListaServicio.consulta(tipoConsulta, seguimientoPersonaListaBean));
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public SeguimientoPersonaListaServicio getSeguimientoPersonaListaServicio() {
		return seguimientoPersonaListaServicio;
	}

	public void setSeguimientoPersonaListaServicio(
			SeguimientoPersonaListaServicio seguimientoPersonaListaServicio) {
		this.seguimientoPersonaListaServicio = seguimientoPersonaListaServicio;
	}
	
	
}
