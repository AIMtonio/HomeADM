
package credito.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.ReporteServiciosAdicionalesBean;
import general.bean.MensajeTransaccionBean;

public class RepServiciosAdicionalesControlador extends SimpleFormController {
	String	successView	= null;

	public RepServiciosAdicionalesControlador() {
		setCommandClass(ReporteServiciosAdicionalesBean.class);
		setCommandName("ReporteServiciosAdicionalesBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		ReporteServiciosAdicionalesBean creditosBean = (ReporteServiciosAdicionalesBean) command;
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

}
