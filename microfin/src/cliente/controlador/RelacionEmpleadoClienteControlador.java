package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.RelacionEmpleadoClienteBean;
import cliente.servicio.RelacionEmpleadoClienteServicio;


public class RelacionEmpleadoClienteControlador extends SimpleFormController {
	RelacionEmpleadoClienteServicio relacionEmpleadoClienteServicio= null;
	
	public RelacionEmpleadoClienteControlador() {
		setCommandClass(RelacionEmpleadoClienteBean.class);
		setCommandName("relacionEmpleadoClienteBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		relacionEmpleadoClienteServicio.getRelacionEmpleadoClienteDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		RelacionEmpleadoClienteBean relacionCliente = (RelacionEmpleadoClienteBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		String lisEmpleados= request.getParameter("lisEmpleados");
		String lisClientes = request.getParameter("lisClientes");
		String lisNomCliente = request.getParameter("lisNomClientes");
		String lisParentesco= request.getParameter("lisParentesco");
		String lisPuesto= request.getParameter("lisPuestos");
		String lisCURP= request.getParameter("lisCURP");
		String lisRFC = request.getParameter("lisRFC");
		
		
		MensajeTransaccionBean mensaje = null;
		mensaje = relacionEmpleadoClienteServicio.grabaTransaccion(tipoTransaccion,relacionCliente, lisEmpleados, lisClientes, lisParentesco, lisPuesto, lisCURP, lisRFC, lisNomCliente);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public RelacionEmpleadoClienteServicio getRelacionEmpleadoClienteServicio() {
		return relacionEmpleadoClienteServicio;
	}

	public void setRelacionEmpleadoClienteServicio(RelacionEmpleadoClienteServicio relacionEmpleadoClienteServicio) {
		this.relacionEmpleadoClienteServicio = relacionEmpleadoClienteServicio;
	}

	
}
