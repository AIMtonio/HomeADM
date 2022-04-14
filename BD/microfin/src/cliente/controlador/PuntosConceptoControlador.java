
package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.PuntosConceptoBean;
import cliente.servicio.PuntosConceptoServicio;

public class PuntosConceptoControlador extends SimpleFormController {
	

	PuntosConceptoServicio puntosConceptoServicio = null;


	public PuntosConceptoControlador() {
		setCommandClass(PuntosConceptoBean.class); 
		setCommandName("puntosConceptoBean");	
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,BindException errors) 
	throws Exception {	

		puntosConceptoServicio.getPuntosConceptoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		PuntosConceptoBean puntosConceptoBean = (PuntosConceptoBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ?
					Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
					
		MensajeTransaccionBean mensaje = null;		
		mensaje = puntosConceptoServicio.grabaTransaccion(tipoTransaccion, puntosConceptoBean);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}//fin del onSubmit


	
	
	//* ============== GETTER & SETTER =============  //*
	
	public PuntosConceptoServicio getPuntosConceptoServicio() {
		return puntosConceptoServicio;
	}
	public void setPuntosConceptoServicio(
			PuntosConceptoServicio puntosConceptoServicio) {
		this.puntosConceptoServicio = puntosConceptoServicio;
	}

}// fin de la clase
