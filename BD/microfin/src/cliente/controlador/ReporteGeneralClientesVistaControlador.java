package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteGeneralBean;
import general.bean.MensajeTransaccionBean;

@SuppressWarnings("deprecation")
public class ReporteGeneralClientesVistaControlador extends SimpleFormController {

	String successView = null;
	
	public ReporteGeneralClientesVistaControlador() {
		setCommandClass(ClienteGeneralBean.class);
		setCommandName("clienteGeneralBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,							
			BindException errors) throws Exception {

		MensajeTransaccionBean mensaje = null;
	
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
}
