package contabilidad.servicio;

import general.servicio.BaseServicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import contabilidad.bean.RegulatoriosContabilidadBean;
import contabilidad.dao.RegulatoriosContabilidadDAO;


public class RegulatoriosContabilidadServicio  extends BaseServicio{
	RegulatoriosContabilidadDAO regulatoriosContabilidadDAO = null;	
	
    String[] meses = {"","ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"};
	
	public RegulatoriosContabilidadServicio() {
		super();
	}

	
	/* ================== Tipo de Lista para reportes regulatorios ============== */
	public static interface Enum_Lis_ReportesA2011{
		int excel	 = 1;
		int csv		 = 2;
	}	
	public static interface Enum_Lis_ReportesA2011Ver2015{
		int excel	 = 1;
		int csv		 = 2;
	}
	public static interface Enum_Lis_ReportesB2021{
		int excel	 = 1;
		int csv		 = 2;
	}
	public static interface Enum_Lis_ReportesA2111{
		int excel	 = 1;
		int csv		 = 2;
	}	
	public static interface Enum_Lis_ReportesA3011{
		int excel	 = 1;
		int csv		 = 2;
	}
	public static interface Enum_Lis_ReportesA2112{
		int excel	 = 1;
		int csv		 = 2;
	}

	
	/* ============ case para listas de reportes regulatorios ===============*/
	public List <RegulatoriosContabilidadBean>listaReporteRegulatorioA2011(int tipoLista, RegulatoriosContabilidadBean reporteBean, HttpServletResponse response, int version){
		List<RegulatoriosContabilidadBean> listaReportes=null;
		switch(tipoLista){
			case Enum_Lis_ReportesA2011.excel:
				listaReportes = regulatoriosContabilidadDAO.reporteRegulatorioA2011(reporteBean, Enum_Lis_ReportesA2011.excel, version); 
				break;
			case Enum_Lis_ReportesA2011.csv:
				listaReportes = generarReporteRegulatorioA2011(reporteBean, Enum_Lis_ReportesA2011.csv,  response, version); 
				break;		
		}
		return listaReportes;
	}
	
	/**
	 * Generacion del reporte A 2011 Coeficiente Liquidez
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @param version
	 * @return
	 */
	public List <RegulatoriosContabilidadBean>listaReporteRegulatorioA2011Version2015(int tipoLista, RegulatoriosContabilidadBean reporteBean, HttpServletResponse response, int version){
		List<RegulatoriosContabilidadBean> listaReportes=null;
		switch(tipoLista){
			case Enum_Lis_ReportesA2011Ver2015.excel:
				listaReportes = regulatoriosContabilidadDAO.reporteRegulatorioA2011Version2015(reporteBean, Enum_Lis_ReportesA2011.excel, version); 
				break;
			case Enum_Lis_ReportesA2011Ver2015.csv:
				listaReportes = generarReporteRegulatorioA2011Ver2015(reporteBean, Enum_Lis_ReportesA2011.csv,  response, version); 
				break;		
		}
		return listaReportes;
	}
	
	public List <RegulatoriosContabilidadBean>listaReporteRegulatorioB2021(int tipoLista, RegulatoriosContabilidadBean reporteBean, HttpServletResponse response){
		List<RegulatoriosContabilidadBean> listaReportes=null;
		switch(tipoLista){
			case Enum_Lis_ReportesB2021.excel:
				listaReportes = regulatoriosContabilidadDAO.reporteRegulatorioB2021(reporteBean, Enum_Lis_ReportesB2021.excel); 
				break;
			case Enum_Lis_ReportesB2021.csv:
				listaReportes = generarReporteRegulatorioB2021(reporteBean, Enum_Lis_ReportesB2021.csv,  response);	
				break;		
		}
		return listaReportes;
	}
	
