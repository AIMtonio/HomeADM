package ventanilla.reporte;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.GregorianCalendar;
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
import ventanilla.servicio.AbonoChequeSBCServicio;
import ventanilla.bean.AbonoChequeSBCBean;


public class RepChequesEmitidosControlador extends AbstractCommandController{
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
		  int  ReporExcel= 2 ;
	}
	
	AbonoChequeSBCServicio chequesServicio = new AbonoChequeSBCServicio ();
	String nombreReporte = null;
	String claveUsuario;
	String fechaSis;
	String institucion;
	String nombreinstitucion;
	String Sucursal;
	
	public RepChequesEmitidosControlador(){
		setCommandClass(AbonoChequeSBCBean.class);
		setCommandName("abonoChequeSBCBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
	
		AbonoChequeSBCBean reporteCheques= (AbonoChequeSBCBean) command;
		 
		ByteArrayOutputStream htmlStringPDF = null;
		
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
				
		institucion=(request.getParameter("bancoEmisor")!=null)?request.getParameter("bancoEmisor"):"";
		nombreinstitucion=(request.getParameter("nombreInstitucion")!=null)?request.getParameter("nombreInstitucion"):"";
		Sucursal=(request.getParameter("nomSucursal")!=null)?request.getParameter("nomSucursal"):"";
		claveUsuario=(request.getParameter("usuario")!=null)?request.getParameter("usuario"):"";
		fechaSis=(request.getParameter("fechaSis")!=null)?request.getParameter("fechaSis"):"";
		
		reporteCheques.setFechaCobro((request.getParameter("fechaCobro")!=null)?request.getParameter("fechaCobro"):"");
		reporteCheques.setFechaFinCobro((request.getParameter("fechaFinCobro")!=null)?request.getParameter("fechaFinCobro"):"");
		reporteCheques.setBancoEmisor((request.getParameter("bancoEmisor")!=null)?request.getParameter("bancoEmisor"):"");
		reporteCheques.setCuentaEmisor((request.getParameter("cuentaEmisor")!=null)?request.getParameter("cuentaEmisor"):"");
		reporteCheques.setNumCheque((request.getParameter("numCheque")!=null)?request.getParameter("numCheque"):"");
		reporteCheques.setEstatus((request.getParameter("estatus")!=null)?request.getParameter("estatus"):"");
		reporteCheques.setClienteID((request.getParameter("clienteID")!=null)?request.getParameter("clienteID"):"");
		reporteCheques.setSucursalID((request.getParameter("sucursalID")!=null)?request.getParameter("sucursalID"):"");
		
		
		reporteCheques.setSucursalOperacion((request.getParameter("sucMov")!=null)?request.getParameter("sucMov"):"");
		reporteCheques.setUsuarioID(claveUsuario);
		reporteCheques.setFechaAplicacion(fechaSis);
		reporteCheques.setSucursalRep(Sucursal);
		
		
		
		switch(tipoReporte){
		case Enum_Con_TipRepor.ReporPDF:
			try {
				String contentOriginal = response.getContentType();
				reporteCheques.setBancoEmisor(institucion);
				reporteCheques.setNombreEmisor(nombreinstitucion);
				htmlStringPDF = chequesServicio.reporteChequesIE(reporteCheques, nombreReporte);
				response.addHeader("Content-Disposition", "inline; filename=ReporteCheques.pdf");
				response.setContentType(contentOriginal);
				
				byte[] bytes = htmlStringPDF.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		break;
		case Enum_Con_TipRepor.ReporExcel:
			chequeSBCExcel(Enum_Con_TipRepor.ReporExcel,reporteCheques,response,request);
		break;
	}
		
		
		return null;
	}

	
	private List <AbonoChequeSBCBean> chequeSBCExcel(int tipoLista,	AbonoChequeSBCBean reporteCheque,
			HttpServletResponse response, HttpServletRequest request) {

		List  <AbonoChequeSBCBean> listaChequeSBC =null;
		String todos ="TODOS";
		String noAplica="NA";
		Calendar calendario = new GregorianCalendar();
		int hora, minutos;
		hora =calendario.get(Calendar.HOUR_OF_DAY);
		minutos = calendario.get(Calendar.MINUTE);
		
		listaChequeSBC =  chequesServicio.listaReporte(reporteCheque); 

		try {
	
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			
			HSSFFont fuente10= libro.createFont();
			fuente10.setFontHeightInPoints((short)10);

			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			
			HSSFFont fuente8= libro.createFont();
			fuente10.setFontHeightInPoints((short)8);

			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);

			HSSFCellStyle estilo10 = libro.createCellStyle();
			estilo10.setFont(fuente10);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);

			HSSFCellStyle estilo8 = libro.createCellStyle();
			estilo8.setFont(fuente8);
			
			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  

			HSSFCellStyle estiloDatosDerecha = libro.createCellStyle();
			estiloDatosDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT); 

			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);

			
			HSSFCellStyle estiloCentrado10 = libro.createCellStyle();
			estiloCentrado10.setFont(fuenteNegrita10);
			estiloCentrado10.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado10.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			
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
			HSSFSheet hoja = libro.createSheet("ReporteChequeRecibidos");
			HSSFRow fila= hoja.createRow(0);
			
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				0, //primera fila (0-based)
				0, //ultima fila  (0-based)
				0, //primer celda (0-based)
				8  //ultima celda   (0-based)
			));

			HSSFCell celdaUsu=fila.createCell((short)0);

			celdaUsu.setCellValue(reporteCheque.getSucursalOperacion());
			celdaUsu.setCellStyle(estiloCentrado10);
			
			celdaUsu = fila.createCell((short)9);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);
			celdaUsu = fila.createCell((short)10);
			celdaUsu.setCellValue( claveUsuario.toUpperCase());
			celdaUsu.setCellStyle(estilo8);
			
			fila= hoja.createRow(1);	
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					1, //primera fila (0-based)
					1, //ultima fila  (0-based)
					0, //primer celda (0-based)
					8  //ultima celda   (0-based)
				));
			celdaUsu=fila.createCell((short)0);
			celdaUsu.setCellValue("Reporte de Cheques Recibidos del "+reporteCheque.getFechaCobro()+" al "+reporteCheque.getFechaFinCobro());
			celdaUsu.setCellStyle(estiloCentrado10);
			
			HSSFCell celdaFec=fila.createCell((short)9);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)10);
			celdaFec.setCellValue(fechaSis);
			celdaFec.setCellStyle(estilo8);
			
			fila = hoja.createRow(2);
			HSSFCell celdaHora=fila.createCell((short)9);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);
			celdaHora = fila.createCell((short)10);
			celdaHora.setCellValue(hora+":"+minutos);
			
			
			fila = hoja.createRow(4);
			
			HSSFCell celdaFiltros=fila.createCell((short)0);

			
			celdaFiltros=fila.createCell((short)0);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Institución:");
			
			celdaFiltros=fila.createCell((short)1);
			celdaFiltros.setCellValue(nombreinstitucion.toUpperCase());
			celdaFiltros.setCellStyle(estilo10);	
			
			celdaFiltros=fila.createCell((short)5);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Cuenta Bancaria:");
			
			String descrip;
			if(reporteCheque.getCuentaEmisor().equals("0")){
				descrip="TODAS";
			}
			else{
				descrip=reporteCheque.getCuentaEmisor();
			}
			
			celdaFiltros=fila.createCell((short)6);
			celdaFiltros.setCellValue(descrip);
			celdaFiltros.setCellStyle(estilo10);
			

			celdaFiltros=fila.createCell((short)9);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Sucursal:");

			celdaFiltros=fila.createCell((short)10);
			celdaFiltros.setCellValue(Sucursal);
			celdaFiltros.setCellStyle(estilo10);
			
			fila = hoja.createRow(5);

			celdaFiltros=fila.createCell((short)0);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("No. Cheque:");
			
			celdaFiltros=fila.createCell((short)1);			
			celdaFiltros.setCellValue((Integer.parseInt(reporteCheque.getNumCheque())>0)?reporteCheque.getNumCheque():"TODOS");
			celdaFiltros.setCellStyle(estilo10);
			
			celdaFiltros=fila.createCell((short)5);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Socio:");
			
			celdaFiltros=fila.createCell((short)6);			
			celdaFiltros.setCellValue((Integer.parseInt(reporteCheque.getClienteID())>0)?reporteCheque.getClienteID():"TODOS");
			celdaFiltros.setCellStyle(estilo10);
			
			celdaFiltros=fila.createCell((short)9);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Estatus:");
			
			String tipo;
			if(reporteCheque.getEstatus().equals("R")){
				tipo="RECIBIDO";
				
			}else if(reporteCheque.getEstatus().equals("A")){
				tipo="APLICADO";
				
			}else if (reporteCheque.getEstatus().equals("C")){
				tipo="CANCELADO";
				
			}
			else{
				tipo="TODOS";
			}
		
			
			celdaFiltros=fila.createCell((short)10);
			celdaFiltros.setCellValue(tipo);
			celdaFiltros.setCellStyle(estilo10);
			
			
			
			fila = hoja.createRow(7);
			HSSFCell celda=fila.createCell((short)0);
			celda.setCellValue("Sucursal ID");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)1);
			celda.setCellValue("Nombre Sucursal");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)2);
			celda.setCellValue("Tipo Cheque");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)3);
			celda.setCellValue("Banco Emisor");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Nombre Banco");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Número de Cuenta");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("No. Cheque");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("No. Socio");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Nombre Socio");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)9);
			celda.setCellValue("Monto");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Fecha Recepción");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Estatus Cheque");
			celda.setCellStyle(estiloNeg8);
			
			int efila=8;
			int eCelda=0;
			int registros=0;
			
			for(AbonoChequeSBCBean reporte :listaChequeSBC){
				fila=hoja.createRow(efila);	
				
				
				celda=fila.createCell((short)0);
				celda.setCellValue(reporte.getSucursalID());
				celda=fila.createCell((short)1);
				celda.setCellValue(reporte.getNombreSucurs());
				celda=fila.createCell((short)2);
				celda.setCellValue(reporte.getTipoCheque());
				celda=fila.createCell((short)3);
				celda.setCellValue(reporte.getBancoEmisor());
				celda=fila.createCell((short)4);
				celda.setCellValue(reporte.getNombreCorto());
				celda=fila.createCell((short)5);
				celda.setCellValue(reporte.getCuentaEmisor());
				celda=fila.createCell((short)6);
				celda.setCellValue(reporte.getNumCheque());
				celda=fila.createCell((short)7);
				celda.setCellValue(reporte.getClienteID());
				celda=fila.createCell((short)8);
				celda.setCellValue(reporte.getNombreReceptor());
				celda=fila.createCell((short)9);
				celda.setCellValue(Double.parseDouble(reporte.getMonto()));
				celda.setCellStyle(estiloFormatoDecimal);
				celda=fila.createCell((short)10);
				celda.setCellValue(reporte.getFechaCobro());
				celda=fila.createCell((short)11);
				celda.setCellValue(reporte.getEstatus());
				registros++;
				efila++;
			}
			fila=hoja.createRow(efila+2);	
			celda=fila.createCell((short)0);
			celda.setCellValue("Total de Registros Exportados:");
			celda.setCellStyle(estiloNeg8);
			
			celda=fila.createCell((short)1);
			celda.setCellValue(registros);
			
			
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
			hoja.autoSizeColumn((short)13);
			
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteChequeSBC.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();


		}catch(Exception e){
			e.printStackTrace();
			System.out.println("error en el reporte de Pago de Servicios Controlador ");
		}
		return listaChequeSBC;
	} 
	

	public String getNombreReporte() {
		return nombreReporte;
	}


	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public AbonoChequeSBCServicio getChequesServicio() {
		return chequesServicio;
	}

	public void setChequesServicio(AbonoChequeSBCServicio chequesServicio) {
		this.chequesServicio = chequesServicio;
	}


}