package nomina.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.NomTipoClavePresupBean;
import nomina.servicio.NomTipoClavePresupServicio;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class NomTipoClavePresupControlador  extends SimpleFormController{
	NomTipoClavePresupServicio nomTipoClavePresupServicio = null;
	
	public NomTipoClavePresupControlador(){
		setCommandClass(NomTipoClavePresupBean.class);
		setCommandName("nomTipoClavePresupBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		NomTipoClavePresupBean tiposClavesPresup = (NomTipoClavePresupBean) command;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)? Integer.parseInt(request.getParameter("tipoTransaccion")): 0;			
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)? Integer.parseInt(request.getParameter("tipoActualizacion")): 0;
			
		MensajeTransaccionBean mensaje = null;
		mensaje = nomTipoClavePresupServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, tiposClavesPresup);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	
	}
	
	
	public NomTipoClavePresupServicio getNomTipoClavePresupServicio() {
		return nomTipoClavePresupServicio;
	}
	public void setNomTipoClavePresupServicio(
			NomTipoClavePresupServicio nomTipoClavePresupServicio) {
		this.nomTipoClavePresupServicio = nomTipoClavePresupServicio;
	}
}
