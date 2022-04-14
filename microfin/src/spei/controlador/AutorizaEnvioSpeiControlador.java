package spei.controlador;

	import general.bean.MensajeTransaccionBean;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.SimpleFormController;

	import spei.bean.AutorizaEnvioSpeiBean;
	import spei.servicio.AutorizaEnvioSpeiServicio;


	public class AutorizaEnvioSpeiControlador extends SimpleFormController {

		AutorizaEnvioSpeiServicio	autorizaEnvioSpeiServicio=null;

		public AutorizaEnvioSpeiControlador(){
			setCommandClass(AutorizaEnvioSpeiBean.class);
			setCommandName("autorizaEnvioSpeiBean");
		}

		protected ModelAndView onSubmit(HttpServletRequest request,
										HttpServletResponse response,
										Object command,
										BindException errors) throws Exception {

			AutorizaEnvioSpeiBean autorizaEnvioSpeiBean = (AutorizaEnvioSpeiBean) command;
			
		autorizaEnvioSpeiServicio.getAutorizaEnvioSpeiDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			
			int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
			String datosGrid = request.getParameter("datosGrid");	
			MensajeTransaccionBean mensaje = null;
		mensaje = autorizaEnvioSpeiServicio.grabaTransaccion(tipoTransaccion, autorizaEnvioSpeiBean,datosGrid);
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}

		public AutorizaEnvioSpeiServicio getAutorizaEnvioSpeiServicio() {
			return autorizaEnvioSpeiServicio;
		}

		public void setAutorizaEnvioSpeiServicio(
				AutorizaEnvioSpeiServicio autorizaEnvioSpeiServicio) {
			this.autorizaEnvioSpeiServicio = autorizaEnvioSpeiServicio;
		}

		

		
		
		
	} 



