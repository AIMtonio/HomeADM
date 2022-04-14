package fira.controlador;

import fira.bean.MinistracionCredAgroBean;
import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;
/**
 * Clase para la pantalla del pagare de crédito, se encarga de grabar las amortizaciones finales
 * @see pagareCreditoAgro.htm
 */
public class PagareCredAgroControlador extends SimpleFormController {
	CreditosServicio	creditosServicio	= null;

	public PagareCredAgroControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditos");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		CreditosBean creditos = (CreditosBean) command;
		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		int tipoActualizacion = Utileria.convierteEntero(request.getParameter("tipoActualizacion"));
		MensajeTransaccionBean mensaje = null;
		MinistracionCredAgroBean ministraciones=null;
		mensaje = creditosServicio.grabaTransaccionAgro(tipoTransaccion, tipoActualizacion, creditos,ministraciones, request);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

}
