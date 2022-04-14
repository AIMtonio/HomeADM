package originacion.controlador;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.OtrosAccesoriosBean;
import originacion.servicio.OtrosAccesoriosServicio;

public class OtrosAccesoriosGridControlador extends SimpleFormController {

	OtrosAccesoriosServicio otrosAccesoriosServicio;
	
	public OtrosAccesoriosGridControlador() {
		setCommandClass(OtrosAccesoriosBean.class);
		setCommandName("otrosAccesoriosBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		OtrosAccesoriosBean otrosAccesoriosBean = (OtrosAccesoriosBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		List<OtrosAccesoriosBean> lista = otrosAccesoriosServicio.lista(tipoLista, otrosAccesoriosBean);
		return new ModelAndView(getSuccessView(), "listaResultado", lista);
	}

	public OtrosAccesoriosServicio getOtrosAccesoriosServicio() {
		return otrosAccesoriosServicio;
	}

	public void setOtrosAccesoriosServicio(
			OtrosAccesoriosServicio otrosAccesoriosServicio) {
		this.otrosAccesoriosServicio = otrosAccesoriosServicio;
	}	

}