package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;


public class PagoComCreditoGridControlador extends AbstractCommandController {
	CreditosServicio creditosServicio = null;
	

	public PagoComCreditoGridControlador(){
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		
		CreditosBean creditosBean = (CreditosBean)command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		
		List listaResultado = new ArrayList();
		List listaCreditos = creditosServicio.listaGrid(tipoLista,creditosBean);			
		
		 listaResultado.add(tipoLista);
		 listaResultado.add(listaCreditos);
		
		return new ModelAndView("credito/pagoComCreditosGridVista", "listaResultado", listaResultado);
	}
	
	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	
	

}
