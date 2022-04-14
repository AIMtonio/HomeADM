package nomina.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;



import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import nomina.bean.EmpleadoNominaBean;
import nomina.servicio.NominaServicio;

public class ReportEstatusEmpNomControlador extends SimpleFormController{
	NominaServicio nominaServicio = null;

	public ReportEstatusEmpNomControlador() {
		setCommandClass(EmpleadoNominaBean.class);
		setCommandName("estatusEmpleadoNomina");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
			
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
	
				EmpleadoNominaBean nominaBean = (EmpleadoNominaBean) command;
		MensajeTransaccionBean mensaje = null;	
		mensaje = nominaServicio.grabaTransaccion(tipoTransaccion,nominaBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	

	/* Declaracion de getter y setters */
	
	
	public NominaServicio getNominaServicio() {
		return nominaServicio;
	}
	public void setNominaServicio(NominaServicio nominaServicio) {
		this.nominaServicio = nominaServicio;
	}
}
