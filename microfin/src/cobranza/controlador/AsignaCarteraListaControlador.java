package cobranza.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cobranza.bean.AsignaCarteraBean;
import cobranza.servicio.AsignaCarteraServicio;

public class AsignaCarteraListaControlador  extends AbstractCommandController{
	private AsignaCarteraServicio asignaCarteraServicio = null;
	
	public AsignaCarteraListaControlador(){
		setCommandClass(AsignaCarteraBean.class);
		setCommandName("asignaCarteraBean");		
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		AsignaCarteraBean asignaCartera = (AsignaCarteraBean)command;
		List asignaciones = asignaCarteraServicio.lista(tipoLista, asignaCartera);

		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(asignaciones);
		
		return new ModelAndView("cobranza/asignaCarteraListaVista", "listaResultado",listaResultado);
	}

	public AsignaCarteraServicio getAsignaCarteraServicio() {
		return asignaCarteraServicio;
	}

	public void setAsignaCarteraServicio(AsignaCarteraServicio asignaCarteraServicio) {
		this.asignaCarteraServicio = asignaCarteraServicio;
	}
}
