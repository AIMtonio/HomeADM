package soporte.servicio;

import general.servicio.BaseServicio;
import herramientas.Constantes;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import soporte.bean.RepEdoCtaBean;
import soporte.dao.RepEdoCtaDAO;

public class RepEdoCtaServicio extends BaseServicio{
	RepEdoCtaDAO repEdoCtaDAO = null;

	public RepEdoCtaServicio(){
		super();
	}

	/**
	 * Funcion para generar el reporte de estado de cuenta en formato excel.
	 * 
	 * @param numeroReporte: Numero de reporte 1.
	 * @param repEdoCtaBean: Bean con los datos necesarios para generar el reporte.
	 * @param response : HttpServletResponse
	 * @return Lista de objetos RepEdoCtaBean.
	 * @author jcardenas
	 */
	public List<RepEdoCtaBean> reporteEdoCtaExcel(int numeroReporte, RepEdoCtaBean repEdoCtaBean, HttpServletResponse response) {
		List<RepEdoCtaBean> listaEdoCta = null;
		listaEdoCta = reporteEstadoCuenta(numeroReporte, repEdoCtaBean, response);

		try {
			XSSFWorkbook libro = new XSSFWorkbook();

			// Se define una Fuente Arial 10 Bold para la cabecera de la tabla.
			XSSFFont fuenteArial10Negrita = libro.createFont();
			fuenteArial10Negrita.setFontHeightInPoints((short) 10);
			fuenteArial10Negrita.setFontName("Arial");
			fuenteArial10Negrita.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);

			// Se define una fuente Arial 10 para los datos obtenidos
			XSSFFont fuenteArial10 = libro.createFont();
			fuenteArial10.setFontHeightInPoints((short) 10);
			fuenteArial10.setFontName("Arial");

			// La fuente se mete en un estilo para poder ser usada.
			// Estilo para el titulo del reporte
			XSSFCellStyle estiloTitulo = libro.createCellStyle();
			estiloTitulo.setFont(fuenteArial10Negrita);
			estiloTitulo.setAlignment((short) XSSFCellStyle.ALIGN_CENTER);

			// Estilo para el encabezado de la tabla
			XSSFCellStyle estiloEncabezado = libro.createCellStyle();
			estiloEncabezado.setFont(fuenteArial10Negrita);
			estiloEncabezado.setAlignment((short) XSSFCellStyle.ALIGN_CENTER);

			XSSFCellStyle estiloParametros = libro.createCellStyle();
			estiloParametros.setFont(fuenteArial10Negrita);

			//Estilo para la informacion del reporte
			XSSFCellStyle estiloDatosReporte = libro.createCellStyle();
			estiloDatosReporte.setFont(fuenteArial10);
			estiloDatosReporte.setAlignment((short) XSSFCellStyle.ALIGN_LEFT);

			XSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteArial10);
			estiloCentrado.setAlignment((short) XSSFCellStyle.ALIGN_CENTER);

			// Creacion de hoja
			XSSFSheet hoja = libro.createSheet("Reporte de Estado de Cuenta");

			// Fila 0: Parametro Usuario
			XSSFRow fila = hoja.createRow(0);

			// Fila 1: Nombre de institucion y fecha
			fila = hoja.createRow(1);

