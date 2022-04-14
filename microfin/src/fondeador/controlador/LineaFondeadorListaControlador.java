package fondeador.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fondeador.bean.LineaFondeadorBean;
import fondeador.servicio.LineaFondeadorServicio;

public class LineaFondeadorListaControlador extends AbstractCommandController {
	
	LineaFondeadorServicio lineaFondeadorServicio = null;
	
	public LineaFondeadorListaControlador() {
		setCommandClass(LineaFondeadorBean.class);
		setCommandName("lineaFond");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {

	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	LineaFondeadorBean lineaFondeador = (LineaFondeadorBean) command;
	
	List lineaFond =	lineaFondeadorServicio.lista(tipoLista, lineaFondeador);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(lineaFond);
			
	return new ModelAndView("fondeador/lineaFondeoListaVista", "listaResultado", listaResultado);
	}

	public void setLineaFondeadorServicio(
			LineaFondeadorServicio lineaFondeadorServicio) {
		this.lineaFondeadorServicio = lineaFondeadorServicio;
	}
	
}
