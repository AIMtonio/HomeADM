package aportaciones.controlador;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import aportaciones.bean.AportacionesBean;
import aportaciones.servicio.AportacionesServicio;

public class ResumenAportGridControlador extends AbstractCommandController{

	AportacionesServicio aportacionesServicio = null;

	public ResumenAportGridControlador() {
		setCommandClass(AportacionesBean.class);
		setCommandName("aportBean");
	}

	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response,
			Object command, BindException errors) throws Exception {

		AportacionesBean aportBean = (AportacionesBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));

		List resumenCte = aportacionesServicio.lista(tipoLista, aportBean);

		return new ModelAndView("aportaciones/resumenAportGridVista","resumenAport",resumenCte);
	}

	public AportacionesServicio getAportacionesServicio() {
		return aportacionesServicio;
	}

	public void setAportacionesServicio(AportacionesServicio aportacionesServicio) {
		this.aportacionesServicio = aportacionesServicio;
	}
}