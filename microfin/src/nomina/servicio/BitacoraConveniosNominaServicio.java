package nomina.servicio;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;

import general.servicio.BaseServicio;
import herramientas.Utileria;
import inversiones.bean.InversionBean;
import nomina.bean.ConvenioNominaBean;
import nomina.dao.BitacoraConveniosNominaDAO;
//import nomina.servicio.TipoDocNominaServicio.Enum_Lis_TipoDoc;
import originacion.bean.SolicitudCreditoBean;
import reporte.ParametrosReporte;
import reporte.Reporte;

public class BitacoraConveniosNominaServicio extends BaseServicio {
	
	BitacoraConveniosNominaDAO bitacoraConveniosNominaDAO = null;
	
	public static interface Enum_Lis_BitaCon {
		int listaGrid = 1;
		int listaConvenios = 3;
	}
	
	public static interface Enum_Rep_BitaCon {
		int reporteTodos = 1;
		int reporteIndividual = 2;
	}
	
	public List<?> lista(int tipoLista, ConvenioNominaBean convenioNominaBean){
		List<?> resultado = null;

		switch (tipoLista) {
		case Enum_Lis_BitaCon.listaGrid:
			resultado = bitacoraConveniosNominaDAO.listaCambiosParamInstNom(tipoLista, convenioNominaBean);
			break;
		case Enum_Lis_BitaCon.listaConvenios:
			resultado = bitacoraConveniosNominaDAO.listaConveniosTodos(tipoLista, convenioNominaBean);
		}
		return resultado;
	}
	
