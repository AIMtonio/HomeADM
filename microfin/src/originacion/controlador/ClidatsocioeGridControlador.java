package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.ClidatsocioeBean;
import originacion.servicio.ClidatsocioeServicio;

public class ClidatsocioeGridControlador extends AbstractCommandController{
	
	ClidatsocioeServicio clidatsocioeServicio  = null;
public ClidatsocioeGridControlador() {
	setCommandClass(ClidatsocioeBean.class);
	setCommandName("clidatsocioeBean");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {	
	
	ClidatsocioeBean clidatsocioeBean = (ClidatsocioeBean) command;
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	List gruposList = clidatsocioeServicio.lista(tipoLista, clidatsocioeBean);
	List listaResultado = new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(gruposList);
	
	return new ModelAndView("originacion/clidatsocioeGridVista", "listaResultado", listaResultado);
}

public void setClidatsocioeServicio(ClidatsocioeServicio clidatsocioeServicio) {
	this.clidatsocioeServicio = clidatsocioeServicio;
}


}

