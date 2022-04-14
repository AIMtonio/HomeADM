package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.ClasificCreditoBean;
import credito.servicio.ClasificCreditoServicio;

public class ClasificCreditoControlador extends SimpleFormController {

	ClasificCreditoServicio clasificCreditoServicio = null;

	public ClasificCreditoControlador(){
		setCommandClass(ClasificCreditoBean.class);
		setCommandName("clasificCreditoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		ClasificCreditoBean clasificCreditoBean = (ClasificCreditoBean) command;

		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = clasificCreditoServicio.grabaTransaccion(tipoTransaccion, clasificCreditoBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setClasificCreditoServicio(ClasificCreditoServicio clasificCreditoServicio){
                    this.clasificCreditoServicio = clasificCreditoServicio;
	}
} 
