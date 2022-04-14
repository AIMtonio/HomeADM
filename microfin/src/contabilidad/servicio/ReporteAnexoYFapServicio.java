package contabilidad.servicio;

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
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;

import contabilidad.bean.ReporteAnexoYFapBean;
import contabilidad.dao.ReporteAnexoYFapDAO;

import regulatorios.dao.RegulatorioA1011DAO;
import regulatorios.servicio.RegulatorioInsServicio;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;
import general.servicio.BaseServicio;

public class ReporteAnexoYFapServicio extends	BaseServicio{
	
	ReporteAnexoYFapDAO reporteAnexoYFapDAO = null;
	
	public ReporteAnexoYFapServicio(){
		super();
	}
	
	public List <ReporteAnexoYFapBean>listaReporteAnexoYFap(int tipoLista,int tipoEntidad, ReporteAnexoYFapBean reporteBean, HttpServletResponse response) throws IOException{
		List<ReporteAnexoYFapBean> listaReportes=null;
		
		/*
		 * SOFIPOS
		 */
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaReportes = generarReporteAnexoYFapExcel(Enum_Lis_TipoReporte.excel,reporteBean,response);
					break;
				case Enum_Lis_TipoReporte.csv:
					listaReportes = generarReporteAnexoYFapCSV(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
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
	private List generarReporteAnexoYFapCSV(ReporteAnexoYFapBean reporteBean,int tipoReporte,HttpServletResponse response){
		try
		{
		String mesEnLetras	= "";
		String anio		= "";
		String nombreArchivo="";
		List listaBeans = reporteAnexoYFapDAO.reporteAnexoYFapCSV(reporteBean, tipoReporte);
				
		mesEnLetras = RegulatorioInsServicio.descripcionMes(reporteBean.getFecha().substring(5,7));
		anio = reporteBean.getFecha().substring(0,4);
		
		nombreArchivo="ANEXOYFAP_" + mesEnLetras+ "_"+anio +".csv";
	
		// se inicia seccion para pintar el archivo csv
		try{
			ReporteAnexoYFapBean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (ReporteAnexoYFapBean) listaBeans.get(i);
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
	public List<ReporteAnexoYFapBean> generarReporteAnexoYFapExcel(int tipoLista,ReporteAnexoYFapBean reporteBean,  HttpServletResponse response)
	{
		List<ReporteAnexoYFapBean> listaRepBean = null;
		String mesEnLetras	= "";
		String anio		= "";
		String nombreArchivo = "";

		mesEnLetras = RegulatorioInsServicio.descripcionMes(reporteBean.getFecha().substring(5,7));
		anio	= reporteBean.getFecha().substring(0,4);
		nombreArchivo = "ANEXOYFAP_"+mesEnLetras +"_"+anio; 
		
		listaRepBean = reporteAnexoYFapDAO.reporteAnexoYFapExcel(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRepBean != null)
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
				DataFormat format8 = libro.createDataFormat();
				estilo8.setDataFormat(format8.getFormat("0.00"));
				estilo8.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estilo8.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estilo8.setWrapText(true);
				
				CellStyle estiloUpper = libro.createCellStyle();
				estiloUpper.setFont(fuente8);
				DataFormat formatUpper = libro.createDataFormat();
				estiloUpper.setDataFormat(formatUpper.getFormat("0.00"));
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
				DataFormat format = libro.createDataFormat();
				estiloFormatoTasa.setDataFormat(format.getFormat("0.0000"));
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
				hoja = (SXSSFSheet) libro.createSheet("Reporte Financiero ANEXOYFAP.");
				
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				/* FIN ENCABEZADO y CONFIGURACION DEL  EXCEL */
				
				
							
				//Titulos del Reporte
				fila = hoja.createRow(0);
				celda=fila.createCell((short)0);
				celda.setCellValue("NOMBRE(S) O RAZÓN SOCIAL DEL AHORRADOR.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)1);
				celda.setCellValue("APELLIDO PATERNO DEL AHORRADOR.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)2);
				celda.setCellValue("APELLIDO MATERNO DEL AHORRADOR.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)3);
				celda.setCellValue("NÚMERO DE CLIENTE.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)4);
				celda.setCellValue("NÚMERO DE CUENTA.");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)5);
				celda.setCellValue("TIPO DE PERSONA.");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)6);
				celda.setCellValue("ACTIVIDAD, GIRO O PROFESIÓN.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)7);
				celda.setCellValue("NACIONALIDAD DEL AHORRADOR.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)8);
				celda.setCellValue("FECHA DE NACIMIENTO DEL AHORRADOR O FECHA DE CONSTITUCIÓN DE LA EMPRESA.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)9);
				celda.setCellValue("RFC DEL AHORRADOR (con homoclave).");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)10);
				celda.setCellValue("CLAVE ÚNICA DE REGISTRO DE POBLACIÓN (CURP DEL AHORRADOR).");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)11);
				celda.setCellValue("CALLE DEL DOMICILIO DEL AHORRADOR.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)12);
				celda.setCellValue("NÚMERO DEL DOMICILIO DEL AHORRADOR.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)13);
				celda.setCellValue("COLONIA DEL DOMICILIO DEL AHORRADOR.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)14);
				celda.setCellValue("CÓDIGO POSTAL DEL DOMICILIO DEL AHORRADOR.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)15);
				celda.setCellValue("LOCALIDAD DEL DOMICILIO DEL AHORRADOR.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)16);
				celda.setCellValue("MUNICIPIO DEL DOMICILIO DEL AHORRADOR.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)17);	
				celda.setCellValue("ENTIDAD FEDERATIVA DEL DOMICILIO DEL AHORRADOR.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)18);
				celda.setCellValue("PAÍS DEL DOMICILIO DEL AHORRADOR.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)19);
				celda.setCellValue("DIRECCIÓN DEL TRABAJO.");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)20);
				celda.setCellValue("TELEFONO DE CASA DEL AHORRADOR.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)21);
				celda.setCellValue("TELEFONO DE OFICINA DEL AHORRADOR.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)22);
				celda.setCellValue("TELEFONO MOVIL DEL AHORRADOR.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)23);
				celda.setCellValue("OTRO NUMERO DE TELEFONO PARA LOCALIZACIÓN.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)24);
				celda.setCellValue("RELACIÓN DEL OTRO NUMERO DE LOCALIZACIÓN.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)25);
				celda.setCellValue("CORREO ELECTRONICO.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)26);
				celda.setCellValue("NUMERO O CLAVE DE LA SUCURSAL QUE OPERA LA CUENTA.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)27);	
				celda.setCellValue("NOMBRE DE LA SUCURSAL QUE OPERA LA CUENTA.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)28);
				celda.setCellValue("DIRECCIÓN DE LA SUCURSAL QUE OPERA LA CUENTA.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)29);
				celda.setCellValue("TIPO DE DEPÓSITO.");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)30);
				celda.setCellValue("TIPO DE CUENTA.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)31);
				celda.setCellValue("NÚMERO DEL CONTRATO DE AHORRO.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)32);
				celda.setCellValue("FECHA DE CONTRATACIÓN O APERTURA.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)33);
				celda.setCellValue("FECHA DE VENCIMIENTO DEL DEPÓSITO.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)34);
				celda.setCellValue("PLAZO DEL DEPOSITO.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)35);
				celda.setCellValue("PERIODICIDAD DEL PAGO DE RENDIMIENTOS.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)36);
				celda.setCellValue("VALOR DE LA TASA PACTADA.");
				celda.setCellStyle(estiloEncabezado);
		
				celda=fila.createCell((short)37);
				celda.setCellValue("FECHA DEL ÚLTIMO DEPOSITO.");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)38);
				celda.setCellValue("MONTO DEL ÚLTIMO DEPÓSITO.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)39);
				celda.setCellValue("PORCENTAJE DEL SALDO TOTAL CUBIERTO POR EL SEGURÓ DE DEPOSITO");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)40);
				celda.setCellValue("SALDO DEL CAPITAL.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)41);
				celda.setCellValue("SALDO DE LOS INTERESES DEVENGADOS NO PAGADOS.");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)42);
				celda.setCellValue("SALDO TOTAL.");
				celda.setCellStyle(estiloEncabezado);

				
				int rowExcel=1, numero_hoja=2;
				contador=2;
				ReporteAnexoYFapBean bean = null;
				
				for(int x = 0; x< listaRepBean.size() ; x++ ){
					
					CellStyle estiloDinamico = null;
					if (x == 0){
						estiloDinamico = estiloUpper;
					}else						
					if(x == (listaRepBean.size()-1)){
						estiloDinamico = estiloBottom;
					}else{
						estiloDinamico = estilo8;
					}
					
					fila=hoja.createRow(rowExcel);
							
					celda=fila.createCell((short)0);
					celda.setCellValue(listaRepBean.get(x).getNombre());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)1);
					celda.setCellValue(listaRepBean.get(x).getApellidoPat());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)2);
					celda.setCellValue(listaRepBean.get(x).getApellidoMat());
					celda.setCellStyle(estiloDinamico);	

					celda=fila.createCell((short)3);
					celda.setCellValue(listaRepBean.get(x).getClienteID());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)4);
					celda.setCellValue(listaRepBean.get(x).getNumeroCuenta());
					celda.setCellStyle(estiloDinamico);
					
					celda=fila.createCell((short)5);
					celda.setCellValue(listaRepBean.get(x).getTipoPersona());
					celda.setCellStyle(estiloDinamico);
					
					celda=fila.createCell((short)6);
					celda.setCellValue(listaRepBean.get(x).getActividadEconomica());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)7);
					celda.setCellValue(listaRepBean.get(x).getNacionalidad());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)8);
					celda.setCellValue(listaRepBean.get(x).getFechaNac());
					celda.setCellStyle(estiloDinamico);
					
					celda=fila.createCell((short)9);
					celda.setCellValue(listaRepBean.get(x).getRFC());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)10);
					celda.setCellValue(listaRepBean.get(x).getCURP());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)11);
					celda.setCellValue(listaRepBean.get(x).getCalle());
					celda.setCellStyle(estiloDinamico);
					
					celda=fila.createCell((short)12);
					celda.setCellValue(listaRepBean.get(x).getNumeroExt());
					celda.setCellStyle(estiloDinamico);
					
					celda=fila.createCell((short)13);
					celda.setCellValue(listaRepBean.get(x).getColoniaID());
					celda.setCellStyle(estiloDinamico);
					
					celda=fila.createCell((short)14);
					celda.setCellValue(listaRepBean.get(x).getCodigoPostal());
					celda.setCellStyle(estiloDinamico);
					
					celda=fila.createCell((short)15);
					celda.setCellValue(listaRepBean.get(x).getLocalidad());
					celda.setCellStyle(estiloDinamico);
					
					celda=fila.createCell((short)16);
					celda.setCellValue(listaRepBean.get(x).getMunicipioID());
					celda.setCellStyle(estiloDinamico);
					
					celda=fila.createCell((short)17);
					celda.setCellValue(listaRepBean.get(x).getEstadoID());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)18);
					celda.setCellValue(listaRepBean.get(x).getCodigoPais());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)19);
					celda.setCellValue(listaRepBean.get(x).getDireccion());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)20);
					celda.setCellValue(listaRepBean.get(x).getTelefonoCasa());
					celda.setCellStyle(estiloDinamico);

					
					celda=fila.createCell((short)21);
					celda.setCellValue(listaRepBean.get(x).getTelefonoCelular());
					celda.setCellStyle(estiloDinamico);
					
					celda=fila.createCell((short)22);
					celda.setCellValue(listaRepBean.get(x).getTelefonoOficina());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)23);
					celda.setCellValue(listaRepBean.get(x).getTelefonoLocalizacion());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)24);
					celda.setCellValue(listaRepBean.get(x).getRelacionLocalizacion());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)25);	
					celda.setCellValue(listaRepBean.get(x).getCorreo());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)26);
					celda.setCellValue(listaRepBean.get(x).getClaveSucursal());
					celda.setCellStyle(estiloDinamico);
					
					celda=fila.createCell((short)27);
					celda.setCellValue(listaRepBean.get(x).getNombreSucursal());
					celda.setCellStyle(estiloDinamico);
					
					celda=fila.createCell((short)28);
					celda.setCellValue(listaRepBean.get(x).getDireccionSucursal());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)29);
					celda.setCellValue(listaRepBean.get(x).getClasfContable());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)30);
					celda.setCellValue(listaRepBean.get(x).getTipoCuenta());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)31);
					celda.setCellValue(listaRepBean.get(x).getNumContrato());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)32);
					celda.setCellValue(listaRepBean.get(x).getFechaContrato());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)33);
					celda.setCellValue(listaRepBean.get(x).getFechaVencimiento());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)34);
					celda.setCellValue(listaRepBean.get(x).getPlazoDeposito());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)35);	
					celda.setCellValue(listaRepBean.get(x).getPeriodicidad());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)36);
					celda.setCellValue(listaRepBean.get(x).getTasaPactada());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)37);
					celda.setCellValue(listaRepBean.get(x).getFechaUltimoDeposito());
					celda.setCellStyle(estiloDinamico);
					
					celda=fila.createCell((short)38);
					celda.setCellValue(Double.parseDouble(listaRepBean.get(x).getSaldoUltimoDepostito().toString()));
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)39);
					celda.setCellValue(listaRepBean.get(x).getPorcFondoPro().toString());
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)40);
					celda.setCellValue(Double.parseDouble(listaRepBean.get(x).getSaldoCapital().toString()));
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)41);
					celda.setCellValue(Double.parseDouble(listaRepBean.get(x).getIntDevNoPago().toString()));
					celda.setCellStyle(estiloDinamico);

					celda=fila.createCell((short)42);
					celda.setCellValue(Double.parseDouble(listaRepBean.get(x).getSaldoFinal().toString()));
					celda.setCellStyle(estiloDinamico);
					rowExcel++;
					contador++;
				}
				
				hoja.setColumnWidth(0,6000);
				hoja.setColumnWidth(1,3500);
				hoja.setColumnWidth(2,3500);
				hoja.setColumnWidth(3,3000);
				hoja.setColumnWidth(4,3000);
				
				hoja.setColumnWidth(5,3000);
				hoja.setColumnWidth(6,3000);
				hoja.setColumnWidth(7,3000);
				hoja.setColumnWidth(8,3000);
				hoja.setColumnWidth(9,3000);
				
				hoja.setColumnWidth(10,4000);
				hoja.setColumnWidth(11,5000);
				hoja.setColumnWidth(12,3000);
				hoja.setColumnWidth(13,6000);
				hoja.setColumnWidth(14,3000);
				
				hoja.setColumnWidth(15,3500);
				hoja.setColumnWidth(16,3000);
				hoja.setColumnWidth(17,3000);
				hoja.setColumnWidth(18,3000);
				hoja.setColumnWidth(19,10000);
				
				hoja.setColumnWidth(20,3000);
				hoja.setColumnWidth(21,3000);
				hoja.setColumnWidth(22,3000);
				hoja.setColumnWidth(23,3000);
				hoja.setColumnWidth(24,3000);
				
				hoja.setColumnWidth(25,4500);
				hoja.setColumnWidth(26,3000);
				hoja.setColumnWidth(27,4500);
				hoja.setColumnWidth(28,10000);
				hoja.setColumnWidth(29,3000);
				
				hoja.setColumnWidth(30,3000);
				hoja.setColumnWidth(31,3000);
				hoja.setColumnWidth(32,3000);
				hoja.setColumnWidth(33,3000);
				hoja.setColumnWidth(34,3000);
				
				hoja.setColumnWidth(35,3000);
				hoja.setColumnWidth(36,3000);
				hoja.setColumnWidth(37,3000);
				hoja.setColumnWidth(38,3000);
				hoja.setColumnWidth(39,3000);
				
				hoja.setColumnWidth(40,3000);
				hoja.setColumnWidth(41,3000);
				hoja.setColumnWidth(42,3000);
				
				
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
		return listaRepBean;
	}
	
	public ReporteAnexoYFapDAO getReporteAnexoYFapDAO() {
		return reporteAnexoYFapDAO;
	}
	
	public void setReporteAnexoYFapDAO(ReporteAnexoYFapDAO reporteAnexoYFapDAO) {
		this.reporteAnexoYFapDAO = reporteAnexoYFapDAO;
	}
}
