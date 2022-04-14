package originacion.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.EsquemaSeguroBean;
import originacion.servicio.EsquemaSeguroServicio;

public class EsquemaSeguroGridControlador extends SimpleFormController {
	
	EsquemaSeguroServicio esquemaSeguroServicio;
	
	public EsquemaSeguroGridControlador() {
		setCommandClass(EsquemaSeguroBean.class);
		setCommandName("paramDiasFrecuenciaBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		EsquemaSeguroBean esquemaSeguroBean = (EsquemaSeguroBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List<EsquemaSeguroBean> lista = esquemaSeguroServicio.lista(tipoLista, esquemaSeguroBean);
		return new ModelAndView(getSuccessView(), "listaResultado", lista);
	}

	public EsquemaSeguroServicio getEsquemaSeguroServicio() {
		return esquemaSeguroServicio;
	}

	public void setEsquemaSeguroServicio(EsquemaSeguroServicio esquemaSeguroServicio) {
		this.esquemaSeguroServicio = esquemaSeguroServicio;
	}

}
