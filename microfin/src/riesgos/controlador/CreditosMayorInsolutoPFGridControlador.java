package riesgos.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosMayorInsolutoPFServicio;

public class CreditosMayorInsolutoPFGridControlador extends AbstractCommandController{
	CreditosMayorInsolutoPFServicio creditosMayorInsolutoPFServicio = null;
	
	public CreditosMayorInsolutoPFGridControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("mayorSaldoInsolutoPF");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		UACIRiesgosBean riesgosBean = (UACIRiesgosBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List mayorSaldoInsolutoPF = creditosMayorInsolutoPFServicio.lista(tipoLista, riesgosBean);
	
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(mayorSaldoInsolutoPF);
		
		return new ModelAndView("riesgos/creditosMayorInsolutoPFGridVista", "listaResultado", listaResultado);
	
	}

	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosMayorInsolutoPFServicio getCreditosMayorInsolutoPFServicio() {
		return creditosMayorInsolutoPFServicio;
	}

	public void setCreditosMayorInsolutoPFServicio(
			CreditosMayorInsolutoPFServicio creditosMayorInsolutoPFServicio) {
		this.creditosMayorInsolutoPFServicio = creditosMayorInsolutoPFServicio;
	}
	
}
