package psl.servicio;

import general.servicio.BaseServicio;
import herramientas.Constantes;

import java.io.ByteArrayOutputStream;
import java.text.NumberFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Locale;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.util.CellRangeAddress;

import psl.bean.PSLReportePagoBean;
import psl.dao.PSLReportePagoDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;

public class PSLReportePagoServicio extends BaseServicio{
	PSLReportePagoDAO pslReportePagoDAO = null;

	public PSLReportePagoServicio(){
		super();
	}

	public ByteArrayOutputStream reportePagoPDF(PSLReportePagoBean pslReportePagoBean, String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio", pslReportePagoBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin", pslReportePagoBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_SucursalID", pslReportePagoBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_Sucursal", pslReportePagoBean.getSucursal());
		parametrosReporte.agregaParametro("Par_TipoServicioID", pslReportePagoBean.getTipoServicioID());
		parametrosReporte.agregaParametro("Par_TipoServicio", pslReportePagoBean.getTipoServicio());
		parametrosReporte.agregaParametro("Par_ServicioID", pslReportePagoBean.getServicioID());
		parametrosReporte.agregaParametro("Par_Servicio", pslReportePagoBean.getServicio());
		parametrosReporte.agregaParametro("Par_ProductoID", pslReportePagoBean.getProductoID());
		parametrosReporte.agregaParametro("Par_Producto", pslReportePagoBean.getProducto());
		parametrosReporte.agregaParametro("Par_Canal", pslReportePagoBean.getCanal());
		parametrosReporte.agregaParametro("Par_FechaEmision", pslReportePagoBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_ClaveUsuario", pslReportePagoBean.getClaveUsuario());
		parametrosReporte.agregaParametro("Par_NombreUsuario", pslReportePagoBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", pslReportePagoBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_NombreSucursal", pslReportePagoBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_RutaImagen", pslReportePagoBean.getRutaImagen());
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public List<PSLReportePagoBean> reportePagoExcel(int numeroReporte, PSLReportePagoBean pslReportePagoBean, HttpServletResponse response) {
		List<PSLReportePagoBean> listaPagoServicios = null;
		listaPagoServicios = reportePagoServicios(numeroReporte, pslReportePagoBean, response);

		try {
			HSSFWorkbook libro = new HSSFWorkbook();

			// Se define una Fuente Arial 10 Bold para la cabecera de la tabla.
			HSSFFont fuenteArial10Negrita = libro.createFont();
			fuenteArial10Negrita.setFontHeightInPoints((short) 10);
			fuenteArial10Negrita.setFontName("Arial");
			fuenteArial10Negrita.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);

			// Se define una fuente Arial 10 para los datos obtenidos
			HSSFFont fuenteArial10 = libro.createFont();
			fuenteArial10.setFontHeightInPoints((short) 10);
			fuenteArial10.setFontName("Arial");

			// La fuente se mete en un estilo para poder ser usada.
			// Estilo para el titulo del reporte
			HSSFCellStyle estiloTitulo = libro.createCellStyle();
			estiloTitulo.setFont(fuenteArial10Negrita);
			estiloTitulo.setAlignment((short) HSSFCellStyle.ALIGN_CENTER);

			// Estilo para el encabezado de la tabla
			HSSFCellStyle estiloEncabezado = libro.createCellStyle();
			estiloEncabezado.setFont(fuenteArial10Negrita);
			estiloEncabezado.setAlignment((short) HSSFCellStyle.ALIGN_CENTER);

			HSSFCellStyle estiloParametros = libro.createCellStyle();
			estiloParametros.setFont(fuenteArial10Negrita);

			//Estilo para la informacion del reporte
			HSSFCellStyle estiloDatosReporte = libro.createCellStyle();
			estiloDatosReporte.setFont(fuenteArial10);
			estiloDatosReporte.setAlignment((short) HSSFCellStyle.ALIGN_LEFT);

			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteArial10);
			estiloCentrado.setAlignment((short) HSSFCellStyle.ALIGN_CENTER);

			HSSFCellStyle estiloMoneda = libro.createCellStyle();
			estiloMoneda.setFont(fuenteArial10);
			estiloMoneda.setAlignment((short) HSSFCellStyle.ALIGN_RIGHT);
			HSSFDataFormat formatoMoneda = libro.createDataFormat();
			estiloMoneda.setDataFormat(formatoMoneda.getFormat("$#,##0.00"));

			// Creacion de hoja
			HSSFSheet hoja = libro.createSheet("Reporte de Pago de Servicios en Línea");

			// Fila 0: Parametro Usuario
			HSSFRow fila = hoja.createRow(0);

			// Fila 1: Nombre de institucion y fecha
			fila = hoja.createRow(1);

			HSSFCell celda = fila.createCell((short) 14);
			celda.setCellValue("Usuario:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short) 15);
			celda.setCellValue(pslReportePagoBean.getClaveUsuario());
			celda.setCellStyle(estiloDatosReporte);

			celda = fila.createCell((short) 1);
			celda.setCellValue(pslReportePagoBean.getNombreInstitucion());
			celda.setCellStyle(estiloTitulo);

			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					1, //primera fila (0-based)
					1, //ultima fila  (0-based)
					1, //primer celda (0-based)
					13 //ultima celda (0-based)
					));

			// Fila 2: Título y hora
			fila = hoja.createRow(2);
			celda = fila.createCell((short) 14);
			celda.setCellValue("Fecha:");
			celda.setCellStyle(estiloParametros);	
			celda = fila.createCell((short) 15);
			celda.setCellValue(pslReportePagoBean.getFechaEmision());
			celda.setCellStyle(estiloDatosReporte);

			celda = fila.createCell((short) 1);
			celda.setCellValue("REPORTE DE PAGO DE SERVICIOS DEL " + pslReportePagoBean.getFechaInicio() + " AL "+pslReportePagoBean.getFechaFin());
			celda.setCellStyle(estiloTitulo);

			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					2, //primera fila (0-based)
					2, //ultima fila  (0-based)
					1, //primer celda (0-based)
					13 //ultima celda (0-based)
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

			pslReportePagoBean.setHoraEmision(formatoHora + ":" + formatoMinuto);

			String horaVar = pslReportePagoBean.getHoraEmision();

			celda = fila.createCell((short) 14);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short) 15);
			celda.setCellValue(horaVar);
			celda.setCellStyle(estiloDatosReporte);

			fila = hoja.createRow(4);

			celda = fila.createCell((short) 1);
			celda.setCellValue("Sucursal:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short) 2);

			String sucursal = "";

			if (pslReportePagoBean.getSucursalID().equals(Constantes.STRING_CERO)) {
				sucursal = "TODAS";
			} else {
				sucursal = pslReportePagoBean.getSucursal();
			}

			celda.setCellValue(sucursal);

			celda = fila.createCell((short) 8);
			celda.setCellValue("Servicio:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short) 9);

			String servicio = "";

			if (pslReportePagoBean.getServicioID().equals(Constantes.STRING_CERO)) {
				servicio = "TODOS";
			} else {
				servicio = pslReportePagoBean.getServicio();
			}

			celda.setCellValue(servicio);

			celda = fila.createCell((short) 12);
			celda.setCellValue("Canal:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short) 13);

			String canalVentanilla = "V";
			String canalLinea = "L";
			String canalMovil = "M";
			String canalVentanillaLinea = "VL";
			String canalVentanillaMovil = "VM";
			String canalLineaMovil = "LM";

			String canalVentanillaDesc = "VENTANILLA";
			String canalLineaDesc = "BANCA EN LÍNEA";
			String canalMovilDesc = "BANCA MÓVIL";
			String canalVentanillaLineaDesc = "VENTANILLA, BANCA EN LÍNEA";
			String canalVentanillaMovilDesc = "VENTANILLA, BANCA MÓVIL";
			String canalLineaMovilDesc = "BANCA EN LÍNEA, BANCA MÓVIL";
			String canalVentanillaLineaMovilDesc = "VENTANILLA, BANCA EN LÍNEA, BANCA MÓVIL";

			if (pslReportePagoBean.getCanal().equals(Constantes.STRING_VACIO)) {
				celda.setCellValue(canalVentanillaLineaMovilDesc);
			}
			if (pslReportePagoBean.getCanal().equals(canalVentanilla)) {
				celda.setCellValue(canalVentanillaDesc);
			}
			if (pslReportePagoBean.getCanal().equals(canalLinea)) {
				celda.setCellValue(canalLineaDesc);
			}
			if (pslReportePagoBean.getCanal().equals(canalMovil)) {
				celda.setCellValue(canalMovilDesc);
			}
			if (pslReportePagoBean.getCanal().equals(canalVentanillaLinea)) {
				celda.setCellValue(canalVentanillaLineaDesc);
			}
			if (pslReportePagoBean.getCanal().equals(canalVentanillaMovil)) {
				celda.setCellValue(canalVentanillaMovilDesc);
			}
			if (pslReportePagoBean.getCanal().equals(canalLineaMovil)) {
				celda.setCellValue(canalLineaMovilDesc);
			}

			fila = hoja.createRow(5);

			celda = fila.createCell((short) 1);
			celda.setCellValue("Tipo de servicio:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short) 2);

			String tipoServicio = "";

			if (pslReportePagoBean.getTipoServicioID().equals(Constantes.STRING_VACIO)) {
				tipoServicio = "TODOS";
			} else {
				tipoServicio = pslReportePagoBean.getTipoServicio();
			}

			celda.setCellValue(tipoServicio);

			celda = fila.createCell((short) 8);
			celda.setCellValue("Producto:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short) 9);

			String producto = "";

			if (pslReportePagoBean.getProductoID().equals(Constantes.STRING_CERO)) {
				producto = "TODOS";
			} else {
				producto = pslReportePagoBean.getProducto();
			}

			celda.setCellValue(producto);

			// Celdas de títulos
			fila = hoja.createRow(6);

			celda = fila.createCell((short) 1);
			celda.setCellValue("Fecha");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 2);
			celda.setCellValue("Sucursal");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 3);
			celda.setCellValue("No. Caja");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 4);
			celda.setCellValue("Servicio");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 5);
			celda.setCellValue("Tipo de servicio");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 6);
			celda.setCellValue("Producto");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 7);
			celda.setCellValue("Teléfono");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 8);
			celda.setCellValue("Referencia");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 9);
			celda.setCellValue("Monto servicio");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 10);
			celda.setCellValue("Monto comisión proveedor");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 11);
			celda.setCellValue("Monto comisión institución");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 12);
			celda.setCellValue("IVA comisión institución");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 13);
			celda.setCellValue("Total pagado");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 14);
			celda.setCellValue("Forma de pago");
			celda.setCellStyle(estiloEncabezado);

			celda = fila.createCell((short) 15);
			celda.setCellValue("Canal");
			celda.setCellStyle(estiloEncabezado);

			// Recorremos la lista para la parte de los datos

			int i = 7,iter = 0;
			int tamanioLista = 0;
			if (listaPagoServicios != null) {
				tamanioLista = listaPagoServicios.size();
			}

			PSLReportePagoBean reporte = null;

			NumberFormat mxn = NumberFormat.getCurrencyInstance(Locale.US);

			double monto = 0;

			for(iter = 0; iter < tamanioLista; iter++) {
				reporte = listaPagoServicios.get(iter);
				fila=hoja.createRow(i);

				celda=fila.createCell((short) 1);
				celda.setCellValue(reporte.getFechaPago().substring(0, 10));
				celda.setCellStyle(estiloCentrado);

				celda=fila.createCell((short) 2);
				celda.setCellValue("(" + reporte.getSucursalID() + ")" + " " + reporte.getSucursal());
				celda.setCellStyle(estiloDatosReporte);

				celda=fila.createCell((short) 3); 
				celda.setCellValue(reporte.getNumeroCaja());
				celda.setCellStyle(estiloDatosReporte);

				celda=fila.createCell((short) 4);
				celda.setCellValue(reporte.getServicio());
				celda.setCellStyle(estiloDatosReporte);

				tipoServicio = "";
				if (reporte.getTipoServicioID().equals("RE")) {
					tipoServicio = "RECARGA";
				}
				if (reporte.getTipoServicioID().equals("CO")) {
					tipoServicio = "CONSULTA DE SALDO";
				}
				if (reporte.getTipoServicioID().equals("PS")) {
					tipoServicio = "PAGO DE SERVICIO";
				}
				celda=fila.createCell((short) 5);
				celda.setCellValue(tipoServicio);
				celda.setCellStyle(estiloDatosReporte);

				celda=fila.createCell((short) 6);
				celda.setCellValue(reporte.getProducto());
				celda.setCellStyle(estiloDatosReporte);

				celda=fila.createCell((short) 7);
				celda.setCellValue(reporte.getTelefono());
				celda.setCellStyle(estiloDatosReporte);

				celda=fila.createCell((short) 8);
				celda.setCellValue(reporte.getReferencia());
				celda.setCellStyle(estiloDatosReporte);

				monto = Math.abs(Double.parseDouble(reporte.getMontoServicio()));
				celda=fila.createCell((short) 9);
				celda.setCellValue(monto);
				celda.setCellStyle(estiloMoneda);

				monto = Math.abs(Double.parseDouble(reporte.getMontoComisionProveedor()));
				celda=fila.createCell((short) 10);
				celda.setCellValue(monto);
				celda.setCellStyle(estiloMoneda);

				monto = Math.abs(Double.parseDouble(reporte.getMontoComisionInstitucion()));
				celda=fila.createCell((short) 11);
				celda.setCellValue(monto);
				celda.setCellStyle(estiloMoneda);

				monto = Math.abs(Double.parseDouble(reporte.getIvaComisionInstitucion()));
				celda=fila.createCell((short) 12);
				celda.setCellValue(monto);
				celda.setCellStyle(estiloMoneda);

				monto = Math.abs(Double.parseDouble(reporte.getTotalPagado()));
				celda=fila.createCell((short) 13);
				celda.setCellValue(monto);
				celda.setCellStyle(estiloMoneda);

				celda=fila.createCell((short) 14);
				celda.setCellValue(reporte.getFormaPago());
				celda.setCellStyle(estiloDatosReporte);

				celda=fila.createCell((short) 15);
				celda.setCellValue(reporte.getCanal());
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
			celda.setCellValue("PSLCOBROSLREP");
			celda.setCellStyle(estiloDatosReporte);

			for(int celdaIter = 0; celdaIter <= 15; celdaIter++)
				hoja.autoSizeColumn((short) celdaIter);

			// Crear la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReportePagoServicios.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
		} catch(Exception exception) {
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error al generar el reporte: " + exception.getMessage());
			exception.printStackTrace();
		}//Fin del catch

		return listaPagoServicios;
	}

	public List<PSLReportePagoBean> reportePagoServicios(int numeroReporte, PSLReportePagoBean pslReportePagoBean, HttpServletResponse response) {
		List<PSLReportePagoBean> listaPagoServicios = null;
		listaPagoServicios = pslReportePagoDAO.reportePagoServicios(numeroReporte, pslReportePagoBean);
		return listaPagoServicios;
	}

	public PSLReportePagoDAO getPslReportePagoDAO() {
		return pslReportePagoDAO;
	}

	public void setPslReportePagoDAO(PSLReportePagoDAO pslReportePagoDAO) {
		this.pslReportePagoDAO = pslReportePagoDAO;
	}
}
