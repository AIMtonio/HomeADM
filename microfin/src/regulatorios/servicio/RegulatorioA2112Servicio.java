package regulatorios.servicio;

import general.servicio.BaseServicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import regulatorios.bean.RegulatorioA2112Bean;
import regulatorios.dao.RegulatorioA2112DAO;


public class RegulatorioA2112Servicio  extends BaseServicio{
	RegulatorioA2112DAO regulatorioA2112DAO = null;	
	
    String[] meses = {"","ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"};
	
	public RegulatorioA2112Servicio() {
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

	/**
	 * Consulta de reporte A2112
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List <RegulatorioA2112Bean>listaReporteRegulatorioA2112(int tipoLista, RegulatorioA2112Bean reporteBean, HttpServletResponse response){
		List<RegulatorioA2112Bean> listaReportes=null;
		switch(tipoLista){
			case Enum_Lis_ReportesA2112.excel:
				listaReportes = regulatorioA2112DAO.reporteRegulatorioA2112(reporteBean, Enum_Lis_ReportesA3011.excel); 
				break;
			case Enum_Lis_ReportesA2112.csv:
				listaReportes = generarReporteRegulatorioA2112(reporteBean, Enum_Lis_ReportesA3011.csv,  response);		
				break;		
		}
		return listaReportes;
	}
	

	/* ======================================  FUNCIONES PARA GENERAR REPORTES CSV  ========================================*/	
	/**
	 * Genera reporte regulatorio A2112 version CSV
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generarReporteRegulatorioA2112(RegulatorioA2112Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioA2112DAO.reporteRegulatorioA2112Csv(reporteBean, tipoReporte);
		nombreArchivo="A_2112_Desagregado_de_req_de_Cap_por_riesgo.csv";
		
		try{
			RegulatorioA2112Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioA2112Bean) listaBeans.get(i);
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
	public RegulatorioA2112DAO getRegulatorioA2112DAO() {
		return regulatorioA2112DAO;
	}


	public void setRegulatorioA2112DAO(RegulatorioA2112DAO regulatorioA2112DAO) {
		this.regulatorioA2112DAO = regulatorioA2112DAO;
	}


	public String[] getMeses() {
		return meses;
	}


	public void setMeses(String[] meses) {
		this.meses = meses;
	}
	

	
	
		
}
