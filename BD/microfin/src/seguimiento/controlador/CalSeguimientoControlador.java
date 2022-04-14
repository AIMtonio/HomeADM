package seguimiento.controlador;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import seguimiento.bean.*;
import seguimiento.servicio.SegtoManualServicio;


public class CalSeguimientoControlador extends SimpleFormController {	
		SegtoManualServicio segtoManualServicio = null;
		
		public CalSeguimientoControlador() {
			setCommandClass(SegtoManualBean.class);
			setCommandName("segtoManualBean");
		}

		
		protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,							
				BindException errors) throws Exception {


		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		MensajeTransaccionBean mensaje = null;
				
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}


		public SegtoManualServicio getSegtoManualServicio() {
			return segtoManualServicio;
		}


		public void setSegtoManualServicio(SegtoManualServicio segtoManualServicio) {
			this.segtoManualServicio = segtoManualServicio;
		}
}
