package contabilidad.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.RepPolizasIntersucBean;
import contabilidad.servicio.RepPolizasIntersucServicio;

public class RepPolizasIntersucControlador extends SimpleFormController {
	RepPolizasIntersucServicio repPolizasIntersuc = null;

	String nombreReporte = null;
	String successView = null;

	public RepPolizasIntersucControlador() {
		setCommandClass(RepPolizasIntersucBean.class);
		setCommandName("repPolizasIntersuc");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		repPolizasIntersuc.getReportePolizasIntersucDAO()
				.getParametrosAuditoriaBean()
				.setNombrePrograma(request.getRequestURI().toString());
		RepPolizasIntersucBean repPolizasIntersuc = (RepPolizasIntersucBean) command;

		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer
				.parseInt(request.getParameter("tipoTransaccion")) : 0;

		MensajeTransaccionBean mensaje = null;

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}

	public RepPolizasIntersucServicio getRepPolizasIntersuc() {
		return repPolizasIntersuc;
	}

	public void setRepPolizasIntersuc(
			RepPolizasIntersucServicio repPolizasIntersuc) {
		this.repPolizasIntersuc = repPolizasIntersuc;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

}
