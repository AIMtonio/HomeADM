package regulatorios.servicio;

import general.servicio.BaseServicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import regulatorios.bean.RegulatorioB2021Bean;
import regulatorios.dao.RegulatorioB2021DAO;


public class RegulatorioB2021Servicio  extends BaseServicio{
	RegulatorioB2021DAO regulatorioB2021DAO = null;	
	
    String[] meses = {"","ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"};
	
	public RegulatorioB2021Servicio() {
		super();
	}

	
	/* ================== Tipo de Lista para reportes regulatorios ============== */
	
	public static interface Enum_Lis_ReportesB2021{
		int excel	 = 1;
		int csv		 = 2;
	}
	public static interface Enum_Lis_ReportesA2111{
		int excel	 = 1;
		int csv		 = 2;
	}
	
	public List <RegulatorioB2021Bean>listaReporteRegulatorioB2021(int tipoLista, RegulatorioB2021Bean reporteBean, HttpServletResponse response){
		List<RegulatorioB2021Bean> listaReportes=null;
		switch(tipoLista){
			case Enum_Lis_ReportesB2021.excel:
				listaReportes = regulatorioB2021DAO.reporteRegulatorioB2021(reporteBean, Enum_Lis_ReportesB2021.excel); 
				break;
			case Enum_Lis_ReportesB2021.csv:
				listaReportes = generarReporteRegulatorioB2021(reporteBean, Enum_Lis_ReportesB2021.csv,  response);	
				break;		
		}
		return listaReportes;
	}
	/* ======================================  FUNCIONES PARA GENERAR REPORTES CSV  ========================================*/	
	
	private List generarReporteRegulatorioB2021(RegulatorioB2021Bean reporteBean,int tipoReporte,HttpServletResponse response){
		
		String nombreArchivo="";
		List listaBeans = regulatorioB2021DAO.reporteRegulatorioB2021Csv(reporteBean, tipoReporte);
		
		nombreArchivo="R20 B 2021 " + meses[Integer.parseInt(reporteBean.getMes())] + " "+reporteBean.getAnio() + ".csv";

		// se inicia seccion para pintar el archivo csv
		try{
			RegulatorioB2021Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioB2021Bean) listaBeans.get(i);
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

	public RegulatorioB2021DAO getRegulatorioB2021DAO() {
		return regulatorioB2021DAO;
	}

	public void setRegulatorioB2021DAO(RegulatorioB2021DAO regulatorioB2021DAO) {
		this.regulatorioB2021DAO = regulatorioB2021DAO;
	}

	public String[] getMeses() {
		return meses;
	}

	public void setMeses(String[] meses) {
		this.meses = meses;
	}
	

	
	
}
