
package regulatorios.servicio;
import general.servicio.BaseServicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;

import regulatorios.bean.RegulatorioD2441Bean;
import regulatorios.dao.RegulatorioD2441DAO;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;


public class RegulatorioD2441Servicio  extends BaseServicio{
	RegulatorioD2441DAO regulatorioD2441DAO = null;	
	
    String[] meses = {"","ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"};
	
	public RegulatorioD2441Servicio() {
		super();
	}

	
	/* ================== Tipo de Lista para reportes regulatorios ============== */
	public static interface Enum_Lis_RegulatorioD2441{
		int excel	 = 1;
		int csv		 = 2;
	}	

	/* ============ case para listas de reportes regulatorios ===============*/
	public List <RegulatorioD2441Bean>listaReporteRegulatorioD2441(int tipoLista, int tipoEntidad, RegulatorioD2441Bean reporteBean, HttpServletResponse response){
		List<RegulatorioD2441Bean> listaReportes=null;
		
		/*SOCAP*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch(tipoLista){
				case Enum_Lis_RegulatorioD2441.excel:
					listaReportes = reporteRegulatorioD2441XLSX_SOCAP(Enum_Lis_TipoReporte.excel, reporteBean, response); 
					break;
				case Enum_Lis_RegulatorioD2441.csv:
					listaReportes = generarReporteRegulatorioD2441(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		/*SOFIPO*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_RegulatorioD2441.excel:
					listaReportes = reporteRegulatorioD2441XLSX_SOFIPO(Enum_Lis_TipoReporte.excel, reporteBean, response); 
					break;
				case Enum_Lis_RegulatorioD2441.csv:
					listaReportes = generarReporteRegulatorioD2441(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		
		return listaReportes;
	}
		
	
	/* ======================================  FUNCIONES PARA GENERAR REPORTES CSV  ========================================*/	
	
	private List<RegulatorioD2441Bean> reporteRegulatorioD2441XLSX_SOFIPO(
			int tipoLista, RegulatorioD2441Bean reporteBean,
			HttpServletResponse response) {
		List<RegulatorioD2441Bean> listaRegulatorioD2441Bean = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		nombreArchivo 	= "R24_D_2441_"+descripcionMes(reporteBean.getPeriodo())+"_"+reporteBean.getAnio(); 
		
		listaRegulatorioD2441Bean = regulatorioD2441DAO.reporteRegulatorioD2441Sofipo(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRegulatorioD2441Bean != null){
			try {
				//////////////////////////////////////////////////////////////////////////////////////
				////////////////////// ENCABEZADO y CONFIGURACION DEL  EXCEL /////////////////////////////////////////
	
				Workbook libro = new SXSSFWorkbook();
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				
				Font fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setFontName("Negrita");
				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				Font fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)8);
				
				//Estilo de 8  para Contenido
				CellStyle estilo8 = libro.createCellStyle();
				estilo8.setFont(fuente8);
				
				//Estilo Formato Tasa (0.0000)
				CellStyle estiloFormatoTasa = libro.createCellStyle();
				DataFormat format = libro.createDataFormat();
				estiloFormatoTasa.setDataFormat(format.getFormat("0.0000"));
				estiloFormatoTasa.setFont(fuente8);
				
				//Encabezado agrupaciones
				CellStyle estiloAgrupacion = libro.createCellStyle();
				estiloAgrupacion.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloAgrupacion.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloAgrupacion.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setFont(fuenteNegrita8);
				estiloAgrupacion.setWrapText(true);
				estiloAgrupacion.setFillBackgroundColor(IndexedColors.GREY_40_PERCENT.getIndex());
				estiloAgrupacion.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
				
				//Estilo negrita tamaño 8 centrado
				CellStyle estiloEncabezado = libro.createCellStyle();
				estiloEncabezado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloEncabezado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezado.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setFont(fuenteNegrita8);
				estiloEncabezado.setWrapText(true);
				
				//Estilo para una celda con dato con color de fondo gris
				CellStyle celdaGrisDato = libro.createCellStyle();
				celdaGrisDato.setFont(fuenteNegrita8);
				celdaGrisDato.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				celdaGrisDato.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				celdaGrisDato.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				celdaGrisDato.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setWrapText(true);
				// Creacion de hoja
				SXSSFSheet hoja = null;
				hoja = (SXSSFSheet) libro.createSheet("D 2441");
				
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				/////////////////////////////////////////////////////////////////////////////////////
				///////////////////////// FIN ENCABEZADO EXCEL //////////////////////////////////////
				//AGREGAR GRUPOS DE COLUMNAS
				//////////////////////////////////////////////////////////////////////////////
				
				celda = fila.createCell((short)0);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL REPORTE");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				
				celda = fila.createCell((short)3);
				celda.setCellValue("SECCIÓN TIPO DE INFORMACIÓN OPERATIVA");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            3, //primer celda (0-based)
			            5 //ultima celda   (0-based)
			    ));
				
				
				celda = fila.createCell((short)6);
				celda.setCellValue("SECCIÓN DE SEGUIMIENTO DE PRODUCTOS DE CAPTACIÓN");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            6, //primer celda (0-based)
			            8 //ultima celda   (0-based)
			    ));
				
				
				fila = hoja.createRow(1);
				celda=fila.createCell((short)0);
				celda.setCellValue("PERÍODO");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)1);
				celda.setCellValue("CLAVE DE LA ENTIDAD");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)2);
				celda.setCellValue("REPORTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)3);
				celda.setCellValue("TIPO DE CUENTA TRANSACCIONAL");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)4);
				celda.setCellValue("CANAL DE LA TRANSACCIÓN");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)5);
				celda.setCellValue("TIPO DE OPERACIÓN REALIZADA POR EL CLIENTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)6);
				celda.setCellValue("MONTO DE LAS OPERACIONES");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)7);
				celda.setCellValue("NÚMERO DE OPERACIONES");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)8);
				celda.setCellValue("NÚMERO DE CLIENTES");
				celda.setCellStyle(estiloEncabezado);
									


					int rowExcel=2;
					contador=2;
					RegulatorioD2441Bean regRegulatorioD2441Bean = null;
					
					for(int x = 0; x< listaRegulatorioD2441Bean.size() ; x++ ){
						
											
						
						fila=hoja.createRow(rowExcel);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(listaRegulatorioD2441Bean.get(x).getPeriodo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(listaRegulatorioD2441Bean.get(x).getClaveEntidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)2);
						celda.setCellValue(listaRegulatorioD2441Bean.get(x).getSubreporte());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)3);
						celda.setCellValue(listaRegulatorioD2441Bean.get(x).getTipoCuentaTrans());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(listaRegulatorioD2441Bean.get(x).getCanalTransaccion());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)5);
						celda.setCellValue(listaRegulatorioD2441Bean.get(x).getTipoOperacion());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(Double.parseDouble(listaRegulatorioD2441Bean.get(x).getMontoOperacion()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(Integer.parseInt(listaRegulatorioD2441Bean.get(x).getNumeroOperaciones()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(Integer.parseInt(listaRegulatorioD2441Bean.get(x).getNumeroClientes()));
						celda.setCellStyle(estilo8);
						

						
						rowExcel++;
						contador++;
					}

							
										
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xlsx");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				libro.write(outputStream);
				outputStream.flush();
				outputStream.close();
			
			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
		}
		return listaRegulatorioD2441Bean;
	}


	private List<RegulatorioD2441Bean> reporteRegulatorioD2441XLSX_SOCAP(
			int tipoLista, RegulatorioD2441Bean reporteBean,
			HttpServletResponse response) {
		List<RegulatorioD2441Bean> listaRegulatorioD2441Bean = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		nombreArchivo 	= "R24_D_2441_"+descripcionMes(reporteBean.getPeriodo())+"_"+reporteBean.getAnio(); 
		
		listaRegulatorioD2441Bean = regulatorioD2441DAO.reporteRegulatorioD2441Socap(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRegulatorioD2441Bean != null){
			try {
				//////////////////////////////////////////////////////////////////////////////////////
				////////////////////// ENCABEZADO y CONFIGURACION DEL  EXCEL /////////////////////////////////////////
	
				Workbook libro = new SXSSFWorkbook();
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				
				Font fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setFontName("Negrita");
				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				Font fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)8);
				
				//Estilo de 8  para Contenido
				CellStyle estilo8 = libro.createCellStyle();
				estilo8.setFont(fuente8);
				
				//Estilo Formato Tasa (0.0000)
				CellStyle estiloFormatoTasa = libro.createCellStyle();
				DataFormat format = libro.createDataFormat();
				estiloFormatoTasa.setDataFormat(format.getFormat("0.0000"));
				estiloFormatoTasa.setFont(fuente8);
				
				//Encabezado agrupaciones
				CellStyle estiloAgrupacion = libro.createCellStyle();
				estiloAgrupacion.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloAgrupacion.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloAgrupacion.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setFont(fuenteNegrita8);
				estiloAgrupacion.setWrapText(true);
				estiloAgrupacion.setFillBackgroundColor(IndexedColors.GREY_40_PERCENT.getIndex());
				estiloAgrupacion.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
				
				//Estilo negrita tamaño 8 centrado
				CellStyle estiloEncabezado = libro.createCellStyle();
				estiloEncabezado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloEncabezado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezado.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setFont(fuenteNegrita8);
				estiloEncabezado.setWrapText(true);
				
				//Estilo para una celda con dato con color de fondo gris
				CellStyle celdaGrisDato = libro.createCellStyle();
				celdaGrisDato.setFont(fuenteNegrita8);
				celdaGrisDato.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				celdaGrisDato.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				celdaGrisDato.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				celdaGrisDato.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setWrapText(true);
			
				// Creacion de hoja
				SXSSFSheet hoja = null;
				hoja = (SXSSFSheet) libro.createSheet("D 2441");
				
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				/////////////////////////////////////////////////////////////////////////////////////
				///////////////////////// FIN ENCABEZADO EXCEL //////////////////////////////////////
				//AGREGAR GRUPOS DE COLUMNAS
				//////////////////////////////////////////////////////////////////////////////
				celda = fila.createCell((short)0);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL REPORTE");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				
				celda = fila.createCell((short)3);
				celda.setCellValue("SECCIÓN TIPO DE INFORMACIÓN OPERATIVA");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            3, //primer celda (0-based)
			            5 //ultima celda   (0-based)
			    ));
				
				
				celda = fila.createCell((short)6);
				celda.setCellValue("SECCIÓN DE SEGUIMIENTO DE PRODUCTOS DE CAPTACIÓN");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            6, //primer celda (0-based)
			            8 //ultima celda   (0-based)
			    ));
				
				
				fila = hoja.createRow(1);
				celda=fila.createCell((short)0);
				celda.setCellValue("PERÍODO QUE SE REPORTA");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)1);
				celda.setCellValue("CLAVE DE LA ENTIDAD");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)2);
				celda.setCellValue("SUBREPORTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)3);
				celda.setCellValue("TIPO DE CUENTA TRANSACCIONAL");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)4);
				celda.setCellValue("CANAL DE LA TRANSACCIÓN");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)5);
				celda.setCellValue("TIPO DE OPERACIÓN REALIZADA POR EL SOCIO O CLIENTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)6);
				celda.setCellValue("MONTO DE LAS OPERACIONES");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)7);
				celda.setCellValue("NÚMERO DE OPERACIONES");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)8);
				celda.setCellValue("NÚMERO DE SOCIOS O CLIENTES");
				celda.setCellStyle(estiloEncabezado);
									


					int rowExcel=2;
					contador=2;
					RegulatorioD2441Bean regRegulatorioD2441Bean = null;
					
					for(int x = 0; x< listaRegulatorioD2441Bean.size() ; x++ ){
						
											
						
						fila=hoja.createRow(rowExcel);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(listaRegulatorioD2441Bean.get(x).getPeriodo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(listaRegulatorioD2441Bean.get(x).getClaveEntidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)2);
						celda.setCellValue(listaRegulatorioD2441Bean.get(x).getSubreporte());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)3);
						celda.setCellValue(listaRegulatorioD2441Bean.get(x).getTipoCuentaTrans());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(listaRegulatorioD2441Bean.get(x).getCanalTransaccion());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)5);
						celda.setCellValue(listaRegulatorioD2441Bean.get(x).getTipoOperacion());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(Double.parseDouble(listaRegulatorioD2441Bean.get(x).getMontoOperacion()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(Integer.parseInt(listaRegulatorioD2441Bean.get(x).getNumeroOperaciones()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(Integer.parseInt(listaRegulatorioD2441Bean.get(x).getNumeroClientes()));
						celda.setCellStyle(estilo8);
						

						
						rowExcel++;
						contador++;
					}

							
										
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xlsx");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				libro.write(outputStream);
				outputStream.flush();
				outputStream.close();
			
			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
		}
		return listaRegulatorioD2441Bean;
	}


	private List generarReporteRegulatorioD2441(RegulatorioD2441Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioD2441DAO.reporteRegulatorioD2441Csv(reporteBean, tipoReporte);
		nombreArchivo="R24_D2441_"+descripcionMes(reporteBean.getPeriodo())+"_"+reporteBean.getAnio()+".csv"; 
		// se inicia seccion para pintar el archivo csv
		try{
			RegulatorioD2441Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioD2441Bean) listaBeans.get(i);
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
	
	public String descripcionMes(String periodo){
		String mes = "";
		int mese = Integer.parseInt(periodo);
        switch (mese) {
            case 1:  mes ="MARZO" ; break;
            case 2:  mes ="JUNIO"; break;
            case 3:  mes ="SEPTIEMBRE"; break;
            case 4:  mes ="DICIEMBRE"; break;
     
        }
        return mes;
	}
	/* ========================= GET  &&  SET  =========================*/
	
	public RegulatorioD2441DAO getRegulatorioD2441DAO() {
		return regulatorioD2441DAO;
	}

	public void setRegulatorioD2441DAO(RegulatorioD2441DAO regulatorioD2441DAO) {
		this.regulatorioD2441DAO = regulatorioD2441DAO;
	}

	public String[] getMeses() {
		return meses;
	}

	public void setMeses(String[] meses) {
		this.meses = meses;
	}
	

	
		
}
