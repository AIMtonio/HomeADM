package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.CargosBean;
import soporte.servicio.CargosServicio;


public class CargosControlador extends SimpleFormController {

	CargosServicio cargosServicio = null;
	
	public CargosControlador() {
		setCommandClass(CargosBean.class);
		setCommandName("cargos");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		CargosBean cargos = (CargosBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = cargosServicio.grabaTransaccion(tipoTransaccion, cargos);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CargosServicio getCargosServicio() {
		return cargosServicio;
	}

	public void setCargosServicio(CargosServicio cargosServicio) {
		this.cargosServicio = cargosServicio;
	}

	
		
}
