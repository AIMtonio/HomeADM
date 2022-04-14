package activos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import activos.bean.ActivosBean;
import activos.servicio.ActivosServicio;

public class ActivosControlador extends SimpleFormController{
	private ActivosServicio activosServicio = null;
	
	public ActivosControlador(){
		setCommandClass(ActivosBean.class);
		setCommandName("activosBean");		
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		activosServicio.getActivosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ActivosBean activosBean = (ActivosBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		
		mensaje = activosServicio.grabaTransaccion(tipoTransaccion, activosBean);
				
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ActivosServicio getActivosServicio() {
		return activosServicio;
	}

	public void setActivosServicio(ActivosServicio activosServicio) {
		this.activosServicio = activosServicio;
	}

}
