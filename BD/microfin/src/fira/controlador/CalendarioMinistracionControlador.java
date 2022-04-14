package fira.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.CalendarioMinistracionBean;
import fira.servicio.CalendarioMinistracionServicio;
import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

public class CalendarioMinistracionControlador extends SimpleFormController {

	CalendarioMinistracionServicio calendarioMinistracionServicio = null;

	public CalendarioMinistracionControlador(){
		setCommandClass(CalendarioMinistracionBean.class);
		setCommandName("calendarioMinistra");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response,
			Object command, BindException errors) throws Exception {

		CalendarioMinistracionBean calendarioMinistracionBean = (CalendarioMinistracionBean) command;

		calendarioMinistracionServicio.getCalendarioMinistracionDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)? Utileria.convierteEntero(request.getParameter("tipoTransaccion")): 0;

		MensajeTransaccionBean mensaje = null;
		mensaje = calendarioMinistracionServicio.grabaTransaccion(tipoTransaccion, calendarioMinistracionBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CalendarioMinistracionServicio getCalendarioMinistracionServicio() {
		return calendarioMinistracionServicio;
	}

	public void setCalendarioMinistracionServicio(
			CalendarioMinistracionServicio calendarioMinistracionServicio) {
		this.calendarioMinistracionServicio = calendarioMinistracionServicio;
	}

}