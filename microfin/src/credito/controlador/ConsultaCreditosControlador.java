package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class ConsultaCreditosControlador extends SimpleFormController{

	CreditosServicio creditosServicio = null;
	
	public ConsultaCreditosControlador () {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		CreditosBean creditos = (CreditosBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = creditosServicio.grabaTransaccion(tipoTransaccion,0, creditos,request);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}
		
}
