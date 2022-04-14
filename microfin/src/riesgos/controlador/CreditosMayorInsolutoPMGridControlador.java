package riesgos.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosMayorInsolutoPMServicio;

public class CreditosMayorInsolutoPMGridControlador  extends AbstractCommandController{
	CreditosMayorInsolutoPMServicio creditosMayorInsolutoPMServicio = null;
	
	public CreditosMayorInsolutoPMGridControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("mayorSaldoInsolutoPM");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		UACIRiesgosBean riesgosBean = (UACIRiesgosBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List mayorSaldoInsolutoPM = creditosMayorInsolutoPMServicio.lista(tipoLista, riesgosBean);
	
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(mayorSaldoInsolutoPM);
		
		return new ModelAndView("riesgos/creditosMayorInsolutoPMGridVista", "listaResultado", listaResultado);
	
	}

	/* ****************** GETTER Y SETTERS *************************** */

	public CreditosMayorInsolutoPMServicio getCreditosMayorInsolutoPMServicio() {
		return creditosMayorInsolutoPMServicio;
	}

	public void setCreditosMayorInsolutoPMServicio(
			CreditosMayorInsolutoPMServicio creditosMayorInsolutoPMServicio) {
		this.creditosMayorInsolutoPMServicio = creditosMayorInsolutoPMServicio;
	}

	
}
