package credito.controlador;

import herramientas.Utileria;
import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class ResumenCteCredGridControlador  extends AbstractCommandController {
	CreditosServicio creditosServicio = null;
	

	public ResumenCteCredGridControlador() {
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
				
		return new ModelAndView("credito/resumenCteCredGridVista", "resumCteCred", resumenCteInvList);
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}
	
}
