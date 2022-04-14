package nomina.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;



import nomina.bean.ActualizaEstatusEmpBean;
import nomina.servicio.ActualizaEstatusEmpServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class ActualizaEstatusEmpControlador extends SimpleFormController{
	ActualizaEstatusEmpServicio actualizaEstatusEmpServicio = null;

	public ActualizaEstatusEmpControlador() {
		setCommandClass(ActualizaEstatusEmpBean.class);
		setCommandName("actualizaEstatusEmpBean");
}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		actualizaEstatusEmpServicio.getActualizaEstatusEmpDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ActualizaEstatusEmpBean actualizaEstatusEmpBean = (ActualizaEstatusEmpBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
	
		MensajeTransaccionBean mensaje = null;
		mensaje = actualizaEstatusEmpServicio.grabaTransaccion(tipoTransaccion,actualizaEstatusEmpBean);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
    // Getter y Setter
	public ActualizaEstatusEmpServicio getActualizaEstatusEmpServicio() {
		return actualizaEstatusEmpServicio;
	}

	public void setActualizaEstatusEmpServicio(
			ActualizaEstatusEmpServicio actualizaEstatusEmpServicio) {
		this.actualizaEstatusEmpServicio = actualizaEstatusEmpServicio;
	}


}
