package cuentas.servicio;

import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.HttpRequest;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import contabilidad.bean.ReporteCatMinFapBean;
import cuentas.bean.RepSeguimientoFolioJPMovilBean;
import cuentas.bean.RepVerificacionPreguntasBean;
import cuentas.dao.RepSeguimientoFolioJPMovilDAO;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

public class RepSeguimientoFolioJPMovilServicio extends BaseServicio{
	
	RepSeguimientoFolioJPMovilDAO repSeguimientoFolioJPMovilDAO = null;
	ParametrosSesionBean parametrosSesionBean;
	public RepSeguimientoFolioJPMovilServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public static interface Enum_Rep_Seguimiento{
		int excel = 1;
	}
	
	public List<RepSeguimientoFolioJPMovilBean> listaReporte(RepSeguimientoFolioJPMovilBean repSeguimientoFolioJPMovilBean, int tipoReporte){
		List<RepSeguimientoFolioJPMovilBean> listaBean = null;
		switch(tipoReporte){
			case  Enum_Rep_Seguimiento.excel:
				listaBean = repSeguimientoFolioJPMovilDAO.repHisSeguimientoJPMovil(repSeguimientoFolioJPMovilBean, tipoReporte);
				break;
		}
		return listaBean;
	}
	
	public void generaReporteExcel(HttpServletResponse response,RepSeguimientoFolioJPMovilBean repSeguimientoFolioJPMovilBean, int tipoReporte){
/*		String mesEnLetras	= "";
		String anio		= "";
		mesEnLetras = descripcionMes(repRegCatalogoMinimoBean.getMes());
		anio	= repRegCatalogoMinimoBean.getAnio();*/
		String nombreArchivo = "";
		nombreArchivo = "Reporte Historico Folios JPMovil";

		List<RepSeguimientoFolioJPMovilBean> listaRepSeguimiento = null;
		/*Se hace la llamada para obtener la lista para llenar el reporte*/
		listaRepSeguimiento = listaReporte(repSeguimientoFolioJPMovilBean, tipoReporte);
		String folioEstatus = "";
		if(repSeguimientoFolioJPMovilBean.getEstatus().equalsIgnoreCase("P")){
			folioEstatus = "EN PROCESO";
		}else{
			if(repSeguimientoFolioJPMovilBean.getEstatus().equalsIgnoreCase("C")){
				folioEstatus = "CANCELADO";
			}else{
				if(repSeguimientoFolioJPMovilBean.getEstatus().equalsIgnoreCase("R")){
					folioEstatus = "RESUELTO";
				}else{
					folioEstatus = "TODOS";
				}
			}
		}
		
try {
			
			XSSFWorkbook libro = new XSSFWorkbook();
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			XSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			XSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			// Negrita 10 centrado
			XSSFFont centradoNegrita10 = libro.createFont();
			centradoNegrita10.setFontHeightInPoints((short)10);
			centradoNegrita10.setFontName("Negrita");
			centradoNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			XSSFCellStyle estiloNegCentrado10 = libro.createCellStyle();
			estiloNegCentrado10.setFont(centradoNegrita10);
			estiloNegCentrado10.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			
			// Negrita 8 centrado
			XSSFFont centradoNegrita8= libro.createFont();
			centradoNegrita8.setFontHeightInPoints((short)8);
			centradoNegrita8.setFontName("Negrita");
			centradoNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			XSSFCellStyle estiloNegCentrado8 = libro.createCellStyle();
			estiloNegCentrado8.setFont(centradoNegrita8);
			estiloNegCentrado8.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
						
			//Estilo Formato decimal (0.00)
			XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			XSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			// Creacion de hoja
			XSSFSheet hoja = libro.createSheet("Reporte");
			XSSFRow fila= hoja.createRow(1);

			// Nombre Usuario
			XSSFCell celdaini = fila.createCell((short)1);
			celdaini = fila.createCell((short)8);
			celdaini.setCellValue("Usuario:");
			celdaini.setCellStyle(estiloNeg8);	
			celdaini = fila.createCell((short)9);
			celdaini.setCellValue(repSeguimientoFolioJPMovilBean.getUsuario());
			
			// Nombre Institucion
			XSSFCell celdaInst=fila.createCell((short)1);
			celdaInst=fila.createCell((short)1);
			celdaInst.setCellStyle(estiloNegCentrado10);
			celdaInst.setCellValue(repSeguimientoFolioJPMovilBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(
		            1, //first row (0-based)
		            1, //last row  (0-based)
		            1, //first column (0-based)
		            6  //last column  (0-based)
		    )); 

			// Descripcion del Reporte
			fila	= hoja.createRow(2);	
			
			// Fecha en que se genera el reporte
			XSSFCell celdafin = fila.createCell((short)8);
			celdafin.setCellValue("Fecha:");
			celdafin.setCellStyle(estiloNeg8);	
			celdafin = fila.createCell((short)9);
			celdafin.setCellValue(repSeguimientoFolioJPMovilBean.getFechaEmision());
			
			XSSFCell celdaR=fila.createCell((short)2);
			celdaR	= fila.createCell((short)1);			
			celdaR.setCellStyle(estiloNegCentrado10);
			celdaR.setCellValue("REPORTE DE FOLIOS PADEMOBILE DEL " + repSeguimientoFolioJPMovilBean.getFechaInicio() + " AL " + repSeguimientoFolioJPMovilBean.getFechaFin());
			hoja.addMergedRegion(new CellRangeAddress(
		            2, //first row (0-based)
		            2, //last row  (0-based)
		            1, //first column (0-based)
		            6  //last column  (0-based)
		    ));
			
			
			// Hora en que se genera el reporte
			fila = hoja.createRow(3);	
			XSSFCell celda=fila.createCell((short)1);
			celda = fila.createCell((short)8);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)9);
			
