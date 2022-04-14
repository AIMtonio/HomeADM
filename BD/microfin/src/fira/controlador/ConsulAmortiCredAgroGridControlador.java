package fira.controlador;

import herramientas.Utileria;

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
/**
 * Clase para listar las amortizaciones del Pagare de Creditos Agropecuarios
 * @see consultaCredAmortiAgroGridVista.htm
 */
public class ConsulAmortiCredAgroGridControlador extends AbstractCommandController {
	AmortizacionCreditoServicio	amortizacionCreditoServicio	= null;

	public ConsulAmortiCredAgroGridControlador() {
		setCommandClass(AmortizacionCreditoBean.class);
		setCommandName("amortizaCredBean");
	}

	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		String cobraSeguroCuota = (request.getParameter("cobraSeguroCuota"));
		String page = request.getParameter("page");
		String tipoPaginacion = "";
		List listaResultado = new ArrayList();

		if (page == null) {
			tipoPaginacion = "Completa";
		}

		if (tipoPaginacion.equalsIgnoreCase("Completa")) {

			AmortizacionCreditoBean amortizacionCredito = (AmortizacionCreditoBean) command;
			List<AmortizacionCreditoBean> amortizacionCreditoList = amortizacionCreditoServicio.listaAgroGrid(tipoLista, amortizacionCredito);

			PagedListHolder amortList = new PagedListHolder(amortizacionCreditoList);
			amortList.setPageSize(20);
			listaResultado.add(tipoLista);
			listaResultado.add(amortList);
			listaResultado.add(cobraSeguroCuota);

			request.getSession().setAttribute("ConsulAmortiCredGridControlador_amortizacionCreditoList", listaResultado);

		} else {
			PagedListHolder amortList = null;

			if (request.getSession().getAttribute("ConsulAmortiCredGridControlador_amortizacionCreditoList") != null) {
				listaResultado = (List) request.getSession().getAttribute("ConsulAmortiCredGridControlador_amortizacionCreditoList");
				amortList = (PagedListHolder) listaResultado.get(1);

				if ("next".equals(page)) {
					amortList.nextPage();
				} else if ("previous".equals(page)) {
					amortList.previousPage();
					amortList.getPage();
				}
			} else {
				amortList = null;
			}
			listaResultado.add(tipoLista);
			listaResultado.add(amortList);
			listaResultado.add(cobraSeguroCuota);
		}
		return new ModelAndView("fira/consultaCredAmortiAgroGridVista", "listaResultado", listaResultado);
	}

	public void setAmortizacionCreditoServicio(AmortizacionCreditoServicio amortizacionCreditoServicio) {
		this.amortizacionCreditoServicio = amortizacionCreditoServicio;
	}
}
