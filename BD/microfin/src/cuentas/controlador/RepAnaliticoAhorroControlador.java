package cuentas.controlador;




import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.AnaliticoAhorroBean;
import cuentas.servicio.CuentasAhoServicio;

public class RepAnaliticoAhorroControlador extends SimpleFormController {
			
	CuentasAhoServicio cuentasAhoServicio= null;
	
	String nombreReporte = null;
	String successView = null;		

 	public RepAnaliticoAhorroControlador(){
 		setCommandClass(AnaliticoAhorroBean.class);
 		setCommandName("analiticoAhorroBean");
 	}
    
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		AnaliticoAhorroBean analiticoAhorroBean = (AnaliticoAhorroBean) command;
 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
						   Integer.parseInt(request.getParameter("tipoActualizacion"))	:
							   0;		
						   
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte Analitico Ahorro");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public CuentasAhoServicio getCuentasAhoServicio() {
		return cuentasAhoServicio;
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	




}
