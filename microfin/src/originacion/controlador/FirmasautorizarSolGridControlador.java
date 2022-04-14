package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.OrganoAutorizaBean;
import originacion.servicio.OrganoAutorizaServicio;

public class FirmasautorizarSolGridControlador extends AbstractCommandController{
	
	OrganoAutorizaServicio organoAutorizaServicio  = null;
	public FirmasautorizarSolGridControlador() {
	setCommandClass(OrganoAutorizaBean.class);
	setCommandName("organoAutorizaBean");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {	
	
	OrganoAutorizaBean organoAutorizaBean = (OrganoAutorizaBean) command;
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	List oragnoAutoList = organoAutorizaServicio.listaOrganoAutoriza(tipoLista, organoAutorizaBean);
	List listaResultado = new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(oragnoAutoList);
	
	return new ModelAndView("originacion/firmasAutorizaSolGridVista", "listaResultado", listaResultado);
}


public void setOrganoAutorizaServicio(
		OrganoAutorizaServicio organoAutorizaServicio) {
	this.organoAutorizaServicio = organoAutorizaServicio;
}

}
