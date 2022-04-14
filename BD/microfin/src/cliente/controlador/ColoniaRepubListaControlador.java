package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ColoniaRepubBean;
import cliente.servicio.ColoniaRepubServicio;

public class ColoniaRepubListaControlador  extends AbstractCommandController{
	ColoniaRepubServicio coloniaRepubServicio = null;
	
	public ColoniaRepubListaControlador() {
		setCommandClass(ColoniaRepubBean.class);
		setCommandName("colonia");
}
		
protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
	
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");
	
	ColoniaRepubBean colonia = (ColoniaRepubBean) command;
	List colonias =	coloniaRepubServicio.lista(tipoLista, colonia);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(colonias);
			
	return new ModelAndView("cliente/coloniasRepubListaVista", "listaResultado", listaResultado);
	}

public ColoniaRepubServicio getColoniaRepubServicio() {
	return coloniaRepubServicio;
}

public void setColoniaRepubServicio(ColoniaRepubServicio coloniaRepubServicio) {
	this.coloniaRepubServicio = coloniaRepubServicio;
}

}
