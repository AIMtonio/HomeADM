package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.RatiosBean;
import originacion.servicio.RatiosServicio;

public class CalculoRatiosControlador extends SimpleFormController {
	
	RatiosServicio	ratiosServicio	= null;
	
	/**
	 * Controlador de la pantalla de Solicitud Credito> Registro > Ratios
	 */
	public CalculoRatiosControlador() {
		
		setCommandClass(RatiosBean.class);
		setCommandName("ratiosBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		RatiosBean ratiosBean = (RatiosBean) command;
		ratiosServicio.getRatiosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
		MensajeTransaccionBean mensaje = null;
		mensaje = ratiosServicio.grabaTransaccion(tipoTransaccion, ratiosBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public void setRatiosServicio(RatiosServicio ratiosServicio) {
		this.ratiosServicio = ratiosServicio;
	}
	
}
