package credito.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class CancelaCreditoControlador extends SimpleFormController {
	
	CreditosServicio	creditosServicio	= null;
	
	public CancelaCreditoControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		CreditosBean creditos = (CreditosBean) command;
		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		int tipoActualizacion = Utileria.convierteEntero(request.getParameter("tipoActualizacion"));
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		MensajeTransaccionBean mensaje = null;
		creditos.setUsuarioAutoriza(request.getParameter("usuarioAutoriza"));
		creditos.setContrasenia(request.getParameter("contraseniaAutoriza"));
		mensaje = creditosServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, creditos, request);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}
	
	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}
	
}
