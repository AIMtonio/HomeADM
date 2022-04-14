package credito.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.PagosConciliadoBean;
import credito.servicio.CreditosServicio;
import general.bean.MensajeTransaccionBean;
import soporte.servicio.UsuarioServicio;

public class RepConciliacionCobrazaMovilControlador extends SimpleFormController {

	UsuarioServicio usuarioServicio = null;
	CreditosServicio creditosServicio = null;

	public RepConciliacionCobrazaMovilControlador() {
		setCommandClass(PagosConciliadoBean.class);
		setCommandName("conciliacionCobranzaBean");
	}

	@Override
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,
			BindException errors) throws Exception {

		PagosConciliadoBean pagosConciliadoBean = (PagosConciliadoBean) command;

		MensajeTransaccionBean mensaje = creditosServicio.guardarPagosConciliados(pagosConciliadoBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

}
