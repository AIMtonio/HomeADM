package originacion.controlador;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.EsquemaOtrosAccesoriosBean;
import originacion.servicio.EsquemaOtrosAccesoriosServicio;


public class EsquemaOtrosAccesoriosGridControlador extends SimpleFormController {

	EsquemaOtrosAccesoriosServicio esquemaOtrosAccesoriosServicio;
	
	public EsquemaOtrosAccesoriosGridControlador() {
		setCommandClass(EsquemaOtrosAccesoriosBean.class);
		setCommandName("esquemaOtrosAccesoriosBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		EsquemaOtrosAccesoriosBean otrosAccesoriosBean = (EsquemaOtrosAccesoriosBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		List<EsquemaOtrosAccesoriosBean> lista = esquemaOtrosAccesoriosServicio.lista(tipoLista, otrosAccesoriosBean);
		return new ModelAndView(getSuccessView(), "listaResultado", lista);
	}

	public EsquemaOtrosAccesoriosServicio getEsquemaOtrosAccesoriosServicio() {
		return esquemaOtrosAccesoriosServicio;
	}

	public void setEsquemaOtrosAccesoriosServicio(
			EsquemaOtrosAccesoriosServicio esquemaOtrosAccesoriosServicio) {
		this.esquemaOtrosAccesoriosServicio = esquemaOtrosAccesoriosServicio;
	}

}