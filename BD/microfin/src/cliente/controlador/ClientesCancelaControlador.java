package cliente.controlador; 

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClientesCancelaBean;
import cliente.servicio.ClientesCancelaServicio;;


 public class ClientesCancelaControlador extends SimpleFormController {

 	ClientesCancelaServicio clientesCancelaServicio = null;


 	public ClientesCancelaControlador(){
 		setCommandClass(ClientesCancelaBean.class);
 		setCommandName("clientesCancelaBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 		clientesCancelaServicio.getClientesCancelaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		ClientesCancelaBean clientesCancelaBean = (ClientesCancelaBean) command;

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
 								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
 		
 		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
 								Integer.parseInt(request.getParameter("tipoActualizacion")):
 								0;
 									
 		MensajeTransaccionBean mensaje = null;
 		mensaje = clientesCancelaServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, clientesCancelaBean);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

 	public void setClientesCancelaServicio(ClientesCancelaServicio clientesCancelaServicio){
                     this.clientesCancelaServicio = clientesCancelaServicio;
 	}
 } 
