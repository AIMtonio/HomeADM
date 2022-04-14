package gestionComecial.controlador;

import gestionComecial.bean.OrganigramaBean;
import gestionComecial.bean.OrganigramaDetalleBean;
import gestionComecial.servicio.OrganigramaServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class OrganigramaGridControlador extends AbstractCommandController{
	
OrganigramaServicio organigramaServicio = null;
public OrganigramaGridControlador() {
	setCommandClass(OrganigramaBean.class);
	setCommandName("organigramaGrid");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {	
	
	OrganigramaBean organigramaDetalle = (OrganigramaBean) command;
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	List listaResultado = new ArrayList();
	
	List organigramaList = organigramaServicio.lista(tipoLista, organigramaDetalle);
	listaResultado.add(organigramaList);
	
	return new ModelAndView("gestionComercial/organigramaGridVista", "listaResultado", listaResultado);
}

public void setOrganigramaServicio(OrganigramaServicio organigramaServicio) {
	this.organigramaServicio = organigramaServicio;
}
}

