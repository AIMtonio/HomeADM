package fondeador.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import fondeador.bean.TiposLineaFondeaBean;
import fondeador.servicio.TiposLineaFondeaServicio;

public class TiposLineaFondeaListaControlador extends AbstractCommandController {
	
	TiposLineaFondeaServicio tiposLineaFondeaServicio = null;
	
	public TiposLineaFondeaListaControlador() {
		setCommandClass(TiposLineaFondeaBean.class);
		setCommandName("tiposLineaF");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {

	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	TiposLineaFondeaBean tiposLinFon = (TiposLineaFondeaBean) command;
	
	List tiposLinea =	tiposLineaFondeaServicio.lista(tipoLista, tiposLinFon);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(tiposLinea);
			
	return new ModelAndView("fondeador/tiposlineaFondeaListaVista", "listaResultado", listaResultado);
	}

	
	public void setTiposLineaFondeaServicio(
			TiposLineaFondeaServicio tiposLineaFondeaServicio) {
		this.tiposLineaFondeaServicio = tiposLineaFondeaServicio;
	}

	
}
