package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.ControlClaveBean;
import soporte.servicio.ControlClaveServicio;


public class CapturaClavesControlador extends SimpleFormController{
	ControlClaveServicio controlClaveServicio = null;
	public CapturaClavesControlador() {
		setCommandClass(ControlClaveBean.class);
		setCommandName("controlClaveBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		controlClaveServicio.getControlClaveDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ControlClaveBean controlClave= (ControlClaveBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		String desplegado =(request.getParameter("desplegado")!=null)?
						request.getParameter("desplegado"):"";
		MensajeTransaccionBean mensaje = null;
		controlClave.setOrigenDatos(desplegado);
		mensaje = controlClaveServicio.grabaTransaccion(tipoTransaccion, controlClave);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ControlClaveServicio getControlClaveServicio() {
		return controlClaveServicio;
	}

	public void setControlClaveServicio(ControlClaveServicio controlClaveServicio) {
		this.controlClaveServicio = controlClaveServicio;
	}
	
}
