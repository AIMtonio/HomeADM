package psl.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import psl.bean.PSLConfigProductoBean;
import psl.bean.PSLConfigServicioBean;
import psl.servicio.PSLConfigProductoServicio;

public class PSLConfigProductoGridControlador extends AbstractCommandController {
	PSLConfigProductoServicio pslConfigProductoServicio;

	public PSLConfigProductoGridControlador(){
		setCommandClass(PSLConfigProductoBean.class);
 		setCommandName("pslConfigProductoBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaResultado = new ArrayList();
		
		PSLConfigProductoBean pslConfigProductoBean = (PSLConfigProductoBean) command;
		List listaConfiguraciones = pslConfigProductoServicio.lista(tipoLista, pslConfigProductoBean);
		
		
		PagedListHolder pagedListConfiguraciones = new PagedListHolder(listaConfiguraciones);
		pagedListConfiguraciones.setPageSize(400);
		listaResultado.add(tipoLista);
		listaResultado.add(pagedListConfiguraciones);
		
		return new ModelAndView("psl/pslConfigProductoGridVista", "listaResultado", listaResultado);
	}

	public PSLConfigProductoServicio getPslConfigProductoServicio() {
		return pslConfigProductoServicio;
	}

	public void setPslConfigProductoServicio(
			PSLConfigProductoServicio pslConfigProductoServicio) {
		this.pslConfigProductoServicio = pslConfigProductoServicio;
	}
}
