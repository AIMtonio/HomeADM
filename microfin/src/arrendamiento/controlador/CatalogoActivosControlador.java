package arrendamiento.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import arrendamiento.bean.ActivoArrendaBean;
import arrendamiento.servicio.ActivoArrendaServicio;

public class CatalogoActivosControlador extends SimpleFormController {

	ActivoArrendaServicio activoArrendaServicio = null;

	public CatalogoActivosControlador() {
		setCommandClass(ActivoArrendaBean.class);
		setCommandName("activoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		// Servicio
		activoArrendaServicio.getActivoArrendaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		// mensaje
		MensajeTransaccionBean mensaje = null;
		
		// Bean
		ActivoArrendaBean activoBean = (ActivoArrendaBean) command;
		
		// tipo de transaccion
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;

		mensaje = activoArrendaServicio.grabaTransaccion(tipoTransaccion, activoBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	
	//---------- Getter y Setters ------------------------------------------------------------------------
	public ActivoArrendaServicio getActivoArrendaServicio() {
		return activoArrendaServicio;
	}

	public void setActivoArrendaServicio(ActivoArrendaServicio activoArrendaServicio) {
		this.activoArrendaServicio = activoArrendaServicio;
	}
}
