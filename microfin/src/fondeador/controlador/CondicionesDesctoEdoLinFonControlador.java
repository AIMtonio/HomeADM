package fondeador.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fondeador.bean.CondicionesDesctoEdoLinFonBean;
import fondeador.servicio.CondicionesDesctoEdoLinFonServicio;

public class CondicionesDesctoEdoLinFonControlador extends SimpleFormController {

	CondicionesDesctoEdoLinFonServicio condicionesDesctoEdoLinFonServicio = null;
	
	public CondicionesDesctoEdoLinFonControlador() {
		setCommandClass(CondicionesDesctoEdoLinFonBean.class);
		setCommandName("condicionesDesctoEdoLinFonBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		condicionesDesctoEdoLinFonServicio.getCondicionesDesctoEdoLinFonDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccionEstado"));
		CondicionesDesctoEdoLinFonBean condicionesDesctoEdoLinFonBean = (CondicionesDesctoEdoLinFonBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = condicionesDesctoEdoLinFonServicio.grabaTransaccion(tipoTransaccion, condicionesDesctoEdoLinFonBean);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CondicionesDesctoEdoLinFonServicio getCondicionesDesctoEdoLinFonServicio() {
		return condicionesDesctoEdoLinFonServicio;
	}

	public void setCondicionesDesctoEdoLinFonServicio(
			CondicionesDesctoEdoLinFonServicio condicionesDesctoEdoLinFonServicio) {
		this.condicionesDesctoEdoLinFonServicio = condicionesDesctoEdoLinFonServicio;
	}
}
