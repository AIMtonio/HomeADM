package fira.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fira.bean.MonitorExcedentesBean;
import fira.servicio.MonitorExcedentesServicio;


public class MonitorExcedentesGridControlador extends AbstractCommandController {
	MonitorExcedentesServicio monitorExcedentesServicio = null;
	
	public MonitorExcedentesGridControlador(){
		setCommandClass(MonitorExcedentesBean.class);
		setCommandName("excedentesBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		MonitorExcedentesBean respuestaBean = (MonitorExcedentesBean)command;
		String fecha = request.getParameter("fecha");
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));	

		String page = request.getParameter("page");
	    String tipoPaginacion = "";
		  
	    
	    List listaResultado = (List)new ArrayList();
		if (page == null) {
			tipoPaginacion = "Completa";
		}
		
				
		if (tipoPaginacion.equalsIgnoreCase("Completa")) {

			List listaResul = monitorExcedentesServicio.listaExcedentes(fecha, tipoLista,respuestaBean);
			
			PagedListHolder excedenteLis = new PagedListHolder(listaResul);
			excedenteLis.setPageSize(25);
			listaResultado.add(tipoLista);
			listaResultado.add(excedenteLis);			
	
			request.getSession().setAttribute("ConsultaMonitorGridControlador", listaResultado);

		} else {
			PagedListHolder credList = null;
	
			if (request.getSession().getAttribute("ConsultaMonitorGridControlador") != null) {
				listaResultado = (List) request.getSession().getAttribute("ConsultaMonitorGridControlador");
				credList = (PagedListHolder) listaResultado.get(1);
				if ("next".equals(page)) {
					credList.nextPage();
				}
				else if ("previous".equals(page)) {
					credList.previousPage();
					credList.getPage();
				}
			} else {
				credList = null;
			}			
			listaResultado.add(tipoLista);
			listaResultado.add(credList);
			
	
		}
		
		return new ModelAndView("fira/monitorExcedentesGridVista", "listaResultado", listaResultado);
	}

	public MonitorExcedentesServicio getMonitorExcedentesServicio() {
		return monitorExcedentesServicio;
	}

	public void setMonitorExcedentesServicio(
			MonitorExcedentesServicio monitorExcedentesServicio) {
		this.monitorExcedentesServicio = monitorExcedentesServicio;
	}
}
