package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import nomina.bean.ProcAfiliaBajaCtaClabeBean;
import nomina.servicio.ProcAfiliaBajaCtaClabeServicio;


public class ProcAfiliaBajaCtaClabeGridControlador extends AbstractCommandController{
	ProcAfiliaBajaCtaClabeServicio procAfiliaBajaCtaClabeServicio = null;
	
	public ProcAfiliaBajaCtaClabeGridControlador(){
		setCommandClass(ProcAfiliaBajaCtaClabeBean.class);
		setCommandName("procAfiliaBajaCtaClabeBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		ProcAfiliaBajaCtaClabeBean procAfiliaBajaCtaClabeBean = null;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String page = request.getParameter("page");
		String tipoPaginacion = "";
		
		List listaResultado = new ArrayList();

		if(page == null){
			tipoPaginacion = "Completa";
		}
		
		List afiliacionLis =  null;
		
		if(tipoPaginacion.equalsIgnoreCase("Completa")){
			
			procAfiliaBajaCtaClabeBean = (ProcAfiliaBajaCtaClabeBean) command;
						
			afiliacionLis = procAfiliaBajaCtaClabeServicio.lista(tipoLista, procAfiliaBajaCtaClabeBean);
			
			PagedListHolder afiliacionList = new PagedListHolder(afiliacionLis);
			
			afiliacionList.setPageSize(20);	
			listaResultado.add(0,afiliacionList);

			request.getSession().setAttribute("afiliacionList", listaResultado);
			
		}else{		
			PagedListHolder afiliacionList = null;
			
			if(request.getSession().getAttribute("afiliacionList")!= null){
				
				listaResultado = (List) request.getSession().getAttribute("afiliacionList");
				afiliacionList = (PagedListHolder) listaResultado.get(0);
				
				if ("next".equals(page)) {
					afiliacionList.nextPage();
				}
				else if ("previous".equals(page)) {
					afiliacionList.previousPage();
				}	
			}else{
				afiliacionList = null;
			}
			
			listaResultado.add(0, afiliacionList);
		}

		return new ModelAndView("nomina/procAfiliaBajaCtaClabeGridVista", "listaResultado", listaResultado);
	}

	// ============== GETTER & SETTER ===================
	
	public ProcAfiliaBajaCtaClabeServicio getProcAfiliaBajaCtaClabeServicio() {
		return procAfiliaBajaCtaClabeServicio;
	}

	public void setProcAfiliaBajaCtaClabeServicio(ProcAfiliaBajaCtaClabeServicio procAfiliaBajaCtaClabeServicio) {
		this.procAfiliaBajaCtaClabeServicio = procAfiliaBajaCtaClabeServicio;
	}

}
