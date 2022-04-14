package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.IndiceNaPreConsumidorBean;
import soporte.servicio.IndiceNaPreConsumidorServicio;

public class IndiceNaPreConsumidorListaControlador extends AbstractCommandController{

	IndiceNaPreConsumidorServicio indiceNaPreConsumidorServicio = null;
	
	public IndiceNaPreConsumidorListaControlador() {
		setCommandClass(IndiceNaPreConsumidorBean.class);
		setCommandName("indice");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
	
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");
	
	
	IndiceNaPreConsumidorBean indice = (IndiceNaPreConsumidorBean) command;
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
		
	return new ModelAndView("soporte/indiceNaPreConsumidorListaVista", "listaResultado", listaResultado);
	}

	/* GETTER y SETTER */
	public IndiceNaPreConsumidorServicio getIndiceNaPreConsumidorServicio() {
		return indiceNaPreConsumidorServicio;
	}

	public void setIndiceNaPreConsumidorServicio(
			IndiceNaPreConsumidorServicio indiceNaPreConsumidorServicio) {
		this.indiceNaPreConsumidorServicio = indiceNaPreConsumidorServicio;
	}

}