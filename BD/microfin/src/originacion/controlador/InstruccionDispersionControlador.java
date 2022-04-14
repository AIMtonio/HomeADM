package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.InstruccionDispersionBean;

import originacion.servicio.InstruccionDispersionServicio;

public class InstruccionDispersionControlador extends SimpleFormController {
	InstruccionDispersionServicio instruccionDispersionServicio = null;

	public InstruccionDispersionControlador(){
		setCommandClass(InstruccionDispersionBean.class);
		setCommandName("instruccionDispersion");
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		InstruccionDispersionBean instruccionDispersionBean = (InstruccionDispersionBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
							Integer.parseInt(request.getParameter("tipoTransaccion")):0;

		String altainstruccionDispersion = (request.getParameter("datosGridEsquema")!=null)?
									request.getParameter("datosGridEsquema"):"";	
									
		MensajeTransaccionBean mensaje = null;
		
		mensaje = instruccionDispersionServicio.grabaTransaccion(tipoTransaccion,altainstruccionDispersion,instruccionDispersionBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	//----------- setter------------
	public void setEsquemaAutorizaServicio(
			InstruccionDispersionServicio esquemaAutorizaServicio) {
		this.instruccionDispersionServicio = esquemaAutorizaServicio;
	}
	
	

}
