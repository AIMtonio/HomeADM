package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.CargosBean;
import soporte.servicio.CargosServicio;



public class CargosListaControlador extends AbstractCommandController {
	
	CargosServicio cargosServicio = null;
	
	public CargosListaControlador() {
		setCommandClass(CargosBean.class);
		setCommandName("cargos");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	CargosBean cargo = (CargosBean) command;
	List cargos  =	cargosServicio.lista(tipoLista, cargo);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(cargos);
			
	return new ModelAndView("soporte/cargosListaVista", "listaResultado", listaResultado);
	}

	public CargosServicio getCargosServicio() {
		return cargosServicio;
	}

	public void setCargosServicio(CargosServicio cargosServicio) {
		this.cargosServicio = cargosServicio;
	}

	
}

