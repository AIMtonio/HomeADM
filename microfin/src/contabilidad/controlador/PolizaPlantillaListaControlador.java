package contabilidad.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.PolizaBean;
import contabilidad.servicio.PolizaServicio;

public class PolizaPlantillaListaControlador extends AbstractCommandController {

	PolizaServicio polizaServicio = null;
	
	public PolizaPlantillaListaControlador() {
		setCommandClass(PolizaBean.class);
		setCommandName("poliza");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
			
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
	
		PolizaBean polizaBean = (PolizaBean) command;
		List ocupaciones =	polizaServicio.lista(tipoLista, polizaBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(ocupaciones);
				
		return new ModelAndView("contabilidad/polizaPlantillaListaVista", "listaResultado", listaResultado);											  
	}

	public void setPolizaServicio(PolizaServicio polizaServicio) {
		this.polizaServicio = polizaServicio;
	}
}
	