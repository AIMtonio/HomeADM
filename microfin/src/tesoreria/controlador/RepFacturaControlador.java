package tesoreria.controlador;



import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.servicio.FacturaprovServicio;
import tesoreria.bean.FacturaprovBean;
 

public class RepFacturaControlador extends SimpleFormController {
	FacturaprovServicio facturaprovServicio = null;
	String nombreReporte = null;
	String successView = null;		

 	public RepFacturaControlador(){
 		setCommandClass(FacturaprovBean.class);
 		setCommandName("facturaBean");
 	}
    
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 			
						   
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte de Facturas");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}


	public void setFacturaprovServicio(FacturaprovServicio facturaprovServicio) {
		this.facturaprovServicio = facturaprovServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

}

