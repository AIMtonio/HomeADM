package credito.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.OblSolidariosPorSoliciBean;
import credito.bean.IntegraGruposBean;
import credito.servicio.OblSoliPorSoliciServicio;
import credito.servicio.IntegraGruposServicio;
import credito.servicio.ObligadosSolidariosServicio;

public class OblSolidPorSoliciGridControlador extends AbstractCommandController{
	
	OblSoliPorSoliciServicio oblSolidariosPorSoliciServicio = null;
	
public OblSolidPorSoliciGridControlador() {
	setCommandClass(OblSolidariosPorSoliciBean.class);
	setCommandName("oblSolidGrid");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {	
	
	OblSolidariosPorSoliciBean oblSolidDetalle = (OblSolidariosPorSoliciBean) command;
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	List oblSolidList = oblSolidariosPorSoliciServicio.lista(tipoLista, oblSolidDetalle);

	return new ModelAndView("credito/oblSolidariosPorSoliciGridVista", "listaResultado", oblSolidList);
}

public void setOblSoliPorSoliciServicio(
		OblSoliPorSoliciServicio oblSolidariosPorSoliciServicio) {
	this.oblSolidariosPorSoliciServicio = oblSolidariosPorSoliciServicio;
}



}

