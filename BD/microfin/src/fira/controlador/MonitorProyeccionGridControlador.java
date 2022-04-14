package fira.controlador;


import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fira.bean.MonitorProyeccionBean;
import fira.servicio.MonitorProyeccionServicio;

public class MonitorProyeccionGridControlador extends AbstractCommandController{
	MonitorProyeccionServicio monitorProyeccionServicio = null;
	
	public MonitorProyeccionGridControlador(){
		setCommandClass(MonitorProyeccionBean.class);
		setCommandName("proyeccionBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		MonitorProyeccionBean respuestaBean = (MonitorProyeccionBean)command;
		int anioLista = Integer.parseInt(request.getParameter("anioLista"));
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));	

		
		String page = request.getParameter("page");
	    String tipoPaginacion = "";
		  
	    
	    List listaResultado = (List)new ArrayList();
		if (page == null) {
			tipoPaginacion = "Completa";
		}
		
				
		if (tipoPaginacion.equalsIgnoreCase("Completa")) {

			List listaResul = monitorProyeccionServicio.listaProyeccion(anioLista, tipoLista,respuestaBean);
			
			PagedListHolder proyeccionLis = new PagedListHolder(listaResul);
			proyeccionLis.setPageSize(50);
			listaResultado.add(anioLista);
			listaResultado.add(tipoLista);
			listaResultado.add(proyeccionLis);			
	
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
			
			listaResultado.add(anioLista);
			listaResultado.add(tipoLista);
			listaResultado.add(credList);
			
	
		}
		
		return new ModelAndView("fira/monitorProyeccionGridVista", "listaResultado", listaResultado);
	}

	public MonitorProyeccionServicio getMonitorProyeccionServicio() {
		return monitorProyeccionServicio;
	}

	public void setMonitorProyeccionServicio(
			MonitorProyeccionServicio monitorProyeccionServicio) {
		this.monitorProyeccionServicio = monitorProyeccionServicio;
	}

		

}
