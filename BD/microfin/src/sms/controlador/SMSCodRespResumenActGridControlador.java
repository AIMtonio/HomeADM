package sms.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import sms.bean.SMSCodigosRespBean;
import sms.servicio.SMSCodigosRespServicio;

public class SMSCodRespResumenActGridControlador extends AbstractCommandController{
	
	SMSCodigosRespServicio smsCodigosRespServicio = null;
	
public SMSCodRespResumenActGridControlador() {
	setCommandClass(SMSCodigosRespBean.class);
	setCommandName("smsCodigosResp");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {			
	SMSCodigosRespBean smsCodigosResp = (SMSCodigosRespBean) command;
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	List detallePolizaList = smsCodigosRespServicio.lista(tipoLista, smsCodigosResp);

	return new ModelAndView("sms/codResResumenActGridVista", "listaResultado", detallePolizaList);
}


public void setSmsCodigosRespServicio(
		SMSCodigosRespServicio smsCodigosRespServicio) {
	this.smsCodigosRespServicio = smsCodigosRespServicio;
}


}

