package crowdfunding.controlador;

import herramientas.Utileria;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.ParamGeneralesBean;
import crowdfunding.bean.ParametrosCRWBean;
import crowdfunding.servicio.ParametrosCRWServicio;

public class ParametrosCRWControlador extends SimpleFormController {

	ParametrosCRWServicio parametrosCRWServicio = null;

	public ParametrosCRWControlador() {
		setCommandClass(ParametrosCRWBean.class);
		setCommandName("parametrosCRWBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,							
			BindException errors) throws Exception {
		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));

		ParametrosCRWBean parametrosCRWBean = (ParametrosCRWBean) command;
		ParamGeneralesBean generalesBean = new ParamGeneralesBean();
		generalesBean.setLlaveParametro("ActivoModCrowd");
		generalesBean.setValorParametro(request.getParameter("habilitaFondeo"));
		parametrosCRWServicio.getParametrosCRWDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionBean mensaje = null;
		mensaje = parametrosCRWServicio.grabaTransaccion(tipoTransaccion,parametrosCRWBean,generalesBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ParametrosCRWServicio getParametrosCRWServicio() {
		return parametrosCRWServicio;
	}

	public void setParametrosCRWServicio(
			ParametrosCRWServicio parametrosCRWServicio) {
		this.parametrosCRWServicio = parametrosCRWServicio;
	}

}