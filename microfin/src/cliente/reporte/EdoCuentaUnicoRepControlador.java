package cliente.reporte;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.File;
import java.io.FileInputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.CompaniasBean;
import soporte.servicio.CompaniasServicio;


import cliente.bean.EstadoCuentaUnicoBean;

import cliente.servicio.EdoCuentaUnicoRepServicio;

public class EdoCuentaUnicoRepControlador extends  AbstractCommandController {
			 
	EdoCuentaUnicoRepServicio edoCuentaUnicoRepServicio=null;
	CompaniasBean companiasBean = null;
	CompaniasServicio companiasServicio = null;
	
 	public EdoCuentaUnicoRepControlador(){
 		setCommandClass(EstadoCuentaUnicoBean.class);
 		setCommandName("estadoCuentaUnicoBean");
 	}

 	String successView = null;
 
 	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception { 
 		
 		EstadoCuentaUnicoBean estadoCuentaUnicoBean ;
 		EstadoCuentaUnicoBean cuentaUnicoBean = (EstadoCuentaUnicoBean) command;
 		
 		int tipoConsulta=1;
		int tipoPrefijo = 1;
 		
		//Se consulta el prefijo de la compania
		CompaniasBean prefijoCompania = companiasServicio.consulta(tipoPrefijo, companiasBean);
		
 		String contentOriginal = response.getContentType();
 		estadoCuentaUnicoBean=edoCuentaUnicoRepServicio.consulta(tipoConsulta);
 		cuentaUnicoBean.setRutapdf( estadoCuentaUnicoBean.getRutapdf() + prefijoCompania.getDesplegado().replaceAll("\\s", "")  + "/" );

 		String nombrePdf =
 				cuentaUnicoBean.getRutapdf()+ cuentaUnicoBean.getPeriodo() +
				System.getProperty("file.separator")+ Utileria.completaCerosIzquierda(cuentaUnicoBean.getSucursalOrigen(), 3) +
				System.getProperty("file.separator")+
				Utileria.completaCerosIzquierda(cuentaUnicoBean.getClienteID(),10) +"-"+cuentaUnicoBean.getPeriodo()+".pdf";
 		
 		File pdfFile = new File(nombrePdf);	 		
 		FileInputStream fileInputStream = new FileInputStream(pdfFile);
 		try{	 			 	
 			response.setContentType("application/pdf");
	 		response.addHeader("Content-Disposition","inline; filename=" + "EdoCta" +  Utileria.completaCerosIzquierda(cuentaUnicoBean.getClienteID(),10) + "-" +cuentaUnicoBean.getPeriodo() +".pdf");
	 		
	 		response.setContentLength((int) pdfFile.length()); 	
	 		int bytes;
			while ((bytes = fileInputStream.read()) != -1) {
				response.getOutputStream().write(bytes);
			}
			response.getOutputStream().flush();
			response.getOutputStream().close();
			
			return null;
			
 		}catch (Exception e) {
 			String htmlString = Constantes.htmlErrorEdoCtaPDF;
 			response.addHeader("Content-Disposition","");
	 		response.setContentType(contentOriginal);
	 		response.setContentLength(htmlString.length());
 			return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString); 
		}

 	}
 		
   /* =================== GETTER && SETTERS =========================== */
	public EdoCuentaUnicoRepServicio getEdoCuentaUnicoRepServicio() {
		return edoCuentaUnicoRepServicio;
	}


	public void setEdoCuentaUnicoRepServicio(
			EdoCuentaUnicoRepServicio edoCuentaUnicoRepServicio) {
		this.edoCuentaUnicoRepServicio = edoCuentaUnicoRepServicio;
	}


	public String getSuccessView() {
		return successView;
	}


	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public CompaniasServicio getCompaniasServicio() {
		return companiasServicio;
	}


	public void setCompaniasServicio(CompaniasServicio companiasServicio) {
		this.companiasServicio = companiasServicio;
	}
 	
 }

