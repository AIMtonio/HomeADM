package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

 
import originacion.bean.SocDemogViviendaBean;
import originacion.servicio.SocDemoViviendaServicio;

public class SocDemoViviendaControlador extends SimpleFormController {
	
	SocDemoViviendaServicio socDemoViviendaServicio=null;
	
	public SocDemoViviendaControlador(){
		setCommandClass(SocDemogViviendaBean.class);
		setCommandName("socDemogViviendaBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		SocDemogViviendaBean socDemogViviendaBean = (SocDemogViviendaBean) command;
		SocDemogViviendaBean SocDemogVivBean = null;
		SocDemogVivBean = socDemoViviendaServicio.restableceParamsConyugue(socDemogViviendaBean, request);
		socDemoViviendaServicio.getSosDemogViviendaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion =(request.getParameter("tipoTransaccionViv")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccionViv")):0;		
				
				
						
		MensajeTransaccionBean mensaje = null;
		mensaje = socDemoViviendaServicio.grabaTransaccion(tipoTransaccion,SocDemogVivBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	
	public void setSocDemoViviendaServicio(SocDemoViviendaServicio socDemoViviendaServicio) {
		this.socDemoViviendaServicio = socDemoViviendaServicio;
	}

}
