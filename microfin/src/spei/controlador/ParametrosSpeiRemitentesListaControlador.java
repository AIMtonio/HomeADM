package spei.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import spei.bean.ParametrosSpeiBean;
import spei.servicio.ParametrosSpeiServicio;



public class ParametrosSpeiRemitentesListaControlador extends AbstractCommandController{
	

ParametrosSpeiServicio parametrosSpeiServicio = null;

public ParametrosSpeiRemitentesListaControlador() {
	setCommandClass(ParametrosSpeiBean.class);
	setCommandName("parametrosSpeiBean");
}

protected ModelAndView handle(HttpServletRequest request,
		  HttpServletResponse response,
		  Object command,
		  BindException errors) throws Exception {

	int tipoLista =(request.getParameter("tipoLista")!=null)?
	Integer.parseInt(request.getParameter("tipoLista")): 0;
	
	String controlID = request.getParameter("controlID");
	
	ParametrosSpeiBean parametrosSpeiBean = (ParametrosSpeiBean) command;
	List parametrosSpei = parametrosSpeiServicio.lista(tipoLista, parametrosSpeiBean);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(parametrosSpei);
	
	return new ModelAndView("spei/ParametrosSpeiRemitentesLista", "listaResultado",listaResultado);
}
	
public void setParametrosSpeiServicio(ParametrosSpeiServicio parametrosSpeiServicio) {
	this.parametrosSpeiServicio = parametrosSpeiServicio;
}



}
