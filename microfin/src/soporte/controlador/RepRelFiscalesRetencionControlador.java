package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.RelacionadosFiscalesBean;

public class RepRelFiscalesRetencionControlador extends SimpleFormController {
	
	public RepRelFiscalesRetencionControlador(){
		setCommandClass(RelacionadosFiscalesBean.class);
		setCommandName("relacionadosFiscalesBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,	HttpServletResponse response,
			Object command,	BindException errors)
			throws Exception {
		
		MensajeTransaccionBean mensaje = null;

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
}
