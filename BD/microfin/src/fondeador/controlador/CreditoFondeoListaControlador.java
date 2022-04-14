package fondeador.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fondeador.bean.CreditoFondeoBean;
import fondeador.servicio.CreditoFondeoServicio;

public class CreditoFondeoListaControlador extends AbstractCommandController {
	
	CreditoFondeoServicio creditoFondeoServicio = null;
	
	public CreditoFondeoListaControlador() {
		setCommandClass(CreditoFondeoBean.class);
		setCommandName("creditoFondeoBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {

	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	CreditoFondeoBean creditoFondeoBean = (CreditoFondeoBean) command;
	
	List lineaFond =	creditoFondeoServicio.lista(tipoLista, creditoFondeoBean);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(lineaFond);
			
	return new ModelAndView("fondeador/creditoFondeoListaVista", "listaResultado", listaResultado);
	}

	public CreditoFondeoServicio getCreditoFondeoServicio() {
		return creditoFondeoServicio;
	}

	public void setCreditoFondeoServicio(CreditoFondeoServicio creditoFondeoServicio) {
		this.creditoFondeoServicio = creditoFondeoServicio;
	}

	
	
}