	public List <RegulatoriosContabilidadBean>listaReporteRegulatorioA2111(int tipoLista, RegulatoriosContabilidadBean reporteBean, HttpServletResponse response){
		List<RegulatoriosContabilidadBean> listaReportes=null;
		switch(tipoLista){
			case Enum_Lis_ReportesA2111.excel:
				listaReportes = regulatoriosContabilidadDAO.reporteRegulatorioA2111(reporteBean,  Enum_Lis_ReportesA2111.excel); 
				break;
			case Enum_Lis_ReportesA2111.csv:
				listaReportes = generarReporteRegulatorioA2111(reporteBean, Enum_Lis_ReportesA2111.csv,  response);				
				break;		
		}
		return listaReportes;
	}
	
	public List <RegulatoriosContabilidadBean>listaReporteRegulatorioA3011(int tipoLista, RegulatoriosContabilidadBean reporteBean, HttpServletResponse response){
		List<RegulatoriosContabilidadBean> listaReportes=null;
		switch(tipoLista){
			case Enum_Lis_ReportesA3011.excel:
				listaReportes = regulatoriosContabilidadDAO.reporteRegulatorioA3011(reporteBean, Enum_Lis_ReportesA3011.excel); 
				break;
			case Enum_Lis_ReportesA3011.csv:
				listaReportes = generarReporteRegulatorioA3011(reporteBean, Enum_Lis_ReportesA3011.csv,  response);		
				break;		
		}
		return listaReportes;
	}
	
	/**
	 * Consulta de reporte A2112
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List <RegulatoriosContabilidadBean>listaReporteRegulatorioA2112(int tipoLista, RegulatoriosContabilidadBean reporteBean, HttpServletResponse response){
		List<RegulatoriosContabilidadBean> listaReportes=null;
		switch(tipoLista){
			case Enum_Lis_ReportesA2112.excel:
				listaReportes = regulatoriosContabilidadDAO.reporteRegulatorioA2112(reporteBean, Enum_Lis_ReportesA3011.excel); 
				break;
			case Enum_Lis_ReportesA2112.csv:
				listaReportes = generarReporteRegulatorioA2112(reporteBean, Enum_Lis_ReportesA3011.csv,  response);		
				break;		
		}
		return listaReportes;
	}
	

	/* ======================================  FUNCIONES PARA GENERAR REPORTES CSV  ========================================*/	
	
