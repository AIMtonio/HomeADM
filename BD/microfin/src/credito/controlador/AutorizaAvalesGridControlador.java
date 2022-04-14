package credito.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.AutorizaAvalesBean;
import credito.servicio.AutorizaAvalesServicio;

public class AutorizaAvalesGridControlador extends AbstractCommandController{
	
	AutorizaAvalesServicio autorizaAvalesServicio = null;
public AutorizaAvalesGridControlador() {
	setCommandClass(AutorizaAvalesBean.class);
	setCommandName("autorizaGrid");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {	
	
	AutorizaAvalesBean avalesDetalle = (AutorizaAvalesBean) command;
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	List avalesList = autorizaAvalesServicio.lista(tipoLista, avalesDetalle);

	return new ModelAndView("credito/autorizaAvalesGridVista", "listaResultado", avalesList);
}

public void setAutorizaAvalesServicio(
		AutorizaAvalesServicio autorizaAvalesServicio) {
	this.autorizaAvalesServicio = autorizaAvalesServicio;
}




}

