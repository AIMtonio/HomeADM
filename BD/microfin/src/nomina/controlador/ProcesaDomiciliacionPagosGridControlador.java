package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import nomina.bean.ProcesaDomiciliacionPagosBean;
import nomina.servicio.ProcesaDomiciliacionPagosServicio;


public class ProcesaDomiciliacionPagosGridControlador extends AbstractCommandController{
	ProcesaDomiciliacionPagosServicio procesaDomiciliacionPagosServicio = null;
	
	public ProcesaDomiciliacionPagosGridControlador(){
		setCommandClass(ProcesaDomiciliacionPagosBean.class);
		setCommandName("procesaDomiciliacionPagosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean = null;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String page = request.getParameter("page");
		String tipoPaginacion = "";
		
		List listaResultado = new ArrayList();

		if(page == null){
			tipoPaginacion = "Completa";
		}
		
		List domiciliacionLis = null;

		if(tipoPaginacion.equalsIgnoreCase("Completa")){
			
			procesaDomiciliacionPagosBean = (ProcesaDomiciliacionPagosBean) command;
			
			domiciliacionLis = procesaDomiciliacionPagosServicio.lista(tipoLista, procesaDomiciliacionPagosBean);
			
			PagedListHolder domiciliaPagosList = new PagedListHolder(domiciliacionLis);
			
			domiciliaPagosList.setPageSize(20);	
			listaResultado.add(0,domiciliaPagosList);
		
			request.getSession().setAttribute("domiciliaPagosList", listaResultado);
			
		}else{		
			PagedListHolder domiciliaPagosList = null;
			
			if(request.getSession().getAttribute("domiciliaPagosList")!= null){
				
				listaResultado = (List) request.getSession().getAttribute("domiciliaPagosList");
				domiciliaPagosList = (PagedListHolder) listaResultado.get(0);
				
				if ("next".equals(page)) {
					domiciliaPagosList.nextPage();
				}
				else if ("previous".equals(page)) {
					domiciliaPagosList.previousPage();
				}	
			}else{
				domiciliaPagosList = null;
			}
			
			listaResultado.add(0, domiciliaPagosList);

		}
		
		return new ModelAndView("nomina/procesaDomiciliacionPagosGridVista", "listaResultado", listaResultado);
	
	}
		
	// ============== GETTER & SETTER ===================
	
	public ProcesaDomiciliacionPagosServicio getProcesaDomiciliacionPagosServicio() {
		return procesaDomiciliacionPagosServicio;
	}

	public void setProcesaDomiciliacionPagosServicio(ProcesaDomiciliacionPagosServicio procesaDomiciliacionPagosServicio) {
		this.procesaDomiciliacionPagosServicio = procesaDomiciliacionPagosServicio;
	}

}