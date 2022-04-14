package credito.servicio;

import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import regulatorios.bean.CalificacionYEstimacionB0417Bean;
import regulatorios.bean.EstimacionPreventivaA419Bean;
import regulatorios.bean.DesagregadoCarteraC0451Bean;
import credito.dao.RegulatoriosCarteraDAO;

public class ReportesRegulatoriosServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	ParametrosSesionBean parametrosSesionBean;
	RegulatoriosCarteraDAO regulatoriosCarteraDAO = null;

	//-------------------------------------------------------------------------------------------------
	// -------------------- TRANSACCIONES (CONSULTAS, LISTADOS, REPORTES)
	//-------------------------------------------------------------------------------------------------	
	
	public static interface Enum_Reporte_Desagregado{
		int desagregadoExcel = 1;
		int desagregadoCsv = 2;
	}
	
	public static interface Enum_Reporte_CalificaEstima{
		int calificaEstimaExcel = 1;
		int calificaEstimaCsv = 2;
	}
	
	public static interface Enum_Reporte_EstPrevA419{
		int estPrevA419Excel = 1;
		int estPrevA419Csv = 2;
	}

	/**
	 * Regulatorio de Calificacion de Cartera y Estimaciones Preventivas B0417 
	 * @param tipoLista
	 * @param b0417Bean
	 * @param response
	 * @return
	 */
	public List<CalificacionYEstimacionB0417Bean> consultaRegulatorioB0417(int tipoLista, CalificacionYEstimacionB0417Bean b0417Bean,HttpServletResponse response) {
		List<CalificacionYEstimacionB0417Bean> listaRegulatorio = null;
		switch (tipoLista) {
			case Enum_Reporte_CalificaEstima.calificaEstimaExcel :
				listaRegulatorio = regulatoriosCarteraDAO
						.consultaRegulatorioB0417(b0417Bean, tipoLista);
				break;
			case Enum_Reporte_CalificaEstima.calificaEstimaCsv :
				listaRegulatorio = generaRegulatorioCalifEstimaCSV(b0417Bean,
						tipoLista, response);
				break;
		}
		return listaRegulatorio;
	}
	
	/**
	 * Regulatorio de Calificacion de Cartera y Estimaciones Preventivas B0417 Consultas para generacion
	 * de reportes version 2015
	 * @param tipoLista
	 * @param b0417Bean
	 * @param response
	 * @return
	 */
	public List<CalificacionYEstimacionB0417Bean> consultaRegulatorioB0417Version2015(int tipoLista, CalificacionYEstimacionB0417Bean b0417Bean,HttpServletResponse response) {
		List<CalificacionYEstimacionB0417Bean> listaRegulatorio = null;
		switch (tipoLista) {
			case Enum_Reporte_CalificaEstima.calificaEstimaExcel :
				listaRegulatorio = regulatoriosCarteraDAO
						.consultaRegulatorioB0417Version2015(b0417Bean, tipoLista);
				break;
			case Enum_Reporte_CalificaEstima.calificaEstimaCsv :
				listaRegulatorio = generaRegulatorioCalifEstimaCSVVersion2015(b0417Bean,
						tipoLista, response);
				break;
		}
		return listaRegulatorio;
	}
	
	/**
	 * Regulatorio de Desagregado de Cartera C0451 
	 * @param tipoLista
	 * @param c0451Bean
	 * @param response
	 * @return
	 */
	public List<DesagregadoCarteraC0451Bean> consultaRegulatorioC0451(int tipoLista, DesagregadoCarteraC0451Bean c0451Bean,HttpServletResponse response) {
		List<DesagregadoCarteraC0451Bean> listaRegulatorio = null;
		switch (tipoLista) {
			case Enum_Reporte_Desagregado.desagregadoExcel :
				listaRegulatorio = regulatoriosCarteraDAO
						.consultaRegulatorioC0451(c0451Bean, tipoLista);
				break;
			case Enum_Reporte_Desagregado.desagregadoCsv :
				listaRegulatorio = generaReporteDesagregadoCSV(c0451Bean,
						tipoLista, response);
				break;
		}
		return listaRegulatorio;
	}
	
	/**
	 * Regulatorio de Desagregado de Cartera C0451 consultas para generacion de reportes version 2015
	 * @param tipoLista
	 * @param c0451Bean
	 * @param response
	 * @return
	 */
	public List<DesagregadoCarteraC0451Bean> consultaRegulatorioC0451Version2015(int tipoLista, DesagregadoCarteraC0451Bean c0451Bean,HttpServletResponse response) {
		List<DesagregadoCarteraC0451Bean> listaRegulatorio = null;
		switch (tipoLista) {
			case Enum_Reporte_Desagregado.desagregadoExcel :
				listaRegulatorio = regulatoriosCarteraDAO.consultaRegulatorioC0451Ver2015(c0451Bean, tipoLista);
				break;
			case Enum_Reporte_Desagregado.desagregadoCsv :
				listaRegulatorio = generaReporteDesagregadoCSVVersion2015(c0451Bean,tipoLista, response);
				break;
		}
		return listaRegulatorio;
	}
			
	/**
	 * Reporte de Desagregado de Cartera C0451 en CSV 
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generaReporteDesagregadoCSV(DesagregadoCarteraC0451Bean reporteBean, int tipoReporte,HttpServletResponse response) {
		String mesEnLetras = "";
		String anio = "";
		String nombreArchivo = "";
		List listaBeans = regulatoriosCarteraDAO.reporteRegulatorio0451Csv(
				reporteBean, tipoReporte);

		mesEnLetras = descripcionMes(reporteBean.getFecha().substring(5, 7));
		anio = reporteBean.getFecha().substring(0, 4);

		nombreArchivo = "R04_C_451_" + mesEnLetras + "_" + anio + ".csv";

		// se inicia seccion para pintar el archivo csv
		try {
			DesagregadoCarteraC0451Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(
					nombreArchivo));
			if (!listaBeans.isEmpty()) {
				for (int i = 0; i < listaBeans.size(); i++) {
					bean = (DesagregadoCarteraC0451Bean) listaBeans.get(i);
					writer.write(bean.getValor() != null ? bean.getValor() : "");
					writer.write("\r\n"); // Esto es un salto de linea
				}
			} else {
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition", "attachment;filename="
					+ nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();

		} catch (IOException io) {
			io.printStackTrace();
		}
		return listaBeans;
	}

	/**
	 * Generacion de archivo CSV para reporte C0451
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generaReporteDesagregadoCSVVersion2015(DesagregadoCarteraC0451Bean reporteBean, int tipoReporte,HttpServletResponse response) {
		try {
			String mesEnLetras = "";
			String anio = "";
			String nombreArchivo = "";
			List listaBeans = regulatoriosCarteraDAO
					.reporteRegulatorio0451Version2015Csv(reporteBean,
							tipoReporte);

			mesEnLetras = descripcionMes(reporteBean.getFecha().substring(5, 7));
			anio = reporteBean.getFecha().substring(0, 4);

			nombreArchivo = "R04_C_451_" + mesEnLetras + "_" + anio + ".csv";

			// se inicia seccion para pintar el archivo csv
			try {
				DesagregadoCarteraC0451Bean bean;
				BufferedWriter writer = new BufferedWriter(new FileWriter(
						nombreArchivo));
				if (!listaBeans.isEmpty()) {
					for (int i = 0; i < listaBeans.size(); i++) {
						bean = (DesagregadoCarteraC0451Bean) listaBeans.get(i);
						writer.write(bean.getValor() != null
								? bean.getValor()
								: "");
						writer.write("\r\n"); // Esto es un salto de linea
					}
				} else {
					writer.write("");
				}
				writer.close();

				FileInputStream archivo = new FileInputStream(nombreArchivo);
				int longitud = archivo.available();
				byte[] datos = new byte[longitud];
				archivo.read(datos);
				archivo.close();

				response.setHeader("Content-Disposition",
						"attachment;filename=" + nombreArchivo);
				response.setContentType("application/text");
				ServletOutputStream outputStream = response.getOutputStream();
				outputStream.write(datos);
				outputStream.flush();
				outputStream.close();

			} catch (IOException io) {
				io.printStackTrace();
			}
			return listaBeans;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	/**
	 * Reporte de Regulatorio de Calificacion de Cartera y Estimaciones Preventivas B0417 en CSV 
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generaRegulatorioCalifEstimaCSV(CalificacionYEstimacionB0417Bean reporteBean, int tipoReporte,HttpServletResponse response) {
		String mesEnLetras = "";
		String anio = "";
		String nombreArchivo = "";
		List listaBeans = regulatoriosCarteraDAO.reporteRegulatorio0417Csv(
				reporteBean, tipoReporte);

		mesEnLetras = descripcionMes(reporteBean.getFecha().substring(5, 7));
		anio = reporteBean.getFecha().substring(0, 4);
		nombreArchivo = "R04_B_0417_" + mesEnLetras + "_" + anio + ".csv";

		// se inicia seccion para pintar el archivo csv
		try {
			CalificacionYEstimacionB0417Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(
					nombreArchivo));
			if (!listaBeans.isEmpty()) {
				for (int i = 0; i < listaBeans.size(); i++) {
					bean = (CalificacionYEstimacionB0417Bean) listaBeans.get(i);
					writer.write(bean.getValor());
					writer.write("\r\n"); // Esto es un salto de linea
				}
			} else {
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition", "attachment;filename="
					+ nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();

		} catch (IOException io) {
			io.printStackTrace();
		}
		return listaBeans;
	}
	
	/**
	 * Reporte de Regulatorio de Calificacion de Cartera y Estimaciones Preventivas B0417 en formato cvs
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generaRegulatorioCalifEstimaCSVVersion2015(CalificacionYEstimacionB0417Bean reporteBean, int tipoReporte,HttpServletResponse response) {
		String mesEnLetras = "";
		String anio = "";
		String  nombreArchivo = "";
		List listaBeans = regulatoriosCarteraDAO.reporteRegulatorio0417CSVVersion2015(reporteBean, tipoReporte);

		mesEnLetras = descripcionMes(reporteBean.getFecha().substring(5, 7));
		anio = reporteBean.getFecha().substring(0, 4);
		nombreArchivo = "R04_B_0417_" + mesEnLetras + "_" + anio + ".csv";

		try {
			CalificacionYEstimacionB0417Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(
					nombreArchivo));
			if (!listaBeans.isEmpty()) {
				for (int i = 0; i < listaBeans.size(); i++) {
					bean = (CalificacionYEstimacionB0417Bean) listaBeans.get(i);
					writer.write(bean.getValor());
					writer.write("\r\n"); // Esto es un salto de linea
				}
			} else {
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition", "attachment;filename="
					+ nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();

		} catch (Exception io) {
			io.printStackTrace();
		}
		return listaBeans;
	}
	
	/**
	 * Regulatorio de Estimación Preventiva A-419 
	 * @param tipoLista
	 * @param b0419Bean
	 * @param response
	 * @return
	 */
	public List<EstimacionPreventivaA419Bean> consultaRegulatorioA0419(int tipoLista, EstimacionPreventivaA419Bean a0419Bean,HttpServletResponse response) {
		List<EstimacionPreventivaA419Bean> listaRegulatorio = null;
		switch (tipoLista) {
			case Enum_Reporte_EstPrevA419.estPrevA419Excel :
				listaRegulatorio = regulatoriosCarteraDAO
						.consultaRegulatorioA0419(a0419Bean, tipoLista);
				break;
			case Enum_Reporte_EstPrevA419.estPrevA419Csv :
				listaRegulatorio = generaRegulatorioEstPrevA419CSV(a0419Bean,
						tipoLista, response);
				break;
		}
		return listaRegulatorio;
	}
	
	
	/**
	 * Reporte de Regulatorio de Estimación Preventiva A-419  en formato cvs
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generaRegulatorioEstPrevA419CSV(EstimacionPreventivaA419Bean reporteBean, int tipoReporte,HttpServletResponse response) {
		String mesEnLetras = "";
		String anio = "";
		String  nombreArchivo = "";
		List listaBeans = regulatoriosCarteraDAO.reporteRegulatorio0419(reporteBean, tipoReporte);

		mesEnLetras = descripcionMes(reporteBean.getFecha().substring(5, 7));
		anio = reporteBean.getFecha().substring(0, 4);
		nombreArchivo = "R04_A_0419_" + mesEnLetras + "_" + anio + ".csv";

		try {
			EstimacionPreventivaA419Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(
					nombreArchivo));
			if (!listaBeans.isEmpty()) {
				for (int i = 0; i < listaBeans.size(); i++) {
					bean = (EstimacionPreventivaA419Bean) listaBeans.get(i);
					writer.write(bean.getValor());
					writer.write("\r\n"); // Esto es un salto de linea
				}
			} else {
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition", "attachment;filename="
					+ nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();

		} catch (Exception io) {
			io.printStackTrace();
		}
		return listaBeans;
	}
	
	
	
	public String descripcionMes(String meses) {
		String mes = "";
		int mese = Integer.parseInt(meses);
		switch (mese) {
			case 1 :
				mes = "ENERO";
				break;
			case 2 :
				mes = "FEBRERO";
				break;
			case 3 :
				mes = "MARZO";
				break;
			case 4 :
				mes = "ABRIL";
				break;
			case 5 :
				mes = "MAYO";
				break;
			case 6 :
				mes = "JUNIO";
				break;
			case 7 :
				mes = "JULIO";
				break;
			case 8 :
				mes = "AGOSTO";
				break;
			case 9 :
				mes = "SEPTIEMBRE";
				break;
			case 10 :
				mes = "OCTUBRE";
				break;
			case 11 :
				mes = "NOVIEMBRE";
				break;
			case 12 :
				mes = "DICIEMBRE";
				break;
		}
		return mes;
	}

	
	//-------------------------------------------------------------------------------------------------
	// -------------------- SETTERS Y GETTERS	-------------------------------------------------------
	//-------------------------------------------------------------------------------------------------
	
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	public RegulatoriosCarteraDAO getRegulatoriosCarteraDAO() {
		return regulatoriosCarteraDAO;
	}
	public void setRegulatoriosCarteraDAO(
			RegulatoriosCarteraDAO regulatoriosCarteraDAO) {
		this.regulatoriosCarteraDAO = regulatoriosCarteraDAO;
	}
	
}
