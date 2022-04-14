package pld.controlador;

	import general.bean.MensajeTransaccionBean;
	import general.bean.ParametrosSesionBean;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.SimpleFormController;

	import pld.bean.OperLimExcedidosRepBean;
	import pld.servicio.OperLimExcedidosRepServicio;

	public class OperLimExcedidosRepControlador extends SimpleFormController {
		
		OperLimExcedidosRepServicio operLimExcedidosRepServicio = null;

		public OperLimExcedidosRepControlador() {
			setCommandClass(OperLimExcedidosRepBean.class);
			setCommandName("operLimExcedidosRepBean");
		}
			
		protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
				operLimExcedidosRepServicio.getOperLimExcedidosRepDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			OperLimExcedidosRepBean limitesExcedBean = (OperLimExcedidosRepBean) command;
			MensajeTransaccionBean mensaje = null;
											
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}

		public OperLimExcedidosRepServicio getOperLimExcedidosRepServicio() {
			return operLimExcedidosRepServicio;
		}

		public void setOperLimExcedidosRepServicio(
				OperLimExcedidosRepServicio operLimExcedidosRepServicio) {
			this.operLimExcedidosRepServicio = operLimExcedidosRepServicio;
		}
 
		
		

	}


