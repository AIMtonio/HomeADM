package tarjetas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.TipoTarjetaDebBean;
import tarjetas.servicio.TipoTarjetaDebServicio;


public class TipoTarjetaDebListaControlador extends AbstractCommandController{
	
	TipoTarjetaDebServicio tipoTarjetaDebServicio = null;
	
	public TipoTarjetaDebListaControlador() {
		setCommandClass(TipoTarjetaDebBean.class);
		setCommandName("tipoTarjetaDebBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	TipoTarjetaDebBean tipoTarjetaDebBean = (TipoTarjetaDebBean) command;
	List listaTiposTarjetas =	tipoTarjetaDebServicio.lista(tipoLista, tipoTarjetaDebBean);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(listaTiposTarjetas);
			
	return new ModelAndView("tarjetas/tiposTarjetaDebListaVista", "listaResultado", listaResultado);
	}

	
	//--------------setter------------------
	public void setTipoTarjetaDebServicio(
			TipoTarjetaDebServicio tipoTarjetaDebServicio) {
		this.tipoTarjetaDebServicio = tipoTarjetaDebServicio;
	}
	
	

}
