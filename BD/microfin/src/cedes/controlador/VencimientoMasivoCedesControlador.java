package cedes.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cedes.bean.CedesBean;
import cedes.bean.TasasCedesBean;
import cedes.servicio.CedesServicio;
import cedes.servicio.TasasCedesServicio;

public class VencimientoMasivoCedesControlador extends SimpleFormController{
CedesServicio cedesServicio = null;
	
	public VencimientoMasivoCedesControlador(){
		
		setCommandClass(CedesBean.class);
 		setCommandName("cedesBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
		
		MensajeTransaccionBean mensaje = null;
		
		CedesBean cedesBean = (CedesBean) command;
		cedesServicio.getCedesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		mensaje = cedesServicio.vencimientoMasivoCedes(cedesBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CedesServicio getCedesServicio() {
		return cedesServicio;
	}

	public void setCedesServicio(CedesServicio cedesServicio) {
		this.cedesServicio = cedesServicio;
	}
	
 
}