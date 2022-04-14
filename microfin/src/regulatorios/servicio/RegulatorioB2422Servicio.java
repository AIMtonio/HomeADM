
package regulatorios.servicio;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
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

import regulatorios.bean.RegulatorioB2422Bean;
import regulatorios.dao.RegulatorioB2422DAO;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;


public class RegulatorioB2422Servicio  extends BaseServicio{
	RegulatorioB2422DAO regulatorioB2422DAO = null;	
	
    String[] meses = {"","ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"};
	
	public RegulatorioB2422Servicio() {
		super();
	}
 
	
	/* ================== Tipo de Lista para reportes regulatorios ============== */
	public static interface Enum_Lis_RegulatorioB2422{
		int excel	 = 1;
		int csv		 = 2;
	}	

	/* ============ case para listas de reportes regulatorios ===============*/
	public List <RegulatorioB2422Bean>listaReporteRegulatorioB2422(int tipoLista, int tipoEntidad, RegulatorioB2422Bean reporteBean, HttpServletResponse response){
		List<RegulatorioB2422Bean> listaReportes=null;
		
		/*SOCAP*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch(tipoLista){
				case Enum_Lis_RegulatorioB2422.excel:
					listaReportes = reporteRegulatorioB2422XLSX_SOCAP(Enum_Lis_TipoReporte.excel, reporteBean, response); 
					break;
				case Enum_Lis_RegulatorioB2422.csv:
					listaReportes = generarReporteRegulatorioB2422(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		/*SOFIPO*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_RegulatorioB2422.excel:
					listaReportes = reporteRegulatorioB2422XLSX_SOFIPO(Enum_Lis_TipoReporte.excel, reporteBean, response); 
					break;
				case Enum_Lis_RegulatorioB2422.csv:
					listaReportes = generarReporteRegulatorioB2422(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
	
		return listaReportes;
	}
		
	
	private List<RegulatorioB2422Bean> reporteRegulatorioB2422XLSX_SOCAP(
			int tipoLista, RegulatorioB2422Bean reporteBean,
			HttpServletResponse response) {
		
		List<RegulatorioB2422Bean> listaRegulatorioB2422Bean = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		nombreArchivo 	= "R24_B_2422_"+descripcionMes(reporteBean.getPeriodo())+"_"+reporteBean.getAnio(); 
		
		listaRegulatorioB2422Bean = regulatorioB2422DAO.reporteRegulatorioB2422Socap(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRegulatorioB2422Bean != null){
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
				hoja = (SXSSFSheet) libro.createSheet("B 2422");
				
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
				celda.setCellValue("SECCIÓN UBICACIÓN GEOGRÁFICA");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            3, //primer celda (0-based)
			            4 //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)5);
				celda.setCellValue("SECCIÓN TIPO DE DATOS A REPORTAR");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            5, //primer celda (0-based)
			            6  //ultima celda   (0-based)
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
				celda.setCellValue("MUNICIPIO");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)4);
				celda.setCellValue("ESTADO");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)5);
				celda.setCellValue("TIPO INFORMACIÓN OPERATIVA");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)6);
				celda.setCellValue("NÚMERO TOTAL (DATO) ");
				celda.setCellStyle(estiloEncabezado);
				

					int rowExcel=2;
					contador=2;
					RegulatorioB2422Bean regRegulatorioB2422Bean = null;
					
					for(int x = 0; x< listaRegulatorioB2422Bean.size() ; x++ ){
						
											
						
						fila=hoja.createRow(rowExcel);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(listaRegulatorioB2422Bean.get(x).getPeriodo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(listaRegulatorioB2422Bean.get(x).getClaveEntidad());
						celda.setCellStyle(estilo8);

						
						celda=fila.createCell((short)2);
						celda.setCellValue(listaRegulatorioB2422Bean.get(x).getSubreporte());
						celda.setCellStyle(estilo8);

						
						celda=fila.createCell((short)3);
						celda.setCellValue(Utileria.convierteEntero(listaRegulatorioB2422Bean.get(x).getMunicipio()));
						celda.setCellStyle(estilo8);

						
						celda=fila.createCell((short)4);
						celda.setCellValue(Utileria.convierteEntero(listaRegulatorioB2422Bean.get(x).getEstado()));
						celda.setCellStyle(estilo8);

						
						celda=fila.createCell((short)5);
						celda.setCellValue(Utileria.convierteEntero(listaRegulatorioB2422Bean.get(x).getTipoInformacion()));
						celda.setCellStyle(estilo8);

						
						celda=fila.createCell((short)6);
						celda.setCellValue(Utileria.convierteEntero(listaRegulatorioB2422Bean.get(x).getDato()));
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
		return listaRegulatorioB2422Bean;
	}


	private List<RegulatorioB2422Bean> reporteRegulatorioB2422XLSX_SOFIPO(
			int tipoLista, RegulatorioB2422Bean reporteBean,
			HttpServletResponse response) {
		
		List<RegulatorioB2422Bean> listaRegulatorioB2422Bean = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		nombreArchivo 	= "R24_B_2422_"+descripcionMes(reporteBean.getPeriodo())+"_"+reporteBean.getAnio(); 
		
		listaRegulatorioB2422Bean = regulatorioB2422DAO.reporteRegulatorioB2422Sofipo(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRegulatorioB2422Bean != null){
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
				hoja = (SXSSFSheet) libro.createSheet("B 2422");
				
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
				celda.setCellValue("SECCIÓN UBICACIÓN GEOGRÁFICA");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            3, //primer celda (0-based)
			            6 //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)7);
				celda.setCellValue("SECCIÓN TIPO DE DATOS A REPORTAR");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            7, //primer celda (0-based)
			            8  //ultima celda   (0-based)
			    ));
				
				
				fila = hoja.createRow(1);
				celda=fila.createCell((short)0);
				celda.setCellValue("PERÍODO QUE SE REPORTA");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)1);
				celda.setCellValue("CLAVE DE LA ENTIDAD");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)2);
				celda.setCellValue("REPORTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)3);
				celda.setCellValue("LOCALIDAD");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)4);
				celda.setCellValue("MUNICIPIO");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)5);
				celda.setCellValue("ESTADO");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)6);
				celda.setCellValue("PAÍS");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)7);
				celda.setCellValue("TIPO INFORMACIÓN OPERATIVA");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)8);
				celda.setCellValue("DATO");
				celda.setCellStyle(estiloEncabezado);
				

					int rowExcel=2;
					contador=2;
					RegulatorioB2422Bean regRegulatorioB2422Bean = null;
					
					for(int x = 0; x< listaRegulatorioB2422Bean.size() ; x++ ){
						
											
						
						fila=hoja.createRow(rowExcel);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(listaRegulatorioB2422Bean.get(x).getPeriodo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(listaRegulatorioB2422Bean.get(x).getClaveEntidad());
						celda.setCellStyle(estilo8);

						
						celda=fila.createCell((short)2);
						celda.setCellValue(listaRegulatorioB2422Bean.get(x).getSubreporte());
						celda.setCellStyle(estilo8);

						
						celda=fila.createCell((short)3);
						celda.setCellValue(listaRegulatorioB2422Bean.get(x).getLocalidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(Utileria.convierteEntero(listaRegulatorioB2422Bean.get(x).getMunicipio()));
						celda.setCellStyle(estilo8);

						
						celda=fila.createCell((short)5);
						celda.setCellValue(Utileria.convierteEntero(listaRegulatorioB2422Bean.get(x).getEstado()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(Utileria.convierteEntero(listaRegulatorioB2422Bean.get(x).getPais()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(Utileria.convierteEntero(listaRegulatorioB2422Bean.get(x).getTipoInformacion()));
						celda.setCellStyle(estilo8);

						
						celda=fila.createCell((short)8);
						celda.setCellValue(Utileria.convierteEntero(listaRegulatorioB2422Bean.get(x).getDato()));
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
		return listaRegulatorioB2422Bean;
		
		
	}


	/* ======================================  FUNCIONES PARA GENERAR REPORTES CSV  ========================================*/	
	
	private List generarReporteRegulatorioB2422(RegulatorioB2422Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioB2422DAO.reporteRegulatorioB2422Csv(reporteBean, tipoReporte);
		nombreArchivo="R24_B2422_"+descripcionMes(reporteBean.getPeriodo())+"_"+reporteBean.getAnio()+".csv"; 
		// se inicia seccion para pintar el archivo csv
		try{
			RegulatorioB2422Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioB2422Bean) listaBeans.get(i);
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
	
	public RegulatorioB2422DAO getRegulatorioB2422DAO() {
		return regulatorioB2422DAO;
	}

	public void setRegulatorioB2422DAO(RegulatorioB2422DAO regulatorioB2422DAO) {
		this.regulatorioB2422DAO = regulatorioB2422DAO;
	}

	public String[] getMeses() {
		return meses;
	}

	public void setMeses(String[] meses) {
		this.meses = meses;
	}
	

	
		
}
