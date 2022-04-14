package seguimiento.reporte;

import java.io.ByteArrayOutputStream;
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
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.ReporteMinistraBean;


import seguimiento.bean.RepSeguimientoBean;
import seguimiento.bean.SeguimientoBean;
import seguimiento.servicio.SeguimientoServicio;

public class SegtoCampoRepControlador extends AbstractCommandController {

	public static interface Enum_Con_TipRepor {
		  int  ReportePDF= 1;
		  int  ReporteExcel= 2;
	}
	
	SeguimientoServicio seguimientoServicio = null;
	String nombreReporte = null;
	String successView = null;		

	public SegtoCampoRepControlador(){
		setCommandClass(SeguimientoBean.class);
		setCommandName("seguimientoBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {	
		
			SeguimientoBean segtoBean =(SeguimientoBean) command;
			// TODO Auto-generated method stub
			int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
				
			int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):0;
			
			seguimientoServicio.getSeguimientoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			String htmlString= "";
				
			switch(tipoReporte){
				case Enum_Con_TipRepor.ReportePDF:
					ByteArrayOutputStream htmlStringPDF = repSegtoCampoPDF(segtoBean, nombreReporte, response);
				break;
				case Enum_Con_TipRepor.ReporteExcel:		
					 List listaReportes = repSegtoCampoExcel(tipoLista,segtoBean,response);
				break;
			}
			return null;
		}
	
		// Reporte de Seguimiento de Campo en PDF
		private ByteArrayOutputStream repSegtoCampoPDF(SeguimientoBean segtoBean, String nombreReporte,
				HttpServletResponse response) {
			ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = seguimientoServicio.reporteSegtoCampoPDF(segtoBean, nombreReporte);
				response.addHeader("Content-Disposition","inline; filename=ReporteSegtoCampo.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlStringPDF.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			} catch (Exception e) {
				e.printStackTrace();
			}		
			return htmlStringPDF;
		}
	
