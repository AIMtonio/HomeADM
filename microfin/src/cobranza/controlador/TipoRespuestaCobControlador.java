package cobranza.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cobranza.bean.TipoRespuestaCobBean;
import cobranza.servicio.TipoRespuestaCobServicio;

public class TipoRespuestaCobControlador extends SimpleFormController{
	TipoRespuestaCobServicio tipoRespuestaCobServicio = null;
	
	public TipoRespuestaCobControlador(){
		setCommandClass(TipoRespuestaCobBean.class);
		setCommandName("tipoRespuestaCobBean");		
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		tipoRespuestaCobServicio.getTipoRespuestaCobDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		TipoRespuestaCobBean respuestaBean = (TipoRespuestaCobBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));				
		MensajeTransaccionBean mensaje = null;
		
		mensaje = tipoRespuestaCobServicio.grabaTransaccion(tipoTransaccion, respuestaBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	

	public TipoRespuestaCobServicio getTipoRespuestaCobServicio() {
		return tipoRespuestaCobServicio;
	}

	public void setTipoRespuestaCobServicio(
			TipoRespuestaCobServicio tipoRespuestaCobServicio) {
		this.tipoRespuestaCobServicio = tipoRespuestaCobServicio;
	}	
}
