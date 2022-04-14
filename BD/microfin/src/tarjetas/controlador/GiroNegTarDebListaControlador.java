package tarjetas.controlador;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.GiroNegocioTarDebBean;
import tarjetas.servicio.GiroNegocioTarDebServicio;

public class GiroNegTarDebListaControlador extends AbstractCommandController{
	
	GiroNegocioTarDebServicio giroNegocioTarDebServicio = null;
	
	public GiroNegTarDebListaControlador() {
		setCommandClass(GiroNegocioTarDebBean.class);
		setCommandName("giroNegocioTarDebBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	GiroNegocioTarDebBean giroNegocioTarDebBean = (GiroNegocioTarDebBean) command;
	List listaGiroNegocio =	giroNegocioTarDebServicio.lista(tipoLista, giroNegocioTarDebBean);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(listaGiroNegocio);
			
	return new ModelAndView("tarjetas/giroNegTarDebListaVista", "listaResultado", listaResultado);
	}
	
	//--------------setter------------------
	public void setGiroNegocioTarDebServicio(
			GiroNegocioTarDebServicio giroNegocioTarDebServicio) {
		this.giroNegocioTarDebServicio = giroNegocioTarDebServicio;
	}


	
	

}
