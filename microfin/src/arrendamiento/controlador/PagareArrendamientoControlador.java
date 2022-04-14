package arrendamiento.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import arrendamiento.bean.ArrendamientosBean;
import arrendamiento.servicio.ArrendamientosServicio;

public class PagareArrendamientoControlador extends SimpleFormController{
	
	ArrendamientosServicio arrendamientosServicio = null;
	
	public PagareArrendamientoControlador(){
 		setCommandClass(ArrendamientosBean.class);
 		setCommandName("arrendamientosBean");
 	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		arrendamientosServicio.getArrendamientosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionBean mensaje = null;
		ArrendamientosBean arrendamientosBean = (ArrendamientosBean) command;
		int tipoActualizacion = (request.getParameter("tipoActualizacion") != null) ? Integer
				.parseInt(request.getParameter("tipoActualizacion")) : 0;
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer
				.parseInt(request.getParameter("tipoTransaccion")) : 0;

		mensaje = arrendamientosServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, arrendamientosBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ArrendamientosServicio getArrendamientosServicio() {
		return arrendamientosServicio;
	}

	public void setArrendamientosServicio(
			ArrendamientosServicio arrendamientosServicio) {
		this.arrendamientosServicio = arrendamientosServicio;
	}
}
