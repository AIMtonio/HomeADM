package contabilidad.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.EstatusTimbradoProdBean;
import contabilidad.servicio.EstatusTimbradoProdServicio;

public class EstatusTimbradoProdControlador extends SimpleFormController {
	EstatusTimbradoProdServicio estatusTimbradoProdServicio = null;
	String successView = null;		

 	public EstatusTimbradoProdControlador(){
 		setCommandClass(EstatusTimbradoProdBean.class);
 		setCommandName("estatusTimbradoProdBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		EstatusTimbradoProdBean estatusTimbradoProd = (EstatusTimbradoProdBean) command;
 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
						   Integer.parseInt(request.getParameter("tipoActualizacion")):
							   0;		
						   
		MensajeTransaccionBean mensaje = null;
		mensaje = estatusTimbradoProdServicio.grabaTransaccion(tipoTransaccion, estatusTimbradoProd, request);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

 	}

	public EstatusTimbradoProdServicio getEstatusTimbradoProdServicio() {
		return estatusTimbradoProdServicio;
	}

	public void setEstatusTimbradoProdServicio(
			EstatusTimbradoProdServicio estatusTimbradoProdServicio) {
		this.estatusTimbradoProdServicio = estatusTimbradoProdServicio;
	}
	
	
}
