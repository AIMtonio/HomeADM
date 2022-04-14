package riesgos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosMayorInsolutoPFServicio;

public class CreditosMayorInsolutoPFControlador extends SimpleFormController{
	CreditosMayorInsolutoPFServicio creditosMayorInsolutoPFServicio = null;
	
	public CreditosMayorInsolutoPFControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("mayorSaldoInsolutoPF");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosMayorInsolutoPFServicio getCreditosMayorInsolutoPFServicio() {
		return creditosMayorInsolutoPFServicio;
	}
	public void setCreditosMayorInsolutoPFServicio(
			CreditosMayorInsolutoPFServicio creditosMayorInsolutoPFServicio) {
		this.creditosMayorInsolutoPFServicio = creditosMayorInsolutoPFServicio;
	}

}
