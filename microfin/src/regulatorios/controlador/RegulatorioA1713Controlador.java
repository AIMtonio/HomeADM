package regulatorios.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioA1713Bean;
import regulatorios.servicio.RegulatorioA1713Servicio;

public class RegulatorioA1713Controlador extends SimpleFormController{
	RegulatorioA1713Servicio	regulatorioA1713Servicio=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public RegulatorioA1713Controlador(){
		setCommandClass(RegulatorioA1713Bean.class);
		setCommandName("regulatorioA1713");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		RegulatorioA1713Bean regulatorioA1713Bean = (RegulatorioA1713Bean) command;
		
		regulatorioA1713Servicio.getRegulatorioA1713DAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		
		int tipoEntidad =(request.getParameter("tipoInstitID")!=null)?
				Integer.parseInt(request.getParameter("tipoInstitID")):0;
		
		MensajeTransaccionBean mensaje = null;
		mensaje = regulatorioA1713Servicio.grabaTransaccion(tipoTransaccion,tipoEntidad,regulatorioA1713Bean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
		

	}

// ------ setter ------------------------
	public void setRegulatorioA1713Servicio(
			RegulatorioA1713Servicio regulatorioA1713Servicio) {
		this.regulatorioA1713Servicio = regulatorioA1713Servicio;
	}
	

}