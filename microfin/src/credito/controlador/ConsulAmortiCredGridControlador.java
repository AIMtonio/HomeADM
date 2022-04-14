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
import credito.servicio.AmortizacionCreditoServicio;

public class ConsulAmortiCredGridControlador extends AbstractCommandController {

	AmortizacionCreditoServicio amortizacionCreditoServicio = null;

	public ConsulAmortiCredGridControlador() {
		// TODO Auto-generated constructor stub

		setCommandClass(AmortizacionCreditoBean.class);
		setCommandName("amortizaCredBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		int tipoLista = (request.getParameter("tipoLista") != null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		String cobraSeguroCuota = (request.getParameter("cobraSeguroCuota"));
		String cobraAccesorios = request.getParameter("cobraAccesorios");
		String page = request.getParameter("page");
		String tipoPaginacion = "";
		List listaResultado = new ArrayList();

		if (page == null) {
			tipoPaginacion = "Completa";
		}

		if (tipoPaginacion.equalsIgnoreCase("Completa")) {

			AmortizacionCreditoBean amortizacionCredito = (AmortizacionCreditoBean) command;
			List<AmortizacionCreditoBean> amortizacionCreditoList = amortizacionCreditoServicio.listaGrid(tipoLista, amortizacionCredito);

			PagedListHolder amortList = new PagedListHolder(amortizacionCreditoList);
			amortList.setPageSize(20);
			listaResultado.add(tipoLista);
			listaResultado.add(amortList);
			listaResultado.add(cobraSeguroCuota);
			listaResultado.add(cobraAccesorios);

			request.getSession().setAttribute("ConsulAmortiCredGridControlador_amortizacionCreditoList", listaResultado);

		} else {
			PagedListHolder amortList = null;

			if (request.getSession().getAttribute("ConsulAmortiCredGridControlador_amortizacionCreditoList") != null) {
				listaResultado = (List) request.getSession().getAttribute("ConsulAmortiCredGridControlador_amortizacionCreditoList");
				amortList = (PagedListHolder) listaResultado.get(1);

				if ("next".equals(page)) {
					amortList.nextPage();
				}
				else if ("previous".equals(page)) {
					amortList.previousPage();
					amortList.getPage();
				}
			} else {
				amortList = null;
			}

			listaResultado.add(tipoLista);
			listaResultado.add(amortList);
			listaResultado.add(cobraSeguroCuota);
			listaResultado.add(cobraAccesorios);

		}
		return new ModelAndView("credito/consultaCredAmortiGridVista", "listaResultado", listaResultado);
	}

	public void setAmortizacionCreditoServicio(AmortizacionCreditoServicio amortizacionCreditoServicio) {
		this.amortizacionCreditoServicio = amortizacionCreditoServicio;
	}
}
