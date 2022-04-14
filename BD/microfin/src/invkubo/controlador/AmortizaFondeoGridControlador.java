package invkubo.controlador;

import invkubo.bean.AmortizaFondeoBean;
import invkubo.servicio.AmortizaFondeoServicio;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class AmortizaFondeoGridControlador extends AbstractCommandController {

	AmortizaFondeoServicio amortizaFondeoServicio = null;
	
	public AmortizaFondeoGridControlador() {
		// TODO Auto-generated constructor stub
		
		setCommandClass(AmortizaFondeoBean.class);
		setCommandName("amortizacionesFon");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		
		AmortizaFondeoBean amortizaFondeo = (AmortizaFondeoBean) command;
		amortizaFondeoServicio.getAmortizaFondeoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		amortizaFondeo.setFondeoKuboID(request.getParameter("fondeoKuboID"));
	
		List calendarioInver = amortizaFondeoServicio.lista(tipoLista,amortizaFondeo);
		List listaResultado = (List)new ArrayList(); 
		listaResultado.add(calendarioInver);

		return new ModelAndView("invKubo/calendarioInversionistasGridVista", "listaResultado", listaResultado);
	}

	public void setAmortizaFondeoServicio(
			AmortizaFondeoServicio amortizaFondeoServicio) {
		this.amortizaFondeoServicio = amortizaFondeoServicio;
	}


}
