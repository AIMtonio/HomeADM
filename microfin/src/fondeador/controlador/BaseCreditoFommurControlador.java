package fondeador.controlador;

import fondeador.bean.RedesCuentoBean;
import fondeador.servicio.RedesCuentoServicio;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class BaseCreditoFommurControlador extends SimpleFormController{
	RedesCuentoServicio redesCuentoServicio = null;
	String nombreReporte = null;
	String successView = null;		

 	public BaseCreditoFommurControlador(){
 		setCommandClass(RedesCuentoBean.class);
 		setCommandName("redesCuentoBean");
 	}
    
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		RedesCuentoBean redesCuentoBean = (RedesCuentoBean) command;
 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
						   Integer.parseInt(request.getParameter("tipoActualizacion")):
							   0;		
						   
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte Base Crédito Fommur");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

 	}

	public RedesCuentoServicio getRedesCuentoServicio() {
		return redesCuentoServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}


	public void setRedesCuentoServicio(RedesCuentoServicio redesCuentoServicio) {
		this.redesCuentoServicio = redesCuentoServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

 	
}