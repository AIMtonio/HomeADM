package fondeador.controlador;

import fondeador.bean.LineaFondeadorBean;
import fondeador.servicio.LineaFondeadorServicio;
import general.bean.MensajeTransaccionBean;
import inversiones.bean.InversionBean;
import inversiones.servicio.InversionServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class DetalleLineaFondeoControlador extends SimpleFormController {
	LineaFondeadorServicio lineaFondeadorServicio = null;
	String nombreReporte = null;
	String successView = null;		

 	public DetalleLineaFondeoControlador(){
 		setCommandClass(LineaFondeadorBean.class);
 		setCommandName("lineaFondeador");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		LineaFondeadorBean lineaFondeadorBean = (LineaFondeadorBean) command;
 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
				
		MensajeTransaccionBean mensaje = null;
		mensaje = lineaFondeadorServicio.grabaTransaccion(tipoTransaccion, lineaFondeadorBean);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}

	public LineaFondeadorServicio getLineaFondeadorServicio() {
		return lineaFondeadorServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setLineaFondeadorServicio(
			LineaFondeadorServicio lineaFondeadorServicio) {
		this.lineaFondeadorServicio = lineaFondeadorServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

}
