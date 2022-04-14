package spei.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import spei.bean.RepRecepcionesSpeiiBean;
import spei.servicio.RepRecepcionesSpeiiServicio;

import cliente.bean.RepoteClientesMenoresBean;
import cliente.servicio.ReporteClienteMenoresServicio;



public class RepRecepcionesSpeiiControlador extends SimpleFormController{
	

	RepRecepcionesSpeiiServicio repRecepcionesSpeiiServicio = null;
	

	public RepRecepcionesSpeiiControlador() {
		setCommandClass(RepRecepcionesSpeiiBean.class);
		setCommandName("repRecepcionesSpeiiBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
	
		RepoteClientesMenoresBean repoteClientesMenoresBean= (RepoteClientesMenoresBean) command;
		MensajeTransaccionBean mensaje = null;
			
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public RepRecepcionesSpeiiServicio getRepRecepcionesSpeiiServicio() {
		return repRecepcionesSpeiiServicio;
	}

	public void setRepRecepcionesSpeiiServicio(
			RepRecepcionesSpeiiServicio repRecepcionesSpeiiServicio) {
		this.repRecepcionesSpeiiServicio = repRecepcionesSpeiiServicio;
	}



}
