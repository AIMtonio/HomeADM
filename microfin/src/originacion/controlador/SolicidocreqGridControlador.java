package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.SolicidocreqBean;
import originacion.servicio.SolicidocreqServicio;


public class SolicidocreqGridControlador extends AbstractCommandController{
	
	SolicidocreqServicio solicidocreqServicio  = null;
	
public SolicidocreqGridControlador() {
	setCommandClass(SolicidocreqBean.class);
	setCommandName("solicidocreqBean");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {	
	
	SolicidocreqBean solicidocreqBean = (SolicidocreqBean) command;
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	List documentosReqList = solicidocreqServicio.lista(tipoLista, solicidocreqBean);
	List listaResultado = new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(documentosReqList);
	
	return new ModelAndView("originacion/documentosReqGridVista", "listaResultado", listaResultado);
}

public void setSolicidocreqServicio(SolicidocreqServicio solicidocreqServicio) {
	this.solicidocreqServicio = solicidocreqServicio;
}


}

