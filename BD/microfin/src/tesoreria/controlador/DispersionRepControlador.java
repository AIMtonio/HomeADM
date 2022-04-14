  
package tesoreria.controlador;



import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.servicio.OperDispersionServicio; 
import tesoreria.bean.DispersionBean;
 

public class DispersionRepControlador extends SimpleFormController {
	OperDispersionServicio operDispersionServicio = null;
	String nombreReporte = null;
	String successView = null;		

 	public DispersionRepControlador(){
 		setCommandClass(DispersionBean.class);
 		setCommandName("dispBean");
 	}
    
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 			
						   
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte de Dispersión");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}


	public void setOperDispersionServicio(OperDispersionServicio operDispersionServicio) {
		this.operDispersionServicio = operDispersionServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

}