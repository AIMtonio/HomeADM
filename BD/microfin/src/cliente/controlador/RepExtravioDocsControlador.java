package cliente.controlador;

import general.bean.ParametrosSesionBean;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.RepExtravioDocsBean;
import cliente.servicio.RepExtravioDocsServicio;

public class RepExtravioDocsControlador extends AbstractCommandController {
	RepExtravioDocsServicio repExtravioDocsServicio = null;
	ParametrosSesionBean parametrosSesionBean ;
	String nombreReporte = null;
	String successView = null;
	
	public RepExtravioDocsControlador(){
		setCommandClass(RepExtravioDocsBean.class);
		setCommandName("extravioDocsBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
								HttpServletResponse response,
								Object command,
								BindException errores)throws Exception{
		
		RepExtravioDocsBean repExtravioDocsBean = (RepExtravioDocsBean) command;
		
		System.out.println(repExtravioDocsBean.getTipoRep());
		
		ByteArrayOutputStream htmlStringPDF = repExtravioDocsServicio.reporteExtravioDocsPDF(repExtravioDocsBean,nombreReporte,parametrosSesionBean);
		response.addHeader("Content-Disposition","inline; filename=RepExtravioDocumentos.prpt");
		response.setContentType("application/pdf");
		byte[] bytes = htmlStringPDF.toByteArray();
		response.getOutputStream().write(bytes,0,bytes.length);
		response.getOutputStream().flush();
		response.getOutputStream().close();
		
		return null;	
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public RepExtravioDocsServicio getRepExtravioDocsServicio() {
		return repExtravioDocsServicio;
	}

	public void setRepExtravioDocsServicio(
			RepExtravioDocsServicio repExtravioDocsServicio) {
		this.repExtravioDocsServicio = repExtravioDocsServicio;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
