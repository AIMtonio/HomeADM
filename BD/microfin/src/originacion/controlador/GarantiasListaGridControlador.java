package originacion.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.GarantiaBean;
import originacion.servicio.GarantiaServicio;



public class GarantiasListaGridControlador extends AbstractCommandController {
	
	GarantiaServicio garantiaServicio  = null;
	
	public GarantiasListaGridControlador() {
		setCommandClass(GarantiaBean.class);
		setCommandName("solCheckListGrid");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {			
		GarantiaBean garantiasListaBean = (GarantiaBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List listaGrigGarantias = garantiaServicio.listaAsignaGarantias(tipoLista, garantiasListaBean);

		return new ModelAndView("originacion/garantiasListaGridVista", "listaResultado", listaGrigGarantias);
	}

	

	//----- setter---------
	public void setGarantiaServicio(GarantiaServicio garantiaServicio) {
		this.garantiaServicio = garantiaServicio;
	}
	
	
}
