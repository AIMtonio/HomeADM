package credito.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.AvalesPorSoliciBean;
import credito.bean.IntegraGruposBean;
import credito.servicio.AvalesPorSoliciServicio;
import credito.servicio.IntegraGruposServicio;

public class AvalesPorSoliciGridControlador extends AbstractCommandController{
	
	AvalesPorSoliciServicio avalesPorSoliciServicio = null;
public AvalesPorSoliciGridControlador() {
	setCommandClass(AvalesPorSoliciBean.class);
	setCommandName("avalesGrid");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {	
	
	AvalesPorSoliciBean avalesDetalle = (AvalesPorSoliciBean) command;
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	List avalesList = avalesPorSoliciServicio.lista(tipoLista, avalesDetalle);

	return new ModelAndView("credito/avalesPorSoliciGridVista", "listaResultado", avalesList);
}

public void setAvalesPorSoliciServicio(
		AvalesPorSoliciServicio avalesPorSoliciServicio) {
	this.avalesPorSoliciServicio = avalesPorSoliciServicio;
}




}

