package credito.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import credito.bean.RazonesNoPagoBean;
import credito.servicio.CreditosServicio;

import pld.bean.OpeInusualesBean;

public class RepRazonesNoPagoVistaControlador extends SimpleFormController {

	CreditosServicio creditosServicio = null;

	public RepRazonesNoPagoVistaControlador() {
		setCommandClass(RazonesNoPagoBean.class);
		setCommandName("razonesNoPagoBean");
	}
	
protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		RazonesNoPagoBean razones = (RazonesNoPagoBean) command;
		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}
	
	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

}
