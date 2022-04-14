package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.servicio.ClasificaTipDocServicio;
import originacion.bean.ClasificaTipDocBean;

public class ClasificaTipDocGridControlador extends AbstractCommandController {
	
	ClasificaTipDocServicio clasificaTipDocServicio=null;
	public ClasificaTipDocGridControlador() {
		setCommandClass(ClasificaTipDocBean.class);
		setCommandName("clasificacion");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {			
		ClasificaTipDocBean clasificacion = (ClasificaTipDocBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		String page = request.getParameter("page");
	    String tipoPaginacion = "";
		  
	    
	    List listaResultado = (List)new ArrayList();
		if (page == null) {
			tipoPaginacion = "Completa";
		}
		
		if (tipoPaginacion.equalsIgnoreCase("Completa")) {
			List listaResul = clasificaTipDocServicio.lista(tipoLista, clasificacion);
			
			PagedListHolder documentosLis = new PagedListHolder(listaResul);
			documentosLis.setPageSize(15);
			listaResultado.add(tipoLista);
			listaResultado.add(documentosLis);
	
			request.getSession().setAttribute("ConsultaMonitorGridControlador", listaResultado);

		} else {
			
			
            PagedListHolder docList = null;
	
			if (request.getSession().getAttribute("ConsultaMonitorGridControlador") != null) {
				listaResultado = (List) request.getSession().getAttribute("ConsultaMonitorGridControlador");
				docList = (PagedListHolder) listaResultado.get(1);
				
				if ("next".equals(page)) {
					docList.nextPage();
				}
				else if ("previous".equals(page)) {
					docList.previousPage();
					docList.getPage();
				}
			} else {
				docList = null;
			}			
			listaResultado.add(tipoLista);
			listaResultado.add(docList);
			
	
		}		


		return new ModelAndView("originacion/clasificaDocumentosGridVista", "listaResultado", listaResultado);
	}
//---------setter-------
	public void setClasificaTipDocServicio(
			ClasificaTipDocServicio clasificaTipDocServicio) {
		this.clasificaTipDocServicio = clasificaTipDocServicio;
	}

	
}
