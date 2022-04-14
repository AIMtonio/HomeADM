package fondeador.controlador;

import java.util.ArrayList;
import java.util.List;

import fondeador.bean.AmortizaFondeoBean;
import fondeador.bean.CreditoFondMovsBean;
import fondeador.servicio.CreditoFondMovsServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


public class CreditoFondMovsGridControlador extends SimpleFormController {

	CreditoFondMovsServicio creditoFondMovsServicio = null;
	
	public CreditoFondMovsGridControlador() {
		setCommandClass(CreditoFondMovsBean.class);
		setCommandName("creditoFondMovsBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		CreditoFondMovsBean creditoFondMovsBean = (CreditoFondMovsBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List creditosList = creditoFondMovsServicio.listaGrid(tipoLista, creditoFondMovsBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(creditosList);
		return new ModelAndView("fondeador/creditoFondMovsGridVista", "listaResultado", listaResultado);		
	}

	public CreditoFondMovsServicio getCreditoFondMovsServicio() {
		return creditoFondMovsServicio;
	}

	public void setCreditoFondMovsServicio(
			CreditoFondMovsServicio creditoFondMovsServicio) {
		this.creditoFondMovsServicio = creditoFondMovsServicio;
	}		
}

