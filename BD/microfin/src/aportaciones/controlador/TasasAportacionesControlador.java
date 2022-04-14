package aportaciones.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.TasasAportacionesBean;
import aportaciones.servicio.TasasAportacionesServicio;

public class TasasAportacionesControlador extends SimpleFormController{
	
	TasasAportacionesServicio tasasAportacionesServicio = null;
	
	public TasasAportacionesControlador(){
		
		setCommandClass(TasasAportacionesBean.class);
 		setCommandName("tasasBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
	
		tasasAportacionesServicio.getTasasAportacionesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		TasasAportacionesBean tasasbean = (TasasAportacionesBean) command;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
					
		String tasaAportacion =(request.getParameter("tasaAportacionID")!=null)?
				request.getParameter("tasaAportacionID"):"";
		MensajeTransaccionBean mensaje = null;
		mensaje = tasasAportacionesServicio.grabaTransaccion(tipoTransaccion, tasasbean,tasaAportacion);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public TasasAportacionesServicio getTasasAportacionesServicio() {
		return tasasAportacionesServicio;
	}

	public void setTasasAportacionesServicio(
			TasasAportacionesServicio tasasAportacionesServicio) {
		this.tasasAportacionesServicio = tasasAportacionesServicio;
	}
	
	
	
}
