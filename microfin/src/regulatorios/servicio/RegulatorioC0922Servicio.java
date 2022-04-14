package regulatorios.servicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletOutputStream;
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

import regulatorios.bean.RegulatorioC0922Bean;
import regulatorios.dao.RegulatorioC0922DAO;
import regulatorios.servicio.RegulatorioD2442Servicio.Enum_Lis_RegulatorioD2442;
import regulatorios.servicio.RegulatorioD2443Servicio.Enum_Lis_RegulatorioD2443;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
 
public class RegulatorioC0922Servicio extends BaseServicio{	
	RegulatorioC0922DAO regulatorioC0922DAO=null;
 
	public RegulatorioC0922Servicio() {
		super();
	}
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Lis_RegulatorioC0922 {
		int principal = 1;
		int listaRegistro = 2;
	}
	
	public static interface Enum_Alt_RegulatorioC0922 {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}
	
	
	public static interface Enum_Lis_ReportesC0922{
		int excel	 = 1;
		int csv 	 = 2;
	}
	
		
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,int tipoEntidad,	RegulatorioC0922Bean regulatorioC0922Bean ){
		ArrayList listaRegulatorioC0922 = (ArrayList) creaListaDetalle(regulatorioC0922Bean);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				

		
			switch (tipoTransaccion) {
				case Enum_Alt_RegulatorioC0922.alta:		
					mensaje = altaGridRegulatorioC0922(tipoTransaccion,regulatorioC0922Bean);								
					break;					
			}
			
		
		
		return mensaje;
	}
	
	
	private MensajeTransaccionBean altaGridRegulatorioC0922(
			int tipoTransaccion, RegulatorioC0922Bean regulatorioC0922Bean) {
		
		List registroRegC0922 = creaListaDetalle(regulatorioC0922Bean);
		
		MensajeTransaccionBean mensaje = regulatorioC0922DAO.grabaRegulatorioC0922(regulatorioC0922Bean,registroRegC0922);
		
		return mensaje;
		
	}


	public List lista(int tipoLista, RegulatorioC0922Bean regulatorioC0922Bean){		
		List regulatorioC0922 = null;
		switch (tipoLista) {	
			case Enum_Lis_RegulatorioC0922.principal:		
				regulatorioC0922 = regulatorioC0922DAO.reporteRegulatorioC0922Sofipo(regulatorioC0922Bean, tipoLista);			
				break;
							
		}				
		return regulatorioC0922;
	}
	
	
	
	
	public List creaListaDetalle(RegulatorioC0922Bean regulatorioC0922Bean) {
		ArrayList listaDetalle = new ArrayList();
		List<String> clasfContable  		= regulatorioC0922Bean.getListClasfContable();
		List<String> nombre	 				= regulatorioC0922Bean.getListNombre();
		List<String> puesto  				= regulatorioC0922Bean.getListPuesto();
		List<String> tipoPercepcion  		= regulatorioC0922Bean.getListTipoPercepcion();
		List<String> descripcion  			= regulatorioC0922Bean.getListDescripcion();
		List<String> dato	  				= regulatorioC0922Bean.getListDato();
		
		RegulatorioC0922Bean regulatorioC0922 = null;	
		for (int i = 0; i < clasfContable.size(); i++) {
			regulatorioC0922 = new RegulatorioC0922Bean();
			
			regulatorioC0922.setAnio(regulatorioC0922Bean.getAnio());
			regulatorioC0922.setMes(regulatorioC0922Bean.getMes());
			regulatorioC0922.setClasfContable(clasfContable.get(i));
			regulatorioC0922.setNombre(nombre.get(i));
			regulatorioC0922.setPuesto(puesto.get(i));
			regulatorioC0922.setTipoPercepcion(tipoPercepcion.get(i));
			regulatorioC0922.setDescripcion(descripcion.get(i));
			regulatorioC0922.setDato(dato.get(i));
		
			listaDetalle.add(regulatorioC0922);
			
		}
		
		return listaDetalle;
		
	}
	
	/**
	 * Consulta de reporte C0922
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List <RegulatorioC0922Bean>listaReporteRegulatorioC0922(int tipoLista,int tipoEntidad, RegulatorioC0922Bean reporteBean, HttpServletResponse response){
		List<RegulatorioC0922Bean> listaReportes=null;
		
		
			switch(tipoLista){
				case Enum_Lis_ReportesC0922.excel:
					listaReportes =reporteRegulatorioC0922XLSXSOFIPO(Enum_Lis_ReportesC0922.excel,reporteBean,response); // 
					break;
				case Enum_Lis_ReportesC0922.csv:
					listaReportes = generarReporteRegulatorioC0922Sofipo(reporteBean,Enum_Lis_ReportesC0922.csv,  response); 
					break;		
			}
		

		return listaReportes;
	}
	
	private List<RegulatorioC0922Bean> reporteRegulatorioC0922XLSXSOFIPO(
			int tipoLista, RegulatorioC0922Bean reporteBean,
			HttpServletResponse response) {
		List<RegulatorioC0922Bean> listaC0922Bean = null;
		String mesEnLetras	 = "";
		String anio			 = "";
		String nombreArchivo = "";
		
		
		mesEnLetras = descripcionMes(reporteBean.getMes());
		anio	= reporteBean.getAnio();		
		
		nombreArchivo = "C_0922_"+mesEnLetras +"_"+anio; 
		
		/*Se hace la llamada para obtener la lista para llenar el reporte*/
		listaC0922Bean = regulatorioC0922DAO.reporteRegulatorioC0922Sofipo(reporteBean,tipoLista);
		
		
		if(listaC0922Bean != null){
	
			try {
				HSSFWorkbook libro = new HSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				HSSFFont fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)8);
				fuente8.setFontName(HSSFFont.FONT_ARIAL);
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				HSSFCellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				
				//Estilo negrita de 8  para encabezados del reporte
				HSSFCellStyle estiloNegro = libro.createCellStyle();
				estiloNegro.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setFont(fuenteNegrita8);
				
				//Estilo de 8  para Contenido
				HSSFCellStyle estiloNormal = libro.createCellStyle();
				HSSFDataFormat format = libro.createDataFormat();
				estiloNormal.setFont(fuente8);
				estiloNormal.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setDataFormat(format.getFormat("#,##0"));
				
				HSSFCellStyle estiloDerecha = libro.createCellStyle();
				format = libro.createDataFormat();
				estiloDerecha.setFont(fuente8);
				estiloDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				estiloDerecha.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setDataFormat(format.getFormat("#,##0"));
	
				//Estilo negrita tamaño 8 centrado
				HSSFCellStyle estiloEncabezado = libro.createCellStyle();
				estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setFont(fuenteNegrita8);
			
	
				//Estilo para una celda con dato con color de fondo gris
				HSSFCellStyle celdaGrisDato = libro.createCellStyle();
				HSSFDataFormat formato3 = libro.createDataFormat();
				celdaGrisDato.setFont(fuenteNegrita8);
				celdaGrisDato.setDataFormat(formato3.getFormat("#,##0"));
				celdaGrisDato.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				celdaGrisDato.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				celdaGrisDato.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				celdaGrisDato.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);

				
				// Creacion de hoja
				HSSFSheet hoja = libro.createSheet("Gastos de Administración y Promoción C0922");
				
				
				HSSFRow fila= hoja.createRow(0);
				fila = hoja.createRow(0);

				//Encabezados
				HSSFRow filaTitulo= hoja.createRow(0);
				HSSFCell celda=filaTitulo.createCell((short)0);
	
				
				fila = hoja.createRow(1);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("INFORMACIÓN SOLICITADA");
				celda.setCellStyle(estiloEncabezado);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            11  //ultima celda   (0-based)
			    ));
				
				
				fila = hoja.createRow(2);				
				
				
				celda = fila.createCell((short)0);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL REPORTE");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            4  //ultima celda   (0-based)
			    ));	
				
				celda = fila.createCell((short)5);
				celda.setCellValue("SECCIÓN DE LA INFORMACIÓN");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            5, //primer celda (0-based)
			            11  //ultima celda   (0-based)
			    ));				
				
				
				fila = hoja.createRow(3);
				celda = fila.createCell((short)0);
				celda.setCellValue("PERÍODO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("CLAVE DE LA FEDERACIÓN");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("CLAVE DE LA ENTIDAD");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("CLAVE NIVEL INSTITUCIÓN");				
				celda.setCellStyle(estiloEncabezado);
					
				celda = fila.createCell((short)4);
				celda.setCellValue("SUBREPORTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("NÚMERO SECUENCIA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("CLASIFICACIÓN CONTABLE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("NOMBRE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("PUESTO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("TIPO PERCEPCIÓN");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("DESCRIPCIÓN");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("DATO");
				celda.setCellStyle(estiloEncabezado);
				
				
				
						
				
				int i=4;		
				for(RegulatorioC0922Bean regC0922Bean : listaC0922Bean ){
		
					fila=hoja.createRow(i);
					
					
					celda=fila.createCell((short)0);
					celda.setCellValue(regC0922Bean.getPeriodo());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)1);
					celda.setCellValue(regC0922Bean.getClaveFederacion());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)2);
					celda.setCellValue(regC0922Bean.getClaveEntidad());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)3);
					celda.setCellValue(regC0922Bean.getNivelEntidad());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)4);
					celda.setCellValue(regC0922Bean.getReporte());
					celda.setCellStyle(estiloNormal);
					
					
					celda=fila.createCell((short)5);
					celda.setCellValue(regC0922Bean.getSecuencia());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)6);
					celda.setCellValue(regC0922Bean.getClasfContable());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)7);
					celda.setCellValue(regC0922Bean.getNombre());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)8);
					celda.setCellValue(regC0922Bean.getPuesto());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)9);
					celda.setCellValue(regC0922Bean.getTipoPercepcion());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)10);
					celda.setCellValue(regC0922Bean.getDescripcion());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)11);
					celda.setCellValue(regC0922Bean.getDato());
					celda.setCellStyle(estiloDerecha);
					
					
					
					i++;
				}
										
				hoja.autoSizeColumn(0);
				hoja.autoSizeColumn(1);
				hoja.autoSizeColumn(2);
				hoja.autoSizeColumn(3);
				hoja.autoSizeColumn(4);
				hoja.autoSizeColumn(5);
				hoja.autoSizeColumn(6);
				hoja.autoSizeColumn(7);
				hoja.autoSizeColumn(8);
				hoja.autoSizeColumn(11);
				
				
										
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
			
			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
		}
		return listaC0922Bean;
	}

	/**
	 * Genera reporte regulatorio C0922 version CSV
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generarReporteRegulatorioC0922Sofipo(RegulatorioC0922Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioC0922DAO.reporteRegulatorioC0922Csv(reporteBean, tipoReporte);
		String mesEnLetras = descripcionMes(reporteBean.getMes());
		String anio	= reporteBean.getAnio();	
		
		nombreArchivo = "C_0922_"+mesEnLetras +"_"+anio+".csv"; 
		
		try{
			RegulatorioC0922Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioC0922Bean) listaBeans.get(i);
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
	
	
	//------------getter y setter--------------
	public RegulatorioC0922DAO getRegulatorioC0922DAO() {
		return regulatorioC0922DAO;
	}
	public void setRegulatorioC0922DAO(RegulatorioC0922DAO regulatorioC0922DAO) {
		this.regulatorioC0922DAO = regulatorioC0922DAO;
	}
	
}