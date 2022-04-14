package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.ConsolidacionesBean;
import originacion.servicio.ConsolidacionesServicio;

public class ConsolidacionAgroListaControlador extends AbstractCommandController {
	
	public ConsolidacionAgroListaControlador() {
		setCommandClass(ConsolidacionesBean.class);
		setCommandName("consolidacionesBean");
	}

	ConsolidacionesServicio consolidacionesServicio = null;
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors)throws Exception{
	
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID=request.getParameter("controlID");
		
		ConsolidacionesBean consolidacionesBean = (ConsolidacionesBean) command;

		List<ConsolidacionesBean> listaConsolidacionesBean = consolidacionesServicio.lista(tipoLista, consolidacionesBean);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaConsolidacionesBean); 
		
		return new ModelAndView("originacion/consolidacionAgroListaVista", "listaResultado", listaResultado);	
	}

	public ConsolidacionesServicio getConsolidacionesServicio() {
		return consolidacionesServicio;
	}

	public void setConsolidacionesServicio(
			ConsolidacionesServicio consolidacionesServicio) {
		this.consolidacionesServicio = consolidacionesServicio;
	}

}
