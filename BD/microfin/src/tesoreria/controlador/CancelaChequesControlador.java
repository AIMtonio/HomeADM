package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.CancelaChequesBean;
import tesoreria.servicio.CancelaChequesServicio;


public class CancelaChequesControlador extends SimpleFormController{
	
	CancelaChequesServicio  cancelaChequesServicio= null;
	
	public CancelaChequesControlador() {
		setCommandClass(CancelaChequesBean.class);
		setCommandName("cancelaCheques");		
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
			BindException errors) throws Exception {	
		CancelaChequesBean cancelaChequesBean = (CancelaChequesBean) command;

		cancelaChequesServicio.getCancelaChequesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
			Integer.parseInt(request.getParameter("tipoTransaccion")):0;

			MensajeTransaccionBean mensaje = null;
			mensaje = cancelaChequesServicio.grabaTransaccion(cancelaChequesBean, tipoTransaccion);

			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CancelaChequesServicio getCancelaChequesServicio() {
		return cancelaChequesServicio;
	}

	public void setCancelaChequesServicio(
			CancelaChequesServicio cancelaChequesServicio) {
		this.cancelaChequesServicio = cancelaChequesServicio;
	}
	
	
}