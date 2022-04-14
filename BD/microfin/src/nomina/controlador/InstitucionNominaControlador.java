package nomina.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import nomina.bean.InstitucionNominaBean;
import nomina.servicio.InstitucionNominaServicio;

public class InstitucionNominaControlador extends SimpleFormController{
	
	InstitucionNominaServicio institucionNomServicio = null;

	public InstitucionNominaControlador() {
		setCommandClass(InstitucionNominaBean.class);
		setCommandName("institucionNominaBean");
}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		institucionNomServicio.getInstitucionNomDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		InstitucionNominaBean institucionNominaBean = (InstitucionNominaBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
	
		int tipoActualizacion =(request.getParameter("tipoActualizacion")!=null)?
						Integer.parseInt(request.getParameter("tipoActualizacion")):0;
		MensajeTransaccionBean mensaje = null;
		mensaje = institucionNomServicio.grabaTransaccion(tipoTransaccion,institucionNominaBean,tipoActualizacion);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	/* declaracion de getter y setters */

	public InstitucionNominaServicio getInstitucionNomServicio() {
		return institucionNomServicio;
	}

	public void setInstitucionNomServicio(
			InstitucionNominaServicio institucionNomServicio) {
		this.institucionNomServicio = institucionNomServicio;
	}

}
	