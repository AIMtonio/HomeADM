package cedes.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cedes.bean.CedesBean;
import cedes.bean.TasasCedesBean;
import cedes.servicio.TasasCedesServicio;

public class TasasCedesControlador extends SimpleFormController{
	
	TasasCedesServicio tasasCedesServicio = null;
	
	public TasasCedesControlador(){
		
		setCommandClass(TasasCedesBean.class);
 		setCommandName("tasasBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
		
		tasasCedesServicio.getTasasCedesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		TasasCedesBean tasasbean = (TasasCedesBean) command;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
					
		String tasaCede =(request.getParameter("tasaCedeID")!=null)?
				request.getParameter("tasaCedeID"):"";
		MensajeTransaccionBean mensaje = null;
		mensaje = tasasCedesServicio.grabaTransaccion(tipoTransaccion, tasasbean,tasaCede);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public TasasCedesServicio getTasasCedesServicio() {
		return tasasCedesServicio;
	}

	public void setTasasCedesServicio(TasasCedesServicio tasasCedesServicio) {
		this.tasasCedesServicio = tasasCedesServicio;
	}

 
	

}
