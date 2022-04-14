package guardaValores.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;
import guardaValores.bean.ParamGuardaValoresBean;
import guardaValores.servicio.ParamGuardaValoresServicio;

public class ParamGuardaValoresControlador extends SimpleFormController {

	ParamGuardaValoresServicio paramGuardaValoresServicio = null;

	public ParamGuardaValoresControlador() {
		setCommandClass(ParamGuardaValoresBean.class);
		setCommandName("paramGuardaValoresBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		paramGuardaValoresServicio.getParamGuardaValoresDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
		
		ParamGuardaValoresBean paramGuardaValoresBean = (ParamGuardaValoresBean) command;
		MensajeTransaccionBean mensajeTransaccionBean = null;
		mensajeTransaccionBean = paramGuardaValoresServicio.grabaTransaccion(tipoTransaccion, paramGuardaValoresBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensajeTransaccionBean);
	}

	public ParamGuardaValoresServicio getParamGuardaValoresServicio() {
		return paramGuardaValoresServicio;
	}

	public void setParamGuardaValoresServicio(ParamGuardaValoresServicio paramGuardaValoresServicio) {
		this.paramGuardaValoresServicio = paramGuardaValoresServicio;
	}

}
