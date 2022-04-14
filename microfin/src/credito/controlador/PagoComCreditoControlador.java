package credito.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class PagoComCreditoControlador extends SimpleFormController{

	CreditosServicio creditosServicio = null;
	
	public PagoComCreditoControlador () {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
				
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		CreditosBean creditos = (CreditosBean) command;
		MensajeTransaccionBean mensaje = null;
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		creditos.setCicloGrupo(request.getParameter("cicloID"));
		mensaje = creditosServicio.grabaTransaccion(tipoTransaccion,0, creditos,request);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}
		
}
