package soporte.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;
import soporte.bean.ParamCreditPaymentBean;
import soporte.servicio.ParamCreditPaymentServicio;

public class ParamCreditPaymentControlador extends SimpleFormController{

	ParamCreditPaymentServicio paramCreditPaymentServicio = null;

	public ParamCreditPaymentControlador(){
		setCommandClass(ParamCreditPaymentBean.class);
		setCommandName("paramCreditPaymentBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response,
				Object command, BindException errors) throws Exception {

		ParamCreditPaymentBean paramCreditPaymentBean = (ParamCreditPaymentBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		MensajeTransaccionBean mensaje = null;
		mensaje = paramCreditPaymentServicio.grabaTransaccion(tipoTransaccion,paramCreditPaymentBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ParamCreditPaymentServicio getParamCreditPaymentServicio() {
		return paramCreditPaymentServicio;
	}

	public void setParamCreditPaymentServicio(ParamCreditPaymentServicio paramCreditPaymentServicio) {
		this.paramCreditPaymentServicio = paramCreditPaymentServicio;
	}

	
}
