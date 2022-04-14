package activos.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import activos.bean.TiposActivosBean;
import activos.servicio.TiposActivosServicio;

public class TiposActivosListaControlador extends AbstractCommandController{
	private TiposActivosServicio tiposActivosServicio = null;

	public TiposActivosListaControlador(){
		setCommandClass(TiposActivosBean.class);
		setCommandName("tiposActivosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		TiposActivosBean bean = (TiposActivosBean)command;
		List beanLis = tiposActivosServicio.lista(tipoLista, bean);
 
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(beanLis);
		
		return new ModelAndView("activos/tiposActivosListaVista", "listaResultado",listaResultado);
	}


	public void setTiposActivosServicio(TiposActivosServicio tiposActivosServicio) {
		this.tiposActivosServicio = tiposActivosServicio;
	}	
	
}
