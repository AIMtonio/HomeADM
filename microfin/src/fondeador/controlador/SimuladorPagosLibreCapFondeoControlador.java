package fondeador.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fondeador.bean.AmortizaFondeoBean;
import fondeador.bean.CreditoFondeoBean;
import fondeador.servicio.CreditoFondeoServicio;

public class SimuladorPagosLibreCapFondeoControlador  extends AbstractCommandController {

	CreditoFondeoServicio creditoFondeoServicio = null;
	
	public SimuladorPagosLibreCapFondeoControlador() {
		setCommandClass(CreditoFondeoBean.class);
		setCommandName("creditoFondeoBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {	
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
					0;
		
		CreditoFondeoBean creditoFondeo = (CreditoFondeoBean) command;
		List LisCreditos = creditoFondeoServicio.simuladorAmortizacionesFondeo(tipoLista, creditoFondeo);
		List listaResultado = new ArrayList();
		
		AmortizaFondeoBean amortizaFondeoBean = new AmortizaFondeoBean();
		AmortizaFondeoBean amortizacionFonRet = new AmortizaFondeoBean();
		amortizaFondeoBean = (AmortizaFondeoBean) LisCreditos.get(LisCreditos.size()-1);
		
		amortizacionFonRet.setFechaVencim(amortizaFondeoBean.getFechaVencim());	
		
		listaResultado.add(tipoLista);
		listaResultado.add(amortizacionFonRet);
		listaResultado.add(LisCreditos);
		
		return new ModelAndView("fondeador/simuladorLibreCapPagosFondeoGridVista", "listaResultado", listaResultado);
	}

	public CreditoFondeoServicio getCreditoFondeoServicio() {
		return creditoFondeoServicio;
	}

	public void setCreditoFondeoServicio(CreditoFondeoServicio creditoFondeoServicio) {
		this.creditoFondeoServicio = creditoFondeoServicio;
	}	
}