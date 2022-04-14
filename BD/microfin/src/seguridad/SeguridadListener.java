package seguridad;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationListener;
import org.springframework.security.authentication.event.AbstractAuthenticationEvent;
import org.springframework.security.authentication.event.AuthenticationFailureBadCredentialsEvent;
import org.springframework.security.authentication.event.AuthenticationFailureDisabledEvent;
import org.springframework.security.authentication.event.AuthenticationSuccessEvent;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.WebAuthenticationDetails;

import seguridad.bean.BitacoraAccesoBean;
import seguridad.bean.SessionesUsuarioBean;
import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Con_Usuario;
 
public class SeguridadListener implements ApplicationListener<AbstractAuthenticationEvent>{
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	UsuarioServicio usuarioServicio = null;
	SessionesUsuarioBean sessionesUsuarioBean;
	SeguridadRecursosServicio seguridadRecursosServicio = null;
	
	public void onApplicationEvent(AbstractAuthenticationEvent event) {

		BitacoraAccesoBean bitacoraAccesoBean = new BitacoraAccesoBean();		
		
		if(event instanceof AuthenticationFailureBadCredentialsEvent){
			UsuarioBean usuario = new UsuarioBean();
			String mensajeLog = null;
			Authentication userAuth = ((AuthenticationFailureBadCredentialsEvent)event).getAuthentication();
			mensajeLog = "Actividad: LogIn Fallido(Password Incorrecto);"+ " Usuario: " + 
					 userAuth.getName() + "; IP: " + ((WebAuthenticationDetails) userAuth.getDetails()).getRemoteAddress()+";";
			loggerSAFI.info(usuario.getOrigenDatos()+mensajeLog);
			usuario.setClave(userAuth.getName());
			// ((WebAuthenticationDetails) userAuth.getDetails()).getSessionId();

			bitacoraAccesoBean.setClaveUsuario(userAuth.getName());
			bitacoraAccesoBean.setDetalleAcceso("Actividad: LogIn Fallido(Password Incorrecto);"+ " Usuario: " + 
					 userAuth.getName() + "; ");
			bitacoraAccesoBean.setTipoAcceso("2");
			bitacoraAccesoBean.setAccesoIP( ((WebAuthenticationDetails) userAuth.getDetails()).getRemoteAddress());
			
			usuarioServicio.actualizaUsuario(UsuarioServicio.Enum_Act_Usuario.loginsFallidos, usuario);
						
		}else if(event instanceof AuthenticationFailureDisabledEvent){			
			String mensajeLog = null;
			UsuarioBean usuario = new UsuarioBean();
			Authentication userAuth = ((AuthenticationFailureDisabledEvent)event).getAuthentication();
			usuario.setClave(userAuth.getName());						
			mensajeLog = "Actividad: LogIn Fallido(Usuario Deshabilitado);" + " Usuario: " + 
						  userAuth.getName() + "; IP: " + ((WebAuthenticationDetails) userAuth.getDetails()).getRemoteAddress()+";";
			loggerSAFI.info(usuario.getOrigenDatos()+"-"+mensajeLog);

			bitacoraAccesoBean.setClaveUsuario(userAuth.getName());
			bitacoraAccesoBean.setDetalleAcceso("Actividad: LogIn Fallido(Usuario Deshabilitado);" + " Usuario: " + 
					  userAuth.getName() + "; ");
			bitacoraAccesoBean.setTipoAcceso("2");
			bitacoraAccesoBean.setAccesoIP( ((WebAuthenticationDetails) userAuth.getDetails()).getRemoteAddress());
						
						
		}else if(event instanceof AuthenticationSuccessEvent){
			String mensajeLog = null;
			UsuarioBean usuario = new UsuarioBean();
			Authentication userAuth = ((AuthenticationSuccessEvent)event).getAuthentication();
			//TODO:fchia Se elimino la actualizacion en BD
			usuario.setClave(userAuth.getName());
			
			mensajeLog = "Actividad: LogIn Exitoso;" + " Usuario: " + 
						 userAuth.getName() + "; IP: " + ((WebAuthenticationDetails) userAuth.getDetails()).getRemoteAddress()+
						 "; SessionID: " + ((WebAuthenticationDetails) userAuth.getDetails()).getSessionId()+";";
			loggerSAFI.info(usuario.getOrigenDatos()+"-"+mensajeLog);
			//Guarda la Relacion del Usuario-Session en la Aplicacion
			
			bitacoraAccesoBean.setClaveUsuario(userAuth.getName());
			bitacoraAccesoBean.setDetalleAcceso("Actividad: LogIn Exitoso;" + " Usuario: " + 
					 userAuth.getName() + "; ");
			bitacoraAccesoBean.setTipoAcceso("1");
			bitacoraAccesoBean.setAccesoIP( ((WebAuthenticationDetails) userAuth.getDetails()).getRemoteAddress());		

			sessionesUsuarioBean.getSesionesAplicacion().put(userAuth.getName(), userAuth);
			usuarioServicio.actualizaUltimoAcceso(usuario);//para actuaizar el ultimo acceso.
		}

		bitacoraAccesoBean.setTipoMetodo("POST");
		seguridadRecursosServicio.altaBitacoraAccesoLogin(bitacoraAccesoBean);

	}
	
	// -------------------------- Setters y Getters ------------------------------------------------------
	
	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	public void setSessionesUsuarioBean(SessionesUsuarioBean sessionesUsuarioBean) {
		this.sessionesUsuarioBean = sessionesUsuarioBean;
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public SeguridadRecursosServicio getSeguridadRecursosServicio() {
		return seguridadRecursosServicio;
	}

	public void setSeguridadRecursosServicio(
			SeguridadRecursosServicio seguridadRecursosServicio) {
		this.seguridadRecursosServicio = seguridadRecursosServicio;
	}

	
	
}
