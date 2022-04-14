package cliente.controlador;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import cliente.bean.SucursalesBean;
import cliente.servicio.SucursalesServicio;


public class SucursalesListaControlador extends AbstractCommandController{

	
	SucursalesServicio sucursalesServicio = null;
		
	public SucursalesListaControlador() {
			setCommandClass(SucursalesBean.class);
			setCommandName("sucursal");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");
	
	SucursalesBean sucursal = (SucursalesBean) command;
	List sucursales =	sucursalesServicio.lista(tipoLista, sucursal);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(sucursales);
		
	return new ModelAndView("cliente/sucursalesListaVista", "listaResultado", listaResultado);
	}

	public void setSucursalesServicio(SucursalesServicio sucursalesServicio) {
		this.sucursalesServicio = sucursalesServicio;
	}	
	
}
