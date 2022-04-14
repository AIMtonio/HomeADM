	package spei.controlador;

	import general.bean.MensajeTransaccionBean;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.SimpleFormController;

	import spei.bean.ConsultaSpeiBean;
	import spei.servicio.ConsultaSpeiServicio;


	public class ConsultaSpeiControlador extends SimpleFormController {

		ConsultaSpeiServicio	consultaSpeiServicio=null;

		public ConsultaSpeiControlador(){
			setCommandClass(ConsultaSpeiBean.class);
			setCommandName("consultaSpeiBean");
		}

		protected ModelAndView onSubmit(HttpServletRequest request,
										HttpServletResponse response,
										Object command,
										BindException errors) throws Exception {

			ConsultaSpeiBean consultaSpeiBean = (ConsultaSpeiBean) command;
			
			consultaSpeiServicio.getConsultaSpeiDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			
			int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
			
			String datosGrid = request.getParameter("datosGrid");	
			MensajeTransaccionBean mensaje = null;
		//	mensaje = consultaSpeiServicio.grabaTransaccion(tipoTransaccion, consultaSpeiBean, datosGrid);
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}

		public ConsultaSpeiServicio getConsultaSpeiServicio() {
			return consultaSpeiServicio;
		}

		public void setConsultaSpeiServicio(
				ConsultaSpeiServicio consultaSpeiServicio) {
			this.consultaSpeiServicio = consultaSpeiServicio;
		}

		

		
		
		
	} 




