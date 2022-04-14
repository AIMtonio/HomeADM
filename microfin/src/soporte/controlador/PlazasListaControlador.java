package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.PlazasBean;
import soporte.servicio.PlazasServicio;



public class PlazasListaControlador extends AbstractCommandController {
	
	PlazasServicio plazasServicio = null;
	
	public PlazasListaControlador() {
		setCommandClass(PlazasBean.class);
		setCommandName("plazas");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	PlazasBean plaza = (PlazasBean) command;
	List plazas =	plazasServicio.lista(tipoLista, plaza);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(plazas);
			
	return new ModelAndView("soporte/plazasListaVista", "listaResultado", listaResultado);
	}

	public void setPlazasServicio(PlazasServicio plazasServicio) {
		this.plazasServicio = plazasServicio;
	}
	
}

