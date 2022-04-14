package ventanilla.controlador;

import herramientas.Constantes;
import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.UsuarioServiciosBean;
import ventanilla.servicio.UsuarioArchivosServicio;

public class UsuarioArchivosGridControlador extends AbstractCommandController {
	UsuarioArchivosServicio usuarioArchivosServicio = null;

	public UsuarioArchivosGridControlador() {
		setCommandClass(UsuarioServiciosBean.class);
		setCommandName("usuarioArchivo");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		UsuarioServiciosBean usuarioArchivo = (UsuarioServiciosBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List usuarioArchivoList =	usuarioArchivosServicio.listaArchivosUsuario(tipoLista, usuarioArchivo);
		
		return new ModelAndView("ventanilla/usuarioArchivosGridVista", "usuarioArchivo", usuarioArchivoList);
	}

	public UsuarioArchivosServicio getUsuarioArchivosServicio() {
		return usuarioArchivosServicio;
	}

	public void setUsuarioArchivosServicio(
			UsuarioArchivosServicio usuarioArchivosServicio) {
		this.usuarioArchivosServicio = usuarioArchivosServicio;
	}	
}