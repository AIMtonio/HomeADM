package pld.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.OpeInusualesBean;
import pld.bean.SeguimientoPersonaListaBean;
import pld.servicio.SeguimientoPersonaListaServicio;

public class SeguimientoPersonaListaControlador extends AbstractCommandController{
	
	SeguimientoPersonaListaServicio seguimientoPersonaListaServicio = null;
	
	public SeguimientoPersonaListaControlador() {
		setCommandClass(SeguimientoPersonaListaBean.class);
		setCommandName("seguimientoPersonaListaBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
	
	
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
	
		SeguimientoPersonaListaBean inusuales = (SeguimientoPersonaListaBean) command;
		List lista =	seguimientoPersonaListaServicio.lista(tipoLista, inusuales);
	
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(lista);
	
	return new ModelAndView("pld/seguimientoPersonaListaVista", "listaResultado", listaResultado);
	}

	public SeguimientoPersonaListaServicio getSeguimientoPersonaListaServicio() {
		return seguimientoPersonaListaServicio;
	}

	public void setSeguimientoPersonaListaServicio(
			SeguimientoPersonaListaServicio seguimientoPersonaListaServicio) {
		this.seguimientoPersonaListaServicio = seguimientoPersonaListaServicio;
	}
	
}
