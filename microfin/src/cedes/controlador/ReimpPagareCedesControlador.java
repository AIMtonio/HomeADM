package cedes.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cedes.bean.CedesBean;
import cedes.servicio.CedesServicio;

public class ReimpPagareCedesControlador extends SimpleFormController{
	CedesServicio cedesServicio = null;
	
	public ReimpPagareCedesControlador(){
		setCommandClass(CedesBean.class);
		setCommandName("reimpPagareCedes");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		CedesBean cedesBean = (CedesBean) command;
		
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);	
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CedesServicio getCedesServicio() {
		return cedesServicio;
	}

	public void setCedesServicio(CedesServicio cedesServicio) {
		this.cedesServicio = cedesServicio;
	}
	 
}
