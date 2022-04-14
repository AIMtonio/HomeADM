package aportaciones.controlador;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.AportDispersionesBean;
import aportaciones.servicio.AportDispersionesServicio;

public class AportDispersionesGridControlador extends SimpleFormController {

	AportDispersionesServicio aportDispersionesServicio;
	
	public AportDispersionesGridControlador() {
		setCommandClass(AportDispersionesBean.class);
		setCommandName("aportDispersionesBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		AportDispersionesBean gruposFamBean = (AportDispersionesBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		List<AportDispersionesBean> lista = aportDispersionesServicio.lista(tipoLista, gruposFamBean);
		return new ModelAndView(getSuccessView(), "listaResultado", lista);
	}

	public AportDispersionesServicio getAportDispersionesServicio() {
		return aportDispersionesServicio;
	}

	public void setAportDispersionesServicio(
			AportDispersionesServicio aportDispersionesServicio) {
		this.aportDispersionesServicio = aportDispersionesServicio;
	}

}