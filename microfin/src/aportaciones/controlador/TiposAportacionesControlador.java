package aportaciones.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.TiposAportacionesBean;
import aportaciones.servicio.TiposAportacionesServicio;
import general.bean.MensajeTransaccionBean;

public class TiposAportacionesControlador extends SimpleFormController{
	
	private TiposAportacionesControlador(){
		setCommandClass(TiposAportacionesBean.class);
		setCommandName("tiposAportacionesBean");
	}
	
	TiposAportacionesServicio tiposAportacionesServicio = null;
	
	
	 protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
		
		 tiposAportacionesServicio.getTiposAportacionesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		TiposAportacionesBean tiposAportacionesBean = (TiposAportacionesBean) command;
		
 		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje = null;
 		
 		mensaje = tiposAportacionesServicio.grabaTransaccion(tipoTransaccion, tiposAportacionesBean);
 		
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}


	public TiposAportacionesServicio getTiposAportacionesServicio() {
		return tiposAportacionesServicio;
	}


	public void setTiposAportacionesServicio(
			TiposAportacionesServicio tiposAportacionesServicio) {
		this.tiposAportacionesServicio = tiposAportacionesServicio;
	}
	 
	
	 
}
