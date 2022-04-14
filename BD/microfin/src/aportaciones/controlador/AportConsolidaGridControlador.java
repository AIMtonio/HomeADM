package aportaciones.controlador;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.AportacionesBean;
import aportaciones.servicio.CondicionesVencimServicio;

public class AportConsolidaGridControlador extends SimpleFormController {

	CondicionesVencimServicio condicionesVencimServicio = null;

	public AportConsolidaGridControlador() {
		setCommandClass(AportacionesBean.class);
		setCommandName("aportacionesBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		AportacionesBean aportBean = (AportacionesBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		List<AportacionesBean> lista = condicionesVencimServicio.lista(tipoLista, aportBean);
		return new ModelAndView(getSuccessView(), "listaResultado", lista);
	}

	public CondicionesVencimServicio getCondicionesVencimServicio() {
		return condicionesVencimServicio;
	}

	public void setCondicionesVencimServicio(
			CondicionesVencimServicio condicionesVencimServicio) {
		this.condicionesVencimServicio = condicionesVencimServicio;
	}

}