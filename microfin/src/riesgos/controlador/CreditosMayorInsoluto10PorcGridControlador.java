package riesgos.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosMayorInsoluto10PorcServicio;

public class CreditosMayorInsoluto10PorcGridControlador extends AbstractCommandController{
	CreditosMayorInsoluto10PorcServicio creditosMayorInsoluto10PorcServicio = null;
	
	public CreditosMayorInsoluto10PorcGridControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("mayorSaldoInsoluto10Porc");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		UACIRiesgosBean riesgosBean = (UACIRiesgosBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List mayorSaldoInsoluto10Porc = creditosMayorInsoluto10PorcServicio.lista(tipoLista, riesgosBean);
	
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(mayorSaldoInsoluto10Porc);
		
		return new ModelAndView("riesgos/creditosMayorInsoluto10PorcGridVista", "listaResultado", listaResultado);
	
	}
	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosMayorInsoluto10PorcServicio getCreditosMayorInsoluto10PorcServicio() {
		return creditosMayorInsoluto10PorcServicio;
	}

	public void setCreditosMayorInsoluto10PorcServicio(
			CreditosMayorInsoluto10PorcServicio creditosMayorInsoluto10PorcServicio) {
		this.creditosMayorInsoluto10PorcServicio = creditosMayorInsoluto10PorcServicio;
	}
	
}
