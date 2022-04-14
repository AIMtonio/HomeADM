package credito.reporte;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;
import herramientas.Utileria;

public class RepOperacionBasicaUnidadControlador extends AbstractCommandController {

	CreditosServicio		creditosServicio		= null;
	String					nomReporte				= null;
	String					successView				= null;

	public static interface Enum_Con_TipRepor {
		int ReporteExcel = 1;
	}

	public RepOperacionBasicaUnidadControlador() {
		setCommandClass(CreditosBean.class);
 		setCommandName("operacionBasicaUnidadBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		CreditosBean creditosBean = (CreditosBean) command;
		
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));

		switch (tipoReporte) {
		case Enum_Con_TipRepor.ReporteExcel:
			List<CreditosBean> listaReportes = operacionesBasicaUnidad(tipoLista, creditosBean, response);
			break;
		}

		return null;

	}	

	// Reporte de saldos capital de credito en excel
	public List<CreditosBean> operacionesBasicaUnidad(int tipoLista, CreditosBean creditosBean, HttpServletResponse response) {
		List<CreditosBean> listaCreditos = null;
		String tipoUsuario = "";
		try {

			listaCreditos = creditosServicio.listaReporteOperaciones(tipoLista, creditosBean, response);

			Workbook libro = new XSSFWorkbook();

			// Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			Font fuenteNegrita14 = libro.createFont();
			fuenteNegrita14.setFontHeightInPoints((short) 14);
			fuenteNegrita14.setFontName("Arial");
			fuenteNegrita14.setBoldweight(Font.BOLDWEIGHT_BOLD);

			Font font10 = libro.createFont();
			font10.setFontHeightInPoints((short) 10);
			font10.setFontName("Arial");
			
			Font fuente10Cen= libro.createFont();
			fuente10Cen.setFontHeightInPoints((short)10);
			fuente10Cen.setFontName("Arial");
			
			// Estilo Formato decimal (0.00)
			Font fontDecimal10 = libro.createFont();
			fontDecimal10.setFontHeightInPoints((short) 10);
			fontDecimal10.setFontName("Arial");
				
			Font fontCentrado10 = libro.createFont();
			fontCentrado10.setFontHeightInPoints((short) 10);
			fontCentrado10.setFontName("Arial");
			
			// Crea un Fuente Negrita con tamaño 8 para informacion del reporte.

			Font fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName(("Arial"));
			fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			Font fuenteNegrita10Centrado= libro.createFont();
			fuenteNegrita10Centrado.setFontHeightInPoints((short)10);
			fuenteNegrita10Centrado.setFontName("Arial");
			fuenteNegrita10Centrado.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			Font fuenteArialDiez= (Font) libro.createFont();
			fuenteArialDiez.setFontHeightInPoints((short)10);
			fuenteArialDiez.setFontName("Arial");
			
			// La fuente se mete en un estilo para poder ser usada.
			// Estilo negrita de 10 para el titulo del reporte
			CellStyle estiloNeg14 = libro.createCellStyle();
			estiloNeg14.setFont(fuenteNegrita14);
			estiloNeg14.setAlignment((short)CellStyle.ALIGN_CENTER);
			estiloNeg14.setVerticalAlignment((short) CellStyle.VERTICAL_CENTER);

			// Estilo negrita de 8 para encabezados del reporte
			CellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			// Estilo negrita de 8 con border
			CellStyle estiloNeg10Border = libro.createCellStyle();
			estiloNeg10Border.setFont(fuenteNegrita10);
			estiloNeg10Border.setBorderTop(XSSFCellStyle.BORDER_DASH_DOT);
			estiloNeg10Border.setBorderBottom(XSSFCellStyle.BORDER_DASH_DOT);
			estiloNeg10Border.setBorderLeft(XSSFCellStyle.BORDER_DASH_DOT);
			estiloNeg10Border.setBorderRight(XSSFCellStyle.BORDER_DASH_DOT);

			CellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
			estiloCentrado.setFont(fuenteNegrita10Centrado);
			estiloCentrado.setWrapText(true);
			
			CellStyle estilo10 = libro.createCellStyle();
			estilo10.setFont(font10);
			estilo10.setVerticalAlignment((short) CellStyle.VERTICAL_CENTER);
			
			//Estilo 10 centrado
			CellStyle estiloFormatoICentrado = libro.createCellStyle();
			estiloFormatoICentrado.setAlignment((short)CellStyle.ALIGN_CENTER);
			estiloFormatoICentrado.setFont(fuente10Cen);			
			
			CellStyle estiloFormatoDecimal = libro.createCellStyle();
			DataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setFont(fontDecimal10);
			estiloFormatoDecimal.setBorderTop(XSSFCellStyle.BORDER_DASH_DOT);
			estiloFormatoDecimal.setBorderBottom(XSSFCellStyle.BORDER_DASH_DOT);
			estiloFormatoDecimal.setBorderLeft(XSSFCellStyle.BORDER_DASH_DOT);
			estiloFormatoDecimal.setBorderRight(XSSFCellStyle.BORDER_DASH_DOT);
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			CellStyle estiloTextoIzquierda = libro.createCellStyle();
			estiloTextoIzquierda.setFont(fuenteArialDiez);
			estiloTextoIzquierda.setAlignment(CellStyle.ALIGN_LEFT);
			
			//Estilo Texto Izquierda con Border
			CellStyle estiloTextoIzquierdaBorde = libro.createCellStyle();
			estiloTextoIzquierdaBorde.setFont(fuenteArialDiez);
			estiloTextoIzquierdaBorde.setBorderTop(XSSFCellStyle.BORDER_DASH_DOT);
			estiloTextoIzquierdaBorde.setBorderBottom(XSSFCellStyle.BORDER_DASH_DOT);
			estiloTextoIzquierdaBorde.setBorderLeft(XSSFCellStyle.BORDER_DASH_DOT);
			estiloTextoIzquierdaBorde.setBorderRight(XSSFCellStyle.BORDER_DASH_DOT);
			
			// Creacion de hoja
			Sheet hoja = null;
			hoja = libro.createSheet("Reporte Básico de Unidad");

			Row fila = hoja.createRow(0);

			Cell celdaini = fila.createCell((short) 1);
			celdaini = fila.createCell((short) 5);
			celdaini.setCellValue("Usuario:");
			celdaini.setCellStyle(estiloNeg10);
			celdaini = fila.createCell((short) 6);
			celdaini.setCellValue((!creditosBean.getUsuario().isEmpty()) ? creditosBean.getUsuario() : "TODOS");

			String fechaVar = creditosBean.getParFechaEmision();

			Calendar calendario = new GregorianCalendar();
			
			// Celda del nombre de institucion
			Cell celdaInst = fila.createCell((short) 1);
			celdaInst.setCellValue(creditosBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(// funcion para unir celdas
					0, // primera fila (0-based)
					0, // a la ultima fila (0-based)
					1, // primer celda (0-based)
					4 // a ultima celda (0-based)
			));
			celdaInst.setCellStyle(estiloNeg14);
			
			fila = hoja.createRow(1);

			Cell celdafin = fila.createCell((short)5);
			celdafin.setCellValue("Fecha:");
			celdafin.setCellStyle(estiloNeg10);
			celdafin = fila.createCell((short) 6);
			celdafin.setCellValue(fechaVar);
			
			//Celda del nombre de reporte
			Cell celda = fila.createCell((short) 1);
			celda.setCellStyle(estiloNeg14);
			int tamanioListaHead = listaCreditos.size();
			if (listaCreditos != null && tamanioListaHead > 0) {
				CreditosBean credito = null;
				for (int iterHead = 0; iterHead < tamanioListaHead; iterHead++) {
					credito = (CreditosBean) listaCreditos.get(0);
					tipoUsuario = credito.getTipoUsuario();
					if(tipoUsuario.equals("C")){
						celda.setCellValue("REPORTE CONSOLIDADO DE UNIDAD");
					}
					if(tipoUsuario.equals("P")){
						celda.setCellValue("REPORTE BÁSICO DE UNIDAD");
					}
				}
			}else{
				celda.setCellValue("REPORTE BÁSICO DE UNIDAD");
			}
			//celda.setCellValue("REPORTE BÁSICO DE UNIDAD");
			hoja.addMergedRegion(new CellRangeAddress(// funcion para unir celdas
					1, // primera fila (0-based)
					1, // ultima fila (0-based)
					1, // primer celda (0-based)
					4 // ultima celda (0-based)
			));
			
			fila = hoja.createRow(2);
			Cell celdaHora = fila.createCell((short) 5);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg10);

			String horaVar = "";

			int hora = calendario.get(Calendar.HOUR_OF_DAY);
			int minutos = calendario.get(Calendar.MINUTE);
			int segundos = calendario.get(Calendar.SECOND);

			String h = Integer.toString(hora);
			String m = "";
			String s = "";
			if (minutos < 10)
				m = "0" + Integer.toString(minutos);
			else
				m = Integer.toString(minutos);
			if (segundos < 10)
				s = "0" + Integer.toString(segundos);
			else
				s = Integer.toString(segundos);

			horaVar = h + ":" + m + ":" + s;

			celdaHora = fila.createCell((short) 6);
			celdaHora.setCellValue(horaVar);

			int i = 3, iter = 0, celd = 1;;
			int filaID = 2;
			int tamanioLista = 0;
			if (listaCreditos != null) {
				tamanioLista = listaCreditos.size();
				CreditosBean credito = null;
				for (iter = 0; iter < tamanioLista; iter++) {

					credito = (CreditosBean) listaCreditos.get(iter);
					
					// Creacion de fila
					fila = hoja.createRow(i);
					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					
					Cell celdaFechaInicio = fila.createCell((short)1);
					celdaFechaInicio.setCellValue("Fecha Inicio:");
					celdaFechaInicio.setCellStyle(estiloNeg10);
					
					Cell celdaFechaDato = fila.createCell((short) 2);
					celdaFechaDato.setCellValue(creditosBean.getFechaInicio());
					celdaFechaDato.setCellStyle(estiloFormatoICentrado);
					
					Cell celdaSucursal = fila.createCell((short)3);
					celdaSucursal.setCellValue("Sucursal:");
					celdaSucursal.setCellStyle(estiloNeg10);
					Cell celdaDatosSucursal = fila.createCell((short) 4);
					celdaDatosSucursal.setCellValue(creditosBean.getNombreSucursal());
					celdaDatosSucursal.setCellStyle(estiloTextoIzquierda);
					
					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					
					Cell celdaFechaFin = fila.createCell((short)1);
					celdaFechaFin.setCellValue("Fecha Fin:");
					celdaFechaFin.setCellStyle(estiloNeg10);
					celdaFechaFin = fila.createCell((short) 2);
					celdaFechaFin.setCellValue(creditosBean.getFechaFin());
					celdaFechaFin.setCellStyle(estiloFormatoICentrado);
					
					Cell celdaPromotor = fila.createCell((short)3);
					celdaPromotor.setCellValue("Promotor:");
					celdaPromotor.setCellStyle(estiloNeg10);
					Cell celdaDatosPromotor = fila.createCell((short) 4);
					celdaDatosPromotor.setCellValue(credito.getNombrePromotor());
					celdaDatosPromotor.setCellStyle(estiloTextoIzquierda);
					
					fila = hoja.createRow(i++);
					fila = hoja.createRow(i++);
					fila = hoja.createRow(i++);
					
					filaID++;//Se incrementa el contador de fila
					filaID++;//Se incrementa el contador de fila
					filaID++;//Se incrementa el contador de fila
					
					Cell celdaConcepto = fila.createCell((short)1);
					celdaConcepto.setCellValue("CONCEPTO");
					celdaConcepto.setCellStyle(estiloNeg10Border);
					//Combinacion del concepto
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));

					Cell celValor = fila.createCell((short)5);
					celValor.setCellValue("VALOR");
					celValor.setCellStyle(estiloNeg10Border);
					//Combinacion de celdas para valor
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));
					
					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					
					celda = fila.createCell((short) 1);
					celda.setCellValue("Nombre del Asesor");
					celda.setCellStyle(estiloNeg10Border);
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					celda = fila.createCell((short) 5);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));
					celda.setCellValue(credito.getNombrePromotor());
					celda.setCellStyle(estiloTextoIzquierdaBorde);
					//hoja.autoSizeColumn(5, true);
					/*String nombreAsesor = credito.getNombrePromotor();
					int lengtAsesor = nombreAsesor.length();
					hoja.setColumnWidth(5, 250);*/

					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					celda = fila.createCell((short) 1);
					celda.setCellValue("Fecha y hora inicio actividades");
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					celda.setCellStyle(estiloNeg10Border);
					celda = fila.createCell((short) 5);
					celda.setCellValue(credito.getFechaInicio());
					celda.setCellStyle(estiloTextoIzquierdaBorde);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));

					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					celda = fila.createCell((short) 1);
					celda.setCellValue("Fecha y hora última transacción");
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					celda.setCellStyle(estiloNeg10Border);
					celda = fila.createCell((short) 5);
					celda.setCellValue(credito.getFechaFin());
					celda.setCellStyle(estiloTextoIzquierdaBorde);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));

					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					celda = fila.createCell((short) 1);
					celda.setCellValue("Número Total de clientes a visitar");
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					celda.setCellStyle(estiloNeg10Border);
					celda = fila.createCell((short) 5);
					celda.setCellValue(credito.getTotalClientes());
					celda.setCellStyle(estiloTextoIzquierdaBorde);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));
					
					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					celda = fila.createCell((short) 1);
					celda.setCellValue("Detalle de clientes nuevos / renovaciones");
					celda.setCellStyle(estiloNeg10Border);
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					celda = fila.createCell((short) 5);
					celda.setCellValue(credito.getTotalCtesNuevos());
					celda.setCellStyle(estiloTextoIzquierdaBorde);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));
					
					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					celda = fila.createCell((short) 1);
					celda.setCellValue("Número Total de clientes visitados al corte");
					celda.setCellStyle(estiloNeg10Border);
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					celda = fila.createCell((short) 5);
					celda.setCellValue(credito.getTotalCtesCorte());
					celda.setCellStyle(estiloTextoIzquierdaBorde);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));
					
					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					celda = fila.createCell((short) 1);
					celda.setCellValue("Número Total de clientes con pago registrado");
					celda.setCellStyle(estiloNeg10Border);
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					celda = fila.createCell((short) 5);
					celda.setCellValue(credito.getTotalCtesPagos());
					celda.setCellStyle(estiloTextoIzquierdaBorde);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));
					
					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					celda = fila.createCell((short) 1);
					celda.setCellValue("Número de Clientes nuevos y/o renovaciones");
					celda.setCellStyle(estiloNeg10Border);
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					celda = fila.createCell((short) 5);
					celda.setCellValue(credito.getTotalCteCreditos());
					celda.setCellStyle(estiloTextoIzquierdaBorde);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));
					
					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					celda = fila.createCell((short) 1);
					celda.setCellValue("Número de Clientes NO Pago");
					celda.setCellStyle(estiloNeg10Border);
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					celda = fila.createCell((short) 5);
					celda.setCellValue(credito.getTotalCtesNoPagos());
					celda.setCellStyle(estiloTextoIzquierdaBorde);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));
					
					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					celda = fila.createCell((short) 1);
					celda.setCellValue("Número de  Clientes con cuotas extras");
					celda.setCellStyle(estiloNeg10Border);
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					celda = fila.createCell((short) 5);
					celda.setCellValue(credito.getTotalCtesPrepagos());
					celda.setCellStyle(estiloTextoIzquierdaBorde);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));
					
					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					celda = fila.createCell((short) 1);
					celda.setCellValue("Saldo inicial de cada asesor");
					celda.setCellStyle(estiloNeg10Border);
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					Cell celdaAsesor = fila.createCell((short) 5);
					celdaAsesor.setCellValue(Utileria.convierteDoble(credito.getSaldoInicialCaja()));
					celdaAsesor.setCellStyle(estiloFormatoDecimal);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));
					
					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					celda = fila.createCell((short) 1);
					celda.setCellValue("Recaudo esperado de cartera");
					celda.setCellStyle(estiloNeg10Border);
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					celda = fila.createCell((short) 5);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoEsperadoCartera()));
					celda.setCellStyle(estiloFormatoDecimal);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));
					
					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					celda = fila.createCell((short) 1);
					celda.setCellValue("Recaudo en $ (valor)");
					celda.setCellStyle(estiloNeg10Border);
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					celda = fila.createCell((short) 5);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoCartera()));
					celda.setCellStyle(estiloFormatoDecimal);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));
					
					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					celda = fila.createCell((short) 1);
					celda.setCellValue("Recaudo cuotas extras");
					celda.setCellStyle(estiloNeg10Border);
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					celda = fila.createCell((short) 5);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoRecaudoPrepago()));
					celda.setCellStyle(estiloFormatoDecimal);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));
					
					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					celda = fila.createCell((short) 1);
					celda.setCellValue("Recaudo en %");
					celda.setCellStyle(estiloNeg10Border);
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					celda = fila.createCell((short) 5);
					celda.setCellValue(credito.getPorcentajeRecaudo());
					celda.setCellStyle(estiloTextoIzquierdaBorde);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));
					
					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					celda = fila.createCell((short) 1);
					celda.setCellValue("% de clientes con los que se recaudó el pretendido");
					celda.setCellStyle(estiloNeg10Border);
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					celda = fila.createCell((short) 5);
					celda.setCellValue(credito.getPorcentajePretendido());
					celda.setCellStyle(estiloTextoIzquierdaBorde);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));
					
					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					celda = fila.createCell((short) 1);
					celda.setCellValue("Valor en $ ventas nuevas o renovaciones");
					celda.setCellStyle(estiloNeg10Border);
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					celda = fila.createCell((short) 5);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoTotalCreditos()));
					celda.setCellStyle(estiloFormatoDecimal);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));
					
					fila = hoja.createRow(i++);
					filaID++;//Se incrementa el contador de fila
					celda = fila.createCell((short) 1);
					celda.setCellValue("Gastos del Día");
					celda.setCellStyle(estiloNeg10Border);
					//Combinacion del celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 1, 4));
					
					celda = fila.createCell((short) 5);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoGastosDia()));
					celda.setCellStyle(estiloFormatoDecimal);
					//Combinacion de celdas
					hoja.addMergedRegion(new CellRangeAddress(filaID, filaID, 5, 6));

					i = i+5;
					filaID = filaID + 5;//Se incrementa el contador de fila
				}
				
				//Se autoincrementa el tamaño de las celdas, pasando como parametro para que no ignore las celdas combinadas
				for(int cellda = 0; cellda <= i; cellda++){
					hoja.autoSizeColumn(cellda, true);
				}
			}

			// Creo la cabecera
			response.addHeader("Content-Disposition", "inline; filename=ReporteBasicoUnidad.xlsx");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();

		} catch (Exception e) {
			e.printStackTrace();
		} // Fin del catch
		return listaCreditos;

	}

	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

}
