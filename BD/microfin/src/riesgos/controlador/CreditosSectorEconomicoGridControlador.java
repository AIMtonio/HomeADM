package riesgos.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosSectorEconomicoServicio;

public class CreditosSectorEconomicoGridControlador extends AbstractCommandController{
	CreditosSectorEconomicoServicio creditosSectorEconomicoServicio = null;
	
	public CreditosSectorEconomicoGridControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("creditosSectorEconomico");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		UACIRiesgosBean riesgosBean = (UACIRiesgosBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaSectorEconomico = creditosSectorEconomicoServicio.lista(tipoLista, riesgosBean);
	
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(listaSectorEconomico);
		
		return new ModelAndView("riesgos/creditosSectorEconomicoGridVista", "listaResultado", listaResultado);
	
	}
	/* ****************** GETTER Y SETTERS *************************** */

	public CreditosSectorEconomicoServicio getCreditosSectorEconomicoServicio() {
		return creditosSectorEconomicoServicio;
	}

	public void setCreditosSectorEconomicoServicio(
			CreditosSectorEconomicoServicio creditosSectorEconomicoServicio) {
		this.creditosSectorEconomicoServicio = creditosSectorEconomicoServicio;
	}

}
