package guardaValores.reporte;

import guardaValores.bean.DocumentosGuardaValoresBean;
import guardaValores.servicio.DocumentosGuardaValoresServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class ReporteDocumentosExcelControlador extends AbstractCommandController {

	DocumentosGuardaValoresServicio documentosGuardaValoresServicio = null;
	String nomReporte = null;
	String successView = null;

	public static interface Enum_Rep_Excel {
		int ingresoDocumentos  = 1;
		int estatusDocumentos  = 2;
		int prestamoDocumentos = 3;
		int bitacoraDocumentos = 4;
	}

	public ReporteDocumentosExcelControlador () {
		setCommandClass(DocumentosGuardaValoresBean.class);
		setCommandName("documentosGuardaValoresBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {

		DocumentosGuardaValoresBean documentosGuardaValoresBean = (DocumentosGuardaValoresBean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null) ? Integer.parseInt(request.getParameter("tipoReporte")): 0;

		switch(tipoReporte){
			case Enum_Rep_Excel.ingresoDocumentos:
				documentosGuardaValoresServicio.reporteIngresoDocumentosExcel(documentosGuardaValoresBean, response);
			break;
			case Enum_Rep_Excel.estatusDocumentos:
				documentosGuardaValoresServicio.reporteEstatusDocumentosExcel(documentosGuardaValoresBean, response);
			break;
			case Enum_Rep_Excel.prestamoDocumentos:
				documentosGuardaValoresServicio.reportePrestamoDocumentosExcel(documentosGuardaValoresBean, response);
			break;
			case Enum_Rep_Excel.bitacoraDocumentos:
				documentosGuardaValoresServicio.reporteBitacoraDocumentosExcel(documentosGuardaValoresBean, response);
			break;
		}

		return null;
	}

	public DocumentosGuardaValoresServicio getDocumentosGuardaValoresServicio() {
		return documentosGuardaValoresServicio;
	}

	public void setDocumentosGuardaValoresServicio(DocumentosGuardaValoresServicio documentosGuardaValoresServicio) {
		this.documentosGuardaValoresServicio = documentosGuardaValoresServicio;
	}

	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}
