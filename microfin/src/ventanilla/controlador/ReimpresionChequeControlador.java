package ventanilla.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.ReimpresionChequeBean;
import ventanilla.servicio.ReimpresionChequeServicio;

public class ReimpresionChequeControlador extends SimpleFormController {
	ReimpresionChequeServicio reimpresionChequeServicio = null;

	String successView = null;

	public ReimpresionChequeControlador() {
		setCommandClass(ReimpresionChequeBean.class);
		setCommandName("reimpresionCheque");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		reimpresionChequeServicio.getReimpresionChequeDAO()
				.getParametrosAuditoriaBean()
				.setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionBean mensaje = null;

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}

	public ReimpresionChequeServicio getReimpresionChequeServicio() {
		return reimpresionChequeServicio;
	}

	public void setReimpresionChequeServicio(
			ReimpresionChequeServicio reimpresionChequeServicio) {
		this.reimpresionChequeServicio = reimpresionChequeServicio;
	}



}
