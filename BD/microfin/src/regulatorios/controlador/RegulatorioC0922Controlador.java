package regulatorios.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.RegulatorioC0922Bean;
import regulatorios.servicio.RegulatorioC0922Servicio;

public class RegulatorioC0922Controlador extends SimpleFormController{
	RegulatorioC0922Servicio	regulatorioC0922Servicio=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public RegulatorioC0922Controlador(){
		setCommandClass(RegulatorioC0922Bean.class);
		setCommandName("regulatorioC0922");
	} 

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		RegulatorioC0922Bean regulatorioC0922Bean = (RegulatorioC0922Bean) command;
		
		regulatorioC0922Servicio.getRegulatorioC0922DAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		
		int tipoEntidad =(request.getParameter("tipoInstitID")!=null)?
				Integer.parseInt(request.getParameter("tipoInstitID")):0;
		
		MensajeTransaccionBean mensaje = null;
		mensaje = regulatorioC0922Servicio.grabaTransaccion(tipoTransaccion,tipoEntidad,regulatorioC0922Bean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
		

	}

// ------ setter ------------------------
	public void setRegulatorioC0922Servicio(
			RegulatorioC0922Servicio regulatorioC0922Servicio) {
		this.regulatorioC0922Servicio = regulatorioC0922Servicio;
	}
	

}