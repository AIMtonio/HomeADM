	package cliente.controlador;

	import general.bean.MensajeTransaccionBean;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.apache.log4j.Logger;
	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.SimpleFormController;

	import cliente.bean.BaseCaptacionBean;
	import cliente.servicio.BaseCaptacionServicio;

	public class RepBaseSupervisionControlador extends SimpleFormController{
		BaseCaptacionServicio baseCaptacionServicio=null;
		protected final Logger loggerSAFI = Logger.getLogger("SAFI");
		
		public RepBaseSupervisionControlador() {
			setCommandClass(BaseCaptacionBean.class);
			setCommandName("RepBasesup");
		}
		protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
			MensajeTransaccionBean mensaje = null;
		
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
		public BaseCaptacionServicio getBaseCaptacionServicio() {
			return baseCaptacionServicio;
		}
		public void setBaseCaptacionServicio(BaseCaptacionServicio baseCaptacionServicio) {
			this.baseCaptacionServicio = baseCaptacionServicio;
		}
		
	}
