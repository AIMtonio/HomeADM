package tarjetas.controlador;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import com.google.gson.Gson;

import tarjetas.bean.TarBinParamsBean;
import tarjetas.servicio.TarBinParamsServicio;

public class TarParametrosBINGridControlador extends AbstractCommandController {

	TarBinParamsServicio tarjetaBinParamsServicio = null;
	
	public TarParametrosBINGridControlador() {
		setCommandClass(TarBinParamsBean.class);
		setCommandName("tarBinParamsBean");
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
			TarBinParamsBean tarBinParamsBean = (TarBinParamsBean) command;
			tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			
			List lista = tarjetaBinParamsServicio.lista(tipoLista, tarBinParamsBean);
			PagedListHolder binList = new PagedListHolder(lista);
			binList.setPageSize(15);
			request.getSession().setAttribute("BINGridControlador_lista", binList);
			
			return new ModelAndView("tarjetas/tarParametrosBINGrid", "listaPaginada", binList);
		}else{
			PagedListHolder binList = null;
			if(request.getSession().getAttribute("BINGridControlador_lista")!= null){
				binList = (PagedListHolder) request.getSession().getAttribute("BINGridControlador_lista");
			if ("next".equals(page)) {
				binList.nextPage();
			}
			else if ("previous".equals(page)) {
				binList.previousPage();
			}
		}else{
			binList = null;
		}
			return new ModelAndView("tarjetas/tarParametrosBINGrid", "listaPaginada", binList);
		}
		
	}

	public TarBinParamsServicio getTarjetaBinParamsServicio() {
		return tarjetaBinParamsServicio;
	}

	public void setTarjetaBinParamsServicio(
			TarBinParamsServicio tarjetaBinParamsServicio) {
		this.tarjetaBinParamsServicio = tarjetaBinParamsServicio;
	}

}
