package inversiones.controlador;

import general.bean.MensajeTransaccionBean;
import inversiones.bean.InversionBean;
import inversiones.servicio.InversionServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class ReimpresionPagareInvControlador extends SimpleFormController {
	
	public ReimpresionPagareInvControlador(){
		setCommandClass(InversionBean.class);
		setCommandName("inversionBean");
	}
	
	InversionServicio inversionServicio = null;
	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		InversionBean inversionBean = (InversionBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		
		mensaje = inversionServicio.grabaTransaccion(tipoTransaccion, inversionBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}
	

	public void setInversionServicio(InversionServicio inversionServicio) {
		this.inversionServicio = inversionServicio;
	}
}