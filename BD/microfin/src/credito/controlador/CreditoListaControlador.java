package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class CreditoListaControlador extends AbstractCommandController {

CreditosServicio creditosServicio = null;
	
	public CreditoListaControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditos");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {

	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	CreditosBean credito = (CreditosBean) command;
	
	List creditos =	creditosServicio.lista(tipoLista, credito);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(creditos);
			
	return new ModelAndView("credito/creditoListaVista", "listaResultado", listaResultado);
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	

}
