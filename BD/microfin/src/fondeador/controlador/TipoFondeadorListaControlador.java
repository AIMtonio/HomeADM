package fondeador.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fondeador.bean.TipoFondeadorBean;
import fondeador.servicio.TipoFondeadorServicio;

public class TipoFondeadorListaControlador extends AbstractCommandController{
	TipoFondeadorServicio tipoFondeadorServicio =  null;
	public TipoFondeadorListaControlador() {
		setCommandClass(TipoFondeadorBean.class);
		setCommandName("tipoFondeador");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");
	
	TipoFondeadorBean tipoFondeadorBean = (TipoFondeadorBean) command;
	
	List institutFon =	tipoFondeadorServicio.lista(tipoLista, tipoFondeadorBean);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(institutFon);
	
	return new ModelAndView("fondeador/tipoFondeadorListaVista", "listaResultado", listaResultado);
	}

	public TipoFondeadorServicio getTipoFondeadorServicio() {
		return tipoFondeadorServicio;
	}

	public void setTipoFondeadorServicio(TipoFondeadorServicio tipoFondeadorServicio) {
		this.tipoFondeadorServicio = tipoFondeadorServicio;
	}

}
