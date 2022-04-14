
package regulatorios.reporte;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.RegulatorioA2112Bean;
import regulatorios.servicio.RegulatorioA2112Servicio;
import regulatorios.servicio.RegulatorioA2112Servicio.Enum_Lis_ReportesA2112;

public class RegulatorioA2112ReporteControlador extends AbstractCommandController{
	RegulatorioA2112Servicio regulatorioA2112Servicio = null;
	String successView = null;

	
	public RegulatorioA2112ReporteControlador () {
		setCommandClass(RegulatorioA2112Bean.class);
		setCommandName("regulatoriosCarteraBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		RegulatorioA2112Bean reporteBean = (RegulatorioA2112Bean) command;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
		
		switch(tipoReporte)	{
			case Enum_Lis_ReportesA2112.excel:		
				reporteRegulatorioA2112(tipoReporte,reporteBean,response);
				break;
			case Enum_Lis_ReportesA2112.csv:
				regulatorioA2112Servicio.listaReporteRegulatorioA2112(tipoReporte, reporteBean, response); ;
		}
		return null;	
	}


	/**
	 * Generacion de reporte A2112 en Excel
	 * 
	 * @param tipoReporte
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List  reporteRegulatorioA2112(int tipoReporte,RegulatorioA2112Bean reporteBean,  HttpServletResponse response){
		List listaRepote = null;
		listaRepote = regulatorioA2112Servicio.listaReporteRegulatorioA2112(tipoReporte, reporteBean,response);
		try {
			HSSFWorkbook libro = new HSSFWorkbook();
			// Se crea una Fuente Negrita con tamaño 10
			HSSFFont fuenteNegrita10 = libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short) 10);
			fuenteNegrita10.setFontName("Arial");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);

			// Se crea una Fuente tamaño 10
			HSSFFont fuentetamanio10 = libro.createFont();
			fuentetamanio10.setFontHeightInPoints((short) 10);
			fuentetamanio10.setFontName("Arial");

			// La fuente se mete en un estilo para poder ser usada.
			// Estilo tamaño 10 alineado a la derecha
			HSSFCellStyle estiloTitulo = libro.createCellStyle();
			estiloTitulo.setFont(fuenteNegrita10);
			estiloTitulo.setAlignment((short) HSSFCellStyle.ALIGN_LEFT);
			
			// Estilo negrita tamaño 10
			HSSFCellStyle estiloEncabezado = libro.createCellStyle();
			estiloEncabezado.setAlignment((short) HSSFCellStyle.ALIGN_LEFT);
			estiloEncabezado.setFont(fuenteNegrita10);
			estiloEncabezado.setAlignment((short) HSSFCellStyle.ALIGN_CENTER);
			estiloEncabezado.setVerticalAlignment((short) HSSFCellStyle.VERTICAL_CENTER);
			estiloEncabezado.setBorderTop((short) HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderBottom((short) HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderRight((short) HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderLeft((short) HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setFillBackgroundColor(HSSFColor.GREY_25_PERCENT.index);
			estiloEncabezado.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

			// Estilo tamaño 10 alineado a la izquierda
			HSSFCellStyle estiloConceptos = libro.createCellStyle();
			estiloConceptos.setAlignment((short) HSSFCellStyle.ALIGN_LEFT);
			estiloConceptos.setBorderRight((short) HSSFCellStyle.BORDER_MEDIUM);
			estiloConceptos.setBorderLeft((short) HSSFCellStyle.BORDER_MEDIUM);
			estiloConceptos.setWrapText(true);
			estiloConceptos.setFont(fuenteNegrita10);

			// Solo celda con borde inferior, izquierdo y derecho
			HSSFCellStyle estiloUltimaCelda = libro.createCellStyle();
			estiloUltimaCelda.setBorderRight((short) HSSFCellStyle.BORDER_MEDIUM);
			estiloUltimaCelda.setBorderLeft((short) HSSFCellStyle.BORDER_MEDIUM);
			estiloUltimaCelda.setBorderBottom((short) HSSFCellStyle.BORDER_MEDIUM);

			HSSFDataFormat format = libro.createDataFormat();

			// Estilo tamaño 10 alineado a la derecha sin decimales
			HSSFCellStyle estiloSaldos = libro.createCellStyle();
			estiloSaldos.setAlignment((short) HSSFCellStyle.ALIGN_RIGHT);
			estiloSaldos.setBorderRight((short) HSSFCellStyle.BORDER_MEDIUM);
			estiloSaldos.setBorderLeft((short) HSSFCellStyle.BORDER_MEDIUM);
			estiloSaldos.setDataFormat(format.getFormat("#,##0"));
			estiloSaldos.setFont(fuentetamanio10);

			// Estilo tamaño 10 negrita alineado a la izquierda
			HSSFCellStyle estiloPie = libro.createCellStyle();
			estiloPie.setAlignment((short) HSSFCellStyle.ALIGN_LEFT);
			estiloPie.setFont(fuenteNegrita10);

			// Creacion de hoja
			HSSFSheet hoja = libro.createSheet("A 2112");
			HSSFRow fila = hoja.createRow(0);
			HSSFCell celda = fila.createCell((short) 0);
			
			int numeroFila = 1, iter = 0;
			String formula = "";
			int tamanioLista = listaRepote.size();
			RegulatorioA2112Bean reporteRegBean = null;

			for (iter = 0; iter < tamanioLista; iter++) {
				reporteRegBean = (RegulatorioA2112Bean) listaRepote
						.get(iter);
				// CARGANDO ENCABEZADOS DEL REPORTE
				if (iter <= 4) {
					fila = hoja.createRow(numeroFila);
					celda = fila.createCell((short) 0);
					celda.setCellValue(reporteRegBean.getConcepto());
					celda.setCellStyle(estiloTitulo);
				}
				if (iter == 5) {
					fila = hoja.createRow(numeroFila);
					numeroFila++;
					fila = hoja.createRow(numeroFila);
					celda = fila.createCell((short) 0);
					celda.setCellValue("Concepto");
					celda.setCellStyle(estiloEncabezado);
					celda = fila.createCell((short) 1);
					celda.setCellValue("Dato");
					celda.setCellStyle(estiloEncabezado);
					// -------------------------------------
					numeroFila++;

				}

				if (iter == 6) {
					fila = hoja.createRow(numeroFila);
					fila = hoja.createRow(numeroFila);
					celda = fila.createCell((short) 0);
					celda.setCellStyle(estiloUltimaCelda);
					celda = fila.createCell((short) 1);
					celda.setCellStyle(estiloUltimaCelda);
					numeroFila++;
					fila = hoja.createRow(numeroFila);
					celda = fila.createCell((short) 0);
					celda.setCellValue("Concepto");
					celda.setCellStyle(estiloEncabezado);
					celda = fila.createCell((short) 1);
					celda.setCellValue("Saldo al cierre del mes");
					celda.setCellStyle(estiloEncabezado);
					// -------------------------------------
					numeroFila++;

				}
				if (iter == 64) {
					fila = hoja.createRow(numeroFila);
					celda = fila.createCell((short) 0);
					celda.setCellStyle(estiloUltimaCelda);
					celda = fila.createCell((short) 1);
					celda.setCellStyle(estiloUltimaCelda);
					numeroFila++;
				}
				if (iter >= 64 && iter <= 69) {
					fila = hoja.createRow(numeroFila);
					celda = fila.createCell((short) 0);
					celda.setCellValue(reporteRegBean.getConcepto());
					celda.setCellStyle(estiloPie);
				}

				fila = hoja.createRow(numeroFila);
				celda = fila.createCell((short) 0);
				celda.setCellValue(reporteRegBean.getConcepto());
				if (iter > 4 && iter < 64) {
					celda.setCellStyle(estiloConceptos);
				} else if (iter >= 64) {
					celda.setCellStyle(estiloPie);
				} else {
					celda.setCellStyle(estiloTitulo);
				}

				// Formula Saldo o Saldo
				if (iter > 4 && iter < 64) {
					celda = fila.createCell((short) 1);
					celda.setCellStyle(estiloSaldos);
					if (reporteRegBean.getFormulaSaldo() != null
							&& !reporteRegBean.getFormulaSaldo().isEmpty()) {
						formula = reporteRegBean.getFormulaSaldo();
						celda.setCellType(HSSFCell.CELL_TYPE_FORMULA);
						celda.setCellFormula(formula);
					} else {
						if (!reporteRegBean.getConcepto().isEmpty()) {
							celda.setCellValue(Double
									.parseDouble(reporteRegBean.getSaldo()));
						}
					}
					// Formula indicador
					if (reporteRegBean.getFormulaIndicador() != null
							&& !reporteRegBean.getFormulaIndicador().isEmpty()) {
						formula = reporteRegBean.getFormulaIndicador();
						celda.setCellType(HSSFCell.CELL_TYPE_FORMULA);
						celda.setCellFormula(formula);
					} else {
						if (!reporteRegBean.getConcepto().isEmpty()) {
							celda.setCellValue(Double
									.parseDouble(reporteRegBean.getSaldo()));
						}
					}
				}

				numeroFila++;
			}

			fila = hoja.createRow(numeroFila++);
			for (int celd = 1; celd <= 40; celd++)
				hoja.autoSizeColumn((short) celd);
			
			hoja.setColumnWidth(0,19000);

			// Creo la cabecera
			response.addHeader("Content-Disposition",
					"inline; filename=A_2112_Desagregado_de_req_de_Cap_por_riesgo.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();

		} catch (Exception e) {
			e.printStackTrace();
		}// Fin del catch
		return listaRepote;
	}

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public RegulatorioA2112Servicio getRegulatorioA2112Servicio() {
		return regulatorioA2112Servicio;
	}

	public void setRegulatorioA2112Servicio(
			RegulatorioA2112Servicio regulatorioA2112Servicio) {
		this.regulatorioA2112Servicio = regulatorioA2112Servicio;
	}

	
}