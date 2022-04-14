package soporte.reporte;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import general.bean.ParametrosSesionBean;
import herramientas.Utileria;
import soporte.bean.ReporteBean;
import soporte.dao.GenDinamicoRepDAO;
import soporte.dao.GenDinamicoRepDAO.Enum_Con_Reporte;
import soporte.dao.GenDinamicoRepDAO.Enum_Tipo_Dato;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ReporteDinamicoServicio;
/**
 * Clase para generar dinamicamente los reportes en excel y PDF, si el diseño de tu reporte tiene otros detalles
 * es preferible que crees sus propias clases, esta clase es para el diseño estandar.
 * @author pmontero
 * @version 1.0.0
 */
public class GenDinamicoRepControlador extends AbstractCommandController{
	ReporteDinamicoServicio		reporteDinamicoServicio	= null;
	ParametrosSesionBean		parametrosSesionBean	= null;
	ParametrosSisServicio		parametrosSisServicio	= null;
	
	String						successView				= null;
	
	public static interface Enum_Con_TipRepor {
		int EXCEL = 1;
		int PDF = 2;
		int Pantalla = 2;
	}

	public GenDinamicoRepControlador() {
		setCommandClass(ReporteBean.class);
		setCommandName("reporteBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		ReporteBean bean = (ReporteBean) command;
		String htmlString = "";
		try {
			int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
			switch (tipoReporte) {
				case Enum_Con_TipRepor.EXCEL:
					reporteExcel(bean, request, response);
				break;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return new ModelAndView(getSuccessView(), "reporte", htmlString);
	}

	/**
	 * Genera el reporte de forma dinamica en excel, la estructura del reporte se registra a nivel de BD.
	 * Revisar las siguientes tablas: 
	 * <b>REPORTEDINAMICO REPDINAMICOPARAM REPDINAMICOCOLUM</b>
	 * @param bean : {@link ReporteBean} Bean que contiene la informacion de los filtros, el numero de reporte reporteID
	 * @param request
	 * @param response
	 */
	private void reporteExcel(ReporteBean bean, HttpServletRequest request, HttpServletResponse response) {
		try {
			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
			String hora = postFormater.format(calendario.getTime());
			
			reporteDinamicoServicio.encabezado(bean, Enum_Con_Reporte.ENCABEZADO);
			bean.setParametros(reporteDinamicoServicio.getParametros(bean));
			bean.setColumnas(reporteDinamicoServicio.getColumnas(bean));
			bean.setFilas(reporteDinamicoServicio.getFilas(bean));

			SXSSFSheet hoja = null;
			SXSSFWorkbook libro = null;
			libro = new SXSSFWorkbook();
			/********************** DECLARACION DE LOS ELEMENTOS PARA EL DISEÑO DEL REPORTE *************************************/
			// Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			Font fuenteNegrita10 = libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short) 10);
			fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);

			Font fuenteNegrita10Izq = libro.createFont();
			fuenteNegrita10Izq.setFontHeightInPoints((short) 10);
			fuenteNegrita10Izq.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10Izq.setBoldweight(Font.BOLDWEIGHT_BOLD);

			// Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			Font fuenteNegrita8 = libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short) 8);
			fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);

			// Fuente encabezado del reporte
			Font fuenteEncabezado = libro.createFont();
			fuenteEncabezado.setFontHeightInPoints((short) 8);
			fuenteEncabezado.setFontName(HSSFFont.FONT_ARIAL);
			fuenteEncabezado.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			Font fuentecentrado = libro.createFont();
			fuentecentrado.setFontHeightInPoints((short) 8);
			fuentecentrado.setFontName(HSSFFont.FONT_ARIAL);
			Font fuentecentradoSinResultados = libro.createFont();
			fuentecentradoSinResultados.setFontHeightInPoints((short) 8);
			fuentecentradoSinResultados.setFontName(HSSFFont.FONT_ARIAL);
			fuentecentradoSinResultados.setColor(HSSFColor.GREY_40_PERCENT.index);

			// Crea un Fuente con tamaño 8 para informacion del reporte.
			Font fuente8 = libro.createFont();
			fuente8.setFontHeightInPoints((short) 8);
			fuente8.setFontName(HSSFFont.FONT_ARIAL);
			
			Font fuenteDatos = libro.createFont();
			fuenteDatos.setFontHeightInPoints((short) 8);
			fuenteDatos.setFontName(HSSFFont.FONT_ARIAL);

			Font fuente8Decimal = libro.createFont();
			fuente8Decimal.setFontHeightInPoints((short) 8);
			fuente8Decimal.setFontName(HSSFFont.FONT_ARIAL);

			Font fuente8Cuerpo = libro.createFont();
			fuente8Cuerpo.setFontHeightInPoints((short) 8);
			fuente8Cuerpo.setFontName(HSSFFont.FONT_ARIAL);

			// Crea un Fuente con tamaño 8 para informacion del reporte.
			Font fuente10 = libro.createFont();
			fuente10.setFontHeightInPoints((short) 10);
			fuente10.setFontName(HSSFFont.FONT_ARIAL);

			// La fuente se mete en un estilo para poder ser usada.
			// Estilo negrita de 10 para el titulo del reporte
			CellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			estiloNeg10.setAlignment(CellStyle.ALIGN_CENTER);
			
			//Alineado a la izq
			CellStyle estiloNeg10Izq = libro.createCellStyle();
			estiloNeg10Izq.setFont(fuenteNegrita10Izq);
			estiloNeg10Izq.setAlignment(CellStyle.ALIGN_LEFT);
			
			//Estilo negrita de 8  para encabezados del reporte
			CellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			// Estilo de datos centrados 
			CellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteEncabezado);
			estiloCentrado.setAlignment(CellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
			
			CellStyle estiloCentradoDatos = libro.createCellStyle();
			estiloCentradoDatos.setFont(fuentecentrado);
			estiloCentradoDatos.setAlignment(CellStyle.ALIGN_CENTER);
			estiloCentradoDatos.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
			
			CellStyle estiloCentradoSinresultados = libro.createCellStyle();
			estiloCentradoSinresultados.setFont(fuentecentradoSinResultados);
			estiloCentradoSinresultados.setAlignment(CellStyle.ALIGN_CENTER);
			estiloCentradoSinresultados.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
			
			CellStyle estilo8 = libro.createCellStyle();
			estilo8.setFont(fuenteDatos);
			estilo8.setAlignment(CellStyle.ALIGN_LEFT);
			estilo8.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
			
			CellStyle estilo10 = libro.createCellStyle();
			estilo10.setFont(fuente10);
			estilo10.setAlignment(CellStyle.ALIGN_LEFT);
			estilo10.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
			
			//Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimal = libro.createCellStyle();
			DataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,###,##0.00"));
			estiloFormatoDecimal.setFont(fuente8);
			
			CellStyle estiloDecimalSinSimbol = libro.createCellStyle();
			DataFormat format2 = libro.createDataFormat();
			estiloDecimalSinSimbol.setDataFormat(format2.getFormat("#,###,##0.00"));
			estiloDecimalSinSimbol.setFont(fuente8Decimal);
			estiloDecimalSinSimbol.setAlignment(CellStyle.ALIGN_RIGHT);
			
			//Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimalTit = libro.createCellStyle();
			DataFormat formatTit = libro.createDataFormat();
			estiloFormatoDecimalTit.setDataFormat(formatTit.getFormat("$#,###,##0.00"));
			estiloFormatoDecimalTit.setFont(fuenteNegrita8);
			
			/********************** FIN DECLARACION DE LOS ELEMENTOS PARA EL DISEÑO DEL REPORTE ********************************* */
			/************************************************ ENCABEZADO DEL REPORTE ******************************************** */
			String nombreHoja=String.valueOf(bean.getNombreHoja());
			if(nombreHoja==null || nombreHoja.isEmpty()) {
				nombreHoja="hoja1";
			}
			hoja = (SXSSFSheet) libro.createSheet(nombreHoja);
			
			int tam=0;
			if(bean.getColumnas()==null) {
				tam=5;
			} else if(bean.getColumnas().size()<(bean.getCampos().size()*3)){
				tam=(bean.getCampos().size()*3);
			} else {
				tam=bean.getColumnas().size();
			}
			
			if(tam<bean.getCampos().size()*3) {
				tam=bean.getCampos().size()*3;
			}
			
			int columnaInfo		= tam - 1;
			int filaN=1;
			Row fila = hoja.createRow(filaN);
			/** ========= FIN NOMBRE INSTITUCION ===========**/
			Cell celdaInst = fila.createCell((short) 1);
			celdaInst.setCellValue(bean.getNombreInstitucion());
			celdaInst.setCellStyle(estiloNeg10);
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					1, //primera fila (0-based)
					1, //ultima fila  (0-based)
					1, //primer celda (0-based)
					tam -3 //ultima celda   (0-based)
					));
			celdaInst.setCellStyle(estiloNeg10);
			/** ========= FIN NOMBRE INSTITUCION ===========**/
			Cell celdaUsu = fila.createCell(columnaInfo);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg10Izq);
			celdaUsu = fila.createCell(columnaInfo+1);
			celdaUsu.setCellValue(((!bean.getUsuario().isEmpty()) ? bean.getUsuario() : "TODOS").toUpperCase());
			celdaUsu.setCellStyle(estilo10);
			filaN++;
			fila = hoja.createRow(filaN);
			/** ============ NOMBRE REPORTE ================**/
			Cell celda2 = fila.createCell((short) 1);
			celda2.setCellValue(bean.getTituloReporte());
			celda2.setCellStyle(estiloNeg10);
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					2, //primera fila (0-based)
					2, //ultima fila  (0-based)
					1, //primer celda (0-based)
					tam -3 //ultima celda   (0-based)
					));
			celda2.setCellStyle(estiloNeg10);
			/** ============ FIN NOMBRE REPORTE ==============**/
			String fechaVar = (bean.getFechaSistema()!=null?bean.getFechaSistema().toString():"");
			Cell celdaFec = fila.createCell(columnaInfo);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg10Izq);
			celdaFec = fila.createCell(columnaInfo+1);
			celdaFec.setCellValue(fechaVar);
			celdaFec.setCellStyle(estilo10);
			filaN++;
			fila = hoja.createRow(filaN);
			Cell celdaHora = fila.createCell(columnaInfo);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg10Izq);
			celdaHora = fila.createCell(columnaInfo+1);
			celdaHora.setCellValue(hora);
			celdaHora.setCellStyle(estilo10);
			
			
			
			/************************************************FIN ENCABEZADO DEL REPORTE ******************************************** */
			/****************************************************** FILTRO REPORTE ************************************************* */
			int col=1;
			int ncel=1;
			filaN=5;
			if(bean.getCampos()!=null && !bean.getCampos().isEmpty()) {
				for(int i=0;i<bean.getCampos().size();i++) {
					try {
						if(i==0 || i%5==0) {
							fila = hoja.createRow(filaN++);
							col=1;
						}
						/*Nombre Filtro*/
						Cell cel= fila.createCell(col);
						cel.setCellValue(bean.getCampos().get(i)+":");
						cel.setCellStyle(estiloNeg10Izq);
						/*Valor Filtro*/
						col+=1;
						Cell celVal= fila.createCell(col);
						celVal.setCellValue(bean.getValorCampos().get(i));
						celVal.setCellStyle(estilo10);
						col+=1;
						ncel++;
						col++;
					}catch(Exception ex) {
						ex.printStackTrace();
						i=bean.getCampos().size()+1;
					}
				}
			}
			/**************************************************** FIN FILTRO REPORTE *********************************************** */
			/********************************************************** COLUMNAS *************************************************** */
			ncel=1;
			fila = hoja.createRow(filaN++);
			fila = hoja.createRow(filaN++);
			for (int i = 0; i < bean.getColumnas().size(); i++) {
				Cell cel = fila.createCell(ncel++);
				cel.setCellValue(bean.getColumnas().get(i).getNombreColumna());
				cel.setCellStyle(estiloCentrado);
			}
			for (int celd = 0; celd <= ncel; celd++) {
				try {
					hoja.autoSizeColumn((short) celd, true);
				} catch (Exception ex) {

				}
			}
			/******************************************************* FIN COLUMNAS ************************************************** */
			/*********************************************************** FILAS ***************************************************** */
			int totalFilas;
			if(bean.getFilas()!=null && !bean.getFilas().isEmpty()) {
				for (int i = 0; i < bean.getFilas().size(); i++) {
					fila = hoja.createRow(filaN++);
					ncel = 1;
					for (int j = 0; j < bean.getColumnas().size(); j++) {
						Cell cel = fila.createCell(ncel++);
						switch (bean.getColumnas().get(j).getTipo()) {
						case Enum_Tipo_Dato.DECIMAL:
							cel.setCellValue(Utileria.convierteDoble(bean.getFilas().get(i).get(j)));
							cel.setCellStyle(estiloDecimalSinSimbol);
							break;
						case Enum_Tipo_Dato.FECHA:
							cel.setCellValue(bean.getFilas().get(i).get(j));
							cel.setCellStyle(estiloCentradoDatos);
							break;
						default:
							cel.setCellValue(bean.getFilas().get(i).get(j));
							cel.setCellStyle(estilo8);
						}
					}
				}
				totalFilas=bean.getFilas().size();
				for (int celd = 0; celd <= ncel; celd++) {
					try {
						hoja.autoSizeColumn((short) celd, true);
					} catch (Exception ex) {

					}
				}
			} else {
				fila = hoja.createRow(filaN);
				Cell cel = fila.createCell(1);
				cel.setCellValue("Sin Resultados");
				cel.setCellStyle(estiloCentradoSinresultados);
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
						filaN, //primera fila (0-based)
						filaN, //ultima fila  (0-based)
						1, //primer celda (0-based)
						tam //ultima celda   (0-based)
						));
				totalFilas=0;
			}
			
			filaN=filaN+2;
			fila = hoja.createRow(filaN);
			Cell celdaF = fila.createCell((short) 1);
			celdaF.setCellValue("Registros Exportados:");
			celdaF.setCellStyle(estiloNeg8);
			filaN=filaN+1;
			fila = hoja.createRow(filaN);
			celdaF = fila.createCell((short) 1);
			celdaF.setCellValue(totalFilas);
			
			

			/********************************************************* FIN FILAS *************************************************** */
			/************************************************** CREACION DEL ARCHIVO *********************************************** */
			response.addHeader("Content-Disposition", "inline; filename="+bean.getNombreArchivo()+".xlsx");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			/************************************************ FIN ARCHIVO ******************************************** */
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public ReporteDinamicoServicio getReporteDinamicoServicio() {
		return reporteDinamicoServicio;
	}

	public void setReporteDinamicoServicio(ReporteDinamicoServicio reporteDinamicoServicio) {
		this.reporteDinamicoServicio = reporteDinamicoServicio;
	}

}
