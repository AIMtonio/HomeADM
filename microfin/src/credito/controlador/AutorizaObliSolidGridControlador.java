package credito.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.AutorizaObliSolidBean;
import credito.servicio.AutorizaObliSolidServicio;

public class AutorizaObliSolidGridControlador extends AbstractCommandController{
	
	AutorizaObliSolidServicio autorizaObliSolidServicio = null;
public AutorizaObliSolidGridControlador() {
	setCommandClass(AutorizaObliSolidBean.class);
	setCommandName("autorizaGrid");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {	
	
	AutorizaObliSolidBean avalesDetalle = (AutorizaObliSolidBean) command;
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	List avalesList = autorizaObliSolidServicio.lista(tipoLista, avalesDetalle);

	return new ModelAndView("credito/autorizaObliSolidGridVista", "listaResultado", avalesList);
}

public void setAutorizaObliSolidServicio(
		AutorizaObliSolidServicio autorizaObliSolidServicio) {
	this.autorizaObliSolidServicio = autorizaObliSolidServicio;
}




}

