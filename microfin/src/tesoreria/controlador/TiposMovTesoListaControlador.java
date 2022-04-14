package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

 
import tesoreria.bean.TiposMovTesoBean; 
import tesoreria.servicio.TiposMovTesoServicio;

public class TiposMovTesoListaControlador extends AbstractCommandController {


	TiposMovTesoServicio tiposMovTesoServicio = null;
		
	public TiposMovTesoListaControlador() {
			setCommandClass(TiposMovTesoBean.class);
			setCommandName("tiposMov");
	}
	  		
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");
	
	TiposMovTesoBean tiposMovTesoBean = (TiposMovTesoBean) command;
	List tiposMovConciliados = tiposMovTesoServicio.lista(tipoLista, tiposMovTesoBean);
 
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(tiposMovConciliados);
		
	return new ModelAndView("tesoreria/tiposMovTesoListaVista", "listaResultado", listaResultado);
	}
	
	public void setTiposMovTesoServicio(TiposMovTesoServicio tiposMovTesoServicio){
		this.tiposMovTesoServicio = tiposMovTesoServicio;
	}
}
