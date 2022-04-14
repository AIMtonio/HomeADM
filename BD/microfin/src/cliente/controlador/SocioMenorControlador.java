package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.SocioMenorBean;
import cliente.servicio.SocioMenorServicio;


public class SocioMenorControlador extends SimpleFormController {

	SocioMenorServicio socioMenorServicio = null;
 	private ParametrosSesionBean parametrosSesionBean = null;

	public SocioMenorControlador() {
		setCommandClass(SocioMenorBean.class);
		setCommandName("socioMenor");
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		socioMenorServicio.getSocioMenorDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		SocioMenorBean socioMenor = (SocioMenorBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
				
		MensajeTransaccionBean mensaje = null;
		
		mensaje = socioMenorServicio.grabaTransaccion(tipoTransaccion, socioMenor);
		
		
		
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public SocioMenorServicio getSocioMenorServicio() {
		return socioMenorServicio;
	}

	public void setSocioMenorServicio(SocioMenorServicio socioMenorServicio) {
		this.socioMenorServicio = socioMenorServicio;
	}


	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}	
	
}

