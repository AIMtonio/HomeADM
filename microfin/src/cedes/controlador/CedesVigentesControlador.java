package cedes.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cedes.bean.CedesVigentesBean;
import cedes.servicio.CedesServicio;

public class CedesVigentesControlador extends SimpleFormController{		
	CedesServicio cedesServicio = null;
	
	public CedesVigentesControlador() {
		setCommandClass(CedesVigentesBean.class);
		setCommandName("CedesBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
	
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public CedesServicio getCedesServicio() {
		return cedesServicio;
	}
	public void setCedesServicio(CedesServicio cedesServicio) {
		this.cedesServicio = cedesServicio;
	}
	 
}