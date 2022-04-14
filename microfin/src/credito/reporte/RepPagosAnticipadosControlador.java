package credito.reporte;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.bean.PagosAnticipadosBean;
import credito.servicio.CreditosServicio;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;

public class RepPagosAnticipadosControlador extends AbstractCommandController {

	CreditosServicio		creditosServicio		= null;
	String					nomReporte				= null;
	String					successView				= null;
	ParametrosSisServicio	parametrosSisServicio	= null;
	ParametrosSesionBean	parametrosSesionBean	= null;

	public static interface Enum_Con_TipRepor {
		int ReporteExcel = 1;
	}

	public RepPagosAnticipadosControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		CreditosBean creditosBean = (CreditosBean) command;

		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));

		String htmlString = "";
		switch (tipoReporte) {
		case Enum_Con_TipRepor.ReporteExcel:
			List<PagosAnticipadosBean> listaReportes = pagosXReferenciaRep(tipoLista, creditosBean, response);
			break;
		}

		return null;

	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	// Reporte de saldos capital de credito en excel
	public List<PagosAnticipadosBean> pagosXReferenciaRep(int tipoLista, CreditosBean creditosBean, HttpServletResponse response) {
		List<PagosAnticipadosBean> listaCreditos = null;
		try {

			// Se obtiene el tipo de institucion financiera
			ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
			parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.tipoInstitFin, parametrosSisBean);
			String safilocale = Utileria.generaLocale("safilocale.cliente", parametrosSisBean.getNombreCortoInst());
			int regExport = 0;
			listaCreditos = creditosServicio.pagosAnticipadosRep(tipoLista, creditosBean, response);

			SXSSFWorkbook libro = new SXSSFWorkbook(100);

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
			fuente10Cen.setFontName(HSSFFont.FONT_ARIAL);
			
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
			fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			Font fuenteNegrita10Centrado= libro.createFont();
			fuenteNegrita10Centrado.setFontHeightInPoints((short)10);
			fuenteNegrita10Centrado.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10Centrado.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.
			// Estilo negrita de 10 para el titulo del reporte
			CellStyle estiloNeg14 = libro.createCellStyle();
			estiloNeg14.setFont(fuenteNegrita14);
			estiloNeg14.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			estiloNeg14.setVerticalAlignment((short) CellStyle.VERTICAL_CENTER);

			// Estilo negrita de 8 para encabezados del reporte
			CellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);			

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
			estiloFormatoICentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			estiloFormatoICentrado.setFont(fuente10Cen);			
			
			CellStyle estiloFormatoDecimal = libro.createCellStyle();
			DataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			estiloFormatoDecimal.setFont(fontDecimal10);		
			
			// Creacion de hoja
			Sheet hoja = null;
			hoja = libro.createSheet("ReportePagosAnticipados");

			Row fila = hoja.createRow(0);

			Cell celdaini = fila.createCell((short) 1);
			celdaini = fila.createCell((short) 13);
			celdaini.setCellValue("Usuario:");
			celdaini.setCellStyle(estiloNeg10);
			celdaini = fila.createCell((short) 14);
			celdaini.setCellValue((!creditosBean.getUsuario().isEmpty()) ? creditosBean.getUsuario() : "TODOS");

			String fechaVar = creditosBean.getParFechaEmision();

			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");

			fila = hoja.createRow(1);

			Cell celdafin = fila.createCell((short) 13);
			celdafin.setCellValue("Fecha:");
			celdafin.setCellStyle(estiloNeg10);
			celdafin = fila.createCell((short) 14);
			celdafin.setCellValue(fechaVar);

			Cell celdaInst = fila.createCell((short) 0);
			celdaInst.setCellValue(creditosBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(// funcion para unir celdas
					1, // primera fila (0-based)
					1, // ultima fila (0-based)
					0, // primer celda (0-based)
					12 // ultima celda (0-based)
			));
			celdaInst.setCellStyle(estiloNeg14);

			fila = hoja.createRow(2);
			Cell celdaHora = fila.createCell((short) 13);
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

			celdaHora = fila.createCell((short) 14);
			celdaHora.setCellValue(horaVar);

			Cell celda = fila.createCell((short) 0);
			celda.setCellStyle(estiloNeg14);
			celda.setCellValue("REPORTE DE PAGOS ANTIPADOS DEL " + creditosBean.getFechaInicio() + " AL " + creditosBean.getFechaFinal());
			
			hoja.addMergedRegion(new CellRangeAddress(// funcion para unir celdas
					2, // primera fila (0-based)
					2, // ultima fila (0-based)
					0, // primer celda (0-based)
					12 // ultima celda (0-based)
			));

			// Creacion de fila
			fila = hoja.createRow(3);
			fila = hoja.createRow(4);
			int celd = 0;
			
			celda = fila.createCell((short) celd++);
			celda.setCellValue("ID de " + safilocale);
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short) celd++);
			celda.setCellValue("Nombre " + safilocale);
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short) celd++);
			celda.setCellValue("ID Crédito");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short) celd++);
			celda.setCellValue("Sucursal");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short) celd++);
			celda.setCellValue("Fuente de Fondeo");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short) celd++);
			celda.setCellValue("Fecha Vencimiento");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short) celd++);
			celda.setCellValue("Fecha de Depósito");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short) celd++);
			celda.setCellValue("Fecha de Aplicación");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short) celd++);
			celda.setCellValue("Días: Depósito-Aplicación");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short) celd++);
			celda.setCellValue("Capital");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short) celd++);
			celda.setCellValue("Interés Ordinario");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short) celd++);
			celda.setCellValue("Interés Moratorio");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short) celd++);
			celda.setCellValue("IVA");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short) celd++);
			celda.setCellValue("Notas de cargo");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short) celd++);
			celda.setCellValue("IVA notas de cargo");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short) celd++);
			celda.setCellValue("Total");
			celda.setCellStyle(estiloCentrado);

			Utileria.autoAjustaColumnas(celd, hoja);

			
			int i = 5, iter = 0;
			int tamanioLista = 0;
			if (listaCreditos != null) {
				tamanioLista = listaCreditos.size();
				PagosAnticipadosBean credito = null;
		
				for (iter = 0; iter < tamanioLista; iter++) {

					credito = (PagosAnticipadosBean) listaCreditos.get(iter);
					fila = hoja.createRow(i);

					celd = 0;
					celda = fila.createCell((short) celd++);
					celda.setCellValue(credito.getClienteID());
					celda.setCellStyle(estilo10);

					celda = fila.createCell((short) celd++);
					celda.setCellValue(credito.getNombreCliente());
					celda.setCellStyle(estilo10);

					celda = fila.createCell((short) celd++);
					celda.setCellValue(credito.getCreditoID());
					celda.setCellStyle(estilo10);

					celda = fila.createCell((short) celd++);
					celda.setCellValue(credito.getNombreSucursal());
					celda.setCellStyle(estilo10);

					celda = fila.createCell((short) celd++);
					celda.setCellValue(credito.getNombreInstFon());
					celda.setCellStyle(estilo10);

					celda = fila.createCell((short) celd++);
					celda.setCellValue(credito.getFechaVencimiento());
					celda.setCellStyle(estiloFormatoICentrado);

					celda = fila.createCell((short) celd++);
					celda.setCellValue(credito.getFechaDeposito());
					celda.setCellStyle(estiloFormatoICentrado);

					celda = fila.createCell((short) celd++);
					celda.setCellValue(credito.getFechaAplicacion());
					celda.setCellStyle(estiloFormatoICentrado);

					celda = fila.createCell((short) celd++);
					celda.setCellValue(credito.getDiasDepAplica());
					celda.setCellStyle(estiloFormatoICentrado);
					
					celda = fila.createCell((short) celd++);
					celda.setCellValue(Utileria.convierteDoble(credito.getCapital()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short) celd++);
					celda.setCellValue(Utileria.convierteDoble(credito.getInteresOrdinario()));
					celda.setCellStyle(estiloFormatoDecimal);

					celda = fila.createCell((short) celd++);
					celda.setCellValue(Utileria.convierteDoble(credito.getInteresMoratorio()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short) celd++);
					celda.setCellValue(Utileria.convierteDoble(credito.getIva()));
					celda.setCellStyle(estiloFormatoDecimal);

					celda = fila.createCell((short) celd++);
					celda.setCellValue(Utileria.convierteDoble(credito.getNotasCargo()));
					celda.setCellStyle(estiloFormatoDecimal);

					celda = fila.createCell((short) celd++);
					celda.setCellValue(Utileria.convierteDoble(credito.getIvaNotasCargo()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short) celd++);
					celda.setCellValue(Utileria.convierteDoble(credito.getTotal()));
					celda.setCellStyle(estiloFormatoDecimal);

					i++;
				}
				/* Auto Ajusto las Columnas */
			}

			i = i + 2;
			fila = hoja.createRow(i);
			celda = fila.createCell((short) 0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg10);

			i = i + 1;
			fila = hoja.createRow(i);
			celda = fila.createCell((short) 0);
			tamanioLista = (tamanioLista==-1?0:tamanioLista);
			celda.setCellValue(tamanioLista);

			// Creo la cabecera
			response.addHeader("Content-Disposition", "inline; filename=ReportePagosAnticipados.xlsx");
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

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

}

