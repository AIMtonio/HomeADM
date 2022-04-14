package pld.controlador;



import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.RepConocimientoCteBean;
import pld.servicio.ParametrosegoperServicio;




public class ConocimientoCteControlador extends SimpleFormController {
	
	
	ParametrosegoperServicio parametrosegoperServicio =null;
	
	
	String nombreReporte = null;
	String successView = null;		

 	public ConocimientoCteControlador(){
 		setCommandClass(RepConocimientoCteBean.class);
 		setCommandName("ConocimientoCteBean");
 	}
    
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		RepConocimientoCteBean ConocimientoCteBean = (RepConocimientoCteBean) command;
 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
						   Integer.parseInt(request.getParameter("tipoActualizacion"))	:
							   0;		
						   
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte Conocimiento cliente");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}

	

	public ParametrosegoperServicio getParametrosegoperServicio() {
		return parametrosegoperServicio;
	}

	public void setParametrosegoperServicio(
			ParametrosegoperServicio parametrosegoperServicio) {
		this.parametrosegoperServicio = parametrosegoperServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	




}
