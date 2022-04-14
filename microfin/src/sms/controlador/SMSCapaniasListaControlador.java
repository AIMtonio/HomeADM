package sms.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import sms.bean.SMSCapaniasBean;
import sms.servicio.SMSCapaniasServicio;



public class SMSCapaniasListaControlador extends AbstractCommandController {
	
	SMSCapaniasServicio smsCapaniasServicio = null;
	
	public SMSCapaniasListaControlador() {
		setCommandClass(SMSCapaniasBean.class);
		setCommandName("smsCapaniasBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	SMSCapaniasBean smsCapaniasBean = (SMSCapaniasBean) command;
	smsCapaniasServicio.getSmsCapaniasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

	List campanias =	smsCapaniasServicio.lista(tipoLista, smsCapaniasBean);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(campanias);
			
	return new ModelAndView("sms/campaniasListaVista", "listaResultado", listaResultado);
	}

	public void setSmsCapaniasServicio(SMSCapaniasServicio smsCapaniasServicio) {
		this.smsCapaniasServicio = smsCapaniasServicio;
	}
	
}


