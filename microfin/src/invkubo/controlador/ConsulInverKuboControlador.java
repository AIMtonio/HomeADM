package invkubo.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;
import invkubo.bean.FondeoSolicitudBean;
import invkubo.servicio.InversionistasKuboServicio;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


public class ConsulInverKuboControlador extends SimpleFormController {
	InversionistasKuboServicio inversionistasKuboServicio = null;
	String nombreReporte = null;
	String successView = null;		

 	public ConsulInverKuboControlador(){
 		setCommandClass(FondeoSolicitudBean.class);
 		setCommandName("inversionistas");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		FondeoSolicitudBean fondeoSolicitudBean = (FondeoSolicitudBean) command;
 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
				
		MensajeTransaccionBean mensaje = null;
		mensaje = inversionistasKuboServicio.grabaTransaccion(tipoTransaccion,fondeoSolicitudBean);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}

	public InversionistasKuboServicio getInversionistasKuboServicio() {
		return inversionistasKuboServicio;
	}

	public void setInversionistasKuboServicio(InversionistasKuboServicio inversionistasKuboServicio) {
		this.inversionistasKuboServicio = inversionistasKuboServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}


}