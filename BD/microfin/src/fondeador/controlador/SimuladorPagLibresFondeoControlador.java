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
import fondeador.servicio.CreditoFondeoServicio.Enum_Sim_PagAmortizacionesFondeo;

public class SimuladorPagLibresFondeoControlador  extends AbstractCommandController {

	CreditoFondeoServicio creditoFondeoServicio = null;
	
	public SimuladorPagLibresFondeoControlador() {
		setCommandClass(CreditoFondeoBean.class);
		setCommandName("creditoFondeoBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		int tipoLista = (request.getParameter("tipoLista") != null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		String montosCapital = request.getParameter("montosCapital");

		CreditoFondeoBean creditoFondeoBean = (CreditoFondeoBean) command;

		List LisCreditos = (List) new ArrayList();
		List listaResultado = (List) new ArrayList();

		switch (tipoLista) {
		case Enum_Sim_PagAmortizacionesFondeo.pagosLibresTasaFija:
			LisCreditos = creditoFondeoServicio.grabaListaSimPagLibFondeo(creditoFondeoBean, montosCapital);
			listaResultado.add(tipoLista);
			listaResultado.add(LisCreditos.get(0));
			listaResultado.add(LisCreditos.get(1));
			break;
		case Enum_Sim_PagAmortizacionesFondeo.pagosLibresTasaVar:
			LisCreditos = creditoFondeoServicio.grabaListaSimPagLibTasaVar(creditoFondeoBean, montosCapital);
			listaResultado.add(tipoLista);
			listaResultado.add(LisCreditos.get(0));
			listaResultado.add(LisCreditos.get(1));
			break;
		case Enum_Sim_PagAmortizacionesFondeo.pagLibFecCapTasaFija:

			LisCreditos = creditoFondeoServicio.grabaListaSimPagLibFecCap(creditoFondeoBean, montosCapital);
			listaResultado.add(tipoLista);
			listaResultado.add(LisCreditos.get(0));
			listaResultado.add(LisCreditos.get(1));
			break;
		case Enum_Sim_PagAmortizacionesFondeo.pagLibFecCapTasaVar:

			LisCreditos = creditoFondeoServicio.grabaListaSimPagLibFecCapTasVar(creditoFondeoBean, montosCapital);
			listaResultado.add(tipoLista);
			listaResultado.add(LisCreditos.get(0));
			listaResultado.add(LisCreditos.get(1));
			break;
		}

		return new ModelAndView("fondeador/simuladorPagosLibresFondeoGridVista", "listaResultado", listaResultado);

	}

	public CreditoFondeoServicio getCreditoFondeoServicio() {
		return creditoFondeoServicio;
	}

	public void setCreditoFondeoServicio(CreditoFondeoServicio creditoFondeoServicio) {
		this.creditoFondeoServicio = creditoFondeoServicio;
	}
}