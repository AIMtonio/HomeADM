package credito.controlador;
 
import general.bean.ParametrosAuditoriaBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.ContratoCredito;

import reporte.ParametrosReporte;
import reporte.Reporte;
import cliente.bean.ClienteBean;

public class ReporteContratoFormController extends SimpleFormController {
	
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	public ReporteContratoFormController() {
		setCommandClass(ContratoCredito.class);
		setCommandName("contrato");	
	}

	protected ModelAndView onSubmit(Object command,
									BindException bindException)
														throws Exception {
		ContratoCredito contrato = (ContratoCredito) command;
		
		/*ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("testparam", cliente.getNumero());*/
		
		String htmlString = Reporte.creaHtmlReporte("Contrato.prpt", null, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());		
		return new ModelAndView(getSuccessView(), "reporte", htmlString);
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
	
			
}
