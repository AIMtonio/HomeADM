package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractFormController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.CancelaFacturaBean;
import soporte.servicio.CancelaFacturaServicio;

public class CancelaFacturaControlador extends SimpleFormController{
	CancelaFacturaServicio cancelaFacturaServicio=null;
	public CancelaFacturaControlador() {
		setCommandClass(CancelaFacturaBean.class);
		setCommandName("cancelarFactura");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		
		CancelaFacturaBean cancelaFactura= (CancelaFacturaBean) command;			
		cancelaFacturaServicio.getCancelaFacturaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		MensajeTransaccionBean mensaje = null;
					
		mensaje = cancelaFacturaServicio.grabaTransaccion(cancelaFactura);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
				
	public CancelaFacturaServicio getCancelaFacturaServicio() {
		return cancelaFacturaServicio;
	}
	public void setCancelaFacturaServicio(CancelaFacturaServicio cancelaFacturaServicio) {
		this.cancelaFacturaServicio = cancelaFacturaServicio;
	}
}
