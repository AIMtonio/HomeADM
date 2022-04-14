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

import regulatorios.bean.DesagreCaptaD0841Bean;
import regulatorios.bean.RegulatorioA2611Bean;
import regulatorios.dao.RegulatorioD0841DAO;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;


public class RegulatorioD0841Servicio extends BaseServicio {
	
	RegulatorioD0841DAO regulatorioD841DAO = null;
	
	public RegulatorioD0841Servicio(){
		super();
	}
	
	public List <DesagreCaptaD0841Bean>listaReporteRegulatorioD841(int tipoLista,int tipoEntidad, DesagreCaptaD0841Bean reporteBean, HttpServletResponse response) throws IOException{
		List<DesagreCaptaD0841Bean> listaReportes=null;
		
		/*
		 * SOCAPS
		 */
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaReportes = reporteRegulatorioD0841SOCAP(Enum_Lis_TipoReporte.excel,reporteBean,response);
					break;
				case Enum_Lis_TipoReporte.csv:
					listaReportes = generarReporteRegulatorioD841CSV(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		
		}
		
		/*
		 * SOFIPOS
		 */
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaReportes = reporteRegulatorioD0841SOFIPO(Enum_Lis_TipoReporte.excel,reporteBean,response);
					break;
				case Enum_Lis_TipoReporte.csv:
					listaReportes = generarReporteRegulatorioD841CSV(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		return listaReportes;
		
	}
	
	/* ======================================  FUNCION PARA GENERAR REPORTE CSV  ========================================*/	

	/**
	 * Genera reporte Desagregado de Captacion D0841 en formato CSV
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generarReporteRegulatorioD841CSV(DesagreCaptaD0841Bean reporteBean,int tipoReporte,HttpServletResponse response){
		try
		{
		String mesEnLetras	= "";
		String anio		= "";
		String nombreArchivo="";
		List listaBeans = regulatorioD841DAO.consultaRegulatorioD0841CSV(reporteBean, tipoReporte);
		
		mesEnLetras = RegulatorioInsServicio.descripcionMes(reporteBean.getFecha().substring(5,7));
		anio = reporteBean.getFecha().substring(0,4);
		
		nombreArchivo="D_0841_" + mesEnLetras+ "_"+anio +".csv";
	
		// se inicia seccion para pintar el archivo csv
		try{
			DesagreCaptaD0841Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (DesagreCaptaD0841Bean) listaBeans.get(i);
					writer.write(bean.getValor()!=null?bean.getValor():"");        
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
			
		}catch(Exception io ){	
			io.printStackTrace();
		}
		
		return listaBeans;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return null;
	}
	
	/* ======================================  FUNCION PARA GENERAR REPORTE SOCAP  ========================================*/	

	/**
	 * Generacion del reporte Desagregado de Captacion D0841 en formato Excel
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List<DesagreCaptaD0841Bean> reporteRegulatorioD0841SOCAP(int tipoLista,DesagreCaptaD0841Bean reporteBean,  HttpServletResponse response)
	{
		List<DesagreCaptaD0841Bean> listaRepBean = null;
		String mesEnLetras	= "";
		String anio		= "";
		String nombreArchivo = "";

		mesEnLetras = RegulatorioInsServicio.descripcionMes(reporteBean.getFecha().substring(5,7));
		anio	= reporteBean.getFecha().substring(0,4);
		nombreArchivo = "D_0841_"+mesEnLetras +"_"+anio; 
		
		listaRepBean = regulatorioD841DAO.consultaRegulatorioD0841Socap(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRepBean != null){
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
			
				// Creacion de hoja
				SXSSFSheet hoja = null;
				hoja = (SXSSFSheet) libro.createSheet("D 0841");
				
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				/////////////////////////////////////////////////////////////////////////////////////
				///////////////////////// FIN ENCABEZADO EXCEL //////////////////////////////////////
				//AGREGAR GRUPOS DE COLUMNAS
				//////////////////////////////////////////////////////////////////////////////
				fila = hoja.createRow(0);
				celda=fila.createCell((short)0);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL REPORTE");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				celda=fila.createCell((short)3);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL SOCIO");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            3, //primer celda (0-based)
			            19 //ultima celda   (0-based)
			    ));
				
				celda=fila.createCell((short)20);
				celda.setCellValue("SECCIÓN DATOS DE LA OPERACIÓN");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            20, //primer celda (0-based)
			            36  //ultima celda   (0-based)
			    ));
				
	
					////////////////////////////////////////////////////////////////////////////////
					
					//Titulos del Reporte
					fila = hoja.createRow(1);
					celda=fila.createCell((short)0);
					celda.setCellValue("PERIODO QUE SE REPORTA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)1);
					celda.setCellValue("CLAVE DE LA ENTIDAD");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)2);
					celda.setCellValue("SUBREPORTE");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)3);
					celda.setCellValue("NÚMERO DE IDENTIFICACIÓN");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)4);
					celda.setCellValue("TIPO DE SOCIO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)5);
					celda.setCellValue("NOMBRE, RAZÓN O DENOMINACIÓN SOCIAL");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)6);
					celda.setCellValue("APELLIDO PATERNO DEL SOCIO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)7);
					celda.setCellValue("APELLIDO MATERNO DEL SOCIO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)8);
					celda.setCellValue("RFC DEL SOCIO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)9);
					celda.setCellValue("CURP DEL SOCIO (SI ES PERSONA FÍSICA)");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)10);
					celda.setCellValue("GÉNERO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)11);
					celda.setCellValue("FECHA DE NACIMIENTO O CONSTITUCIÓN DE PERSONA MORAL");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)12);
					celda.setCellValue("CÓDIGO POSTAL DEL DOMICILIO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)13);
					celda.setCellValue("LOCALIDAD DEL DOMICILIO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)14);
					celda.setCellValue("ESTADO DEL DOMICILIO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)15);
					celda.setCellValue("PAÍS DEL DOMICILIO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)16);
					celda.setCellValue("NÚMERO DE CERTIFICADOS DE APORTACIÓN ORDINARIOS");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)17);	
					celda.setCellValue("MONTO DEL CERTIFICADO DE APORTACIÓN ORDINARIO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)18);
					celda.setCellValue("NÚMERO DE CERTIFICADOS EXCEDENTES O VOLUNTARIOS");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)19);
					celda.setCellValue("MONTO DEL CERTIFICADO EXCEDENTE O VOLUNTARIO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)20);
					celda.setCellValue("NÚMERO DE CONTRATO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)21);
					celda.setCellValue("NÚMERO DE CUENTA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)22);
					celda.setCellValue("NOMBRE DE LA SUCURSAL QUE OPERA EL DEPÓSITO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)23);
					celda.setCellValue("FECHA DE CONTRATACIÓN");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)24);
					celda.setCellValue("TIPO DE PRODUCTO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)25);
					celda.setCellValue("TIPO DE MODALIDAD");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)26);
					celda.setCellValue("TASA DE RENDIMIENTO ANUAL");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)27);	
					celda.setCellValue("MONEDA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)28);
					celda.setCellValue("PLAZO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)29);
					celda.setCellValue("FECHA DE VENCIMIENTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)30);
					celda.setCellValue("SALDO DE LA CUENTA AL INICIO DEL PERÍODO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)31);
					celda.setCellValue("MONTO DEL DEPÓSITO DE DINERO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)32);
					celda.setCellValue("MONTO DEL RETIRO DE DINERO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)33);
					celda.setCellValue("INTERESES DEVENGADOS NO PAGADOS EN EL PERÍODO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)34);
					celda.setCellValue("SALDO DE LA CUENTA AL FINAL DEL PERÍODO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)35);
					celda.setCellValue("FECHA DE ÚLTIMO MOVIMIENTO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)36);
					celda.setCellValue("TIPO DE APERTURA DE CUENTA");
					celda.setCellStyle(estiloEncabezado);
		


					int rowExcel=2, numero_hoja=2;
					contador=2;
					DesagreCaptaD0841Bean regC0451Bean = null;
					
					for(int x = 0; x< listaRepBean.size() ; x++ ){
						
											
						
						fila=hoja.createRow(rowExcel);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(listaRepBean.get(x).getVar_Periodo());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)1);
						celda.setCellValue(listaRepBean.get(x).getVar_ClaveEntidad());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)2);
						celda.setCellValue(listaRepBean.get(x).getFormulario());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)3);
						celda.setCellValue(listaRepBean.get(x).getNumIdentificacion());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)4);
						celda.setCellValue(listaRepBean.get(x).getTipoPersona());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)5);
						celda.setCellValue(listaRepBean.get(x).getNombre());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(listaRepBean.get(x).getApellidoPat());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)7);
						celda.setCellValue(listaRepBean.get(x).getApellidoMat());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)8);
						celda.setCellValue(listaRepBean.get(x).getRFC());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)9);
						celda.setCellValue(listaRepBean.get(x).getCURP());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)10);
						celda.setCellValue(listaRepBean.get(x).getGenero());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)11);
						celda.setCellValue(listaRepBean.get(x).getFechaNac());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)12);
						celda.setCellValue(listaRepBean.get(x).getCodigoPostal());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)13);
						celda.setCellValue(listaRepBean.get(x).getLocalidad());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)14);
						celda.setCellValue(listaRepBean.get(x).getEstadoClave());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)15);
						celda.setCellValue(listaRepBean.get(x).getCodigoPais());
						celda.setCellStyle(estilo8);

						
						celda=fila.createCell((short)16);
						celda.setCellValue(listaRepBean.get(x).getNumAportacion());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)17);
						celda.setCellValue(listaRepBean.get(x).getMtoAportacion());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)18);
						celda.setCellValue(listaRepBean.get(x).getNumAportaVol());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)19);
						celda.setCellValue(listaRepBean.get(x).getMtoAportaVol());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)20);	
						celda.setCellValue(listaRepBean.get(x).getNumContrato());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)21);
						celda.setCellValue(listaRepBean.get(x).getNumeroCuenta());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)22);
						celda.setCellValue(listaRepBean.get(x).getSucursal());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)23);
						celda.setCellValue(listaRepBean.get(x).getFechaApertura());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)24);
						celda.setCellValue(listaRepBean.get(x).getTipoProducto());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)25);
						celda.setCellValue(listaRepBean.get(x).getTipoModalidad());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)26);
						celda.setCellValue(listaRepBean.get(x).getTasaInteres());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)27);
						celda.setCellValue(listaRepBean.get(x).getMoneda());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)28);
						celda.setCellValue(listaRepBean.get(x).getPlazo());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)29);
						celda.setCellValue(listaRepBean.get(x).getFechaVencim());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)30);	
						celda.setCellValue(listaRepBean.get(x).getSaldoIniPer());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)31);
						celda.setCellValue(listaRepBean.get(x).getMtoDepositos());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)32);
						celda.setCellValue(listaRepBean.get(x).getMtoRetiros());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)33);
						celda.setCellValue(listaRepBean.get(x).getIntDevNoPago());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)34);
						celda.setCellValue(listaRepBean.get(x).getSaldoFinal());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)35);
						celda.setCellValue(listaRepBean.get(x).getFecUltMov());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)36);
						celda.setCellValue(listaRepBean.get(x).getTipoApertura());
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
		return listaRepBean;
	}
	
	
	/* ======================================  FUNCION PARA GENERAR REPORTE SOFIPO  ========================================*/	

	/**
	 * Generacion del reporte Desagregado de Captacion D0841 en formato Excel
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List<DesagreCaptaD0841Bean> reporteRegulatorioD0841SOFIPO(int tipoLista,DesagreCaptaD0841Bean reporteBean,  HttpServletResponse response)
	{
		List<DesagreCaptaD0841Bean> listaRepBean = null;
		String mesEnLetras	= "";
		String anio		= "";
		String nombreArchivo = "";

		mesEnLetras = RegulatorioInsServicio.descripcionMes(reporteBean.getFecha().substring(5,7));
		anio	= reporteBean.getFecha().substring(0,4);
		nombreArchivo = "D_0841_"+mesEnLetras +"_"+anio; 
		
		listaRepBean = regulatorioD841DAO.consultaRegulatorioD0841Sofipo(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRepBean != null){
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
			
				// Creacion de hoja
				SXSSFSheet hoja = null;
				hoja = (SXSSFSheet) libro.createSheet("D 0841");
				
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				/////////////////////////////////////////////////////////////////////////////////////
				///////////////////////// FIN ENCABEZADO EXCEL //////////////////////////////////////
				//AGREGAR GRUPOS DE COLUMNAS
				//////////////////////////////////////////////////////////////////////////////
				fila = hoja.createRow(0);
				celda=fila.createCell((short)0);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL REPORTE");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				celda=fila.createCell((short)3);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL AHORRADOR");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            3, //primer celda (0-based)
			            22 //ultima celda   (0-based)
			    ));
				
				celda=fila.createCell((short)23);
				celda.setCellValue("SECCIÓN DATOS DE LA OPERACIÓN");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            23, //primer celda (0-based)
			            59  //ultima celda   (0-based)
			    ));
				
				
				
					////////////////////////////////////////////////////////////////////////////////
					
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

					celda=fila.createCell((short)3);
					celda.setCellValue("NÚMERO DEL CLIENTE");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)4);
					celda.setCellValue("NOMBRE(S) O RAZÓN SOCIAL DEL AHORRADOR");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)5);
					celda.setCellValue("APELLIDO PATERNO DEL AHORRADOR");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)6);
					celda.setCellValue("APELLIDO MATERNO DEL AHORRADOR ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)7);
					celda.setCellValue("PERSONALIDAD JURÍDICA DEL AHORRADOR ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)8);
					celda.setCellValue("GRADO DE RIESGO (BAJO, INTERMEDIO O ALTO)");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)9);
					celda.setCellValue("ACTIVIDAD ECONÓMICA DEL AHORRADOR");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)10);
					celda.setCellValue("NACIONALIDAD DEL AHORRADOR ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)11);
					celda.setCellValue("FECHA DE NACIMIENTO DEL AHORRADOR/CONSTITUCIÓN DE LA EMPRESA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)12);
					celda.setCellValue("RFC DEL AHORRADOR");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)13);
					celda.setCellValue("CURP DEL AHORRADOR ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)14);
					celda.setCellValue("GÉNERO DEL AHORRADOR");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)15);
					celda.setCellValue("CALLE DEL DOMICILIO DEL AHORRADOR ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)16);
					celda.setCellValue("NÚMERO EXTERIOR DEL DOMICILIO DEL AHORRADOR");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)17);	
					celda.setCellValue("COLONIA DEL DOMICILIO DEL AHORRADOR ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)18);
					celda.setCellValue("CÓDIGO POSTAL DEL DOMICILIO DEL AHORRADOR");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)19);
					celda.setCellValue("LOCALIDAD DEL DOMICILIO DEL AHORRADOR ");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)20);
					celda.setCellValue("ESTADO DEL DOMICILIO DEL AHORRADOR ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)21);
					celda.setCellValue("MUNICIPIO DEL DOMICILIO DEL AHORRADOR");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)22);
					celda.setCellValue("PAÍS DEL DOMICILIO DEL AHORRADOR");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)23);
					celda.setCellValue("CLAVE DE LA SUCURSAL QUE OPERA EL DEPÓSITO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)24);
					celda.setCellValue("NÚMERO DE CUENTA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)25);
					celda.setCellValue("NÚMERO DEL CONTRATO DE AHORRO ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)26);
					celda.setCellValue("TIPO DE CLIENTE (ACREDITADO Y AHORRADOR)");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)27);	
					celda.setCellValue("CLASIFICACIÓN CONTABLE (TIPO DE DEPÓSITO) ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)28);
					celda.setCellValue("CLASIFICACIÓN DEL CERTIFICADO BURSÁTIL");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)29);
					celda.setCellValue("TIPO DE PRODUCTO ");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)30);
					celda.setCellValue("FECHA DE CONTRATACIÓN O APERTURA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)31);
					celda.setCellValue("FECHA INICIAL DEL DEPÓSITO ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)32);
					celda.setCellValue("MONTO INICIAL DEL DEPÓSITO EN LA MONEDA DE ORIGEN");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)33);
					celda.setCellValue("MONTO INICIAL DEL DEPÓSITO VALORIZADO EN PESOS");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)34);
					celda.setCellValue("FECHA DE VENCIMIENTO DEL DEPÓSITO ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)35);
					celda.setCellValue("PLAZO AL VENCIMIENTO ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)36);
					celda.setCellValue("RANGO DE PLAZO AL VENCIMIENTO ");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)37);
					celda.setCellValue("PERIODICIDAD DEL PLAN DE RENDIMIENTOS ACORDADOS");
					celda.setCellStyle(estiloEncabezado);
				
					celda=fila.createCell((short)38);
					celda.setCellValue("TIPO DE TASA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)39);
					celda.setCellValue("VALOR DE LA TASA ORIGINALMENTE PACTADA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)40);
					celda.setCellValue("VALOR DE LA TASA DE INTERÉS APLICABLE EN EL PERÍODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)41);
					celda.setCellValue("TASA DE INTERÉS DE REFERENCIA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)42);
					celda.setCellValue("DIFERENCIAL SOBRE TASA DE REFERENCIA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)43);
					celda.setCellValue("OPERACIÓN DE DIFERENCIAL SOBRE TASA DE REFERENCIA (ADITIVA O FACTOR)");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)44);
					celda.setCellValue("FRECUENCIA DE LA REVISIÓN DE LA TASA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)45);
					celda.setCellValue("TIPO DE MONEDA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)46);
					celda.setCellValue("SALDO DE LA CUENTA AL INICIO DEL PERÍODO ");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)47);
					celda.setCellValue("IMPORTE DE LOS DEPÓSITOS");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)48);
					celda.setCellValue("IMPORTE DE LOS RETIROS");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)49);
					celda.setCellValue("SALDO DE LOS INTERESES DEVENGADOS NO PAGADOS");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)50);
					celda.setCellValue("SALDO DE LA CUENTA AL FINAL DEL PERÍODO ");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)51);
					celda.setCellValue("MONTO DE LOS INTERESES DEL MES");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)52);
					celda.setCellValue("MONTO DE LAS COMISIONES DEL MES ");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)53);
					celda.setCellValue("FECHA DEL ÚLTIMO MOVIMIENTO DEL CLIENTE ");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)54);
					celda.setCellValue("MONTO DEL ÚLTIMO MOVIMIENTO DEL CLIENTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)55);
					celda.setCellValue("SALDO PROMEDIO DEL PERÍODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)56);
					celda.setCellValue("RETIRO ANTICIPADO DEL DEPÓSITO (SI/NO)");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)57);
					celda.setCellValue("MONTO CUBIERTO POR EL FONDO DE PROTECCIÓN");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)58);
					celda.setCellValue("PORCENTAJE CUBIERTO POR EL FONDO DE PROTECCIÓN");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)59);
					celda.setCellValue("PORCENTAJE EN GARANTÍA");
					celda.setCellStyle(estiloEncabezado);
	
					
					


					int rowExcel=2, numero_hoja=2;
					contador=2;
					DesagreCaptaD0841Bean regC0451Bean = null;
					
					for(int x = 0; x< listaRepBean.size() ; x++ ){
						
											
						
						fila=hoja.createRow(rowExcel);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(listaRepBean.get(x).getVar_Periodo());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)1);
						celda.setCellValue(listaRepBean.get(x).getVar_ClaveEntidad());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)2);
						celda.setCellValue(listaRepBean.get(x).getFormulario());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)3);
						celda.setCellValue(listaRepBean.get(x).getClienteID());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(listaRepBean.get(x).getNombre());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)5);
						celda.setCellValue(listaRepBean.get(x).getApellidoPat());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(listaRepBean.get(x).getApellidoMat());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(listaRepBean.get(x).getPersJuridica());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(listaRepBean.get(x).getGradoRiesgo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)9);
						celda.setCellValue(listaRepBean.get(x).getActividadEco());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)10);
						celda.setCellValue(listaRepBean.get(x).getNacionalidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)11);
						celda.setCellValue(listaRepBean.get(x).getFechaNac());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)12);
						celda.setCellValue(listaRepBean.get(x).getRFC());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)13);
						celda.setCellValue(listaRepBean.get(x).getCURP());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)14);
						celda.setCellValue(listaRepBean.get(x).getGenero());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)15);
						celda.setCellValue(listaRepBean.get(x).getCalle());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)16);
						celda.setCellValue(listaRepBean.get(x).getNumeroExt());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)17);
						celda.setCellValue(listaRepBean.get(x).getColoniaDes());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)18);
						celda.setCellValue(listaRepBean.get(x).getCodigoPostal());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)19);
						celda.setCellValue(listaRepBean.get(x).getLocalidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)20);
						celda.setCellValue(listaRepBean.get(x).getEstadoID());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)21);
						celda.setCellValue(listaRepBean.get(x).getMunicipioID());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)22);
						celda.setCellValue(listaRepBean.get(x).getCodigoPais());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)23);
						celda.setCellValue(listaRepBean.get(x).getClaveSucursal());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)24);
						celda.setCellValue(listaRepBean.get(x).getNumeroCuenta());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)25);
						celda.setCellValue(listaRepBean.get(x).getNumContrato());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)26);
						celda.setCellValue(listaRepBean.get(x).getTipoCliente());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)27);
						celda.setCellValue(listaRepBean.get(x).getClasfContable());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)28);
						celda.setCellValue(listaRepBean.get(x).getClasfBursatil());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)29);
						celda.setCellValue(listaRepBean.get(x).getTipoInstrumento());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)30);
						celda.setCellValue(listaRepBean.get(x).getFechaApertura());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)31);
						celda.setCellValue(listaRepBean.get(x).getFechaDepoIni());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)32);
						celda.setCellValue(listaRepBean.get(x).getMontoDepoIniOri());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)33);
						celda.setCellValue(listaRepBean.get(x).getMontoDepoIniPes());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)34);
						celda.setCellValue(listaRepBean.get(x).getFechaDepoVenc());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)35);
						celda.setCellValue(listaRepBean.get(x).getPlazoAlVencimi());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)36);
						celda.setCellValue(listaRepBean.get(x).getRangoPlazo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)37);
						celda.setCellValue(listaRepBean.get(x).getPeriodicidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)38);
						celda.setCellValue(listaRepBean.get(x).getTipoTasa());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)39);
						celda.setCellValue(listaRepBean.get(x).getTasaInteres());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)40);
						celda.setCellValue(listaRepBean.get(x).getTasaPeriodo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)41);
						celda.setCellValue(listaRepBean.get(x).getTasaReferencia());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)42);
						celda.setCellValue(listaRepBean.get(x).getDiferencialTasa());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)43);
						celda.setCellValue(listaRepBean.get(x).getOpeDiferencial());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)44);
						celda.setCellValue(listaRepBean.get(x).getFrecRevTasa());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)45);
						celda.setCellValue(listaRepBean.get(x).getMoneda());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)46);
						celda.setCellValue(listaRepBean.get(x).getSaldoIniPer());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)47);
						celda.setCellValue(listaRepBean.get(x).getMtoDepositos());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)48);
						celda.setCellValue(listaRepBean.get(x).getMtoRetiros());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)49);
						celda.setCellValue(listaRepBean.get(x).getIntDevNoPago());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)50);
						celda.setCellValue(listaRepBean.get(x).getSaldoFinal());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)51);
						celda.setCellValue(listaRepBean.get(x).getInteresMes());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)52);
						celda.setCellValue(listaRepBean.get(x).getComisionMes());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)53);
						celda.setCellValue(listaRepBean.get(x).getFecUltMov());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)54);
						celda.setCellValue(listaRepBean.get(x).getMontoUltMov());
						celda.setCellStyle(estilo8);
						
						
						celda=fila.createCell((short)55);
						celda.setCellValue(listaRepBean.get(x).getSaldoProm());
						celda.setCellStyle(estilo8);
						
						
						celda=fila.createCell((short)56);
						celda.setCellValue(listaRepBean.get(x).getRetiroAnt());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)57);
						celda.setCellValue(listaRepBean.get(x).getMontoFondPro());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)58);
						celda.setCellValue(listaRepBean.get(x).getPorcFondoPro());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)59);
						celda.setCellValue(listaRepBean.get(x).getPorcGarantia());
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
		return listaRepBean;
	}

	public RegulatorioD0841DAO getRegulatorioD841DAO() {
		return regulatorioD841DAO;
	}

	public void setRegulatorioD841DAO(RegulatorioD0841DAO regulatorioD841DAO) {
		this.regulatorioD841DAO = regulatorioD841DAO;
	}
	
	
	
}