			XSSFCell celda = fila.createCell((short) 8);
			celda.setCellValue("Usuario:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short) 9);
			celda.setCellValue(repEdoCtaBean.getClaveUsuario());
			celda.setCellStyle(estiloDatosReporte);

			celda = fila.createCell((short) 1);
			celda.setCellValue(repEdoCtaBean.getNombreInstitucion());
			celda.setCellStyle(estiloTitulo);

			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					1, //primera fila (0-based)
					1, //ultima fila  (0-based)
					1, //primer celda (0-based)
					7 //ultima celda (0-based)
					));

			// Fila 2: Título y hora
			fila = hoja.createRow(2);
			celda = fila.createCell((short) 8);
			celda.setCellValue("Fecha:");
			celda.setCellStyle(estiloParametros);	
			celda = fila.createCell((short) 9);
			celda.setCellValue(repEdoCtaBean.getFechaEmision());
			celda.setCellStyle(estiloDatosReporte);

			celda = fila.createCell((short) 1);
			celda.setCellValue("REPORTE DE ESTADO DE CUENTA DEL PERIODO " + repEdoCtaBean.getAnioMes());
			celda.setCellStyle(estiloTitulo);

			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					2, //primera fila (0-based)
					2, //ultima fila  (0-based)
					1, //primer celda (0-based)
					7 //ultima celda (0-based)
					));

			// Parametros para el reporte
			fila = hoja.createRow(3);

			Calendar calendario = new GregorianCalendar();
			int hora, minutos;
			hora = calendario.get(Calendar.HOUR_OF_DAY);
			minutos = calendario.get(Calendar.MINUTE);
			String formatoMinuto;
			String formatoHora;

			if (hora <= 9) {
				formatoHora = "0" + hora;
			} else {
				formatoHora = "" + hora;
			}

			if (minutos <= 9) {
				formatoMinuto = "0" + minutos;
			} else {
				formatoMinuto = "" + minutos;
			}

			repEdoCtaBean.setHoraEmision(formatoHora + ":" + formatoMinuto);

			String horaVar = repEdoCtaBean.getHoraEmision();

			celda = fila.createCell((short) 8);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short) 9);
			celda.setCellValue(horaVar);
			celda.setCellStyle(estiloDatosReporte);

			fila = hoja.createRow(4);

			celda = fila.createCell((short) 1);
			celda.setCellValue("Cliente:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short) 2);

			String cliente = "";

			if (repEdoCtaBean.getClienteID().equals(Constantes.STRING_CERO)) {
				cliente = "TODOS";
			} else {
				cliente = repEdoCtaBean.getNombreCliente();
			}

			celda.setCellValue(cliente);

			fila = hoja.createRow(5);
			
			celda = fila.createCell((short) 1);
			celda.setCellValue("Estatus:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short) 2);

			String estatus = "";

			if (repEdoCtaBean.getEstatus().equals(Constantes.STRING_CERO)) {
				estatus = "TODOS";
			} else {
				estatus = repEdoCtaBean.getNombreEstatus();
			}

			celda.setCellValue(estatus);

			// Celdas de títulos
			fila = hoja.createRow(6);

			celda = fila.createCell((short) 1);
			celda.setCellValue("Fecha de generación");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 2);
			celda.setCellValue("Número de Cliente");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 3);
			celda.setCellValue("Nombre");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 4);
			celda.setCellValue("Sucursal");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 5);
			celda.setCellValue("PDF Generado");
			celda.setCellStyle(estiloEncabezado);
			
			celda = fila.createCell((short) 6);
			celda.setCellValue("Timbrado Realizado");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 7);
			celda.setCellValue("Envío Realizado");
			celda.setCellStyle(estiloEncabezado);

			// Recorremos la lista para la parte de los datos

			int i = 7,iter = 0;
			int tamanioLista = 0;
			if (listaEdoCta != null) {
				tamanioLista = listaEdoCta.size();
			}

			RepEdoCtaBean reporte = null;

			for(iter = 0; iter < tamanioLista; iter++) {
				reporte = listaEdoCta.get(iter);
				fila=hoja.createRow(i);

				celda=fila.createCell((short) 1);
				celda.setCellValue(reporte.getAnioMes());
				celda.setCellStyle(estiloCentrado);

				celda=fila.createCell((short) 2);
				celda.setCellValue(reporte.getClienteID());
				celda.setCellStyle(estiloDatosReporte);

				celda=fila.createCell((short) 3); 
				celda.setCellValue(reporte.getNombreCliente());
				celda.setCellStyle(estiloDatosReporte);

				celda=fila.createCell((short) 4);
				celda.setCellValue("(" + reporte.getSucursalID() + ")" + " " + reporte.getSucursal());
				celda.setCellStyle(estiloDatosReporte);

				celda=fila.createCell((short) 5);
				celda.setCellValue(reporte.getPdfGenerado());
				celda.setCellStyle(estiloDatosReporte);

				celda=fila.createCell((short) 6);
				celda.setCellValue(reporte.getEstatusEdoCta());
				celda.setCellStyle(estiloDatosReporte);

				celda=fila.createCell((short) 7);
				celda.setCellValue(reporte.getEstatusEnvio());
				celda.setCellStyle(estiloDatosReporte);

				i++;
			}

			i = i + 1;
			fila=hoja.createRow(i); // Fila Registros Exportados
			celda = fila.createCell((short) 0);
			celda.setCellValue("Registros exportados");
			celda.setCellStyle(estiloParametros);

			i = i + 1;
			fila=hoja.createRow(i); // Fila Total de Registros Exportados
			celda=fila.createCell((short) 0);
			celda.setCellValue(tamanioLista);
			celda.setCellStyle(estiloDatosReporte);

			i = i + 1;
			fila=hoja.createRow(i); // Fila Procedimiento
			celda = fila.createCell((short) 0);
			celda.setCellValue("Procedimiento");
			celda.setCellStyle(estiloParametros);

			i = i + 1;
			fila=hoja.createRow(i); // Fila Nombre Procedimiento
			celda=fila.createCell((short) 0);
			celda.setCellValue("EDOCTAENVIOCORREOREP");
			celda.setCellStyle(estiloDatosReporte);

			for(int celdaIter = 0; celdaIter <= 9; celdaIter++)
				hoja.autoSizeColumn((short) celdaIter);

			// Crear la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteEdoCta.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
		} catch(Exception exception) {
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error al generar el reporte: " + exception.getMessage());
			exception.printStackTrace();
		}//Fin del catch

		return listaEdoCta;
	}

	public List<RepEdoCtaBean> reporteEstadoCuenta(int numeroReporte, RepEdoCtaBean repEdoCtaBean, HttpServletResponse response) {
		List<RepEdoCtaBean> listaEdoCta = null;
		listaEdoCta = repEdoCtaDAO.reporteEdoCta(numeroReporte, repEdoCtaBean);
		return listaEdoCta;
	}

	public RepEdoCtaDAO getRepEdoCtaDAO() {
		return repEdoCtaDAO;
	}

	public void setRepEdoCtaDAO(RepEdoCtaDAO repEdoCtaDAO) {
		this.repEdoCtaDAO = repEdoCtaDAO;
	}
}
