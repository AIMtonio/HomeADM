package riesgos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosMayorInsoluto10PorcServicio;

public class CreditosMayorInsoluto10PorcControlador extends SimpleFormController{
	CreditosMayorInsoluto10PorcServicio creditosMayorInsoluto10PorcServicio = null;
	
	public CreditosMayorInsoluto10PorcControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("mayorSaldoInsoluto10Porc");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosMayorInsoluto10PorcServicio getCreditosMayorInsoluto10PorcServicio() {
		return creditosMayorInsoluto10PorcServicio;
	}
	public void setCreditosMayorInsoluto10PorcServicio(
			CreditosMayorInsoluto10PorcServicio creditosMayorInsoluto10PorcServicio) {
		this.creditosMayorInsoluto10PorcServicio = creditosMayorInsoluto10PorcServicio;
	}
	
}
