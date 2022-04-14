package regulatorios.reporte;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
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

import regulatorios.reporte.DesagregadoC0451RepControlador.Enum_Con_TipReporte;

import regulatorios.bean.RepRegulatorioCaptacion811Bean;
import regulatorios.bean.ReporteRegulatorioBean;
import regulatorios.servicio.RepRegulatorioCaptacionServicio;
   
public class RepRegulatorioCaptacion811Controlador  extends AbstractCommandController{

	RepRegulatorioCaptacionServicio repRegulatorioCaptacionServicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporExcel= 1;
		  int  ReporCsv= 2;
	}
	
	public RepRegulatorioCaptacion811Controlador () {
		setCommandClass(RepRegulatorioCaptacion811Bean.class);
		setCommandName("repRegulatorioCaptacion811Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		

		RepRegulatorioCaptacion811Bean reporteBean = (RepRegulatorioCaptacion811Bean) command;
	
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
				0;
				
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
				0;

		String htmlString= "";
		
			switch(tipoReporte){	
				case Enum_Con_TipRepor.ReporExcel:
					 List<RepRegulatorioCaptacion811Bean>listaReportes = reporteRegulatorioCaptacion811(tipoLista,reporteBean,response);
						break;
				case Enum_Con_TipRepor.ReporCsv:		
					repRegulatorioCaptacionServicio.listaReportesRegulatorios(tipoLista,reporteBean,response);
				break;
				}
			
				return null;	
			}

	// Reporte de saldos capital de credito en excel
	public List<RepRegulatorioCaptacion811Bean> reporteRegulatorioCaptacion811(int tipoLista,RepRegulatorioCaptacion811Bean reporteBean,  
			HttpServletResponse response){
		List listaRepote=null;
		
		String mesEnLetras	= "";
		String anio		= "";
		String nombreArchivo = "";
		
		mesEnLetras = repRegulatorioCaptacionServicio.descripcionMes(reporteBean.getFecha().substring(5,7));
		anio	= reporteBean.getFecha().substring(0,4);
		
		nombreArchivo = "R08 A 0811 "+mesEnLetras +" "+anio; 
		
		listaRepote = repRegulatorioCaptacionServicio.listaReportesRegulatorios(tipoLista, reporteBean, response); 	
		
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
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			//Crea fuente con tamaño 10 para informacion del reporte.
			HSSFFont fuente10= libro.createFont();
			fuente10.setFontHeightInPoints((short)10);
			fuente10.setFontName(HSSFFont.FONT_ARIAL);
			
			//Estilo de 8  para Contenido
			HSSFCellStyle estilo8 = libro.createCellStyle();
			estilo8.setFont(fuente10);
			
			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			

			HSSFCellStyle estiloDatosDerecha = libro.createCellStyle();
			estiloDatosDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);  
			
			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);

			//Estilo negrita de 8  y color de fondo
			HSSFCellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			HSSFDataFormat formato = libro.createDataFormat();
			estiloFormatoDecimal.setFont(fuente10);
			estiloFormatoDecimal.setDataFormat(formato.getFormat("#,##0.00"));
			estiloFormatoDecimal.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo tamaño 8 alineado a la derecha
			HSSFCellStyle estiloTitulo = libro.createCellStyle();
			estiloTitulo.setFont(fuenteNegrita8);
			estiloTitulo.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			//Estilo tamaño 8 alineado a la izquierda
			HSSFCellStyle estiloSubtitulo = libro.createCellStyle();
			estiloSubtitulo.setFont(fuenteNegrita8);
			estiloSubtitulo.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			
			//Estilo negrita tamaño 8 centrado
			HSSFCellStyle estiloEncabezado = libro.createCellStyle();
			estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setFont(fuenteNegrita8);
			
			
			//Estilo de 8  para la Nota
			HSSFCellStyle estiloNota = libro.createCellStyle();
			estiloNota.setFont(fuenteNegrita8);
			estiloNota.setAlignment((short)HSSFCellStyle.ALIGN_JUSTIFY);
			
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("A 0811");
			HSSFRow fila= hoja.createRow(0);
			fila = hoja.createRow(0);
			
			//Encabezados
			HSSFRow filaTitulo= hoja.createRow(0);
			HSSFCell celda=filaTitulo.createCell((short)0);
			celda.setCellValue("Reporte Regulatorio de Captación Tradicional y Préstamos Bancarios y de Otros Organismos");
			celda.setCellStyle(estiloTitulo);
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            0, //primera fila (0-based)
		            0, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            5  //ultima celda   (0-based)
		    ));
			
			fila = hoja.createRow(1);
			celda = fila.createCell((short)0);
			celda.setCellValue("Subreporte: Captación Tradicional y Préstamos Bancarios y de Otros Organismos");
			celda.setCellStyle(estiloTitulo);	
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            1, //primera fila (0-based)
		            1, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            5  //ultima celda   (0-based)
		    ));
			
			fila = hoja.createRow(2);
			celda = fila.createCell((short)0);
			celda.setCellValue("R08 A 0811");
			celda.setCellStyle(estiloTitulo);	
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            5  //ultima celda   (0-based)
		    ));
			
			fila = hoja.createRow(4);
			celda = fila.createCell((short)0);
			celda.setCellValue("Subreporte: Captación Tradicional y Préstamos Bancarios  y de Otros Organismos");
			celda.setCellStyle(estiloSubtitulo);
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            4, //primera fila (0-based)
		            4, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            5  //ultima celda   (0-based)
		    ));
			
			fila = hoja.createRow(5);
			celda = fila.createCell((short)0);
			celda.setCellValue("Incluye: Moneda Nacional y Udis Valorizadas en Pesos");
			celda.setCellStyle(estiloSubtitulo);	
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            5, //primera fila (0-based)
		            5, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            5  //ultima celda   (0-based)
		    ));
			
			fila = hoja.createRow(6);
			celda = fila.createCell((short)0);
			celda.setCellValue("Cifras en Pesos");
			celda.setCellStyle(estiloSubtitulo);
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            6, //primera fila (0-based)
		            6, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            5  //ultima celda   (0-based)
		    ));

			fila = hoja.createRow(8);
			celda = fila.createCell((short)0);
			celda.setCellValue("C o n c e p t o");
			celda.setCellStyle(estiloEncabezado);
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            8, //primera fila (0-based)
		            8, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            0  //ultima celda   (0-based)
		    ));
			
			celda = fila.createCell((short)1);
			celda.setCellValue("Saldo del \ncapital al cierre \ndel mes \n(a)");
			celda.setCellStyle(estiloEncabezado);
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            8, //primera fila (0-based)
		            8, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            1  //ultima celda   (0-based)
		    ));
			
			
			celda = fila.createCell((short)2);
			celda.setCellValue("Saldo de los \nIntereses \ndevengados no \npagados al \ncierre del mes \n(b)");
			celda.setCellStyle(estiloEncabezado);
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            8, //primera fila (0-based)
		            8, //ultima fila  (0-based)
		            2, //primer celda (0-based)
		            2  //ultima celda   (0-based)
		    ));
			
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Saldo al cierre \ndel mes \n (c) = (a) + (b)");
			celda.setCellStyle(estiloEncabezado);
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            8, //primera fila (0-based)
		            8, //ultima fila  (0-based)
		            3, //primer celda (0-based)
		            3  //ultima celda   (0-based)
		    ));
					

			celda = fila.createCell((short)4);
			celda.setCellValue("Intereses del mes \n 1/");
			celda.setCellStyle(estiloEncabezado);
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            8, //primera fila (0-based)
		            8, //ultima fila  (0-based)
		            4, //primer celda (0-based)
		            4  //ultima celda   (0-based)
		    ));
			
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Comisiones del \nmes 2/ ");
			celda.setCellStyle(estiloEncabezado);
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            8, //primera fila (0-based)
		            8, //ultima fila  (0-based)
		            5, //primer celda (0-based)
		            5  //ultima celda   (0-based)
		    ));
			
			
			int numeroFila=10,iter=0;
			int tamanioLista = listaRepote.size();
			RepRegulatorioCaptacion811Bean reporteRegBean = null;
			for( iter=0; iter<tamanioLista; iter ++){
				reporteRegBean = (RepRegulatorioCaptacion811Bean) listaRepote.get(iter);
				fila=hoja.createRow(numeroFila);
				if(iter == 0 || iter== 1 || iter==2 || iter==5 || iter==8 || iter==9 ||iter ==10 || iter==16){
					celda=fila.createCell((short)0);
					celda.setCellValue(reporteRegBean.getConcepto());
					celda.setCellStyle(estiloNeg10);
				}else{
					celda=fila.createCell((short)0);
					celda.setCellValue(reporteRegBean.getConcepto());
				}
				
				
				celda=fila.createCell((short)1);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getSalCapCie()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)2);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getSalIntNoPa()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)3);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getSalCieMes()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)4);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getIntMes()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)5);
				celda.setCellValue(Double.parseDouble(reporteRegBean.getComMes()));
				celda.setCellStyle(estiloFormatoDecimal);
				numeroFila++;
			}

			for(int celd=0; celd<=18; celd++)
			hoja.autoSizeColumn((short)celd);
			
			fila=hoja.createRow(34);			
			celda=fila.createCell((short)0);
			celda.setCellValue("Notas:");	
			celda.setCellStyle(estiloNota);
			
			fila=hoja.createRow(36);			
			celda=fila.createCell((short)0);
			celda.setCellValue("1/  Los intereses del mes incluyen los intereses pagados que forman parte del margen financiero.");	
			celda.setCellStyle(estiloNota);
			hoja.addMergedRegion(new CellRangeAddress(
		            36, //primera fila (0-based)
		            36, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            5  //ultima celda   (0-based)
		    ));
			
			fila=hoja.createRow(37);			
			celda=fila.createCell((short)0);
			celda.setCellValue("2/  Comisiones se refiere a aquellas que forman parte del Margen Financiero y son ajustes al costo de Captación Tradicional / Depósitos");	
			celda.setCellStyle(estiloNota);
			hoja.addMergedRegion(new CellRangeAddress(
		            37, //primera fila (0-based)
		            37, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            5  //ultima celda   (0-based)
		    ));
			
			fila=hoja.createRow(38);			
			celda=fila.createCell((short)0);
			celda.setCellValue("3/ Aplica sólo para las Entidades de Ahorro y Crédito Popular con Nivel de Operaciones IV");	
			celda.setCellStyle(estiloNota);
			hoja.addMergedRegion(new CellRangeAddress(
		            38, //primera fila (0-based)
		            38, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            5  //ultima celda   (0-based)
		    ));
			
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
