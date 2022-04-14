package guardaValores.controlador;

import general.bean.MensajeTransaccionBean;
import guardaValores.bean.DocumentosGuardaValoresBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class ReporteIngresoDocumentoControlador extends SimpleFormController {

	MensajeTransaccionBean mensajeTransaccionBean = null;
	
	public ReporteIngresoDocumentoControlador () {
		setCommandClass(DocumentosGuardaValoresBean.class);
		setCommandName("documentosGuardaValoresBean");

	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		return new ModelAndView(getSuccessView(), "mensaje", null);
		
	}

}
