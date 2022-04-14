package pld.reporte;

import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
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
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.OpeInusualesBean;
import pld.servicio.OpeInusualesServicio;
import pld.servicio.OpeInusualesServicio.Enum_Lis_OpeInusuales;

public class RepOpFraccionadasControlador extends AbstractCommandController {
	String					nombreReporte			= null;
	String					successView				= null;
	OpeInusualesServicio	opeInusualesServicio	= null;
	ParametrosSesionBean	parametrosSesionBean	= null;

	public static interface Enum_Con_TipRepor {
		int	PDF		= 1;
		int	EXCEL	= 2;
	}

	public RepOpFraccionadasControlador() {
		setCommandClass(OpeInusualesBean.class);
		setCommandName("opeInusualesBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		OpeInusualesBean opeInuBean = (OpeInusualesBean) command;
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		String htmlString = "";
		switch (tipoReporte) {
			case Enum_Con_TipRepor.PDF:
				reportePDF(opeInuBean, nombreReporte, response);
				break;
			case Enum_Con_TipRepor.EXCEL:
				reporteExcel(opeInuBean, Enum_Lis_OpeInusuales.listaFraccionadas, response);
				break;
		}

		return new ModelAndView(getSuccessView(), "reporte", htmlString);
	}

	public ByteArrayOutputStream reportePDF(OpeInusualesBean persInvListasBean, String nombreReporte, HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = opeInusualesServicio.reporteOpeFraccionadas(persInvListasBean, nombreReporte);
			response.addHeader("Content-Disposition", "inline; filename=RepOpFraccionadas.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes, 0, bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return htmlStringPDF;
	}

	private ByteArrayOutputStream reporteExcel(OpeInusualesBean opeInusualesBean, int tipoLista, HttpServletResponse response) {
		List<OpeInusualesBean> listaPersonas = null;
		try {
			listaPersonas = opeInusualesServicio.lista(tipoLista, opeInusualesBean);
			String safilocalecliente = "safilocale.cliente";
			safilocalecliente = Utileria.generaLocale(safilocalecliente, parametrosSesionBean.getNomCortoInstitucion());
			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
			opeInusualesBean.setHoraEmision(postFormater.format(calendario.getTime()));
			XSSFSheet hoja = null;
			XSSFWorkbook libro = null;
			libro = new XSSFWorkbook();
			// Se crea una Fuente Negrita con tamaño 10 para el titulo del
			// reporte
			XSSFFont fuenteNegrita10 = libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short) 10);
			fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);

			XSSFFont fuenteNegrita10Izq = libro.createFont();
			fuenteNegrita10Izq.setFontHeightInPoints((short) 10);
			fuenteNegrita10Izq.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10Izq.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);

			// Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			XSSFFont fuenteNegrita8 = libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short) 8);
			fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			XSSFFont fontNegTotales = libro.createFont();
			fontNegTotales.setFontHeightInPoints((short) 8);
			fontNegTotales.setFontName(HSSFFont.FONT_ARIAL);
			fontNegTotales.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);

			// Crea un Fuente con tamaño 8 para informacion del reporte.
			XSSFFont fuente8 = libro.createFont();
			fuente8.setFontHeightInPoints((short) 8);
			fuente8.setFontName(HSSFFont.FONT_ARIAL);

			XSSFFont fuente82 = libro.createFont();
			fuente82.setFontHeightInPoints((short) 8);
			fuente82.setFontName(HSSFFont.FONT_ARIAL);
			
			XSSFFont fuenteCen = libro.createFont();
			fuenteCen.setFontHeightInPoints((short) 8);
			fuenteCen.setFontName(HSSFFont.FONT_ARIAL);

			XSSFFont fuente823 = libro.createFont();
			fuente823.setFontHeightInPoints((short) 8);
			fuente823.setFontName(HSSFFont.FONT_ARIAL);
			
			XSSFFont fuente8NegRight= libro.createFont();
			fuente8NegRight.setFontHeightInPoints((short) 8);
			fuente8NegRight.setFontName(HSSFFont.FONT_ARIAL);
			fuente8NegRight.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);

			XSSFFont fuente8Cuerpo = libro.createFont();
			fuente8Cuerpo.setFontHeightInPoints((short) 8);
			fuente8Cuerpo.setFontName(HSSFFont.FONT_ARIAL);

			// Crea un Fuente con tamaño 8 para informacion del reporte.
			XSSFFont fuente10 = libro.createFont();
			fuente10.setFontHeightInPoints((short) 10);
			fuente10.setFontName(HSSFFont.FONT_ARIAL);

			// La fuente se mete en un estilo para poder ser usada.
			// Estilo negrita de 10 para el titulo del reporte
			XSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			estiloNeg10.setAlignment(XSSFCellStyle.ALIGN_CENTER);

			// Alineado a la izq
			XSSFCellStyle estiloNeg10Izq = libro.createCellStyle();
			estiloNeg10Izq.setFont(fuenteNegrita10Izq);
			estiloNeg10Izq.setAlignment(XSSFCellStyle.ALIGN_LEFT);

			// Estilo negrita de 8 para encabezados del reporte
			XSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			estiloNeg8.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			
			XSSFCellStyle estiloNegTotales = libro.createCellStyle();
			estiloNegTotales.setFont(fontNegTotales);
			estiloNegTotales.setAlignment(XSSFCellStyle.ALIGN_RIGHT);

			XSSFCellStyle estilo8 = libro.createCellStyle();
			estilo8.setFont(fuente82);
			
			XSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteCen);
			estiloCentrado.setAlignment(XSSFCellStyle.ALIGN_CENTER);

			XSSFCellStyle estilo8AlingRight = libro.createCellStyle();
			estilo8AlingRight.setFont(fuente823);
			estilo8AlingRight.setAlignment(XSSFCellStyle.ALIGN_RIGHT);
			
			XSSFCellStyle estiloEtiTotal = libro.createCellStyle();
			estiloEtiTotal.setFont(fuente8NegRight);
			estiloEtiTotal.setAlignment(XSSFCellStyle.ALIGN_RIGHT);

			XSSFCellStyle estilo10 = libro.createCellStyle();
			estilo10.setFont(fuente10);
			// Estilo Formato decimal (0.00)
			XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			XSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,###,##0.00"));
			estiloFormatoDecimal.setFont(fuente8);

			// Estilo Formato decimal (0.00)
			XSSFCellStyle estiloFormatoDecimalTit = libro.createCellStyle();
			XSSFDataFormat formatTit = libro.createDataFormat();
			estiloFormatoDecimalTit.setDataFormat(formatTit.getFormat("$#,###,##0.00"));
			estiloFormatoDecimalTit.setFont(fuenteNegrita8);

			// Creacion de hoja
			hoja = libro.createSheet("OPERACIONES FRACCIONADAS");

			// inicio fecha, usuario,institucion y hora
			XSSFRow fila = hoja.createRow(0);
			XSSFCell celdaUsu = fila.createCell((short) 6);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg10Izq);
			celdaUsu = fila.createCell((short) 7);
			celdaUsu.setCellValue(((!opeInusualesBean.getUsuario().isEmpty()) ? opeInusualesBean.getUsuario() : "TODOS").toUpperCase());

			fila = hoja.createRow(1);
			String fechaVar = opeInusualesBean.getFechaSistema().toString();
			XSSFCell celdaFec = fila.createCell((short) 6);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg10Izq);
			celdaFec = fila.createCell((short) 7);
			celdaFec.setCellValue(fechaVar);

			XSSFCell celdaInst = fila.createCell((short) 1);
			celdaInst.setCellValue(opeInusualesBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(1, // primera fila
															// (0-based)
			1, // ultima fila (0-based)
			1, // primer celda (0-based)
			5 // ultima celda (0-based)
			));
			celdaInst.setCellStyle(estiloNeg10);

			fila = hoja.createRow(2);
			XSSFCell celdaHora = fila.createCell((short) 6);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg10Izq);
			celdaHora = fila.createCell((short) 7);
			celdaHora.setCellValue(opeInusualesBean.getHoraEmision());
			// fin fecha usuario,institucion y hora
			XSSFCell celda = fila.createCell((short) 1);
			celda.setCellValue("OPERACIONES FRACCIONADAS POR " + safilocalecliente.toUpperCase());
			celda.setCellStyle(estiloNeg10);

			hoja.addMergedRegion(new CellRangeAddress(// funcion para unir
														// celdas
			2, // primera fila (0-based)
			2, // ultima fila (0-based)
			1, // primer celda (0-based)
			5 // ultima celda (0-based)
			));
			celda.setCellStyle(estiloNeg10);

			fila = hoja.createRow(4);

			celda = fila.createCell((short) 1);
			celda.setCellStyle(estiloNeg10Izq);
			celda.setCellValue("Periodo:");

			celda = fila.createCell((short) 2);
			celda.setCellStyle(estilo10);
			celda.setCellValue(opeInusualesBean.getPeriodoDes());

			celda = fila.createCell((short) 4);
			celda.setCellStyle(estiloNeg10Izq);
			celda.setCellValue(safilocalecliente + ": ");

			celda = fila.createCell((short) 5);
			celda.setCellStyle(estilo10);
			celda.setCellValue(opeInusualesBean.getClienteID());

			celda = fila.createCell((short) 5);
			celda.setCellStyle(estilo10);
			celda.setCellValue(opeInusualesBean.getNombresPersonaInv());

			fila = hoja.createRow(5);
			fila = hoja.createRow(6);

			int col = 1;

			celda = fila.createCell(col++);
			celda.setCellValue("Número " + safilocalecliente);
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell(col++);
			celda.setCellValue("Nombre del " + safilocalecliente);
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell(col++);
			celda.setCellValue("Número de Cuenta");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell(col++);
			celda.setCellValue("Número de Movimiento");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell(col++);
			celda.setCellValue("Fecha del Movimiento");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell(col++);
			celda.setCellValue("Descripción del Movimiento");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell(col++);
			celda.setCellValue("Monto");
			celda.setCellStyle(estiloNeg8);

			int tamanioLista = listaPersonas.size();
			int i = 7;
			long totalRegistros = 0;

			OpeInusualesBean pers = null;
			for (int iter = 0; iter < tamanioLista; iter++) {
				pers = (OpeInusualesBean) listaPersonas.get(iter);

				int cool = 1;

				fila = hoja.createRow(i);
				celda = fila.createCell(cool++);
				celda.setCellValue(pers.getClienteID());
				celda.setCellStyle(estilo8);

				celda = fila.createCell(cool++);
				celda.setCellValue(pers.getNomPersonaInv());
				celda.setCellStyle(estilo8);

				celda = fila.createCell(cool++);
				celda.setCellValue(pers.getCuentaAhoID());
				celda.setCellStyle(estilo8);
				
				celda = fila.createCell(cool++);
				celda.setCellValue(pers.getTransaccionOpe());
				celda.setCellStyle(estilo8);
				
				celda = fila.createCell(cool++);
				celda.setCellValue(pers.getFecha());
				celda.setCellStyle(estiloCentrado);

				celda = fila.createCell(cool++);
				celda.setCellValue(pers.getDescripcionMov());
				if(pers.getTipoOperacion().equalsIgnoreCase("S")){
					celda.setCellStyle(estiloNegTotales);
				} else {
					celda.setCellStyle(estilo8);
					totalRegistros ++;
				}

				celda = fila.createCell(cool++);
				celda.setCellValue(Utileria.convierteDoble(pers.getMontoOperacion()));
				celda.setCellStyle(estiloFormatoDecimal);

				i++;
			}
			
			i = i + 2;
			fila = hoja.createRow(i);
			celda = fila.createCell((short) 0);
			celda.setCellValue("Registros Exportados:");
			celda.setCellStyle(estiloNeg8);
			i++;
			fila = hoja.createRow(i);
			celda = fila.createCell((short) 0);
			celda.setCellValue(totalRegistros);
			celda.setCellStyle(estilo8);
			
			// NÚM. DEL CLIENTE.
			hoja.setColumnWidth(1, 15 * 256);
			// NOMBRE COMPLETO.
			hoja.setColumnWidth(2, 35 * 256);
			// NÚM. DE LA CUENTA.
			hoja.setColumnWidth(3, 15 * 256);
			// NÚM. DEL MOVIMIENTO.
			hoja.setColumnWidth(4, 20 * 256);
			// FECHA DEL MOVIMIENTO.
			hoja.setColumnWidth(5, 20 * 256);
			// DESCRIPCIÓN.
			hoja.setColumnWidth(6, 40 * 256);
			// MONTO.
			hoja.setColumnWidth(7, 20 * 256);
			
			// Creo la cabecera
			response.addHeader("Content-Disposition", "inline; filename=ReporteOpFraccionadas.xlsx");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public OpeInusualesServicio getOpeInusualesServicio() {
		return opeInusualesServicio;
	}

	public void setOpeInusualesServicio(OpeInusualesServicio opeInusualesServicio) {
		this.opeInusualesServicio = opeInusualesServicio;
	}

}
