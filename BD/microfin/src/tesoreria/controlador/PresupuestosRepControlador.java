 
package tesoreria.controlador;



import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.servicio.PresupSucursalServicio;
import tesoreria.bean.PresupuestoSucursalBean;
 

public class PresupuestosRepControlador extends SimpleFormController {
	PresupSucursalServicio presupSucursalServicio = null;
	String nombreReporte = null;
	String successView = null;		

 	public PresupuestosRepControlador(){
 		setCommandClass(PresupuestoSucursalBean.class);
 		setCommandName("PresupBean");
 	}
    
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 			
						   
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte de presupuestos");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}


	public void setPresupSucursalServicio(PresupSucursalServicio presupSucursalServicio) {
		this.presupSucursalServicio = presupSucursalServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

}

 
 
 