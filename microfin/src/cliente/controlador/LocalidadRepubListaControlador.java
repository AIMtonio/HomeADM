package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.LocalidadRepubBean;
import cliente.servicio.LocalidadRepubServicio;

public class LocalidadRepubListaControlador  extends AbstractCommandController{
	LocalidadRepubServicio localidadRepubServicio = null;
	
	public LocalidadRepubListaControlador() {
		setCommandClass(LocalidadRepubBean.class);
		setCommandName("localidades");
}
		
protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
	
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");
	
	LocalidadRepubBean localidad = (LocalidadRepubBean) command;
	List localidades =	localidadRepubServicio.lista(tipoLista, localidad);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(localidades);
			
	return new ModelAndView("cliente/localidadesRepubListaVista", "listaResultado", listaResultado);
	}

public LocalidadRepubServicio getLocalidadRepubServicio() {
	return localidadRepubServicio;
}

public void setLocalidadRepubServicio(
		LocalidadRepubServicio localidadRepubServicio) {
	this.localidadRepubServicio = localidadRepubServicio;
}

}
