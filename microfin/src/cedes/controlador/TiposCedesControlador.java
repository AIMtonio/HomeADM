package cedes.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cedes.bean.TiposCedesBean;
import cedes.servicio.TiposCedesServicio;
import general.bean.MensajeTransaccionBean;

public class TiposCedesControlador extends SimpleFormController {
	
	private TiposCedesControlador(){
		setCommandClass(TiposCedesBean.class);
		setCommandName("tiposCedesBean");
	}
	
	TiposCedesServicio tiposCedesServicio = null;
	
	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
		
		tiposCedesServicio.getTiposCedesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		TiposCedesBean tiposCedesBean = (TiposCedesBean) command;
		
 		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje = null;
 		
 		mensaje = tiposCedesServicio.grabaTransaccion(tipoTransaccion, tiposCedesBean);
 		
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public TiposCedesServicio getTiposCedesServicio() {
		return tiposCedesServicio;
	}

	public void setTiposCedesServicio(TiposCedesServicio tiposCedesServicio) {
		this.tiposCedesServicio = tiposCedesServicio;
	}	
	
	
	 

}
