package fondeador.controlador;

import fondeador.bean.CondicionesDesctoCteLinFonBean;
import fondeador.servicio.CondicionesDesctoCteLinFonServicio;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class CondicionesDesctoCteLinFonControlador extends SimpleFormController {

	CondicionesDesctoCteLinFonServicio condicionesDesctoCteLinFonServicio = null;
	
	public CondicionesDesctoCteLinFonControlador() {
		setCommandClass(CondicionesDesctoCteLinFonBean.class);
		setCommandName("condicionesDesctoCteLinFonBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		condicionesDesctoCteLinFonServicio.getCondicionesDesctoCteLinFonDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccionCondCte"));
		CondicionesDesctoCteLinFonBean condicionesDesctoCteLinFonBean = (CondicionesDesctoCteLinFonBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = condicionesDesctoCteLinFonServicio.grabaTransaccion(tipoTransaccion, condicionesDesctoCteLinFonBean);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CondicionesDesctoCteLinFonServicio getCondicionesDesctoCteLinFonServicio() {
		return condicionesDesctoCteLinFonServicio;
	}

	public void setCondicionesDesctoCteLinFonServicio(
			CondicionesDesctoCteLinFonServicio condicionesDesctoCteLinFonServicio) {
		this.condicionesDesctoCteLinFonServicio = condicionesDesctoCteLinFonServicio;
	}	
}
