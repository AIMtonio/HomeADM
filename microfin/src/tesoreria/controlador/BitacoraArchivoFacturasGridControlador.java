package tesoreria.controlador;

import herramientas.Utileria;
import tesoreria.bean.CargaMasivaFacturasBean;
import tesoreria.servicio.CargaMasivaFacturasServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class BitacoraArchivoFacturasGridControlador extends AbstractCommandController{
	CargaMasivaFacturasServicio cargaMasivaFacturasServicio = null;
	
	public BitacoraArchivoFacturasGridControlador() {
		setCommandClass(CargaMasivaFacturasBean.class);
		setCommandName("cargaMasivaFacturasBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		List listaResultado = new ArrayList();
		try {			
			
			
			CargaMasivaFacturasBean cargaMasivaFacturas = (CargaMasivaFacturasBean) command;
			int tipoLista = (request.getParameter("tipoLista")!=null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
	
			String pagina = request.getParameter("page");
			String tipoPaginacion = "";
			String completa = "Completa";
			String nombreLista = request.getParameter("nombreLista");
			if(pagina == null){
				tipoPaginacion = completa;
			}
	
			List listaCargaMasivaFacturasBean = null;
			PagedListHolder listaPaginada = null;
	
			if(tipoPaginacion.equalsIgnoreCase("Completa")){
				listaCargaMasivaFacturasBean = cargaMasivaFacturasServicio.lista(tipoLista, cargaMasivaFacturas);
				listaPaginada = new PagedListHolder(listaCargaMasivaFacturasBean);
			}else{

				if(request.getSession().getAttribute(nombreLista) != null){
					// Agrego las Observaciones, ubicacion, estatus
					listaResultado = (List) request.getSession().getAttribute(nombreLista);
					listaPaginada = (PagedListHolder) listaResultado.get(1);
					List listaParametros = listaPaginada.getSource();
					// Obtengo los elementos que se envian en el js
					String[] listaFolioCargaID = request.getParameter("listaFolioCargaID").split(",");
					String[] listaEstatus = request.getParameter("listaEstatus").split(",");
					String[] listaEsSeleccionado = request.getParameter("listaEsSeleccionado").split(",");
				
					
					for(int iteracion =0; iteracion <listaParametros.size(); iteracion++){
	
						CargaMasivaFacturasBean cargaMasivaFacturasBean = (CargaMasivaFacturasBean) listaParametros.get(iteracion);
						
						for(int itaradorAuxiliar =0; itaradorAuxiliar<listaFolioCargaID.length; itaradorAuxiliar++){
							if(cargaMasivaFacturasBean.getFolioFacturaID().equalsIgnoreCase((String) listaFolioCargaID[itaradorAuxiliar])){
								cargaMasivaFacturasBean.setFolioFacturaID((String)listaFolioCargaID[itaradorAuxiliar]);
								cargaMasivaFacturasBean.setSeleccionadoCheck((String)listaEsSeleccionado[itaradorAuxiliar]);
								cargaMasivaFacturasBean.setEstatus((String)listaEstatus[itaradorAuxiliar]);
							
							}
							listaParametros.set(iteracion, cargaMasivaFacturasBean);
						}
	
					}
					listaPaginada.setSource(listaParametros);
	
				}
				
				// Se guarda la paginacion
				listaCargaMasivaFacturasBean = (List) request.getSession().getAttribute(nombreLista);
				listaPaginada = (PagedListHolder) listaCargaMasivaFacturasBean.get(1);
				listaPaginada.getSource();
	
				if("next".equals(pagina)) {
					listaPaginada.nextPage();
				} else if ("previous".equals(pagina)) {
					listaPaginada.previousPage();
				} else if ("check".equals(pagina)) {
					listaPaginada.getPage();
				} else {
					listaPaginada = null;
				}
	
			}
	
			listaPaginada.setPageSize(25);
			listaResultado.add(0,tipoLista);
			listaResultado.add(1,listaPaginada);
			request.getSession().setAttribute(nombreLista, listaResultado);
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView("tesoreria/bitacoraArchivoFacturasGridVista", "listaBitacoraCarga", listaResultado);
		
	}


	//------------------ Setter y Getters --------------------------
	public CargaMasivaFacturasServicio getCargaMasivaFacturasServicio() {
		return cargaMasivaFacturasServicio;
	}
	public void setCargaMasivaFacturasServicio(
			CargaMasivaFacturasServicio cargaMasivaFacturasServicio) {
		this.cargaMasivaFacturasServicio = cargaMasivaFacturasServicio;
	}

}