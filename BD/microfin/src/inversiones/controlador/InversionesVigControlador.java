package inversiones.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;
import inversiones.bean.InversionBean;
import inversiones.servicio.InversionServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;

public class InversionesVigControlador extends SimpleFormController {
	InversionServicio inversionServicio = null;
	String nombreReporte = null;
	String successView = null;		

 	public InversionesVigControlador(){
 		setCommandClass(InversionBean.class);
 		setCommandName("inversionesVig");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		InversionBean inversionBean = (InversionBean) command;
 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
				
		MensajeTransaccionBean mensaje = null;
		mensaje = inversionServicio.grabaTransaccion(tipoTransaccion,inversionBean);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}

	public InversionServicio getInversionServicio() {
		return inversionServicio;
	}

	public void setInversionServicio(InversionServicio inversionServicio) {
		this.inversionServicio = inversionServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}


}
