package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class DesembolsoCreditoControlador extends SimpleFormController {

	CreditosServicio creditosServicio = null;
	
	public DesembolsoCreditoControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditos");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;

	int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
						Integer.parseInt(request.getParameter("tipoActualizacion")):
						0;		
		//Seteamos a los Parametros de Auditoria el Nombrel del Programa o Recurso
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	
		CreditosBean creditos = (CreditosBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = creditosServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion, creditos,request);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	

		
}

