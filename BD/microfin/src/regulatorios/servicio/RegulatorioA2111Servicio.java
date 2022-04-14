package regulatorios.servicio;

import general.servicio.BaseServicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
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

import regulatorios.bean.RegulatorioA2111Bean;
import regulatorios.dao.RegulatorioA2111DAO;
import regulatorios.servicio.RegulatorioD2443Servicio.Enum_Lis_RegulatorioD2443;


public class RegulatorioA2111Servicio  extends BaseServicio{
	RegulatorioA2111DAO regulatorioA2111DAO = null;	
	
    String[] meses = {"","ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"};
	
	public RegulatorioA2111Servicio() {
		super();
	}

	
	/* ================== Tipo de Lista para reportes regulatorios ============== */

	public static interface Enum_Lis_ReportesA2111{
		int excel	 = 1;
		int csv		 = 2;
	}	
	

	/* ======================================  FUNCIONES PARA GENERAR REPORTES CSV  ========================================*/	
	
	
	public List <RegulatorioA2111Bean>listaReporteRegulatorioA2111(int tipoLista,int tipoEntidad,RegulatorioA2111Bean reporteBean, HttpServletResponse response){
		List<RegulatorioA2111Bean> listaReportes=null;
		
		
		
		/*
		 * SOCAPS
		 */
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch(tipoLista){
				case Enum_Lis_ReportesA2111.excel:
					listaReportes = reporteRegulatorioA2111XLSXSOCAP(Enum_Lis_ReportesA2111.excel,reporteBean,response); // 
					break;
				case Enum_Lis_ReportesA2111.csv:
					listaReportes = generarReporteRegulatorioA2111(reporteBean, Enum_Lis_RegulatorioD2443.csv,  response); 
					break;		
			}
		
		}
		
