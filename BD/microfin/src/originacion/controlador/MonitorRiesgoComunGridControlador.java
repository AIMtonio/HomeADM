package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.MonitorRiesgoComunBean;
import originacion.servicio.MonitorRiesgoComunServicio;


public class MonitorRiesgoComunGridControlador extends AbstractCommandController{
	MonitorRiesgoComunServicio monitorRiesgoComunServicio = null;
	
	public MonitorRiesgoComunGridControlador(){
		setCommandClass(MonitorRiesgoComunBean.class);
		setCommandName("riesgoComunBean");	
		
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		MonitorRiesgoComunBean respuestaBean = (MonitorRiesgoComunBean)command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));	

		String page = request.getParameter("page");
	    String tipoPaginacion = "";
		  
	    
	    List listaResultado = (List)new ArrayList();
		if (page == null) {
			tipoPaginacion = "Completa";
		}
		
		if (tipoPaginacion.equalsIgnoreCase("Completa")) {

			List listaResul = monitorRiesgoComunServicio.listaRiesgoComun(tipoLista,respuestaBean);
			
			PagedListHolder riesgosLis = new PagedListHolder(listaResul);
			riesgosLis.setPageSize(50);
			listaResultado.add(tipoLista);
			listaResultado.add(riesgosLis);			
	
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
		
		return new ModelAndView("originacion/monitorRiesgoComunGridVista", "listaResultado", listaResultado);
	}

	public MonitorRiesgoComunServicio getMonitorRiesgoComunServicio() {
		return monitorRiesgoComunServicio;
	}

	public void setMonitorRiesgoComunServicio(
			MonitorRiesgoComunServicio monitorRiesgoComunServicio) {
		this.monitorRiesgoComunServicio = monitorRiesgoComunServicio;
	}

	

		
}
