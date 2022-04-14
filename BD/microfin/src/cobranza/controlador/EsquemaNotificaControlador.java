package cobranza.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cobranza.bean.EsquemaNotificaBean;
import cobranza.servicio.EsquemaNotificaServicio;

public class EsquemaNotificaControlador extends SimpleFormController{
	EsquemaNotificaServicio esquemaNotificaServicio = null;
	
	public EsquemaNotificaControlador(){
		setCommandClass(EsquemaNotificaBean.class);
		setCommandName("esquemaNotificaBean");		
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		esquemaNotificaServicio.getEsquemaNotificaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		EsquemaNotificaBean esquemaBean = (EsquemaNotificaBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));				
		MensajeTransaccionBean mensaje = null;
		
		mensaje = esquemaNotificaServicio.grabaTransaccion(tipoTransaccion, esquemaBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public EsquemaNotificaServicio getEsquemaNotificaServicio() {
		return esquemaNotificaServicio;
	}

	public void setEsquemaNotificaServicio(
			EsquemaNotificaServicio esquemaNotificaServicio) {
		this.esquemaNotificaServicio = esquemaNotificaServicio;
	}	
}
