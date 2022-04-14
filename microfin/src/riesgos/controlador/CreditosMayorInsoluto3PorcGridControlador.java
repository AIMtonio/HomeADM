package riesgos.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosMayorInsoluto3PorcServicio;

public class CreditosMayorInsoluto3PorcGridControlador extends AbstractCommandController{
	CreditosMayorInsoluto3PorcServicio creditosMayorInsoluto3PorcServicio = null;
	
	public CreditosMayorInsoluto3PorcGridControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("mayorSaldoInsoluto3Porc");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		UACIRiesgosBean riesgosBean = (UACIRiesgosBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List mayorSaldoInsoluto3Porc = creditosMayorInsoluto3PorcServicio.lista(tipoLista, riesgosBean);
	
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(mayorSaldoInsoluto3Porc);
		
		return new ModelAndView("riesgos/creditosMayorInsoluto3PorcGridVista", "listaResultado", listaResultado);
	
	}
	/* ****************** GETTER Y SETTERS *************************** */

	public CreditosMayorInsoluto3PorcServicio getCreditosMayorInsoluto3PorcServicio() {
		return creditosMayorInsoluto3PorcServicio;
	}

	public void setCreditosMayorInsoluto3PorcServicio(
			CreditosMayorInsoluto3PorcServicio creditosMayorInsoluto3PorcServicio) {
		this.creditosMayorInsoluto3PorcServicio = creditosMayorInsoluto3PorcServicio;
	}

}