	private List generarReporteRegulatorioA2011(RegulatoriosContabilidadBean reporteBean,int tipoReporte,HttpServletResponse response, int version){
		String nombreArchivo="";
		List listaBeans = regulatoriosContabilidadDAO.reporteRegulatorioA2011Csv(reporteBean, tipoReporte, version);
		nombreArchivo="A_2011_Coeficiente_Liquidez.csv"; 
		// se inicia seccion para pintar el archivo csv
		try{
			RegulatoriosContabilidadBean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatoriosContabilidadBean) listaBeans.get(i);
					writer.write(bean.getValor());        
					writer.write("\r\n"); // Esto es un salto de linea	
				}
			}else{
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();
			
		}catch(IOException io ){	
			io.printStackTrace();
		}
		
		return listaBeans;
	}
	
	/**
	 * Genera reporte regulatorio A 2011 Coeficiente Liquidez version 2015 formato CSV
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @param version
	 * @return
	 */
	private List generarReporteRegulatorioA2011Ver2015(RegulatoriosContabilidadBean reporteBean, int tipoReporte,HttpServletResponse response, int version) {
		String nombreArchivo = "";
		List listaBeans = regulatoriosContabilidadDAO.reporteRegulatorioA2011CsvVersion2015(reporteBean,tipoReporte, version);

		nombreArchivo = "A_2011_Coeficiente_Liquidez.csv";

		// se inicia seccion para pintar el archivo csv
		try {
			RegulatoriosContabilidadBean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(
					nombreArchivo));
			if (!listaBeans.isEmpty()) {
				for (int i = 0; i < listaBeans.size(); i++) {
					bean = (RegulatoriosContabilidadBean) listaBeans.get(i);
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
	
	private List generarReporteRegulatorioA2111(RegulatoriosContabilidadBean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatoriosContabilidadDAO.reporteRegulatorioA2111Csv(reporteBean, tipoReporte);
		nombreArchivo="R20 A 2111 " + meses[Integer.parseInt(reporteBean.getMes())] + " "+reporteBean.getAnio() + ".csv";
		// se inicia seccion para pintar el archivo csv
		try{
			RegulatoriosContabilidadBean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatoriosContabilidadBean) listaBeans.get(i);
					writer.write(bean.getValor());        
					writer.write("\r\n"); // Esto es un salto de linea		
				}
			}else{
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();
			
		}catch(IOException io ){	
			io.printStackTrace();
		}
		
		return listaBeans;
	}
	
	
	private List generarReporteRegulatorioA3011(RegulatoriosContabilidadBean reporteBean,int tipoReporte,HttpServletResponse response){
		
		String nombreArchivo="";
		List listaBeans = regulatoriosContabilidadDAO.reporteRegulatorioA3011Csv(reporteBean, tipoReporte);
		nombreArchivo="R20 A 3011 " + meses[Integer.parseInt(reporteBean.getMes())] + " "+reporteBean.getAnio() + ".csv";
		// se inicia seccion para pintar el archivo csv
		try{
			RegulatoriosContabilidadBean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatoriosContabilidadBean) listaBeans.get(i);
					writer.write(bean.getValor());        
					writer.write("\r\n"); // Esto es un salto de linea	
				}
			}else{
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();
			
		}catch(IOException io ){	
			io.printStackTrace();
		}
		
		return listaBeans;
	}
	
	
	
	private List generarReporteRegulatorioB2021(RegulatoriosContabilidadBean reporteBean,int tipoReporte,HttpServletResponse response){
		
		String nombreArchivo="";
		List listaBeans = regulatoriosContabilidadDAO.reporteRegulatorioB2021Csv(reporteBean, tipoReporte);
		
		nombreArchivo="R20 B 2021 " + meses[Integer.parseInt(reporteBean.getMes())] + " "+reporteBean.getAnio() + ".csv";

		// se inicia seccion para pintar el archivo csv
		try{
			RegulatoriosContabilidadBean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatoriosContabilidadBean) listaBeans.get(i);
					writer.write(bean.getValor());        
					writer.write("\r\n"); // Esto es un salto de linea	
				}
			}else{
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();
			
		}catch(IOException io ){	
			io.printStackTrace();
		}
		
		return listaBeans;
	}
	
	/**
	 * Genera reporte regulatorio A2112 version CSV
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generarReporteRegulatorioA2112(RegulatoriosContabilidadBean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatoriosContabilidadDAO.reporteRegulatorioA2112Csv(reporteBean, tipoReporte);
		nombreArchivo="A_2112_Desagregado_de_req_de_Cap_por_riesgo.csv";
		
		try{
			RegulatoriosContabilidadBean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatoriosContabilidadBean) listaBeans.get(i);
					writer.write(bean.getValor());        
					writer.write("\r\n");	
				}
			}else{
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();
			
		}catch(IOException io ){	
			io.printStackTrace();
		}
		return listaBeans;
	}
	
	public String descripcionMes(String meses){
		String mes = "";
		int mese = Integer.parseInt(meses);
        switch (mese) {
            case 1:  mes ="ENERO" ; break;
            case 2:  mes ="FEBRERO"; break;
            case 3:  mes ="MARZO"; break;
            case 4:  mes ="ABRIL"; break;
            case 5:  mes ="MAYO"; break;
            case 6:  mes ="JUNIO"; break;
            case 7:  mes ="JULIO"; break;
            case 8:  mes ="AGOSTO"; break;
            case 9:  mes ="SEPTIEMBRE"; break;
            case 10: mes ="OCTUBRE"; break;
            case 11: mes ="NOVIEMBRE"; break;
            case 12: mes ="DICIEMBRE"; break;
        }
        return mes;
	}
	

	/* ========================= GET  &&  SET  =========================*/
	public RegulatoriosContabilidadDAO getRegulatoriosContabilidadDAO() {
		return regulatoriosContabilidadDAO;
	}

	public void setRegulatoriosContabilidadDAO(
			RegulatoriosContabilidadDAO regulatoriosContabilidadDAO) {
		this.regulatoriosContabilidadDAO = regulatoriosContabilidadDAO;
	}	
		
}
