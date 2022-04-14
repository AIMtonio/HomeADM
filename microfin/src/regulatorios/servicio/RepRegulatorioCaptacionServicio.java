package regulatorios.servicio;

import general.servicio.BaseServicio;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import regulatorios.bean.DesagreCaptaD0841Bean;
import regulatorios.bean.RepCaptacionPorLocalidad821Bean;
import regulatorios.bean.RepCaptacionPorLocalidad821Bean;
import regulatorios.bean.RepRegulatorioCaptacion811Bean;
import regulatorios.bean.ReporteRegulatorioBean;
import regulatorios.dao.RepRegulatorioCaptacionDAO;

public class RepRegulatorioCaptacionServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	RepRegulatorioCaptacionDAO repRegulatorioCaptacionDAO = null;	
	 String[] meses = {"","ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"};
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_RepReg {
		int captacion811Excel = 1;
		int captacion811Csv = 2;
	}
	//---------- Tipo de Lista para reportes regulatorios----------------------------------------------------------------
	public static interface Enum_Lis_Reportes{
		int regulatorio0815Excel = 1;
		int regulatorio0815Csv = 2;
	}
	// List para reportes Regulatorios Captacion por Localidad
	public static interface Enum_Lis_RepRegulatorio {
		int B081RepEx = 1;
		int B0821RepEx2013 = 2;
		int B0821RepCsv = 3;
		int B0821RepCsv2014 =4;
	}
	//--------- Tipo de lista para reportes regulatorios Desagregado de Captacion D0841
	public static interface Enum_Lis_RepDesagreCapD0841{
		int Excel = 1;
		int CSV = 2;
	}
	
		
	public RepRegulatorioCaptacionServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	public static interface Enum_Reporte_Captacion{
		int captacion = 1;
	}
	
	/*case para listas de reportes regulatorios*/
	public List <RepRegulatorioCaptacion811Bean>listaReportesRegulatorios(int tipoLista, RepRegulatorioCaptacion811Bean reporteBean,
											HttpServletResponse response){
		List<RepRegulatorioCaptacion811Bean> listaReportes=null;
		switch(tipoLista){
			case Enum_Lis_RepReg.captacion811Excel:
				listaReportes = repRegulatorioCaptacionDAO.reporteCaptacion811(reporteBean,tipoLista); 
				break;
			case Enum_Lis_RepReg.captacion811Csv:
				listaReportes = generaRepRegulatorioCaptacionCSV(reporteBean,tipoLista,response); 
				break;
		}
		return listaReportes;
	}
	
	
	/* Case para la Lista de Reportes Regulatorio de Captacion por Localidad B0821 */
	public List <RepCaptacionPorLocalidad821Bean>listaReportesCaptacionPorLocalidad821(int tipoLista, RepCaptacionPorLocalidad821Bean reporteBean,
									HttpServletResponse response){
		List<RepCaptacionPorLocalidad821Bean> listaReportes=null;
		switch(tipoLista){
		case Enum_Lis_RepRegulatorio.B081RepEx:
			listaReportes = repRegulatorioCaptacionDAO.reporteCaptacionPorLocalidad821(reporteBean, tipoLista); 
			break;
		case Enum_Lis_RepRegulatorio.B0821RepEx2013:
			listaReportes = repRegulatorioCaptacionDAO.reporteCaptacionPorLocalidad8212013(reporteBean, tipoLista); 
			break;
		case Enum_Lis_RepRegulatorio.B0821RepCsv:
			listaReportes = generaReporteCaptacionCsv(reporteBean, tipoLista,response); 
			break;
		case Enum_Lis_RepRegulatorio.B0821RepCsv2014:
			listaReportes = generaReporteCaptacionCsv(reporteBean, tipoLista,response); 
			break;
		}
		 return listaReportes;
		}
	
	/* Case para la Lista de Reportes Regulatorio A0815*/
	public List <ReporteRegulatorioBean>listaReporteRegulatorio(int tipoLista, ReporteRegulatorioBean reporteBean, HttpServletResponse response){
		List<ReporteRegulatorioBean> listaReportes=null;
		switch(tipoLista){
			case Enum_Lis_Reportes.regulatorio0815Excel:
				listaReportes = repRegulatorioCaptacionDAO.reporteRegulatorio0815(reporteBean, tipoLista); 
				break;
			case Enum_Lis_Reportes.regulatorio0815Csv:
				listaReportes = generaReporteRegulatorioCSV(reporteBean,tipoLista,response); 
				break;
		}
		return listaReportes;
	}
	

	
	/* Reporte Regulatorio de Captacion por Localidad B0821 en CSV  */
	private List generaReporteCaptacionCsv(RepCaptacionPorLocalidad821Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String mesEnLetras	= "";
		String anio		= "";
		String rutaArchivo = "",nombreArchivo="";
		List listaBeans = repRegulatorioCaptacionDAO.reporteRegulatorioB0821Csv(reporteBean, tipoReporte);
		
		mesEnLetras = descripcionMes(reporteBean.getFecha().substring(5,7));
		anio = reporteBean.getFecha().substring(0,4);
		
		nombreArchivo="R08 B 821 " + mesEnLetras+ " "+anio + ".csv";
		
	
		File file = new File(nombreArchivo);
		// se inicia seccion para pintar el archivo csv
		try{
			RepCaptacionPorLocalidad821Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RepCaptacionPorLocalidad821Bean) listaBeans.get(i);
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
	
	/* Reporte Regulatorio A0815 en CSV  */
	private List generaReporteRegulatorioCSV(ReporteRegulatorioBean reporteBean,int tipoReporte,HttpServletResponse response){

		String rutaArchivo = "",nombreArchivo="";
		List listaBeans = repRegulatorioCaptacionDAO.reporteRegulatorio0815Csv(reporteBean, tipoReporte);
		
		nombreArchivo="R08 A 0815 " + meses[Integer.parseInt(reporteBean.getMes())] + " "+reporteBean.getAnio() + ".csv"; 
		
	
		File file = new File(nombreArchivo);
		// se inicia seccion para pintar el archivo csv
		try{
			ReporteRegulatorioBean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (ReporteRegulatorioBean) listaBeans.get(i);
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
	
	/* Reporte Regulatorio A0811 en CSV  */
	private List generaRepRegulatorioCaptacionCSV(RepRegulatorioCaptacion811Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String mesEnLetras	= "";
		String anio		= "";
		String rutaArchivo = "",nombreArchivo="";
		List listaBeans = repRegulatorioCaptacionDAO.reporteRegulatorio0811Csv(reporteBean, tipoReporte);
		
		mesEnLetras = descripcionMes(reporteBean.getFecha().substring(5,7));
		anio = reporteBean.getFecha().substring(0,4);
		
		nombreArchivo="R08_A_0811_" + mesEnLetras+ "_"+anio + ".csv";
	
		File file = new File(nombreArchivo);
		// se inicia seccion para pintar el archivo csv
		try{
			RepRegulatorioCaptacion811Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RepRegulatorioCaptacion811Bean) listaBeans.get(i);
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


	public RepRegulatorioCaptacionDAO getRepRegulatorioCaptacionDAO() {
		return repRegulatorioCaptacionDAO;
	}

	public void setRepRegulatorioCaptacionDAO(
			RepRegulatorioCaptacionDAO repRegulatorioCaptacionDAO) {
		this.repRegulatorioCaptacionDAO = repRegulatorioCaptacionDAO;
	}
}

