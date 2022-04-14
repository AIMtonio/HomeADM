package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.ImpuestosBean;
import tesoreria.servicio.ImpuestosServicio;

public class ImpuestosListaControlador extends AbstractCommandController{

	ImpuestosServicio impuestosServicio = null;

	public ImpuestosListaControlador() {
			setCommandClass(ImpuestosBean.class);
			setCommandName("impuestosBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		ImpuestosBean impuestosBean = (ImpuestosBean) command;
		List impuestosList = impuestosServicio.lista(tipoLista, impuestosBean);

		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(impuestosList);

		return new ModelAndView("tesoreria/impuestosListaVista", "listaResultado", listaResultado);
	}

	public ImpuestosServicio getImpuestosServicio() {
		return impuestosServicio;
	}

	public void setImpuestosServicio(ImpuestosServicio impuestosServicio) {
		this.impuestosServicio = impuestosServicio;
	}
	
		
}

