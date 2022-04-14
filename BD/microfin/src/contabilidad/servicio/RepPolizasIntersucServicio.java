package contabilidad.servicio;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFSheet;

import contabilidad.bean.RepPolizasIntersucBean;
import contabilidad.dao.RepPolizasIntersucDAO;
//import contabilidad.dao.ReporteTransCtasBanDAO;
import general.servicio.BaseServicio;
import herramientas.Archivos;

public class RepPolizasIntersucServicio extends BaseServicio {

	// ---------- Variables
	// ------------------------------------------------------------------------
	RepPolizasIntersucDAO reportePolizasIntersucDAO = null;

	Archivos manejoArchivo = null;

	public RepPolizasIntersucServicio() {
		super();
	}

	public static interface Enum_Rep_PolIntersuc {
		int operacionesVen = 1;
		int gastospoComp = 2;
		int transCtasBan = 3;
		int facturasProv = 4;
		int polizasInter = 5;
	}

	// lista para reportes de tranferencia entre cuentas
	public List listaReportesTransferCtasBanc(int tipoLista,
			RepPolizasIntersucBean repPolizasIntersucBean,
			HttpServletResponse response) throws Exception {

		List listaTransferCtasBan = null;
		int mes = 0;
		String nombreMes = "", ano = "1900";
		String cadenaFecha[] = repPolizasIntersucBean.getFechaEmision().split(
				"-");
		mes = Integer.parseInt(cadenaFecha[1]);
		ano = cadenaFecha[0];
		nombreMes = obtenerNombreMes(mes);
		String usuario = repPolizasIntersucBean.getClaveUsuario();
		String fecha = repPolizasIntersucBean.getFechaEmision();
		String hora = repPolizasIntersucBean.getHoraEmision();
		String fechaIni = repPolizasIntersucBean.getFechaInicial();
		String fechaFin = repPolizasIntersucBean.getFechaFinal();
		String tipoReg = repPolizasIntersucBean.getTipoRegistro();
		String nombreInstitucion = repPolizasIntersucBean.getNombreInstitucion();

		String[] Encabezados = {
				nombreInstitucion,
				"REPORTE DE TRANSFERENCIAS CUENTAS BANCARIAS",
				"DEL: " + fechaIni + " AL " + fechaFin };
		String[] titulos = { "SUCURSAL ORIGEN", "CENTRO COSTO  ORIGEN",
				"SUCURSAL DESTINO", "CENTRO DE COSTO DESTINO",
				"MONTOS TRANSFERIDOS", "FECHA", "TIPO REGISTRO" };
		String[] columnas = { "ccostosOrigen", "sucursalOrigen",
				"ccostoDestino", "sucursaldestino", "montosTranfer", "fecha",
				"tipoRegistro" };

		String[] auditoria = { usuario, fecha, hora, "TRANSFERCTASBANREP" };

		String nombreHoja = "ReporteTransCtasBan";
		String claseBeanOriginal = "contabilidad.bean.RepPolizasIntersucBean";
		HSSFSheet excel = null;

		switch (tipoLista) {

		case Enum_Rep_PolIntersuc.transCtasBan:

			listaTransferCtasBan = reportePolizasIntersucDAO
					.listaTransCtasBan(repPolizasIntersucBean);
			try {

				excel = manejoArchivo.beansEnExcel(listaTransferCtasBan,
						Encabezados, titulos, columnas, auditoria, nombreHoja,
						claseBeanOriginal, 62000);

				// Creo la cabecera
				response.addHeader("Content-Disposition",
						"inline; filename=ReporteTransCtasBan.xls");
				response.setContentType("application/vnd.ms-excel");

				ServletOutputStream outputStream = response.getOutputStream();
				excel.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();

			} catch (Exception e) {
				e.printStackTrace();
			}
			break;
		}
		return listaTransferCtasBan;
	}

