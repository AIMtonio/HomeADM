package inversiones.controlador;


import inversiones.servicio.RepRetensionISRServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.RepDepositosRefBean;
import tesoreria.servicio.RepDepositosRefServicio;



public class RepRetensionISRControlador extends SimpleFormController {
	RepRetensionISRServicio repRetensionISR = null;

	String nombreReporte = null;
	String successView = null;

	public RepRetensionISRControlador() {
		setCommandClass(RepDepositosRefBean.class);
		setCommandName("repRetensionISR");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		repRetensionISR.getRepRetensionISRDAO()
				.getParametrosAuditoriaBean()
				.setNombrePrograma(request.getRequestURI().toString());
		RepDepositosRefBean repDepositosRefe = (RepDepositosRefBean) command;

		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer
				.parseInt(request.getParameter("tipoTransaccion")) : 0;

		MensajeTransaccionBean mensaje = null;

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}
	
	public RepRetensionISRServicio getRepRetensionISR() {
		return repRetensionISR;
	}

	public void setRepRetensionISR(RepRetensionISRServicio repRetensionISR) {
		this.repRetensionISR = repRetensionISR;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

}

