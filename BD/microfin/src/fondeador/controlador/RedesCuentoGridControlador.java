package fondeador.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import fondeador.bean.RedesCuentoBean;
import fondeador.servicio.RedesCuentoServicio;



public class RedesCuentoGridControlador extends AbstractCommandController{
	
	RedesCuentoServicio redesCuentoServicio = null;
public RedesCuentoGridControlador() {
	setCommandClass(RedesCuentoBean.class);
	setCommandName("CredFonAsigGrid");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {	
	
	RedesCuentoBean redesCuentoBean = (RedesCuentoBean) command;
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	List creditosList = redesCuentoServicio.lista(tipoLista, redesCuentoBean);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(creditosList);
	return new ModelAndView("fondeador/creditosRedesCuentoGridVista", "listaResultado", listaResultado);
}

public RedesCuentoServicio getRedesCuentoServicio() {
	return redesCuentoServicio;
}

public void setRedesCuentoServicio(RedesCuentoServicio redesCuentoServicio) {
	this.redesCuentoServicio = redesCuentoServicio;
}


}

