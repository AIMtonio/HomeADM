package tesoreria.servicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import tesoreria.bean.RepDIOTBean;
import tesoreria.dao.RepDIOTDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class RepDIOTServicio extends BaseServicio{	
	RepDIOTDAO repDIOTDAO=null;
 
	public RepDIOTServicio() {
		super();
	}
	//---------- Tipo de Consulta ----------------------------------------------------------------
	
	public static interface Enum_Lis_ReportesDIOT{
		int excel	 = 1;
		int csv 	 = 2;
	}	
	

	
	/**
	 * Consulta de reporte A1713
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List <RepDIOTBean>listaReporteDIOT(int tipoLista, RepDIOTBean repDIOTBean, HttpServletResponse response){
		List<RepDIOTBean> listaReportes=null;
		switch(tipoLista){
			case Enum_Lis_ReportesDIOT.excel:
				listaReportes = repDIOTDAO.reporteDIOT(repDIOTBean, Enum_Lis_ReportesDIOT.excel); 
				break;
			case Enum_Lis_ReportesDIOT.csv:
				listaReportes = generarReporteDIOT(repDIOTBean, Enum_Lis_ReportesDIOT.csv,  response);		
				break;		
		}
		return listaReportes;
	}
	
	/**
	 * Genera reporte regulatorio A1713 version CSV
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generarReporteDIOT(RepDIOTBean repDIOTBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = repDIOTDAO.reporteDIOTCsv(repDIOTBean, tipoReporte);
		nombreArchivo="ReporteDIOT.csv";
		
		try{
			RepDIOTBean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RepDIOTBean) listaBeans.get(i);
					writer.write(bean.getRenglon());        
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

	
	
	//------------getter y setter--------------

	public RepDIOTDAO getRepDIOTDAO() {
		return repDIOTDAO;
	}

	public void setRepDIOTDAO(RepDIOTDAO repDIOTDAO) {
		this.repDIOTDAO = repDIOTDAO;
	}
	
}
