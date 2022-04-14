package credito.controlador;

import general.bean.MensajeTransaccionBean;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import credito.bean.ReestrucCreditoBean;
import credito.servicio.ReestrucCreditoServicio;

public class ReestrucCreditoControlador  extends SimpleFormController {
	ReestrucCreditoServicio reestrucCreditoServicio= null;
	
	public ReestrucCreditoControlador() {
		setCommandClass(ReestrucCreditoBean.class);
		setCommandName("reestrucCredito");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		reestrucCreditoServicio.getReestrucCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
								
		ReestrucCreditoBean reestrucCreditoBean = (ReestrucCreditoBean) command;

		CreditosBean creditosBean = (CreditosBean) request;
		
		MensajeTransaccionBean mensaje = null;
		
		//mensaje = reestrucCreditoServicio.grabaTransaccion(tipoTransaccion, creditosBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ReestrucCreditoServicio getReestrucCreditoServicio() {
		return reestrucCreditoServicio;
	}

	public void setReestrucCreditoServicio(
			ReestrucCreditoServicio reestrucCreditoServicio) {
		this.reestrucCreditoServicio = reestrucCreditoServicio;
	}		
}

