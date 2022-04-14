package regulatorios.servicio;

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
import regulatorios.bean.DesagregadoCarteraC0451Bean;
import regulatorios.dao.DesagregadoCarteraC0451DAO;

public class DesagregadoCarteraC0451Servicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	ParametrosSesionBean parametrosSesionBean;
	DesagregadoCarteraC0451DAO desagregadoCarteraC0451DAO = null;

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
				listaRegulatorio = desagregadoCarteraC0451DAO
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
				listaRegulatorio = desagregadoCarteraC0451DAO.consultaRegulatorioC0451Ver2015(c0451Bean, tipoLista);
				break;
			case Enum_Reporte_Desagregado.desagregadoCsv :
				listaRegulatorio = generaReporteDesagregadoCSVVersion2015(c0451Bean,tipoLista, response);
				break;
		}
		return listaRegulatorio;
	}
			
	/**
	 * Regulatorio de Desagregado de Cartera C0451 consultas para generacion de reportes version 2017 - SOFIPOS
	 * @param tipoLista
	 * @param c0451Bean
	 * @param response
	 * @return
	 */
	public List<DesagregadoCarteraC0451Bean> consultaRegulatorioC0451VersionSOFIPO(int tipoLista, DesagregadoCarteraC0451Bean c0451Bean,HttpServletResponse response) {
		List<DesagregadoCarteraC0451Bean> listaRegulatorio = null;
		switch (tipoLista) {
			case Enum_Reporte_Desagregado.desagregadoExcel :
				System.out.println("Reporte 1");
				listaRegulatorio = desagregadoCarteraC0451DAO.consultaRegulatorioC0451Sofipo(c0451Bean, tipoLista);
				break;
			case Enum_Reporte_Desagregado.desagregadoCsv :
				listaRegulatorio = generaReporteDesagregadoCSVSofipo(c0451Bean,tipoLista, response);
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
		List listaBeans = desagregadoCarteraC0451DAO.reporteRegulatorio0451Csv(
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
			List listaBeans = desagregadoCarteraC0451DAO
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
	 * Generacion de archivo CSV para reporte C0451
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generaReporteDesagregadoCSVSofipo(DesagregadoCarteraC0451Bean reporteBean, int tipoReporte,HttpServletResponse response) {
		try {
			String mesEnLetras = "";
			String anio = "";
			String nombreArchivo = "";
			List listaBeans = desagregadoCarteraC0451DAO
					.reporteRegulatorio0451SofipoCsv(reporteBean,
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

	public DesagregadoCarteraC0451DAO getDesagregadoCarteraC0451DAO() {
		return desagregadoCarteraC0451DAO;
	}

	public void setDesagregadoCarteraC0451DAO(
			DesagregadoCarteraC0451DAO desagregadoCarteraC0451DAO) {
		this.desagregadoCarteraC0451DAO = desagregadoCarteraC0451DAO;
	}
	
	
}
