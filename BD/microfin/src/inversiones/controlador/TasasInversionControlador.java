package inversiones.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import inversiones.bean.TasasInversionBean;
import inversiones.servicio.TasasInversionServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class TasasInversionControlador extends SimpleFormController {
	
	public TasasInversionControlador(){
		setCommandClass(TasasInversionBean.class);
		setCommandName("tasasInversionBean");
	}
	
	
	TasasInversionServicio tasasInversionServicio = null;
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		
		TasasInversionBean tasasInversionBean = (TasasInversionBean) command;
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		
		mensaje = tasasInversionServicio.grabaTransaccion(tipoTransaccion, tasasInversionBean);
		
		
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	
	
	public void setTasasInversionServicio(TasasInversionServicio tasasInversionServicio) {
		this.tasasInversionServicio = tasasInversionServicio;
	}
}
