package tarjetas.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.BitacoraLoteDebBean;
import tarjetas.servicio.BitacoraLoteDebServicio;

public class BitacoraCargaLoteGridControlador extends AbstractCommandController{

	BitacoraLoteDebServicio bitacoraLoteDebServicio = null;
	
	
	
	public BitacoraCargaLoteGridControlador() {
		setCommandClass(BitacoraLoteDebBean.class);
		setCommandName("bitacoraLoteDebBean");
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
			BitacoraLoteDebBean loteDebBean = (BitacoraLoteDebBean) command;
			tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			List reporteBitacoraList = bitacoraLoteDebServicio.lista(tipoLista, loteDebBean);
			PagedListHolder bitacoraList = new PagedListHolder(reporteBitacoraList);
			bitacoraList.setPageSize(20);
			request.getSession().setAttribute("BitacoraCargaLoteGridControlador_listaBitacoraCarga", bitacoraList);
			return new ModelAndView("tarjetas/bitacoraCargaLoteTarDebGridVista", "listaPaginada", bitacoraList);
		}else{		
			PagedListHolder bitacoraList = null;
			if(request.getSession().getAttribute("BitacoraCargaLoteGridControlador_listaBitacoraCarga")!= null){
				bitacoraList = (PagedListHolder) request.getSession().getAttribute("BitacoraCargaLoteGridControlador_listaBitacoraCarga");
				if ("next".equals(page)) {
					bitacoraList.nextPage();
				}
				else if ("previous".equals(page)) {
					bitacoraList.previousPage();
				}	
			}else{
				bitacoraList = null;
		}
		
		return new ModelAndView("tarjetas/bitacoraCargaLoteTarDebGridVista", "listaPaginada", bitacoraList);
		}
	}
	
	
	//------------------ Setter y Getters --------------------------
	public void setBitacoraLoteDebServicio(
			BitacoraLoteDebServicio bitacoraLoteDebServicio) {
		this.bitacoraLoteDebServicio = bitacoraLoteDebServicio;
	}
	
	
}
