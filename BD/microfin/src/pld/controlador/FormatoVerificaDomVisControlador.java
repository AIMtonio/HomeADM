package pld.controlador;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.FormatoVerificaDomBean;
import pld.bean.RepConocimientoCteBean;
import pld.servicio.ParametrosegoperServicio;




public class FormatoVerificaDomVisControlador extends SimpleFormController {
	
	
	ParametrosegoperServicio parametrosegoperServicio =null;
	
	
	String nombreReporte = null;
	String successView = null;		

 	public FormatoVerificaDomVisControlador(){
		setCommandClass(FormatoVerificaDomBean.class);
		setCommandName("formatoVerificaDomBean");
 	}
    
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
						   
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte Conocimiento cliente");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		
}
	
	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	




}
