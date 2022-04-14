package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.DepositosRefeBean;
import tesoreria.bean.DispersionMasivaBean;
import tesoreria.servicio.DispersionMasivaServicio;

public class DispersionMasivaGridControlador extends AbstractCommandController{
	
	DispersionMasivaServicio dispersionMasivaServicio;
	
	public DispersionMasivaGridControlador() {
		setCommandClass(DispersionMasivaBean.class);
		setCommandName("dispersionMasivaBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		DispersionMasivaBean dispersionMasivaBean = (DispersionMasivaBean)command;
		
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		String pagina = request.getParameter("pagina");
		
		int errorExito = 1;
		String tipoPaginacion ="";
		PagedListHolder lisValidacion = null;
		
		if(pagina == null){
			tipoPaginacion= "Completa";
		}
		
		MensajeTransaccionBean mensaje = null;
		
		List<DispersionMasivaBean> listaValidacion = null;
		List listaResultado = new ArrayList();
		
		if(tipoPaginacion.equalsIgnoreCase("Completa")){
			mensaje = dispersionMasivaServicio.valida(tipoTransaccion,dispersionMasivaBean);
			
			if(mensaje.getNumero() == 0){
				dispersionMasivaBean.setNumTransaccion(mensaje.getConsecutivoInt());
				listaValidacion = dispersionMasivaServicio.lista(tipoLista, dispersionMasivaBean);
	
				if(listaValidacion.size() == 0){
					dispersionMasivaBean.setLinea("0");
					dispersionMasivaBean.setValidacion("validación Exitosa.");
					listaValidacion.add(dispersionMasivaBean);
					errorExito = 0;
				}else{
					//Si tiene validaciones damos de baja el archivo para que se pueda carga de nuevo
					dispersionMasivaServicio.valida(3, dispersionMasivaBean);
				}
			}else{
				listaValidacion = new ArrayList();
				dispersionMasivaBean.setLinea(mensaje.getNumero()+"");
				dispersionMasivaBean.setValidacion(mensaje.getDescripcion());
				listaValidacion.add(dispersionMasivaBean);
			}
			
			lisValidacion = new PagedListHolder(listaValidacion);
			
		}else{
			if (request.getSession().getAttribute("listaValidacion") != null) {
				listaResultado = (List) request.getSession().getAttribute("listaValidacion");
				lisValidacion =  (PagedListHolder) listaResultado.get(1);
				
				if ("siguiente".equals(pagina)) {
					lisValidacion.nextPage();
				}else if ("anterior".equals(pagina)) {
					lisValidacion.previousPage();
				}else if("primero".equals(pagina)){
					lisValidacion.setPage(0);
					lisValidacion.getPage();
				}else if("ultimo".equals(pagina)){
					lisValidacion.setPage(lisValidacion.getPageCount()-1);
					lisValidacion.getPage();
				}
			}
		}
		
		lisValidacion.setPageSize(25);
		
		
		listaResultado.add(0,tipoLista);
		listaResultado.add(1,lisValidacion);
		listaResultado.add(2,errorExito);
		listaResultado.add(3,dispersionMasivaBean.getNumTransaccion());
		listaResultado.add(4,lisValidacion.getPage()+1);
		listaResultado.add(5,lisValidacion.getPageCount());
		request.getSession().setAttribute("listaValidacion", listaResultado);
		
		return new ModelAndView("tesoreria/dispersionMasivaGridVista", "listaResultado", listaResultado);
	}

	public DispersionMasivaServicio getDispersionMasivaServicio() {
		return dispersionMasivaServicio;
	}

	public void setDispersionMasivaServicio(
			DispersionMasivaServicio dispersionMasivaServicio) {
		this.dispersionMasivaServicio = dispersionMasivaServicio;
	}
	
}
