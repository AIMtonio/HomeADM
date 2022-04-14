package contabilidad.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import contabilidad.bean.ReportePolizaBean;
import contabilidad.servicio.PolizaServicio;

public class PDFPolizaRepControlador extends AbstractCommandController{
	PolizaServicio polizaServicio = null;
	UsuarioServicio usuarioServicio = null;
	String nombreReporte = null;	
	String successView = null;	

	public static interface Enum_Con_TipRepor {
		int  ReporPDF		= 1 ;
		int  ReporExcel	= 2 ;

	}

	public PDFPolizaRepControlador(){
		setCommandClass(ReportePolizaBean.class);
		setCommandName("reportePolizaBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		ReportePolizaBean reportePolizaBean = (ReportePolizaBean) command;

		int consultar =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
//		System.out.println("Parametro UsuarioID="+request.getParameter("usuarioID"));
//		reportePolizaBean.setUsuarioID((request.getParameter("usuarioID")!=null)?(request.getParameter("usuarioID")):"0");

		String htmlString= "";
				switch(consultar){
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = reportePContablePDF(reportePolizaBean, nombreReporte, response);
					break;
				case Enum_Con_TipRepor.ReporExcel:
					List<ReportePolizaBean>listaReportes = reportePolizaExcel(reportePolizaBean,  response);
					break;
				}
				return null;				
	}

	public ByteArrayOutputStream reportePContablePDF(ReportePolizaBean reportePolizaBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			
			htmlStringPDF = polizaServicio.reportePolizaPDF(reportePolizaBean, nomReporte);
			response.setContentType("application/pdf");
			response.addHeader("Content-Disposition", "inline; filename=PolizaContable.pdf");
			
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return htmlStringPDF;
	}

	// Reporte de balanza contable en Excel
	public List <ReportePolizaBean> reportePolizaExcel(ReportePolizaBean reportePolizaBean,  HttpServletResponse response){
		List<ReportePolizaBean> listaPoliza=null;
		
		listaPoliza = polizaServicio.listaReportePolizaExcel(reportePolizaBean,response); 
		UsuarioBean usuarioBean = new UsuarioBean();
		usuarioBean.setUsuarioID(reportePolizaBean.getUsuarioID());
		
		usuarioBean= usuarioServicio.consulta(1, usuarioBean);
		
		if(listaPoliza != null){
			// Creacion de Libro
			try {
				SXSSFWorkbook libro = new SXSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				Font fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setFontName("Negrita");
				fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);

				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				Font fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setFontName("Negrita");
				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				CellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				estiloNeg10.setAlignment(CellStyle.ALIGN_CENTER);								

				//Estilo negrita de 8  para encabezados del reporte
				CellStyle estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);

				//Estilo negrita de 8  y color de fondo
				CellStyle estiloColor = libro.createCellStyle();
				estiloColor.setFont(fuenteNegrita8);
				//estiloColor.setFillForegroundColor(CellStyle.c);
				estiloColor.setFillPattern(CellStyle.SOLID_FOREGROUND);

				//Estilo Formato decimal (0.00)
				CellStyle estiloFormatoDecimal = libro.createCellStyle();
				DataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("0.00"));					
			
				// Creacion de hoja
				Sheet hoja = libro.createSheet("Reporte de Póliza Contable");
				Row fila= hoja.createRow(0);
				Cell celda=fila.createCell((short)1);

				celda=fila.createCell((short)1);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue(reportePolizaBean.getNombreInstitucion());
				CellRangeAddress region = new CellRangeAddress(0,(short)0,1,(short)7);
				hoja.addMergedRegion(region);
			
				celda=fila.createCell((short)9);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("Usuario: ");

				celda=fila.createCell((short)10);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue(reportePolizaBean.getNombreUsuario());
				
											
				fila = hoja.createRow(1);
				
				celda=fila.createCell((short)9);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("Fecha: ");
				
				celda=fila.createCell((short)10);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue(reportePolizaBean.getFechaEmision());	
				
				fila = hoja.createRow(2);
				
				celda=fila.createCell((short)1);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("Reporte de Póliza Contable");
				region = new CellRangeAddress(2,(short)2,1,(short)7);
				hoja.addMergedRegion(region);
				
				
				celda=fila.createCell((short)9);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("Hora: ");
				
				celda=fila.createCell((short)10);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue(reportePolizaBean.getHora());

				fila = hoja.createRow(3);
				fila = hoja.createRow(4);

				String polizaP =String.valueOf(reportePolizaBean.getPolizaID());
				String transac=String.valueOf(reportePolizaBean.getNumeroTransaccion()) ;
				
				String centroCostos=String.valueOf(reportePolizaBean.getSegundoCentroCostos()) ;
				String tipoInstrumento =String.valueOf(reportePolizaBean.getSegundoRango()) ;
				
				if(polizaP.equals("0")){
					polizaP="TODAS";
				}
				if(transac.equals("0")){
					transac="TODAS";
				}
				
				if(centroCostos.equals("0")){
					centroCostos = "TODOS";
				}else{
					centroCostos = reportePolizaBean.getPrimerCentroCostos()+ " - "+reportePolizaBean.getSegundoCentroCostos();
				}
				
				if(tipoInstrumento.equals("0")){
					tipoInstrumento = "TODOS";
				}
				else{
					tipoInstrumento = reportePolizaBean.getPrimerRango()+ " - " + reportePolizaBean.getSegundoRango();
				}
				
				
				celda=fila.createCell((short)0);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("Fecha Inicial: "+reportePolizaBean.getFechaInicial());
				celda=fila.createCell((short)1);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("Fecha Final: "+reportePolizaBean.getFechaFinal());

				celda=fila.createCell((short)2);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("Póliza: "+polizaP); 				

				celda=fila.createCell((short)3);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("Transacción: "+transac);
/*
				celda=fila.createCell((short)4);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("Sucursal: "+reportePolizaBean.getNombreSucursal());*/

				celda=fila.createCell((short)4);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("Moneda: "+reportePolizaBean.getDescripMoneda());
				
				celda=fila.createCell((short)5);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("Centro de Costos: "+ centroCostos);
				
				celda=fila.createCell((short)6);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("Tipo Instrumento: "+ reportePolizaBean.getDescTipoInstrumento());
				
				celda= fila.createCell((short)7);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("Instrumento: "+ tipoInstrumento );
			
				celda= fila.createCell((short)8);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("Usuario: "+reportePolizaBean.getUsuarioID()+"-"+(Integer.parseInt(reportePolizaBean.getUsuarioID())>0?usuarioBean.getNombreCompleto():"TODOS") );
				

				// Creacion de fila
				fila = hoja.createRow(5);
				fila = hoja.createRow(6);

				//Inicio en la segunda fila y que el fila uno tiene los encabezados
				celda = fila.createCell((short)0);
				celda.setCellValue("Póliza");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Usuario");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("Fecha");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Concepto");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Descripción");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)5);
				celda.setCellValue("Instrumento");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)6);
				celda.setCellValue("No. de Cuenta");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)7);
				celda.setCellValue("Nombre");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("CR");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)9);
				celda.setCellValue("Referencias");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Cargos");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)11);
				celda.setCellValue("Abonos");
				celda.setCellStyle(estiloNeg8);
				
				// Ajuste de columnas
				Utileria.autoAjustaColumnas(12, hoja);
				
				int i=8;
				for(ReportePolizaBean poliza : listaPoliza){
					fila=hoja.createRow(i);
					
					celda=fila.createCell((short)0);
					celda.setCellValue(poliza.getPolizaID());
					
					celda=fila.createCell((short)1);
					celda.setCellValue(poliza.getUsuarioID()+"-"+(reportePolizaBean.getUsuarioID()=="0"?"TODOS":poliza.getNombreUsuario()));
					
					celda=fila.createCell((short)2);
					celda.setCellValue(poliza.getFecha());
					
					celda=fila.createCell((short)3);
					celda.setCellValue(poliza.getConcepto());
					
					celda=fila.createCell((short)4);
					celda.setCellValue(poliza.getDetDescri());
					
					celda=fila.createCell((short)5);
					celda.setCellValue(poliza.getInstrumento());
					
					celda=fila.createCell((short)6);
					celda.setCellValue(poliza.getCuentaCompleta());

					celda=fila.createCell((short)7);
					celda.setCellValue(poliza.getCueDescri());

					celda=fila.createCell((short)8);
					celda.setCellValue(poliza.getCentroCostoID());

					celda=fila.createCell((short)9);
					celda.setCellValue(poliza.getReferencia());

					celda=fila.createCell((short)10);
					celda.setCellValue(Double.parseDouble(poliza.getCargos()));

					celda=fila.createCell((short)11);
					celda.setCellValue(Double.parseDouble(poliza.getAbonos()));
					
					i++;					
					
				}
			
					//Creo la cabecera
					response.addHeader("Content-Disposition","inline; filename=ReportePoliza.xlsx");
					response.setContentType("application/vnd.ms-excel");

					ServletOutputStream outputStream = response.getOutputStream();
					hoja.getWorkbook().write(outputStream);
					outputStream.flush();
					outputStream.close();

					//	log.info("Termina Reporte");
				}
			
			catch(Exception e){
				//	log.info("Error al crear el reporte: " + e.getMessage());
				e.printStackTrace();
			}//Fin del catch
		}
		return  listaPoliza;

	}

	public void setPolizaServicio(PolizaServicio polizaServicio) {
		this.polizaServicio = polizaServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

}
