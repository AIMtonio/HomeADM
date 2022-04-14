package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.OperacionesCapitalNetoBean;
import cliente.servicio.OperacionesCapitalNetoServicio;
import general.bean.MensajeTransaccionBean;

public class OperacionesCapitalNetoControlador extends SimpleFormController {

	

	OperacionesCapitalNetoServicio operacionesCapitalNetoServicio= null;


	public OperacionesCapitalNetoControlador() {
		setCommandClass(OperacionesCapitalNetoBean.class); 
		setCommandName("operacionesCapitalNetoBean");	
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,BindException errors) 
	throws Exception {	

		operacionesCapitalNetoServicio.getOperacionesCapitalNetoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		OperacionesCapitalNetoBean operCapitalNetoBean = (OperacionesCapitalNetoBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ?
					Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
					
		int tipoActualizacion =(request.getParameter("tipoActualizacion")!=null) ?
					Integer.parseInt(request.getParameter("tipoActualizacion")): 0;

		MensajeTransaccionBean mensaje = null;		
		mensaje = operacionesCapitalNetoServicio.grabaTransaccion(tipoTransaccion,operCapitalNetoBean);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}//fin del onSubmit

	
	//* ============== GETTER & SETTER =============  //*
	public OperacionesCapitalNetoServicio getOperacionesCapitalNetoServicio() {
		return operacionesCapitalNetoServicio;
	}


	public void setOperacionesCapitalNetoServicio(OperacionesCapitalNetoServicio operacionesCapitalNetoServicio) {
		this.operacionesCapitalNetoServicio = operacionesCapitalNetoServicio;
	}

	

}// fin de la clase