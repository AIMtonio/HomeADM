package fondeador.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import fondeador.bean.CreditoFondeoBean;
import fondeador.servicio.CreditoFondeoServicio;
import general.bean.MensajeTransaccionBean;

public class AnaliticoCarteraPasControlador extends SimpleFormController {
	CreditoFondeoServicio	creditoFondeoServicio	= null;
	String					nombreReporte			= null;
	String					successView				= null;
	
	public AnaliticoCarteraPasControlador() {
		setCommandClass(CreditoFondeoBean.class);
		setCommandName("creditoFondeBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		CreditosBean creditosBean = (CreditosBean) command;
		
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);
		mensaje.setDescripcion("Reporte Analitico Cartera Pasiva");
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public void setCreditoFondeoServicio(CreditoFondeoServicio creditoFondeoServicio) {
		this.creditoFondeoServicio = creditoFondeoServicio;
	}
	
	public String getNombreReporte() {
		return nombreReporte;
	}
	
	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
	
}
