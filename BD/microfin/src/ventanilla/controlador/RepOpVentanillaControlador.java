package ventanilla.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fondeador.bean.CreditoFondeoBean;
import general.bean.MensajeTransaccionBean;

import ventanilla.bean.CajasVentanillaBean;
import ventanilla.dao.OpcionesPorCajaDAO;
import ventanilla.servicio.CajasVentanillaServicio;

public class RepOpVentanillaControlador extends SimpleFormController  {
	CajasVentanillaServicio cajasVentanillaServicio = null;
	String nombreReporte = null;
	String successView = null;
	
	public RepOpVentanillaControlador(){
		setCommandClass(CajasVentanillaBean.class);
		setCommandName("CajasVentanillaBean");	
	}
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {			
		
		
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte Operaciones Ventanilla");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

public CajasVentanillaServicio getCajasVentanillaServicio() {

return cajasVentanillaServicio;

}
public String getNombreReporte() {
	return nombreReporte;
}
public void setCajasVentanillaServicio(CajasVentanillaServicio cajasVentanillaServicio) {
	
this.cajasVentanillaServicio = cajasVentanillaServicio;
}


}
