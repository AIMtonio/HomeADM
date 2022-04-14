package inversiones.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import inversiones.servicio.TipoInversionesServicio;
import inversiones.bean.TipoInversionBean;

public class TipoInversionesListaControlador extends AbstractCommandController{
	
	public TipoInversionesListaControlador(){
		setCommandClass(TipoInversionBean.class);
		setCommandName("tipoInversionBean");
	}
	
	TipoInversionesServicio tipoInversionesServicio = null;
	
	
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		TipoInversionBean tipoInversionBean = (TipoInversionBean) command;
		List listaInversionBean = tipoInversionesServicio.lista(tipoLista, tipoInversionBean);
		List listaResultado = (List)new ArrayList();		
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaInversionBean);
	
		return new ModelAndView("inversiones/tipoInversionesListaVista", "listaResultado",listaResultado);

	}

	
	
	
	public void setTipoInversionesServicio(TipoInversionesServicio tipoInversionesServicio) {
		this.tipoInversionesServicio = tipoInversionesServicio;
	}
	
}
