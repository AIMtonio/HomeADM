package aportaciones.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import aportaciones.bean.AportacionesBean;
import aportaciones.servicio.AportacionesServicio;

public class AportacionesListaControlador extends AbstractCommandController{

	AportacionesServicio aportacionesServicio = null;

	public AportacionesListaControlador() {
		setCommandClass(AportacionesBean.class);
		setCommandName("aportacionesBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		AportacionesBean aportacionesBean = (AportacionesBean) command;
		List aportaciones =	aportacionesServicio.lista(tipoLista, aportacionesBean);

		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(aportaciones);

		return new ModelAndView("aportaciones/aportacionesListaVista", "listaResultado",listaResultado);
	}

	public AportacionesServicio getAportacionesServicio() {
		return aportacionesServicio;
	}

	public void setAportacionesServicio(AportacionesServicio aportacionesServicio) {
		this.aportacionesServicio = aportacionesServicio;
	}
}