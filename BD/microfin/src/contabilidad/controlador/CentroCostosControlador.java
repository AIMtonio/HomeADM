package contabilidad.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.CentroCostosBean;
import contabilidad.servicio.CentroCostosServicio;



public class CentroCostosControlador extends SimpleFormController {

	CentroCostosServicio centroCostosServicio = null;
	
	public CentroCostosControlador() {
		setCommandClass(CentroCostosBean.class);
		setCommandName("centro");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		CentroCostosBean centro = (CentroCostosBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = centroCostosServicio.grabaTransaccion(tipoTransaccion,centro);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setCentroCostosServicio(CentroCostosServicio centroCostosServicio) {
		this.centroCostosServicio = centroCostosServicio;
	}
		
}
