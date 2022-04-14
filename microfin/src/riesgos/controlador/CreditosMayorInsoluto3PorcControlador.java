package riesgos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosMayorInsoluto3PorcServicio;


public class CreditosMayorInsoluto3PorcControlador extends SimpleFormController{
	CreditosMayorInsoluto3PorcServicio creditosMayorInsoluto3PorcServicio = null;
	
	public CreditosMayorInsoluto3PorcControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("mayorSaldoInsoluto3Porc");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosMayorInsoluto3PorcServicio getCreditosMayorInsoluto3PorcServicio() {
		return creditosMayorInsoluto3PorcServicio;
	}
	public void setCreditosMayorInsoluto3PorcServicio(
			CreditosMayorInsoluto3PorcServicio creditosMayorInsoluto3PorcServicio) {
		this.creditosMayorInsoluto3PorcServicio = creditosMayorInsoluto3PorcServicio;
	}

}
