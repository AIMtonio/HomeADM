package contabilidad.controlador;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.CentroCostosBean;
import contabilidad.servicio.CentroCostosServicio;



public class CentroCostosListaControlador extends AbstractCommandController {
	
	CentroCostosServicio centroCostosServicio = null;
	
	public CentroCostosListaControlador() {
		setCommandClass(CentroCostosBean.class);
		setCommandName("centros");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	CentroCostosBean centro = (CentroCostosBean) command;
	List centros =	centroCostosServicio.lista(tipoLista, centro);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(centros);
			
	return new ModelAndView("contabilidad/centroCostosListaVista", "listaResultado", listaResultado);
	}

	public void setCentroCostosServicio(CentroCostosServicio centroCostosServicio) {
		this.centroCostosServicio = centroCostosServicio;
	}

	
}

