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

public class CedesControlador extends SimpleFormController{
	
	CedesServicio cedesServicio = null;
	
	public CedesControlador(){
		
		setCommandClass(CedesBean.class);
 		setCommandName("cedesBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
		
		cedesServicio.getCedesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		CedesBean cedesBean = (CedesBean) command;
		
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
		MensajeTransaccionBean mensaje = null;
		mensaje = cedesServicio.grabaTransaccion(tipoTransaccion, cedesBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CedesServicio getCedesServicio() {
		return cedesServicio;
	}

	public void setCedesServicio(CedesServicio cedesServicio) {
		this.cedesServicio = cedesServicio;
	} 
	

}
