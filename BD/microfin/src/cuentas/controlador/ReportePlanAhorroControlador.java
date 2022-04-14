package cuentas.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.FoliosPlanAhorroBean;
import cuentas.servicio.FoliosPlanAhorroServicio;

public class ReportePlanAhorroControlador extends SimpleFormController{

	FoliosPlanAhorroServicio repMovsPlanAhorroServicio = null;
	
	public ReportePlanAhorroControlador(){
		setCommandClass(FoliosPlanAhorroBean.class);
		setCommandName("foliosPlanAhorroBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errores){
		
		MensajeTransaccionBean mensaje = null;
		
		return new ModelAndView(getSuccessView(),"mensaje",mensaje);
	}

	public FoliosPlanAhorroServicio getRepMovsPlanAhorroServicio() {
		return repMovsPlanAhorroServicio;
	}

	public void setRepMovsPlanAhorroServicio(FoliosPlanAhorroServicio repMovsPlanAhorroServicio) {
		this.repMovsPlanAhorroServicio = repMovsPlanAhorroServicio;
	}
	
}