	public ByteArrayOutputStream listaReportePDF(ConvenioNominaBean convenioNominaBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_HisConvenioNomID", convenioNominaBean.getHisConvenioNomID());
		parametrosReporte.agregaParametro("Par_InstitNominaID", convenioNominaBean.getInstitNominaID());
		parametrosReporte.agregaParametro("Par_ConvenioNominaID", convenioNominaBean.getConvenioNominaID());
		parametrosReporte.agregaParametro("Par_FechaInicio", convenioNominaBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin", convenioNominaBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_NombreUsuario", convenioNominaBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_FechaSistema", convenioNominaBean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", convenioNominaBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_NombreInstitNomina", convenioNominaBean.getNombreInstitNomina());
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte,
				parametrosAuditoriaBean.getRutaReportes(),
				parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	/* Controla los tipos de lista para reportes*/
	public List <ConvenioNominaBean> listaReporte(int tipoReporte, ConvenioNominaBean convenioNominaBean, HttpServletResponse response){
		 List <ConvenioNominaBean>listaBitacoraTodos=null;
	
		 switch(tipoReporte){		
		 	case  Enum_Rep_BitaCon.reporteTodos:				
		 		listaBitacoraTodos = bitacoraConveniosNominaDAO.reporteExcelTodos(tipoReporte, convenioNominaBean);
		 		break;
			case  Enum_Rep_BitaCon.reporteIndividual:				
				listaBitacoraTodos = bitacoraConveniosNominaDAO.reporteExcelIndividual(tipoReporte, convenioNominaBean);
				break;
			}
		return listaBitacoraTodos;
	}

	public List<ConvenioNominaBean> listaReporteExcelTodos(int tipoReporte, ConvenioNominaBean convenioNominaBean,  HttpServletResponse response){
		
		List<ConvenioNominaBean> listaHistoricoConvenios=null;

		listaHistoricoConvenios = listaReporte(Enum_Rep_BitaCon.reporteTodos, convenioNominaBean, response);
		
		int regExport = 0;
		Calendar calendario = Calendar.getInstance();
		
		if(listaHistoricoConvenios != null){
			try {
				Workbook libro = new SXSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				Font fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setFontName("Negrita");
				fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);						
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				Font fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)10);
				fuenteNegrita8.setFontName("Negrita");
				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				Font fuenteNegritaGroup= libro.createFont();
				fuenteNegritaGroup.setFontHeightInPoints((short)10);
				fuenteNegritaGroup.setFontName("Negrita");
				fuenteNegritaGroup.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				Font fuenteNegrita= libro.createFont();
				fuenteNegrita.setFontHeightInPoints((short)10);
				fuenteNegrita.setFontName("Negrita");
				fuenteNegrita.setBoldweight(Font.BOLDWEIGHT_BOLD);

				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				CellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				estiloNeg10.setAlignment(CellStyle.ALIGN_CENTER);			
				
				//Estilo negrita de 8  para encabezados del reporte
				CellStyle estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);
				
				//Estilo negrita de 8  y color de fondo
				CellStyle estiloColor = libro.createCellStyle();
				estiloColor.setFont(fuenteNegrita8);
				estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
				estiloColor.setFillPattern(CellStyle.SOLID_FOREGROUND);
				
				CellStyle estiloIzquierda = libro.createCellStyle();
				estiloIzquierda.setFont(fuenteNegrita);
				estiloIzquierda.setAlignment(CellStyle.ALIGN_LEFT);	
				
				//Estilo normal de 8 y alineacion a la derecha
				CellStyle estiloDerecha = libro.createCellStyle();
				estiloDerecha.setAlignment(CellStyle.ALIGN_RIGHT);	
				
				
				//Estilo negrita 8 con bordes
				CellStyle estiloBordes = libro.createCellStyle();
				estiloBordes.setBorderBottom(CellStyle.BORDER_THIN);
				estiloBordes.setBorderTop(CellStyle.BORDER_THIN);
				estiloBordes.setBorderRight(CellStyle.BORDER_THIN);
				estiloBordes.setBorderLeft(CellStyle.BORDER_THIN);
				estiloBordes.setFont(fuenteNegrita);
				estiloBordes.setAlignment(CellStyle.ALIGN_CENTER);
				
				//Estilo negrita 8 con bordes mezclados
				CellStyle estiloBordesMezcla = libro.createCellStyle();
				estiloBordesMezcla.setBorderBottom(CellStyle.BORDER_THIN);
				estiloBordesMezcla.setBorderTop(CellStyle.BORDER_THIN);
				estiloBordesMezcla.setFont(fuenteNegrita);
				estiloBordesMezcla.setAlignment(CellStyle.ALIGN_CENTER);
				
				//Encabezado agrupaciones
				CellStyle estiloAgrupacion = libro.createCellStyle();
				estiloAgrupacion.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloAgrupacion.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloAgrupacion.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setFont(fuenteNegritaGroup);
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
				
				//Estilo negrita tamaño 8 centrado
				CellStyle estiloSaltoLinea = libro.createCellStyle();
				estiloSaltoLinea.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloSaltoLinea.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloSaltoLinea.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloSaltoLinea.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloSaltoLinea.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloSaltoLinea.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloSaltoLinea.setFont(fuenteNegrita8);
				estiloSaltoLinea.setWrapText(true);		
				
				//Asignamos el nombre de la hoja 
				SXSSFSheet hoja = null;
				hoja = (SXSSFSheet) libro.createSheet("BITÁCORA CAMBIOS PARÁMETROS EMPRESA NÓMINA");
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);		

				
				if(tipoReporte == Enum_Rep_BitaCon.reporteTodos) {	
					fila = hoja.createRow(1);
					fila = hoja.createRow(2);
					
					// Usuario que genera el reporte       
					celda = fila.createCell((short)10); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue("Usuario:");		
						
					//Obtenemos el nombre del usuario
					celda = fila.createCell((short)11); //Asignamos el numero del lugar de nuestra celda
					celda.setCellValue(convenioNominaBean.getNombreUsuario());
					celda.setCellStyle(estiloIzquierda);
						
					//Asignamos el titulo del reporte 
					celda = fila.createCell	((short)2);//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue(convenioNominaBean.getNombreInstitucion());
					CellRangeAddress region = new CellRangeAddress(
							2,
							(short)2,
							2,
							(short)8);
					hoja.addMergedRegion(region);
				
					fila = hoja.createRow(3); // Generamos la fila a la que pertenecen los valores anteriores					
					
					// Fecha de Emisión del Reporte
					celda=fila.createCell((short)10); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue("Fecha: ");
					
					// Obtenemos la fecha de Emisión del reporte
					celda=fila.createCell((short)11); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue(convenioNominaBean.getFechaSistema());	
					
					//Asignamos el sub-titulo que contendra las fechas de rango del reporte
					celda = fila.createCell	((short)2);//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("BITÁCORA CAMBIOS PARÁMETROS EMPRESA NÓMINA");
					hoja.addMergedRegion(new CellRangeAddress( // Rango de filas que requeriremos para la union de estas mismas
				            3, //primera fila 
				            3, //ultima fila 
				            2, //primer celda
				            8 //ultima celda
				    ));		
										
					fila = hoja.createRow(4); // Generamos la fila a la que pertenecen los valores anteriores											
					
					//Asignamos la hora de Emisión del reporte
					celda = fila.createCell((short)10); //Asignamos el numero del lugar de nuestra celda
					celda.setCellValue("Hora: ");
					celda.setCellStyle(estiloIzquierda);
					celda = fila.createCell((short)11); //Asignamos el numero del lugar de nuestra celda
					String horaVar="";				 
					int hora =calendario.get(Calendar.HOUR_OF_DAY);
					int minutos = calendario.get(Calendar.MINUTE);
					int segundos = calendario.get(Calendar.SECOND);					
					String h = Integer.toString(hora);
					String m = "";
					String s = "";
					if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
					if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);	 
					horaVar= h+":"+m+":"+s;	
					celda.setCellValue(horaVar);
					celda.setCellStyle(estiloIzquierda);				
								
