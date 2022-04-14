package credito.controlador;
   
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosOtorgarBean;
import credito.servicio.CreditosOtorgarServicio;
import credito.servicio.CreditosServicio;

public class CreditosOtorgarControlador extends SimpleFormController {
	CreditosOtorgarServicio creditosOtorgarServicio = null;
	String nombreReporte = null;
	String successView = null;		

 	public CreditosOtorgarControlador(){
 		setCommandClass(CreditosOtorgarBean.class);
 		setCommandName("creditos");
 	}
   
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		CreditosOtorgarBean creditosOtorgarBean = (CreditosOtorgarBean) command;
 		creditosOtorgarServicio.getcreditosOtorgarDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
					
		MensajeTransaccionBean mensaje = null;
		mensaje = creditosOtorgarServicio.grabaTransaccion(tipoTransaccion,creditosOtorgarBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}

 	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public CreditosOtorgarServicio getCreditosOtorgarServicio() {
		return creditosOtorgarServicio;
	}


	public void setCreditosOtorgarServicio(CreditosOtorgarServicio creditosOtorgarServicio) {
		this.creditosOtorgarServicio = creditosOtorgarServicio;
	}


}
