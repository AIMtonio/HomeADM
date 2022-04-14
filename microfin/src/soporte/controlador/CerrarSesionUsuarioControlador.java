package soporte.controlador;

import general.bean.ParametrosAuditoriaBean;
import herramientas.Constantes;
 
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import seguridad.bean.SessionesUsuarioBean;

public class CerrarSesionUsuarioControlador extends AbstractController{
	
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	static SessionesUsuarioBean sessionesUsuarioBean;
	
	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			 									 HttpServletResponse response) throws Exception {
		
		String claveUsuario = (request.getParameter("claveUsuario") != null)?
				  			request.getParameter("claveUsuario"): Constantes.STRING_VACIO;
				  			
		if(claveUsuario != null){
			
			String mensajeLog = "Actividad:LogOut Exitoso por TimeOut;" + "Usuario:" + claveUsuario  + ";IP: " +
								request.getRequestURI().toString() + "; SessionID: NULL";
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+mensajeLog);
			try{
				sessionesUsuarioBean.getSesionesAplicacion().remove(claveUsuario);
			}catch(Exception e){
				e.printStackTrace();
			}
		}

				  			
		return new ModelAndView("soporte/cerrarSesionUsuario", "listaResultado", null);
	}

	// ----------------Setters y Guetters ------------------------------------------ 
	public void setSessionesUsuarioBean(SessionesUsuarioBean sessionesUsuarioBean) {
		this.sessionesUsuarioBean = sessionesUsuarioBean;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}	
	
}
