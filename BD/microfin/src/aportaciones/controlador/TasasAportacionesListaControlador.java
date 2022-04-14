package aportaciones.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import aportaciones.bean.TasasAportacionesBean;
import aportaciones.servicio.TasasAportacionesServicio;

public class TasasAportacionesListaControlador extends AbstractCommandController{
	
	TasasAportacionesServicio tasasAportacionesServicio = null;

	public TasasAportacionesListaControlador() {
		setCommandClass(TasasAportacionesBean.class);
		setCommandName("tasasBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		TasasAportacionesBean tasasAportacionesBean = (TasasAportacionesBean) command;
		List tasas =	tasasAportacionesServicio.lista(tipoLista, tasasAportacionesBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(tasas);
		
		return new ModelAndView("aportaciones/tasasAportacionesListaVista", "listaResultado", listaResultado);
	}

	public TasasAportacionesServicio getTasasAportacionesServicio() {
		return tasasAportacionesServicio;
	}

	public void setTasasAportacionesServicio(
			TasasAportacionesServicio tasasAportacionesServicio) {
		this.tasasAportacionesServicio = tasasAportacionesServicio;
	}
	
	

}
