package regulatorios.servicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
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

import regulatorios.bean.RegulatorioI0391Bean;
import regulatorios.dao.RegulatorioI0391DAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class RegulatorioI0391Servicio extends BaseServicio{	
	RegulatorioI0391DAO regulatorioI0391DAO=null;
 
	public RegulatorioI0391Servicio() {
		super();
	}
	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Lis_RegulatorioI0391 {
		int principal = 1;
	}
	public static interface Enum_Alt_RegulatorioI0391 {
		int alta = 1;
	}
	public static interface Enum_Baj_RegulatorioI0391 {
		int bajaPorPeriodo = 1;
	}
	
	public static interface Enum_Lis_ReportesI0391{
		int excel	 = 2;
		int csv 	 = 3;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,int tipoEntidad,	RegulatorioI0391Bean regulatorioI0391Bean ){
		ArrayList listaRegulatorioI0391 = null;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			listaRegulatorioI0391 = (ArrayList) creaListaDetalle(regulatorioI0391Bean);
			switch (tipoTransaccion) {
				case Enum_Alt_RegulatorioI0391.alta:		
					mensaje = regulatorioI0391DAO.grabaRegulatorioI0391(regulatorioI0391Bean,listaRegulatorioI0391, Enum_Baj_RegulatorioI0391.bajaPorPeriodo);									
					break;			
			}
		}
				
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			listaRegulatorioI0391 = (ArrayList) creaListaDetalleSofipo(regulatorioI0391Bean);
			switch (tipoTransaccion) {
				case Enum_Alt_RegulatorioI0391.alta:		
					mensaje = regulatorioI0391DAO.grabaRegulatorioI0391Sofipo(regulatorioI0391Bean,listaRegulatorioI0391, Enum_Baj_RegulatorioI0391.bajaPorPeriodo);									
					break;			
			}
		}
		
		
		
		return mensaje;
	}
	
	
	/**
	 * Consulta de reporte I0391
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List <RegulatorioI0391Bean>listaReporteRegulatorioI0391(int tipoLista, int tipoEntidad, RegulatorioI0391Bean reporteBean, HttpServletResponse response){
		List<RegulatorioI0391Bean> listaReportes=null;
		
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch(tipoLista){
				case Enum_Lis_ReportesI0391.excel:
					listaReportes = reporteRegulatorioI0391Socap(tipoLista,tipoEntidad,reporteBean,response); 
					break;
				case Enum_Lis_ReportesI0391.csv:
					listaReportes = generarReporteRegulatorioI0391(reporteBean, Enum_Lis_ReportesI0391.csv,  response);		
					break;		
			}
		}
		
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_ReportesI0391.excel:
					listaReportes = reporteRegulatorioI0391Sofipo(tipoLista,tipoEntidad,reporteBean,response);
					break;
				case Enum_Lis_ReportesI0391.csv:
					listaReportes = generarReporteRegulatorioI0391(reporteBean, Enum_Lis_ReportesI0391.csv,  response);		
					break;		
			}
		}
		
		return listaReportes;
	}
	
	
	
	
	
	public List lista(int tipoLista, int tipoEntidad, RegulatorioI0391Bean regulatorioI0391Bean){		
		List regulatorioI0391 = null;
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch (tipoLista) {	
				case Enum_Lis_RegulatorioI0391.principal:		
					regulatorioI0391 = regulatorioI0391DAO.lista(regulatorioI0391Bean, tipoLista);			
					break;
					
			}
		}
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch (tipoLista) {	
				case Enum_Lis_RegulatorioI0391.principal:		
					regulatorioI0391 = regulatorioI0391DAO.listaSofipo(regulatorioI0391Bean, tipoLista);			
					break;
					
			}
		}
						
		return regulatorioI0391;
	}
	
	public List creaListaDetalle(RegulatorioI0391Bean regulatorioI0391Bean) {
		ArrayList listaDetalle = new ArrayList();
		List<String> entidad  		= regulatorioI0391Bean.getlEntidad();
		List<String> emisora  		= regulatorioI0391Bean.getlEmisora();
		List<String> serie  		= regulatorioI0391Bean.getlSerie();
		List<String> formaAdqui  	= regulatorioI0391Bean.getlFormaAdqui();
		List<String> tipoInstru  	= regulatorioI0391Bean.getlTipoInstru();
		List<String> clasfConta  	= regulatorioI0391Bean.getlClasfConta();
		List<String> fechaContra  	= regulatorioI0391Bean.getlFechaContra();
		List<String> fechaVencim  	= regulatorioI0391Bean.getlFechaVencim();
		List<String> numeroTitu  	= regulatorioI0391Bean.getlNumeroTitu();
		List<String> costoAdqui  	= regulatorioI0391Bean.getlCostoAdqui();
		List<String> tasaInteres  	= regulatorioI0391Bean.getlTasaInteres();
		List<String> grupoRiesgo  	= regulatorioI0391Bean.getlGrupoRiesgo();
		List<String> valuacion  	= regulatorioI0391Bean.getlValuacion();
		List<String> resValuacion  	= regulatorioI0391Bean.getlResValuacion();

		RegulatorioI0391Bean regulatorioI0391 = null;	
		if(entidad != null){
			int tamanio = entidad.size();			
			for (int i = 0; i < tamanio; i++) {
				regulatorioI0391 = new RegulatorioI0391Bean();
				
				regulatorioI0391.setAnio(regulatorioI0391Bean.getAnio());
				regulatorioI0391.setMes(regulatorioI0391Bean.getMes());
				regulatorioI0391.setEntidad(entidad.get(i));
				regulatorioI0391.setEmisora(emisora.get(i));
				regulatorioI0391.setSerie(serie.get(i));
				regulatorioI0391.setFormaAdqui(formaAdqui.get(i));
				regulatorioI0391.setTipoInstru(tipoInstru.get(i));
				regulatorioI0391.setClasfConta(clasfConta.get(i));
				regulatorioI0391.setFechaContra(fechaContra.get(i));
				regulatorioI0391.setFechaVencim(fechaVencim.get(i));
				regulatorioI0391.setNumeroTitu(numeroTitu.get(i));
				regulatorioI0391.setCostoAdqui(costoAdqui.get(i));
				regulatorioI0391.setTasaInteres(tasaInteres.get(i));
				regulatorioI0391.setGrupoRiesgo(grupoRiesgo.get(i));
				regulatorioI0391.setValuacion(valuacion.get(i));
				regulatorioI0391.setResValuacion(resValuacion.get(i));
				regulatorioI0391.setInstitucionID(regulatorioI0391Bean.getInstitucionID());
																		
				listaDetalle.add(regulatorioI0391);
				
			}
		}
		return listaDetalle;
		
	}
	
	
	
	/**
	 * Genera reporte regulatorio I0391 version CSV
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generarReporteRegulatorioI0391(RegulatorioI0391Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioI0391DAO.reporteRegulatorioI0391Csv(reporteBean, tipoReporte);
		nombreArchivo="I_0391_Inversiones_en_Valores_y_Reportos.csv";
		
		try{
			RegulatorioI0391Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioI0391Bean) listaBeans.get(i);
					writer.write(bean.getRenglon());        
					writer.write("\r\n");	
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
	
	/*
	 * Crear lista para Sofipos
	 */
	public List creaListaDetalleSofipo(RegulatorioI0391Bean regulatorioI0391Bean) {
		ArrayList listaDetalle = new ArrayList();
		List<String> entidad  		= regulatorioI0391Bean.getlEntidad();
		List<String> tipoValor		= regulatorioI0391Bean.getlTipoValorID();
		List<String> emisora  		= regulatorioI0391Bean.getlEmisora();
		List<String> serie  		= regulatorioI0391Bean.getlSerie();
		List<String> formaAdqui  	= regulatorioI0391Bean.getlFormaAdqui();
		List<String> tipoInversion  = regulatorioI0391Bean.getlTipoInversion();
		List<String> tipoInstru  	= regulatorioI0391Bean.getlTipoInstru();
		List<String> clasfConta  	= regulatorioI0391Bean.getlClasfConta();
		List<String> fechaContra  	= regulatorioI0391Bean.getlFechaContra();
		List<String> fechaVencim  	= regulatorioI0391Bean.getlFechaVencim();
		List<String> numeroTitu  	= regulatorioI0391Bean.getlNumeroTitu();
		List<String> costoAdqui  	= regulatorioI0391Bean.getlCostoAdqui();
		List<String> tasaInteres  	= regulatorioI0391Bean.getlTasaInteres();
		List<String> grupoRiesgo  	= regulatorioI0391Bean.getlGrupoRiesgo();
		List<String> valuacion  	= regulatorioI0391Bean.getlValuacion();
		List<String> resValuacion  	= regulatorioI0391Bean.getlResValuacion();

		RegulatorioI0391Bean regulatorioI0391 = null;	
		if(entidad != null){
			int tamanio = entidad.size();			
			for (int i = 0; i < tamanio; i++) {
				regulatorioI0391 = new RegulatorioI0391Bean();
				
				regulatorioI0391.setAnio(regulatorioI0391Bean.getAnio());
				regulatorioI0391.setMes(regulatorioI0391Bean.getMes());
				regulatorioI0391.setEntidad(entidad.get(i));
				regulatorioI0391.setTipoValorID(tipoValor.get(i));
				regulatorioI0391.setEmisora(emisora.get(i));
				regulatorioI0391.setSerie(serie.get(i));
				regulatorioI0391.setFormaAdqui(formaAdqui.get(i));
				regulatorioI0391.setTipoInversion(tipoInversion.get(i));
				regulatorioI0391.setTipoInstru(tipoInstru.get(i));
				regulatorioI0391.setClasfConta(clasfConta.get(i));
				regulatorioI0391.setFechaContra(fechaContra.get(i));
				regulatorioI0391.setFechaVencim(fechaVencim.get(i));
				regulatorioI0391.setNumeroTitu(numeroTitu.get(i));
				regulatorioI0391.setCostoAdqui(costoAdqui.get(i));
				regulatorioI0391.setTasaInteres(tasaInteres.get(i));
				regulatorioI0391.setGrupoRiesgo(grupoRiesgo.get(i));
				regulatorioI0391.setValuacion(valuacion.get(i));
				regulatorioI0391.setResValuacion(resValuacion.get(i));
				regulatorioI0391.setInstitucionID(regulatorioI0391Bean.getInstitucionID());
				
	
				listaDetalle.add(regulatorioI0391);
				
			}
		}
		return listaDetalle;
		
	}
	
	
		
	/*
	 * =============================================================================
	 * SOCAP
	 * =============================================================================
	 */

	
	// Reporte Excell
	public List<RegulatorioI0391Bean> reporteRegulatorioI0391Socap(int tipoLista,int tipoEntidad,RegulatorioI0391Bean i0391Bean, 
									HttpServletResponse response){
		List<RegulatorioI0391Bean> listaI0391Bean = null;
		String mesEnLetras	 = "";
		String anio			 = "";
		String nombreArchivo = "";
		
		mesEnLetras = descripcionMes(i0391Bean.getMes());
		anio	= i0391Bean.getAnio();		
		
		nombreArchivo = "R03_I_0391_"+mesEnLetras +"_"+anio; 
		
		/*Se hace la llamada para obtener la lista para llenar el reporte*/
		listaI0391Bean = regulatorioI0391DAO.reporteRegulatorioI0391Socap(i0391Bean, Enum_Lis_ReportesI0391.excel);
		
		if(listaI0391Bean != null){
	
			try {
				HSSFWorkbook libro = new HSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				HSSFFont fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)8);
				fuente8.setFontName(HSSFFont.FONT_ARIAL);
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				HSSFCellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				
				//Estilo negrita de 8  para encabezados del reporte
				HSSFCellStyle estiloNegro = libro.createCellStyle();
				estiloNegro.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setFont(fuenteNegrita8);
				
				//Estilo de 8  para Contenido
				HSSFCellStyle estiloNormal = libro.createCellStyle();
				HSSFDataFormat format = libro.createDataFormat();
				estiloNormal.setFont(fuente8);
				estiloNormal.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setDataFormat(format.getFormat("#,##0"));
				
				HSSFCellStyle estiloDerecha = libro.createCellStyle();
				format = libro.createDataFormat();
				estiloDerecha.setFont(fuente8);
				estiloDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				estiloDerecha.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setDataFormat(format.getFormat("#,##0"));
	
				//Estilo negrita tamaño 8 centrado
				HSSFCellStyle estiloEncabezado = libro.createCellStyle();
				estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setFont(fuenteNegrita8);
			
	
				//Estilo para una celda con dato con color de fondo gris
				HSSFCellStyle celdaGrisDato = libro.createCellStyle();
				HSSFDataFormat formato3 = libro.createDataFormat();
				celdaGrisDato.setFont(fuenteNegrita8);
				celdaGrisDato.setDataFormat(formato3.getFormat("#,##0"));
				celdaGrisDato.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				celdaGrisDato.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				celdaGrisDato.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				celdaGrisDato.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);

				
				// Creacion de hoja
				HSSFSheet hoja = libro.createSheet("Desg Inver y Valores I-0391");
				
				
				HSSFRow fila= hoja.createRow(0);
				fila = hoja.createRow(0);

				//Encabezados
				HSSFRow filaTitulo= hoja.createRow(0);
				HSSFCell celda=filaTitulo.createCell((short)0);
	
				
				fila = hoja.createRow(1);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("INFORMACIÓN SOLICITADA");
				celda.setCellStyle(estiloEncabezado);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            16  //ultima celda   (0-based)
			    ));
				
				
				fila = hoja.createRow(2);				
				
				celda = fila.createCell((short)0);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL FORMULARIO");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)3);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DE LAS INVERSIONES");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            3, //primer celda (0-based)
			            10 //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)11);
				celda.setCellValue("SECCIÓN VARIABLES FINANCIERAS DE LOS TÍTULOS");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            11, //primer celda (0-based)
			            16 //ultima celda   (0-based)
			    ));
				
				fila = hoja.createRow(3);
				celda = fila.createCell((short)0);
				celda.setCellValue("PERIODO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("CLAVE DE LA ENTIDAD");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("SUBREPORTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("ENTIDAD CON LA QUE SE REALIZA LA INVERSIÓN");				
				celda.setCellStyle(estiloEncabezado);
					
				celda = fila.createCell((short)4);
				celda.setCellValue("EMISORA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("SERIE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("FORMA DE ADQUISICIÓN");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("TIPO DE INSTRUMENTO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("CLASIFICACIÓN CONTABLE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("FECHA DE CONTRATACIÓN");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("FECHA DE VENCIMIENTO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("NÚMERO DE TÍTULOS");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("COSTO DE ADQUISICIÓN");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)13);
				celda.setCellValue("TASA DE INTERÉS, CUPÓN O PREMIO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)14);
				celda.setCellValue("GRUPO DE RIESGO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)15);
				celda.setCellValue("VALUACIÓN DIRECTA VECTOR");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)16);
				celda.setCellValue("RESULTADO POR VALUACIÓN");
				celda.setCellStyle(estiloEncabezado);
								
				
				int i=4;		
				for(RegulatorioI0391Bean regI0391Bean : listaI0391Bean ){
		
					fila=hoja.createRow(i);
					
					/* Columna 1 "Periodo" */
					celda=fila.createCell((short)0);
					celda.setCellValue(regI0391Bean.getPeriodo());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Clave de la Entidad" */
					celda=fila.createCell((short)1);
					celda.setCellValue(regI0391Bean.getClaveEntidad());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Subreporte" */
					celda=fila.createCell((short)2);
					celda.setCellValue(regI0391Bean.getSubreporte());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Entidad Finan" */
					celda=fila.createCell((short)3);
					celda.setCellValue(regI0391Bean.getEntidad());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Emisora" */
					celda=fila.createCell((short)4);
					celda.setCellValue(regI0391Bean.getEmisora());
					celda.setCellStyle(estiloNormal);
					
					
					/* Columna 1 "Serie" */
					celda=fila.createCell((short)5);
					celda.setCellValue(regI0391Bean.getSerie());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Forma Adqui" */
					celda=fila.createCell((short)6);
					celda.setCellValue(regI0391Bean.getFormaAdqui());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Tipo Instrumento" */
					celda=fila.createCell((short)7);
					celda.setCellValue(regI0391Bean.getTipoInstru());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Clasificación contable" */
					celda=fila.createCell((short)8);
					celda.setCellValue(regI0391Bean.getClasfConta());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Fecha Contratacion" */
					celda=fila.createCell((short)9);
					celda.setCellValue(regI0391Bean.getFechaContra());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Fecha Vencimiento" */
					celda=fila.createCell((short)10);
					celda.setCellValue(regI0391Bean.getFechaVencim());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Numero Titulo" */
					celda=fila.createCell((short)11);
					celda.setCellValue(regI0391Bean.getNumeroTitu());
					celda.setCellStyle(estiloDerecha);
					
					
					/* Columna 1 "Costo Adquisición" */
					celda=fila.createCell((short)12);
					celda.setCellValue(regI0391Bean.getCostoAdqui());
					celda.setCellStyle(estiloDerecha);
					
					
					/* Columna 1 "Tasa Interes" */
					celda=fila.createCell((short)13);
					celda.setCellValue(regI0391Bean.getTasaInteres());
					celda.setCellStyle(estiloDerecha);
					
					
					/* Columna 1 "Grupo Riesgo" */
					celda=fila.createCell((short)14);
					celda.setCellValue(regI0391Bean.getGrupoRiesgo());
					celda.setCellStyle(estiloNormal);
					
					
					/* Columna 1 "Valuación" */
					celda=fila.createCell((short)15);
					celda.setCellValue(regI0391Bean.getValuacion());
					celda.setCellStyle(estiloDerecha);
					
					/* Columna 1 "Resultado Valuación" */
					celda=fila.createCell((short)16);
					celda.setCellValue(regI0391Bean.getResValuacion());
					celda.setCellStyle(estiloDerecha);
					
					i++;
				}
										
				hoja.autoSizeColumn(0);
				hoja.autoSizeColumn(1);
				hoja.autoSizeColumn(2);
				hoja.autoSizeColumn(3);
				hoja.autoSizeColumn(4);
				hoja.autoSizeColumn(5);
				hoja.autoSizeColumn(6);
				hoja.autoSizeColumn(7);
				hoja.autoSizeColumn(8);
				hoja.autoSizeColumn(9);
				hoja.autoSizeColumn(10);
				hoja.autoSizeColumn(11);
				hoja.autoSizeColumn(12);
				hoja.autoSizeColumn(13);
				hoja.autoSizeColumn(14);
				hoja.autoSizeColumn(15);
				hoja.autoSizeColumn(16);
				
										
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
		}
		return listaI0391Bean;
	}

	
	/*
	 * =============================================================================
	 * SOFIPO
	 * =============================================================================
	 */

	
	// Reporte Excell
	public List<RegulatorioI0391Bean> reporteRegulatorioI0391Sofipo(int tipoLista,int tipoEntidad,RegulatorioI0391Bean i0391Bean, 
									HttpServletResponse response){
		List<RegulatorioI0391Bean> listaI0391Bean = null;
		String mesEnLetras	 = "";
		String anio			 = "";
		String nombreArchivo = "";
		
		mesEnLetras = descripcionMes(i0391Bean.getMes());
		anio	= i0391Bean.getAnio();		
		
		nombreArchivo = "R03_I_0391_"+mesEnLetras +"_"+anio; 
		
		/*Se hace la llamada para obtener la lista para llenar el reporte*/
		listaI0391Bean = regulatorioI0391DAO.reporteRegulatorioI0391Sofipo(i0391Bean, Enum_Lis_ReportesI0391.excel);
		
		if(listaI0391Bean != null){
	
			try {
				HSSFWorkbook libro = new HSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				HSSFFont fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)8);
				fuente8.setFontName(HSSFFont.FONT_ARIAL);
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				HSSFCellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				
				//Estilo negrita de 8  para encabezados del reporte
				HSSFCellStyle estiloNegro = libro.createCellStyle();
				estiloNegro.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setFont(fuenteNegrita8);
				
				//Estilo de 8  para Contenido
				HSSFCellStyle estiloNormal = libro.createCellStyle();
				HSSFDataFormat format = libro.createDataFormat();
				estiloNormal.setFont(fuente8);
				estiloNormal.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setDataFormat(format.getFormat("#,##0"));
				
				HSSFCellStyle estiloDerecha = libro.createCellStyle();
				format = libro.createDataFormat();
				estiloDerecha.setFont(fuente8);
				estiloDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				estiloDerecha.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setDataFormat(format.getFormat("#,##0"));
	
				//Estilo negrita tamaño 8 centrado
				HSSFCellStyle estiloEncabezado = libro.createCellStyle();
				estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setFont(fuenteNegrita8);
			
	
				//Estilo para una celda con dato con color de fondo gris
				HSSFCellStyle celdaGrisDato = libro.createCellStyle();
				HSSFDataFormat formato3 = libro.createDataFormat();
				celdaGrisDato.setFont(fuenteNegrita8);
				celdaGrisDato.setDataFormat(formato3.getFormat("#,##0"));
				celdaGrisDato.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				celdaGrisDato.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				celdaGrisDato.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				celdaGrisDato.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);

				
				// Creacion de hoja
				HSSFSheet hoja = libro.createSheet("Desg Inver y Valores I-0391");
				
				
				HSSFRow fila= hoja.createRow(0);
				fila = hoja.createRow(0);

				//Encabezados
				HSSFRow filaTitulo= hoja.createRow(0);
				HSSFCell celda=filaTitulo.createCell((short)0);
	
				
				fila = hoja.createRow(1);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("INFORMACIÓN SOLICITADA");
				celda.setCellStyle(estiloEncabezado);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            18  //ultima celda   (0-based)
			    ));
				
				
				fila = hoja.createRow(2);				
				
				celda = fila.createCell((short)0);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL REPORTE");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)3);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DE LAS INVERSIONES");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            3, //primer celda (0-based)
			            12 //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)13);
				celda.setCellValue("SECCIÓN VARIABLES FINANCIERAS DE LOS TÍTULOS");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            13, //primer celda (0-based)
			            18 //ultima celda   (0-based)
			    ));
				
				fila = hoja.createRow(3);
				celda = fila.createCell((short)0);
				celda.setCellValue("PERIODO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("CLAVE DE LA ENTIDAD");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("REPORTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("ENTIDAD CON LA QUE SE REALIZA LA INVERSIÓN");				
				celda.setCellStyle(estiloEncabezado);
					
				celda = fila.createCell((short)4);
				celda.setCellValue("EMISORA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("SERIE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("TIPO DE VALOR");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("FORMA DE ADQUISICIÓN");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("TIPO DE INVERSIÓN (REPORTADO/REPORTADOR)");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("TIPO DE INSTRUMENTO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("CLASIFICACIÓN CONTABLE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("FECHA DE CONTRATACIÓN");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("FECHA DE VENCIMIENTO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)13);
				celda.setCellValue("NÚMERO DE TÍTULOS");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)14);
				celda.setCellValue("COSTO DE ADQUISICIÓN");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)15);
				celda.setCellValue("TASA DE INTERÉS, CUPÓN O PREMIO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)16);
				celda.setCellValue("GRUPO DE RIESGO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)17);
				celda.setCellValue("VALUACIÓN DIRECTA VECTOR");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)18);
				celda.setCellValue("RESULTADO POR VALUACIÓN");
				celda.setCellStyle(estiloEncabezado);
								
				
				int i=4;		
				for(RegulatorioI0391Bean regI0391Bean : listaI0391Bean ){
		
					fila=hoja.createRow(i);
					
					/* Columna 1 "Periodo" */
					celda=fila.createCell((short)0);
					celda.setCellValue(regI0391Bean.getPeriodo());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Clave de la Entidad" */
					celda=fila.createCell((short)1);
					celda.setCellValue(regI0391Bean.getClaveEntidad());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Subreporte" */
					celda=fila.createCell((short)2);
					celda.setCellValue(regI0391Bean.getSubreporte());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Entidad Finan" */
					celda=fila.createCell((short)3);
					celda.setCellValue(regI0391Bean.getEntidad());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Emisora" */
					celda=fila.createCell((short)4);
					celda.setCellValue(regI0391Bean.getEmisora());
					celda.setCellStyle(estiloNormal);
					
					
					/* Columna 1 "Serie" */
					celda=fila.createCell((short)5);
					celda.setCellValue(regI0391Bean.getSerie());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Tipo Valor" */
					celda=fila.createCell((short)6);
					celda.setCellValue(regI0391Bean.getTipoValorID());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Forma Adqui" */
					celda=fila.createCell((short)7);
					celda.setCellValue(regI0391Bean.getFormaAdqui());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Tipo Inversion" */
					celda=fila.createCell((short)8);
					celda.setCellValue(regI0391Bean.getTipoInversion());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Tipo Instrumento" */
					celda=fila.createCell((short)9);
					celda.setCellValue(regI0391Bean.getTipoInstru());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Clasificación contable" */
					celda=fila.createCell((short)10);
					celda.setCellValue(regI0391Bean.getClasfConta());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Fecha Contratacion" */
					celda=fila.createCell((short)11);
					celda.setCellValue(regI0391Bean.getFechaContra());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Fecha Vencimiento" */
					celda=fila.createCell((short)12);
					celda.setCellValue(regI0391Bean.getFechaVencim());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 1 "Numero Titulo" */
					celda=fila.createCell((short)13);
					celda.setCellValue(regI0391Bean.getNumeroTitu());
					celda.setCellStyle(estiloDerecha);
					
					
					/* Columna 1 "Costo Adquisición" */
					celda=fila.createCell((short)14);
					celda.setCellValue(regI0391Bean.getCostoAdqui());
					celda.setCellStyle(estiloDerecha);
					
					
					/* Columna 1 "Tasa Interes" */
					celda=fila.createCell((short)15);
					celda.setCellValue(regI0391Bean.getTasaInteres());
					celda.setCellStyle(estiloDerecha);
					
					
					/* Columna 1 "Grupo Riesgo" */
					celda=fila.createCell((short)16);
					celda.setCellValue(regI0391Bean.getGrupoRiesgo());
					celda.setCellStyle(estiloNormal);
					
					
					/* Columna 1 "Valuación" */
					celda=fila.createCell((short)17);
					celda.setCellValue(regI0391Bean.getValuacion());
					celda.setCellStyle(estiloDerecha);
					
					/* Columna 1 "Resultado Valuación" */
					celda=fila.createCell((short)18);
					celda.setCellValue(regI0391Bean.getResValuacion());
					celda.setCellStyle(estiloDerecha);
					
					i++;
				}
										
				hoja.autoSizeColumn(0);
				hoja.autoSizeColumn(1);
				hoja.autoSizeColumn(2);
				hoja.autoSizeColumn(3);
				hoja.autoSizeColumn(4);
				hoja.autoSizeColumn(5);
				hoja.autoSizeColumn(6);
				hoja.autoSizeColumn(7);
				hoja.autoSizeColumn(8);
				hoja.autoSizeColumn(9);
				hoja.autoSizeColumn(10);
				hoja.autoSizeColumn(11);
				hoja.autoSizeColumn(12);
				hoja.autoSizeColumn(13);
				hoja.autoSizeColumn(14);
				hoja.autoSizeColumn(15);
				hoja.autoSizeColumn(16);
				hoja.autoSizeColumn(17);
				hoja.autoSizeColumn(18);
										
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
		}
		return listaI0391Bean;
	}

	
	
	
	
	
	
	
	
	
	
	//------------getter y setter--------------
	public RegulatorioI0391DAO getRegulatorioI0391DAO() {
		return regulatorioI0391DAO;
	}
	public void setRegulatorioI0391DAO(RegulatorioI0391DAO regulatorioI0391DAO) {
		this.regulatorioI0391DAO = regulatorioI0391DAO;
	}
	
}
