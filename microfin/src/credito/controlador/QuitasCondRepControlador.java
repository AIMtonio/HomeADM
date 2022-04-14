 

package credito.controlador;
     
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreQuitasBean;
import credito.servicio.CreQuitasServicio;

public class QuitasCondRepControlador extends SimpleFormController {
	CreQuitasServicio creQuitasServicio = null;
	String nombreReporte = null;
	String successView = null;		

 	public QuitasCondRepControlador(){
 		setCommandClass(CreQuitasBean.class);
 		setCommandName("creQuitasBean");
 	}
    
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		CreQuitasBean creQuitasBean = (CreQuitasBean) command;
 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
						   Integer.parseInt(request.getParameter("tipoActualizacion")):
							   0;		
						   
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte Pagos Realizados");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}


	public void setCreQuitasServicio(CreQuitasServicio creQuitasServicio) {
		this.creQuitasServicio = creQuitasServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

}

 
 