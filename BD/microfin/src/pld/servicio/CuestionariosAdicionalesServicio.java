package pld.servicio;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletResponse;

import pld.reporte.PDFIdentiCteRepControlador.Enum_Con_TipRepor;

import cliente.bean.ClienteBean;
import cliente.bean.ReporteClienteBean;
import cliente.servicio.ClienteServicio;
import general.servicio.BaseServicio;

public class CuestionariosAdicionalesServicio extends BaseServicio{
	ClienteServicio clienteServicio = null;
	
	public CuestionariosAdicionalesServicio(){
		super();
	}
	
	public static interface Enum_Con_TipRepor {
		  int  reportePDF	= 1 ;
		  
	}

	public ByteArrayOutputStream cuestionariosAdicionales(ClienteBean cliente, String nombreReporte, HttpServletResponse response, int tipoReporte){
		ByteArrayOutputStream htmlStringPDF = null;
		switch(tipoReporte){
		case Enum_Con_TipRepor.reportePDF:
			htmlStringPDF = cuestionariosAdicionalesPDF(cliente, nombreReporte, response);
		break;
		}
		return htmlStringPDF;
	}
	
	
	public ByteArrayOutputStream cuestionariosAdicionalesPDF(ClienteBean cliente, String nombreReporte, HttpServletResponse response){
		
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			String nombreArchivo = "CuestionarioAdicional_P"+cliente.getTipoPersona()+"_Riesgo"+cliente.getNivelRiesgo()+"_Cliente"+cliente.getClienteID();
			htmlStringPDF = clienteServicio.cuestionariosAdicionalesPDF(cliente, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();

			e.printStackTrace();
		}		
	return htmlStringPDF;
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}
}