	// lista para reportes de polizas intersucursales
	public List listaReportesPolizasIntersuc(int tipoLista,
			RepPolizasIntersucBean repPolizasIntersucBean,
			HttpServletResponse response) throws Exception {

		List listaPolizasIntersucursales = null;
		int mes = 0;
		String nombreMes = "", ano = "1900";
		String cadenaFecha[] = repPolizasIntersucBean.getFechaEmision().split(
				"-");
		mes = Integer.parseInt(cadenaFecha[1]);
		ano = cadenaFecha[0];
		nombreMes = obtenerNombreMes(mes);
		String usuario = repPolizasIntersucBean.getClaveUsuario();
		String fecha = repPolizasIntersucBean.getFechaEmision();
		String hora = repPolizasIntersucBean.getHoraEmision();
		String fechaIni = repPolizasIntersucBean.getFechaInicial();
		String fechaFin = repPolizasIntersucBean.getFechaFinal();
		String nombreInstitucion = repPolizasIntersucBean.getNombreInstitucion();

		String[] Encabezados = {
				nombreInstitucion,
				"REPORTE DE POLIZAS INTERSUCURSALES",
				"DEL: " + fechaIni + "  AL  " + fechaFin };
		String[] titulos = { "SUCURSAL DE ABONO", "CENTRO COSTO DE ABONO",
				"SUCURSAL DEL CARGO", "CENTRO DE COSTO DEL CARGO", "CANTIDAD",
				"FECHA", "TIPO REGISTRO" };
		String[] columnas = { "sucursalOrigen", "ccostosOrigen",
				"sucursaldestino", "ccostoDestino", "cantidad", "fecha",
				"tipoRegistro" };

		String[] auditoria = { usuario, fecha, hora, "POLIZASINTERSUCREP" };

		String nombreHoja = "ReportePolizasIntersucursales";
		String claseBeanOriginal = "contabilidad.bean.RepPolizasIntersucBean";
		HSSFSheet excel = null;
		switch (tipoLista) {

		case Enum_Rep_PolIntersuc.polizasInter:

			listaPolizasIntersucursales = reportePolizasIntersucDAO
					.listaPolizasIntersucursales(repPolizasIntersucBean);
			try {

				excel = manejoArchivo.beansEnExcel(listaPolizasIntersucursales,
						Encabezados, titulos, columnas, auditoria, nombreHoja,
						claseBeanOriginal, 62000);

				// Creo la cabecera
				response.addHeader("Content-Disposition",
						"inline; filename=ReportePolizasIntersuc.xls");
				response.setContentType("application/vnd.ms-excel");

				ServletOutputStream outputStream = response.getOutputStream();
				excel.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();

			} catch (Exception e) {
				e.printStackTrace();
			}
			break;
		}
		return listaPolizasIntersucursales;
	}

	// lista para reportes de Facturas proveedores
	public List listaReportesFacturasProv(int tipoLista,
			RepPolizasIntersucBean repPolizasIntersucBean,
			HttpServletResponse response) throws Exception {

		List listaFacturasProv = null;
		int mes = 0;
		String nombreMes = "", ano = "1900";
		String cadenaFecha[] = repPolizasIntersucBean.getFechaEmision().split(
				"-");
		mes = Integer.parseInt(cadenaFecha[1]);
		ano = cadenaFecha[0];
		nombreMes = obtenerNombreMes(mes);
		String usuario = repPolizasIntersucBean.getClaveUsuario();
		String fecha = repPolizasIntersucBean.getFechaEmision();
		String hora = repPolizasIntersucBean.getHoraEmision();
		String fechaIni = repPolizasIntersucBean.getFechaInicial();
		String fechaFin = repPolizasIntersucBean.getFechaFinal();
		String nombreInstitucion = repPolizasIntersucBean.getNombreInstitucion();
		String[] Encabezados = {
				nombreInstitucion,
				"REPORTE DE FACTURAS DE PROVEEDORES",
				"DEL: " + fechaIni + "  AL  " + fechaFin };
		String[] titulos = { "CENTRO COSTO CXP", "CENTRO COSTO ORIGEN",
				"SUCURSAL DEL GASTO", "CENTRO DE COSTO DEL GASTO",
				"MONTO PAGADO", "FECHA", "TIPO REGISTRO" };
		String[] columnas = { "ccostoscxp", "ccostosOrigen", "sucursalGasto",
				"ccostoGasto", "montoPagado", "fecha", "tipoRegistro" };

		String[] auditoria = { usuario, fecha, hora, "FACTURASPROVREP" };

		String nombreHoja = "ReporteFacturasProv";
		String claseBeanOriginal = "contabilidad.bean.RepPolizasIntersucBean";
		HSSFSheet excel = null;
		switch (tipoLista) {

		case Enum_Rep_PolIntersuc.facturasProv:

			listaFacturasProv = reportePolizasIntersucDAO
					.listaFacturaProveedores(repPolizasIntersucBean);
			try {

				excel = manejoArchivo.beansEnExcel(listaFacturasProv,
						Encabezados, titulos, columnas, auditoria, nombreHoja,
						claseBeanOriginal, 62000);

				// Creo la cabecera
				response.addHeader("Content-Disposition",
						"inline; filename=ReporteFacturasProv.xls");
				response.setContentType("application/vnd.ms-excel");

				ServletOutputStream outputStream = response.getOutputStream();
				excel.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();

			} catch (Exception e) {
				e.printStackTrace();
			}
			break;
		}
		return listaFacturasProv;
	}

