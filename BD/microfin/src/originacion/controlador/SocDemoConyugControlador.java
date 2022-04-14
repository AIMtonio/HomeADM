package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

 
import originacion.bean.SocDemConyugBean; 
import originacion.servicio.SocDemoConyugServicio;

public class SocDemoConyugControlador extends SimpleFormController {
	
	SocDemoConyugServicio socDemoConyugServicio=null;
	
	public SocDemoConyugControlador(){
		setCommandClass(SocDemConyugBean.class);
		setCommandName("socDemConyugBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		SocDemConyugBean socDemConyugBean = (SocDemConyugBean) command;
		SocDemConyugBean SocDeConuyuBean = null;
		
		
		
		SocDeConuyuBean = socDemoConyugServicio.restableceParamsConyugue(socDemConyugBean, request);
		socDemoConyugServicio.getSocDemoConyugDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion =(request.getParameter("tipoTransaccionCony")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccionCony")):0;		
				
			
						
		MensajeTransaccionBean mensaje = null;
		mensaje = socDemoConyugServicio.grabaTransaccion(tipoTransaccion,SocDeConuyuBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	
	public void setSocDemoConyugServicio(SocDemoConyugServicio socDemoConyugServicio) {
		this.socDemoConyugServicio = socDemoConyugServicio;
	}

}
