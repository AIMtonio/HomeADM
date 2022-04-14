package cobranza.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cobranza.bean.GestoresCobranzaBean;
import cobranza.servicio.GestoresCobranzaServicio;

public class GestoresCobranzaListaControlador extends AbstractCommandController{
	private GestoresCobranzaServicio gestoresCobranzaServicio= null;
	
	public GestoresCobranzaListaControlador(){
		setCommandClass(GestoresCobranzaBean.class);
		setCommandName("gestoresCobranza");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		GestoresCobranzaBean gestor = (GestoresCobranzaBean)command;
		List gestores = gestoresCobranzaServicio.lista(tipoLista, gestor);
 
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(gestores);
		
		return new ModelAndView("cobranza/gestoresCobranzaListaVista", "listaResultado",listaResultado);
	}

	public void setGestoresCobranzaServicio(GestoresCobranzaServicio gestoresCobranzaServicio) {
		this.gestoresCobranzaServicio = gestoresCobranzaServicio;
	}
}