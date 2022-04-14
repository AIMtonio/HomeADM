package fondeador.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fondeador.bean.CondicionesDesctoActLinFonBean;
import fondeador.servicio.CondicionesDesctoActLinFonServicio;

public class CondicionesDesctoActLinFonControlador extends SimpleFormController {

	CondicionesDesctoActLinFonServicio condicionesDesctoActLinFonServicio = null;
	
	public CondicionesDesctoActLinFonControlador() {
		setCommandClass(CondicionesDesctoActLinFonBean.class);
		setCommandName("condicionesDesctoActLinFonBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		condicionesDesctoActLinFonServicio.getCondicionesDesctoActLinFonDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccionAct"));
		CondicionesDesctoActLinFonBean condicionesDesctoActLinFonBean = (CondicionesDesctoActLinFonBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = condicionesDesctoActLinFonServicio.grabaTransaccion(tipoTransaccion, condicionesDesctoActLinFonBean);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CondicionesDesctoActLinFonServicio getCondicionesDesctoActLinFonServicio() {
		return condicionesDesctoActLinFonServicio;
	}

	public void setCondicionesDesctoActLinFonServicio(
			CondicionesDesctoActLinFonServicio condicionesDesctoActLinFonServicio) {
		this.condicionesDesctoActLinFonServicio = condicionesDesctoActLinFonServicio;
	}
}
