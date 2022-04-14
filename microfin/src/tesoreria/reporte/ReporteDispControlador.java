package tesoreria.reporte;

import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

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
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.ReporteMinistraBean;
import tesoreria.servicio.OperDispersionServicio;
import tesoreria.bean.DispersionBean;
import tesoreria.bean.ReporteDispersionBean;


public class ReporteDispControlador extends AbstractCommandController {
	OperDispersionServicio operDispersionServicio = null;
	String nombreReporte = null;
	String successView = null;		

	public static interface Enum_Con_TipRepor {
		  int  ReporPantalla= 1 ;
		  int  ReporPDF= 2 ;
		  int  ReporExcel= 3 ;
	}
	public ReporteDispControlador(){
		setCommandClass(DispersionBean.class);
		setCommandName("dispBean");
	}
   
	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		DispersionBean dispersionBean = (DispersionBean) command;
		 
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):0;
	
		int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):0;
			
		//	operDispersionServicio.getOperDispersionDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			String htmlString= "";
			
				switch(tipoReporte){
				case Enum_Con_TipRepor.ReporPantalla:
					 htmlString = operDispersionServicio.reporteDispPantalla(dispersionBean, nombreReporte);
				break;
					
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = reporteDispersionPDF(dispersionBean, nombreReporte, response);
				break;
					
				case Enum_Con_TipRepor.ReporExcel:		
					 List listaReportes = reporteDispersionesExcel(tipoLista,dispersionBean,response);
				break;
			}
				
				if(tipoReporte ==Enum_Con_TipRepor.ReporPantalla ){
					return new ModelAndView(getSuccessView(), "reporte", htmlString);
				}else {
					return null;
				}
	}
	
	
