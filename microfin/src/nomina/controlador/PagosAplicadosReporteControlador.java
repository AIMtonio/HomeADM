package nomina.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.PagoNominaBean;
import nomina.servicio.PagoNominaServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;

import general.bean.MensajeTransaccionBean;

public class PagosAplicadosReporteControlador extends  SimpleFormController {
	PagoNominaServicio pagoNominaServicio = null;
	String nombreReporte = null;
	String successView = null;		

	public PagosAplicadosReporteControlador(){
		setCommandClass(PagoNominaBean.class);
		setCommandName("pagoNominaBean");
 	}
	    
 	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response,
 									Object command, BindException errors) throws Exception {
 		
 		PagoNominaBean pagoNominaBean = (PagoNominaBean) command;
 		
 		
 		MensajeTransaccionBean mensaje = null;
			mensaje = new MensajeTransaccionBean();
			mensaje.setNumero(0);

			mensaje.setDescripcion("Reporte Pagos Aplicados");
									
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}
/* ----------------------    Getters y Setters   ------------------------- */
	public PagoNominaServicio getPagoNominaServicio() {
		return pagoNominaServicio;
	}

	public void setPagoNominaServicio(PagoNominaServicio pagoNominaServicio) {
		this.pagoNominaServicio = pagoNominaServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

}
