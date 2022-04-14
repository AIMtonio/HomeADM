package ventanilla.servicio;

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
import ventanilla.bean.RemesasPagadasRepBean;
import ventanilla.dao.RemesasPagadasRepDAO;

public class RemesasPagadasRepServicio extends BaseServicio {
	
	RemesasPagadasRepDAO remesasPagadasDAO = null;
	
	public static interface Enum_Rep_RemePag {
		int reporteExcel = 1;
	}
	
	/* Controla los tipos de lista para reportes*/
	public List <RemesasPagadasRepBean> listaReporte(int tipoReporte, RemesasPagadasRepBean remesasPagadasBean, HttpServletResponse response){
		 List <RemesasPagadasRepBean> listaReporteExcel = null;
	
		 switch(tipoReporte){		
		 	case  Enum_Rep_RemePag.reporteExcel:				
		 		listaReporteExcel = remesasPagadasDAO.reporteExcel(remesasPagadasBean);
		 		break;
			}
		return listaReporteExcel;
	}
	
	public List<RemesasPagadasRepBean> listaReporteExcel(int tipoReporte, RemesasPagadasRepBean remesasPagadasBean,  HttpServletResponse response){
			
		List<RemesasPagadasRepBean> listaRemesasPagadas = null;
		
		listaRemesasPagadas = listaReporte(Enum_Rep_RemePag.reporteExcel, remesasPagadasBean, response);
		
		int regExport = 0;
		Calendar calendario = Calendar.getInstance();
		
		if(listaRemesasPagadas != null){
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
				hoja = (SXSSFSheet) libro.createSheet("Reporte de Remesas Pagadas");
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);		
		
				
				fila = hoja.createRow(1);
				fila = hoja.createRow(2);

				//Asignamos el titulo del reporte 
				celda = fila.createCell	((short)2);//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue(remesasPagadasBean.getNombreInstitucion());
				CellRangeAddress region = new CellRangeAddress(
						2,
						(short)2,
						2,
						(short)8);
				hoja.addMergedRegion(region);
				
				// Usuario que genera el reporte       
				celda = fila.createCell((short)10); //Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloIzquierda);
				celda.setCellValue("Usuario:");		
					
				//Obtenemos el nombre del usuario
				celda = fila.createCell((short)11); //Asignamos el numero del lugar de nuestra celda
				celda.setCellValue(remesasPagadasBean.getUsuarioSistema());
				celda.setCellStyle(estiloIzquierda);
			
				fila = hoja.createRow(3); // Generamos la fila a la que pertenecen los valores anteriores					
				
				// Fecha de Emisión del Reporte
				celda=fila.createCell((short)10); //Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloIzquierda);
				celda.setCellValue("Fecha: ");
				
				// Obtenemos la fecha de Emisión del reporte
				celda=fila.createCell((short)11); //Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloIzquierda);
				celda.setCellValue(remesasPagadasBean.getFechaSistema());	
				
				//Asignamos el sub-titulo que contendra las fechas de rango del reporte
				String periodo = "Reporte de Remesas Pagadas del " + remesasPagadasBean.getFechaInicial() + " al " + remesasPagadasBean.getFechaFinal();
				celda = fila.createCell	((short)2);//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue(periodo);
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
				
				celda=fila.createCell((short)1); //Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloIzquierda);
				celda.setCellValue("Remesadora: ");	
				
				celda=fila.createCell((short)2); //Asignamos el numero del lugar de nuestra celda
				celda.setCellValue(remesasPagadasBean.getRemesadora());	
				
				celda=fila.createCell((short)5); //Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloIzquierda);
				celda.setCellValue("Sucursal: ");
				
				celda=fila.createCell((short)6); //Asignamos el numero del lugar de nuestra celda
				celda.setCellValue(remesasPagadasBean.getSucursal());	
				
				celda=fila.createCell((short)8); //Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloIzquierda);
				celda.setCellValue("Usuario: ");
				
				celda=fila.createCell((short)9); //Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloDerecha);
				celda.setCellValue(remesasPagadasBean.getNombreUsuario());	
				
				fila = hoja.createRow(6);
				fila = hoja.createRow(7);
	
				// Inicia de la declaracion de Encabezado de columnas
				celda=fila.createCell((short)1);	//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloBordes);
				celda.setCellValue("Fecha de Pago"); 
				
				celda=fila.createCell((short)2);	//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloBordes);
				celda.setCellValue("Remesadora");
				
				celda=fila.createCell((short)3);	//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloBordes);
				celda.setCellValue("Referencia");
				
				celda=fila.createCell((short)4);	//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloBordes);
				celda.setCellValue("Sucursal");
				
				celda=fila.createCell((short)5);	//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloBordes);
				celda.setCellValue("Beneficiario / Cliente");	
				
				celda=fila.createCell((short)6);	//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloBordes);
				celda.setCellValue("Monto");
				
				celda=fila.createCell((short)7);	//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloBordes);
				celda.setCellValue("Cajero");
				
				celda=fila.createCell((short)8);	//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloBordesMezcla);
				celda.setCellValue("Forma de Pago");
				celda=fila.createCell((short)9);
				celda.setCellStyle(estiloBordesMezcla);
				celda.setCellValue("");
				hoja.addMergedRegion(new CellRangeAddress( // Rango de filas que requeriremos para la union de estas mismas
			            7, //primera fila 
			            7, //ultima fila 
			            8, //primer celda
			            9 //ultima celda
			    ));	
				
				celda=fila.createCell((short)10);	//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloBordes);
				celda.setCellValue("Billetes 1000");
				
				celda=fila.createCell((short)11);	//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloBordes);
				celda.setCellValue("Billetes 500");
				
				celda=fila.createCell((short)12);	//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloBordes);
				celda.setCellValue("Billetes 200");
				
				celda=fila.createCell((short)13);	//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloBordes);
				celda.setCellValue("Billetes 100");
				
				celda=fila.createCell((short)14);	//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloBordes);
				celda.setCellValue("Billetes 50");
				
				celda=fila.createCell((short)15);	//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloBordes);
				celda.setCellValue("Billetes 20");
				
				celda=fila.createCell((short)16);	//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloBordes);
				celda.setCellValue("Monedas");
				
				celda=fila.createCell((short)17);	//Asignamos el numero del lugar de nuestra celda
				celda.setCellStyle(estiloBordes);
				celda.setCellValue("No. Impresiones");
				
				// Finaliza de la declaracion de Encabezado de columnas
				
				fila = hoja.createRow(8); // Generamos la fila a la que pertenecen los valores anteriores							
			
				for (int celd = 0; celd <= 80; celd++){
					hoja.autoSizeColumn(celd, true);
				}
				
				int i=8; //Creamos nuestro contador con el valor de la siguiente fila de la anteriormente creada
				
				for(RemesasPagadasRepBean remesaPagadaBean : listaRemesasPagadas ){
					
					fila=hoja.createRow(i); // Generamos la fila 
					
					//Obtenemos los datos que contiene nuestro bean
					celda=fila.createCell((short)1);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(remesaPagadaBean.getFechaDePago().equals(null) || remesaPagadaBean.getFechaDePago().equals("") ? "-" : remesaPagadaBean.getFechaDePago());		
					
					//Obtenemos los datos que contiene nuestro bean
					celda=fila.createCell((short)2);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(remesaPagadaBean.getRemesadora().equals(null) || remesaPagadaBean.getRemesadora().equals("") ? "-" : remesaPagadaBean.getRemesadora());
					
					//Obtenemos los datos que contiene nuestro bean
					celda=fila.createCell((short)3);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(remesaPagadaBean.getReferencia().equals(null) || remesaPagadaBean.getReferencia().equals("") ? "-" : remesaPagadaBean.getReferencia());		
					
					//Obtenemos los datos que contiene nuestro bean
					celda=fila.createCell((short)4);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(remesaPagadaBean.getSucursal().equals(null) || remesaPagadaBean.getSucursal().equals("") ? "-" : remesaPagadaBean.getSucursal());

					//Obtenemos los datos que contiene nuestro bean
					celda=fila.createCell((short)5);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(remesaPagadaBean.getCliente().equals(null) || remesaPagadaBean.getCliente().equals("") ? "-" : remesaPagadaBean.getCliente());		
					
					//Obtenemos los datos que contiene nuestro bean
					celda=fila.createCell((short)6);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(remesaPagadaBean.getMonto().equals(null) || remesaPagadaBean.getMonto().equals("") ? "-" : remesaPagadaBean.getMonto());

					//Obtenemos los datos que contiene nuestro bean
					celda=fila.createCell((short)7);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(remesaPagadaBean.getCajero().equals(null) || remesaPagadaBean.getCajero().equals("") ? "-" : remesaPagadaBean.getCajero());		
					
					//Obtenemos los datos que contiene nuestro bean
					celda=fila.createCell((short)8);
					celda.setCellValue(remesaPagadaBean.getFormaDePago().equals(null) || remesaPagadaBean.getFormaDePago().equals("") ? "-" : remesaPagadaBean.getFormaDePago());
					hoja.addMergedRegion(new CellRangeAddress( // Rango de filas que requeriremos para la union de estas mismas
				            i, //primera fila 
				            i, //ultima fila 
				            8, //primer celda
				            9 //ultima celda
				    ));	
					
					//Obtenemos los datos que contiene nuestro bean
					celda=fila.createCell((short)10);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(remesaPagadaBean.getBilletesMil().equals(null) || remesaPagadaBean.getBilletesMil().equals("") ? "-" : remesaPagadaBean.getBilletesMil());
					
					//Obtenemos los datos que contiene nuestro bean
					celda=fila.createCell((short)11);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(remesaPagadaBean.getBilletesQuinientos().equals(null) || remesaPagadaBean.getBilletesQuinientos().equals("") ? "-" : remesaPagadaBean.getBilletesQuinientos());		
					
					//Obtenemos los datos que contiene nuestro bean
					celda=fila.createCell((short)12);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(remesaPagadaBean.getBilletesDoscientos().equals(null) || remesaPagadaBean.getBilletesDoscientos().equals("") ? "-" : remesaPagadaBean.getBilletesDoscientos());

					//Obtenemos los datos que contiene nuestro bean
					celda=fila.createCell((short)13);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(remesaPagadaBean.getBilletesCien().equals(null) || remesaPagadaBean.getBilletesCien().equals("") ? "-" : remesaPagadaBean.getBilletesCien());

					//Obtenemos los datos que contiene nuestro bean
					celda=fila.createCell((short)14);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(remesaPagadaBean.getBilletesCincuenta().equals(null) || remesaPagadaBean.getBilletesCincuenta().equals("") ? "-" : remesaPagadaBean.getBilletesCincuenta());

					//Obtenemos los datos que contiene nuestro bean
					celda=fila.createCell((short)15);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(remesaPagadaBean.getBilletesVeinte().equals(null) || remesaPagadaBean.getBilletesVeinte().equals("") ? "-" : remesaPagadaBean.getBilletesVeinte());

					//Obtenemos los datos que contiene nuestro bean
					celda=fila.createCell((short)16);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(remesaPagadaBean.getMonedas().equals(null) || remesaPagadaBean.getMonedas().equals("") ? "-" : remesaPagadaBean.getMonedas());
					
					//Obtenemos los datos que contiene nuestro bean
					celda=fila.createCell((short)17);
					celda.setCellStyle(estiloDerecha);
					celda.setCellValue(remesaPagadaBean.getNoImpresiones().equals(null) || remesaPagadaBean.getNoImpresiones().equals("") ? "-" : remesaPagadaBean.getNoImpresiones());
					
					regExport = regExport + 1;
	
					i++;
				}	
				
				i++;
				int count = listaRemesasPagadas.size();
				
				fila = hoja.createRow(i);
				celda=fila.createCell((short)1);
				celda.setCellStyle(estiloIzquierda);
				celda.setCellValue("Registros Exportados: ");
				
				celda=fila.createCell((short)2);
				celda.setCellStyle(estiloDerecha);
				celda.setCellValue(count);
				
				hoja.setColumnWidth(1, 3400);
				hoja.setColumnWidth(2, 3400);
				hoja.setColumnWidth(3, 3400);
				hoja.setColumnWidth(4, 3400);
				hoja.setColumnWidth(5, 3400);						
				hoja.setColumnWidth(6, 3400);						
				hoja.setColumnWidth(7, 3400);
				hoja.setColumnWidth(8, 3400);
				hoja.setColumnWidth(9, 3400);
				hoja.setColumnWidth(10, 3400);						
				hoja.setColumnWidth(11, 3400);
				hoja.setColumnWidth(12, 3400);
				hoja.setColumnWidth(13, 3400);
				hoja.setColumnWidth(14, 3400);
				hoja.setColumnWidth(15, 3400);
				hoja.setColumnWidth(16, 3400);
				hoja.setColumnWidth(17, 3400);
				
	
				for (int celd = 0; celd <= 80; celd++){
					try {
					  hoja.autoSizeColumn(celd, true);
					} catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
				}
		
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=RemesasPagadas.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				libro.write(outputStream);
				outputStream.flush();
				outputStream.close();
				
			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
		}
		return listaRemesasPagadas;
	}

	public RemesasPagadasRepDAO getRemesasPagadasDAO() {
		return remesasPagadasDAO;
	}

	public void setRemesasPagadasDAO(RemesasPagadasRepDAO remesasPagadasDAO) {
		this.remesasPagadasDAO = remesasPagadasDAO;
	}

}
