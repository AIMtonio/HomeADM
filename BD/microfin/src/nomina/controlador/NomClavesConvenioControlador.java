package nomina.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nomina.bean.NomClavesConvenioBean;
import nomina.servicio.NomClavesConvenioServicio;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class NomClavesConvenioControlador extends SimpleFormController{
	NomClavesConvenioServicio nomClavesConvenioServicio = null;
	
	public NomClavesConvenioControlador(){
		setCommandClass(NomClavesConvenioBean.class);
		setCommandName("nomClavesConvenioBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		NomClavesConvenioBean clavesPresupConv = (NomClavesConvenioBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)? Integer.parseInt(request.getParameter("tipoTransaccion")): 0;			
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)? Integer.parseInt(request.getParameter("tipoActualizacion")): 0;
			
		MensajeTransaccionBean mensaje = null;
		mensaje = nomClavesConvenioServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, clavesPresupConv);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public NomClavesConvenioServicio getNomClavesConvenioServicio() {
		return nomClavesConvenioServicio;
	}

	public void setNomClavesConvenioServicio(
			NomClavesConvenioServicio nomClavesConvenioServicio) {
		this.nomClavesConvenioServicio = nomClavesConvenioServicio;
	}

}
