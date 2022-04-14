package fondeador.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fondeador.bean.InstitutFondeoBean;
import fondeador.servicio.InstitutFondeoServicio;

public class InstitutFondeoControlador extends SimpleFormController {

	InstitutFondeoServicio institutFondeoServicio = null;
	
	public InstitutFondeoControlador() {
		setCommandClass(InstitutFondeoBean.class);
		setCommandName("instFondeo");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {		
		
		institutFondeoServicio.getInstitutFondeoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		InstitutFondeoBean institutFondeo = (InstitutFondeoBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = institutFondeoServicio.grabaTransaccion(tipoTransaccion, institutFondeo);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public InstitutFondeoServicio getInstitutFondeoServicio() {
		return institutFondeoServicio;
	}

	public void setInstitutFondeoServicio( InstitutFondeoServicio institutFondeoServicio) {
		this.institutFondeoServicio = institutFondeoServicio;
	}
		
}//fin
