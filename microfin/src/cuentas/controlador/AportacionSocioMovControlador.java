package cuentas.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.AportacionSocioBean;
import cuentas.servicio.AportacionSocioServicio;

public class AportacionSocioMovControlador extends SimpleFormController{

	AportacionSocioServicio aportacionSocioServicio = null;

 	public AportacionSocioMovControlador(){
 		setCommandClass(AportacionSocioBean.class);
 		setCommandName("aportacionSocio");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 		

										
			MensajeTransaccionBean mensaje = null;
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		
 	}
 	
 	// ---------------  getter y setter -------------------- 
	public AportacionSocioServicio getAportacionSocioServicio() {
		return aportacionSocioServicio;
	}

	public void setAportacionSocioServicio(
			AportacionSocioServicio aportacionSocioServicio) {
		this.aportacionSocioServicio = aportacionSocioServicio;
	}
 } 