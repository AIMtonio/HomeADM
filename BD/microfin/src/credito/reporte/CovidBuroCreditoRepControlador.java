package credito.reporte;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class CovidBuroCreditoRepControlador extends AbstractCommandController  {
	
	public static interface Enum_Con_TipRepor {
		  int  ReporteCsv= 1 ;
		  int  ReporteTxt= 2 ;
	}	
	CreditosServicio creditosServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
	
	String successView = null;
	
	public CovidBuroCreditoRepControlador () {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
				CreditosBean creditosBean = (CreditosBean) command;
			int tipoReporte =(request.getParameter("tipoReporte")!=null)?
					Integer.parseInt(request.getParameter("tipoReporte")):
				0;
			int tipoLista =(request.getParameter("tipoLista")!=null)?
					Integer.parseInt(request.getParameter("tipoLista")):
			0;
					
			creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			String htmlString= "";
			//Solo genera el reporte en Csv 
			switch(tipoReporte){
				case Enum_Con_TipRepor.ReporteCsv:	
					 List<CreditosBean>listaReportesCsv = reporteEnvioBuroCreCsv(tipoReporte,creditosBean,response);
				break;
				case Enum_Con_TipRepor.ReporteTxt:
					 List<CreditosBean>listaReportesExcel = reporteEnvioBuroCreTxt(tipoReporte,creditosBean,response);
				break;
			}
			
			if(tipoReporte == CreditosBean.ReporPantalla ){
				return new ModelAndView(getSuccessView(), "reporte", htmlString);
			}else {
				return null;
			}
			
	}

	/**
	 * Método que genera el reporte para la Cinta de Buró de Crédito con los creditos diferidos. Descarga el Archivo directo en el navegador y además
	 * lo guarada en la ruta parametrizada en Parámetros Generales del Sistema, dentro de la carpeta BuroCredito.
	 * @author olegario
	 * El nombre del archivo generado se crea dentro del SP-BUROCREDINTFREP.
	 * @param tipoLista : Tipo de reporte a Generar: 1
	 * @param creditosBean : Clase Bean con los valores de los parámetros de entrada al SP.
	 * @param response : Response (no se ocupa para este reporte).
	 * @return List: Lista con los registros generados para el reporte.
	 */
	public List reporteEnvioBuroCreCsv (int tipoLista,CreditosBean creditosBean,  HttpServletResponse response){
			List listaBuro=null;

			String archivoSal = "";
			try{														
				listaBuro = creditosServicio.listaReporteBCCovid(tipoLista,creditosBean,response);
				
				CreditosBean auxNombre = (CreditosBean)listaBuro.get(0);
				archivoSal = auxNombre.getNombreArchivoRepCinta().trim();
				
				ParametrosSisBean parametrosBean = new ParametrosSisBean();
				parametrosBean.setEmpresaID(String.valueOf(creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().getEmpresaID()));							
				parametrosBean = parametrosSisServicio.consulta(1, parametrosBean);													
				
				File directorioBuro = new File(parametrosBean.getRutaArchivos()+"/BuroCredito/");
				
				if(!directorioBuro.exists()){
					directorioBuro.mkdirs();
				}
											
				//  crea un archivo temporal
		        File  f = File.createTempFile(archivoSal, ".csv", directorioBuro);					        					       
				
				ServletOutputStream ouputStream = null;
				BufferedWriter writer = new BufferedWriter(new FileWriter(f));
				
				 if (!listaBuro.isEmpty()){
					 int i=1,iter=0;
						int tamanioLista=listaBuro.size();
						CreditosBean creditos=null;
						for(iter=0; iter<tamanioLista; iter ++ ){
							creditos= (CreditosBean)listaBuro.get(iter);
							writer.write(creditos.getCinta());	        
					 }
				 }else{
					 writer.write("");
				 }
							
				writer.close();
											
		        FileInputStream archivoLect = new FileInputStream(f);
		        int longitud = archivoLect.available();
		        byte[] datos = new byte[longitud];
		        archivoLect.read(datos);
		        archivoLect.close();
		        
		        f.deleteOnExit();
		        
		        response.setHeader("Content-Disposition","attachment;filename="+archivoSal+".csv");
		    	response.setContentType("application/text");
		    	ouputStream = response.getOutputStream();					    	
		    	ouputStream.write(datos);				    
		    	ouputStream.flush();					    	
		    	ouputStream.close();

			}catch(IOException io ){
				io.printStackTrace();
			}		
			
			return listaBuro;
	}
	/**
	 * Método que genera el reporte para la Cinta de Buró de Crédito con los creditos diferidos. Descarga el Archivo directo en el navegador y además
	 * lo guarada en la ruta parametrizada en Parámetros Generales del Sistema, dentro de la carpeta BuroCredito.
	 * @author olegario
	 * El nombre del archivo generado se crea dentro del SP-BUROCREDINTFREP.
	 * @param tipoLista : Tipo de reporte a Generar: 1
	 * @param creditosBean : Clase Bean con los valores de los parámetros de entrada al SP.
	 * @param response : Response (no se ocupa para este reporte).
	 * @return List: Lista con los registros generados para el reporte.
	 */
	public List reporteEnvioBuroCreTxt (int tipoLista,CreditosBean creditosBean,  HttpServletResponse response){
		List listaBuro=null;
		
		String archivoSal = "";
		try{														
			listaBuro = creditosServicio.listaReporteBCCovid(tipoLista,creditosBean,response);
			
			CreditosBean auxNombre = (CreditosBean)listaBuro.get(0);
			archivoSal = auxNombre.getNombreArchivoRepCinta().trim();																        					       
			
			BufferedWriter writer = new BufferedWriter(new FileWriter(archivoSal));
			
			if (!listaBuro.isEmpty()){
				int i=1,iter=0;
				int tamanioLista=listaBuro.size();
				CreditosBean creditos=null;
				for(iter=0; iter<tamanioLista; iter ++ ){
					creditos= (CreditosBean)listaBuro.get(iter);
					writer.write(creditos.getCinta());	        
				}
			}else{
				writer.write("");
			}
			writer.close();
			
			FileInputStream archivoLect = new FileInputStream(archivoSal);
			int longitud = archivoLect.available();
			byte[] datos = new byte[longitud];
			archivoLect.read(datos);
			archivoLect.close();
			
			response.setHeader("Content-Disposition","attachment;filename="+archivoSal+".txt");
			response.setContentType("application/text");
			ServletOutputStream ouputStream = response.getOutputStream();	    	
			ouputStream.write(datos);
			ouputStream.flush();
			ouputStream.close();
			
		}catch(IOException io ){
			io.printStackTrace();
		}		
		
		return listaBuro;
	}
					
	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}



	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
}

