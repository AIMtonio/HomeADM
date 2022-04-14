package cuentas.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.FoliosPlanAhorroBean;
import cuentas.servicio.FoliosPlanAhorroServicio;
import general.bean.MensajeTransaccionBean;

public class FoliosPlanAhorroControlador extends SimpleFormController{

	FoliosPlanAhorroServicio foliosPlanAhorroServicio = null;
	
	public FoliosPlanAhorroControlador() {
		setCommandClass(FoliosPlanAhorroBean.class);
		setCommandName("foliosPlanAhorroBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errores) throws Exception{
		foliosPlanAhorroServicio.getFoliosPlanAhorro().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		FoliosPlanAhorroBean folioPlanAhorroBean = (FoliosPlanAhorroBean) command;
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		MensajeTransaccionBean mensaje = null;
		mensaje = foliosPlanAhorroServicio.grabaTransaccion(tipoTransaccion, folioPlanAhorroBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);		
	}

	public FoliosPlanAhorroServicio getFoliosPlanAhorroServicio() {
		return foliosPlanAhorroServicio;
	}

	public void setFoliosPlanAhorroServicio(FoliosPlanAhorroServicio foliosPlanAhorroServicio) {
		this.foliosPlanAhorroServicio = foliosPlanAhorroServicio;
	}
}
