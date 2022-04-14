package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.EsquemaautfirmaBean;
import originacion.servicio.EsquemaautfirmaServicio;



public class FirmasAutorizadasSolCredGridControlador extends AbstractCommandController{
	
	EsquemaautfirmaServicio esquemaautfirmaServicio  = null;
	
	public FirmasAutorizadasSolCredGridControlador() {
	setCommandClass(EsquemaautfirmaBean.class);
	setCommandName("esquemaautfirmaBean");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {	
	
	EsquemaautfirmaBean esquemaautfirmaBean = (EsquemaautfirmaBean) command;
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	List oragnoAutoList = esquemaautfirmaServicio.lista(tipoLista, esquemaautfirmaBean);
	List listaResultado = new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(oragnoAutoList);
	
	return new ModelAndView("originacion/firmasAutorizadasSolGridVista", "listaResultado", listaResultado);
}

public EsquemaautfirmaServicio getEsquemaautfirmaServicio() {
	return esquemaautfirmaServicio;
}

public void setEsquemaautfirmaServicio(
		EsquemaautfirmaServicio esquemaautfirmaServicio) {
	this.esquemaautfirmaServicio = esquemaautfirmaServicio;
}



}
