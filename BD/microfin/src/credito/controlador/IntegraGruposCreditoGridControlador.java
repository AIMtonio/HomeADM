package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.IntegraGruposBean;
import credito.servicio.IntegraGruposServicio;

public class IntegraGruposCreditoGridControlador extends AbstractCommandController{
	
	IntegraGruposServicio integraGruposServicio = null;
public IntegraGruposCreditoGridControlador() {
	setCommandClass(IntegraGruposBean.class);
	setCommandName("integrantesGrid");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {	
	
	IntegraGruposBean integraGruposDetalle = (IntegraGruposBean) command;
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	List gruposList = integraGruposServicio.lista(tipoLista, integraGruposDetalle);
	List listaResultado = new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(gruposList);
	
	return new ModelAndView("credito/integraGruposCreditoGridVista", "listaResultado", listaResultado);
}

public void setIntegraGruposServicio(IntegraGruposServicio integraGruposServicio) {
	this.integraGruposServicio = integraGruposServicio;
}


}

