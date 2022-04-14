package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.PuestosRelacionadoBean;
import soporte.servicio.PuestosRelacionadoServicio;



public class PuestosRelacionadoControlador extends SimpleFormController {

	PuestosRelacionadoServicio puestosRelacionadoServicio = null;
	
	public PuestosRelacionadoControlador() {
		setCommandClass(PuestosRelacionadoBean.class);
		setCommandName("puestos");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		PuestosRelacionadoBean cargos = (PuestosRelacionadoBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = puestosRelacionadoServicio.grabaTransaccion(tipoTransaccion, cargos);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public PuestosRelacionadoServicio getPuestosRelacionadoServicio() {
		return puestosRelacionadoServicio;
	}

	public void setPuestosRelacionadoServicio(PuestosRelacionadoServicio puestosRelacionadoServicio) {
		this.puestosRelacionadoServicio = puestosRelacionadoServicio;
	}

	

	
		
}
