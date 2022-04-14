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

import regulatorios.bean.RegulatorioA2611Bean;
import regulatorios.bean.RegulatorioC0453Bean;
import regulatorios.dao.RegulatorioC0453DAO;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;


public class RegulatorioC0453Servicio extends BaseServicio {
    
    RegulatorioC0453DAO regulatorioC0453DAO = null; 
    
    
    public RegulatorioC0453Servicio() {
        super();
    }

    

    public List <RegulatorioC0453Bean>listaReporteRegulatorioC0453(int tipoLista,int tipoEntidad, RegulatorioC0453Bean reporteBean, HttpServletResponse response) throws IOException{
        List<RegulatorioC0453Bean> listaReportes=null;
        
                
        /*
         * SOFIPOS
         */
        if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
            switch(tipoLista){
                case Enum_Lis_TipoReporte.excel:
                    listaReportes = reporteRegulatorioC0453XLSXSOFIPO(Enum_Lis_TipoReporte.excel,reporteBean,response);
                    break;
                case Enum_Lis_TipoReporte.csv:
                    listaReportes = generarReporteRegulatorioC0453(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
                    break;      
            }
        }else{
        	switch(tipoLista){
	            case Enum_Lis_TipoReporte.excel:
	                listaReportes = reporteRegulatorioC0453XLSXSOFIPO(Enum_Lis_TipoReporte.excel,reporteBean,response);
	                break;
	            case Enum_Lis_TipoReporte.csv:
	                listaReportes = generarReporteRegulatorioC0453(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
	                break;      
	        }
        }
        
        return listaReportes;
        
    }
    
    
    /* ======================================  FUNCION PARA GENERAR REPORTE CSV  ========================================*/ 
    
    private List generarReporteRegulatorioC0453(RegulatorioC0453Bean reporteBean,int tipoReporte,HttpServletResponse response){
        String nombreArchivo="";
        List listaBeans         = regulatorioC0453DAO.reporteRegulatorioC452Csv(reporteBean, tipoReporte);
        String anio             = reporteBean.getAnio();
        String mesEnLetras      = RegulatorioInsServicio.descripcionMes(reporteBean.getMes());
        
        nombreArchivo="R04_C0453_"+mesEnLetras+"_"+anio+".csv"; 
        // se inicia seccion para pintar el archivo csv
        try{
            RegulatorioC0453Bean bean;
            BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
            if (!listaBeans.isEmpty()){
                for(int i=0; i < listaBeans.size(); i++){
                    bean = (RegulatorioC0453Bean) listaBeans.get(i);
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
     * Generacion del reporte SOFIPO
     * @param tipoLista
     * @param reporteBean
     * @param response
     * @return
     */
    public List<RegulatorioC0453Bean> reporteRegulatorioC0453XLSXSOFIPO(int tipoLista,RegulatorioC0453Bean reporteBean, HttpServletResponse response) throws IOException
    {
        List<RegulatorioC0453Bean> listaRegulatorioC0453Bean = null;
        String mesEnLetras          = "";
        String anio                 = "";
        String nombreArchivo        = "";
        
        anio            = reporteBean.getAnio();
        mesEnLetras     = RegulatorioInsServicio.descripcionMes(reporteBean.getMes());
        nombreArchivo   = "R04_C0453_"+mesEnLetras+"_"+anio; 
        
        listaRegulatorioC0453Bean =  regulatorioC0453DAO.reporteRegulatorioC0453Sofipo(reporteBean,tipoLista);
        int contador = 1;
        
        if(listaRegulatorioC0453Bean != null){
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
                hoja = (SXSSFSheet) libro.createSheet("C 0452");
                
                Row fila = hoja.createRow(0);
                Cell celda=fila.createCell((short)1);
                /////////////////////////////////////////////////////////////////////////////////////
                ///////////////////////// FIN ENCABEZADO EXCEL //////////////////////////////////////
                //AGREGAR GRUPOS DE COLUMNAS
                //////////////////////////////////////////////////////////////////////////////
                
                celda = fila.createCell((short)0);
                celda.setCellValue("SECCIÓN IDENTIFICADOR DEL REPORTE");
                celda.setCellStyle(estiloAgrupacion);
                //funcion para unir celdas
                hoja.addMergedRegion(new CellRangeAddress(
                        0, //primera fila (0-based)
                        0, //ultima fila  (0-based)
                        0, //primer celda (0-based)
                        2  //ultima celda   (0-based)
                ));
                
                
                celda = fila.createCell((short)3);
                celda.setCellValue("SECCIÓN IDENTIFICADOR DEL CRÉDITO");
                celda.setCellStyle(estiloAgrupacion);
                //funcion para unir celdas
                hoja.addMergedRegion(new CellRangeAddress(
                        0, //primera fila (0-based)
                        0, //ultima fila  (0-based)
                        3, //primer celda (0-based)
                        15 //ultima celda   (0-based)
                ));
                
         
                    //Titulos del Reporte
                    fila = hoja.createRow(1);
                    
                    celda=fila.createCell((short)0);
                    celda.setCellValue("PERIODO");
                    celda.setCellStyle(estiloEncabezado);

                    celda=fila.createCell((short)1);
                    celda.setCellValue("CLAVE DE LA ENTIDAD");
                    celda.setCellStyle(estiloEncabezado);
                    
                    celda=fila.createCell((short)2);
                    celda.setCellValue("REPORTE");
                    celda.setCellStyle(estiloEncabezado);
         
                    
                    /*
                     * ====== IDENTIFICADOR DEL CREDITO
                     */
                    
                    celda=fila.createCell((short)3);
                    celda.setCellValue("IDENTIFICADOR DEL CRÉDITO ASIGNADO METODOLOGÍA CNBV");
                    celda.setCellStyle(estiloEncabezado);
                    
                    
                    celda=fila.createCell((short)4);
                    celda.setCellValue("TIPO BAJA CRÉDITO");
                    celda.setCellStyle(estiloEncabezado);
                    
                    celda=fila.createCell((short)5);
                    celda.setCellValue("SALDO INSOLUTO DEL CRÉDITO AL MOMENTO DE LA BAJA ");
                    celda.setCellStyle(estiloEncabezado);
                    
                    celda=fila.createCell((short)6);
                    celda.setCellValue("MONTO TOTAL PAGADO EFECTIVAMENTE POR EL ACREDITADO EN EL MOMENTO DE LA BAJA ");
                    celda.setCellStyle(estiloEncabezado);
                    
                    celda=fila.createCell((short)7);
                    celda.setCellValue("MONTO RECONOCIDO POR CASTIGOS EN EL PERIODO");
                    celda.setCellStyle(estiloEncabezado);
                    
                    celda=fila.createCell((short)8);
                    celda.setCellValue(" MONTO RECONOCIDO POR CONDONACIÓN EN EL PERIODO ");
                    celda.setCellStyle(estiloEncabezado);
                    
                    celda=fila.createCell((short)9);
                    celda.setCellValue("MONTO RECONOCIDO POR QUITA EN EL PERIODO");
                    celda.setCellStyle(estiloEncabezado);
                    
                    celda=fila.createCell((short)10);
                    celda.setCellValue("MONTO RECONOCIDO POR BONIFICACIONES EN EL PERIODO");
                    celda.setCellStyle(estiloEncabezado);
                    
                    celda=fila.createCell((short)11);
                    celda.setCellValue("MONTO RECONOCIDO POR DESCUENTOS EN EL PERIODO");
                    celda.setCellStyle(estiloEncabezado);
                    
                    celda=fila.createCell((short)12);
                    celda.setCellValue("MONTO DEL VALOR DEL BIEN RECIBIDO COMO DACIÓN EN PAGO");
                    celda.setCellStyle(estiloEncabezado);
                    
                    celda=fila.createCell((short)13);
                    celda.setCellValue("MONTO CANCELADO FUERA DE BALANCE");
                    celda.setCellStyle(estiloEncabezado);
                    
                    celda=fila.createCell((short)14);
                    celda.setCellValue("ESTIMACIONES PREVENTIVAS DERIVADAS DE LA CALIFICACIÓN CANCELADAS EN EL PERIODO ");
                    celda.setCellStyle(estiloEncabezado);
                    
                    celda=fila.createCell((short)15);
                    celda.setCellValue("ESTIMACIONES PREVENTIVAS ADICIONALES CANCELADAS EN EL PERIODO");
                    celda.setCellStyle(estiloEncabezado);
               
                    
                    int rowExcel=2;
                    contador=2;
                    RegulatorioA2611Bean regRegulatorioA2611Bean = null;
                    
                    for(int x = 0; x< listaRegulatorioC0453Bean.size() ; x++ ){
                        
                                            
                        
                        fila=hoja.createRow(rowExcel);
                                
                        celda=fila.createCell((short)0);
                        celda.setCellValue(listaRegulatorioC0453Bean.get(x).getPeriodo());
                        celda.setCellStyle(estilo8);
                        
                        celda=fila.createCell((short)1);
                        celda.setCellValue(listaRegulatorioC0453Bean.get(x).getClaveEntidad());
                        celda.setCellStyle(estilo8);
                        
                        celda=fila.createCell((short)2);
                        celda.setCellValue(listaRegulatorioC0453Bean.get(x).getReporte());
                        celda.setCellStyle(estilo8);
                        
                        /*
                         * == Identificador del credito
                         * 
                         */
                        
                        celda=fila.createCell((short)3);
                        celda.setCellValue(listaRegulatorioC0453Bean.get(x).getIdencreditoCNBV());
                        celda.setCellStyle(estilo8);

                        celda=fila.createCell((short)4);
                        celda.setCellValue(listaRegulatorioC0453Bean.get(x).getTipoBaja());
                        celda.setCellStyle(estilo8);

                        celda=fila.createCell((short)5);
                        celda.setCellValue(listaRegulatorioC0453Bean.get(x).getSaldoInsoluto());
                        celda.setCellStyle(estilo8);

                        celda=fila.createCell((short)6);
                        celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0453Bean.get(x).getMontoPagadoTotal()));
                        celda.setCellStyle(estilo8);

                        /*
                         * == Creditos a la fecha de corte
                         */
                        
                        celda=fila.createCell((short)7);
                        celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0453Bean.get(x).getMontoCastigos()));
                        celda.setCellStyle(estilo8);

                        celda=fila.createCell((short)8);
                        celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0453Bean.get(x).getMontoCondonacion()));
                        celda.setCellStyle(estilo8);
                            
                        celda=fila.createCell((short)9);
                        celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0453Bean.get(x).getMontoQuitas()));
                        celda.setCellStyle(estilo8);
                        
