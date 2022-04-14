package cuentas.controlador;



	import general.bean.MensajeTransaccionBean;
	import general.bean.ParametrosSesionBean;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.SimpleFormController;

	import cuentas.bean.RepCtasLimitesExcedBean;
	import cuentas.servicio.RepCtasLimitesExcedServicio;

	public class RepCtasLimitesExcedControlador extends SimpleFormController {
		
		RepCtasLimitesExcedServicio repCtasLimitesExcedServicio = null;

		public RepCtasLimitesExcedControlador() {
			setCommandClass(RepCtasLimitesExcedBean.class);
			setCommandName("repCtasLimitesExcedBean");
		}
			
		protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
				repCtasLimitesExcedServicio.getRepCtasLimitesExcedDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			RepCtasLimitesExcedBean limitesExcedBean = (RepCtasLimitesExcedBean) command;
			int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
			int tipoActualizacion = 0;
			MensajeTransaccionBean mensaje = null;
			//mensaje = repCtasLimitesExcedServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion,limitesExcedBean);
													
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}

		public RepCtasLimitesExcedServicio getRepCtasLimitesExcedServicio() {
			return repCtasLimitesExcedServicio;
		}

		public void setRepCtasLimitesExcedServicio(
				RepCtasLimitesExcedServicio repCtasLimitesExcedServicio) {
			this.repCtasLimitesExcedServicio = repCtasLimitesExcedServicio;
		}
		
		

	}


