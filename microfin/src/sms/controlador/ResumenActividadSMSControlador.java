package sms.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import sms.bean.ResumenActividadSMSBean;
import sms.servicio.ResumenActividadSMSServicio;


public class ResumenActividadSMSControlador extends SimpleFormController {

	ResumenActividadSMSServicio resumenActividadSMSServicio = null;

	public ResumenActividadSMSControlador(){
		setCommandClass(ResumenActividadSMSBean.class);
		setCommandName("resumenActividadSMS");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		ResumenActividadSMSBean resumenActividadSMSBean = (ResumenActividadSMSBean) command;
		resumenActividadSMSServicio.getResumenActividadSMSDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
					
		MensajeTransaccionBean mensaje = null;
	//	mensaje = resumenActividadSMSServicio.grabaTransaccion(tipoTransaccion,resumenActividadSMSBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	
	
	public void setResumenActividadSMSServicio(
			ResumenActividadSMSServicio resumenActividadSMSServicio) {
		this.resumenActividadSMSServicio = resumenActividadSMSServicio;
	}

} 


