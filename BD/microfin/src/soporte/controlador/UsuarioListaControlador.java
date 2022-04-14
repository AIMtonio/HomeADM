package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;

public class UsuarioListaControlador extends AbstractCommandController {

	UsuarioServicio usuarioServicio = null;
	
	public UsuarioListaControlador() {
		setCommandClass(UsuarioBean.class);
		setCommandName("usuario");
	}

	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		UsuarioBean usuario = (UsuarioBean) command;
		List usuarios =	usuarioServicio.lista(tipoLista, usuario);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(usuarios);
		
		return new ModelAndView("soporte/usuarioListaVista", "listaResultado", listaResultado);
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	
	
}
