package fondeador.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fondeador.bean.TiposLineaFondeaBean;
import fondeador.servicio.TiposLineaFondeaServicio;

public class TiposLineaFondeaControlador extends SimpleFormController {

	TiposLineaFondeaServicio tiposLineaFondeaServicio = null;
	
	public TiposLineaFondeaControlador() {
		setCommandClass(TiposLineaFondeaBean.class);
		setCommandName("tiposLineaFondea");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {		
		tiposLineaFondeaServicio.getTiposLineaFondeaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		TiposLineaFondeaBean tiposLineaFondeaBean = (TiposLineaFondeaBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = tiposLineaFondeaServicio.grabaTransaccion(tipoTransaccion, tiposLineaFondeaBean);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	
	public TiposLineaFondeaServicio getTiposLineaFondeaServicio() {
		return tiposLineaFondeaServicio;
	}

	public void setTiposLineaFondeaServicio(
			TiposLineaFondeaServicio tiposLineaFondeaServicio) {
		this.tiposLineaFondeaServicio = tiposLineaFondeaServicio;
	}

	
}
