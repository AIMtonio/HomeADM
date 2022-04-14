package cuentas.controlador;

import general.bean.MensajeTransaccionBean;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.IDEMensualBean;

import cuentas.servicio.CuentasAhoServicio;


public class RepIDEMensualControlador extends SimpleFormController {
	CuentasAhoServicio cuentasAhoServicio = null;
	String nombreReporte = null;
	String successView = null;

 	public RepIDEMensualControlador(){
 		setCommandClass(IDEMensualBean.class);
 		setCommandName("IDEMensualBean");
 	}
    
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		IDEMensualBean IDEMensualBean = (IDEMensualBean) command;
 		
 								   
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte IDE Mensual");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

		
}

	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	
 	

}
