package sms.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import sms.bean.ResumenActividadSMSBean;
import sms.servicio.ResumenActividadSMSServicio;


public class ResumenActividadSMSGridControlador extends AbstractCommandController{
	
	ResumenActividadSMSServicio resumenActividadSMSServicio = null;
	public ResumenActividadSMSGridControlador() {
	setCommandClass(ResumenActividadSMSBean.class);
	setCommandName("smsCodigosResp");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {			
	ResumenActividadSMSBean resumenActividadSMSBean = (ResumenActividadSMSBean) command;
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	List resumenActLis = resumenActividadSMSServicio.lista(tipoLista, resumenActividadSMSBean);

	return new ModelAndView("sms/resumenActividadGridVista", "listaResultado", resumenActLis);
}


	public void setResumenActividadSMSServicio(
			ResumenActividadSMSServicio resumenActividadSMSServicio) {
		this.resumenActividadSMSServicio = resumenActividadSMSServicio;
	}


}


