package credito.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;
import general.bean.MensajeTransaccionBean;

public class CobranzaAutomaticaRefereControlador extends SimpleFormController {
	CreditosServicio creditosServicio = null;

	public CobranzaAutomaticaRefereControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("usuario");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		CreditosBean bean = (CreditosBean) command;
		MensajeTransaccionBean mensaje = null;
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setNombrePrograma("CobranzaAutoRefereControlador");
		mensaje = creditosServicio.realizaCobranzaAutomaticaReferencia(bean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}


}
