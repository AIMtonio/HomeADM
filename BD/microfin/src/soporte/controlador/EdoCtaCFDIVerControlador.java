package soporte.controlador;

import herramientas.Constantes;
import herramientas.Utileria;

import java.io.File;
import java.io.FileInputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.CancelaFacturaBean;
import soporte.bean.CompaniasBean;
import soporte.bean.EdoCtaParamsBean;
import soporte.dao.EdoCtaParamsDAO;
import soporte.servicio.CompaniasServicio;

public class EdoCtaCFDIVerControlador extends AbstractCommandController{

	public EdoCtaCFDIVerControlador(){
		setCommandClass(CancelaFacturaBean.class);
 		setCommandName("cancelaCFDIBean");
	}
	
	CompaniasBean companiasBean = null;
	CompaniasServicio companiasServicio = null;
	EdoCtaParamsDAO edoCtaParamsDAO = null;
	EdoCtaParamsBean edoctaParamsBean = null;
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		CancelaFacturaBean cancelaCFDI = (CancelaFacturaBean) command;
	
		String contentOriginal = response.getContentType();
		
		//Se consulta la rutas para el EdoCta.
		EdoCtaParamsBean rutaPDF = edoCtaParamsDAO.consultaPrincipal(1);
		//Se consulta el prefijo de la empresa necesario para la creacion de directorios
		CompaniasBean desplegadoEmpresa = companiasServicio.consulta(1, companiasBean);
		
		String nombreCompleto =	System.getProperty("file.separator")+ rutaPDF.getRutaExpPDF() +
				System.getProperty("file.separator")+ desplegadoEmpresa.getDesplegado().replaceAll("\\s", "") +
				System.getProperty("file.separator")+ cancelaCFDI.getPeriodo() +
				System.getProperty("file.separator")+ Utileria.completaCerosIzquierda(cancelaCFDI.getSucursalCliente(), 3) +
				System.getProperty("file.separator")+
				Utileria.completaCerosIzquierda(cancelaCFDI.getCliente(),10) +"-"+cancelaCFDI.getPeriodo()+".pdf"; 	
		
		String nomArchivo = Utileria.completaCerosIzquierda(cancelaCFDI.getCliente(),10) +"-"+cancelaCFDI.getPeriodo()+".pdf";
		File archivoFile = new File(nombreCompleto);	 
		try{
	 		FileInputStream fileInputStream = new FileInputStream(archivoFile);
	 		response.setContentType("application/pdf");
	 		response.addHeader("Content-Disposition","inline; filename=" +nomArchivo);
	 		
	 		response.setContentLength((int) archivoFile.length()); 		
	 		int bytes;
	 		
			while ((bytes = fileInputStream.read()) != -1) {
				response.getOutputStream().write(bytes);
			}
	
			response.getOutputStream().flush();
			response.getOutputStream().close();
			
			return null;
			
		}catch (Exception e) {
			e.printStackTrace();
			String htmlString = Constantes.htmlErrorVerArchivoCuenta;
			response.addHeader("Content-Disposition","");
	 		response.setContentType(contentOriginal);
	 		response.setContentLength(htmlString.length());
			return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
		}
	}
	
	public CompaniasServicio getCompaniasServicio() {
		return companiasServicio;
	}
	
	public void setCompaniasServicio(CompaniasServicio companiasServicio) {
		this.companiasServicio = companiasServicio;
	}
	
	public EdoCtaParamsDAO getEdoCtaParamsDAO() {
		return edoCtaParamsDAO;
	}
	
	public void setEdoCtaParamsDAO(EdoCtaParamsDAO edoCtaParamsDAO) {
		this.edoCtaParamsDAO = edoCtaParamsDAO;
	}
}