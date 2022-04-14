package cobranza.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cobranza.bean.GestoresCobranzaBean;
import cobranza.servicio.GestoresCobranzaServicio;

public class GestoresCobranzaControlador extends SimpleFormController{
	private GestoresCobranzaServicio gestoresCobranzaServicio= null;
	
	public GestoresCobranzaControlador(){
		setCommandClass(GestoresCobranzaBean.class);
		setCommandName("gestoresCobranza");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		gestoresCobranzaServicio.getGestoresCobranzaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		GestoresCobranzaBean gestores = (GestoresCobranzaBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		
		mensaje = gestoresCobranzaServicio.grabaTransaccion(tipoTransaccion, gestores);
		
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public GestoresCobranzaServicio getGestoresCobranzaServicio() {
		return gestoresCobranzaServicio;
	}
	public void setGestoresCobranzaServicio(
			GestoresCobranzaServicio gestoresCobranzaServicio) {
		this.gestoresCobranzaServicio = gestoresCobranzaServicio;
	}
}