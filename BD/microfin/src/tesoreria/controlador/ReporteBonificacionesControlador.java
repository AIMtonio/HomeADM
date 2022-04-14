package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.BonificacionesBean;

public class ReporteBonificacionesControlador extends SimpleFormController {

	MensajeTransaccionBean mensajeTransaccionBean = null;

	public ReporteBonificacionesControlador () {
		setCommandClass(BonificacionesBean.class);
		setCommandName("bonificacionesBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		return new ModelAndView(getSuccessView(), "mensaje", null);

	}

}
