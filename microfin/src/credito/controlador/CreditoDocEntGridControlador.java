package credito.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

//import credito.bean.IntegraGruposBean;
import credito.bean.CreditoDocEntBean;
import credito.servicio.CreditoDocEntServicio;

public class CreditoDocEntGridControlador  extends AbstractCommandController {
			 
	CreditoDocEntServicio  creditoDocEntServicio= null;
public CreditoDocEntGridControlador() {
	setCommandClass(CreditoDocEntBean.class);
	setCommandName("documentosGrid");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {	
	
	CreditoDocEntBean docRecibidosDetalle = (CreditoDocEntBean) command;
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	List docEntregados = creditoDocEntServicio.lista(tipoLista, docRecibidosDetalle);
	

	return new ModelAndView("credito/creditoDocEntGridVista", "listaResultado", docEntregados);
}


//--- setter
public void setCreditoDocEntServicio(CreditoDocEntServicio creditoDocEntServicio) {
	this.creditoDocEntServicio = creditoDocEntServicio;
}

	

}
