package ventanilla.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.ChequesEmitidosBean;
import ventanilla.servicio.ChequesEmitidosServicio;

public class ChequesEmitidosListaControlador extends AbstractCommandController {
	
	ChequesEmitidosServicio chequesEmitidosServicio = null;
	
	public ChequesEmitidosListaControlador() {
		setCommandClass(ChequesEmitidosBean.class);		
		setCommandName("cancelacionCheques");
		
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		ChequesEmitidosBean chequesEmitidosBean = (ChequesEmitidosBean) command;		
		List chequesLis =	chequesEmitidosServicio.listaChequesEmitidos(tipoLista, chequesEmitidosBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(chequesLis);
		
		return new ModelAndView("ventanilla/chequesEmitidosListaVista", "listaResultado",listaResultado);
	}

	public ChequesEmitidosServicio getChequesEmitidosServicio() {
		return chequesEmitidosServicio;
	}

	public void setChequesEmitidosServicio(
			ChequesEmitidosServicio chequesEmitidosServicio) {
		this.chequesEmitidosServicio = chequesEmitidosServicio;
	}

	
	
	
	
}


