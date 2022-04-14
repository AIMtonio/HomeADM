package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ConceptosCalifBean;
import cliente.servicio.ConceptosCalifServicio;

public class CalificacionClienteControlador extends SimpleFormController {

	ConceptosCalifServicio conceptosCalifServicio = null;


	public CalificacionClienteControlador() {
		setCommandClass(ConceptosCalifBean.class); 
		setCommandName("conceptosCalifBean");	
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,BindException errors) 
	throws Exception {	

		conceptosCalifServicio.getConceptosCalifDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		ConceptosCalifBean conceptosCalifBean = (ConceptosCalifBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ?
					Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
					

		MensajeTransaccionBean mensaje = null;		
		mensaje = conceptosCalifServicio.grabaTransaccion(tipoTransaccion,conceptosCalifBean);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}//fin del onSubmit



	
	//* ============== GETTER & SETTER =============  //*

	public ConceptosCalifServicio getConceptosCalifServicio() {
		return conceptosCalifServicio;
	}
	public void setConceptosCalifServicio(
			ConceptosCalifServicio conceptosCalifServicio) {
		this.conceptosCalifServicio = conceptosCalifServicio;
	}
	
}
