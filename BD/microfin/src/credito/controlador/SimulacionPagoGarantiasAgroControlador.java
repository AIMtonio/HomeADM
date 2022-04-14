package credito.controlador;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;
import fira.bean.MinistracionCredAgroBean;
import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class SimulacionPagoGarantiasAgroControlador extends AbstractCommandController {

	CreditosServicio creditosServicio = null;
	
	public SimulacionPagoGarantiasAgroControlador(){
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}

	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		CreditosBean creditosBean = (CreditosBean) command;
		MinistracionCredAgroBean ministracionCredAgroBean = null;
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
		int tipoActualizacion = (request.getParameter("tipoActualizacion") != null) ? Integer.parseInt(request.getParameter("tipoActualizacion")) : 0;
		
		
		MensajeTransaccionBean mensajeTransaccionBean = null;
		mensajeTransaccionBean = creditosServicio.grabaTransaccionAgro(tipoTransaccion, tipoActualizacion, creditosBean, ministracionCredAgroBean, request);
		
		if(mensajeTransaccionBean == null){
			mensajeTransaccionBean = new MensajeTransaccionBean();
		}
		
		Utileria.respuestaJsonTransaccion(mensajeTransaccionBean, response);
		
		return null;
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}
}
