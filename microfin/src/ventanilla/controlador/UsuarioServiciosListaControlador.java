package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.UsuarioServiciosBean;
import ventanilla.servicio.UsuarioServiciosServicio;

public class UsuarioServiciosListaControlador  extends AbstractCommandController{
	
UsuarioServiciosServicio usuarioServiciosServicio = null;
	
	public UsuarioServiciosListaControlador(){
		setCommandClass(UsuarioServiciosBean.class);
		setCommandName("usuarioServicios");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		UsuarioServiciosBean usuarioServicios = (UsuarioServiciosBean) command;
		
		List usuarios =	usuarioServiciosServicio.lista(tipoLista, usuarioServicios);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(usuarios);
		
		return new ModelAndView("ventanilla/usuarioServiciosListaVista", "listaResultado", listaResultado);
	}
	
	public void setUsuarioServiciosServicio(
			UsuarioServiciosServicio usuarioServiciosServicio) {
		this.usuarioServiciosServicio = usuarioServiciosServicio;
	}

}
