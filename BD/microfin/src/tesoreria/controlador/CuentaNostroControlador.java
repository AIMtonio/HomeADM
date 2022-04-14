package tesoreria.controlador;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

//import soporte.bean.SucursalesBean;
//import soporte.servicio.SucursalesServicio;
import tesoreria.bean.CuentaNostroBean;
//import soporte.servicio.SucursalesServicio;
import tesoreria.servicio.CuentaNostroServicio;

public class CuentaNostroControlador extends SimpleFormController{

  
//	SucursalesServicio sucursalesServicio = null;
	CuentaNostroServicio cuentaNostroServicio =null;
	
	public CuentaNostroControlador() { 
		setCommandClass(CuentaNostroBean.class);
		setCommandName("cuentaNostro"); 
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		CuentaNostroBean cuentaNostroBean = (CuentaNostroBean) command;
	           
        int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
	
		
		MensajeTransaccionBean mensaje = null;
		mensaje = cuentaNostroServicio.grabaTransaccion(tipoTransaccion, cuentaNostroBean);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setCuentaNostroServicio(CuentaNostroServicio cuentaNostroServicio) {
		this.cuentaNostroServicio = cuentaNostroServicio;
	}

}
