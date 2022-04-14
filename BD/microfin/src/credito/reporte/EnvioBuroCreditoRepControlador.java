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

public class EnvioBuroCreditoRepControlador extends AbstractCommandController  {
	
	public static interface Enum_Con_TipRepor {
		  int  ReporCsv= 1 ;
		  int  ReporExcel= 2 ;
		  int  ReporExt= 3;
	}	
	CreditosServicio creditosServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
	
	String successView = null;
	
	public EnvioBuroCreditoRepControlador () {
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
			int tipoCintaBuro =(request.getParameter("tipoFormatoCinta")!=null)?
							Integer.parseInt(request.getParameter("tipoFormatoCinta")):
			0;
					
			creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			String htmlString= "";
			//Solo genera el reporte en Csv 
			switch(tipoReporte){
				case Enum_Con_TipRepor.ReporCsv:	
					 List<CreditosBean>listaReportesCsv = reporteEnvioBuroCreCsv(tipoLista, tipoCintaBuro, creditosBean,response);
				break;
				case Enum_Con_TipRepor.ReporExcel:
					 List<CreditosBean>listaReportesExcel = reporteEnvioBuroCreExcel(tipoLista,creditosBean,response);
				break;
				case Enum_Con_TipRepor.ReporExt:
					 List<CreditosBean>listaReportesExt = reporteEnvioBuroCreExt(tipoLista,tipoCintaBuro, creditosBean,response);
				break;
			}
			
			if(tipoReporte == CreditosBean.ReporPantalla ){
				return new ModelAndView(getSuccessView(), "reporte", htmlString);
			}else {
				return null;
			}
			
	}
	
	// Reporte de envio buro credito en excel
	public List  reporteEnvioBuroCreExcel(int tipoLista,CreditosBean creditosBean,  HttpServletResponse response){
		List listaBuroCre=null;
		//List listaCreditos = null;
		listaBuroCre = creditosServicio.listaReportesCreditos(tipoLista,creditosBean,response); 	
		
		int regExport = 0;
		
		//if(listaMinistraciones != null){

		try {
		HSSFWorkbook libro = new HSSFWorkbook();
		//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
		HSSFFont fuenteNegrita10= libro.createFont();
		fuenteNegrita10.setFontHeightInPoints((short)10);
		fuenteNegrita10.setFontName("Negrita");
		fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		
		
		//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
		HSSFFont fuenteNegrita8= libro.createFont();
		fuenteNegrita8.setFontHeightInPoints((short)8);
		fuenteNegrita8.setFontName("Negrita");
		fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		
		// La fuente se mete en un estilo para poder ser usada.
		//Estilo negrita de 10 para el titulo del reporte
		HSSFCellStyle estiloNeg10 = libro.createCellStyle();
		estiloNeg10.setFont(fuenteNegrita10);
		
		//Estilo negrita de 8  para encabezados del reporte
		HSSFCellStyle estiloNeg8 = libro.createCellStyle();
		estiloNeg8.setFont(fuenteNegrita8);
		
		//Estilo negrita de 8  y color de fondo
		HSSFCellStyle estiloColor = libro.createCellStyle();
		estiloColor.setFont(fuenteNegrita8);
		estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
		estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		
		
		//Estilo Formato decimal (0.00)
		HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
		HSSFDataFormat format = libro.createDataFormat();
		estiloFormatoDecimal.setDataFormat(format.getFormat("0.00"));
		
		//centrado
		HSSFCellStyle estiloCentrado = libro.createCellStyle();
		estiloCentrado.setFont(fuenteNegrita8);
		estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
		estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
		
	    // Lista de encabezados del excel
		List<String> listaTitulosBuro = new ArrayList<String>();	
		/* 1  */listaTitulosBuro.add("- Cinta");



		// Creacion de hoja
		HSSFSheet hoja = libro.createSheet("Reporte Envio Buro Credito");
		HSSFRow fila= hoja.createRow(0);
		HSSFCell celda=null;
		for (int cel=0; cel < listaTitulosBuro.size(); cel ++){
	    String  titulo= (String) listaTitulosBuro.get(cel);
	    celda=fila.createCell((short)cel);
		celda.setCellValue(titulo);
		celda.setCellStyle(estiloNeg8);
		}
     		
		
		int i=1,iter=0;
		int tamanioLista=listaBuroCre.size();
		CreditosBean creditos=null;
		for(iter=0; iter<tamanioLista; iter ++ ){

			creditos= (CreditosBean)listaBuroCre.get(iter);
				fila=hoja.createRow(i);
				celda=fila.createCell((short)0);
				celda.setCellValue(creditos.getNombreCliente());

			i++;
		}

		for(int celd=0; celd<=42; celd++)
		hoja.autoSizeColumn((short)celd);

								
		//Creo la cabecera
		response.addHeader("Content-Disposition","inline; filename=ReporteEnvioBuroCred.xls");
		response.setContentType("application/vnd.ms-excel");
		
		ServletOutputStream outputStream = response.getOutputStream();
		hoja.getWorkbook().write(outputStream);
		outputStream.flush();
		outputStream.close();
		
		}catch(Exception e){
			e.printStackTrace();
		}//Fin del catch
	//} fin if null
	return  listaBuroCre;
	
	}

