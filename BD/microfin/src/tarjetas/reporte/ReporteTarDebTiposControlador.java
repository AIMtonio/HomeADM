
package tarjetas.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.bean.TipoTarjetaDebBean;
import tarjetas.servicio.TarjetaDebitoServicio;
import tarjetas.servicio.TipoTarjetaDebServicio;
import tarjetas.servicio.TarjetaDebitoServicio.Enum_Con_tarjetaDebito;

public class ReporteTarDebTiposControlador  extends AbstractCommandController{

	TipoTarjetaDebServicio  tipoTarjetaDebServicio= null;
	TarjetaDebitoServicio tarjetaDebitoServicio= null;
	
	String nomReporte= null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
		  int ArchLayoutTarSAFI = 2;

		}
	public ReporteTarDebTiposControlador () {
		setCommandClass(TipoTarjetaDebBean.class);
		setCommandName("tipoTarjetaDebBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		TipoTarjetaDebBean tipoTarjetaDebBean = (TipoTarjetaDebBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
		0;
	String loteDebSAFIID =(request.getParameter("loteDebSAFIID")!=null)?request.getParameter("loteDebSAFIID"):"0";
			
	String htmlString= "";
			
		switch(tipoReporte){
			
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = TarDebTiposRepPDF(tipoTarjetaDebBean, nomReporte, response);
			break;
			case Enum_Con_TipRepor.ArchLayoutTarSAFI:
				ByteArrayOutputStream htmlStringLayoutTarSAFI = LayoutTarDebSAFI(loteDebSAFIID, response);
			break;
	
		}
			return null;
		}
			
	// Reporte de vencimientos en pdf
	public ByteArrayOutputStream TarDebTiposRepPDF(TipoTarjetaDebBean tipoTarjetaDebBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = tipoTarjetaDebServicio.creaReporteTarDebTiposPDF(tipoTarjetaDebBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteBitacoraEstatus.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	return htmlStringPDF;
	}
	
	// Layout Tarjeta TGS
	public ByteArrayOutputStream LayoutTarDebSAFI(String LoteDebSAFIID, HttpServletResponse response){
		TarjetaDebitoBean tarjetaDebito = null;
		TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
		tarjetaDebitoBean.setLoteDebitoSAFIID(LoteDebSAFIID);
		tarjetaDebito = tarjetaDebitoServicio.consulta(Enum_Con_tarjetaDebito.conRutaNomArchSAFI, tarjetaDebitoBean);
		ByteArrayOutputStream htmlStringLayout = null;
		
		String rutaConArchivo = tarjetaDebito.getRutaNomArch();
		try {
			String nombreArchivo = rutaConArchivo.substring(rutaConArchivo.lastIndexOf('/') + 1);
			
			File directorioArchivo = new File(rutaConArchivo);
			if (!directorioArchivo.exists()) {
				throw new Exception("No se encontro el archivo layout.");
			}
							
	        FileInputStream archivoLect = new FileInputStream(directorioArchivo);
	        int longitud = archivoLect.available();
	        byte[] datos = new byte[longitud];
	        archivoLect.read(datos);
	        archivoLect.close();
		        
	        directorioArchivo.deleteOnExit();
		    
	        ServletOutputStream ouputStream = null;
	        
	        response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
	    	response.setContentType("application/text;charset=US-ASCII");
	    	response.setCharacterEncoding("US-ASCII");
	    	ouputStream = response.getOutputStream();
	    	
	    	ouputStream.write(datos);   
	    	ouputStream.flush();
	    	ouputStream.close();
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return htmlStringLayout;
	}	
	
	public TarjetaDebitoServicio getTarjetaDebitoServicio() {
		return tarjetaDebitoServicio;
	}

	public void setTarjetaDebitoServicio(TarjetaDebitoServicio tarjetaDebitoServicio) {
		this.tarjetaDebitoServicio = tarjetaDebitoServicio;
	}
	
	public void setTipoTarjetaDebServicio(
			TipoTarjetaDebServicio tipoTarjetaDebServicio) {
		this.tipoTarjetaDebServicio = tipoTarjetaDebServicio;
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
