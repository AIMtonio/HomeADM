package inversiones.controlador;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import inversiones.bean.BeneficiariosInverBean;
import inversiones.servicio.BeneficiariosInverServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class BeneficiariosInverControlador extends SimpleFormController {

	BeneficiariosInverServicio beneficiariosInverServicio = null;
	
 	public BeneficiariosInverControlador(){
 		setCommandClass(BeneficiariosInverBean.class);
 		setCommandName("beneficiariosInv"); 
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
 	
 		beneficiariosInverServicio.getBeneficiariosInverDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		BeneficiariosInverBean beneficiariosInverBean = (BeneficiariosInverBean) command;
 		int tipoTransaccion =(request.getParameter("tipoTransaccion1")!=null)?
 								Integer.parseInt(request.getParameter("tipoTransaccion1")):0;
 								
 								
		MensajeTransaccionBean mensaje = null;
		mensaje = beneficiariosInverServicio.grabaTransaccion(tipoTransaccion,beneficiariosInverBean);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}

	

	public BeneficiariosInverServicio getBeneficiariosInverServicio() {
		return beneficiariosInverServicio;
	}

	public void setBeneficiariosInverServicio(
			BeneficiariosInverServicio beneficiariosInverServicio) {
		this.beneficiariosInverServicio = beneficiariosInverServicio;
	}



}