	// lista para reportes Gastos por comprobar y anticipos de sueldos
	public List listaReportesGastosAnticipos(int tipoLista,
			RepPolizasIntersucBean repPolizasIntersucBean,
			HttpServletResponse response) throws Exception {

		List listaGastosAnticipos = null;
		int mes = 0;
		String nombreMes = "", ano = "1900";
		String cadenaFecha[] = repPolizasIntersucBean.getFechaEmision().split(
				"-");
		mes = Integer.parseInt(cadenaFecha[1]);
		ano = cadenaFecha[0];
		nombreMes = obtenerNombreMes(mes);
		String usuario = repPolizasIntersucBean.getClaveUsuario();
		String fecha = repPolizasIntersucBean.getFechaEmision();
		String hora = repPolizasIntersucBean.getHoraEmision();
		String fechaIni = repPolizasIntersucBean.getFechaInicial();
		String fechaFin = repPolizasIntersucBean.getFechaFinal();
		String nombreInstitucion = repPolizasIntersucBean.getNombreInstitucion();

		String[] Encabezados = {
				nombreInstitucion,
				"REPORTE DE GASTOS POR COMPROBAR, ANTICIPO DE SUELDOS",
				"DEL: " + fechaIni + "  AL  " + fechaFin };
		String[] titulos = { "SUCURSAL OPERACION", "CENTRO COSTO OPERACION",
				"MOVIMIENTOS DE EMPLEADO DE SUC", "CENTRO DE COSTO EMPLEADO",
				"MONTOS RETIROS (SALIDA)", "MONTOS DEPOSITO (ENTRADA)", "FECHA", "TIPO REGISTRO" };
		String[] columnas = { "sucOperacion", "ccostoOperacion",
				"movEmpleadosOperacion", "ccostoEmpleado", "salida", "entrada",
				"fecha", "tipoRegistro" };

		String[] auditoria = { usuario, fecha, hora, "GASTOSANTICIPOSREP" };

		String nombreHoja = "ReporteGastosAnticipos";
		String claseBeanOriginal = "contabilidad.bean.RepPolizasIntersucBean";
		HSSFSheet excel = null;
		switch (tipoLista) {

		case Enum_Rep_PolIntersuc.gastospoComp:

			listaGastosAnticipos = reportePolizasIntersucDAO
					.listaGastosAnticipos(repPolizasIntersucBean);
			try {

				excel = manejoArchivo.beansEnExcel(listaGastosAnticipos,
						Encabezados, titulos, columnas, auditoria, nombreHoja,
						claseBeanOriginal, 62000);

				// Creo la cabecera
				response.addHeader("Content-Disposition",
						"inline; filename=ReporteGastosAnticipos.xls");
				response.setContentType("application/vnd.ms-excel");

				ServletOutputStream outputStream = response.getOutputStream();
				excel.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();

			} catch (Exception e) {
				e.printStackTrace();
			}
			break;
		}
		return listaGastosAnticipos;
	}
	
