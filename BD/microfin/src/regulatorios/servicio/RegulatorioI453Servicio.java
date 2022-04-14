package regulatorios.servicio;

import general.servicio.BaseServicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import regulatorios.bean.RegulatorioI453Bean;
import regulatorios.dao.RegulatorioI453DAO;

public class RegulatorioI453Servicio  extends BaseServicio{
	RegulatorioI453DAO regulatorioI453DAO = null;	
	
    String[] meses = {"","ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"};
	
	public RegulatorioI453Servicio() {
		super();
	}

	
	/* ================== Tipo de Lista para reportes regulatorios ============== */
	public static interface Enum_Lis_ReportesI453{
		int excel	 = 1;
		int csv		 = 2;
	}
	
	/**
	 * Consulta de reporte I0453
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List <RegulatorioI453Bean>listaReporteRegulatorioI453(int tipoLista, RegulatorioI453Bean reporteBean, HttpServletResponse response){
		List<RegulatorioI453Bean> listaReportes=null;
		switch(tipoLista){
			case Enum_Lis_ReportesI453.excel:
				listaReportes = regulatorioI453DAO.reporteRegulatorioI453(reporteBean, Enum_Lis_ReportesI453.excel); 
				break;
			case Enum_Lis_ReportesI453.csv:
				listaReportes = generarReporteRegulatorioI453(reporteBean, Enum_Lis_ReportesI453.csv,  response);		
				break;		
		}
		return listaReportes;
	}
	

	/**
	 * Genera reporte regulatorio A2112 version CSV
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generarReporteRegulatorioI453(RegulatorioI453Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioI453DAO.reporteRegulatorioI453Csv(reporteBean, tipoReporte);
		nombreArchivo="I_0453_Desagregado_de_Cartera_Castigada.csv";
		
		try{
			RegulatorioI453Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioI453Bean) listaBeans.get(i);
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
	public RegulatorioI453DAO getRegulatorioI453DAO() {
		return regulatorioI453DAO;
	}

	public void setRegulatorioI453DAO(
			RegulatorioI453DAO regulatorioI453DAO) {
		this.regulatorioI453DAO = regulatorioI453DAO;
	}	
		
}
