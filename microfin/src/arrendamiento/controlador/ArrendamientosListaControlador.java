package arrendamiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import arrendamiento.bean.ArrendamientosBean;
import arrendamiento.servicio.ArrendamientosServicio;

public class ArrendamientosListaControlador extends AbstractCommandController {
	
	ArrendamientosServicio arrendamientosServicio = null;
	
	public ArrendamientosListaControlador() {
		setCommandClass(ArrendamientosBean.class);
		setCommandName("arrendamientosBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {

	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	ArrendamientosBean arrendamientos = (ArrendamientosBean) command;
	
	List lineaArrenda =	 arrendamientosServicio.lista(tipoLista, arrendamientos);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(lineaArrenda);
			
	return new ModelAndView("arrendamiento/arrendamientosListaVista", "listaResultado", listaResultado);
	}

	public void setArrendamientosServicio(
			ArrendamientosServicio arrendamientosServicio) {
		this.arrendamientosServicio = arrendamientosServicio;
	}
	
}
