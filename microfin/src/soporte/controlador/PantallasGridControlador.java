package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.MenuAplicacionBean;
import soporte.bean.MenuBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.MenuServicio;
import soporte.servicio.MenuServicio.Enum_Con_Menu;

public class PantallasGridControlador extends AbstractCommandController{
		
	MenuServicio menuServicio = null;
	public PantallasGridControlador() {
		setCommandClass(UsuarioBean.class);
		setCommandName("usuarioBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {			
		UsuarioBean usuarioBean = (UsuarioBean) command;
		MenuAplicacionBean menuAplicacion = null;
		String  lado = (request.getParameter("ladoLista")!=null) ? request.getParameter("ladoLista") : "";
		menuAplicacion = menuServicio.consultaMenuPorPerfil(Enum_Con_Menu.gralConfig, usuarioBean);
		List<Object> listaResultado = (List<Object>)new ArrayList(); 
		
		MenuBean menu = null;
				
		listaResultado.add(lado);	
		listaResultado.add(menuAplicacion);		
		
		return new ModelAndView("soporte/pantallasGridVista", "listaResultado", listaResultado);
		
		
	}

	public void setMenuServicio(MenuServicio menuServicio) {
		this.menuServicio = menuServicio;
	}

}	//Nueva instalacion a kubo 1.1

