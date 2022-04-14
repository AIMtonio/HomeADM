package fondeador.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fondeador.bean.CreditoFondeoBean;
import fondeador.servicio.CreditoFondeoServicio;

public class CreditoFondeoControlador extends SimpleFormController {

	CreditoFondeoServicio creditoFondeoServicio = null;
	
	public CreditoFondeoControlador() {
		setCommandClass(CreditoFondeoBean.class);
		setCommandName("creditoFondeoBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		creditoFondeoServicio.getCreditoFondeoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		CreditoFondeoBean creditoFondeoBean = (CreditoFondeoBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = creditoFondeoServicio.grabaTransaccion(tipoTransaccion, creditoFondeoBean);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CreditoFondeoServicio getCreditoFondeoServicio() {
		return creditoFondeoServicio;
	}

	public void setCreditoFondeoServicio(CreditoFondeoServicio creditoFondeoServicio) {
		this.creditoFondeoServicio = creditoFondeoServicio;
	}
}
