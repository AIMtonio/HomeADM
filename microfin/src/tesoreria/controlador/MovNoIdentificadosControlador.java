package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.MovNoIdentificadosBean;
import tesoreria.servicio.MovNoIdentificadosServicio;

public class MovNoIdentificadosControlador extends SimpleFormController {
	
	public MovNoIdentificadosControlador(){
		setCommandClass(MovNoIdentificadosBean.class);
		setCommandName("movNoIdentificadosBean");
	}
	
	MovNoIdentificadosServicio movNoIdentificadosServicio;
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		MovNoIdentificadosBean  movimientos = (MovNoIdentificadosBean)command;
		
		MensajeTransaccionBean mensaje = null;
		
		movNoIdentificadosServicio.getMovNoIdentificadosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion = (request.getParameter("tipoTransaccion")!=null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
			
		mensaje = movNoIdentificadosServicio.grabaTransaccion(tipoTransaccion, movimientos);
		
				
		return  new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setMovNoIdentificadosServicio(MovNoIdentificadosServicio movNoIdentificadosServicio) {
		this.movNoIdentificadosServicio = movNoIdentificadosServicio;
	}
	
}
