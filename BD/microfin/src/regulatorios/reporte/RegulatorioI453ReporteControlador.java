package regulatorios.reporte;

import herramientas.Utileria;

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

import regulatorios.bean.RegulatorioBean;
import regulatorios.servicio.RegulatorioA2112Servicio;
import regulatorios.servicio.RegulatorioA2112Servicio.Enum_Lis_ReportesA2112;
import regulatorios.bean.DesagregadoCarteraC0451Bean;

import regulatorios.bean.RegulatorioI453Bean;
import regulatorios.dao.RegulatorioI453DAO;
import regulatorios.servicio.RegulatorioI453Servicio;


public class RegulatorioI453ReporteControlador extends AbstractCommandController{
	RegulatorioI453Servicio regulatorioI453Servicio = null;
	String successView = null;
		
	public RegulatorioI453ReporteControlador () {
		setCommandClass(RegulatorioI453Bean.class);
		setCommandName("regulatorioI453Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		RegulatorioI453Bean reporteBean = (RegulatorioI453Bean) command;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
		
		switch(tipoReporte)	{
			case Enum_Lis_ReportesA2112.excel:		
				reporteRegulatorioI453(tipoReporte,reporteBean,response);
				break;
			case Enum_Lis_ReportesA2112.csv:
				regulatorioI453Servicio.listaReporteRegulatorioI453(tipoReporte, reporteBean, response); ;
		}
		return null;	
	}


	/**
	 * Generacion de reporte I0453 en Excel
	 * 
	 * @param tipoReporte
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List  reporteRegulatorioI453(int tipoReporte,RegulatorioI453Bean reporteBean,  HttpServletResponse response){
		List<RegulatorioI453Bean> listaRepote = null;
		listaRepote = regulatorioI453Servicio.listaReporteRegulatorioI453(tipoReporte, reporteBean,response);
		String mesEnLetras	= "";
		String anio		= "";
		String nombreArchivo = "";
		
		mesEnLetras = regulatorioI453Servicio.descripcionMes(reporteBean.getMes());
		anio	= reporteBean.getAnio();
		nombreArchivo = "R04_I_453_"+mesEnLetras +"_"+anio; 

		try {
			HSSFWorkbook libro = new HSSFWorkbook();
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuente8= libro.createFont();
			fuente8.setFontHeightInPoints((short)8);
			
			//Estilo de 8  para Contenido
			HSSFCellStyle estilo8 = libro.createCellStyle();
			estilo8.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
			estilo8.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
			estilo8.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
			estilo8.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
			estilo8.setFont(fuente8);
			
			
			//Estilo Formato Tasa (0.0000)
			HSSFCellStyle estiloFormatoTasa = libro.createCellStyle();
			HSSFDataFormat format = libro.createDataFormat();
			estiloFormatoTasa.setDataFormat(format.getFormat("0.0000"));
			estiloFormatoTasa.setFont(fuente8);
			
			//Estilo negrita tamaño 8 centrado
			HSSFCellStyle estiloEncabezado = libro.createCellStyle();
			estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setFont(fuenteNegrita8);
			
			// Creacion de hoja
			HSSFSheet hoja = libro.createSheet("R04 I 453");
			HSSFRow fila = hoja.createRow(0);
			fila = hoja.createRow(0);				
			HSSFCell celda=fila.createCell((short)1);

			//Titulos del Reporte
			fila = hoja.createRow(0);
			celda=fila.createCell((short)0);
			celda.setCellValue("PERIODO QUE \nSE REPORTA");
			celda.setCellStyle(estiloEncabezado);

			celda=fila.createCell((short)1);
			celda.setCellValue("CLAVE DE LA \nENTIDAD");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)2);
			celda.setCellValue("SUBREPORTE");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)3);
			celda.setCellValue("IDENTIFICADOR DEL \nACREDITADO ASIGNADO\nPOR LA SOCIEDAD");
			celda.setCellStyle(estiloEncabezado);

			celda=fila.createCell((short)4);
			celda.setCellValue("PERSONALIDAD\nJURÍDICA");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)5);
			celda.setCellValue("NOMBRE, RAZÓN O\n DENOMINACIÓN SOCIAL\nDEL SOCIO O SOCAP");
			celda.setCellStyle(estiloEncabezado);

			celda=fila.createCell((short)6);
			celda.setCellValue("PRIMER APELLIDO\nDEL SOCIO");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)7);
			celda.setCellValue("SEGUNDO APELLIDO\nDEL SOCIO");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)8);
			celda.setCellValue("RFC DEL\nACREDITADO");
			celda.setCellStyle(estiloEncabezado);

			celda=fila.createCell((short)9);
			celda.setCellValue("CURP DEL ACREDITADO\nSI ES PERSONA FÍSICA");
			celda.setCellStyle(estiloEncabezado);

			celda=fila.createCell((short)10);
			celda.setCellValue("GÉNERO DEL\nSOCIO O CLIENTE");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)11);
			celda.setCellValue("IDENTIFICADOR DEL\nCRÉDITO ASIGNADO\nPOR LA SOCIEDAD");
			celda.setCellStyle(estiloEncabezado);

			celda=fila.createCell((short)12);
			celda.setCellValue("SUCURSAL QUE\nOPERA EL CRÉDITO");
			celda.setCellStyle(estiloEncabezado);

			celda=fila.createCell((short)13);
			celda.setCellValue("CLASIFICACIÓN DEL\nCRÉDITO POR DESTINO");
			celda.setCellStyle(estiloEncabezado);

			celda=fila.createCell((short)14);
			celda.setCellValue("PRODUCTO DE CRÉDITO");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)15);
			celda.setCellValue("FECHA DE DISPOSICIÓN\nDEL CRÉDITO");
			celda.setCellStyle(estiloEncabezado);

			celda=fila.createCell((short)16);
			celda.setCellValue("FECHA DE VENCIMIENTO\nDEL CRÉDITO");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)17);  
			celda.setCellValue("MODALIDAD\nDE PAGO");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)18);   
			celda.setCellValue("MONTO\nORIGINAL");
			celda.setCellStyle(estiloEncabezado);

			celda=fila.createCell((short)19);  
			celda.setCellValue("FECHA DEL ÚLTIMO\nPAGO CAPITAL");
			celda.setCellStyle(estiloEncabezado);

			celda=fila.createCell((short)20);  
			celda.setCellValue("MONTO DEL ÚLTIMO\nPAGO CAPITAL");
			celda.setCellStyle(estiloEncabezado);

			celda=fila.createCell((short)21);  
			celda.setCellValue("FECHA DEL ÚLTIMO\nPAGO INTERESES");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)22);  
			celda.setCellValue("MONTO DEL ÚLTIMO\nPAGO DE INTERESES");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)23);  
			celda.setCellValue("FECHA DE LA PRIMERA\nAMORTIZACIÓN NO CUBIERTA");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)24);  
			celda.setCellValue("DÍAS DE MORA\n(RETRASO)");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)25);  
			celda.setCellValue("TIPO DE\nCRÉDITO");
			celda.setCellStyle(estiloEncabezado);

			celda=fila.createCell((short)26);   
			celda.setCellValue("CAPITAL");
			celda.setCellStyle(estiloEncabezado);

			celda=fila.createCell((short)27);   
			celda.setCellValue("INTERESES\nORDINARIOS");
			celda.setCellStyle(estiloEncabezado);

			celda=fila.createCell((short)28);  
			celda.setCellValue("INTERESES\nMORATORIOS");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)29);
			celda.setCellValue("INTERESES REFINANCIADOS\nO INTERESES RECAPITALIZADOS");
			celda.setCellStyle(estiloEncabezado);

			celda=fila.createCell((short)30);
			celda.setCellValue("MONTO DEL\nCASTIGO");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)31);
			celda.setCellValue("MONTO DE LA\nCONDONACIÓN,QUITA,\nBONIFICACIÓN O DESCUENTO");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)32);
			celda.setCellValue("BONIFICACIÓN\nO DESCUENTO");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)33);
			celda.setCellValue("FECHA DEL\nCASTIGO");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)34);
			celda.setCellValue("TIPO DE ACREDITADO\nRELACIONADO");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)35);
			celda.setCellValue("ESTIMACIONES PREVENTIVAS\nTOTALES");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)36);
			celda.setCellValue("CLAVE DE\nPREVENCIÓN");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)37);
			celda.setCellValue("FECHA DE LA\nCONSULTA A LA SIC");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)38);
			celda.setCellValue("TIPO DE\nCOBRANZA");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)39);
			celda.setCellValue("GARANTÍA\nLÍQUIDA");
			celda.setCellStyle(estiloEncabezado);
			
			celda=fila.createCell((short)40);
			celda.setCellValue("GARANTÍA\nHIPOTECARIA");
			celda.setCellStyle(estiloEncabezado);
			
			fila.setHeight((short)800);

			int i=1;
			for(RegulatorioI453Bean regI0453Bean : listaRepote ){
	
				fila=hoja.createRow(i);
				celda=fila.createCell((short)0);
				celda.setCellValue(regI0453Bean.getPeriodo());
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)1);
				celda.setCellValue(regI0453Bean.getClaveEntidad());
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)2);
				celda.setCellValue(regI0453Bean.getFormulario());
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)3);
				celda.setCellValue(regI0453Bean.getClienteID());
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)4);
				celda.setCellValue(Integer.parseInt(regI0453Bean.getTipoPersona()));
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)5);
				celda.setCellValue(regI0453Bean.getDenominacion());
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)6);
				celda.setCellValue(regI0453Bean.getApellidoPat());
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)7);
				celda.setCellValue(regI0453Bean.getApellidoMat());
				celda.setCellStyle(estilo8);
				//Long.parseLong(Utileria.eliminaDecimales(regI0453Bean.getSaldoTotal()))
				celda=fila.createCell((short)8);
				celda.setCellValue(regI0453Bean.getRfc());
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)9);
				celda.setCellValue(regI0453Bean.getCurp());
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)10);
				celda.setCellValue(regI0453Bean.getGenero());
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)11);
				celda.setCellValue(Long.parseLong(regI0453Bean.getCreditoID()));
				celda.setCellStyle(estilo8);	

				celda=fila.createCell((short)12);
				celda.setCellValue(regI0453Bean.getClaveSucursal());										
				celda.setCellStyle(estiloFormatoTasa);
				
				celda=fila.createCell((short)13);
				celda.setCellValue(regI0453Bean.getClasifConta());
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)14);
				celda.setCellValue(regI0453Bean.getProductoCredito());
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)15);
				celda.setCellValue(regI0453Bean.getFechaDisp());
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)16);
				celda.setCellValue(regI0453Bean.getFechaVencim());
				celda.setCellStyle(estilo8);	
				
				celda=fila.createCell((short)17);
				celda.setCellValue(Integer.parseInt(regI0453Bean.getTipoAmorti()));
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)18);
				celda.setCellValue(Double.parseDouble(regI0453Bean.getMontoCredito()));
				celda.setCellStyle(estilo8);	
				
				celda=fila.createCell((short)19);
				celda.setCellValue(regI0453Bean.getFecUltPagoCap());
				celda.setCellStyle(estilo8);	

				celda=fila.createCell((short)20);
				celda.setCellValue(Double.parseDouble(regI0453Bean.getMonUltPagoCap()));
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)21);
				celda.setCellValue(regI0453Bean.getFecUltPagoInt());
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)22);
				celda.setCellValue(Double.parseDouble(regI0453Bean.getMonUltPagoInt()));
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)23);
				celda.setCellValue(regI0453Bean.getFecPrimAtraso());
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)24);
				celda.setCellValue(Integer.parseInt(regI0453Bean.getNumDiasAtraso()));
				celda.setCellStyle(estilo8);
									
				celda=fila.createCell((short)25);
				celda.setCellValue(regI0453Bean.getTipoCredito());
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)26);
				celda.setCellValue(Double.parseDouble(regI0453Bean.getSalCapital()));
				celda.setCellStyle(estilo8);

				celda=fila.createCell((short)27);
				celda.setCellValue(Double.parseDouble(regI0453Bean.getSalIntOrdin()));
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)28);
				celda.setCellValue(Double.parseDouble(regI0453Bean.getSalIntMora()));
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)29);
				celda.setCellValue(Double.parseDouble(regI0453Bean.getIntereRefinan()));
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)30);
				celda.setCellValue(Double.parseDouble(regI0453Bean.getMontoCastigo()));
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)31);
				celda.setCellValue(Double.parseDouble(regI0453Bean.getMontoCondona()));
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)32);
				celda.setCellValue(Double.parseDouble(regI0453Bean.getMontoBonifi()));
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)33);
				celda.setCellValue(regI0453Bean.getFechaCastigo());
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)34);
				celda.setCellValue(Integer.parseInt(regI0453Bean.getTipoRelacion()));
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)35);
				celda.setCellValue(Double.parseDouble(regI0453Bean.getePRCTotal()));
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)36);
				celda.setCellValue(regI0453Bean.getClaveSIC());
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)37);
				celda.setCellValue(regI0453Bean.getFecConsultaSIC());
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)38);
				celda.setCellValue(Integer.parseInt(regI0453Bean.getTipoCobranza()));
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)39);
				celda.setCellValue(Double.parseDouble(regI0453Bean.getTotGtiaLiquida()));
				celda.setCellStyle(estilo8);
				
				celda=fila.createCell((short)40);
				celda.setCellValue(Double.parseDouble(regI0453Bean.getGtiaHipotecaria()));
				celda.setCellStyle(estilo8);
				
				
				
				i++;
			}
			
			for(int pos = 0 ; pos < 40 ; pos++){
				hoja.autoSizeColumn((short)pos);
			}
					
									
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();

		} catch (Exception e) {
			e.printStackTrace();
		}// Fin del catch
		return listaRepote;
	}

	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public RegulatorioI453Servicio getRegulatorioI453Servicio() {
		return regulatorioI453Servicio;
	}

	public void setRegulatorioI453Servicio(
			RegulatorioI453Servicio regulatorioI453Servicio) {
		this.regulatorioI453Servicio = regulatorioI453Servicio;
	}
	
}