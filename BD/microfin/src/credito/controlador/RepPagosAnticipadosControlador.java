
package credito.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import general.bean.MensajeTransaccionBean;

public class RepPagosAnticipadosControlador extends SimpleFormController {
	String	successView	= null;

	public RepPagosAnticipadosControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		CreditosBean creditosBean = (CreditosBean) command;
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

}
