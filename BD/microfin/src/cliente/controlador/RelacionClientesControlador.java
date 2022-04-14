package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.RelacionClienteEmpleadoBean;
import cliente.servicio.RelacionClienteEmpleadoServicio;

public class RelacionClientesControlador extends SimpleFormController {
	RelacionClienteEmpleadoServicio relacionClienteServicio= null;
	
	public RelacionClientesControlador() {
		setCommandClass(RelacionClienteEmpleadoBean.class);
		setCommandName("relacionClienteBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		relacionClienteServicio.getRelacionClienteDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		RelacionClienteEmpleadoBean relacionCliente = (RelacionClienteEmpleadoBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		String lisEmpleados= request.getParameter("lisEmpleados");
		String lisClientes = request.getParameter("lisClientes");
		String lisParentesco= request.getParameter("lisParentesco");

		
		MensajeTransaccionBean mensaje = null;
		mensaje = relacionClienteServicio.grabaTransaccion(tipoTransaccion,relacionCliente, lisEmpleados, lisClientes, lisParentesco);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public RelacionClienteEmpleadoServicio getRelacionClienteServicio() {
		return relacionClienteServicio;
	}

	public void setRelacionClienteServicio(
			RelacionClienteEmpleadoServicio relacionClienteServicio) {
		this.relacionClienteServicio = relacionClienteServicio;
	}
}