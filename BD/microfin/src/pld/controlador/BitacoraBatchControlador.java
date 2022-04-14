package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.servicio.ParametrosOpRelServicio;

public class BitacoraBatchControlador  extends SimpleFormController {
	ParametrosOpRelServicio parametrosOpRelServicio = null;
	String nombreReporte = null;
	String successView = null;		

 	public BitacoraBatchControlador(){
 		setCommandClass(Object.class);
 		setCommandName("BatchPLD");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
				
		MensajeTransaccionBean mensaje = null;
		
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}

	


	public void setParametrosOpRelServicio(
			ParametrosOpRelServicio parametrosOpRelServicio) {
		this.parametrosOpRelServicio = parametrosOpRelServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

}
