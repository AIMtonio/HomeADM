package regulatorios.reporte;

import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.RepCaptacionPorLocalidad821Bean;
import regulatorios.bean.ReporteRegulatorioBean;
import regulatorios.reporte.RepRegulatorioPorLocalidad821Controlador.Enum_Con_TipReporte;
import regulatorios.servicio.RepRegulatorioCaptacionServicio;

public class RepRegulatorio0815Controlador extends AbstractCommandController{
	RepRegulatorioCaptacionServicio repRegulatorioCaptacionServicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipReporte {
		  int  ReporExcel= 1;
		  int  ReporCsv= 2;
	}
	
	public RepRegulatorio0815Controlador () {
		setCommandClass(ReporteRegulatorioBean.class);
		setCommandName("reporteRegulatorioBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		ReporteRegulatorioBean reporteBean = (ReporteRegulatorioBean) command;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
			0;
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
				0;
					
		String htmlString= "";
	
		switch(tipoReporte){	
		case Enum_Con_TipReporte.ReporExcel:
			 List<ReporteRegulatorioBean>listaReportes = reporteRegulatorio0815(tipoLista,reporteBean,response);
				break;
		case Enum_Con_TipReporte.ReporCsv:		
			repRegulatorioCaptacionServicio.listaReporteRegulatorio(tipoLista,reporteBean,response);
		break;
		}
	
		return null;	
	}
	

	// Reporte de Captacion Trandicional y Prestamo Bancario y de Otros Organismos
	public List<ReporteRegulatorioBean> reporteRegulatorio0815(int tipoLista,ReporteRegulatorioBean reporteBean,  HttpServletResponse response){
		List<ReporteRegulatorioBean> listaRepote = null;
		String mesEnLetras	= "";
		String anio		= "";
		String nombreArchivo = "";
		mesEnLetras = repRegulatorioCaptacionServicio.descripcionMes(reporteBean.getMes());
		anio	= reporteBean.getAnio();
		
		nombreArchivo = "R08 A 0815 "+mesEnLetras +" "+anio; 
		
		listaRepote = repRegulatorioCaptacionServicio.listaReporteRegulatorio(tipoLista, reporteBean, response); 	
		
		int regExport = 0;
		
		// Creacion de Libro
		try {
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			HSSFCellStyle estiloTituloRep = libro.createCellStyle();
			estiloTituloRep.setFont(fuenteNegrita10);
			estiloTituloRep.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			//Estilo negrita de 8 para el  Subtitulo del reporte
			HSSFCellStyle estiloSubtituloRep = libro.createCellStyle();
			estiloSubtituloRep.setFont(fuenteNegrita8);
			estiloSubtituloRep.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			
			//Estilo negrita de 8  para encabezados de datos del reporte
			HSSFCellStyle estiloEncabezado = libro.createCellStyle();
			estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setFont(fuenteNegrita8);
			
			//Estilo negrita de 8  para Conceptos de datos del reporte
			HSSFCellStyle estiloConceptos = libro.createCellStyle();
			estiloConceptos.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			estiloConceptos.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloConceptos.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloConceptos.setFont(fuenteNegrita8);
			
			//Estilo negrita de 8  para el último Concepto de datos del reporte
			HSSFCellStyle estiloUltimoConcepto = libro.createCellStyle();
			estiloUltimoConcepto.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			estiloUltimoConcepto.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloUltimoConcepto.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloUltimoConcepto.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloUltimoConcepto.setFont(fuenteNegrita8);
			
			//Estilo negrita de 8  para el pide de reporte
			HSSFCellStyle estiloPieReporte = libro.createCellStyle();
			estiloPieReporte.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			estiloPieReporte.setFont(fuenteNegrita10);
								
			// Estilo alineado a la derecha
			HSSFCellStyle estiloDatosDerecha = libro.createCellStyle();			
			estiloDatosDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			estiloDatosDerecha.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloDatosDerecha.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			//Estilo Formato decimal (0.00)
			HSSFDataFormat format = libro.createDataFormat();
			estiloDatosDerecha.setDataFormat(format.getFormat("#,##0.00"));

			
			// Estilo alineado a la derecha para el ultimo renglon de la tabla de datos
			HSSFCellStyle estiloUltimoDatoDerecha = libro.createCellStyle();
			estiloUltimoDatoDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			estiloUltimoDatoDerecha.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloUltimoDatoDerecha.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloUltimoDatoDerecha.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
			
			//Estilo negrita de 8  y color de fondo
			HSSFCellStyle estiloColorFondo = libro.createCellStyle();
			estiloColorFondo.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			estiloColorFondo.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			estiloColorFondo.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			estiloColorFondo.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloColorFondo.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloColorFondo.setDataFormat(format.getFormat("#,##0.00")); 
			
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("A 0815");		
					
			HSSFRow filaVacia= hoja.createRow(0);
			filaVacia = hoja.createRow(1);
			
			HSSFRow filaTitulo= hoja.createRow(1);
			HSSFCell celda=filaTitulo.createCell((short)0);			
			celda.setCellValue("Reporte Regulatorio de Captación Tradicional y Préstamos Bancarios y de Otros Organismos");
			celda.setCellStyle(estiloTituloRep);	
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            1, //primera fila (0-based)
		            1, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            9  //ultima celda   (0-based)
		    ));
			
			HSSFRow fila= hoja.createRow(2);
			celda=fila.createCell((short)0);
			celda.setCellValue("Subreporte: Captación Tradicional y Préstamos Bancarios y de Otros Organismos Estratificada por Plazos al Vencimiento y Monto");
			celda.setCellStyle(estiloTituloRep);
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            9  //ultima celda   (0-based)
		    ));
						
			fila = hoja.createRow(3);
			celda=fila.createCell((short)0);
			celda.setCellValue("R08 A 0815");
			celda.setCellStyle(estiloTituloRep);
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            3, //primera fila (0-based)
		            3, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            9  //ultima celda   (0-based)
		    ));
						
			fila = hoja.createRow(4);
			fila = hoja.createRow(5);		
			
			
			fila = hoja.createRow(6);
			celda=fila.createCell((short)1);
			celda.setCellValue("Subreporte: Captación Tradicional y Préstamos Bancarios y de Otros Organismos Estratificada por Plazos al Vencimiento y Monto");
			celda.setCellStyle(estiloSubtituloRep);	
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            6, //primera fila (0-based)
		            6, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            9  //ultima celda   (0-based)
		    ));
			
			fila = hoja.createRow(7);
			celda=fila.createCell((short)1);
			celda.setCellValue("Incluye: Moneda nacional y Udis valorizadas en pesos ");
			celda.setCellStyle(estiloSubtituloRep);
			
			fila = hoja.createRow(8);
			HSSFCell celdaHora=fila.createCell((short)1);
			celdaHora.setCellValue("Cifras en pesos");
			celdaHora.setCellStyle(estiloSubtituloRep);
			
			fila = hoja.createRow(9);

			fila = hoja.createRow(10);
			celda=fila.createCell((short)0);

			celda = fila.createCell((short)1);
			celda.setCellValue("Concepto");
			celda.setCellStyle(estiloEncabezado);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("Saldo al cierre \ndel mes");
			celda.setCellStyle(estiloEncabezado);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Número de cuentas  \no contratos");
			celda.setCellStyle(estiloEncabezado);			

			
			int numeroFila=11   ,iter=0;
			int tamanioLista = listaRepote.size();
			ReporteRegulatorioBean reporteRegBean = null;
			
			for( iter=0; iter<tamanioLista; iter ++){
				reporteRegBean = (ReporteRegulatorioBean) listaRepote.get(iter);
				fila=hoja.createRow(numeroFila);
				
				// Verifica si ya es el ultimo registro
				if(iter + 1 == tamanioLista){					
					celda=fila.createCell((short)1);
					celda.setCellValue(reporteRegBean.getConcepto());
					celda.setCellStyle(estiloConceptos);												
					
					celda=fila.createCell((short)2);
					celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldo()));	
					celda.setCellStyle(estiloDatosDerecha);
									
					celda=fila.createCell((short)3);
					celda.setCellValue(Integer.parseInt(reporteRegBean.getNumCuentas()));		
					celda.setCellStyle(estiloDatosDerecha);
					
					//Fila vacia
					fila=hoja.createRow(++numeroFila);
					celda=fila.createCell((short)1);
					celda.setCellStyle(estiloUltimoConcepto);
					celda=fila.createCell((short)2);
					celda.setCellStyle(estiloUltimoDatoDerecha);									
					celda=fila.createCell((short)3);		
					celda.setCellStyle(estiloUltimoDatoDerecha);
				}else{						
						celda=fila.createCell((short)1);
						celda.setCellValue(reporteRegBean.getConcepto());
						celda.setCellStyle(estiloConceptos);												
						
						// Si no es cero, inserta el saldo
						celda=fila.createCell((short)2);
						if(iter != 0 && iter != 9){
							celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldo()));					
						}
						// Pone el fondo gris de la celda cuando se trata de un total
						if((iter == 1 || iter ==10) && (iter != 0 && iter != 9)){
							celda.setCellStyle(estiloColorFondo);
						}else{
							celda.setCellStyle(estiloDatosDerecha);
						}
										
						// Pone el fondo gris de la celda cuando se trata de un total
						celda=fila.createCell((short)3);
						if(iter != 0 && iter != 9){
							celda.setCellValue(Integer.parseInt(reporteRegBean.getNumCuentas()));					
						}
						// Pone el fondo gris de la celda cuando se trata de un total
						if((iter == 1 || iter ==10) && (iter != 0 && iter != 9)){
							celda.setCellStyle(estiloColorFondo);
						}else{
							celda.setCellStyle(estiloDatosDerecha);
						}
				}
				numeroFila++;
			} 
			
						
			fila=hoja.createRow(numeroFila);
			
			fila=hoja.createRow(++numeroFila);
			celda=fila.createCell((short)1);
			celda.setCellValue("Nota:");
			celda.setCellStyle(estiloPieReporte);	
			
			fila=hoja.createRow(++numeroFila);			
			celda=fila.createCell((short)1);
			celda.setCellValue("1/      Los depósitos a la vista y las cuentas de ahorro se considerarán a plazo de un día.");	
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            32, //primera fila (0-based)
		            32, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            9  //ultima celda   (0-based)
		    ));
			
			fila=hoja.createRow(++numeroFila);
			celda=fila.createCell((short)1);
			celda.setCellValue("Las celdas sombreadas representan celdas invalidadas para las cuales no aplica la información solicitada.");
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            33, //primera fila (0-based)
		            33, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            9  //ultima celda   (0-based)
		    ));

			for(int celd=0; celd<=18; celd++)
			hoja.autoSizeColumn((short)celd);
				
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
		}catch(Exception e){
			e.printStackTrace();
		}//Fin del catch
		return  listaRepote;
	}
	

	public RepRegulatorioCaptacionServicio getRepRegulatorioCaptacionServicio() {
		return repRegulatorioCaptacionServicio;
	}
	public void setRepRegulatorioCaptacionServicio(
			RepRegulatorioCaptacionServicio repRegulatorioCaptacionServicio) {
		this.repRegulatorioCaptacionServicio = repRegulatorioCaptacionServicio;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
}
