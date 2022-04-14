package cliente.controlador; 



import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.DireccionesClienteBean;
import cliente.servicio.DireccionesClienteServicio;

 public class DireccionesClienteControlador extends SimpleFormController {

 	DireccionesClienteServicio direccionesClienteServicio = null;

 	public DireccionesClienteControlador(){
 		setCommandClass(DireccionesClienteBean.class);
 		setCommandName("direccionesCliente");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 		
 		direccionesClienteServicio.getDireccionesClienteDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

 		DireccionesClienteBean direccionesCliente = (DireccionesClienteBean) command;

 		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje = null;
 		mensaje = direccionesClienteServicio.grabaTransaccion(tipoTransaccion, direccionesCliente);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

 	public void setDireccionesClienteServicio(DireccionesClienteServicio direccionesClienteServicio){
                     this.direccionesClienteServicio = direccionesClienteServicio;
 	}
 } 
