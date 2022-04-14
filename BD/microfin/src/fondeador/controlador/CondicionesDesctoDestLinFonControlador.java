package fondeador.controlador;

import fondeador.bean.CondicionesDesctoDestLinFonBean;
import fondeador.servicio.CondicionesDesctoDestLinFonServicio;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


public class CondicionesDesctoDestLinFonControlador extends SimpleFormController {

	CondicionesDesctoDestLinFonServicio condicionesDesctoDestLinFonServicio = null;
	
	public CondicionesDesctoDestLinFonControlador() {
		setCommandClass(CondicionesDesctoDestLinFonBean.class);
		setCommandName("condicionesDesctoDestLinFonBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		condicionesDesctoDestLinFonServicio.getCondicionesDesctoDestLinFonDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccionDestino"));
		CondicionesDesctoDestLinFonBean condicionesDesctoDestLinFonBean = (CondicionesDesctoDestLinFonBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = condicionesDesctoDestLinFonServicio.grabaTransaccion(tipoTransaccion, condicionesDesctoDestLinFonBean);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CondicionesDesctoDestLinFonServicio getCondicionesDesctoDestLinFonServicio() {
		return condicionesDesctoDestLinFonServicio;
	}

	public void setCondicionesDesctoDestLinFonServicio(
			CondicionesDesctoDestLinFonServicio condicionesDesctoDestLinFonServicio) {
		this.condicionesDesctoDestLinFonServicio = condicionesDesctoDestLinFonServicio;
	}	
}
