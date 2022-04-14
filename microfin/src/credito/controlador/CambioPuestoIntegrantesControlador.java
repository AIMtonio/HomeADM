package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CambioPuestoIntegrantesBean;
import credito.servicio.CambioPuestoIntegrantesServicio;

public class CambioPuestoIntegrantesControlador extends SimpleFormController {
	CambioPuestoIntegrantesServicio cambioPuestoIntegrantesServicio = null;
	
	public CambioPuestoIntegrantesControlador(){
		setCommandClass(CambioPuestoIntegrantesBean.class);
		setCommandName("cambioPuestoIntegrantesBean");	
	}
	protected ModelAndView onSubmit(HttpServletRequest request, 
			HttpServletResponse response, Object command,
			BindException errors) throws Exception {
		
		cambioPuestoIntegrantesServicio.getCambioPuestoIntegrantesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		
		CambioPuestoIntegrantesBean cambioPuestoIntegrantesBean =(CambioPuestoIntegrantesBean) command;
		
				int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ?
				Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
	
		MensajeTransaccionBean mensaje = null;	
		mensaje = cambioPuestoIntegrantesServicio.grabaTransaccion(tipoTransaccion,cambioPuestoIntegrantesBean);
			
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	//fin del onSubmit
	
	//* ============== Getter & Setter =============  //*	
	public CambioPuestoIntegrantesServicio getCambioPuestoIntegrantesServicio() {
		return cambioPuestoIntegrantesServicio;
	}
	public void setCambioPuestoIntegrantesServicio(
			CambioPuestoIntegrantesServicio cambioPuestoIntegrantesServicio) {
		this.cambioPuestoIntegrantesServicio = cambioPuestoIntegrantesServicio;
	}
}
