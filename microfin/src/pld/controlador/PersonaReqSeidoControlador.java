package pld.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.PersonaReqSeidoBean;
import pld.servicio.PersonaReqSeidoServicio;

public class PersonaReqSeidoControlador extends SimpleFormController {
	
 	private ParametrosSesionBean parametrosSesionBean = null;
 	private PersonaReqSeidoServicio personaReqSeidoServicio;

	public PersonaReqSeidoControlador() {
		setCommandClass(PersonaReqSeidoBean.class);
		setCommandName("personaReqSeido");
	}		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
				
		personaReqSeidoServicio.getPersonaReqSeidoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		PersonaReqSeidoBean personaReqSeido = (PersonaReqSeidoBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = personaReqSeidoServicio.grabaTransaccion(tipoTransaccion, personaReqSeido);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}	
	
	
	
	public PersonaReqSeidoServicio getPersonaReqSeidoServicio() {
		return personaReqSeidoServicio;
	}

	public void setPersonaReqSeidoServicio(
			PersonaReqSeidoServicio personaReqSeidoServicio) {
		this.personaReqSeidoServicio = personaReqSeidoServicio;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
	
}


