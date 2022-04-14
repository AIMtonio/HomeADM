package tesoreria.servicio;

import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import tesoreria.bean.BonificacionesBean;
import tesoreria.dao.BonificacionesDAO;

import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

public class BonificacionesServicio extends BaseServicio {
	
	BonificacionesDAO bonificacionesDAO = null;
	
	// Reportes en Documento Excel
	public static interface Enum_Rep_Bonificacion {
		int reporteExcel = 1;
		int reportePDF   = 2;
	}

	
	// Reporte Bitacora de Documentos en Excel
	public void reporteBonificaciones(BonificacionesBean bonificacionesBean, HttpServletResponse response) {

		List<BonificacionesBean> listaBonificaciones = null;
		String nombreArchivo = "";

		try{
			nombreArchivo = "REPORTE_BONIFICACIONES.xls";
			listaBonificaciones = bonificacionesDAO.reporteBonificaciones(bonificacionesBean, Enum_Rep_Bonificacion.reporteExcel);
			XSSFWorkbook libro = new XSSFWorkbook();

			//Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFCellStyle estiloTitulo = Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para cabeceras del reporte.
			XSSFCellStyle estiloCabecera = Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para los Parametros del reporte.
			XSSFCellStyle estiloParametros = Utileria.crearFuente(libro, 10, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloTexto = Utileria.crearFuente(libro, 10, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_NOBOLD);

			//Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloTextoCentrado = Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_NOBOLD);

			//Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloDecimal = Utileria.crearFuenteDecimal(libro, 10, Constantes.FUENTE_NOBOLD);

			// Creacion de hoja
			XSSFSheet hoja = libro.createSheet("REPORTE_BONIFICACIONES");
			XSSFRow fila= hoja.createRow(0);

			// Nombre Institucion y Usuario
			fila = hoja.createRow(1);
			XSSFCell celdaNombreUsuario=fila.createCell((short)1);
			celdaNombreUsuario = fila.createCell((short)9);
			celdaNombreUsuario.setCellValue("Usuario:");
			celdaNombreUsuario.setCellStyle(estiloParametros);
			celdaNombreUsuario = fila.createCell((short)10);
			celdaNombreUsuario.setCellValue((!bonificacionesBean.getNombreUsuario().isEmpty())?bonificacionesBean.getNombreUsuario(): "TODOS");
			celdaNombreUsuario.setCellStyle(estiloTexto);

			String horaReporte  = bonificacionesBean.getHoraEmision();
			String fechaReporte = bonificacionesBean.getFechaEmision();

			// Titulo del Reporte y Fecha
			fila = hoja.createRow(2);
			XSSFCell celdaInstitucion = fila.createCell((short)1);
			celdaInstitucion.setCellValue(bonificacionesBean.getNombreInstitucion());
			celdaInstitucion.setCellStyle(estiloTitulo);
			hoja.addMergedRegion(new CellRangeAddress(2, 2, 1, 8));

			celdaInstitucion = fila.createCell((short)9);
			celdaInstitucion.setCellValue("Fecha:");
			celdaInstitucion.setCellStyle(estiloParametros);
			celdaInstitucion = fila.createCell((short)10);
			celdaInstitucion.setCellValue(fechaReporte);
			celdaInstitucion.setCellStyle(estiloTexto);

			// Rango de Fechas del Reporte y hora
			fila = hoja.createRow(3);
			XSSFCell celdaNombreReporte = fila.createCell((short)1);
			celdaNombreReporte.setCellValue("REPORTE DE BONIFICACIONES DEL "+bonificacionesBean.getFechaInicio() + " AL " + bonificacionesBean.getFechaFin());
			celdaNombreReporte.setCellStyle(estiloTitulo);
			hoja.addMergedRegion(new CellRangeAddress(3, 3, 1, 8));

			celdaNombreReporte = fila.createCell((short)9);
			celdaNombreReporte.setCellValue("Hora:");
			celdaNombreReporte.setCellStyle(estiloParametros);
			celdaNombreReporte = fila.createCell((short)10);
			celdaNombreReporte.setCellValue(horaReporte);
			celdaNombreReporte.setCellStyle(estiloTexto);

			fila = hoja.createRow(4);
			fila = hoja.createRow(5);

			XSSFCell celdaParametros = fila.createCell((short)1);
			celdaParametros.setCellValue("Estatus:");
			celdaParametros.setCellStyle(estiloParametros);
			celdaParametros = fila.createCell((short)2);
			celdaParametros.setCellValue(bonificacionesBean.getDescripcionEstatus());
			celdaParametros.setCellStyle(estiloTexto);

			fila = hoja.createRow(6);
			fila = hoja.createRow(7);
			XSSFCell celdaEncabezados = fila.createCell((short)1);

			celdaEncabezados = fila.createCell((short)1);
			celdaEncabezados.setCellValue("Número Cliente");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)2);
			celdaEncabezados.setCellValue("Nombre Cliente");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)3);
			celdaEncabezados.setCellValue("Cuenta Ahorro");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)4);
			celdaEncabezados.setCellValue("Monto");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)5);
			celdaEncabezados.setCellValue("Forma de Pago");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)6);
			celdaEncabezados.setCellValue("Estatus");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)7);
			celdaEncabezados.setCellValue("Folio Dispersión");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)8);
			celdaEncabezados.setCellValue("Meses para Amortizar");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)9);
			celdaEncabezados.setCellValue("Monto Amortizado");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)10);
			celdaEncabezados.setCellValue("Monto por Amortizar");
			celdaEncabezados.setCellStyle(estiloCabecera);

			int renglon = 8;
			int iteracion = 0;
			int numRegistros = 0;
			int tamanioLista = listaBonificaciones.size();
			BonificacionesBean bonificaciones = null;

			for( iteracion =0; iteracion <tamanioLista; iteracion  ++){

				bonificaciones = (BonificacionesBean) listaBonificaciones.get(iteracion );
				fila=hoja.createRow(renglon);
				XSSFCell celdaCuerpo = fila.createCell((short)1);

				celdaCuerpo=fila.createCell((short)1);
				celdaCuerpo.setCellValue(Utileria.convierteEntero(bonificaciones.getClienteID()));
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)2);
				celdaCuerpo.setCellValue(bonificaciones.getNombreCliente());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)3);
				celdaCuerpo.setCellValue(Utileria.convierteLong(bonificaciones.getCuentaAhoID()));
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)4);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(bonificaciones.getMonto()));
				celdaCuerpo.setCellStyle(estiloDecimal);

				celdaCuerpo=fila.createCell((short)5);
				celdaCuerpo.setCellValue(bonificaciones.getTipoDispersion());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)6);
				celdaCuerpo.setCellValue(bonificaciones.getEstatus());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)7);
				celdaCuerpo.setCellValue(Utileria.convierteEntero(bonificaciones.getFolioDispersion()));
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)8);
				celdaCuerpo.setCellValue(Utileria.convierteEntero(bonificaciones.getMeses()));
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)9);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(bonificaciones.getMontoAmortizado()));
				celdaCuerpo.setCellStyle(estiloDecimal);

				celdaCuerpo=fila.createCell((short)10);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(bonificaciones.getMontoPorAmortizar()));
				celdaCuerpo.setCellStyle(estiloDecimal);

				renglon++;
				numRegistros = numRegistros+1;
			}

			renglon = renglon + 1;
			fila = hoja.createRow(renglon);
			XSSFCell celdaPiePagina = fila.createCell((short)1);
			celdaPiePagina = fila.createCell((short)0);
			celdaPiePagina.setCellValue("Registros Exportados");
			celdaPiePagina.setCellStyle(estiloParametros);

			renglon = renglon + 1;
			fila = hoja.createRow(renglon);
			celdaPiePagina = fila.createCell((short)0);
			celdaPiePagina.setCellValue(numRegistros);
			celdaPiePagina.setCellStyle(estiloTexto);

			for(int celdaAjustar=0; celdaAjustar <= 10; celdaAjustar++){
				hoja.autoSizeColumn((short)celdaAjustar);
			}

			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=" + nombreArchivo);
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();


		} catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.info("error en el Reporte de Bonificaciones " + exception);
		}

	}

	public BonificacionesDAO getBonificacionesDAO() {
		return bonificacionesDAO;
	}


	public void setBonificacionesDAO(BonificacionesDAO bonificacionesDAO) {
		this.bonificacionesDAO = bonificacionesDAO;
	}
}
