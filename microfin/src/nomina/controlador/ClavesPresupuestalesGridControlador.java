package nomina.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.ListIterator;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.NomClavePresupBean;
import nomina.bean.NomTipoClavePresupBean;
import nomina.servicio.NomClavePresupServicio;
import nomina.servicio.NomTipoClavePresupServicio;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class ClavesPresupuestalesGridControlador extends AbstractCommandController  {
	NomClavePresupServicio nomClavePresupServicio = null;
	
	public ClavesPresupuestalesGridControlador() {
		setCommandClass(NomClavePresupBean.class);
		setCommandName("nomClavePresupBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors) throws Exception {
				
		int tipoLista = (request.getParameter("tipoLista")!=null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;		

		String page = request.getParameter("page");
		String buscar = request.getParameter("buscar");
		String tipoPaginacion = "";
		
		if(page == null && (buscar == null || buscar.length() == 0)){
			tipoPaginacion = "Completa";
		}else{
			tipoPaginacion = page;
		}
		
		if(tipoPaginacion.equals("Completa")){
			System.out.println("Completa");
			NomClavePresupBean nomClavePresupBean = (NomClavePresupBean) command;
			List listaClavePresup = nomClavePresupServicio.lista(tipoLista, nomClavePresupBean);
			
			List listaResultado = new ArrayList();
			
			PagedListHolder clavePresupList = new PagedListHolder(listaClavePresup);
			clavePresupList.setPageSize(30);
			
			listaResultado.add(tipoLista);//0
			listaResultado.add(clavePresupList);//1
			listaResultado.add(listaClavePresup);
						
			request.getSession().setAttribute("GridClavesPresupuestales", listaResultado);
			return new ModelAndView("nomina/clavesPresupuestalesGridVista", "listaResultado", listaResultado);
	
		}else{
			System.out.println("Filtros o paginacion");
			PagedListHolder clavePresupList = null;
			List listaResultado = new ArrayList();
			List listaResultaFiltrado = new ArrayList();
			List listaClavePresup = new ArrayList();
			
			if(request.getSession().getAttribute("GridClavesPresupuestales")!= null){
				listaResultado = (List) request.getSession().getAttribute("GridClavesPresupuestales");
				clavePresupList = (PagedListHolder) listaResultado.get(1);
				
				if ("next".equals(page)) {
					clavePresupList.nextPage();
				}
				else if ("previous".equals(page)) {
					clavePresupList.previousPage();
					clavePresupList.getPage();
				}
				else if ("buscar".equals(page)) {
					listaClavePresup = (List)listaResultado.get(2);
					listaResultado = null;
					clavePresupList = null;
					listaResultado = new ArrayList();
					
					for(int indice = 0;indice< listaClavePresup.size() ;indice++) {
						NomClavePresupBean bean = (NomClavePresupBean)listaClavePresup.get(indice);
						if(bean.getDescripcion().toUpperCase().indexOf(buscar.toUpperCase())>=0){
							listaResultaFiltrado.add(bean);
						}
					}
					
					clavePresupList = new PagedListHolder(listaResultaFiltrado);
					clavePresupList.setPageSize(30);
					
					listaResultado.add(tipoLista);
					listaResultado.add(clavePresupList);
					listaResultado.add(listaClavePresup);
					
					return new ModelAndView("nomina/clavesPresupuestalesGridVista", "listaResultado", listaResultado);
				}
				else {
					int numeroPaginada = Utileria.convierteEntero(tipoPaginacion);
					clavePresupList.setPage(numeroPaginada - 1);
				}
			}else{
				clavePresupList = null;
			}
			
			listaResultado.add(tipoLista);
			listaResultado.add(clavePresupList);
			listaResultado.add(listaClavePresup);
			
			return new ModelAndView("nomina/clavesPresupuestalesGridVista", "listaResultado", listaResultado);
		}
		
	}

	public NomClavePresupServicio getNomClavePresupServicio() {
		return nomClavePresupServicio;
	}

	public void setNomClavePresupServicio(
			NomClavePresupServicio nomClavePresupServicio) {
		this.nomClavePresupServicio = nomClavePresupServicio;
	}


}