// Reporte  de  ministraciones  en PDF
	public ByteArrayOutputStream reporteDispersionPDF(DispersionBean dispersionBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = operDispersionServicio.reporteDispersionPDF(dispersionBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteDispersion.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	return htmlStringPDF;
	}
	@SuppressWarnings("deprecation")
	public List reporteDispersionesExcel(int tipoLista,DispersionBean dispersionBean,HttpServletResponse response){
		List listaDispersiones=null;
		
		listaDispersiones= operDispersionServicio.listaRepDispersionExcel(tipoLista, dispersionBean, response);
		
		int regExport = 0;
		
		try{
			
			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
			String hora = postFormater.format(calendario.getTime());
			
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
			estiloNeg10.setAlignment(CellStyle.ALIGN_CENTER);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
			
			//Estilo negrita de 8  y color de fondo
			HSSFCellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			
			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			HSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			//centrado
			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			// Creacion de hoja
			HSSFSheet hoja = libro.createSheet("Reporte de Dispersiones");
			HSSFRow fila= hoja.createRow(0);
			HSSFCell celdaUsu=fila.createCell((short)1);
			//
			celdaUsu = fila.createCell((short)12);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)13);
			celdaUsu.setCellValue((!dispersionBean.getNomUsuario().isEmpty())?dispersionBean.getNomUsuario(): "TODOS");
			
			String fechaVar=dispersionBean.getFechaEmision();
			
			fila = hoja.createRow(1);
			HSSFCell celdaFec=fila.createCell((short)1);
			celdaFec = fila.createCell((short)12);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)13);
			celdaFec.setCellValue(fechaVar);
			
			
			
			HSSFCell celdaInst=fila.createCell((short)1);
			celdaInst.setCellStyle(estiloNeg10);
			celdaInst.setCellValue(dispersionBean.getNomInstitucion());
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					1, //primera fila (0-based)
					1, //ultima fila  (0-based)
					1, //primer celda (0-based)
					11 //ultima celda   (0-based)
					));
			
			//
			fila = hoja.createRow(2);
			HSSFCell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)12);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)13);
			celdaHora.setCellValue(hora);
						
			HSSFCell celda=fila.createCell((short)1);
			celda.setCellStyle(estiloNeg10);
			
			celda.setCellValue("REPORTE DE DISPERSIONES DEL "+dispersionBean.getFechaInicio()+" AL "+dispersionBean.getFechaFin());
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					2, //primera fila (0-based)
					2, //ultima fila  (0-based)
					1, //primer celda (0-based)
					11 //ultima celda   (0-based)
					));
			
			fila=hoja.createRow(4);
			HSSFCell celdaParametros=fila.createCell((short)1);
			celdaParametros.setCellValue("Est. Dispersión:");
			celdaParametros.setCellStyle(estiloNeg8);
			HSSFCell celdaValor=fila.createCell((short)2);
			celdaValor.setCellValue((!dispersionBean.getEstatusEnc().isEmpty())?dispersionBean.getEstatusEnc():"TODAS");

			//		Inistitucion
			celdaParametros=fila.createCell((short)4);
			celdaParametros.setCellValue("Institución:");
			celdaParametros.setCellStyle(estiloNeg8);
			celdaValor=fila.createCell((short)5);
			celdaValor.setCellValue((!dispersionBean.getNomInstitucionID().isEmpty())?dispersionBean.getNomInstitucionID():"TODAS");

			// Cuenta bancaria
			celdaParametros=fila.createCell((short)9);
			celdaParametros.setCellValue("Sucursal:");
			celdaParametros.setCellStyle(estiloNeg8);
			celdaValor=fila.createCell((short)10);
			celdaValor.setCellValue((!dispersionBean.getNomSucursal().isEmpty())?dispersionBean.getNomSucursal():"TODAS");
			
			
			fila=hoja.createRow(5);
			//Estatus Movs
			celdaParametros=fila.createCell((short)1);
			celdaParametros.setCellValue("Est. Movimientos:");
			celdaParametros.setCellStyle(estiloNeg8);
			celdaValor=fila.createCell((short)2);
			celdaValor.setCellValue((!dispersionBean.getEstatusDet().isEmpty())?dispersionBean.getEstatusDet():"TODAS");
			
			//Estatus Cuenta
			celdaParametros=fila.createCell((short)4);
			celdaParametros.setCellValue("Cuenta");
			celdaParametros.setCellStyle(estiloNeg8);
			celdaValor=fila.createCell((short)5);
			celdaValor.setCellValue((!dispersionBean.getCuentaAhorro().equals(0))?dispersionBean.getCuentaAhorro():"TODAS");
			
			//Estatus Cuenta
			if(!dispersionBean.getNomFormaPago().equals("")){
			celdaParametros=fila.createCell((short)9);
			celdaParametros.setCellValue("Forma de Pago:");
			celdaParametros.setCellStyle(estiloNeg8);
			celdaValor=fila.createCell((short)10);
			celdaValor.setCellValue((!dispersionBean.getFormaPagoID().equals(0))?dispersionBean.getNomFormaPago():"TODAS");
			}
			//Encabezados columnas
			fila=hoja.createRow(6);
			fila=hoja.createRow(7);
			
			
			// Cuenta Cargo
			celda = fila.createCell((short)1);
			celda.setCellValue("Cuenta Cargo");
			celda.setCellStyle(estiloCentrado);
			
			//Cliente
			celda = fila.createCell((short)2);
			celda.setCellValue("Cliente");
			celda.setCellStyle(estiloCentrado);
			
			//Numero poliza
			celda = fila.createCell((short)3);
			celda.setCellValue("Número de Póliza");
			celda.setCellStyle(estiloCentrado);
			
			//Referencia
			celda = fila.createCell((short)4);
			celda.setCellValue("Referencia");
			celda.setCellStyle(estiloCentrado);
			
			//Descripcion
			celda = fila.createCell((short)5);
			celda.setCellValue("Descripción");
			celda.setCellStyle(estiloCentrado);
			
			//FormaPago
			celda = fila.createCell((short)6);
			celda.setCellValue("Forma Pago");
			celda.setCellStyle(estiloCentrado);
			
			//Concepto
			celda = fila.createCell((short)7);
			celda.setCellValue("Concepto");
			celda.setCellStyle(estiloCentrado);
			
			//Monto
			celda = fila.createCell((short)8);
			celda.setCellValue("Monto");
			celda.setCellStyle(estiloCentrado);
			
			//Num cuenta cheques
			celda = fila.createCell((short)9);
			celda.setCellValue("Núm. de Cheque	Núm. Tarjeta/Cta Cheques");
			celda.setCellStyle(estiloCentrado);
			
				
			//Nombre Beneficiario
			celda = fila.createCell((short)10);
			celda.setCellValue("Nombre Beneficiario");
			celda.setCellStyle(estiloCentrado);
			
			//Estatus
			celda = fila.createCell((short)11);
			celda.setCellValue("Estatus");
			celda.setCellStyle(estiloCentrado);
			
			//Estatus Referencia
			if(!dispersionBean.getNomFormaPago().equals("")){
				celda = fila.createCell((short)12);
				celda.setCellValue("Estatus referencia");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)13);
				celda.setCellValue("Estatus Tran. Santander");
				celda.setCellStyle(estiloCentrado);
			}
			fila=hoja.createRow(8);
			int i=8;
			//iterar entre los resultados de la consulta
			int tamanioLista=listaDispersiones.size();
			int iter=0;
			ReporteDispersionBean reporteDispersionBean=null;
			for(iter=0; iter<tamanioLista; iter ++ ){
				reporteDispersionBean= (ReporteDispersionBean)listaDispersiones.get(iter);
				fila=hoja.createRow(i);
				
				celda=fila.createCell((short)1);
				celda.setCellValue(reporteDispersionBean.getCuentaCargo());
				
				celda=fila.createCell((short)2);
				celda.setCellValue(reporteDispersionBean.getNombreCompleto());
				
				celda=fila.createCell((short)3);
				celda.setCellValue(reporteDispersionBean.getPolizaID());
				
				celda=fila.createCell((short)4);
				celda.setCellValue(reporteDispersionBean.getReferencia());
				
				celda=fila.createCell((short)5);
				celda.setCellValue(reporteDispersionBean.getDescriMov());
				
				celda=fila.createCell((short)6);
				celda.setCellValue(reporteDispersionBean.getFormaPago());
				
				celda=fila.createCell((short)7);
				celda.setCellValue(reporteDispersionBean.getConcepto());
				
				celda=fila.createCell((short)8);
				celda.setCellValue(reporteDispersionBean.getMonto());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)9);
				celda.setCellValue(reporteDispersionBean.getCuentaDestino());
				
				celda=fila.createCell((short)10);
				celda.setCellValue(reporteDispersionBean.getNombreBenefi());
				
				celda=fila.createCell((short)11);
				celda.setCellValue(reporteDispersionBean.getEstatusDet());
				
				if(!dispersionBean.getNomFormaPago().equals("")){
					celda=fila.createCell((short)12);
					celda.setCellValue((reporteDispersionBean.getEstatusRef()!=null?reporteDispersionBean.getEstatusRef():""));
					
					celda=fila.createCell((short)13);
					celda.setCellValue((reporteDispersionBean.getEstatusTranSan()!=null?reporteDispersionBean.getEstatusTranSan():""));
				}
				
				i++;
				
			}
			i = i+2;
			fila=hoja.createRow(i);
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);
			
			i = i+1;
			fila=hoja.createRow(i);
			celda=fila.createCell((short)0);
			celda.setCellValue(tamanioLista);
			

			for(int celd=0; celd<=21; celd++)
			hoja.autoSizeColumn((short)celd);

			
			
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteDispersiones.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		return listaDispersiones;
	}

	public void setOperDispersionServicio(OperDispersionServicio operDispersionServicio ) {
		this.operDispersionServicio = operDispersionServicio;
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

