package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.MotivoCancelacionChequesBean;
import tesoreria.servicio.MotivoCancelacionChequesServicio;


public class MotivoCancelacionChequesControlador extends SimpleFormController{
	
	MotivoCancelacionChequesServicio motivoCancelacionChequesServicio = null;

	public MotivoCancelacionChequesControlador() {
		setCommandClass(MotivoCancelacionChequesBean.class);
		setCommandName("motivoCancelacionCheques");
}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		motivoCancelacionChequesServicio.getMotivoCancelacionChequesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MotivoCancelacionChequesBean motivoCancelacionCheques = (MotivoCancelacionChequesBean) command;
		
		int tipoTransaccion = (request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
		

		MensajeTransaccionBean mensaje = null;
		mensaje = motivoCancelacionChequesServicio.grabaTransaccion(tipoTransaccion,motivoCancelacionCheques);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public MotivoCancelacionChequesServicio getMotivoCancelacionChequesServicio() {
		return motivoCancelacionChequesServicio;
	}

	public void setMotivoCancelacionChequesServicio(
			MotivoCancelacionChequesServicio motivoCancelacionChequesServicio) {
		this.motivoCancelacionChequesServicio = motivoCancelacionChequesServicio;
	}
	

}
