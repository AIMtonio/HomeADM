package fira.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.LineasCreditoBean;
import credito.servicio.LineasCreditoServicio;

 public class LineasCreditoAgroRepControlador extends SimpleFormController{
	 LineasCreditoServicio	lineasCreditoServicio	= null;
	 String				successView			= null;
	
	public LineasCreditoAgroRepControlador() {
		setCommandClass(LineasCreditoBean.class);
		setCommandName("lineasCreditoAgro");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		LineasCreditoBean lineasCreditoBean = (LineasCreditoBean) command;
		MensajeTransaccionBean mensaje = null;
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public void setLineasCreditoServicio(LineasCreditoServicio lineasCreditoServicio) {
		this.lineasCreditoServicio = lineasCreditoServicio;
	}
} 
