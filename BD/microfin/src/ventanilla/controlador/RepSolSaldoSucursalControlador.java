package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.SolSaldoSucursalBean;
import ventanilla.servicio.SolSaldoSucursalServicio;
import cuentas.bean.IDEMensualBean;


public class RepSolSaldoSucursalControlador  extends SimpleFormController {
	SolSaldoSucursalServicio solSaldoSucursalServicio = null;
	String nombreReporte = null;
	String successView = null;

 	public RepSolSaldoSucursalControlador(){
 		setCommandClass(SolSaldoSucursalBean.class);
 		setCommandName("solSaldoSucursalBean");
 	}
    
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		SolSaldoSucursalBean solSaldoSucursalBean = (SolSaldoSucursalBean) command;
 		
 								   
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte Solicitud de Saldos por Sucursal");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

		
}

	

	public SolSaldoSucursalServicio getSolSaldoSucursalServicio() {
		return solSaldoSucursalServicio;
	}

	public void setSolSaldoSucursalServicio(
			SolSaldoSucursalServicio solSaldoSucursalServicio) {
		this.solSaldoSucursalServicio = solSaldoSucursalServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	
 	

}
