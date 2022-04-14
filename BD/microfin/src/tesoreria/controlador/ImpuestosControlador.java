package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.ImpuestosBean;
import tesoreria.servicio.ImpuestosServicio;

public class ImpuestosControlador extends SimpleFormController{
	ImpuestosServicio impuestosServicio = null;

	public ImpuestosControlador() {
		setCommandClass(ImpuestosBean.class);
		setCommandName("impuestos");
}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		impuestosServicio.getImpuestosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ImpuestosBean impuestosBean = (ImpuestosBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		

		MensajeTransaccionBean mensaje = null;
		mensaje = impuestosServicio.grabaTransaccion(tipoTransaccion,impuestosBean);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ImpuestosServicio getImpuestosServicio() {
		return impuestosServicio;
	}

	public void setImpuestosServicio(ImpuestosServicio impuestosServicio) {
		this.impuestosServicio = impuestosServicio;
	}

		
		
}