			String horaVar = "";
			
			Calendar calendario = Calendar.getInstance();	 
			int hora =calendario.get(Calendar.HOUR_OF_DAY);
			int minutos = calendario.get(Calendar.MINUTE);
			int segundos = calendario.get(Calendar.SECOND);
			
			String h = Integer.toString(hora);
			String m = "";
			String s = "";
			if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
			if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);		
				 
			horaVar= h+":"+m+":"+s;
			
			celda.setCellValue(horaVar);
			
			// Creacion de fila
			fila = hoja.createRow(4);
			fila = hoja.createRow(5);
			
			
			celda = fila.createCell((short)1);
			celda.setCellValue(Utileria.generaLocale(Constantes.CLIENTE_SOCIO, parametrosSesionBean.getNomCortoInstitucion()));
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)2);
			celda.setCellValue(repSeguimientoFolioJPMovilBean.getClienteID()+" - "+repSeguimientoFolioJPMovilBean.getNombreCompleto());
			celda.setCellStyle(estiloNeg8);	
			
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Folio");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)5);
			celda.setCellValue(folioEstatus);
			celda.setCellStyle(estiloNeg8);
			
			fila = hoja.createRow(6);
			fila = hoja.createRow(7);
			
			celda = fila.createCell((short)1);
			celda.setCellValue("No. "+Utileria.generaLocale(Constantes.CLIENTE_SOCIO, parametrosSesionBean.getNomCortoInstitucion()));
			celda.setCellStyle(estiloNegCentrado8);	

			celda = fila.createCell((short)2);
			celda.setCellValue("Nombre Completo");
			celda.setCellStyle(estiloNegCentrado8);	
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Teléfono Celular");
			celda.setCellStyle(estiloNegCentrado8);	
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Número Cuenta");
			celda.setCellStyle(estiloNegCentrado8);
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Folio");
			celda.setCellStyle(estiloNegCentrado8);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Sucursal");
			celda.setCellStyle(estiloNegCentrado8);	
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Estatus");
			celda.setCellStyle(estiloNegCentrado8);	
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Fecha Apertura");
			celda.setCellStyle(estiloNegCentrado8);	
			
			celda = fila.createCell((short)9);
			celda.setCellValue("Hora");
			celda.setCellStyle(estiloNegCentrado8);	
			
			
			
			if(repSeguimientoFolioJPMovilBean.getIncluyeComentario().equalsIgnoreCase("S")){
				celda = fila.createCell((short)10);
				celda.setCellValue("Comentario del usuario");
				celda.setCellStyle(estiloNegCentrado8);
				celda = fila.createCell((short)11);
				celda.setCellValue("Comentario del cliente");
				celda.setCellStyle(estiloNegCentrado8);
			}else{
				celda = fila.createCell((short)10);
				celda.setCellValue("Tipo de Soporte");
				celda.setCellStyle(estiloNegCentrado8);	
				
				celda = fila.createCell((short)11);
				celda.setCellValue("Usuario");
				celda.setCellStyle(estiloNegCentrado8);	
				
				celda = fila.createCell((short)12);
				celda.setCellValue("Resultado");
				celda.setCellStyle(estiloNegCentrado8);
			}
				
			
			int row = 8,iter=0,contador=0;
			int tamanioLista = listaRepSeguimiento.size();
			//RepVerificacionPreguntasBean verificaPregunta = null;
			for(RepSeguimientoFolioJPMovilBean seguimientoFolioBean : listaRepSeguimiento){
				//verificaPregunta = (RepVerificacionPreguntasBean) listaRepSeguimiento.get(iter);

				fila=hoja.createRow(row);
				
				celda = fila.createCell((short)1);
				celda.setCellValue(seguimientoFolioBean.getClienteID());
				if(!seguimientoFolioBean.getClienteID().isEmpty()){
					contador++;
				}
				celda = fila.createCell((short)2);
				celda.setCellValue(seguimientoFolioBean.getNombreCompleto());
				
				celda = fila.createCell((short)3);
				celda.setCellValue(seguimientoFolioBean.getTeléfonoCelular());
				
				celda = fila.createCell((short)4);
				celda.setCellValue(seguimientoFolioBean.getNumeroCuenta());
				
				celda = fila.createCell((short)5);
				celda.setCellValue(seguimientoFolioBean.getSeguimientoID());
				
				celda = fila.createCell((short)6);
				celda.setCellValue(seguimientoFolioBean.getSucursal());
				
				celda = fila.createCell((short)7);
				celda.setCellValue(seguimientoFolioBean.getEstatus());
				
				celda = fila.createCell((short)8);
				celda.setCellValue(seguimientoFolioBean.getFechaApertura());
				
				celda = fila.createCell((short)9);
				celda.setCellValue(seguimientoFolioBean.getHora());
				
				
				if(repSeguimientoFolioJPMovilBean.getIncluyeComentario().equalsIgnoreCase("S")){
					celda = fila.createCell((short)10);
					celda.setCellValue(seguimientoFolioBean.getComentarioUsuario());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)11);
					celda.setCellValue(seguimientoFolioBean.getRespuestaCliente());
				}else{
					celda = fila.createCell((short)10);
					celda.setCellValue(seguimientoFolioBean.getTipoSoporte());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)11);
					celda.setCellValue(seguimientoFolioBean.getUsuario());
					
					celda = fila.createCell((short)12);
					celda.setCellValue(seguimientoFolioBean.getUltimoComentario());
				}
				
				
				row++;
			}
			
			row = row+2;
			fila=hoja.createRow(row);
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);
			
			row = row+1;
			fila=hoja.createRow(row);
			celda=fila.createCell((short)0);
			celda.setCellValue(contador);
			
			hoja.autoSizeColumn((short)0);
			hoja.autoSizeColumn((short)1);
			hoja.autoSizeColumn((short)2);
			hoja.autoSizeColumn((short)3);
			hoja.autoSizeColumn((short)4);
			hoja.autoSizeColumn((short)5);
			hoja.autoSizeColumn((short)6);
			hoja.autoSizeColumn((short)7);
			hoja.autoSizeColumn((short)8);
			hoja.autoSizeColumn((short)9);
			hoja.autoSizeColumn((short)10);
			hoja.autoSizeColumn((short)11);
			hoja.autoSizeColumn((short)12);
			
			//Se crea la cabecera
			response.addHeader("Content-Disposition","inline; filename=RepHistoricoSeguimientoFolioJPMovil.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			}catch(Exception e){
	    		e.printStackTrace();
	    	}//Fin del catch

	}

	public RepSeguimientoFolioJPMovilDAO getRepSeguimientoFolioJPMovilDAO() {
		return repSeguimientoFolioJPMovilDAO;
	}

	public void setRepSeguimientoFolioJPMovilDAO(
			RepSeguimientoFolioJPMovilDAO repSeguimientoFolioJPMovilDAO) {
		this.repSeguimientoFolioJPMovilDAO = repSeguimientoFolioJPMovilDAO;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
