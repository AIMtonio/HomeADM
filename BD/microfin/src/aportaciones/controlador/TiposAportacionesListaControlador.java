package aportaciones.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import aportaciones.bean.TiposAportacionesBean;
import aportaciones.servicio.TiposAportacionesServicio;

public class TiposAportacionesListaControlador extends AbstractCommandController{
	
	TiposAportacionesServicio tiposAportacionesServicio = null;
	
	public TiposAportacionesListaControlador() {
		setCommandClass(TiposAportacionesBean.class);
		setCommandName("tiposAportacionesBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		TiposAportacionesBean tiposAportacionesBean = (TiposAportacionesBean) command;
		List tiposAportaciones =	tiposAportacionesServicio.lista(tipoLista, tiposAportacionesBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(tiposAportaciones);
		
		return new ModelAndView("aportaciones/tiposAportacionesListaVista", "listaResultado",listaResultado);
	}

	public TiposAportacionesServicio getTiposAportacionesServicio() {
		return tiposAportacionesServicio;
	}

	public void setTiposAportacionesServicio(
			TiposAportacionesServicio tiposAportacionesServicio) {
		this.tiposAportacionesServicio = tiposAportacionesServicio;
	}
	
	
}
