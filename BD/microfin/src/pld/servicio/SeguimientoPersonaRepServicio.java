package pld.servicio;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import pld.bean.PerfilTransaccionalBean;
import pld.bean.SeguimientoPersonaRepBean;
import pld.dao.SeguimientoPersonaRepDAO;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class SeguimientoPersonaRepServicio extends BaseServicio{
	
	SeguimientoPersonaRepDAO seguimientoPersonaRepDAO = null;
	ParametrosSisServicio	parametrosSisServicio	= null;
	
	public void reporteExcel(SeguimientoPersonaRepBean seguimientoPersonaRepBean, HttpServletRequest request, HttpServletResponse response,int tipoReporte){
		try{
		List<SeguimientoPersonaRepBean> listaReporte = seguimientoPersonaRepDAO.seguimientoPersonasRep(seguimientoPersonaRepBean, tipoReporte);
		// Se obtiene el tipo de institucion financiera
					ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
					parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.tipoInstitFin, parametrosSisBean);
					String safilocaleCliente = Utileria.generaLocale("safilocale.cliente", parametrosSisBean.getNombreCortoInst());
					
					Calendar calendario = new GregorianCalendar();
					SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm:ss");
					String hora = postFormater.format(calendario.getTime());
					
					XSSFSheet hoja = null;
					XSSFWorkbook libro = null;
					libro = new XSSFWorkbook();
					//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
					XSSFFont fuenteNegrita10 = libro.createFont();
					fuenteNegrita10.setFontHeightInPoints((short) 10);
					fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
					fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
					
					XSSFFont fuenteNegrita10Izq = libro.createFont();
					fuenteNegrita10Izq.setFontHeightInPoints((short) 10);
					fuenteNegrita10Izq.setFontName(HSSFFont.FONT_ARIAL);
					fuenteNegrita10Izq.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
					
					//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
					XSSFFont fuenteNegrita8 = libro.createFont();
					fuenteNegrita8.setFontHeightInPoints((short) 8);
					fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
					fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
					
					// Fuente encabezado del reporte
					XSSFFont fuenteEncabezado = libro.createFont();
					fuenteEncabezado.setFontHeightInPoints((short) 8);
					fuenteEncabezado.setFontName(HSSFFont.FONT_ARIAL);
					fuenteEncabezado.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
					
					//Crea un Fuente con tamaño 8 para informacion del reporte.
					XSSFFont fuente8 = libro.createFont();
					fuente8.setFontHeightInPoints((short) 8);
					fuente8.setFontName(HSSFFont.FONT_ARIAL);
					
					XSSFFont fuente8Centro = libro.createFont();
					fuente8Centro.setFontHeightInPoints((short) 8);
					fuente8Centro.setFontName(HSSFFont.FONT_ARIAL);
					
					XSSFFont fuente8Decimal = libro.createFont();
					fuente8Decimal.setFontHeightInPoints((short) 8);
					fuente8Decimal.setFontName(HSSFFont.FONT_ARIAL);
					
					XSSFFont fuente8Cuerpo = libro.createFont();
					fuente8Cuerpo.setFontHeightInPoints((short) 8);
					fuente8Cuerpo.setFontName(HSSFFont.FONT_ARIAL);
					
					//Crea un Fuente con tamaño 8 para informacion del reporte.
					XSSFFont fuente10 = libro.createFont();
					fuente10.setFontHeightInPoints((short) 10);
					fuente10.setFontName(HSSFFont.FONT_ARIAL);
					
					// La fuente se mete en un estilo para poder ser usada.
					//Estilo negrita de 10 para el titulo del reporte
					XSSFCellStyle estiloNeg10 = libro.createCellStyle();
					estiloNeg10.setFont(fuenteNegrita10);
					estiloNeg10.setAlignment(XSSFCellStyle.ALIGN_CENTER);
					
					//Alineado a la izq
					XSSFCellStyle estiloNeg10Izq = libro.createCellStyle();
					estiloNeg10Izq.setFont(fuenteNegrita10Izq);
					estiloNeg10Izq.setAlignment(XSSFCellStyle.ALIGN_LEFT);
					
					//Estilo negrita de 8  para encabezados del reporte
					XSSFCellStyle estiloNeg8 = libro.createCellStyle();
					estiloNeg8.setFont(fuenteNegrita8);
					
					// Estilo de datos centrados 
					XSSFCellStyle estiloCentrado = libro.createCellStyle();
					estiloCentrado.setFont(fuenteEncabezado);
					estiloCentrado.setAlignment(XSSFCellStyle.ALIGN_CENTER);
					estiloCentrado.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);
					
					// Estilo de datos centrados 
					XSSFCellStyle estiloCentradoCuerpo = libro.createCellStyle();
					estiloCentradoCuerpo.setFont(fuente8Centro);
					estiloCentradoCuerpo.setAlignment(XSSFCellStyle.ALIGN_CENTER);
					estiloCentradoCuerpo.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);
					
					
					XSSFCellStyle estilo8 = libro.createCellStyle();
					estilo8.setFont(fuente8);
					
					XSSFCellStyle estilo10 = libro.createCellStyle();
					estilo10.setFont(fuente10);
					
					
					
					
					//Estilo Formato decimal (0.00)
					XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
					XSSFDataFormat format = libro.createDataFormat();
					estiloFormatoDecimal.setDataFormat(format.getFormat("$#,###,##0.00"));
					estiloFormatoDecimal.setFont(fuente8);
					
					XSSFCellStyle estiloDecimalSinSimbol = libro.createCellStyle();
					XSSFDataFormat format2 = libro.createDataFormat();
					estiloDecimalSinSimbol.setDataFormat(format2.getFormat("#,###,##0.00"));
					estiloDecimalSinSimbol.setFont(fuente8Decimal);
					estiloDecimalSinSimbol.setAlignment(XSSFCellStyle.ALIGN_RIGHT);
					
					//Estilo Formato decimal (0.00)
					XSSFCellStyle estiloFormatoDecimalTit = libro.createCellStyle();
					XSSFDataFormat formatTit = libro.createDataFormat();
					estiloFormatoDecimalTit.setDataFormat(formatTit.getFormat("$#,###,##0.00"));
					estiloFormatoDecimalTit.setFont(fuenteNegrita8);
					
					// Creacion de hoja					
					hoja = libro.createSheet("SeguimientoEnListas");
					
					// inicio fecha, usuario,institucion y hora
					XSSFRow fila = hoja.createRow(0);
					XSSFCell celdaUsu = fila.createCell(9);
					celdaUsu.setCellValue("Usuario:");
					celdaUsu.setCellStyle(estiloNeg10Izq);
					celdaUsu = fila.createCell(10);
					celdaUsu.setCellValue(((!seguimientoPersonaRepBean.getNombreUsuario().isEmpty()) ? seguimientoPersonaRepBean.getNombreUsuario() : "TODOS").toUpperCase());
					
					fila = hoja.createRow(1);
					String fechaVar = seguimientoPersonaRepBean.getFechaSistema().toString();
					XSSFCell celdaFec = fila.createCell(9);
					celdaFec.setCellValue("Fecha:");
					celdaFec.setCellStyle(estiloNeg10Izq);
					celdaFec = fila.createCell(10);
					celdaFec.setCellValue(fechaVar);
					
					XSSFCell celdaInst = fila.createCell((short) 1);
					celdaInst.setCellValue(seguimientoPersonaRepBean.getNombreInstitucion());
					hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					1, //primera fila (0-based)
					1, //ultima fila  (0-based)
					1, //primer celda (0-based)
					8 //ultima celda   (0-based)
					));
					celdaInst.setCellStyle(estiloNeg10);
					
					fila = hoja.createRow(2);
					XSSFCell celdaHora = fila.createCell(9);
					celdaHora.setCellValue("Hora:");
					celdaHora.setCellStyle(estiloNeg10Izq);
					celdaHora = fila.createCell(10);
					celdaHora.setCellValue(hora);
					// fin fecha usuario,institucion y hora
					XSSFCell celda = fila.createCell((short) 1);
					celda.setCellValue("REPORTE DE DETECCIÓN EN LISTAS");
					celda.setCellStyle(estiloNeg10);
					
					hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					2, //primera fila (0-based)
					2, //ultima fila  (0-based)
					1, //primer celda (0-based)
					8 //ultima celda   (0-based)
					));
					celda.setCellStyle(estiloNeg10);
					
					fila = hoja.createRow(3);
					XSSFCell celdaFecha = fila.createCell((short) 1);
					celdaFecha.setCellValue("DEL "+seguimientoPersonaRepBean.getFechaInicio()+" AL "+seguimientoPersonaRepBean.getFechaFin());
					celdaFecha.setCellStyle(estiloNeg10);
					
					hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					3, //primera fila (0-based)
					3, //ultima fila  (0-based)
					1, //primer celda (0-based)
					8 //ultima celda   (0-based)
					));
					celdaFecha.setCellStyle(estiloNeg10);
				
					
					
					//Inicio en la segunda fila y que el fila uno tiene los encabezados
					fila = hoja.createRow(6);
					int numCelda = 0;
					celda = fila.createCell(numCelda);
					hoja.addMergedRegion(new CellRangeAddress(6, 6, numCelda, numCelda));
					

					celda = fila.createCell(numCelda++);
					celda.setCellValue("Folio");
					hoja.addMergedRegion(new CellRangeAddress(6, 6, numCelda, numCelda));
					celda.setCellStyle(estiloCentrado);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue("Número Cliente");
					hoja.addMergedRegion(new CellRangeAddress(6, 6, numCelda, numCelda));
					celda.setCellStyle(estiloCentrado);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue("Nombre Cliente");
					hoja.addMergedRegion(new CellRangeAddress(6, 6, numCelda, numCelda));
					celda.setCellStyle(estiloCentrado);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue("Actividad Cliente");
					hoja.addMergedRegion(new CellRangeAddress(6, 6, numCelda, numCelda));
					celda.setCellStyle(estiloCentrado);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue("Fecha Detección");
					hoja.addMergedRegion(new CellRangeAddress(6, 6, numCelda, numCelda));
					celda.setCellStyle(estiloCentrado);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue("Lista Detección");
					hoja.addMergedRegion(new CellRangeAddress(6, 6, numCelda, numCelda));
					celda.setCellStyle(estiloCentrado);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue("Permite Operación");
					hoja.addMergedRegion(new CellRangeAddress(6, 6, numCelda, numCelda));
					celda.setCellStyle(estiloCentrado);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue("Comentario Cumplimiento");
					hoja.addMergedRegion(new CellRangeAddress(6, 6, numCelda, numCelda));
					celda.setCellStyle(estiloCentrado);
					
					
					
					for (int celd = 0; celd <= 42; celd++) {
						hoja.autoSizeColumn(celd, true);
					}
					int i = 7;
					if (listaReporte != null) {
						
						int tamanioLista = listaReporte.size();
						
						SeguimientoPersonaRepBean sitiBean = null;
						for (int iter = 0; iter < tamanioLista; iter++) {
							sitiBean = (SeguimientoPersonaRepBean) listaReporte.get(iter);
							
							numCelda = 0;
							fila = hoja.createRow(i);
							
							celda = fila.createCell(numCelda++);
							celda.setCellValue(sitiBean.getFolio());
							celda.setCellStyle(estilo8);

							
							celda = fila.createCell(numCelda++);
							celda.setCellValue(sitiBean.getNumcliente());
							celda.setCellStyle(estilo8);
							
							celda = fila.createCell(numCelda++);
							celda.setCellValue(sitiBean.getNombreCliente());
							celda.setCellStyle(estilo8);
							
							celda = fila.createCell(numCelda++);
							celda.setCellValue(sitiBean.getActividadBMX());
							celda.setCellStyle(estilo8);
							
							
							celda = fila.createCell(numCelda++);
							celda.setCellValue(sitiBean.getFechaDeteccion());
							celda.setCellStyle(estiloCentradoCuerpo);
							
							celda = fila.createCell(numCelda++);
							celda.setCellValue(sitiBean.getListaDeteccion());
							celda.setCellStyle(estilo8);
							
							celda = fila.createCell(numCelda++);
							celda.setCellValue(sitiBean.getPermiteOperacion());
							celda.setCellStyle(estiloCentradoCuerpo);
							
							celda = fila.createCell(numCelda++);
							celda.setCellValue(sitiBean.getComentario());
							celda.setCellStyle(estilo8);

							i++;
						}
						
						i = i + 2;
						fila = hoja.createRow(i);
						celda = fila.createCell((short) 0);
						celda.setCellValue("Registros Exportados:");
						celda.setCellStyle(estiloNeg8);

						celda = fila.createCell((short) 1);
						celda.setCellValue(listaReporte.size());
						celda.setCellStyle(estilo8);
						
						i++;
						fila = hoja.createRow(i);
						celda = fila.createCell((short) 0);
					
					}

					for (int celd = 0; celd <= 42; celd++) {
						hoja.autoSizeColumn(celd, true);
					}
					//Creo la cabecera
					response.addHeader("Content-Disposition", "inline; filename=ReporteDeteccionEnListas.xls");
					response.setContentType("application/vnd.ms-excel");
					
					ServletOutputStream outputStream = response.getOutputStream();
					hoja.getWorkbook().write(outputStream);
					outputStream.flush();
					outputStream.close();
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}
		
	}
	
	
	
	
	
	public SeguimientoPersonaRepDAO getSeguimientoPersonaRepDAO() {
		return seguimientoPersonaRepDAO;
	}
	public void setSeguimientoPersonaRepDAO(
			SeguimientoPersonaRepDAO seguimientoPersonaRepDAO) {
		this.seguimientoPersonaRepDAO = seguimientoPersonaRepDAO;
	}





	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
	
	
}
