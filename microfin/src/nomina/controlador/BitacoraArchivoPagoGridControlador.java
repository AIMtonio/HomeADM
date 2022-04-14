package nomina.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import java.util.List;
import nomina.bean.CargaPagoErrorBean;
import nomina.servicio.BitacoraPagoNominaServicio;

public class BitacoraArchivoPagoGridControlador extends AbstractCommandController{
	BitacoraPagoNominaServicio bitacoraPagoNominaServicio = null;
	
	public BitacoraArchivoPagoGridControlador() {
		setCommandClass(CargaPagoErrorBean.class);
		setCommandName("bitacoraPagoNominaBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
			
		int tipoLista = 0;
		String page = request.getParameter("page");
		String tipoPaginacion = "";
		if(page == null){
			tipoPaginacion = "Completa";
		}

		if(tipoPaginacion.equalsIgnoreCase("Completa")){
			CargaPagoErrorBean cargaPagoErrorBean = (CargaPagoErrorBean) command;
			tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			List reporteBitacoraList = bitacoraPagoNominaServicio.lista(tipoLista, cargaPagoErrorBean);
			PagedListHolder bitacoraList = new PagedListHolder(reporteBitacoraList);
			bitacoraList.setPageSize(20);
			request.getSession().setAttribute("BitacoraArchivoPagoGridControlador_listaBitacoraCarga", bitacoraList);
			return new ModelAndView("nomina/bitacoraArchivoPagoGridVista", "listaPaginada", bitacoraList);
		}else{		
			PagedListHolder bitacoraList = null;
			if(request.getSession().getAttribute("BitacoraArchivoPagoGridControlador_listaBitacoraCarga")!= null){
				bitacoraList = (PagedListHolder) request.getSession().getAttribute("BitacoraArchivoPagoGridControlador_listaBitacoraCarga");
				if ("next".equals(page)) {
					bitacoraList.nextPage();
					}
					else if ("previous".equals(page)) {
						bitacoraList.previousPage();
					}	
			}else{
				bitacoraList = null;
				}

			return new ModelAndView("nomina/bitacoraArchivoPagoGridVista", "listaPaginada", bitacoraList);
			}
		}

	//------------------ Setter y Getters --------------------------
	public BitacoraPagoNominaServicio getBitacoraPagoNominaServicio() {
		return bitacoraPagoNominaServicio;
	}

	public void setBitacoraPagoNominaServicio(
			BitacoraPagoNominaServicio bitacoraPagoNominaServicio) {
		this.bitacoraPagoNominaServicio = bitacoraPagoNominaServicio;
	}	
}