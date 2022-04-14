package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Act_Usuario;

public class SessionExpiradaControlador extends AbstractController{

	UsuarioServicio usuarioServicio = null;

	

	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			 HttpServletResponse response)
	throws Exception {
		
		String clave = request.getParameter("claveUsu");	
		UsuarioBean usuarioBean = new UsuarioBean();		
		usuarioBean.setClave(clave);

		String controlID = request.getParameter("controlID");
		MensajeTransaccionBean mensaje = null;
		mensaje= usuarioServicio.actualizaUsuario(Enum_Act_Usuario.act_statusSesInact, usuarioBean);
		List listaResultado = (List)new ArrayList();
		//listaResultado.add(tipoTransaccion);
		listaResultado.add(controlID);
		listaResultado.add(mensaje);
		
		Cookie cookieSesion = new Cookie("JSESSIONID", null);
		cookieSesion.setPath(request.getContextPath());
		cookieSesion.setMaxAge(0);
		response.addCookie(cookieSesion);	
		
		SecurityContext ctx = SecurityContextHolder.getContext();
		ctx.setAuthentication(null);
		request.getSession().invalidate();
		
		
		
		return new ModelAndView("soporte/sesionExpiradaVista", "listaResultado", listaResultado);
	}


	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	
	
}