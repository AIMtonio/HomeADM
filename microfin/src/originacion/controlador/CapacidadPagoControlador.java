
package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.CapacidadPagoBean;
import originacion.servicio.CapacidadPagoServicio;
public class CapacidadPagoControlador extends SimpleFormController {
	

	CapacidadPagoServicio capacidadPagoServicio = null;


	public CapacidadPagoControlador() {
		setCommandClass(CapacidadPagoBean.class); 
		setCommandName("capacidadPagoBean");	
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,BindException errors) 
	throws Exception {	

		capacidadPagoServicio.getCapacidadPagoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		CapacidadPagoBean capacidadPagoBena = (CapacidadPagoBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ?
					Integer.parseInt(request.getParameter("tipoTransaccion")): 0;

		MensajeTransaccionBean mensaje = null;		
		mensaje = capacidadPagoServicio.grabaTransaccion(tipoTransaccion,capacidadPagoBena);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}//fin del onSubmit


	
	
	//* ============== GETTER & SETTER =============  //*	

	public CapacidadPagoServicio getCapacidadPagoServicio() {
		return capacidadPagoServicio;
	}
	public void setCapacidadPagoServicio(CapacidadPagoServicio capacidadPagoServicio) {
		this.capacidadPagoServicio = capacidadPagoServicio;
	}

}// fin de la clase
