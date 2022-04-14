package seguimiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import seguimiento.bean.SegtoManualBean;
import seguimiento.servicio.SegtoManualServicio;

public class CalSeguimientoListaControlador extends AbstractCommandController{	
	SegtoManualServicio segtoManualServicio = null;
	
	public CalSeguimientoListaControlador() {
		setCommandClass(SegtoManualBean.class);
		setCommandName("segtoManualBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		SegtoManualBean seguimiento = (SegtoManualBean) command;
		List ListSeguimiento =	segtoManualServicio.lista(tipoLista, seguimiento);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(ListSeguimiento );
		
		return new ModelAndView("seguimiento/segtoListaVista", "listaResultado",listaResultado);
	}

	public SegtoManualServicio getSegtoManualServicio() {
		return segtoManualServicio;
	}

	public void setSegtoManualServicio(SegtoManualServicio segtoManualServicio) {
		this.segtoManualServicio = segtoManualServicio;
	}	
}
