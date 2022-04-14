package tesoreria.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.RepDepositosRefBean;
import tesoreria.servicio.RepDepositosRefServicio;



public class RepDepositosRefControlador extends SimpleFormController {
	RepDepositosRefServicio repDepositosRef = null;

	String nombreReporte = null;
	String successView = null;

	public RepDepositosRefControlador() {
		setCommandClass(RepDepositosRefBean.class);
		setCommandName("repDepositosRef");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		repDepositosRef.getRepDepositosRefDAO()
				.getParametrosAuditoriaBean()
				.setNombrePrograma(request.getRequestURI().toString());
		RepDepositosRefBean repDepositosRefe = (RepDepositosRefBean) command;

		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer
				.parseInt(request.getParameter("tipoTransaccion")) : 0;

		MensajeTransaccionBean mensaje = null;

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}


	public RepDepositosRefServicio getRepDepositosRef() {
		return repDepositosRef;
	}

	public void setRepDepositosRef(RepDepositosRefServicio repDepositosRef) {
		this.repDepositosRef = repDepositosRef;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

}

