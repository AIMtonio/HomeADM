package nomina.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.CalendarioIngresosBean;
import nomina.bean.TipoEmpleadosConvenioBean;
import nomina.servicio.CalendarioIngresosServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class CalendarioIngresosControlador  extends SimpleFormController  {
	CalendarioIngresosServicio calendarioIngresosServicio = null;
	public CalendarioIngresosControlador()
	{
		// TODO Auto-generated constructor stub
				setCommandClass(CalendarioIngresosBean.class);
				setCommandName("calendarioIngresosBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		CalendarioIngresosBean calendarioIngresosBean = (CalendarioIngresosBean) command;
		
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;
		calendarioIngresosServicio.getCalendarioIngresosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionBean mensaje = null;
       
		mensaje = calendarioIngresosServicio.grabaTransaccion(tipoTransaccion, calendarioIngresosBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CalendarioIngresosServicio getCalendarioIngresosServicio() {
		return calendarioIngresosServicio;
	}

	public void setCalendarioIngresosServicio(
			CalendarioIngresosServicio calendarioIngresosServicio) {
		this.calendarioIngresosServicio = calendarioIngresosServicio;
	}
	

}
