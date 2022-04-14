package aportaciones.reporte;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

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

import aportaciones.bean.AportDispersionesBean;
import aportaciones.bean.AportacionesBean;
import aportaciones.servicio.AportDispersionesServicio;
import aportaciones.servicio.AportDispersionesServicio.Enum_Lis_AportDispersiones;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;
import soporte.servicio.ParametrosSisServicio;

public class RepDispersionesControlador extends AbstractCommandController{

	AportDispersionesServicio aportDispersionesServicio = null;
	ParametrosSesionBean parametrosSesionBean = null;
	ParametrosSisServicio parametrosSisServicio = null;

	String successView = null;

	public static interface Enum_Con_TipRepor {
		int EXCEL = 1;
	}

	public RepDispersionesControlador() {
		setCommandClass(AportDispersionesBean.class);
		setCommandName("aportDispersionesBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		AportDispersionesBean bean = (AportDispersionesBean) command;
		String htmlString = "";
		try {
			int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
			switch (tipoReporte) {
			case Enum_Con_TipRepor.EXCEL :
				reporteExcel(bean, request, response);
				break;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return new ModelAndView(getSuccessView(), "reporte", htmlString);
	}

	/**
	 * Genera el Reporte de Dispersiones Procesadas en formato excel.
	 * @param bean {@link AportacionesBean} Bean que contiene la informacion de los filtros, el numero de reporte aportacionID
	 * @param request
	 * @param response
	 */
	private void reporteExcel(AportDispersionesBean bean, HttpServletRequest request, HttpServletResponse response) {
		try {
			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
			String hora = postFormater.format(calendario.getTime());
			List<AportDispersionesBean> lista = aportDispersionesServicio.lista(Enum_Lis_AportDispersiones.dispProcesadasRep, bean);
			
			SXSSFSheet hoja = null;
			SXSSFWorkbook libro = null;
			libro = new SXSSFWorkbook();
			/********************* DECLARACION DE LOS ELEMENTOS PARA EL DISEÑO DEL REPORTE ************************************/
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

			// Alineado a la izq
			CellStyle estiloNeg10Izq = libro.createCellStyle();
			estiloNeg10Izq.setFont(fuenteNegrita10Izq);
			estiloNeg10Izq.setAlignment(CellStyle.ALIGN_LEFT);

			// Estilo negrita de 8 para encabezados del reporte
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

			// Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimal = libro.createCellStyle();
			DataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,###,##0.00"));
			estiloFormatoDecimal.setFont(fuente8);

			CellStyle estiloDecimalSinSimbol = libro.createCellStyle();
			DataFormat format2 = libro.createDataFormat();
			estiloDecimalSinSimbol.setDataFormat(format2.getFormat("#,###,##0.00"));
			estiloDecimalSinSimbol.setFont(fuente8Decimal);
			estiloDecimalSinSimbol.setAlignment(CellStyle.ALIGN_RIGHT);

			// Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimalTit = libro.createCellStyle();
			DataFormat formatTit = libro.createDataFormat();
			estiloFormatoDecimalTit.setDataFormat(formatTit.getFormat("$#,###,##0.00"));
			estiloFormatoDecimalTit.setFont(fuenteNegrita8);

			/********************* FIN DECLARACION DE LOS ELEMENTOS PARA EL DISEÑO DEL REPORTE ******************************** */
			/*********************************************** ENCABEZADO DEL REPORTE ******************************************* */
			String nombreHoja = "Dispersiones Proc.";
			if (nombreHoja == null || nombreHoja.isEmpty()) {
				nombreHoja = "hoja1";
			}
			hoja = (SXSSFSheet) libro.createSheet(nombreHoja);

			int tam = 19;


			int columnaInfo = tam - 1;
			int filaN = 1;
			int filaM = 1;
			Row fila = hoja.createRow(filaN);
			

			
			/* ========= FIN NOMBRE INSTITUCION =========== */
			Cell celdaInst = fila.createCell((short) 1);
			celdaInst.setCellValue(bean.getNombreInstitucion());
			celdaInst.setCellStyle(estiloNeg10);

			hoja.addMergedRegion(new CellRangeAddress(// funcion para unir celdas
					1, // primera fila (0-based)
					1, // ultima fila (0-based)
					1, // primer celda (0-based)
					tam - 3 // ultima celda (0-based)
					));
			celdaInst.setCellStyle(estiloNeg10);
			/* ========= FIN NOMBRE INSTITUCION =========== */
			Cell celdaUsu = fila.createCell(columnaInfo);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg10Izq);
			celdaUsu = fila.createCell(columnaInfo + 1);
			celdaUsu.setCellValue(((!bean.getUsuario().isEmpty()) ? bean.getUsuario() : "TODOS").toUpperCase());
			celdaUsu.setCellStyle(estilo10);
			filaN++;
			fila = hoja.createRow(filaN);
			/* ============ NOMBRE REPORTE ================ */
			Cell celda2 = fila.createCell((short) 1);
			celda2.setCellValue( "Reporte de Montos y Beneficiarios a Dispersar del"+" "+bean.getFechaInicio() +" al "+" "+bean.getFechaFinal());
			celda2.setCellStyle(estiloNeg10);

			hoja.addMergedRegion(new CellRangeAddress(// funcion para unir celdas
					2, // primera fila (0-based)
					2, // ultima fila (0-based)
					1, // primer celda (0-based)
					tam - 3 // ultima celda (0-based)
					));
			celda2.setCellStyle(estiloNeg10);
			/* ============ FIN NOMBRE REPORTE ============== */
			String fechaVar = (bean.getFechaSistema() != null ? bean.getFechaSistema().toString() : "");
			Cell celdaFec = fila.createCell(columnaInfo);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg10Izq);
			celdaFec = fila.createCell(columnaInfo + 1);
			celdaFec.setCellValue(fechaVar);
			celdaFec.setCellStyle(estilo10);
			filaN++;
			fila = hoja.createRow(filaN);
			
			Cell celdaHora = fila.createCell(columnaInfo);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg10Izq);
			celdaHora = fila.createCell(columnaInfo + 1);
			celdaHora.setCellValue(hora);
			celdaHora.setCellStyle(estilo10);
			
			fila = hoja.createRow(4);
			Cell celdaEstatus  = fila.createCell(0);

			celdaEstatus.setCellStyle(estiloCentrado);

			
			celdaEstatus = fila.createCell((short)1);
			celdaEstatus.setCellValue("Estatus:");
			celdaEstatus.setCellStyle(estiloNeg8);	
			
			celdaEstatus = fila.createCell((short)2);
			celdaEstatus.setCellValue(bean.getEstatusDes());
			
			celdaEstatus = fila.createCell((short)4);
			celdaEstatus.setCellValue("Cliente:");
			celdaEstatus.setCellStyle(estiloNeg8);	
			celdaEstatus = fila.createCell((short)5);
			celdaEstatus.setCellValue(bean.getClienteID() + "-"+ bean.getNombreCliente());
			
			celdaEstatus = fila.createCell((short)7);
			celdaEstatus.setCellValue("Producto:");
			celdaEstatus.setCellStyle(estiloNeg8);	
			celdaEstatus = fila.createCell((short)8);
			celdaEstatus.setCellValue(bean.getProductoDes());
			filaN++;
			filaN++;	

			fila = hoja.createRow(filaN);
			Cell celdaEnca2 = fila.createCell(1);
			
			celdaEnca2.setCellValue(("Datos del aportante").toUpperCase());
			celdaEnca2.setCellStyle(estiloNeg10);
			hoja.addMergedRegion(new CellRangeAddress(// funcion para unir celdas
					5, // primera fila (0-based)
					5, // ultima fila (0-based)
					1, // primer celda (0-based)
					3 // ultima celda (0-based)
					));
			celdaEnca2.setCellStyle(estiloNeg10);
			
			celdaEnca2 = fila.createCell(4);
			celdaEnca2.setCellValue(("Promotoría").toUpperCase());
			celdaEnca2.setCellStyle(estiloNeg10);
			hoja.addMergedRegion(new CellRangeAddress(// funcion para unir celdas
					5, // primera fila (0-based)
					5, // ultima fila (0-based)
					4, // primer celda (0-based)
					5 // ultima celda (0-based)
					));
			celdaEnca2.setCellStyle(estiloNeg10);
			
			
			celdaEnca2 = fila.createCell(6);
			celdaEnca2.setCellValue(("Montos de las aportaciones").toUpperCase());
			celdaEnca2.setCellStyle(estiloNeg10);
			hoja.addMergedRegion(new CellRangeAddress(// funcion para unir celdas
					5, // primera fila (0-based)
					5, // ultima fila (0-based)
					6, // primer celda (0-based)
					11 // ultima celda (0-based)
					));
			celdaEnca2.setCellStyle(estiloNeg10);
			
			
			celdaEnca2 = fila.createCell(12);
			celdaEnca2.setCellValue(("Datos del Beneficiario").toUpperCase());
			celdaEnca2.setCellStyle(estiloNeg10);
			hoja.addMergedRegion(new CellRangeAddress(// funcion para unir celdas
					5, // primera fila (0-based)
					5, // ultima fila (0-based)
					12, // primer celda (0-based)
					19 // ultima celda (0-based)
					));
			celdaEnca2.setCellStyle(estiloNeg10);
			
			
			/*********************************************** FIN ENCABEZADO DEL REPORTE ******************************************* */
			/***************************************************** FILTRO REPORTE ************************************************ */
			int col = 1;
			int ncel = 1;
			filaN = 6;
			/*************************************************** FIN FILTRO REPORTE ********************************************** */
			/********************************************************* COLUMNAS ************************************************** */
			ncel = 1;
			fila = hoja.createRow(filaN++);
			Cell cel = fila.createCell(ncel++);			
			cel.setCellValue("Cuenta");
			cel.setCellStyle(estiloCentrado);			
			cel = fila.createCell(ncel++);
			cel.setCellValue("Núm. de Aportante");
			cel.setCellStyle(estiloCentrado);
			cel = fila.createCell(ncel++);
			cel.setCellValue("Nombre del Aportante");
			cel.setCellStyle(estiloCentrado);
			cel = fila.createCell(ncel++);
			cel.setCellValue("Núm Promotor");
			cel.setCellStyle(estiloCentrado);
			cel = fila.createCell(ncel++);
			cel.setCellValue("Nombre del Promotor");
			cel.setCellStyle(estiloCentrado);
			cel = fila.createCell(ncel++);
			cel.setCellValue("Fecha Corte");
			cel.setCellStyle(estiloCentrado);
			cel = fila.createCell(ncel++);
			cel.setCellValue("Núm Aportaciones");
			cel.setCellStyle(estiloCentrado);
			cel = fila.createCell(ncel++);
			cel.setCellValue("Capital");
			cel.setCellStyle(estiloCentrado);
			cel = fila.createCell(ncel++);
			cel.setCellValue("Interés");
			cel.setCellStyle(estiloCentrado);
			cel = fila.createCell(ncel++);
			cel.setCellValue("ISR");
			cel.setCellStyle(estiloCentrado);
			cel = fila.createCell(ncel++);
			cel.setCellValue("Total a Pagar");
			cel.setCellStyle(estiloCentrado);
			cel = fila.createCell(ncel++);
			cel.setCellValue("Estatus");
			cel.setCellStyle(estiloCentrado);
			cel = fila.createCell(ncel++);
			cel.setCellValue("Institución");
			cel.setCellStyle(estiloCentrado);
			cel = fila.createCell(ncel++);
			cel.setCellValue("Tipo Cuenta");
			cel.setCellStyle(estiloCentrado);
			cel = fila.createCell(ncel++);
			cel.setCellValue("Cuenta");
			cel.setCellStyle(estiloCentrado);
			cel = fila.createCell(ncel++);
			cel.setCellValue("Beneficiario");
			cel.setCellStyle(estiloCentrado);
			cel = fila.createCell(ncel++);
			cel.setCellValue("Cantidad Pagada");
			cel.setCellStyle(estiloCentrado);
			cel = fila.createCell(ncel++);
			cel.setCellValue("Cantidad a pagar");
			cel.setCellStyle(estiloCentrado);
			cel = fila.createCell(ncel++);
			cel.setCellValue("Cantidad pendiente por pagar");
			cel.setCellStyle(estiloCentrado);
			

			for (int celd = 0; celd <= ncel; celd++) {
				try {
					hoja.autoSizeColumn((short) celd, true);
				} catch (Exception ex) {

				}
			}
			/****************************************************** FIN COLUMNAS ************************************************* */
			/********************************************************** FILAS **************************************************** */
			int totalFilas;
		

			if (lista != null && !lista.isEmpty()) {
				for (int i = 0; i < lista.size(); i++) {

						col=1;
						fila = hoja.createRow(filaN++);
						Cell celcol = fila.createCell(col++);
						celcol.setCellValue(lista.get(i).getCuentaAhoID());
						celcol.setCellStyle(estilo8);
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(Utileria.convierteEntero(lista.get(i).getClienteID()));
						celcol.setCellStyle(estilo8);
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(lista.get(i).getNombreAportante());
						celcol.setCellStyle(estilo8);
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(Utileria.convierteEntero(lista.get(i).getPromotorID()));
						celcol.setCellStyle(estilo8);
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(lista.get(i).getNombrePromotor());
						celcol.setCellStyle(estilo8);
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(lista.get(i).getFechaCorte());
						celcol.setCellStyle(estilo8);
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(Utileria.convierteEntero(lista.get(i).getNumAportaciones()));
						celcol.setCellStyle(estilo8);
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(Utileria.convierteDoble(lista.get(i).getCapital()));
						celcol.setCellStyle(estiloDecimalSinSimbol);
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(Utileria.convierteDoble(lista.get(i).getInteres()));
						celcol.setCellStyle(estiloDecimalSinSimbol);
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(Utileria.convierteDoble(lista.get(i).getInteresRetener()));
						celcol.setCellStyle(estiloDecimalSinSimbol);
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(Utileria.convierteDoble(lista.get(i).getTotal()));
						celcol.setCellStyle(estiloDecimalSinSimbol);
						
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(lista.get(i).getDesEstatus());
						celcol.setCellStyle(estilo8);
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(lista.get(i).getNombreInstitucion());
						celcol.setCellStyle(estilo8);
						
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(lista.get(i).getTipoCuentaSpei());
						celcol.setCellStyle(estilo8);
						
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(lista.get(i).getClabe());
						celcol.setCellStyle(estilo8);
						
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(lista.get(i).getBeneficiario());
						celcol.setCellStyle(estilo8);
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(Utileria.convierteDoble(lista.get(i).getCantidadPagada()));
						celcol.setCellStyle(estiloDecimalSinSimbol);
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(Utileria.convierteDoble(lista.get(i).getCantidadenDispersion()));
						celcol.setCellStyle(estiloDecimalSinSimbol);
						
						celcol = fila.createCell(col++);
						celcol.setCellValue(Utileria.convierteDoble(lista.get(i).getCantidadPendiente()));
						celcol.setCellStyle(estiloDecimalSinSimbol);
						

		
				}
				totalFilas = lista.size();
				for (int celd = 0; celd <= ncel; celd++) {
					try {
						hoja.autoSizeColumn((short) celd, true);
					} catch (Exception ex) {

					}
				}
			} else {
				fila = hoja.createRow(filaN);
				Cell cel2 = fila.createCell(1);
				cel2.setCellValue("Sin Resultados");
				cel2.setCellStyle(estiloCentradoSinresultados);
				hoja.addMergedRegion(new CellRangeAddress(// funcion para unir celdas
						filaN, // primera fila (0-based)
						filaN, // ultima fila (0-based)
						1, // primer celda (0-based)
						tam // ultima celda (0-based)
						));
				totalFilas = 0;
			}

			filaN = filaN + 2;
			fila = hoja.createRow(filaN);
			Cell celdaF = fila.createCell((short) 1);
			celdaF.setCellValue("Registros Exportados:");
			celdaF.setCellStyle(estiloNeg8);
			filaN = filaN + 1;
			fila = hoja.createRow(filaN);
			celdaF = fila.createCell((short) 1);
			celdaF.setCellValue(totalFilas);

			/******************************************************** FIN FILAS ************************************************** */
			/************************************************* CREACION DEL ARCHIVO ********************************************** */
			response.addHeader("Content-Disposition", "inline; filename=MontosyBenefDispersar.xlsx");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			/*********************************************** FIN ARCHIVO ******************************************* */
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

	public AportDispersionesServicio getAportDispersionesServicio() {
		return aportDispersionesServicio;
	}

	public void setAportDispersionesServicio(AportDispersionesServicio aportDispersionesServicio) {
		this.aportDispersionesServicio = aportDispersionesServicio;
	}

}