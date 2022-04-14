package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ExpedienteClienteBean;
import cliente.servicio.ExpedienteClienteServicio;

public class ExpedienteControlador extends AbstractCommandController {

	public ExpedienteClienteServicio expedienteClienteServicio = null;
	public String successView = null;

	public ExpedienteControlador() {
		setCommandClass(ExpedienteClienteBean.class);
		setCommandName("expedienteBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		int tipoConsulta = 2;
		String clienteID = request.getParameter("clienteID");
		ExpedienteClienteBean expediente = new ExpedienteClienteBean();
		expediente.setClienteID(clienteID);

		return new ModelAndView(getSuccessView(), "expedienteBean",
				expedienteClienteServicio.consulta(expediente, tipoConsulta));
	}

	public ExpedienteClienteServicio getExpedienteClienteServicio() {
		return expedienteClienteServicio;
	}

	public void setExpedienteClienteServicio(
			ExpedienteClienteServicio expedienteClienteServicio) {
		this.expedienteClienteServicio = expedienteClienteServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}