		/*
		 * SOFIPOS
		 */
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_ReportesA2111.excel:
					listaReportes =reporteRegulatorioA2111XLSXSOFIPO(Enum_Lis_ReportesA2111.excel,reporteBean,response); // 
					break;
				case Enum_Lis_ReportesA2111.csv:
					listaReportes = generarReporteRegulatorioA2111(reporteBean, Enum_Lis_RegulatorioD2443.csv,  response); 
					break;		
			}
		}

		return listaReportes;
	}
	
	
	
	
	
	private List<RegulatorioA2111Bean> reporteRegulatorioA2111XLSXSOFIPO(
			int tipoReporte, RegulatorioA2111Bean reporteBean,
			HttpServletResponse response) {
		
		List listaRepote=null;
		listaRepote = regulatorioA2111DAO.reporteRegulatorioA2111Sofipo(reporteBean,tipoReporte); 	
		
		int regExport = 0;
		
		
		// Creacion de Libro
		try {
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Arial");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Se crea una Fuente tamaño 10 
			HSSFFont fuentetamanio10= libro.createFont();
			fuentetamanio10.setFontHeightInPoints((short)10);
			fuentetamanio10.setFontName("Arial");
			
			//Se crea una Fuente tamaño 10 color blanco
			HSSFFont fuentetamanio10Blanco= libro.createFont();
			fuentetamanio10Blanco.setFontHeightInPoints((short)10);
			fuentetamanio10Blanco.setFontName("Arial");
			fuentetamanio10Blanco.setColor((short)HSSFColor.WHITE.index);
			
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo tamaño 10 alineado a la derecha
			HSSFCellStyle estiloTitulo = libro.createCellStyle();
			estiloTitulo.setFont(fuenteNegrita10);
			estiloTitulo.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			//Estilo tamaño 10 alineado a la izquierda
			HSSFCellStyle estiloSubtitulo = libro.createCellStyle();
			estiloSubtitulo.setFont(fuenteNegrita10);
			estiloSubtitulo.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			
			//Estilo negrita tamaño 10 centrado
			HSSFCellStyle estiloEncabezado = libro.createCellStyle();
			estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
			estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
			estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
			estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
			estiloEncabezado.setFont(fuenteNegrita10);
						
			//Estilo negrita tamaño 10 centrado
			HSSFCellStyle estiloConceptos = libro.createCellStyle();
			estiloConceptos.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			estiloConceptos.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
			estiloConceptos.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
			estiloConceptos.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
			estiloConceptos.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
			estiloConceptos.setWrapText(true);
			
			//Estilo para una celda sin dato con color de fondo gris
			HSSFCellStyle celdaGris = libro.createCellStyle();
			celdaGris.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			celdaGris.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			celdaGris.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
			celdaGris.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
			celdaGris.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
			celdaGris.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
					
						
			//Estilo negritas tamaño 10 alineado a la derecha y con formato moneda
			HSSFCellStyle estiloSaldoNegritas = libro.createCellStyle();
			estiloSaldoNegritas.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			HSSFDataFormat format = libro.createDataFormat();
			estiloSaldoNegritas.setDataFormat(format.getFormat("#,##0.0000"));
			estiloSaldoNegritas.setFont(fuenteNegrita10);
			estiloSaldoNegritas.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
			estiloSaldoNegritas.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
			estiloSaldoNegritas.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
			estiloSaldoNegritas.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
			
			//Estilo tamaño 10 alineado a la derecha y con formato moneda
			HSSFCellStyle estiloSaldo = libro.createCellStyle();
			estiloSaldo.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			estiloSaldo.setDataFormat(format.getFormat("#,##0.0000"));
			estiloSaldo.setFont(fuentetamanio10);			
			estiloSaldo.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
			estiloSaldo.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
			estiloSaldo.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
			estiloSaldo.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
	
											
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("A 2111");		
					
			HSSFRow filaVacia= hoja.createRow(0);			
			HSSFCell celda=filaVacia.createCell((short)0);			
			celda.setCellValue("Sociedades Financieras Populares ");
			celda.setCellStyle(estiloTitulo);	
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            0, //primera fila (0-based)
		            0, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            2  //ultima celda   (0-based)
		    ));
			
			
			filaVacia = hoja.createRow(1);
			
			HSSFRow filaTitulo= hoja.createRow(1);
			celda=filaTitulo.createCell((short)0);			
			celda.setCellValue("Serie R21 Requerimientos de capital");
			celda.setCellStyle(estiloTitulo);	
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            1, //primera fila (0-based)
		            1, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            2  //ultima celda   (0-based)
		    ));
			
			filaTitulo= hoja.createRow(2);
			celda=filaTitulo.createCell((short)0);			
			celda.setCellValue("Reporte A-2111 Requerimientos de capital por riesgos");
			celda.setCellStyle(estiloTitulo);	
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            2  //ultima celda   (0-based)
		    ));
			
			HSSFRow fila= hoja.createRow(3);
			
			fila = hoja.createRow(4);
			celda=fila.createCell((short)0);
			celda.setCellValue("Cifras en pesos");
			celda.setCellStyle(estiloSubtitulo);			

			fila = hoja.createRow(5);
			fila.setHeight((short)1000);
			celda=fila.createCell((short)0);
			celda.setCellValue("\nConcepto\n");
			celda.setCellStyle(estiloEncabezado);
		
			celda=fila.createCell((short)1);
			celda.setCellValue("Montos y Saldos\n Requerimientos \nde Capitalización");
			celda.setCellStyle(estiloEncabezado);
		
			
			celda=fila.createCell((short)2);
			celda.setCellValue("Indicadores \nRequerimientos \nde Capitalización 1/");
			celda.setCellStyle(estiloEncabezado);
			
			
			
			
			
			int numeroFila=6   ,iter=0;
			String formula = "";
			int tamanioLista = listaRepote.size();
			RegulatorioA2111Bean reporteRegBean = null;
			
			for( iter=0; iter<tamanioLista; iter ++){
				reporteRegBean = (RegulatorioA2111Bean) listaRepote.get(iter);
				fila=hoja.createRow(numeroFila);
				
				if(saltoPagina(numeroFila)){
					fila.setHeight((short)700);
				}else{
					fila.setHeight((short)250);
				}
				
				
					celda=fila.createCell((short)1);
					if(reporteRegBean.getColorCeldaSaldo().equalsIgnoreCase("S") ){
						celda.setCellStyle(celdaGris);
					}else{
						if(reporteRegBean.getSaldoEsNegrita().equalsIgnoreCase("S")){
							celda.setCellStyle(estiloSaldoNegritas);
						}else{
							celda.setCellStyle(estiloSaldo);
						}
						
						
						if(!reporteRegBean.getFormulaSaldo().isEmpty()){
							formula = reporteRegBean.getFormulaSaldo();
							celda.setCellType(HSSFCell.CELL_TYPE_FORMULA);
							celda.setCellFormula(formula);
						}else{
							if(!reporteRegBean.getSaldo().isEmpty() && !reporteRegBean.getConcepto().isEmpty()){
								celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldo()));		
							}
						}
				
					}
												
					
					celda=fila.createCell((short)2);
					if(reporteRegBean.getColorCeldaIndicador().equalsIgnoreCase("S") ){
						celda.setCellStyle(celdaGris);
					}else{
						celda.setCellStyle(estiloSaldo);
						if(!reporteRegBean.getFormulaIndicador().isEmpty()){
							formula = reporteRegBean.getFormulaIndicador();
							celda.setCellType(HSSFCell.CELL_TYPE_FORMULA);
							celda.setCellFormula(formula);						
						}else{
							celda.setCellValue(Double.parseDouble(reporteRegBean.getIndicador()));	
						}
					}
					
					
					
					celda=fila.createCell((short)0);
					if(reporteRegBean.getColorCeldaSaldoProm().equalsIgnoreCase("S")){
						celda.setCellStyle(celdaGris);
					}else{
						
						celda.setCellValue(reporteRegBean.getConcepto());			
						celda.setCellStyle(estiloConceptos);
					}
					
												
					
				numeroFila++;
			} 
			
						
			
			fila=hoja.createRow(99);
			celda=fila.createCell((short)0);
			celda.setCellValue("Nota:");
			celda.setCellStyle(estiloSubtitulo);	
			
			fila=hoja.createRow(100);			
			celda=fila.createCell((short)0);
			celda.setCellValue("Las celdas sombreadas representan celdas invalidadas para las cuales no aplica la información solicitada.");	
						
			fila=hoja.createRow(101);
			celda=fila.createCell((short)0);
			celda.setCellValue("1/ Los Indicadores se deben presentar sin el signo \"%\", a 4 decimales y en base 100. Por ejemplo: 20% sería 20.0000.");
			
			fila=hoja.createRow(102);
			celda=fila.createCell((short)0);
			celda.setCellValue("2/ A diferencia de otros reportes en éste, se solicita que la Estimación para riesgos crediticios se presente con signo positivo");
			
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            100, //primera fila (0-based)
		            100, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            2  //ultima celda   (0-based)
		    ));
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            101, //primera fila (0-based)
		            101, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            2  //ultima celda   (0-based)
		    ));
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            102, //primera fila (0-based)
		            102, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            2  //ultima celda   (0-based)
		    ));
	
			hoja.setColumnWidth(0, 20000);
			hoja.autoSizeColumn(1);
			hoja.autoSizeColumn(2);
			
				
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=A 2111 Requerimientos Capital por Riesgos.xls");
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

	private List<RegulatorioA2111Bean> reporteRegulatorioA2111XLSXSOCAP(
			int tipoReporte, RegulatorioA2111Bean reporteBean,
			HttpServletResponse response) {
		
		List listaRepote=null;
		listaRepote = regulatorioA2111DAO.reporteRegulatorioA2111Socap(reporteBean,tipoReporte); 	
		
		int regExport = 0;
		
		
		// Creacion de Libro
		try {
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Arial");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Se crea una Fuente tamaño 10 
			HSSFFont fuentetamanio10= libro.createFont();
			fuentetamanio10.setFontHeightInPoints((short)10);
			fuentetamanio10.setFontName("Arial");
			
			//Se crea una Fuente tamaño 10 color blanco
			HSSFFont fuentetamanio10Blanco= libro.createFont();
			fuentetamanio10Blanco.setFontHeightInPoints((short)10);
			fuentetamanio10Blanco.setFontName("Arial");
			fuentetamanio10Blanco.setColor((short)HSSFColor.WHITE.index);
			
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo tamaño 10 alineado a la derecha
			HSSFCellStyle estiloTitulo = libro.createCellStyle();
			estiloTitulo.setFont(fuenteNegrita10);
			estiloTitulo.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			//Estilo tamaño 10 alineado a la izquierda
			HSSFCellStyle estiloSubtitulo = libro.createCellStyle();
			estiloSubtitulo.setFont(fuenteNegrita10);
			estiloSubtitulo.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			
			//Estilo negrita tamaño 10 centrado
			HSSFCellStyle estiloEncabezado = libro.createCellStyle();
			estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setFont(fuenteNegrita10);
			
			//Estilo negrita tamaño 10 centrado
			HSSFCellStyle estiloConceptos = libro.createCellStyle();
			estiloConceptos.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			estiloConceptos.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloConceptos.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloConceptos.setFont(fuenteNegrita10);
			
			//Estilo para una celda sin dato con color de fondo gris
			HSSFCellStyle celdaGris = libro.createCellStyle();
			celdaGris.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			celdaGris.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			celdaGris.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			celdaGris.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			
			//Estilo para una celda sin dato con color de fondo gris y borde inferior negro
			HSSFCellStyle celdaGrisBorde = libro.createCellStyle();
			celdaGrisBorde.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			celdaGrisBorde.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			celdaGrisBorde.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
			celdaGrisBorde.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			celdaGrisBorde.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
		
			//Estilo para una celda sin dato con color de fondo blanco y borde inferior negro
			HSSFCellStyle celdaBlancaBorde = libro.createCellStyle();
			celdaBlancaBorde.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
			celdaBlancaBorde.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			celdaBlancaBorde.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			
			//Estilo para una celda sin dato con color de fondo gris y borde superior negro
			HSSFCellStyle celdaGrisBordeS = libro.createCellStyle();
			celdaGrisBordeS.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			celdaGrisBordeS.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			celdaGrisBordeS.setBorderTop((short)HSSFCellStyle.BORDER_MEDIUM);
			celdaGrisBordeS.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			celdaGrisBordeS.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
		
			//Estilo para una celda sin dato con color de fondo blanco y borde superior negro
			HSSFCellStyle celdaBlancaBordeS = libro.createCellStyle();
			celdaBlancaBordeS.setBorderTop((short)HSSFCellStyle.BORDER_MEDIUM);
			celdaBlancaBordeS.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			celdaBlancaBordeS.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			
			
			//Estilo negritas tamaño 10 alineado a la derecha y con formato moneda
			HSSFCellStyle estiloSaldoNegritas = libro.createCellStyle();
			estiloSaldoNegritas.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			//Estilo Formato decimal (0.00)
			HSSFDataFormat format = libro.createDataFormat();
			estiloSaldoNegritas.setDataFormat(format.getFormat("#,##0"));
			estiloSaldoNegritas.setFont(fuenteNegrita10);
			
			//Estilo tamaño 10 alineado a la derecha y con formato moneda
			HSSFCellStyle estiloSaldo = libro.createCellStyle();
			estiloSaldo.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			estiloSaldo.setDataFormat(format.getFormat("#,##0"));
			estiloSaldo.setFont(fuentetamanio10);
			
			
			//Estilo negritas tamaño 10 alineado a la derecha y con formato moneda
			HSSFCellStyle estiloIndicadores = libro.createCellStyle();
			estiloIndicadores.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			estiloIndicadores.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloIndicadores.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloIndicadores.setDataFormat(format.getFormat("#,##0.0000"));
			estiloIndicadores.setFont(fuenteNegrita10);
			
											
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("A 2111");		
					
			HSSFRow filaVacia= hoja.createRow(0);
			filaVacia = hoja.createRow(1);
			
			HSSFRow filaTitulo= hoja.createRow(1);
			HSSFCell celda=filaTitulo.createCell((short)0);			
			celda.setCellValue("Reporte Regulatorio Requerimientos de Capital por Riesgos");
			celda.setCellStyle(estiloTitulo);	
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            1, //primera fila (0-based)
		            1, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            2  //ultima celda   (0-based)
		    ));
			
			filaTitulo= hoja.createRow(2);
			celda=filaTitulo.createCell((short)0);			
			celda.setCellValue("Subreporte: Requerimientos de Capital por Riesgos");
			celda.setCellStyle(estiloTitulo);	
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            2  //ultima celda   (0-based)
		    ));
			
			HSSFRow fila= hoja.createRow(3);
			celda=fila.createCell((short)0);
			celda.setCellValue("R21 A 2111");
			celda.setCellStyle(estiloTitulo);
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            3, //primera fila (0-based)
		            3, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            2  //ultima celda   (0-based)
		    ));
			
			fila= hoja.createRow(4);
			fila= hoja.createRow(5);
			celda=fila.createCell((short)0);
			celda.setCellValue("Subreporte: Requerimientos de Capital por Riesgos");
			celda.setCellStyle(estiloSubtitulo);	
			
			fila = hoja.createRow(6);
			celda=fila.createCell((short)0);
			celda.setCellValue("Incluye: Moneda nacional y Udis valorizadas en pesos");
			celda.setCellStyle(estiloSubtitulo);	
			
								
			fila = hoja.createRow(7);
			celda=fila.createCell((short)0);
			celda.setCellValue("Cifras en pesos");
			celda.setCellStyle(estiloSubtitulo);
			
			fila = hoja.createRow(8);	

			fila = hoja.createRow(9);
			celda=fila.createCell((short)0);
			celda.setCellValue("Concepto");
			celda.setCellStyle(estiloEncabezado);
			hoja.addMergedRegion(new CellRangeAddress(
		            9, //primera fila (0-based)
		            11, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            0  //ultima celda   (0-based)
		    ));
			
			celda=fila.createCell((short)1);
			celda.setCellValue("Montos y Saldos Requerimientos \nde Capitalización");
			celda.setCellStyle(estiloEncabezado);
			hoja.addMergedRegion(new CellRangeAddress(
		            9, //primera fila (0-based)
		           11, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            1  //ultima celda   (0-based)
		    ));
			
			celda=fila.createCell((short)2);
			celda.setCellValue("Indicadores \nRequerimientos \nde Capitalización 1/");
			celda.setCellStyle(estiloEncabezado);
			hoja.addMergedRegion(new CellRangeAddress(
		            9, //primera fila (0-based)
		            11, //ultima fila  (0-based)
		            2, //primer celda (0-based)
		            2  //ultima celda   (0-based)
		    ));
			
			
			int numeroFila=12   ,iter=0;
			String formula = "";
			int tamanioLista = listaRepote.size();
			RegulatorioA2111Bean reporteRegBean = null;
			
			for( iter=0; iter<tamanioLista; iter ++){
				reporteRegBean = (RegulatorioA2111Bean) listaRepote.get(iter);
				fila=hoja.createRow(numeroFila);
				 if(iter == 9 || iter == 25 || iter == 48 || iter == 65){
					 	celda=fila.createCell((short)0);			
						celda.setCellStyle(celdaBlancaBorde);
						celda=fila.createCell((short)1);			
						celda.setCellStyle(celdaGrisBorde);
						celda=fila.createCell((short)2);			
						celda.setCellStyle(celdaGrisBorde);
				 }else if(iter == 0 || iter == 50){
					 celda=fila.createCell((short)0);			
						celda.setCellStyle(celdaBlancaBordeS);
						celda=fila.createCell((short)1);			
						celda.setCellStyle(celdaGrisBordeS);
						celda=fila.createCell((short)2);			
						celda.setCellStyle(celdaGrisBordeS);
				 } else{
						celda=fila.createCell((short)0);
						celda.setCellValue(reporteRegBean.getConcepto());			
						celda.setCellStyle(estiloConceptos);
				
						celda=fila.createCell((short)1);
						if(reporteRegBean.getColorCeldaSaldo().equalsIgnoreCase("S") ){
							celda.setCellStyle(celdaGris);
						}else{
							if(reporteRegBean.getSaldoEsNegrita().equalsIgnoreCase("S")){
								celda.setCellStyle(estiloSaldoNegritas);
							}else{
								celda.setCellStyle(estiloSaldo);
							}
							
							
							if(!reporteRegBean.getFormulaSaldo().isEmpty()){
								formula = reporteRegBean.getFormulaSaldo();
								celda.setCellType(HSSFCell.CELL_TYPE_FORMULA);
								celda.setCellFormula(formula);
							}else{
								if(!reporteRegBean.getSaldo().isEmpty() && !reporteRegBean.getConcepto().isEmpty()){
									celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldo()));		
								}
							}
					
						}
													
						
						celda=fila.createCell((short)2);
						if(reporteRegBean.getColorCeldaIndicador().equalsIgnoreCase("S") ){
							celda.setCellStyle(celdaGris);
						}else{
							celda.setCellStyle(estiloIndicadores);
							if(!reporteRegBean.getFormulaIndicador().isEmpty()){
								formula = reporteRegBean.getFormulaIndicador();
								celda.setCellType(HSSFCell.CELL_TYPE_FORMULA);
								celda.setCellFormula(formula);						
							}					
						}
												
				 }	
				numeroFila++;
			} 
			
						
			fila=hoja.createRow(78);
			
			fila=hoja.createRow(79);
			celda=fila.createCell((short)0);
			celda.setCellValue("Nota:");
			celda.setCellStyle(estiloSubtitulo);	
			
			fila=hoja.createRow(80);			
			celda=fila.createCell((short)0);
			celda.setCellValue("1/ Los Indicadores se deben presentar sin el signo '%', a 4 decimales y en base 100. Por ejemplo: 20% sería 20.0000.");	
						
			fila=hoja.createRow(81);
			celda=fila.createCell((short)0);
			celda.setCellValue("2/ A diferencia de otros reportes en este, se solicita que la Estimación para riesgos crediticios se presente con signo positivo.");
			
			fila=hoja.createRow(82);
			celda=fila.createCell((short)0);
			celda.setCellValue("3/ Aplicable sólo para las entidades pertenecientes a nivel III y IV");
			
			fila=hoja.createRow(83);
			celda=fila.createCell((short)0);
			celda.setCellValue("4/ Aplicable sólo para las entidades pertenecientes a nivel IV");
						
			fila=hoja.createRow(86);
			celda=fila.createCell((short)0);
			celda.setCellValue("Los niveles a los que hace referencia el presente reporte corresponden a los niveles de activos totales netos, de conformidad con la regulación prudencial, \n nivel de activos, contenida en el capital");
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            86, //primera fila (0-based)
		            87, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            2  //ultima celda   (0-based)
		    ));
			
			fila=hoja.createRow(89);
			celda=fila.createCell((short)0);
			celda.setCellValue("Las celdas sombreadas representan celdas invalidadas para las cuales no aplica la información solicitada.");

			for(int celd=0; celd<=40; celd++)
			hoja.autoSizeColumn((short)celd);
				
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=A 2111 Requerimientos Capital por Riesgos.xls");
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

	
	
	private List generarReporteRegulatorioA2111(RegulatorioA2111Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioA2111DAO.reporteRegulatorioA2111Csv(reporteBean, tipoReporte);
		nombreArchivo="R20 A 2111 " + meses[Integer.parseInt(reporteBean.getMes())] + " "+reporteBean.getAnio() + ".csv";
		// se inicia seccion para pintar el archivo csv
		try{
			RegulatorioA2111Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioA2111Bean) listaBeans.get(i);
					writer.write(bean.getValor());        
					writer.write("\r\n"); // Esto es un salto de linea		
				}
			}else{
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();
			
		}catch(IOException io ){	
			io.printStackTrace();
		}
		
		return listaBeans;
	}
	
	
	public String descripcionMes(String meses){
		String mes = "";
		int mese = Integer.parseInt(meses);
        switch (mese) {
            case 1:  mes ="ENERO" ; break;
            case 2:  mes ="FEBRERO"; break;
            case 3:  mes ="MARZO"; break;
            case 4:  mes ="ABRIL"; break;
            case 5:  mes ="MAYO"; break;
            case 6:  mes ="JUNIO"; break;
            case 7:  mes ="JULIO"; break;
            case 8:  mes ="AGOSTO"; break;
            case 9:  mes ="SEPTIEMBRE"; break;
            case 10: mes ="OCTUBRE"; break;
            case 11: mes ="NOVIEMBRE"; break;
            case 12: mes ="DICIEMBRE"; break;
        }
        return mes;
	}
	
	
	public boolean saltoPagina(int fila){
		int filas[] = {9,21,26,31,33,43,45,49,50,51,52,53,54,58,59,60,61,69,76,81,82,85,95};
		for(int x = 0; x < filas.length ; x++){
			if(fila == filas[x]){
				return true;
			}
		}
		
		return false;
	}

	/* ========================= GET  &&  SET  =========================*/
	
	public RegulatorioA2111DAO getRegulatorioA2111DAO() {
		return regulatorioA2111DAO;
	}


	public void setRegulatorioA2111DAO(RegulatorioA2111DAO regulatorioA2111DAO) {
		this.regulatorioA2111DAO = regulatorioA2111DAO;
	}


	public String[] getMeses() {
		return meses;
	}


	public void setMeses(String[] meses) {
		this.meses = meses;
	}
	


	
		
}
