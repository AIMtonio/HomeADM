	package ventanilla.controlador;

	import general.bean.MensajeTransaccionBean;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.SimpleFormController;


	import ventanilla.bean.SpeiEnvioBean;
	import ventanilla.servicio.SpeiEnvioServicio;


	public class SpeiEnvioControlador  extends SimpleFormController {

		SpeiEnvioServicio speiEnvioServicio = null;


	 	public SpeiEnvioControlador(){
	 		setCommandClass(SpeiEnvioBean.class);
	 		setCommandName("speiEnivio");
	 	}

	 	protected ModelAndView onSubmit(HttpServletRequest request,
	 									HttpServletResponse response,
	 									Object command,
	 									BindException errors) throws Exception {
	 		SpeiEnvioBean  speiEnivioBean = (SpeiEnvioBean) command;
	 	    speiEnvioServicio.getSpeiEnvioDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	 	
	 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
	 								Integer.parseInt(request.getParameter("tipoTransaccion")):
									0;
	 	
	 		MensajeTransaccionBean mensaje = null;
	 	
	 		mensaje = speiEnvioServicio.grabaTransaccion(tipoTransaccion,request,speiEnivioBean);

	 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	 	}
	 	
	 	

		public SpeiEnvioServicio getSpeiEnvioServicio() {
			return speiEnvioServicio;
		}

		public void setSpeiEnvioServicio(SpeiEnvioServicio speiEnvioServicio) {
			this.speiEnvioServicio = speiEnvioServicio;
		}

	
	 } 

