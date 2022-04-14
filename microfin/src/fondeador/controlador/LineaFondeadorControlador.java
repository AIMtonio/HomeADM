package fondeador.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fondeador.bean.LineaFondeadorBean;
import fondeador.servicio.LineaFondeadorServicio;

public class LineaFondeadorControlador extends SimpleFormController {

	LineaFondeadorServicio lineaFondeadorServicio = null;
	
	public LineaFondeadorControlador() {
		setCommandClass(LineaFondeadorBean.class);
		setCommandName("lineaFondeo");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		lineaFondeadorServicio.getLineaFondeadorDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		LineaFondeadorBean lineaFond = (LineaFondeadorBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = lineaFondeadorServicio.grabaTransaccion(tipoTransaccion, lineaFond);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setLineaFondeadorServicio(
			LineaFondeadorServicio lineaFondeadorServicio) {
		this.lineaFondeadorServicio = lineaFondeadorServicio;
	}
}
