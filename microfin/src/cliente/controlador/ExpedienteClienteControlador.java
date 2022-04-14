package cliente.controlador;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ExpedienteClienteBean;
import cliente.servicio.ExpedienteClienteServicio;

public class ExpedienteClienteControlador extends SimpleFormController {

	ExpedienteClienteServicio expedienteClienteServicio = null;
	ParametrosSesionBean parametrosSesionBean = null;
	
	public ExpedienteClienteControlador() {
		setCommandClass(ExpedienteClienteBean.class);
		setCommandName("expedienteClienteBean");
	}

	@Override
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {ExpedienteClienteBean bean = (ExpedienteClienteBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ?
					Integer.parseInt(request.getParameter("tipoTransaccion")): 0;					
	
		MensajeTransaccionBean mensaje = null;		
		mensaje = expedienteClienteServicio.grabaTransaccion(tipoTransaccion ,bean);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ExpedienteClienteServicio getExpedienteClienteServicio() {
		return expedienteClienteServicio;
	}

	public void setExpedienteClienteServicio(
			ExpedienteClienteServicio expedienteClienteServicio) {
		this.expedienteClienteServicio = expedienteClienteServicio;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
		
}
