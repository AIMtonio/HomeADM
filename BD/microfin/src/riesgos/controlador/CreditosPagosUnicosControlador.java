package riesgos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosPagosUnicosServicio;

public class CreditosPagosUnicosControlador extends SimpleFormController{
	CreditosPagosUnicosServicio creditosPagosUnicosServicio = null;
	
	public CreditosPagosUnicosControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("pagosUnicos");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosPagosUnicosServicio getCreditosPagosUnicosServicio() {
		return creditosPagosUnicosServicio;
	}
	public void setCreditosPagosUnicosServicio(
			CreditosPagosUnicosServicio creditosPagosUnicosServicio) {
		this.creditosPagosUnicosServicio = creditosPagosUnicosServicio;
	}

}
