package nomina.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.EmpleadoNominaBean;
import nomina.servicio.NominaEmpleadosServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;




public class NominaEmpleadosRepControlador extends SimpleFormController{
	NominaEmpleadosServicio nominaEmpleadosServicio = null;
	
	
	public NominaEmpleadosRepControlador() {
		setCommandClass(EmpleadoNominaBean.class);
		setCommandName("empleadoNominaBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		nominaEmpleadosServicio.getNominaEmpleadosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccion")):
									0;
									
			EmpleadoNominaBean empleadoNominaBean = (EmpleadoNominaBean) command;
	
			MensajeTransaccionBean mensaje = null;
	
	
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}


//----------------getter y setter ---------------
	public NominaEmpleadosServicio getNominaEmpleadosServicio() {
		return nominaEmpleadosServicio;
	}

	public void setNominaEmpleadosServicio(
			NominaEmpleadosServicio nominaEmpleadosServicio) {
		this.nominaEmpleadosServicio = nominaEmpleadosServicio;
	}
	
	
	
}