					fila = hoja.createRow(5); // Generamos la fila a la que pertenecen los valores anteriores	
					
					celda=fila.createCell((short)2); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue("Empresa Nomina: ");	
					
					celda=fila.createCell((short)3); //Asignamos el numero del lugar de nuestra celda
					celda.setCellValue(convenioNominaBean.getNombreInstitNomina());	
					
					celda=fila.createCell((short)4); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue("No Convenio: ");
					
					celda=fila.createCell((short)5); //Asignamos el numero del lugar de nuestra celda
					String noConv = "";
					if (convenioNominaBean.getConvenioNominaID().equals("0")){
						noConv = "TODOS";
					}
					else {
						noConv = convenioNominaBean.getConvenioNominaID();
					}
					celda.setCellValue(noConv);	
					
					celda=fila.createCell((short)6); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue("Fecha Inicio: ");
					
					celda=fila.createCell((short)7); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(convenioNominaBean.getFechaInicio());	
					
					celda=fila.createCell((short)8); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue("Fecha Final: ");
					
					celda=fila.createCell((short)9); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(convenioNominaBean.getFechaFin());
					
					fila = hoja.createRow(6);
					fila = hoja.createRow(7);

					// Inicia de la declaracion de Encabezado de columnas
					celda=fila.createCell((short)1);	//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloBordes);
					celda.setCellValue("Fecha Modificación"); 
					
					celda=fila.createCell((short)2);	//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloBordes);
					celda.setCellValue("Hora");
					
					celda=fila.createCell((short)3);	//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloBordesMezcla);
					celda.setCellValue("Empresa Nomina");
					celda=fila.createCell((short)4);
					celda.setCellStyle(estiloBordesMezcla);
					celda.setCellValue("");
					hoja.addMergedRegion(new CellRangeAddress( // Rango de filas que requeriremos para la union de estas mismas
				            7, //primera fila 
				            7, //ultima fila 
				            3, //primer celda
				            4 //ultima celda
				    ));	
					
					celda=fila.createCell((short)5);	//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloBordes);
					celda.setCellValue("No Convenio");
					
