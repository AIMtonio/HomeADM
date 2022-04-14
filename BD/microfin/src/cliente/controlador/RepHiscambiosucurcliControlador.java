package cliente.controlador;

import general.bean.MensajeTransaccionBean;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import cliente.bean.HiscambiosucurcliBean;
import cliente.servicio.HiscambiosucurcliServicio;


public class RepHiscambiosucurcliControlador extends SimpleFormController {
	
	HiscambiosucurcliServicio hiscambiosucurcliServicio = null;

	public RepHiscambiosucurcliControlador() {
		setCommandClass(HiscambiosucurcliBean.class);
		setCommandName("hiscambiosucurcliBean");
	}
		
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		hiscambiosucurcliServicio.getHiscambiosucurcliDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		HiscambiosucurcliBean bean = (HiscambiosucurcliBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = hiscambiosucurcliServicio.grabaTransaccion(tipoTransaccion,bean);
												
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	

	public HiscambiosucurcliServicio getHiscambiosucurcliServicio() {
		return hiscambiosucurcliServicio;
	}

	public void setHiscambiosucurcliServicio(
			HiscambiosucurcliServicio hiscambiosucurcliServicio) {
		this.hiscambiosucurcliServicio = hiscambiosucurcliServicio;
	}

}


