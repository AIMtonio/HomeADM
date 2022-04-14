package regulatorios.servicio;
import herramientas.Utileria;
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
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;


import regulatorios.bean.RegulatorioA1311Bean;
import regulatorios.dao.RegulatorioA1311DAO;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;
import general.servicio.BaseServicio;
import herramientas.Constantes;

public class RegulatorioA1311Servicio extends BaseServicio {

    RegulatorioA1311DAO regulatorioA1311DAO = null; 
        
    public RegulatorioA1311Servicio() {
        super();
    }
    	
    public List <RegulatorioA1311Bean>listaReporteRegulatorioA1311(int tipoLista,int tipoEntidad, RegulatorioA1311Bean reporteBean, HttpServletResponse response) throws IOException{
        List<RegulatorioA1311Bean> listaReportes=null;

            switch(tipoLista){
                case Enum_Lis_TipoReporte.excel:
                    listaReportes = reporteRegulatorioA1311(Enum_Lis_TipoReporte.excel, reporteBean, response);
                    break;
                case Enum_Lis_TipoReporte.csv:
                    listaReportes = generarReporteRegulatorioA1311(reporteBean, Enum_Lis_TipoReporte.csv,  response);
                    break;      
            }                
        return listaReportes;
        
    }
    
    private List generarReporteRegulatorioA1311(RegulatorioA1311Bean reporteBean,int tipoReporte,HttpServletResponse response){
        String nombreArchivo="";
        List listaBeans         = regulatorioA1311DAO.reporteRegulatorioA1311Csv(reporteBean, tipoReporte);
        String fecha_Actual		=  reporteBean.getFechaConsultaAnterior();
        String fecha_Anterior		=reporteBean.getFechaConsultaActual();
    	
        nombreArchivo="Reg_A1311_"+fecha_Actual+"_"+fecha_Anterior+".csv"; 
        // se inicia seccion para pintar el archivo csv
        try{
            RegulatorioA1311Bean bean;
            BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
            if (!listaBeans.isEmpty()){
                for(int i=0; i < listaBeans.size(); i++){
                    bean = (RegulatorioA1311Bean) listaBeans.get(i);
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
    
    /**
     * Generacion del reporte 
     * @param tipoLista
     * @param reporteBean
     * @param response
     * @return
     */
    public List<RegulatorioA1311Bean> reporteRegulatorioA1311(int tipoLista, RegulatorioA1311Bean reporteBean, HttpServletResponse response) throws IOException{
        List<RegulatorioA1311Bean> listaRegulatorioA1311Bean = null;
        String fecha_Actual			= "";
    	String fecha_Anterior		= "";
    	String fecha_Act			= "";
    	String fecha_Ant			= "";
    	String nombreArchivo 		= "";

    	fecha_Actual	= reporteBean.getFechaConsultaAnterior();
    	fecha_Anterior	= reporteBean.getFechaConsultaActual();
    	fecha_Act 		= covertirLetrasFecha(fecha_Actual);
    	fecha_Ant 		= covertirLetrasFecha(fecha_Anterior);
    	nombreArchivo	= "Reg_A1311_"+fecha_Actual +"_"+fecha_Anterior; 

    	listaRegulatorioA1311Bean =  regulatorioA1311DAO.reporteRegulatorioA1311Excel(reporteBean,tipoLista);

    	if(listaRegulatorioA1311Bean != null){
			try {
				
				/* ENCABEZADO y CONFIGURACION DEL  EXCEL */
	
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
				DataFormat formato8 = libro.createDataFormat();
				estilo8.setDataFormat(formato8.getFormat("0.00"));
				estilo8.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estilo8.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estilo8.setWrapText(true);
				
				CellStyle estiloUpper = libro.createCellStyle();
				estiloUpper.setFont(fuente8);
				DataFormat formatoUpper = libro.createDataFormat();
				estiloUpper.setDataFormat(formatoUpper.getFormat("0.00"));
				estiloUpper.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloUpper.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloUpper.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloUpper.setWrapText(true);
				
				CellStyle estiloBottom = libro.createCellStyle();
				estiloBottom.setFont(fuente8);
				DataFormat formatBottom = libro.createDataFormat();
				estiloBottom.setDataFormat(formatBottom.getFormat("0.00"));
				estiloBottom.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloBottom.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloBottom.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloBottom.setWrapText(true);
				
				//Estilo Formato Tasa (0.0000)
				CellStyle estiloFormatoTasa = libro.createCellStyle();
				DataFormat formato = libro.createDataFormat();
				estiloFormatoTasa.setDataFormat(formato.getFormat("0.00"));
				estiloFormatoTasa.setFont(fuente8);
				
				//Encabezado agrupaciones
				
				CellStyle estiloDerecha = libro.createCellStyle();
				estiloDerecha.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
				estiloDerecha.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloDerecha.setFont(fuenteNegrita8);
				estiloDerecha.setWrapText(true);
				
				CellStyle estiloIzquierda = libro.createCellStyle();
				estiloIzquierda.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
				estiloIzquierda.setFont(fuenteNegrita8);
				estiloIzquierda.setWrapText(true);
				
				CellStyle estiloNegrita = libro.createCellStyle();
				estiloNegrita.setFont(fuenteNegrita8);
				estiloNegrita.setWrapText(true);
				
				
				CellStyle estiloAgrupacion = libro.createCellStyle();
				estiloAgrupacion.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				estiloAgrupacion.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
				estiloAgrupacion.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloAgrupacion.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloAgrupacion.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setFont(fuenteNegrita8);
				estiloAgrupacion.setWrapText(true);
				
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
				
				
				// Creacion de hoja
				SXSSFSheet hoja = null;
				hoja = (SXSSFSheet) libro.createSheet("REGULATORIO A-1311");
				
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				
				/* FIN ENCABEZADO y CONFIGURACION DEL  EXCEL */
				celda = fila.createCell((short)1);
				celda.setCellValue("Sociedades Financieras Populares.");
				celda.setCellStyle(estiloDerecha);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            22  //ultima celda (0-based)
			    ));
				
				
				fila = hoja.createRow(1);
				celda = fila.createCell((short)1);
				celda.setCellValue("Serie R13 Estados financieros.");
				celda.setCellStyle(estiloDerecha);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            22  //ultima celda (0-based)
			    ));
				
				fila = hoja.createRow(2);
				celda = fila.createCell((short)1);
				celda.setCellValue("Reporte A-1311 Estado de variaciones en el capital contable.");
				celda.setCellStyle(estiloDerecha);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            22  //ultima celda (0-based)
			    ));
				
				fila = hoja.createRow(4);
				celda = fila.createCell((short)1);
				celda.setCellValue("Incluye cifras en moneda nacional, moneda extranjera y UDIS valorizadas en pesos.");
				hoja.addMergedRegion(new CellRangeAddress(
			            4, //primera fila (0-based)
			            4, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            22  //ultima celda (0-based)
			    ));
				
				fila = hoja.createRow(5);
				celda = fila.createCell((short)1);
				celda.setCellValue("Cifras en pesos.");
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            5, //primera fila (0-based)
			            5, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            22	  //ultima celda (0-based)
			    ));
				
				
				//Titulos del Reporte
				fila = hoja.createRow(7);
				celda=fila.createCell((short)1);
				celda.setCellValue("Concepto");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(
			            7, //primera fila (0-based)
			            8, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            6  //ultima celda (0-based)
			    ));
				
				celda=fila.createCell((short)7);
				celda.setCellValue("Participación controladora.");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(
			            7, //primera fila (0-based)
			            8, //ultima fila  (0-based)
			            7, //primer celda (0-based)
			            7  //ultima celda (0-based)
			    ));
				
				celda=fila.createCell((short)8);
				celda.setCellValue("Capital contribuido");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(
			            7, //primera fila (0-based)
			            7, //ultima fila  (0-based)
			            8, //primer celda (0-based)
			            12  //ultima celda (0-based)
			    ));
				
				celda=fila.createCell((short)13);
				celda.setCellValue("Capital ganado");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(
			            7, //primera fila (0-based)
			            7, //ultima fila  (0-based)
			            13, //primer celda (0-based)
			            20  //ultima celda (0-based)
			    ));

				celda=fila.createCell((short)21);
				celda.setCellValue("Participación no controladora.");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(
			            7, //primera fila (0-based)
			            8, //ultima fila  (0-based)
			            21, //primer celda (0-based)
			            21  //ultima celda (0-based)
			    ));

				celda=fila.createCell((short)22);
				celda.setCellValue("Capital contable.");
				celda.setCellStyle(estiloEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(
			            7, //primera fila (0-based)
			            8, //ultima fila  (0-based)
			            22, //primer celda (0-based)
			            22  //ultima celda (0-based)
			    ));
				
				fila = hoja.createRow(8);
				celda=fila.createCell((short)8);
				celda.setCellValue("Capital social.");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)9);
				celda.setCellValue("Aportaciones para futuros aumentos de capital formalizadas por su órgano de gobierno.");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)10);
				celda.setCellValue("Prima en venta de acciones.");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)11);
				celda.setCellValue("Obligaciones subordinadas en circulación.");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)12);
				celda.setCellValue("Efecto por incorporación al régimen de sociedades financieras populares.");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)13);
				celda.setCellValue("Reservas de capital.");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)14);
				celda.setCellValue("Resultado de ejercicios anteriores.");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)15);
				celda.setCellValue("Resultado por valuación de títulos disponibles para la venta.");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)16);
				celda.setCellValue("Resultado por valuación de instrumentos de cobertura de flujos de efectivo.");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)17);
				celda.setCellValue("Efecto acumulado por conversión.");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)18);
				celda.setCellValue("Remediciones por beneficios definidos a los empleados.");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)19);
				celda.setCellValue("Resultado por tenencia de activos no monetarios.");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)20);
				celda.setCellValue("Resultado neto.");
				celda.setCellStyle(estiloEncabezado);
				
				
			
				/* Seccion para el rellenado de filas*/
				int i=9,iter=0;
				int columnasVacias	= 0, maxEspacios= 0, combinarCeldas = 0;
				int tamanioLista=listaRegulatorioA1311Bean.size();
	
				RegulatorioA1311Bean bean =null;
				for(iter=0; iter<tamanioLista; iter ++ ){
					CellStyle estiloDinamico = null;
					if (iter == 0){
						estiloDinamico = estiloUpper;
					}else						
					if(iter == (listaRegulatorioA1311Bean.size()-1)){
						estiloDinamico = estiloBottom;
					}else{
						estiloDinamico = estilo8;
					}
					
					bean= (RegulatorioA1311Bean)listaRegulatorioA1311Bean.get(iter);
					
					fila=hoja.createRow(i);
					celda=fila.createCell((short)1+columnasVacias+0);
					
					if(Integer.parseInt(bean.getCaTConceptos()) == 1){
						celda.setCellValue(fecha_Act);
						hoja.addMergedRegion(new CellRangeAddress(
					            i, //primera fila (0-based)
					            i, //ultima fila  (0-based)
					            1, //primer celda (0-based)
					            6  //ultima celda (0-based)
					    ));
						celda.setCellStyle(estiloDinamico);
						
					}
					else if(Integer.parseInt(bean.getCaTConceptos()) == 20){
						celda.setCellValue(fecha_Ant);
						hoja.addMergedRegion(new CellRangeAddress(
					            i, //primera fila (0-based)
					            i, //ultima fila  (0-based)
					            1, //primer celda (0-based)
					            6  //ultima celda (0-based)
					     ));       
						celda.setCellStyle(estiloDinamico);
					}else{
						if(bean.getNegrita()!=null &&
							bean.getNegrita().equals(Constantes.STRING_SI)){
							celda.setCellValue(bean.getDescripcion());
							hoja.addMergedRegion(new CellRangeAddress(
						            i, //primera fila (0-based)
						            i, //ultima fila  (0-based)
						            1, //primer celda (0-based)
						            6  //ultima celda (0-based)
						    ));
							celda.setCellStyle(estiloDinamico);
						}
						else{
							celda.setCellValue(bean.getDescripcion());
							hoja.addMergedRegion(new CellRangeAddress(
						            i, //primera fila (0-based)
						            i, //ultima fila  (0-based)
						            1, //primer celda (0-based)
						            6  //ultima celda (0-based)
						    ));
							celda.setCellStyle(estiloDinamico);
						}	
					}
					
					if(combinarCeldas > 1 ){
						// fila inicial, fila final, columna inicial, columna final 
						hoja.addMergedRegion(new CellRangeAddress(i, i, 1+columnasVacias+0, 8+columnasVacias+combinarCeldas-1));
					}
					
					celda=fila.createCell((short)7+maxEspacios);
					if(bean.getParticipacionControladora()!=null &&
						!bean.getParticipacionControladora().isEmpty()){
						celda.setCellValue(Double.parseDouble(bean.getParticipacionControladora()));
						celda.setCellStyle(estiloDinamico);
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
						celda.setCellStyle(estiloDinamico);
					}	
					
					celda=fila.createCell((short)8+maxEspacios);
					if(bean.getCapitalSocial()!=null &&
						!bean.getCapitalSocial().isEmpty()){
						celda.setCellValue(Double.parseDouble(bean.getCapitalSocial()));
						celda.setCellStyle(estiloDinamico);
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
						celda.setCellStyle(estiloDinamico);
					}	
					
					celda=fila.createCell((short)9+maxEspacios);
					if(bean.getAportacionesCapital()!=null &&
						!bean.getAportacionesCapital().isEmpty()){
						celda.setCellValue(Double.parseDouble(bean.getAportacionesCapital()));
						celda.setCellStyle(estiloDinamico);
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
						celda.setCellStyle(estiloDinamico);
					}
					
					celda=fila.createCell((short)10+maxEspacios);
					if(bean.getPrimaVenta()!=null &&
						!bean.getPrimaVenta().isEmpty()){
						celda.setCellValue(Double.parseDouble(bean.getPrimaVenta()));
						celda.setCellStyle(estiloDinamico);
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
						celda.setCellStyle(estiloDinamico);
					}
					
					celda=fila.createCell((short)11+maxEspacios);
					if(bean.getObligacionesSubordinadas()!=null &&
						!bean.getObligacionesSubordinadas().isEmpty()){
						celda.setCellValue(Double.parseDouble(bean.getObligacionesSubordinadas()));
						celda.setCellStyle(estiloDinamico);
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
						celda.setCellStyle(estiloDinamico);
					}
					
					celda=fila.createCell((short)12+maxEspacios);
					if(bean.getIncorporacionSocFinancieras()!=null &&
						!bean.getIncorporacionSocFinancieras().isEmpty()){
						celda.setCellValue(Double.parseDouble(bean.getIncorporacionSocFinancieras()));
						celda.setCellStyle(estiloDinamico);
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
						celda.setCellStyle(estiloDinamico);
					}
					
					celda=fila.createCell((short)13+maxEspacios);
					if(bean.getReservaCapital()!=null &&
						!bean.getReservaCapital().isEmpty()){
						celda.setCellValue(Double.parseDouble(bean.getReservaCapital()));
						celda.setCellStyle(estiloDinamico);
					}else{
						celda.setCellStyle(estiloDinamico);
						celda.setCellValue(Constantes.STRING_VACIO);
					}
					
					celda=fila.createCell((short)14+maxEspacios);
					if(bean.getResultadoEjerAnterior()!=null &&
						!bean.getResultadoEjerAnterior().isEmpty()){
						celda.setCellValue(Double.parseDouble(bean.getResultadoEjerAnterior()));
						celda.setCellStyle(estiloDinamico);
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
						celda.setCellStyle(estiloDinamico);
					}
					
					celda=fila.createCell((short)15+maxEspacios);
					if(bean.getResultadoTitulosVenta()!=null &&
						!bean.getResultadoTitulosVenta().isEmpty()){
						celda.setCellValue(Double.parseDouble(bean.getResultadoTitulosVenta()));
						celda.setCellStyle(estiloDinamico);
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
						celda.setCellStyle(estiloDinamico);
					}
					
					celda=fila.createCell((short)16+maxEspacios);
					if(bean.getResultadoValuacionInstrumentos()!=null &&
						!bean.getResultadoValuacionInstrumentos().isEmpty()){
						celda.setCellValue(Double.parseDouble(bean.getResultadoValuacionInstrumentos()));
						celda.setCellStyle(estiloFormatoTasa);
						celda.setCellStyle(estiloDinamico);
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
						celda.setCellStyle(estiloDinamico);
					}	
					
					celda=fila.createCell((short)17+maxEspacios);
					if(bean.getEfectoAcomulado()!=null &&
						!bean.getEfectoAcomulado().isEmpty()){
						celda.setCellValue(Double.parseDouble(bean.getEfectoAcomulado()));
						celda.setCellStyle(estiloFormatoTasa);
						celda.setCellStyle(estiloDinamico);
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
						celda.setCellStyle(estiloDinamico);
					}
					
					celda=fila.createCell((short)18+maxEspacios);
					if(bean.getBeneficioEmpleados()!=null &&
						!bean.getBeneficioEmpleados().isEmpty()){
						celda.setCellValue(Double.parseDouble(bean.getBeneficioEmpleados()));
						celda.setCellStyle(estiloDinamico);
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
						celda.setCellStyle(estiloDinamico);
					}
					
					celda=fila.createCell((short)19+maxEspacios);
					if(bean.getResultadoMonetario()!=null &&
						!bean.getResultadoMonetario().isEmpty()){
						celda.setCellValue(Double.parseDouble(bean.getResultadoMonetario()));
						celda.setCellStyle(estiloDinamico);
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
						celda.setCellStyle(estiloDinamico);
					}
					
					celda=fila.createCell((short)20+maxEspacios);
					if(bean.getResultadoActivos()!=null &&
						!bean.getResultadoActivos().isEmpty()){
						celda.setCellValue(Double.parseDouble(bean.getResultadoActivos()));
						celda.setCellStyle(estiloDinamico);
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
						celda.setCellStyle(estiloDinamico);
					}
					
					celda=fila.createCell((short)21+maxEspacios);
					if(bean.getParticipacionNoControladora()!=null &&
						!bean.getParticipacionNoControladora().isEmpty()){
						celda.setCellValue(Double.parseDouble(bean.getParticipacionNoControladora()));
						celda.setCellStyle(estiloDinamico);
					}else{
						celda.setCellValue(Constantes.STRING_VACIO);
						celda.setCellStyle(estiloDinamico);
					}
					
					celda=fila.createCell((short)22+maxEspacios);
					if(bean.getCapitalContable()!=null &&
						!bean.getCapitalContable().isEmpty()){
						celda.setCellValue(Double.parseDouble(bean.getCapitalContable()));
						celda.setCellStyle(estiloDinamico);
					}else{
						celda.setCellStyle(estiloDinamico);
						celda.setCellValue(Constantes.STRING_VACIO);
					}
					i++;
				}
				 
				hoja.autoSizeColumn((short)maxEspacios);
				fila = hoja.createRow(i+3);	
				
				i++;
				fila = hoja.createRow(i++);
				celda = fila.createCell((short)1);
				celda.setCellValue("Sociedades Financieras Populares.");
				celda.setCellStyle(estiloDerecha);
				hoja.addMergedRegion(new CellRangeAddress(
						(i-1), //primera fila (0-based)
						(i-1), //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            22 //ultima celda   (0-based)
			    ));
				
				i++;
				fila = hoja.createRow(i++);
				celda = fila.createCell((short)1);
				celda.setCellValue("Nota: En concordancia con lo que establecen los criterios contables, los conceptos que aparecen en el presente estado se muestran de manera enunciativa más no limitativa. La apertura de un mayor número de conceptos con el fin de proporcionar una presentación más detallada de la información deberá ser solicitada a la Dirección General Adjunto de Diseño y Recepción de Información de la Comisión Nacional Bancaria y de Valores.");
				celda.setCellStyle(estiloNegrita);
				hoja.addMergedRegion(new CellRangeAddress(
						(i-1), //primera fila (0-based)
						(i-1), //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            22 //ultima celda   (0-based)
			    ));
				hoja.setColumnWidth(1,5500);
				hoja.setColumnWidth(7,3000);
				hoja.setColumnWidth(8,3000);
				hoja.setColumnWidth(9,3000);
				hoja.setColumnWidth(10,3000);
				hoja.setColumnWidth(11,3000);
				hoja.setColumnWidth(12,3000);
				hoja.setColumnWidth(13,3000);
				hoja.setColumnWidth(14,3000);
				hoja.setColumnWidth(15,3000);
				hoja.setColumnWidth(16,3000);
				hoja.setColumnWidth(17,3000);
				hoja.setColumnWidth(18,3000);
				hoja.setColumnWidth(19,3000);
				hoja.setColumnWidth(20,3000);
				hoja.setColumnWidth(21,3000);
				hoja.setColumnWidth(22,3000);
				
	            //Creo la cabecera
	            response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xlsx");
	            response.setContentType("application/vnd.ms-excel");
	            
	            ServletOutputStream outputStream = response.getOutputStream();
	            libro.write(outputStream);
	            outputStream.flush();
	            outputStream.close();
        
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}//Fin del catch
    	return listaRegulatorioA1311Bean;
        
    }
    
    public RegulatorioA1311DAO getRegulatorioA1311DAO() {
		return regulatorioA1311DAO;
	}

    public void setRegulatorioA1311DAO(RegulatorioA1311DAO regulatorioA1311DAO) {
        this.regulatorioA1311DAO = regulatorioA1311DAO;
    }
    
    public String covertirLetrasFecha(String fechaNumeros){
		String var_FechaCompleta;	
		String mesNombre;
		int anio;
		int mes = 1;
		int dia;
		
		mes = Integer.parseInt((fechaNumeros).substring(5, 7));
		dia = Integer.parseInt((fechaNumeros).substring(8, 10));
		anio = Integer.parseInt((fechaNumeros).substring(0, 4));
		
        switch (mes) {
            case 1:  mesNombre = "Enero";
                     break;
            case 2:  mesNombre = "Febrero";
                     break;
            case 3:  mesNombre = "Marzo";
                     break;
            case 4:  mesNombre = "Abril";
                     break;
            case 5:  mesNombre = "Mayo";
                     break;
            case 6:  mesNombre = "Junio";
                     break;
            case 7:  mesNombre = "Julio";
                     break;
            case 8:  mesNombre = "Agosto";
                     break;
            case 9:  mesNombre = "Septiembre";
                     break;
            case 10: mesNombre = "Octubre";
                     break;
            case 11: mesNombre = "Noviembre";
                     break;
            case 12: mesNombre = "Diciembre";
                     break;
            default: mesNombre = "Mes Invalido";
                     break;
        }
		 var_FechaCompleta = ("Saldo al "+dia + " de " + mesNombre+" de " +anio).toString();
		 return var_FechaCompleta;
	}
}