	// lista para reportes Operaciones en ventanilla Socios
		public List listaReportesOperacionesVenSocios(int tipoLista,
				RepPolizasIntersucBean repPolizasIntersucBean,
				HttpServletResponse response) throws Exception {

			List listaOperacionesVen = null;
			int mes = 0;
			String nombreMes = "", ano = "1900";
			String cadenaFecha[] = repPolizasIntersucBean.getFechaEmision().split(
					"-");
			mes = Integer.parseInt(cadenaFecha[1]);
			ano = cadenaFecha[0];
			nombreMes = obtenerNombreMes(mes);
			String usuario = repPolizasIntersucBean.getClaveUsuario();
			String fecha = repPolizasIntersucBean.getFechaEmision();
			String hora = repPolizasIntersucBean.getHoraEmision();
			String fechaIni = repPolizasIntersucBean.getFechaInicial();
			String fechaFin = repPolizasIntersucBean.getFechaFinal();
			String nombreInstitucion = repPolizasIntersucBean.getNombreInstitucion();

			String[] Encabezados = {
					nombreInstitucion,
					"REPORTE DE OPERACIONES EN VENTANILLA SOCIO",
					"DEL: " + fechaIni + "  AL  " + fechaFin };
			String[] titulos = { "SUCURSAL OPERACION", "CENTRO COSTO OPERACION",
					"MOVIMIENTO DE SOCIO DE SUC", "CENTRO DE COSTO SOCIO",
					"MONTOS RETIROS (SALIDA)", "MONTOS DEPOSITO (ENTRADA)", "FECHA", "TIPO REGISTRO" };
			String[] columnas = { "sucOperacion", "ccostoOperacion",
					"movimientosSocio", "ccostosocio",
					"salida", "entrada","fecha", "tipoRegistro" };
		
	
			String[] auditoria = { usuario, fecha, hora, "OPEVENTANILLACLIREP" };

			String nombreHoja = "ReporteOperacionesVentanilla";
			String claseBeanOriginal = "contabilidad.bean.RepPolizasIntersucBean";
			HSSFSheet excel = null;
			switch (tipoLista) {

			case Enum_Rep_PolIntersuc.operacionesVen:

				listaOperacionesVen = reportePolizasIntersucDAO
						.listaOperacionesVentanilla(repPolizasIntersucBean);
				try {

					excel = manejoArchivo.beansEnExcel(listaOperacionesVen,
							Encabezados, titulos, columnas, auditoria, nombreHoja,
							claseBeanOriginal, 62000);

					// Creo la cabecera
					response.addHeader("Content-Disposition",
							"inline; filename=ReporteOperacionesVen.xls");
					response.setContentType("application/vnd.ms-excel");

					ServletOutputStream outputStream = response.getOutputStream();
					excel.getWorkbook().write(outputStream);
					outputStream.flush();
					outputStream.close();

				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			}
			return listaOperacionesVen;
		}

	public String obtenerNombreMes(int mes) {
		String nombreMes = "";
		switch (mes) {
		case 1:
			nombreMes = "ENERO";
			break;
		case 2:
			nombreMes = "FEBRERO";
			break;
		case 3:
			nombreMes = "MARZO";
			break;
		case 4:
			nombreMes = "ABRIL";
			break;
		case 5:
			nombreMes = "MAYO";
			break;
		case 6:
			nombreMes = "JUNIO";
			break;
		case 7:
			nombreMes = "JULIO";
			break;
		case 8:
			nombreMes = "AGOSTO";
			break;
		case 9:
			nombreMes = "SEPTIEMBRE";
			break;
		case 10:
			nombreMes = "OCTUBRE";
			break;
		case 11:
			nombreMes = "NOVIEMBRE";
			break;
		case 12:
			nombreMes = "DICIEMBRE";
			break;
		}
		return nombreMes;
	}

	public RepPolizasIntersucDAO getReportePolizasIntersucDAO() {
		return reportePolizasIntersucDAO;
	}

	public void setReportePolizasIntersucDAO(
			RepPolizasIntersucDAO reportePolizasIntersucDAO) {
		this.reportePolizasIntersucDAO = reportePolizasIntersucDAO;
	}

	public Archivos getManejoArchivo() {
		return manejoArchivo;
	}

	public void setManejoArchivo(Archivos manejoArchivo) {
		this.manejoArchivo = manejoArchivo;
	}
}
