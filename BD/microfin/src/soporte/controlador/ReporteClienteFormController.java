package soporte.controlador;

import general.bean.ParametrosAuditoriaBean;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.net.URL;
 
import org.pentaho.reporting.engine.classic.core.ClassicEngineBoot;
import org.pentaho.reporting.engine.classic.core.MasterReport;
import org.pentaho.reporting.engine.classic.core.modules.output.table.html.HtmlReportUtil;
import org.pentaho.reporting.libraries.base.util.ObjectUtilities;
import org.pentaho.reporting.libraries.resourceloader.Resource;
import org.pentaho.reporting.libraries.resourceloader.ResourceManager;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.ContratoCredito;
import cliente.bean.ClienteBean;
import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.bean.MenuAplicacionBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.MenuServicio;

@SuppressWarnings("deprecation")
public class ReporteClienteFormController extends SimpleFormController {

	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	public ReporteClienteFormController() {
		setCommandClass(ClienteBean.class);
		setCommandName("cliente");		
	}

	protected ModelAndView onSubmit(Object command,
									BindException bindException)
														throws Exception {
		ClienteBean cliente = (ClienteBean) command;
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("testparam", cliente.getNumero());
		
		String htmlString = Reporte.creaHtmlReporte("cuentas/pardef.prpt", parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());		
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
