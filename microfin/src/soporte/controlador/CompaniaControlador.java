package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.CompaniasBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.CompaniasServicio;

public class CompaniaControlador  extends SimpleFormController {

	CompaniasServicio companiasServicio = null;
	
	public CompaniaControlador() {
		setCommandClass(CompaniasBean.class);
		setCommandName("compania");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		CompaniasBean compania = (CompaniasBean) command;
		int com= compania.getCompaniaID();
	
		MensajeTransaccionBean mensaje = null;
		mensaje = companiasServicio.grabaTransaccion(tipoTransaccion, compania);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CompaniasServicio getCompaniasServicio() {
		return companiasServicio;
	}

	public void setCompaniasServicio(CompaniasServicio companiasServicio) {
		this.companiasServicio = companiasServicio;
	}
	

}
