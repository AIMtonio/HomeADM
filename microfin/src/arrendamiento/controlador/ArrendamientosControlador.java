package arrendamiento.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import general.bean.MensajeTransaccionBean;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import arrendamiento.bean.ArrendamientosBean;
import arrendamiento.servicio.ArrendamientosServicio;


 public class ArrendamientosControlador extends SimpleFormController {

 	ArrendamientosServicio arrendamientosServicio = null;


 	public ArrendamientosControlador(){
 		setCommandClass(ArrendamientosBean.class);
 		setCommandName("arrendamientosBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 		arrendamientosServicio.getArrendamientosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		ArrendamientosBean arrendamientosBean = (ArrendamientosBean) command;

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
 								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
 		
 		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
 								Integer.parseInt(request.getParameter("tipoActualizacion")):
 								0;
 									
 		MensajeTransaccionBean mensaje = null;
 		mensaje = arrendamientosServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, arrendamientosBean);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

 	public void setArrendamientosServicio(ArrendamientosServicio arrendamientosServicio){
                     this.arrendamientosServicio = arrendamientosServicio;
 	}
 } 
