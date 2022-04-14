package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class ProteccionCreditoGridControlador extends AbstractCommandController {
	CreditosServicio creditosServicio = null;
	
	int listaResumenCliente		=7;  //Lista utilizada en el resumen del cliente
	int	listaProteccionCredito	=17; // Usada en la proteccion del credito y Ahorro del cliente	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public ProteccionCreditoGridControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		CreditosBean creditos = (CreditosBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
		List resumenCteInvList =creditosServicio.lista(tipoLista, creditos);

		List listaResultado = (List)new ArrayList();
        listaResultado.add(tipoLista);
        listaResultado.add(resumenCteInvList);
		return new ModelAndView("credito/proteccionCredGridVista", "resumCteCred", listaResultado);
		
		
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}
	
}
