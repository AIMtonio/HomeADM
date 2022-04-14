package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.CuentasBCAMovilBean;
import cliente.servicio.CuentasBCAMovilServicio;

public class CuentasBCAMovilControlador extends SimpleFormController{
	
	CuentasBCAMovilServicio cuentasBCAMovilServicio = null;

 	public CuentasBCAMovilControlador(){
 		setCommandClass(CuentasBCAMovilBean.class);
 		setCommandName("cuentasBCAMovilBean");
 	}
 	
 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		cuentasBCAMovilServicio.getCuentasBCAMovilDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		CuentasBCAMovilBean cuentasBCAMovilBean = (CuentasBCAMovilBean) command;
 	
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
		Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
		
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
				Integer.parseInt(request.getParameter("tipoActualizacion")):0;		
		
		String datosGrid = request.getParameter("datosGridPreguntas");	
				
		MensajeTransaccionBean mensaje = null;
		mensaje = cuentasBCAMovilServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion, cuentasBCAMovilBean,datosGrid);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);


	}
	// ---------------  getter y setter -------------------- 
	public CuentasBCAMovilServicio getCuentasBCAMovilServicio() {
		return cuentasBCAMovilServicio;
	}
	
	public void setCuentasBCAMovilServicio(
			CuentasBCAMovilServicio cuentasBCAMovilServicio) {
		this.cuentasBCAMovilServicio = cuentasBCAMovilServicio;
	}

}
