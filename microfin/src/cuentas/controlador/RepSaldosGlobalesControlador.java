package cuentas.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.RepSaldosGlobalesBean;
import cuentas.servicio.CuentasAhoServicio;
import general.bean.MensajeTransaccionBean;

public class RepSaldosGlobalesControlador extends SimpleFormController {
	
	CuentasAhoServicio cuentasAhoServicio= null;
		
	public RepSaldosGlobalesControlador(){
		setCommandClass(RepSaldosGlobalesBean.class);
		setCommandName("repSaldosGlobalesBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
	
		RepSaldosGlobalesBean repSaldosGlobalesBean = (RepSaldosGlobalesBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion") != null)?
			Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
		int tipoActualizacion = (request.getParameter("tipoActualizacion") != null)?
			Integer.parseInt(request.getParameter("tipoActualizacion"))	: 0;		
					   
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);
		mensaje.setDescripcion("Reporte Saldos Globales");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}
	
	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}

}
