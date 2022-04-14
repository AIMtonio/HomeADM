package originacion.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.InconsistenciasBean;
import originacion.servicio.InconsistenciasServicio;;


public class InconsistenciasControlador extends SimpleFormController{
	
	InconsistenciasServicio inconsistenciasServicio;
	
	public InconsistenciasControlador(){
		setCommandClass(InconsistenciasBean.class);
		setCommandName("inconsistenciasServicio");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		InconsistenciasBean inconsistencias = (InconsistenciasBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;
			inconsistenciasServicio.getInconsistenciasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensaje = inconsistenciasServicio.grabaTransaccion(tipoTransaccion, inconsistencias);
		} catch(Exception ex){
			ex.printStackTrace();
		} finally {
			if(mensaje==null){
				mensaje=new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al Grabar Registro.");
			}
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public InconsistenciasServicio getInconsistenciasServicio() {
		return inconsistenciasServicio;
	}

	public void setInconsistenciasServicio(
			InconsistenciasServicio inconsistenciasServicio) {
		this.inconsistenciasServicio = inconsistenciasServicio;
	}


	
}