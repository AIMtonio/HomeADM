package cuentas.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.ComisionesSaldoPromedioBean;
import cuentas.servicio.ComisionesSaldoPromedioServicio;
import general.bean.MensajeTransaccionBean;

public class CondonacionComSalPromControlador extends SimpleFormController{
	
	ComisionesSaldoPromedioServicio comisionesSaldoPromedioServicio = null;
	
	
	public CondonacionComSalPromControlador(){
 		setCommandClass(ComisionesSaldoPromedioBean.class);
 		setCommandName("comisionesSaldoPromedioBean");
 	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,	HttpServletResponse response,
				Object command,	BindException errors) throws Exception {
		
		comisionesSaldoPromedioServicio.getComisionesSaldoPromedioDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ComisionesSaldoPromedioBean comicionesPendientesCobBean = (ComisionesSaldoPromedioBean) command;
				
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
					Integer.parseInt(request.getParameter("tipoActualizacion")):
					0;
						
		MensajeTransaccionBean mensaje = null;
		mensaje = comisionesSaldoPromedioServicio.grabaTransaccion(tipoActualizacion, comicionesPendientesCobBean);
	
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ComisionesSaldoPromedioServicio getComisionesSaldoPromedioServicio() {
		return comisionesSaldoPromedioServicio;
	}

	public void setComisionesSaldoPromedioServicio(ComisionesSaldoPromedioServicio comisionesSaldoPromedioServicio) {
		this.comisionesSaldoPromedioServicio = comisionesSaldoPromedioServicio;
	}
	

		
	
	
	

}
