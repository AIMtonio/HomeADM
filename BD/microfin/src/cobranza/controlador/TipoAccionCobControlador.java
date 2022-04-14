package cobranza.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cobranza.bean.TipoAccionCobBean;
import cobranza.servicio.TipoAccionCobServicio;

public class TipoAccionCobControlador extends SimpleFormController {
	TipoAccionCobServicio tipoAccionCobServicio = null;
	
	public TipoAccionCobControlador(){
		setCommandClass(TipoAccionCobBean.class);
		setCommandName("tipoAccionCobBean");		
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		tipoAccionCobServicio.getTipoAccionCobDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		TipoAccionCobBean accionBean = (TipoAccionCobBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));				
		MensajeTransaccionBean mensaje = null;
		
		mensaje = tipoAccionCobServicio.grabaTransaccion(tipoTransaccion, accionBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public TipoAccionCobServicio getTipoAccionCobServicio() {
		return tipoAccionCobServicio;
	}

	public void setTipoAccionCobServicio(TipoAccionCobServicio tipoAccionCobServicio) {
		this.tipoAccionCobServicio = tipoAccionCobServicio;
	}
}
