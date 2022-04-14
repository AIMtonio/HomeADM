package soporte.controlador;


import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.servicio.EdoCtaCertificadoServicio;
import soporte.bean.EdoCtaCertificadoBean;

public class EdoCtaCertificadoControlador extends SimpleFormController{
	EdoCtaCertificadoServicio edoCtaCertificadoServicio=null;
		public EdoCtaCertificadoControlador() {
			setCommandClass(EdoCtaCertificadoBean.class);
			setCommandName("edoCtaCertificadoBean");
		}
		protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,Object command,
				BindException errors) throws Exception {					
			
			EdoCtaCertificadoBean edoCuenta= (EdoCtaCertificadoBean) command;			
			edoCtaCertificadoServicio.getEdoCtaCertificadoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			MensajeTransaccionBean mensaje = null;						
			mensaje = edoCtaCertificadoServicio.grabaTransaccion(edoCuenta);
			
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
					
		public EdoCtaCertificadoServicio getEdoCtaCertificadoServicio() {
			return edoCtaCertificadoServicio;
		}
		public void setEdoCtaCertificadoServicio(EdoCtaCertificadoServicio edoCtaCertificadoServicio) {
			this.edoCtaCertificadoServicio = edoCtaCertificadoServicio;
		}
}

