package regulatorios.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioI0391Bean;
import regulatorios.servicio.RegulatorioI0391Servicio;

public class RegulatorioI0391Controlador extends SimpleFormController{
	RegulatorioI0391Servicio	regulatorioI0391Servicio=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public RegulatorioI0391Controlador(){
		setCommandClass(RegulatorioI0391Bean.class);
		setCommandName("regulatorioI0391");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		RegulatorioI0391Bean regulatorioI0391Bean = (RegulatorioI0391Bean) command;
		
		regulatorioI0391Servicio.getRegulatorioI0391DAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		int tipoEntidad = Integer.parseInt(regulatorioI0391Bean.getInstitucionID());
	
				
		MensajeTransaccionBean mensaje = null;
		mensaje = regulatorioI0391Servicio.grabaTransaccion(tipoTransaccion,tipoEntidad,regulatorioI0391Bean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}

// ------ setter ------------------------
	public void setRegulatorioI0391Servicio(
			RegulatorioI0391Servicio regulatorioI0391Servicio) {
		this.regulatorioI0391Servicio = regulatorioI0391Servicio;
	}
	

}
