package riesgos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosMayorInsolutoPMServicio;

public class CreditosMayorInsolutoPMControlador extends SimpleFormController{
	CreditosMayorInsolutoPMServicio creditosMayorInsolutoPMServicio = null;
	
	public CreditosMayorInsolutoPMControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("mayorSaldoInsolutoPM");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosMayorInsolutoPMServicio getCreditosMayorInsolutoPMServicio() {
		return creditosMayorInsolutoPMServicio;
	}
	public void setCreditosMayorInsolutoPMServicio(
			CreditosMayorInsolutoPMServicio creditosMayorInsolutoPMServicio) {
		this.creditosMayorInsolutoPMServicio = creditosMayorInsolutoPMServicio;
	}
	
}
