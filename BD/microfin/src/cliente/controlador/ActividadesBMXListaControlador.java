package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ActividadesBMXBean;
import cliente.bean.ClienteBean;
import cliente.servicio.ActividadesServicio;
import cliente.servicio.ClienteServicio;

public class ActividadesBMXListaControlador extends AbstractCommandController{

	ActividadesServicio actividadesServicio = null;
	
	public ActividadesBMXListaControlador() {
		setCommandClass(ActividadesBMXBean.class);
		setCommandName("actividadBMX");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		ActividadesBMXBean actividad = (ActividadesBMXBean) command;
		List actividades =	actividadesServicio.lista(tipoLista, actividad);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(actividades);
		
		return new ModelAndView("cliente/actividadBMXListaVista", "listaResultado", listaResultado);
	}

	public void setActividadesServicio(ActividadesServicio actividadesServicio) {
		this.actividadesServicio = actividadesServicio;
	}

}
