package ventanilla.controlador;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.CancelacionChequesBean;
import ventanilla.servicio.CancelacionChequesServicio;

public class CancelacionChequesControlador extends SimpleFormController{
	
	CancelacionChequesServicio  cancelacionChequesServicio= null;
	
	public CancelacionChequesControlador() {
		setCommandClass(CancelacionChequesBean.class);
		setCommandName("cancelacionCheques");		
	}

	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
			BindException errors) throws Exception {	
		CancelacionChequesBean cancelacionChequesBean = (CancelacionChequesBean) command;

		cancelacionChequesServicio.getCancelacionChequesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
			Integer.parseInt(request.getParameter("tipoTransaccion")):0;

			MensajeTransaccionBean mensaje = null;
			mensaje = cancelacionChequesServicio.grabaTransaccion(cancelacionChequesBean, tipoTransaccion);

			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public CancelacionChequesServicio getCancelacionChequesServicio() {
		return cancelacionChequesServicio;
	}
	public void setCancelacionChequesServicio(
			CancelacionChequesServicio cancelacionChequesServicio) {
		this.cancelacionChequesServicio = cancelacionChequesServicio;
	}
	


}