                        celda=fila.createCell((short)10);
                        celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0453Bean.get(x).getMontoBonificaciones()));
                        celda.setCellStyle(estilo8);
                        
                        celda=fila.createCell((short)11);
                        celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0453Bean.get(x).getMontoDescuentos()));
                        celda.setCellStyle(estilo8);

                        celda=fila.createCell((short)12);
                        celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0453Bean.get(x).getMontoBienRecibido()));
                        celda.setCellStyle(estilo8);
                            
                        celda=fila.createCell((short)13);
                        celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0453Bean.get(x).getMontoCancelado()));
                        celda.setCellStyle(estilo8);

                        celda=fila.createCell((short)14);
                        celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0453Bean.get(x).getEstimacionesPreventivas()));
                        celda.setCellStyle(estilo8);

                        celda=fila.createCell((short)15);
                        celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0453Bean.get(x).getEstimacionesAdicionales()));
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
        return listaRegulatorioC0453Bean;
    }



    public RegulatorioC0453DAO getRegulatorioC0453DAO() {
        return regulatorioC0453DAO;
    }



    public void setRegulatorioC0453DAO(RegulatorioC0453DAO regulatorioC0453DAO) {
        this.regulatorioC0453DAO = regulatorioC0453DAO;
    }


    

    
    
}

