package psl.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.MonitorSolicitudesBean;

import psl.bean.PSLConfigServicioBean;
import psl.servicio.PSLConfigServicioServicio;

public class PSLConfigServicioGridControlador extends AbstractCommandController {
	PSLConfigServicioServicio pslConfigServicioServicio;

	public PSLConfigServicioGridControlador(){
		setCommandClass(PSLConfigServicioBean.class);
 		setCommandName("pslConfigServicioBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		int cantidadRegistros = 0;
		
		List listaResultado = new ArrayList();
		PSLConfigServicioBean pslConfigServicioBean = (PSLConfigServicioBean) command;
		List listaConfiguraciones = pslConfigServicioServicio.lista(tipoLista, pslConfigServicioBean);
		if(listaConfiguraciones == null) {
			listaConfiguraciones = new ArrayList();
		}
		cantidadRegistros = listaConfiguraciones.size();
		
		PagedListHolder pagedListConfiguraciones = new PagedListHolder(listaConfiguraciones);
		pagedListConfiguraciones.setPageSize(400);
		listaResultado.add(tipoLista);
		listaResultado.add(pagedListConfiguraciones);
		listaResultado.add(cantidadRegistros);
		
		return new ModelAndView("psl/pslConfigServicioGridVista", "listaResultado", listaResultado);
	}
	
	public PSLConfigServicioServicio getPslConfigServicioServicio() {
		return pslConfigServicioServicio;
	}

	public void setPslConfigServicioServicio(PSLConfigServicioServicio pslConfigServicioServicio) {
		this.pslConfigServicioServicio = pslConfigServicioServicio;
	}
		
}
