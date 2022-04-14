package regulatorios.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.servicio.RegulatorioD0842Servicio;
import regulatorios.bean.RegulatorioD0842Bean;

public class RegulatorioD0842Controlador extends SimpleFormController{
	RegulatorioD0842Servicio	regulatorioD0842Servicio=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public RegulatorioD0842Controlador(){
		setCommandClass(RegulatorioD0842Bean.class);
		setCommandName("regulatorioD0842");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		RegulatorioD0842Bean regulatorioD0842Bean = (RegulatorioD0842Bean) command;
		
		regulatorioD0842Servicio.getRegulatorioD0842DAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		
					
		MensajeTransaccionBean mensaje = null;
		mensaje = regulatorioD0842Servicio.grabaTransaccion(tipoTransaccion,regulatorioD0842Bean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}

	public RegulatorioD0842Servicio getRegulatorioD0842Servicio() {
		return regulatorioD0842Servicio;
	}

	public void setRegulatorioD0842Servicio(
			RegulatorioD0842Servicio regulatorioD0842Servicio) {
		this.regulatorioD0842Servicio = regulatorioD0842Servicio;
	}

// ------ setter ------------------------
	
	

}
