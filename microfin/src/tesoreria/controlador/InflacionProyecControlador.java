package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.InflacionProyecBean;
import tesoreria.servicio.InflacionProyecServicio;

public class InflacionProyecControlador extends SimpleFormController{
		InflacionProyecServicio inflacionProyecServicio = null;
		
		public InflacionProyecControlador(){
			setCommandClass(InflacionProyecBean.class);
			setCommandName("inflacionProyec");
		}
		
		protected ModelAndView onSubmit(HttpServletRequest request,
										HttpServletResponse response, 	
										Object command, 
										BindException errors  ) throws Exception{
				InflacionProyecBean inflacionProyecBean = (InflacionProyecBean) command;
				
				int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
				
				MensajeTransaccionBean mensaje = null;
				mensaje = inflacionProyecServicio.grabaTransaccion(tipoTransaccion, inflacionProyecBean);
																		
				return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}

		public InflacionProyecServicio getInflacionProyecServicio() {
			return inflacionProyecServicio;
		}

		public void setInflacionProyecServicio(
				InflacionProyecServicio inflacionProyecServicio) {
			this.inflacionProyecServicio = inflacionProyecServicio;
		}
}
