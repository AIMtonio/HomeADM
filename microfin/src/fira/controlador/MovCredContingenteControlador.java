package fira.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class MovCredContingenteControlador extends SimpleFormController {
	CreditosServicio	creditosServicio	= null;
	String				successView			= null;
	
	public MovCredContingenteControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		CreditosBean creditosBean = (CreditosBean) command;
		MensajeTransaccionBean mensaje = null;
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}
}
