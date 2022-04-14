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

public class AsignaCreditosGridControlador extends AbstractCommandController {
	AsignaCarteraServicio asignaCarteraServicio = null;
	
	public AsignaCreditosGridControlador(){
		setCommandClass(AsignaCarteraBean.class);
		setCommandName("asignaCarteraBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		
		AsignaCarteraBean asignaCartera = (AsignaCarteraBean)command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List listaResultado = new ArrayList();
		List listaCreditos = asignaCarteraServicio.listaGrid(tipoLista,asignaCartera);
		
		 listaResultado.add(tipoLista);
		 listaResultado.add(listaCreditos);
		
		return new ModelAndView("cobranza/asignaCreditosGridVista", "listaResultado", listaResultado);
	}
	
	public void setAsignaCarteraServicio(AsignaCarteraServicio asignaCarteraServicio) {
		this.asignaCarteraServicio = asignaCarteraServicio;
	}

}