					celda=fila.createCell((short)6);	//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloBordes);
					celda.setCellValue("No Actualizaciones");
					
					celda=fila.createCell((short)7);	//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloBordesMezcla);
					celda.setCellValue("Usuario Modificó");
					celda=fila.createCell((short)8);
					celda.setCellStyle(estiloBordesMezcla);
					celda.setCellValue("");
					celda=fila.createCell((short)9);
					celda.setCellStyle(estiloBordesMezcla);
					celda.setCellValue("");
					hoja.addMergedRegion(new CellRangeAddress( // Rango de filas que requeriremos para la union de estas mismas
				            7, //primera fila 
				            7, //ultima fila 
				            7, //primer celda
				            9 //ultima celda
				    ));	
					
					celda=fila.createCell((short)10);	//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloBordesMezcla);
					celda.setCellValue("Sucursal");
					celda=fila.createCell((short)11);
					celda.setCellStyle(estiloBordes);
					celda.setCellValue("");
					hoja.addMergedRegion(new CellRangeAddress( // Rango de filas que requeriremos para la union de estas mismas
				            7, //primera fila 
				            7, //ultima fila 
				            10, //primer celda
				            11 //ultima celda
				    ));	
					// Finaliza de la declaracion de Encabezado de columnas
					
					fila = hoja.createRow(8); // Generamos la fila a la que pertenecen los valores anteriores							
				
					for (int celd = 0; celd <= 42; celd++){
						hoja.autoSizeColumn(celd, true);
					}
					
					int i=8; //Creamos nuestro contador con el valor de la siguiente fila de la anteriormente creada
					
					for(ConvenioNominaBean bitacoraConveniosBean : listaHistoricoConvenios ){
						
						fila=hoja.createRow(i); // Generamos la fila 
						
						//Obtenemos los datos que contiene nuestro bean
						celda=fila.createCell((short)1);
						celda.setCellStyle(estiloDerecha);
						celda.setCellValue(bitacoraConveniosBean.getFechaCambio().equals(null) || bitacoraConveniosBean.getFechaCambio().equals("") ? "-" : bitacoraConveniosBean.getFechaCambio());		
						
						//Obtenemos los datos que contiene nuestro bean
						celda=fila.createCell((short)2);
						celda.setCellStyle(estiloDerecha);
						celda.setCellValue(bitacoraConveniosBean.getHoraCambio().equals(null) || bitacoraConveniosBean.getHoraCambio().equals("") ? "-" : bitacoraConveniosBean.getHoraCambio());
						
						//Obtenemos los datos que contiene nuestro bean
						celda=fila.createCell((short)3);
						celda.setCellValue(bitacoraConveniosBean.getNombreInstitNomina().equals(null) || bitacoraConveniosBean.getNombreInstitNomina().equals("") ? "-" : bitacoraConveniosBean.getNombreInstitNomina());
						hoja.addMergedRegion(new CellRangeAddress( // Rango de filas que requeriremos para la union de estas mismas
					            i, //primera fila 
					            i, //ultima fila 
					            3, //primer celda
					            4 //ultima celda
					    ));	
						
						//Obtenemos los datos que contiene nuestro bean
						celda=fila.createCell((short)5);
						celda.setCellStyle(estiloDerecha);
						celda.setCellValue(bitacoraConveniosBean.getConvenioNominaID().equals(null) || bitacoraConveniosBean.getConvenioNominaID().equals("") ? "-" : bitacoraConveniosBean.getConvenioNominaID());
						
						//Obtenemos los datos que contiene nuestro bean
						celda=fila.createCell((short)6);
						celda.setCellStyle(estiloDerecha);
						celda.setCellValue(bitacoraConveniosBean.getNumActualizaciones().equals(null) || bitacoraConveniosBean.getNumActualizaciones().equals("") ? "-" : bitacoraConveniosBean.getNumActualizaciones());
						
						//Obtenemos los datos que contiene nuestro bean
						celda=fila.createCell((short)7);
						celda.setCellValue(bitacoraConveniosBean.getNombreCompleto().equals(null) || bitacoraConveniosBean.getNombreCompleto().equals("") ? "-" : bitacoraConveniosBean.getNombreCompleto());
						hoja.addMergedRegion(new CellRangeAddress( // Rango de filas que requeriremos para la union de estas mismas
					            i, //primera fila 
					            i, //ultima fila 
					            7, //primer celda
					            9 //ultima celda
					    ));	
						
						//Obtenemos los datos que contiene nuestro bean
						celda=fila.createCell((short)10);
						celda.setCellValue(bitacoraConveniosBean.getNombreSucurs().equals(null) || bitacoraConveniosBean.getNombreSucurs().equals("") ? "-" : bitacoraConveniosBean.getNombreSucurs());
						hoja.addMergedRegion(new CellRangeAddress( // Rango de filas que requeriremos para la union de estas mismas
					            i, //primera fila 
					            i, //ultima fila 
					            10, //primer celda
					            11 //ultima celda
					    ));	
					
						regExport = regExport + 1;
		
						i++;
					}	
					
