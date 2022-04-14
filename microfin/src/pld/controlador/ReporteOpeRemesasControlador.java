package pld.controlador;

import general.bean.MensajeTransaccionBean;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.ReporteOpeRemesasBean;
import pld.servicio.ReporteOpeRemesasServicio;

public class ReporteOpeRemesasControlador extends  SimpleFormController{
	ReporteOpeRemesasServicio reporteOpeRemesasServicio = null;
	
	public ReporteOpeRemesasControlador(){
 		setCommandClass(ReporteOpeRemesasBean.class);
 		setCommandName("reporteOpeRemesasBean");
 	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		ReporteOpeRemesasBean reporteOpeRemesasBean = (ReporteOpeRemesasBean) command;	
		reporteOpeRemesasServicio.getReporteOpeRemesasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		MensajeTransaccionBean mensaje = null;
 
 		return new ModelAndView(getSuccessView(),"mensaje", mensaje);
		
	}

	public ReporteOpeRemesasServicio getReporteOpeRemesasServicio() {
		return reporteOpeRemesasServicio;
	}

	public void setReporteOpeRemesasServicio(
			ReporteOpeRemesasServicio reporteOpeRemesasServicio) {
		this.reporteOpeRemesasServicio = reporteOpeRemesasServicio;
	}

}
