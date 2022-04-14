package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.CliExtranjeroBean;
import cliente.servicio.CliExtranjeroServicio;


public class CliExtranjeroControlador extends SimpleFormController {
	
	CliExtranjeroServicio cliExtranjeroServicio = null;
	
	public CliExtranjeroControlador() {
		setCommandClass(CliExtranjeroBean.class);
		setCommandName("CliExtranjero");
	}
		
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		CliExtranjeroBean cliExBean = (CliExtranjeroBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = cliExtranjeroServicio.grabaTransaccion(tipoTransaccion,cliExBean);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}


	public void setCliExtranjeroServicio(CliExtranjeroServicio cliExtranjeroServicio) {
		this.cliExtranjeroServicio = cliExtranjeroServicio;
	}

	
}