					i++;
					
					fila = hoja.createRow(i);
					celda=fila.createCell((short)1);
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue("Registros Exportados");
					
					celda=fila.createCell((short)3);
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue("Procedimiento");
					
					i++;
					
					int count = listaHistoricoConvenios.size();
					
					fila = hoja.createRow(i);
					celda=fila.createCell((short)1);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(count);
					
					celda=fila.createCell((short)3);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue("HISCONVENIOSNOMINAREP");
					
					hoja.setColumnWidth(1, 2798);
					hoja.setColumnWidth(2, 3351);
					hoja.setColumnWidth(3, 8690);
					hoja.setColumnWidth(4, 8650);
					hoja.setColumnWidth(5, 6610);						
					hoja.setColumnWidth(6, 4690);						
					hoja.setColumnWidth(7, 3392);
					hoja.setColumnWidth(8, 7325);
					hoja.setColumnWidth(9, 4000);
					hoja.setColumnWidth(10, 4690);						
					hoja.setColumnWidth(11, 3392);
				}	
				for (int celd = 0; celd <= 42; celd++){
					try {
						
					  hoja.autoSizeColumn(celd, true);
						
					} catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
				}
		
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=BitacoraCambiosInstitNom.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				libro.write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				}catch(Exception e){
				
					e.printStackTrace();
				}//Fin del catch
			}
			return listaHistoricoConvenios;
		}

	public List<ConvenioNominaBean> listaReporteExcelIndividual(int tipoReporte, ConvenioNominaBean convenioNominaBean,  HttpServletResponse response){
			
		List<ConvenioNominaBean> listaHistoricoConvenios=null;

		listaHistoricoConvenios = listaReporte(Enum_Rep_BitaCon.reporteIndividual, convenioNominaBean, response);
		
		int regExport = 0;
		Calendar calendario = Calendar.getInstance();
		
		if(listaHistoricoConvenios != null){
			try {
				Workbook libro = new SXSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				Font fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setFontName("Negrita");
				fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);						
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				Font fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)10);
				fuenteNegrita8.setFontName("Negrita");
				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				Font fuenteNegritaGroup= libro.createFont();
				fuenteNegritaGroup.setFontHeightInPoints((short)10);
				fuenteNegritaGroup.setFontName("Negrita");
				fuenteNegritaGroup.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				Font fuenteNegrita= libro.createFont();
				fuenteNegrita.setFontHeightInPoints((short)10);
				fuenteNegrita.setFontName("Negrita");
				fuenteNegrita.setBoldweight(Font.BOLDWEIGHT_BOLD);

				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				CellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				estiloNeg10.setAlignment(CellStyle.ALIGN_CENTER);			
				
				//Estilo negrita de 8  para encabezados del reporte
				CellStyle estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);
				
				//Estilo negrita de 8  y color de fondo
				CellStyle estiloColor = libro.createCellStyle();
				estiloColor.setFont(fuenteNegrita8);
				estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
				estiloColor.setFillPattern(CellStyle.SOLID_FOREGROUND);
				
				CellStyle estiloIzquierda = libro.createCellStyle();
				estiloIzquierda.setFont(fuenteNegrita);
				estiloIzquierda.setAlignment(CellStyle.ALIGN_LEFT);	
				
				//Estilo normal de 8 y alineacion a la derecha
				CellStyle estiloDerecha = libro.createCellStyle();
				estiloDerecha.setAlignment(CellStyle.ALIGN_RIGHT);	
				
				
				//Estilo negrita 8 con bordes
				CellStyle estiloBordes = libro.createCellStyle();
				estiloBordes.setBorderBottom(CellStyle.BORDER_THIN);
				estiloBordes.setBorderTop(CellStyle.BORDER_THIN);
				estiloBordes.setBorderRight(CellStyle.BORDER_THIN);
				estiloBordes.setBorderLeft(CellStyle.BORDER_THIN);
				estiloBordes.setFont(fuenteNegrita);
				estiloBordes.setAlignment(CellStyle.ALIGN_CENTER);
				
				//Estilo negrita 8 con bordes mezclados
				CellStyle estiloBordesMezcla = libro.createCellStyle();
				estiloBordesMezcla.setBorderBottom(CellStyle.BORDER_THIN);
				estiloBordesMezcla.setBorderTop(CellStyle.BORDER_THIN);
				estiloBordesMezcla.setFont(fuenteNegrita);
				estiloBordesMezcla.setAlignment(CellStyle.ALIGN_CENTER);
				
				//Encabezado agrupaciones
				CellStyle estiloAgrupacion = libro.createCellStyle();
				estiloAgrupacion.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloAgrupacion.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloAgrupacion.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setFont(fuenteNegritaGroup);
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
				
				
				//Asignamos el nombre de la hoja 
				SXSSFSheet hoja = null;
				hoja = (SXSSFSheet) libro.createSheet("BITÁCORA DETALLA DE CAMBIOS DE PARÁMETROS DE EMPRESA DE NÓMINA");
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);		

				
				if(tipoReporte == Enum_Rep_BitaCon.reporteIndividual) {	
					fila = hoja.createRow(1);
					fila = hoja.createRow(2);
					
					// Usuario que genera el reporte       
					celda = fila.createCell((short)7); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue("Usuario:");		
						
					//Obtenemos el nombre del usuario
					celda = fila.createCell((short)8); //Asignamos el numero del lugar de nuestra celda
					celda.setCellValue(convenioNominaBean.getNombreUsuario());
					celda.setCellStyle(estiloIzquierda);
						
					//Asignamos el titulo del reporte 
					celda = fila.createCell	((short)1);//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue(convenioNominaBean.getNombreInstitucion());
					CellRangeAddress region = new CellRangeAddress(
							2,
							(short)2,
							1,
							(short)6);
					hoja.addMergedRegion(region);
				
					fila = hoja.createRow(3); // Generamos la fila a la que pertenecen los valores anteriores					
					
					// Fecha de Emisión del Reporte
					celda=fila.createCell((short)7); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue("Fecha: ");
					
					// Obtenemos la fecha de Emisión del reporte
					celda=fila.createCell((short)8); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue(convenioNominaBean.getFechaSistema());	
					
					//Asignamos el sub-titulo que contendra las fechas de rango del reporte
					celda = fila.createCell	((short)1);//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("BITÁCORA DETALLA DE CAMBIOS DE PARÁMETROS DE EMPRESA DE NÓMINA");
					hoja.addMergedRegion(new CellRangeAddress( // Rango de filas que requeriremos para la union de estas mismas
				            3, //primera fila 
				            3, //ultima fila 
				            1, //primer celda
				            6 //ultima celda
				    ));		
										
					fila = hoja.createRow(4); // Generamos la fila a la que pertenecen los valores anteriores											
					
					//Asignamos la hora de Emisión del reporte
					celda = fila.createCell((short)7); //Asignamos el numero del lugar de nuestra celda
					celda.setCellValue("Hora: ");
					celda.setCellStyle(estiloIzquierda);
					celda = fila.createCell((short)8); //Asignamos el numero del lugar de nuestra celda
					String horaVar="";				 
					int hora =calendario.get(Calendar.HOUR_OF_DAY);
					int minutos = calendario.get(Calendar.MINUTE);
					int segundos = calendario.get(Calendar.SECOND);					
					String h = Integer.toString(hora);
					String m = "";
					String s = "";
					if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
					if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);	 
					horaVar= h+":"+m+":"+s;	
					celda.setCellValue(horaVar);
					celda.setCellStyle(estiloIzquierda);				
					
					fila = hoja.createRow(5); // Generamos la fila a la que pertenecen los valores anteriores	
					fila = hoja.createRow(6); // Generamos la fila a la que pertenecen los valores anteriores	
					
					celda=fila.createCell((short)1); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue("Empresa Nomina");	
					
					celda=fila.createCell((short)2); //Asignamos el numero del lugar de nuestra celda
					celda.setCellValue(convenioNominaBean.getNombreInstitNomina());	
					
					celda=fila.createCell((short)3); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue("No Convenio");
					
					celda=fila.createCell((short)4); //Asignamos el numero del lugar de nuestra celda
					celda.setCellValue(convenioNominaBean.getConvenioNominaID());	
					
					celda=fila.createCell((short)5); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue("Fecha Inicio");
					
					celda=fila.createCell((short)6); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(convenioNominaBean.getFechaInicio());	
					
					celda=fila.createCell((short)7); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue("Fecha Final");
					
					celda=fila.createCell((short)8); //Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(convenioNominaBean.getFechaFin());
					
					fila = hoja.createRow(7);
					fila = hoja.createRow(8);
			
					celda=fila.createCell((short)1);	//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloBordes);
					celda.setCellValue("Hora");
					
					celda=fila.createCell((short)2);	//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloBordes);
					celda.setCellValue("Empresa Nomina");

					celda=fila.createCell((short)3);	//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloBordes);
					celda.setCellValue("No Convenio");
					
					celda=fila.createCell((short)4);	//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloBordes);
					celda.setCellValue("No Actualizaciones");
					
					celda=fila.createCell((short)5);	//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloBordes);
					celda.setCellValue("Cambios");
										
					celda=fila.createCell((short)6);	//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloBordes);
					celda.setCellValue("Usuario Modificó");
				
					celda=fila.createCell((short)7);	//Asignamos el numero del lugar de nuestra celda
					celda.setCellStyle(estiloBordes);
					celda.setCellValue("Sucursal");
					
					// Finaliza de la declaracion de Encabezado de columnas
					
					fila = hoja.createRow(9); // Generamos la fila a la que pertenecen los valores anteriores							
					for (int celd = 0; celd <= 42; celd++){
						try {
							
						  hoja.autoSizeColumn(celd, true);
							
						} catch (Exception e) {
							// TODO: handle exception
							e.printStackTrace();
						}
					}
					
					int i=9; //Creamos nuestro contador con el valor de la siguiente fila de la anteriormente creada
					
					for(ConvenioNominaBean bitacoraConveniosBean : listaHistoricoConvenios ){
						
						fila=hoja.createRow(i); // Generamos la fila 						
						//Obtenemos los datos que contiene nuestro bean
						celda=fila.createCell((short)1);
						celda.setCellStyle(estiloDerecha);
						celda.setCellValue(bitacoraConveniosBean.getHoraCambio().equals(null) || bitacoraConveniosBean.getHoraCambio().equals("") ? "-" : bitacoraConveniosBean.getHoraCambio());
						
						//Obtenemos los datos que contiene nuestro bean
						celda=fila.createCell((short)2);
						celda.setCellValue(bitacoraConveniosBean.getNombreInstitNomina().equals(null) || bitacoraConveniosBean.getNombreInstitNomina().equals("") ? "-" : bitacoraConveniosBean.getNombreInstitNomina());

						//Obtenemos los datos que contiene nuestro bean
						celda=fila.createCell((short)3);
						celda.setCellStyle(estiloDerecha);
						celda.setCellValue(bitacoraConveniosBean.getConvenioNominaID().equals(null) || bitacoraConveniosBean.getConvenioNominaID().equals("") ? "-" : bitacoraConveniosBean.getConvenioNominaID());
						
						//Obtenemos los datos que contiene nuestro bean
						celda=fila.createCell((short)4);
						celda.setCellStyle(estiloDerecha);
						celda.setCellValue(bitacoraConveniosBean.getNumActualizaciones().equals(null) || bitacoraConveniosBean.getNumActualizaciones().equals("") ? "-" : bitacoraConveniosBean.getNumActualizaciones());
						
						//Obtenemos los datos que contiene nuestro bean
						celda=fila.createCell((short)5);
						celda.setCellValue(bitacoraConveniosBean.getCambios().equals(null) || bitacoraConveniosBean.getCambios().equals("") ? "-" : bitacoraConveniosBean.getCambios());

						
						//Obtenemos los datos que contiene nuestro bean
						celda=fila.createCell((short)6);
						celda.setCellValue(bitacoraConveniosBean.getNombreCompleto().equals(null) || bitacoraConveniosBean.getNombreCompleto().equals("") ? "-" : bitacoraConveniosBean.getNombreCompleto());

						
						//Obtenemos los datos que contiene nuestro bean
						celda=fila.createCell((short)7);
						celda.setCellValue(bitacoraConveniosBean.getNombreSucurs().equals(null) || bitacoraConveniosBean.getNombreSucurs().equals("") ? "-" : bitacoraConveniosBean.getNombreSucurs());
							
						regExport = regExport + 1;
								
						i++;
					}	
					
					i++;
					
					fila = hoja.createRow(i);
					celda=fila.createCell((short)0);
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue("Registros Exportados");
					
					celda=fila.createCell((short)2);
					celda.setCellStyle(estiloIzquierda);
					celda.setCellValue("Procedimiento");
					
					i++;
					
					int count = listaHistoricoConvenios.size();
					
					fila = hoja.createRow(i);
					celda=fila.createCell((short)0);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(count);
					
					celda=fila.createCell((short)2);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue("HISCONVENIOSNOMINAREP");
					
					hoja.setColumnWidth(1, 2798);
					hoja.setColumnWidth(2, 3351);
					hoja.setColumnWidth(3, 8690);
					hoja.setColumnWidth(4, 8650);
					hoja.setColumnWidth(5, 6610);						
					hoja.setColumnWidth(6, 4690);						
					hoja.setColumnWidth(7, 7392);
					hoja.setColumnWidth(8, 7325);
					hoja.setColumnWidth(9, 4000);
					hoja.setColumnWidth(10, 4690);						
					hoja.setColumnWidth(11, 3392);
					hoja.setColumnWidth(12, 3392);
					hoja.setColumnWidth(13, 3392);
				}	
					
				for (int celd = 0; celd <= 42; celd++){
					try {
						
					  hoja.autoSizeColumn(celd, true);
						
					} catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
				}
		
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=BitacoraCambiosInstitNomIndividual.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				libro.write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				}catch(Exception e){
				
					e.printStackTrace();
				}//Fin del catch
			}
			return listaHistoricoConvenios;
		}

	public BitacoraConveniosNominaDAO getBitacoraConveniosNominaDAO() {
		return bitacoraConveniosNominaDAO;
	}

	public void setBitacoraConveniosNominaDAO(BitacoraConveniosNominaDAO bitacoraConveniosNominaDAO) {
		this.bitacoraConveniosNominaDAO = bitacoraConveniosNominaDAO;
	}
}
