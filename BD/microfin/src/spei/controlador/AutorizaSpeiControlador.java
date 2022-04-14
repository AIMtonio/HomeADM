package spei.controlador;

	import general.bean.MensajeTransaccionBean;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.SimpleFormController;

	import spei.bean.AutorizaSpeiBean;
	import spei.servicio.AutorizaSpeiServicio;


	public class AutorizaSpeiControlador extends SimpleFormController {

		AutorizaSpeiServicio	autorizaSpeiServicio=null;

		public AutorizaSpeiControlador(){
			setCommandClass(AutorizaSpeiBean.class);
			setCommandName("autorizaSpeiBean");
		}

		protected ModelAndView onSubmit(HttpServletRequest request,
										HttpServletResponse response,
										Object command,
										BindException errors) throws Exception {

			AutorizaSpeiBean autorizaSpeiBean = (AutorizaSpeiBean) command;
			
			autorizaSpeiServicio.getAutorizaSpeiDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			
			int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
			
			String datosGrid = request.getParameter("datosGrid");	
			MensajeTransaccionBean mensaje = null;
			mensaje = autorizaSpeiServicio.grabaTransaccion(tipoTransaccion, autorizaSpeiBean,datosGrid);
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}

		public AutorizaSpeiServicio getAutorizaSpeiServicio() {
			return autorizaSpeiServicio;
		}

		public void setAutorizaSpeiServicio(
				AutorizaSpeiServicio autorizaSpeiServicio) {
			this.autorizaSpeiServicio = autorizaSpeiServicio;
		}

		

		
		
		
	} 



