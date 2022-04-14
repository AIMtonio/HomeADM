package cliente.controlador;
   
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.SeguroClienteBean;
import cliente.servicio.SeguroClienteServicio;



public class SeguroClienteControlador extends SimpleFormController {
	SeguroClienteServicio seguroClienteServicio = null;
	String successView = null;		

 	public SeguroClienteControlador(){
 		setCommandClass(SeguroClienteBean.class);
 		setCommandName("seguroClienteBean");
 	}
    
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
 		
 		seguroClienteServicio.getSeguroClienteDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		SeguroClienteBean seguroBean = (SeguroClienteBean) command;
 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
						   Integer.parseInt(request.getParameter("tipoActualizacion"))	:
							   0;		
		MensajeTransaccionBean mensaje = null;
		mensaje = seguroClienteServicio.grabaTransaccion(tipoTransaccion,seguroBean);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}

	public SeguroClienteServicio getSeguroClienteServicio() {
		return seguroClienteServicio;
	}

	public void setSeguroClienteServicio(SeguroClienteServicio seguroClienteServicio) {
		this.seguroClienteServicio = seguroClienteServicio;
	}


	




}
