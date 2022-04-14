package crowdfunding.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import crowdfunding.bean.AmortizaFondeoCRWBean;
import crowdfunding.servicio.AmortizaFondeoCRWServicio;


public class AmortizaFondeoCRWGridControlador extends AbstractCommandController {

	AmortizaFondeoCRWServicio amortizaFondeoCRWServicio = null;

	public AmortizaFondeoCRWGridControlador() {
		// TODO Auto-generated constructor stub
		setCommandClass(AmortizaFondeoCRWBean.class);
		setCommandName("amortizacionesFon");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		AmortizaFondeoCRWBean amortizaFondeo = (AmortizaFondeoCRWBean) command;
		amortizaFondeoCRWServicio.getAmortizaFondeoCRWDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		amortizaFondeo.setSolFondeoID(request.getParameter("solFondeoID"));

		List calendarioInver = amortizaFondeoCRWServicio.lista(tipoLista,amortizaFondeo);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(calendarioInver);

		return new ModelAndView("crowdfunding/calendarioInversionistasGridVista", "listaResultado", listaResultado);
	}

	public AmortizaFondeoCRWServicio getAmortizaFondeoCRWServicio() {
		return amortizaFondeoCRWServicio;
	}

	public void setAmortizaFondeoCRWServicio(
			AmortizaFondeoCRWServicio amortizaFondeoCRWServicio) {
		this.amortizaFondeoCRWServicio = amortizaFondeoCRWServicio;
	}

}