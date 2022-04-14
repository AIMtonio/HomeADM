package bancaMovil.controlador;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import bancaMovil.bean.BAMImagenAntiphishingBean;
import bancaMovil.servicio.BAMImagenAntiphishingServicio;
import general.bean.MensajeTransaccionBean;
import soporte.bean.CuentaArchivosBean;

@SuppressWarnings("deprecation")
public class BAMImagenPhishingControlador extends SimpleFormController {

	BAMImagenAntiphishingServicio imagenAntiphishingServicio = null;

	public BAMImagenPhishingControlador() {
		setCommandClass(CuentaArchivosBean.class);
		setCommandName("imagen");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,
			BindException errors) throws ServletException, IOException {

		BAMImagenAntiphishingBean imagenBean = (BAMImagenAntiphishingBean) command;
		MensajeTransaccionBean mensaje = null;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		mensaje = imagenAntiphishingServicio.grabaTransaccion(tipoTransaccion, imagenBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public BAMImagenAntiphishingServicio getImagenAntiphishingServicio() {
		return imagenAntiphishingServicio;
	}

	public void setImagenAntiphishingServicio(BAMImagenAntiphishingServicio imagenAntiphishingServicio) {
		this.imagenAntiphishingServicio = imagenAntiphishingServicio;
	}

}
