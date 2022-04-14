package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CastigosCarteraBean;
import credito.servicio.CastigosCarteraServicio;

public class CreCastigosReporteControlador extends SimpleFormController{
	CastigosCarteraServicio castigosCarteraServicio = null;
	
	
	public CreCastigosReporteControlador() {
		setCommandClass(CastigosCarteraBean.class);
		setCommandName("castigosCarteraBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
			castigosCarteraServicio.getCastigosCarteraDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccion")):
									0;
			
			CastigosCarteraBean creCastigados = (CastigosCarteraBean) command;
	
			MensajeTransaccionBean mensaje = null;
	
	
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

//----------------getter y setter ---------------
	public CastigosCarteraServicio getCastigosCarteraServicio() {
		return castigosCarteraServicio;
	}


	public void setCastigosCarteraServicio(
			CastigosCarteraServicio castigosCarteraServicio) {
		this.castigosCarteraServicio = castigosCarteraServicio;
	}
	
	
	
}
