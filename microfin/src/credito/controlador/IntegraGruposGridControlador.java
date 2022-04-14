package credito.controlador;

import gestionComecial.bean.OrganigramaBean;
import gestionComecial.servicio.OrganigramaServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.IntegraGruposBean;
import credito.servicio.IntegraGruposServicio;

public class IntegraGruposGridControlador extends AbstractCommandController{
	
	IntegraGruposServicio integraGruposServicio = null;
public IntegraGruposGridControlador() {
	setCommandClass(IntegraGruposBean.class);
	setCommandName("integrantesGrid");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {	
	
	IntegraGruposBean integraGruposDetalle = (IntegraGruposBean) command;
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	int controlIntegrante =(request.getParameter("controlIntegrante")!=null)?
				Integer.parseInt(request.getParameter("controlIntegrante")):
			0;
	
	List gruposList = integraGruposServicio.lista(tipoLista, integraGruposDetalle);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlIntegrante);
	listaResultado.add(gruposList);

	return new ModelAndView("credito/integraGruposGridVista", "listaResultado", listaResultado);
}

public void setIntegraGruposServicio(IntegraGruposServicio integraGruposServicio) {
	this.integraGruposServicio = integraGruposServicio;
}


}

