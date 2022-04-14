package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.GrupoMenuBean;
import soporte.bean.MenuBean;
import soporte.servicio.GrupoMenuServicio;
import soporte.servicio.MenuServicio;

public class MenuListaControlador extends AbstractCommandController {
	
	public void setMenuServicio(MenuServicio menuServicio) {
		this.menuServicio = menuServicio;
	}

	MenuServicio menuServicio = null;
	
	public MenuListaControlador() {
		setCommandClass(MenuBean.class);
		setCommandName("menus");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	MenuBean menu = (MenuBean) command;
	List menus =	menuServicio.lista(tipoLista,menu);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(menus);
			
	return new ModelAndView("soporte/menuListaVista", "listaResultado", listaResultado);
	}

	
	
	
}
