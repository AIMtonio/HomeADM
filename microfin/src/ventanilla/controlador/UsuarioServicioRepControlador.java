package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import ventanilla.bean.UsuarioServiciosBean;
import ventanilla.servicio.UsuarioServiciosServicio;

	public class UsuarioServicioRepControlador extends SimpleFormController {
		
		UsuarioServiciosServicio usuarioServiciosServicio = null;

		public UsuarioServicioRepControlador() {
			setCommandClass(UsuarioServiciosBean.class);
			setCommandName("usuarioServiciosBean");
		}
			
		protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
			usuarioServiciosServicio.getUsuarioServiciosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			UsuarioServiciosBean usuarioServiciosBean = (UsuarioServiciosBean) command;
			MensajeTransaccionBean mensaje = null;
											
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}

		public UsuarioServiciosServicio getUsuarioServiciosServicio() {
			return usuarioServiciosServicio;
		}

		public void setUsuarioServiciosServicio(
				UsuarioServiciosServicio usuarioServiciosServicio) {
			this.usuarioServiciosServicio = usuarioServiciosServicio;
		}

		
	}


