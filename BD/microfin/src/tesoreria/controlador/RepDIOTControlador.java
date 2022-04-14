
package tesoreria.controlador;



import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.RepDIOTBean;
import tesoreria.servicio.RepDIOTServicio;

 
 
public class RepDIOTControlador extends SimpleFormController {
	RepDIOTServicio repDIOTServicio = null;
	String nombreReporte = null;
	String successView = null;		

 	public RepDIOTControlador(){
 		setCommandClass(RepDIOTBean.class);
 		setCommandName("DIOTBean");
 	}
    
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 			
						   
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte de la DIOT");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}

	public RepDIOTServicio getRepDIOTServicio() {
		return repDIOTServicio;
	}

	public void setRepDIOTServicio(RepDIOTServicio repDIOTServicio) {
		this.repDIOTServicio = repDIOTServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

}

