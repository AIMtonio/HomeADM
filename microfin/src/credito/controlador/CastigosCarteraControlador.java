package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CastigosCarteraBean;
import credito.servicio.CastigosCarteraServicio;


public class CastigosCarteraControlador  extends SimpleFormController {
	
	CastigosCarteraServicio castigosCarteraServicio = null;
	

	public CastigosCarteraControlador() {
		setCommandClass(CastigosCarteraBean.class);
		setCommandName("castigosCartera");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception{
		
		castigosCarteraServicio.getCastigosCarteraDAO().getParametrosAuditoriaBean().setNombrePrograma(
				request.getRequestURI().toString()
				);

		CastigosCarteraBean castigosCartera = (CastigosCarteraBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
	
		mensaje = castigosCarteraServicio.grabaTransaccion(tipoTransaccion, castigosCartera );
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CastigosCarteraServicio getCastigosCarteraServicio() {
		return castigosCarteraServicio;
	}
	public void setCastigosCarteraServicio(
			CastigosCarteraServicio castigosCarteraServicio) {
		this.castigosCarteraServicio = castigosCarteraServicio;
	}
		



}
