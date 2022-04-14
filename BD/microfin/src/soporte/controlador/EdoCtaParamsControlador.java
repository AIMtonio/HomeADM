package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.servicio.EdoCtaParamsServicio;
import soporte.bean.EdoCtaParamsBean;

public class EdoCtaParamsControlador extends SimpleFormController{
		EdoCtaParamsServicio edoCtaParamsServicio=null;
		public EdoCtaParamsControlador() {
			setCommandClass(EdoCtaParamsBean.class);
			setCommandName("edoCtaParamsBean");
		}
		protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
			
			edoCtaParamsServicio.getEdoCtaParamsDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			EdoCtaParamsBean edoCtaParams= (EdoCtaParamsBean) command;
			int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):0;
					
			MensajeTransaccionBean mensaje = null;
			mensaje = edoCtaParamsServicio.grabaTransaccion(tipoTransaccion,edoCtaParams);
									
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
		
		
		public EdoCtaParamsServicio getEdoCtaParamsServicio() {
			return edoCtaParamsServicio;
		}
		public void setEdoCtaParamsServicio(EdoCtaParamsServicio edoCtaParamsServicio) {
			this.edoCtaParamsServicio = edoCtaParamsServicio;
		}
}
