package seguimiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import seguimiento.bean.SeguimientoBean;
import seguimiento.servicio.SeguimientoServicio;

public class SeguimientoListaControlador extends AbstractCommandController{
	
	SeguimientoServicio seguimientoServicio = null;
	
	public SeguimientoListaControlador() {
		setCommandClass(SeguimientoBean.class);
		setCommandName("seguimientoBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		SeguimientoBean seguimiento = (SeguimientoBean) command;
		List ListSeguimiento = seguimientoServicio.lista(tipoLista, seguimiento);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(ListSeguimiento);
		
		return new ModelAndView("seguimiento/seguimientoListaVista", "listaResultado",listaResultado);
	}

	public SeguimientoServicio getSeguimientoServicio() {
		return seguimientoServicio;
	}

	public void setSeguimientoServicio(SeguimientoServicio seguimientoServicio) {
		this.seguimientoServicio = seguimientoServicio;
	}
}