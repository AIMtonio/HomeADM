package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.GarantesBean;
import originacion.servicio.GarantesServicio;

public class GarantesListaControlador extends AbstractCommandController{
	
	GarantesServicio garantesServicio = null;
	
	public GarantesListaControlador() {
		setCommandClass(GarantesBean.class);
		setCommandName("garante");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
			
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		GarantesBean garante = (GarantesBean) command;
		List garantes =	garantesServicio.lista(tipoLista, garante);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(garantes);
		
		return new ModelAndView("originacion/garantesListaVista", "listaResultado",listaResultado);
	}

	public GarantesServicio getGarantesServicio() {
		return garantesServicio;
	}

	public void setGarantesServicio(GarantesServicio garantesServicio) {
		this.garantesServicio = garantesServicio;
	}

	

	
}
