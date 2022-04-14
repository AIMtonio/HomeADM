package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.CliAplicaPROFUNBean;
import cliente.servicio.CliAplicaPROFUNServicio;

public class CliAplicaPROFUNControlador extends SimpleFormController{
	CliAplicaPROFUNServicio cliAplicaPROFUNServicio = null;

	public CliAplicaPROFUNControlador() {
		setCommandClass(CliAplicaPROFUNBean.class);
		setCommandName("cliAplicaPROFUN");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		cliAplicaPROFUNServicio.getCliAplicaPROFUNDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		CliAplicaPROFUNBean cliAplicaPROFUN = (CliAplicaPROFUNBean) command;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
							
		MensajeTransaccionBean mensaje = null;
		mensaje = cliAplicaPROFUNServicio.grabaTransaccion(tipoTransaccion, cliAplicaPROFUN); //tipoActualizacion
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
			
	}

	public void setCliAplicaPROFUNServicio(
			CliAplicaPROFUNServicio cliAplicaPROFUNServicio) {
		this.cliAplicaPROFUNServicio = cliAplicaPROFUNServicio;
	}

}


