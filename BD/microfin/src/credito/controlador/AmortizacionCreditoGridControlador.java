package credito.controlador;
import herramientas.Constantes;
import herramientas.Utileria;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.AmortizacionCreditoBean;
import credito.bean.CreditosBean;
import credito.servicio.AmortizacionCreditoServicio;
public class AmortizacionCreditoGridControlador extends AbstractCommandController{
		
	AmortizacionCreditoServicio amortizacionCreditoServicio = null;
	public AmortizacionCreditoGridControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {			
		CreditosBean amortizacionCredito = (CreditosBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List amortizacionCreditoList = amortizacionCreditoServicio.lista(tipoLista, amortizacionCredito);
	
		return new ModelAndView("credito/amortizacionCreditoGridVista", "listaResultado", amortizacionCreditoList);
	}

	public void setAmortizacionCreditoServicio(AmortizacionCreditoServicio amortizacionCreditoServicio) {
		this.amortizacionCreditoServicio = amortizacionCreditoServicio;
	}
}