		// Reporte de Seguimiento de Campo en EXCEL
		public List repSegtoCampoExcel(int tipoLista,SeguimientoBean segtoBean,  HttpServletResponse response){
			List listaSeguimiento=null;
			listaSeguimiento = seguimientoServicio.listaReporteSeguimiento(tipoLista,segtoBean,response);
			
			int regExport = 0;
			
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
				
				HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
				estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
				
				HSSFCellStyle estiloCentrado = libro.createCellStyle();
				estiloCentrado.setFont(fuenteNegrita8);
				estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
				
				
				//Estilo negrita de 8  y color de fondo
				HSSFCellStyle estiloColor = libro.createCellStyle();
				estiloColor.setFont(fuenteNegrita8);
				estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
				estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				
				//Estilo Formato decimal (0.00)
				HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
				HSSFDataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
				
				// Creacion de hoja					
				HSSFSheet hoja = libro.createSheet("Reporte de Seguimiento de Campo");
				HSSFRow fila= hoja.createRow(0);
				
				// inicio usuario,fecha y hora
				HSSFCell celdaUsu=fila.createCell((short)1);
	 
				celdaUsu = fila.createCell((short)16);
				celdaUsu.setCellValue("Usuario:");
				celdaUsu.setCellStyle(estiloNeg8);	
				celdaUsu = fila.createCell((short)17);
				celdaUsu.setCellValue((!segtoBean.getNomUsuario().isEmpty())?segtoBean.getNomUsuario(): "TODOS");

				String horaVar="";
				String fechaVar=segtoBean.getFechaEmision();

				int itera=0;
				RepSeguimientoBean seguimientoHora = null;
				if(!listaSeguimiento.isEmpty()){
				for( itera=0; itera<1; itera ++){

					seguimientoHora = (RepSeguimientoBean) listaSeguimiento.get(itera);
					horaVar= seguimientoHora.getHora();

				}
				}
				
				fila = hoja.createRow(1);
				HSSFCell celdaFec=fila.createCell((short)1);
				celdaFec = fila.createCell((short)16);
				celdaFec.setCellValue("Fecha:");
				celdaFec.setCellStyle(estiloNeg8);	
				celdaFec = fila.createCell((short)17);
				celdaFec.setCellValue(fechaVar);
				
				//Nombre Institucion
				HSSFCell celdaInst=fila.createCell((short)1);
				celdaInst.setCellStyle(estiloNeg8);	
				celdaInst.setCellValue(segtoBean.getNomInstitucion());
				estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
				  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            1, //primera fila (0-based)
				            1, //ultima fila  (0-based)
				            1, //primer celda (0-based)
				            10  //ultima celda   (0-based)
				    ));
					celdaInst.setCellStyle(estiloDatosCentrado);
				
				fila = hoja.createRow(2);
				HSSFCell celdaHora=fila.createCell((short)1);
				celdaHora = fila.createCell((short)16);
				celdaHora.setCellValue("Hora:");
				celdaHora.setCellStyle(estiloNeg8);	
				celdaHora = fila.createCell((short)17);
				celdaHora.setCellValue(horaVar);
				
				HSSFCell celda=fila.createCell((short)1);
				celda.setCellStyle(estiloNeg8);	
				celda.setCellValue("REPORTE DE SEGUIMIENTO DE CAMPO DEL: "+segtoBean.getFechaInicio()+" AL "+segtoBean.getFechaFin());
				celda.setCellStyle(estiloDatosCentrado);

			
			   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            10  //ultima celda   (0-based)
			    ));
			   
			   	// Creacion de fila
				fila = hoja.createRow(3);
				fila = hoja.createRow(4);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("No.Seguimiento");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("Fecha Registro");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("No. Crédito");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Nombre Cliente");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("No. Grupo");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("Nombre Grupo");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("Fecha Captura");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Fecha Programada");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Fecha Inicio");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Fecha Terminación");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("Comentarios");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("Resultado");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)13);
				celda.setCellValue("Primera Recomendación");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)14);
				celda.setCellValue("Segunda Recomendación");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)15);
				celda.setCellValue("Estatus");
				celda.setCellStyle(estiloNeg8);
				
				int i=5,iter=0;
				int tamanioLista=listaSeguimiento.size();
				RepSeguimientoBean repSeguimientoBean=null;
				for(iter=0; iter<tamanioLista; iter ++ ){
				
					repSeguimientoBean= (RepSeguimientoBean)listaSeguimiento.get(iter);
					fila=hoja.createRow(i);

					celda=fila.createCell((short)1);
					celda.setCellValue(repSeguimientoBean.getSegtoPrograID());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)2);
					celda.setCellValue(repSeguimientoBean.getFechaRegistro());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)3);
					celda.setCellValue(repSeguimientoBean.getCreditoID());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)4);
					celda.setCellValue(repSeguimientoBean.getNombreCompleto());
					
					celda=fila.createCell((short)5);
					celda.setCellValue(repSeguimientoBean.getGrupoID());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)6);
					celda.setCellValue(repSeguimientoBean.getNombreGrupo());
				
					celda=fila.createCell((short)7);
					celda.setCellValue(repSeguimientoBean.getFechaCaptura());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)8);
					celda.setCellValue(repSeguimientoBean.getFechaProgramada());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)9);
					celda.setCellValue(repSeguimientoBean.getFechaInicioSegto());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)10);
					celda.setCellValue(repSeguimientoBean.getFechaFinalSegto());
					celda.setCellStyle(estiloDatosCentrado);

					celda=fila.createCell((short)11);
					celda.setCellValue(repSeguimientoBean.getComentario());
					
					celda=fila.createCell((short)12);
					celda.setCellValue(repSeguimientoBean.getResultado());
					
					celda=fila.createCell((short)13);
					celda.setCellValue(repSeguimientoBean.getRecomendacion1());
					
					celda=fila.createCell((short)14);
					celda.setCellValue(repSeguimientoBean.getRecomendacion2());
					
					celda=fila.createCell((short)15);
					celda.setCellValue(repSeguimientoBean.getEstatusRealiza());
					i++;
				}
				 
				i = i+1;
				fila=hoja.createRow(i);
				celda = fila.createCell((short)0);
				celda.setCellValue("Registros Exportados");
				celda.setCellStyle(estiloNeg8);
				
				i = i+1;
				fila=hoja.createRow(i);
				celda=fila.createCell((short)0);
				celda.setCellValue(tamanioLista);
				

				for(int celd=0; celd<=19; celd++)
				hoja.autoSizeColumn((short)celd);
				
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteSeguimientoCampo.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
			//	log.info("Termina Reporte");
				}catch(Exception e){
				//	log.info("Error al crear el reporte: " + e.getMessage());
					e.printStackTrace();
				}//Fin del catch 
	    	
	    	return  listaSeguimiento;		
			
		}

	public SeguimientoServicio getSeguimientoServicio() {
		return seguimientoServicio;
	}

	public void setSeguimientoServicio(SeguimientoServicio seguimientoServicio) {
		this.seguimientoServicio = seguimientoServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}