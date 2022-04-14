package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.DispersionBean;

import tesoreria.bean.DispersionGridBean;
import tesoreria.bean.TesoMovsConciliaBean;
import tesoreria.bean.TesoreriaMovsBean;
import tesoreria.servicio.OperDispersionServicio;


public class OperDispersionControlador extends SimpleFormController {

	OperDispersionServicio operDispersionServicio = null;
	
	public OperDispersionControlador(){
		setCommandClass(DispersionBean.class);
		setCommandName("operDispersion");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		 		
		DispersionBean dispersionBean = (DispersionBean) command;

		operDispersionServicio.getOperDispersionDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
	
		MensajeTransaccionBean mensaje = null;
				
		mensaje = operDispersionServicio.grabaTransaccion(tipoTransaccion, dispersionBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setOperDispersionServicio(OperDispersionServicio operDispersionServicio) {
		this.operDispersionServicio = operDispersionServicio;
	}
}

