package bancaMovil.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import bancaMovil.bean.BAMPregutaSecretaBean;
import bancaMovil.servicio.BAMPreguntaSecretaServicio;

@SuppressWarnings("deprecation")
public class BAMPreguntaSecretaControlador extends SimpleFormController {

	BAMPreguntaSecretaServicio preguntaSecretaServicio = null;

	public BAMPreguntaSecretaControlador() {
		setCommandClass(BAMPregutaSecretaBean.class);
		setCommandName("pregunta");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		preguntaSecretaServicio.getPreguntaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		BAMPregutaSecretaBean pregunta = (BAMPregutaSecretaBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = preguntaSecretaServicio.grabaTransaccion(tipoTransaccion, pregunta);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public BAMPreguntaSecretaServicio getPreguntaSecretaServicio() {
		return preguntaSecretaServicio;
	}

	public void setPreguntaSecretaServicio(BAMPreguntaSecretaServicio preguntaSecretaServicio) {
		this.preguntaSecretaServicio = preguntaSecretaServicio;
	}

}
