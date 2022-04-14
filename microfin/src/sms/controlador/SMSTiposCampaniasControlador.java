package sms.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import sms.bean.SMSTiposCampaniasBean;
import sms.servicio.SMSTiposCampaniasServicio;



public class SMSTiposCampaniasControlador extends SimpleFormController {

	SMSTiposCampaniasServicio smsTiposCampaniasServicio = null;

	public SMSTiposCampaniasControlador(){
		setCommandClass(SMSTiposCampaniasBean.class);
		setCommandName("smsTiposCampaniasBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		SMSTiposCampaniasBean smsCapanias = (SMSTiposCampaniasBean) command;
		smsTiposCampaniasServicio.getSmsTiposCampaniasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
					
		MensajeTransaccionBean mensaje = null;
		mensaje = smsTiposCampaniasServicio.grabaTransaccion(tipoTransaccion,smsCapanias);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setSmsTiposCampaniasServicio(
			SMSTiposCampaniasServicio smsTiposCampaniasServicio) {
		this.smsTiposCampaniasServicio = smsTiposCampaniasServicio;
	}



} 
