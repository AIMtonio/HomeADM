package fira.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.CastigosCarteraAgroBean;
import fira.servicio.CastigosCarteraAgroServicio;

public class CastigosCarteraAgroControlador extends SimpleFormController {

	CastigosCarteraAgroServicio castigosCarteraAgroServicio = null;
	
	public CastigosCarteraAgroControlador() {
		setCommandClass(CastigosCarteraAgroBean.class);
		setCommandName("castigosCarteraAgro");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception{
		
		castigosCarteraAgroServicio.getCastigosCarteraAgroDAO().getParametrosAuditoriaBean().setNombrePrograma(
				request.getRequestURI().toString()
				);

		CastigosCarteraAgroBean castigosCartera = (CastigosCarteraAgroBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
	
		mensaje = castigosCarteraAgroServicio.grabaTransaccion(tipoTransaccion, castigosCartera );
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CastigosCarteraAgroServicio getCastigosCarteraAgroServicio() {
		return castigosCarteraAgroServicio;
	}
	public void setCastigosCarteraAgroServicio(
			CastigosCarteraAgroServicio castigosCarteraAgroServicio) {
		this.castigosCarteraAgroServicio = castigosCarteraAgroServicio;
	}
		
}




