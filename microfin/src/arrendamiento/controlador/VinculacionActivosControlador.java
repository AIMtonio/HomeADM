package arrendamiento.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import arrendamiento.bean.ActivoArrendaBean;
import arrendamiento.servicio.ActivoArrendaServicio;

public class VinculacionActivosControlador extends SimpleFormController {

	ActivoArrendaServicio activoArrendaServicio = null;

	public VinculacionActivosControlador() {
		setCommandClass(ActivoArrendaBean.class);
		setCommandName("activoArrendaBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		// Servicio
		activoArrendaServicio.getActivoArrendaDAO().getParametrosAuditoriaBean().setNombrePrograma(
				request.getRequestURI().toString());
		// mensaje
		MensajeTransaccionBean mensaje = null;
		
		// Bean 
		ActivoArrendaBean activoArrendaBean = (ActivoArrendaBean) command;
		
		// tipo de transaccion
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer
				.parseInt(request.getParameter("tipoTransaccion")) : 0;
				
		mensaje = activoArrendaServicio.grabaTransaccionVinculacionActivos(tipoTransaccion, activoArrendaBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	// Getter y Setter
	public ActivoArrendaServicio getActivoArrendaServicio() {
		return activoArrendaServicio;
	}

	public void setActivoArrendaServicio(
			ActivoArrendaServicio activoArrendaServicio) {
		this.activoArrendaServicio = activoArrendaServicio;
	}

}
