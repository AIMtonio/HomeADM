package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.TotalAplicadosWSBean;

public class TotalAplicadosWSRepControlador extends SimpleFormController {
	
	public TotalAplicadosWSRepControlador() {
		setCommandClass(TotalAplicadosWSBean.class);
		setCommandName("totalAplicadosWSBean");
	}
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		 MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
}
