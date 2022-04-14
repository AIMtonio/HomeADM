package inversiones.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import inversiones.bean.InversionBean;
import inversiones.servicio.InversionServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class InversionControlador extends SimpleFormController {
	
	public InversionControlador(){
		setCommandClass(InversionBean.class);
		setCommandName("inversionBean");
	}
	
	InversionServicio inversionServicio = null;
	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		inversionServicio.getInversionDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
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
