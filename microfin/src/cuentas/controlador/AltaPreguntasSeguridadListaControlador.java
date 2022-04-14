package cuentas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.AltaPreguntasSeguridadBean;
import cuentas.servicio.AltaPreguntasSeguridadServicio;

public class AltaPreguntasSeguridadListaControlador extends AbstractCommandController {
	
	AltaPreguntasSeguridadServicio altaPreguntasSeguridadServicio = null;
	
	public AltaPreguntasSeguridadListaControlador() {
		setCommandClass(AltaPreguntasSeguridadBean.class);
		setCommandName("altaPreguntasSeguridadBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista =(request.getParameter("tipoLista")!=null)?
		Integer.parseInt(request.getParameter("tipoLista")): 0;
		
		String controlID = request.getParameter("controlID");
		
		AltaPreguntasSeguridadBean altaPreguntasSeguridadBean = (AltaPreguntasSeguridadBean) command;
		List preguntasSeguridad = altaPreguntasSeguridadServicio.lista(tipoLista, altaPreguntasSeguridadBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(preguntasSeguridad);
		
		return new ModelAndView("cuentas/altaPreguntasSeguridadListaVista", "listaResultado",listaResultado);
	}

	// ---------------  GETTER y SETTER -------------------- 
	
	public AltaPreguntasSeguridadServicio getAltaPreguntasSeguridadServicio() {
		return altaPreguntasSeguridadServicio;
	}

	public void setAltaPreguntasSeguridadServicio(
			AltaPreguntasSeguridadServicio altaPreguntasSeguridadServicio) {
		this.altaPreguntasSeguridadServicio = altaPreguntasSeguridadServicio;
	}
	
}