	/**
	 * Método que genera el reporte para la Cinta de Buró de Crédito. Descarga el Archivo directo en el navegador y además
	 * lo guarada en la ruta parametrizada en Parámetros Generales del Sistema, dentro de la carpeta BuroCredito.
	 * El nombre del archivo generado se crea dentro del SP-BUROCREDINTFREP.
	 * @param tipoLista : Tipo de reporte a Generar: 7 para el reporte de Cinta.
	 * @param creditosBean : Clase Bean con los valores de los parámetros de entrada al SP.
	 * @param response : Response (no se ocupa para este reporte).
	 * @return List: Lista con los registros generados para el reporte.
	 */
	public List reporteEnvioBuroCreCsv (int tipoLista, int tipoCintaBuro,CreditosBean creditosBean,  HttpServletResponse response){
			List listaBuro=null;

			String archivoSal = "";
			String headerINTL = "";
			try{														
				listaBuro = creditosServicio.listaReportesCreditos(tipoLista,creditosBean,response);
				
				CreditosBean auxNombre = (CreditosBean)listaBuro.get(0);
				archivoSal = auxNombre.getNombreArchivoRepCinta().trim();
				//Se obtiene el segmento encabezado de la cadena INTL
				headerINTL = auxNombre.getHeaderINTL();
				
				ParametrosSisBean parametrosBean = new ParametrosSisBean();
				parametrosBean.setEmpresaID(String.valueOf(creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().getEmpresaID()));							
				parametrosBean = parametrosSisServicio.consulta(1, parametrosBean);													
				
				File directorioBuro = new File(parametrosBean.getRutaArchivos()+"/BuroCredito/");
				
				if(!directorioBuro.exists()){
					directorioBuro.mkdirs();
				}
				
				//Tipo cinta de buro de credito en formato CSV
				if(tipoCintaBuro == 1){
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
				}
				//TIPO DE REPORTE EN FORMATO INTL
				if(tipoCintaBuro == 2){
					//crea un archivo temporal
			        File  fileTemp = File.createTempFile(archivoSal, ".txt", directorioBuro);					        					       
					
					ServletOutputStream ouputStream = null;
					BufferedWriter writer = new BufferedWriter(new FileWriter(fileTemp));

					//Que la lista sea diferente de vacio
					 if (!listaBuro.isEmpty()){
						int iter=0;
						int tamanioLista = listaBuro.size();
						CreditosBean creditos=null;
						
						//Se escribe el encabezado para la cinta
						writer.write(headerINTL);
						writer.flush();
						writer.close();

						//SE ITERA LA LISTA
						for(iter=0; iter<tamanioLista; iter ++ ){
							//Iterador
							creditos= (CreditosBean)listaBuro.get(iter);
							//Se escribe sobre la misma fila del archivo
							writer = new BufferedWriter(new FileWriter(fileTemp, true));
							writer.write(creditos.getCinta());
							writer.flush();
						 }
					 }else{
						 writer.write("");
					 }
								
					writer.close();
												
			        FileInputStream archivoLect = new FileInputStream(fileTemp);
			        int longitud = archivoLect.available();
			        byte[] datos = new byte[longitud];
			        archivoLect.read(datos);
			        archivoLect.close();
			        
			        fileTemp.deleteOnExit();
			        
			        response.setHeader("Content-Disposition","attachment;filename="+archivoSal+".txt");
			    	response.setContentType("application/text;charset=US-ASCII");
			    	response.setCharacterEncoding("US-ASCII");
			    	ouputStream = response.getOutputStream();
			    	
			    	ouputStream.write(datos);   
			    	ouputStream.flush();
			    	ouputStream.close();
				}//End INTL

			}catch(IOException io ){
				io.printStackTrace();
			}		
			
			return listaBuro;
	}
	
	public List reporteEnvioBuroCreExt (int tipoLista, int tipoCintaBuro,CreditosBean creditosBean,  HttpServletResponse response){
		List listaBuro=null;

		String archivoSal = "";
		String headerINTL = "";
		try{														
			listaBuro = creditosServicio.listaReportesCreditos(tipoLista,creditosBean,response);
			
			CreditosBean auxNombre = (CreditosBean)listaBuro.get(0);
			archivoSal = auxNombre.getNombreArchivoRepCinta().trim();
			//Se obtiene el segmento encabezado de la cadena INTL
			headerINTL = auxNombre.getHeaderINTL();
			
			ParametrosSisBean parametrosBean = new ParametrosSisBean();
			parametrosBean.setEmpresaID(String.valueOf(creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().getEmpresaID()));							
			parametrosBean = parametrosSisServicio.consulta(1, parametrosBean);													
			
			File directorioBuro = new File(parametrosBean.getRutaArchivos()+"/BuroCredito/");
			
			if(!directorioBuro.exists()){
				directorioBuro.mkdirs();
			}
			
			//Tipo cinta de buro de credito personas fisicas Semanal en formato EXT
			if(tipoCintaBuro == 3){
				//  crea un archivo temporal
		        File  f = File.createTempFile(archivoSal, ".ext", directorioBuro);					        					       
				
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
		        
		        response.setHeader("Content-Disposition","attachment;filename="+archivoSal+".ext");
		    	response.setContentType("application/text");
		    	ouputStream = response.getOutputStream();					    	
		    	ouputStream.write(datos);				    
		    	ouputStream.flush();					    	
		    	ouputStream.close();	
			}//END EXT

		}catch(IOException io ){
			io.printStackTrace();
		}		
		
		return listaBuro;
}
	
	// ------------ GETTERS AND SETTERS
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

