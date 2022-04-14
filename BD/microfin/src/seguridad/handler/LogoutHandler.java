package seguridad.handler;

import herramientas.Constantes;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;

import seguridad.bean.SessionesUsuarioBean;


public class LogoutHandler extends SecurityContextLogoutHandler {
	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	static SessionesUsuarioBean sessionesUsuarioBean;
	
	public void logout(HttpServletRequest request,
 		   HttpServletResponse response,
 		   Authentication authentication){

		Cookie cookieSesion = new Cookie("JSESSIONID", null);
		cookieSesion.setPath(request.getContextPath());
		cookieSesion.setMaxAge(0);
		response.addCookie(cookieSesion);
		
		Cookie cookie = new Cookie("USUARIO", null);
		cookie.setPath(request.getContextPath());
		cookie.setMaxAge(0);
		response.addCookie(cookie);
		
		String mensajeLog;
		
		String claveUsuario = (request.getParameter("claveUsuario") != null)?
							  request.getParameter("claveUsuario"):
							  Constantes.STRING_VACIO;
		
		if(authentication == null){
			if(claveUsuario != null){
				authentication	= (Authentication)sessionesUsuarioBean.getSesionesAplicacion().get(claveUsuario);
				mensajeLog = "Actividad:LogOut Exitoso;" + "Usuario:" + claveUsuario  + ";IP: NULL;" + "SessionID: NULL";
				loggerSAFI.info(mensajeLog);
				sessionesUsuarioBean.getSesionesAplicacion().remove(claveUsuario);				
			}
		}else{
			mensajeLog = "Actividad:LogOut Exitoso;" + "Usuario:" + authentication.getName() + ";IP:" +
					((WebAuthenticationDetails) authentication.getDetails()).getRemoteAddress() +
		 			";SessionID: " + ((WebAuthenticationDetails) authentication.getDetails()).getSessionId();
			loggerSAFI.info(mensajeLog);
			sessionesUsuarioBean.getSesionesAplicacion().remove(authentication.getName());
		}
		
		super.logout(request, response, authentication);
	}

	// Setters 

	public void setSessionesUsuarioBean(SessionesUsuarioBean sessionesUsuarioBean) {
		this.sessionesUsuarioBean = sessionesUsuarioBean;
	}
	
	
}
