package aportaciones.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import aportaciones.bean.AportacionesAnclajeBean;
import aportaciones.servicio.AportacionesAnclajeServicio;

public class AportacionesAnclajeListaControlador extends AbstractCommandController{

	AportacionesAnclajeServicio aportacionesAnclajeServicio = null;

	public AportacionesAnclajeListaControlador() {
		setCommandClass(AportacionesAnclajeBean.class);
		setCommandName("aportacionesAnclajeBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		AportacionesAnclajeBean aportacionesAnclajeBean = (AportacionesAnclajeBean) command;
		List aportaciones =	aportacionesAnclajeServicio.lista(tipoLista, aportacionesAnclajeBean);

		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(aportaciones);

		return new ModelAndView("aportaciones/aportAnclajeListaVista", "listaResultado", listaResultado);
	}

	public AportacionesAnclajeServicio getAportacionesAnclajeServicio() {
		return aportacionesAnclajeServicio;
	}

	public void setAportacionesAnclajeServicio(
			AportacionesAnclajeServicio aportacionesAnclajeServicio) {
		this.aportacionesAnclajeServicio = aportacionesAnclajeServicio;
	}

}