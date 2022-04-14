package regulatorios.servicio;

import general.servicio.BaseServicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import regulatorios.bean.RegulatorioA3011Bean;
import regulatorios.dao.RegulatorioA3011DAO;


public class RegulatorioA3011Servicio  extends BaseServicio{
	RegulatorioA3011DAO regulatorioA3011DAO = null;	
	
    String[] meses = {"","ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"};
	
	public RegulatorioA3011Servicio() {
		super();
	}

	
	/* ================== Tipo de Lista para reportes regulatorios ============== */

	public static interface Enum_Lis_ReportesA3011{
		int excel	 = 1;
		int csv		 = 2;
	}

	
	public List <RegulatorioA3011Bean>listaReporteRegulatorioA3011(int tipoLista, RegulatorioA3011Bean reporteBean, HttpServletResponse response){
		List<RegulatorioA3011Bean> listaReportes=null;
		switch(tipoLista){
			case Enum_Lis_ReportesA3011.excel:
				listaReportes = regulatorioA3011DAO.reporteRegulatorioA3011(reporteBean, Enum_Lis_ReportesA3011.excel); 
				break;
			case Enum_Lis_ReportesA3011.csv:
				listaReportes = generarReporteRegulatorioA3011(reporteBean, Enum_Lis_ReportesA3011.csv,  response);		
				break;		
		}
		return listaReportes;
	}
	

	/* ======================================  FUNCIONES PARA GENERAR REPORTES CSV  ========================================*/	
	
	private List generarReporteRegulatorioA3011(RegulatorioA3011Bean reporteBean,int tipoReporte,HttpServletResponse response){
		
		String nombreArchivo="";
		List listaBeans = regulatorioA3011DAO.reporteRegulatorioA3011Csv(reporteBean, tipoReporte);
		nombreArchivo="R20 A 3011 " + meses[Integer.parseInt(reporteBean.getMes())] + " "+reporteBean.getAnio() + ".csv";
		// se inicia seccion para pintar el archivo csv
		try{
			RegulatorioA3011Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioA3011Bean) listaBeans.get(i);
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



	/* ========================= GET  &&  SET  =========================*/

	public RegulatorioA3011DAO getRegulatorioA3011DAO() {
		return regulatorioA3011DAO;
	}


	public void setRegulatorioA3011DAO(RegulatorioA3011DAO regulatorioA3011DAO) {
		this.regulatorioA3011DAO = regulatorioA3011DAO;
	}


	public String[] getMeses() {
		return meses;
	}


	public void setMeses(String[] meses) {
		this.meses = meses;
	}
	
}
