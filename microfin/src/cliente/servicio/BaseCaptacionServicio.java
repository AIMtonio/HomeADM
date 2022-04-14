package cliente.servicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import cliente.bean.BaseCaptacionBean;
import cliente.dao.BaseCaptacionDAO;
import general.servicio.BaseServicio;

public class BaseCaptacionServicio extends BaseServicio{
	BaseCaptacionDAO baseCaptacionDAO=null;
	
	public static interface Enum_Lis_BaseCap {
        int captacionRepEx= 1;    // Reporte de Captacion en Excel
	}
	public static interface Enum_Reporte_FOCOOP{
		int Captacion = 2;	// Reporte de Captacion en CSV
	}
	
	public List generaReporte(int tipoReporte, BaseCaptacionBean baseCaptacionBean,
			HttpServletResponse response){
			List<BaseCaptacionBean> listaReportes=null;
			switch (tipoReporte) {
				case Enum_Reporte_FOCOOP.Captacion:		
					listaReportes = generaReporteCaptacion(baseCaptacionBean,tipoReporte,response);
				break;
			}
			return listaReportes;
	}
	
	private List generaReporteCaptacion(BaseCaptacionBean baseCaptacionBean,int tipoReporte,
		 	  HttpServletResponse response){
		Calendar calendario = new GregorianCalendar();
		
		int hora, minutos, segundos, milisegundos;
		hora =calendario.get(Calendar.HOUR_OF_DAY);
		minutos = calendario.get(Calendar.MINUTE);
		segundos = calendario.get(Calendar.SECOND);
		milisegundos = calendario.get(Calendar.MILLISECOND);
		String nombreArchivo="BaseCaptacion"+baseCaptacionBean.getFechaReporte()+"-"+hora+minutos+segundos+milisegundos+".csv";

		List listaBaseCapBeans = baseCaptacionDAO.consultaCaptacionCSV(baseCaptacionBean,tipoReporte);				

		 try{
			 BaseCaptacionBean bean;
	            BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
	            if (!listaBaseCapBeans.isEmpty()){
	                for(int i=0; i < listaBaseCapBeans.size(); i++){
	                    bean = (BaseCaptacionBean) listaBaseCapBeans.get(i);
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
       
		return listaBaseCapBeans;
	}
	

	/* Case para listas de reportes de Base Captacion*/
	public List listaReportesFOCOOP(int tipoLista, BaseCaptacionBean baseCaptacionBean){
		 List listaFOCOOP=null;
	
		switch(tipoLista){
			case Enum_Lis_BaseCap.captacionRepEx:
				listaFOCOOP = baseCaptacionDAO.consultaCaptacionExcel(baseCaptacionBean, tipoLista); 
				break;
		}
		
		return listaFOCOOP;
	}

	public BaseCaptacionDAO getBaseCaptacionDAO() {
		return baseCaptacionDAO;
	}

	public void setBaseCaptacionDAO(BaseCaptacionDAO baseCaptacionDAO) {
		this.baseCaptacionDAO = baseCaptacionDAO;
	}
}
