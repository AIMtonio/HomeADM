package regulatorios.servicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
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

import regulatorios.bean.RepRegCatalogoMinimoBean;
import regulatorios.dao.RepRegCatalogoMinimoDAO;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;

import general.servicio.BaseServicio;
import herramientas.Constantes;

public class RepRegCatalogoMinimoServicio extends	BaseServicio{

	RepRegCatalogoMinimoDAO repRegCatalogoMinimoDAO = null;
	String transaccion ="0";
	String dia="";
	String anio="";
	String fecha="";
	String fechaFin="";
	String diaFin="";
	String mesFin="";
	String anioFin="";

	private RepRegCatalogoMinimoServicio(){
		super();
	}

	public static interface Enum_Lis_RepRegCatalogoMinimo{
		int reporteExcel 	= 1;
		int reporteTxt 		= 2;
	}
	
	public static interface Enum_Lis_RepRegCatalogoMinimover2015{
		int excel 	= 1;
		int cvs		= 2;
	}

	public List listaReportesVer2015(int tipoLista,int tipoEntidad, RepRegCatalogoMinimoBean repRegCatalogoMinimoBean, int version,  HttpServletResponse response){
		List listaRepReg =null;
	
		/*SOCAP*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaRepReg = reporteRegCatalogoMinimoExcelSOCAP( repRegCatalogoMinimoBean, Enum_Lis_TipoReporte.excel,response ,version); 
					break;
				case Enum_Lis_TipoReporte.csv:
					listaRepReg = reporteRegCatalogoMinimoCVS2015(repRegCatalogoMinimoBean, Enum_Lis_TipoReporte.csv,response ,version);
					break;		
			}
		}
		
		/*SOFIPO*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaRepReg = reporteRegCatalogoMinimoExcelSOFIPO( repRegCatalogoMinimoBean, Enum_Lis_TipoReporte.excel,response ,version);
					break;
				case Enum_Lis_TipoReporte.csv:
					listaRepReg = reporteRegCatalogoMinimoCVS2015(repRegCatalogoMinimoBean, Enum_Lis_TipoReporte.csv,response ,version);
					break;		
			}
		}
		
		return listaRepReg;
		
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
	
	// =============================== C S V =========================================== //

	public List  reporteRegCatalogoMinimoCVS2015(RepRegCatalogoMinimoBean repRegCatalogoMinimoBean, int tipoLista, HttpServletResponse response, int version){
		String mesEnLetras	= "";
		String anio		= "";
		String nombreArchivo = "";
		mesEnLetras = descripcionMes(repRegCatalogoMinimoBean.getMes());
		anio	= repRegCatalogoMinimoBean.getAnio();
		
		nombreArchivo = "R01_A_0111_"+mesEnLetras +"_"+anio+".csv"; 
		List listaRepRegulatorio = null;
		/*Se hace la llamada para obtener la lista para llenar el reporte*/
		listaRepRegulatorio = repRegCatalogoMinimoDAO.regCatalogoMinimoCSVVersion2015(repRegCatalogoMinimoBean,tipoLista,  version); 	
		// se inicia seccion para pintar el archivo txt
		try{
			RepRegCatalogoMinimoBean catalogoMinimoBean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaRepRegulatorio.isEmpty()){
				for(int i=0; i < listaRepRegulatorio.size(); i++){
					catalogoMinimoBean = (RepRegCatalogoMinimoBean) listaRepRegulatorio.get(i);
					writer.write(catalogoMinimoBean.getValor());        
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
		return  listaRepRegulatorio;	
	} // fin de metodo reporteRegCatalogoMinimoTxt

	
	
	
	// ================================ S O C A P ======================================= //
	public List  reporteRegCatalogoMinimoExcelSOCAP(RepRegCatalogoMinimoBean repRegCatalogoMinimoBean,int tipoLista, HttpServletResponse response, int version){
		String mesEnLetras	= "";
		String anio		= "";
		String nombreArchivo = "";
		mesEnLetras = descripcionMes(repRegCatalogoMinimoBean.getMes());
		anio	= repRegCatalogoMinimoBean.getAnio();
		
		nombreArchivo = "R01_A_0111_"+mesEnLetras +"_"+anio; 
		
		List listaRepRegulatorio = null;
		/*Se hace la llamada para obtener la lista para llenar el reporte*/
		listaRepRegulatorio = repRegCatalogoMinimoDAO.regCatalogoMinimoVersionSOCAP(repRegCatalogoMinimoBean, tipoLista, version);
	
		try {
			HSSFWorkbook libro = new HSSFWorkbook();
			
			/* ------------------------  SE CREAN LOS ESTILOS QUE SE USARAN EN EL REPORTE ------------------------ */
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont estilo10= libro.createFont();
			estilo10.setFontHeightInPoints((short)10);
			
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita11= libro.createFont();
			fuenteNegrita11.setFontHeightInPoints((short)11);
			fuenteNegrita11.setFontName("Negrita");
			fuenteNegrita11.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.

			//Estilo tamaño de 10 para el titulo del reporte
			HSSFCellStyle estiloTam10 = libro.createCellStyle();
			estiloTam10.setFont(estilo10);
			
			//Estilo negrita de 10 para el titulo del reporte
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 11 para el titulo del reporte
			HSSFCellStyle estiloNeg11 = libro.createCellStyle();
			estiloNeg11.setFont(fuenteNegrita11);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);

			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 alineda a la derecha 
			HSSFCellStyle estiloNeg10Der = libro.createCellStyle();
			estiloNeg10Der.setFont(fuenteNegrita10);
			estiloNeg10Der.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			// crea formato datos 
			HSSFDataFormat format = libro.createDataFormat();
			
			//Estilo negrita de 8  y color de fondo
			HSSFCellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

			//Estilo negrita de 10  y color de fondo y formato decimal
			HSSFCellStyle estiloColorDecimal = libro.createCellStyle();
			estiloColorDecimal.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			estiloColorDecimal.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			estiloColorDecimal.setFont(fuenteNegrita10);
			estiloColorDecimal.setDataFormat(format.getFormat("#,##0.00"));

			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			estiloFormatoDecimal.setDataFormat(format.getFormat("#,##0.00"));
			
			//centrado
			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			// Creacion de hoja
			HSSFSheet hoja = libro.createSheet("CAT MINIMO EXCEL");
			
			// se crea la primer fila
			HSSFRow fila= hoja.createRow(0);
			HSSFCell celda;
			celda = fila.createCell((short)7);
			celda.setCellValue("Reporte Regulatorio: Catálogo Mínimo");
			celda.setCellStyle(estiloNeg10Der);	
			  
			fila = hoja.createRow(1);
			celda = fila.createCell((short)7);
			celda.setCellValue("Subreporte: Catálogo Mínimo");
			celda.setCellStyle(estiloNeg10Der);	
			
			fila = hoja.createRow(2);
			celda = fila.createCell((short)7);
			celda.setCellValue("R01 A 0111");
			celda.setCellStyle(estiloNeg10Der);	
			
			fila = hoja.createRow(3);
			fila = hoja.createRow(4);
			celda = fila.createCell((short)0);
			celda.setCellValue("Subreporte: Catálogo Mínimo");
			celda.setCellStyle(estiloNeg10);
			
			fila = hoja.createRow(5);
			celda = fila.createCell((short)0);
			celda.setCellValue("Cifras en pesos: Incluye cifras en Moneda nacional, Udis valorizadas en pesos");
			celda.setCellStyle(estiloNeg10);
			
			fila = hoja.createRow(6);
			fila = hoja.createRow(7);
			fila = hoja.createRow(8);
			celda = fila.createCell((short)0);
			celda.setCellValue("CATÁLOGO MÍNIMO PARA SOCIEDADES COOPERATIVAS DE AHORRO Y PRESTAMO CON NIVEL DE OPERACIONES DE I AL IV");
			celda.setCellStyle(estiloNeg11);			
			// fila inicial, fila final, columna inicial, columna final 
			hoja.addMergedRegion(new CellRangeAddress(8, 8, 0, 7));
			
			fila = hoja.createRow(9);
			fila = hoja.createRow(10);
			fila = hoja.createRow(11);			
			
			int i=12,iter=0;
			int columnasVacias	= 0, maxEspacios= 0, combinarCeldas = 0;
			int tamanioLista=listaRepRegulatorio.size();

			RepRegCatalogoMinimoBean catalogoMinimoBean=null;
			for(iter=0; iter<tamanioLista; iter ++ ){
				catalogoMinimoBean= (RepRegCatalogoMinimoBean)listaRepRegulatorio.get(iter);
				
				columnasVacias = (catalogoMinimoBean.getEspacios()!=null)?
									Integer.parseInt(catalogoMinimoBean.getEspacios()):
														0;
				maxEspacios = (catalogoMinimoBean.getMaxEspacios()!=null)?
						Integer.parseInt(catalogoMinimoBean.getMaxEspacios()):
											0;
				combinarCeldas = (catalogoMinimoBean.getCombinarCeldas()!=null)?
						Integer.parseInt(catalogoMinimoBean.getCombinarCeldas()):
											1;
						
				fila=hoja.createRow(i);
				celda=fila.createCell((short)columnasVacias+0);
				celda.setCellValue(catalogoMinimoBean.getDescripcion());
				if(catalogoMinimoBean.getNegrita()!=null &&
						catalogoMinimoBean.getNegrita().equals(Constantes.STRING_SI)){
					celda.setCellStyle(estiloNeg10);
				}
				
				if(combinarCeldas > 1 ){
					// fila inicial, fila final, columna inicial, columna final 
					hoja.addMergedRegion(new CellRangeAddress(i, i, columnasVacias+0, columnasVacias+combinarCeldas-1));
				}
				
				celda=fila.createCell((short)0+maxEspacios);
				if(catalogoMinimoBean.getMonto()!=null &&
						!catalogoMinimoBean.getMonto().isEmpty()){
					celda.setCellValue(Double.parseDouble(catalogoMinimoBean.getMonto()));
					celda.setCellStyle(estiloFormatoDecimal);
				}else{
					 celda.setCellValue(catalogoMinimoBean.getMonto());
				}
				
				if(catalogoMinimoBean.getSombreado()!=null &&
						catalogoMinimoBean.getSombreado().equals("S")){
					celda.setCellStyle(estiloColorDecimal);
				}
				i++;
			}
			 
			hoja.autoSizeColumn((short)maxEspacios);
					
			fila = hoja.createRow(i+3);
			celda = fila.createCell((short)1);
			celda.setCellValue("(1)");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)2);
			celda.setCellValue("Rubros aplicables únicamente para sociedades financieras populares.");
			celda.setCellStyle(estiloTam10);
			
			fila = hoja.createRow(i+4);
			celda = fila.createCell((short)1);
			celda.setCellValue("(2)");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)2);
			celda.setCellValue("Rubros aplicables únicamente para sociedades cooperativas de ahorro y préstamo.");
			celda.setCellStyle(estiloTam10);
			
			
			
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
		return  listaRepRegulatorio;	
	} // fin reporteRegCatalogoMinimoExcel
	
	
	// ========================================= S O F I P O ===================================== //
	
	
	public List  reporteRegCatalogoMinimoExcelSOFIPO(RepRegCatalogoMinimoBean repRegCatalogoMinimoBean,int tipoLista, HttpServletResponse response, int version){
		String mesEnLetras	= "";
		String anio		= "";
		String nombreArchivo = "";
		mesEnLetras = descripcionMes(repRegCatalogoMinimoBean.getMes());
		anio	= repRegCatalogoMinimoBean.getAnio();
		
		nombreArchivo = "R01_A_0111_"+mesEnLetras +"_"+anio; 
		
		List listaRepRegulatorio = null;
		/*Se hace la llamada para obtener la lista para llenar el reporte*/
		listaRepRegulatorio = repRegCatalogoMinimoDAO.regCatalogoMinimoVersionSOFIPO(repRegCatalogoMinimoBean, tipoLista, version);
	
		try {
			HSSFWorkbook libro = new HSSFWorkbook();
			
			/* ------------------------  SE CREAN LOS ESTILOS QUE SE USARAN EN EL REPORTE ------------------------ */
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont estilo10= libro.createFont();
			estilo10.setFontHeightInPoints((short)10);
			
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita11= libro.createFont();
			fuenteNegrita11.setFontHeightInPoints((short)11);
			fuenteNegrita11.setFontName("Negrita");
			fuenteNegrita11.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.

			//Estilo tamaño de 10 para el titulo del reporte
			HSSFCellStyle estiloTam10 = libro.createCellStyle();
			estiloTam10.setFont(estilo10);
			
			//Estilo negrita de 10 para el titulo del reporte
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 11 para el titulo del reporte
			HSSFCellStyle estiloNeg11 = libro.createCellStyle();
			estiloNeg11.setFont(fuenteNegrita11);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);

			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 alineda a la derecha 
			HSSFCellStyle estiloNeg10Der = libro.createCellStyle();
			estiloNeg10Der.setFont(fuenteNegrita10);
			estiloNeg10Der.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			// crea formato datos 
			HSSFDataFormat format = libro.createDataFormat();
			
			//Estilo negrita de 8  y color de fondo
			HSSFCellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

			//Estilo negrita de 10  y color de fondo y formato decimal
			HSSFCellStyle estiloColorDecimal = libro.createCellStyle();
			estiloColorDecimal.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			estiloColorDecimal.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			estiloColorDecimal.setFont(fuenteNegrita10);
			estiloColorDecimal.setDataFormat(format.getFormat("#,##0.00"));

			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			estiloFormatoDecimal.setDataFormat(format.getFormat("#,##0.00"));
			
			//centrado
			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			// Creacion de hoja
			HSSFSheet hoja = libro.createSheet("CAT MINIMO EXCEL");
			
			// se crea la primer fila
			HSSFRow fila= hoja.createRow(0);
			HSSFCell celda;
			celda = fila.createCell((short)7);
			celda.setCellValue("Reporte Regulatorio: Catálogo Mínimo");
			celda.setCellStyle(estiloNeg10Der);	
			  
			fila = hoja.createRow(1);
			celda = fila.createCell((short)7);
			celda.setCellValue("Subreporte: Catálogo Mínimo");
			celda.setCellStyle(estiloNeg10Der);	
			
			fila = hoja.createRow(2);
			celda = fila.createCell((short)7);
			celda.setCellValue("R01 A 0111");
			celda.setCellStyle(estiloNeg10Der);	
			
			fila = hoja.createRow(3);
			fila = hoja.createRow(4);
			celda = fila.createCell((short)0);
			celda.setCellValue("Subreporte: Catálogo Mínimo");
			celda.setCellStyle(estiloNeg10);
			
			fila = hoja.createRow(5);
			celda = fila.createCell((short)0);
			celda.setCellValue("Cifras en pesos: Incluye cifras en Moneda nacional, Udis valorizadas en pesos");
			celda.setCellStyle(estiloNeg10);
			
			fila = hoja.createRow(6);
			fila = hoja.createRow(7);
			fila = hoja.createRow(8);
			celda = fila.createCell((short)0);
			celda.setCellValue("CATÁLOGO MÍNIMO PARA SOCIEDADES FINANCIERAS POPULARES");
			celda.setCellStyle(estiloNeg11);			
			// fila inicial, fila final, columna inicial, columna final 
			hoja.addMergedRegion(new CellRangeAddress(8, 8, 0, 7));
			
			fila = hoja.createRow(9);
			fila = hoja.createRow(10);
			fila = hoja.createRow(11);
			
			celda = fila.createCell((short)0);
			celda.setCellValue("Concepto");
			celda.setCellStyle(estiloColorDecimal);
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            11, //primera fila (0-based)
		            11, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            6//ultima celda   (0-based)
		    ));
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Moneda nacional \n y UDIS valorizadas");
			celda.setCellStyle(estiloColorDecimal);
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Moneda extranjera\n valorizada");
			celda.setCellStyle(estiloColorDecimal);
					
			
			int i=12,iter=0;
			int columnasVacias	= 0, maxEspacios= 0, combinarCeldas = 0;
			int tamanioLista=listaRepRegulatorio.size();

			RepRegCatalogoMinimoBean catalogoMinimoBean=null;
			for(iter=0; iter<tamanioLista; iter ++ ){
				catalogoMinimoBean= (RepRegCatalogoMinimoBean)listaRepRegulatorio.get(iter);
				
				columnasVacias = (catalogoMinimoBean.getEspacios()!=null)?
									Integer.parseInt(catalogoMinimoBean.getEspacios()):
														0;
				maxEspacios = (catalogoMinimoBean.getMaxEspacios()!=null)?
						Integer.parseInt(catalogoMinimoBean.getMaxEspacios()):
											0;
				combinarCeldas = (catalogoMinimoBean.getCombinarCeldas()!=null)?
						Integer.parseInt(catalogoMinimoBean.getCombinarCeldas()):
											1;
						
				fila=hoja.createRow(i);
				celda=fila.createCell((short)columnasVacias+0);
				celda.setCellValue(catalogoMinimoBean.getDescripcion());
				if(catalogoMinimoBean.getNegrita()!=null &&
						catalogoMinimoBean.getNegrita().equals(Constantes.STRING_SI)){
					celda.setCellStyle(estiloNeg10);
				}
				
				if(combinarCeldas > 1 ){
					// fila inicial, fila final, columna inicial, columna final 
					hoja.addMergedRegion(new CellRangeAddress(i, i, columnasVacias+0, columnasVacias+combinarCeldas-1));
				}
				
				celda=fila.createCell((short)0+maxEspacios);
				if(catalogoMinimoBean.getMonto()!=null &&
						!catalogoMinimoBean.getMonto().isEmpty()){
					celda.setCellValue(Double.parseDouble(catalogoMinimoBean.getMonto()));
					celda.setCellStyle(estiloFormatoDecimal);
				}else{
					 celda.setCellValue(catalogoMinimoBean.getMonto());
				}
				
				if(catalogoMinimoBean.getSombreado()!=null &&
						catalogoMinimoBean.getSombreado().equals("S")){
					celda.setCellStyle(estiloColorDecimal);
				}
				
				celda=fila.createCell((short)1+maxEspacios);
				celda.setCellValue(Double.parseDouble(catalogoMinimoBean.getMonedaExt()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				if(catalogoMinimoBean.getSombreado()!=null &&
						catalogoMinimoBean.getSombreado().equals("S")){
					celda.setCellStyle(estiloColorDecimal);
				}
				
				i++;
			}
			 
			hoja.autoSizeColumn((short)maxEspacios);
					
			fila = hoja.createRow(i+3);
			celda = fila.createCell((short)1);
			celda.setCellValue("(1)");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short)2);
			celda.setCellValue("Estos conceptos serán aplicables bajo un entorno económico inflacionario con base en lo establecido en la Norma de información financiera B-10 “Efectos de la inflación”, emitida por el Consejo Mexicano de Normas de Información Financiera, A.C. (CINIF).");
			celda.setCellStyle(estiloTam10);
			
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
		return  listaRepRegulatorio;	
	} // fin reporteRegCatalogoMinimoExcel
	
	
	
	
	
	
	
	
	
	
	

	public RepRegCatalogoMinimoDAO getRepRegCatalogoMinimoDAO() {
		return repRegCatalogoMinimoDAO;
	}

	public void setRepRegCatalogoMinimoDAO(
			RepRegCatalogoMinimoDAO repRegCatalogoMinimoDAO) {
		this.repRegCatalogoMinimoDAO = repRegCatalogoMinimoDAO;
	}
	

}
