package inversiones.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import inversiones.bean.TipoInversionBean;
import inversiones.servicio.TipoInversionesServicio;

import general.bean.MensajeTransaccionBean;

public class TipoInversionesControlador extends SimpleFormController {
	
	private TipoInversionesControlador(){
		setCommandClass(TipoInversionBean.class);
		setCommandName("tipoInversionBean");
	}
	
	TipoInversionesServicio tipoInversionesServicio = null;
	
	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
		
		TipoInversionBean tipoInversionBean = (TipoInversionBean) command;
		
 		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje = null;
 		
 		mensaje = tipoInversionesServicio.grabaTransaccion(tipoTransaccion, tipoInversionBean);
 		
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	
	
	
	public void setTipoInversionesServicio(TipoInversionesServicio tipoInversionesServicio) {
		this.tipoInversionesServicio = tipoInversionesServicio;
	}
	
	
	

}
