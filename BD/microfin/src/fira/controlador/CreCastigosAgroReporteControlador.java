package fira.controlador;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.CastigosCarteraAgroBean;
import fira.servicio.CastigosCarteraAgroServicio;

public class CreCastigosAgroReporteControlador extends SimpleFormController{

	CastigosCarteraAgroServicio castigosCarteraAgroServicio = null;
	
	public CreCastigosAgroReporteControlador() {
		setCommandClass(CastigosCarteraAgroBean.class);
		setCommandName("castigosCarteraBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
			castigosCarteraAgroServicio.getCastigosCarteraAgroDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccion")):
									0;
			
			CastigosCarteraAgroBean creCastigados = (CastigosCarteraAgroBean) command;
	
			MensajeTransaccionBean mensaje = null;
	
	
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

//----------------getter y setter ---------------
	public CastigosCarteraAgroServicio getCastigosCarteraAgroServicio() {
		return castigosCarteraAgroServicio;
	}


	public void setCastigosCarteraAgroServicio(
			CastigosCarteraAgroServicio castigosCarteraAgroServicio) {
		this.castigosCarteraAgroServicio = castigosCarteraAgroServicio;
	}

}


