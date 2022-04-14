package fondeador.controlador;

import java.util.ArrayList;
import java.util.List;

import fondeador.bean.AmortizaFondeoBean;
import fondeador.servicio.AmortizaFondeoServicio;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


public class AmortizaMovimientoGridControlador extends SimpleFormController {

	AmortizaFondeoServicio amortizaFondeoServicio = null;
	
	public AmortizaMovimientoGridControlador() {
		setCommandClass(AmortizaFondeoBean.class);
		setCommandName("amortizaFondeoBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		AmortizaFondeoBean amortizaFondeoBean = (AmortizaFondeoBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List creditosList = amortizaFondeoServicio.listaGrid(tipoLista, amortizaFondeoBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(creditosList);
		return new ModelAndView("fondeador/amortizaMovimientoGridVista", "listaResultado", listaResultado);
		//mensaje = creditosServicio.grabaTransaccion(tipoTransaccion, creditos);						
	}

	public AmortizaFondeoServicio getAmortizaFondeoServicio() {
		return amortizaFondeoServicio;
	}

	public void setAmortizaFondeoServicio(
			AmortizaFondeoServicio amortizaFondeoServicio) {
		this.amortizaFondeoServicio = amortizaFondeoServicio;
	}

	
		
}

