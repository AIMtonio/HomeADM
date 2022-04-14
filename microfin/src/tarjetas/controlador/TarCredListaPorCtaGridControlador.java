package tarjetas.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


import tarjetas.bean.TarjetaCreditoBean;
import tarjetas.servicio.TarjetaCreditoServicio;
public class TarCredListaPorCtaGridControlador extends AbstractCommandController{
	
	TarjetaCreditoServicio tarjetaCreditoServicio = null;

	public TarCredListaPorCtaGridControlador() {
		setCommandClass(TarjetaCreditoBean.class);
		setCommandName("tarjetaDebitoBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {				
				int tipoLista = 0;
					String page = request.getParameter("page");
					String tipoPaginacion = "";
			if(page== null){
			tipoPaginacion = "Completa";
			}
			
			if(tipoPaginacion.equalsIgnoreCase("Completa")){
				TarjetaCreditoBean tarjetaCreditoBean = (TarjetaCreditoBean) command;
			tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			
			List reporteListTarDeb = tarjetaCreditoServicio.lista(tipoLista, tarjetaCreditoBean);
			PagedListHolder movimientosList = new PagedListHolder(reporteListTarDeb);
			movimientosList.setPageSize(20);		
			request.getSession().setAttribute("TarDebListaPorCtaGridControlador_listaMovsCta", movimientosList);
			return new ModelAndView("tarjetas/tarCredAsociaCtaGridVista", "listaPaginada", movimientosList);
			
			}else{		
			PagedListHolder movimientosList = null;
			if(request.getSession().getAttribute("TarDebListaPorCtaGridControlador_listaMovsCta")!= null){
				movimientosList = (PagedListHolder) request.getSession().getAttribute("TarDebListaPorCtaGridControlador_listaMovsCta");
			if ("next".equals(page)) {
				movimientosList.nextPage();
							}
				else if ("previous".equals(page)) {
					movimientosList.previousPage();
				}	
				}else{
					movimientosList = null;
				}
						
				return new ModelAndView("tarjetas/tarDebAsociaCtaGridVista", "listaPaginada", movimientosList);
				}
			}
	public TarjetaCreditoServicio getTarjetaCreditoServicio() {
		return tarjetaCreditoServicio;
	}
	public void setTarjetaCreditoServicio(
			TarjetaCreditoServicio tarjetaCreditoServicio) {
		this.tarjetaCreditoServicio = tarjetaCreditoServicio;
	}
		
}