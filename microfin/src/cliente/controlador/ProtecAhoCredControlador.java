package cliente.controlador;

import general.bean.MensajeTransaccionBean;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import cliente.bean.ProtecionAhorroCreditoBean;
import cliente.servicio.ProtectAhoCredServicio;

public class ProtecAhoCredControlador extends SimpleFormController {
	ProtectAhoCredServicio protectAhoCredServicio= null;

	public ProtecAhoCredControlador() {
		setCommandClass(ProtecionAhorroCreditoBean.class);
		setCommandName("cliAProtecCuenBean");
	}
		
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		protectAhoCredServicio.getProtectAhoCredDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ProtecionAhorroCreditoBean proteccionCuentaAhorro = (ProtecionAhorroCreditoBean) command;
		int tipoTransaccion		= (request.getParameter("tipoTransaccion")!= null)?
									Integer.parseInt(request.getParameter("tipoTransaccion")):0 ;
		int tipoActualizacion	= (request.getParameter("tipoActualizacion")!=null)?
									Integer.parseInt(request.getParameter("tipoActualizacion")):
									0;
		MensajeTransaccionBean mensaje = null;
		mensaje = protectAhoCredServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, proteccionCuentaAhorro);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	//-------------setter---------------
	public void setProtectAhoCredServicio(
			ProtectAhoCredServicio protectAhoCredServicio) {
		this.protectAhoCredServicio = protectAhoCredServicio;
	}
}