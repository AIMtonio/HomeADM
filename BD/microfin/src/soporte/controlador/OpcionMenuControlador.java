package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.OpcionMenuBean;
import soporte.servicio.OpcionMenuServico;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class OpcionMenuControlador extends SimpleFormController {

	OpcionMenuServico opcionMenuServico = null;
	
	public OpcionMenuControlador() {
		setCommandClass(OpcionMenuBean.class);
		setCommandName("opciones");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		OpcionMenuBean opcionMenu = (OpcionMenuBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = opcionMenuServico.grabaTransaccion(tipoTransaccion, opcionMenu);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setOpcionMenuServico(OpcionMenuServico opcionMenuServico) {
		this.opcionMenuServico = opcionMenuServico;
	}

	

	

		
}


