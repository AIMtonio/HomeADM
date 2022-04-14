package contabilidad.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.PeriodoContableBean;
import contabilidad.servicio.PeriodoContableServicio;;

public class PeriodoContableControlador extends SimpleFormController {

 	PeriodoContableServicio periodoContableServicio = null;


 	public PeriodoContableControlador(){
 		setCommandClass(PeriodoContableBean.class);
 		setCommandName("periodoContableBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		PeriodoContableBean periodoContableBean = (PeriodoContableBean) command;

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
 								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
 									
 		MensajeTransaccionBean mensaje = null;
 		mensaje = periodoContableServicio.grabaTransaccion(tipoTransaccion, periodoContableBean);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

 	public void setPeriodoContableServicio(PeriodoContableServicio periodoContableServicio){
                     this.periodoContableServicio = periodoContableServicio;
 	}
}