package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.AmortizacionCreditoBean;
import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class SimuladorPagosLibreCapControlador  extends AbstractCommandController {

	CreditosServicio creditosServicio = null;
	
	public SimuladorPagosLibreCapControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?Integer.parseInt(request.getParameter("tipoLista")):0;
		String cobraAccesorios = request.getParameter("cobraAccesorios");
		
		CreditosBean creditosBean = (CreditosBean) command;
		List<AmortizacionCreditoBean> LisCreditos = creditosServicio.simuladorAmortizaciones(tipoLista, creditosBean);
		List listaResultado = new ArrayList();
		
		AmortizacionCreditoBean amortizacionCreditoBean = new AmortizacionCreditoBean();
		AmortizacionCreditoBean amortizacionCreditoRet = new AmortizacionCreditoBean();
		amortizacionCreditoBean = (AmortizacionCreditoBean) LisCreditos.get(LisCreditos.size()-1);
		
		amortizacionCreditoRet.setFechaVencim(amortizacionCreditoBean.getFechaVencim());	
		
		listaResultado.add(tipoLista);
		listaResultado.add(amortizacionCreditoRet);
		listaResultado.add(LisCreditos);
	     if(LisCreditos!=null && LisCreditos.size()>=1){
	    	 String numeroError=LisCreditos.get(0).getCodigoError();
	    	 String messError=LisCreditos.get(0).getMensajeError();
	    	 String cobraSeguroCuota = LisCreditos.get(0).getCobraSeguroCuota();
		     listaResultado.add(numeroError);
		     listaResultado.add(messError);
		     listaResultado.add(cobraSeguroCuota);
		     listaResultado.add(cobraAccesorios);
	     } else {
	    	 listaResultado.add("999");
		     listaResultado.add("Ocurrio un Error al Simular.");
	     }
	        
		return new ModelAndView("credito/simuladorLibreCapPagosGridVista", "listaResultado", listaResultado);
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}
	
}