package credito.reporte;
   
import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import herramientas.Utileria;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.servicio.ParametrosSisServicio;
import tesoreria.servicio.RepDIOTServicio.Enum_Lis_ReportesDIOT;

import credito.bean.CreditosBean;
import credito.servicio.ReporteCarteraCNBVServicio;

public class RepCarteraCNBVControlador extends AbstractCommandController  {
	
	
	ReporteCarteraCNBVServicio reporteCarteraCNBVServicio = null;
	String nomReporte= null;
	String successView = null;
	ParametrosSisServicio	parametrosSisServicio	= null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporteExcel= 1 ;
		  int  ReporteCSV= 2 ;
		}
	public RepCarteraCNBVControlador () {
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
			
	String htmlString= "";
		switch(tipoReporte){
				
			case Enum_Con_TipRepor.ReporteExcel:		
				 List<CreditosBean>listaReportes = SaldosCapitalCreditoExcel(tipoLista,creditosBean,response);
			break;
			case Enum_Con_TipRepor.ReporteCSV:
				reporteCarteraCNBVServicio.listaReportesCreditos(tipoLista,creditosBean,response); 
			break;
			}
		
			return null;
		
			
	}


	// Reporte de saldos capital de credito en excel
	public List  SaldosCapitalCreditoExcel(int tipoLista,CreditosBean creditosBean,  HttpServletResponse response){
		List listaCreditos=null;
		
		listaCreditos = reporteCarteraCNBVServicio.listaReportesCreditos(tipoLista,creditosBean,response); 	
		int regExport = 0;


			try {
				
			SXSSFWorkbook libro = new SXSSFWorkbook(100);
			
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			Font fuenteNegrita14= libro.createFont();
			fuenteNegrita14.setFontHeightInPoints((short)14);
			fuenteNegrita14.setFontName("Arial");
			fuenteNegrita14.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			Font fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Arial");
			fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			CellStyle estiloNeg14 = libro.createCellStyle();
			estiloNeg14.setFont(fuenteNegrita14);
			estiloNeg14.setAlignment((short) CellStyle.ALIGN_CENTER);
			estiloNeg14.setVerticalAlignment((short) CellStyle.VERTICAL_CENTER);
			
			//Estilo negrita de 8  para encabezados del reporte
			CellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			CellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);  
			
			CellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita10);
			estiloCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
			
			
		
			
			
			//Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimal = libro.createCellStyle();
			DataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			// Creacion de hoja
			Sheet hoja = null;
			hoja =libro.createSheet("Reporte Cartera CNBV");
						
			
			Row fila = hoja.createRow(0);
			
			Cell celdaini = fila.createCell((short) 1);
			celdaini = fila.createCell((short) 13);
			celdaini.setCellValue("Usuario:");
			celdaini.setCellStyle(estiloNeg10);
			celdaini = fila.createCell((short) 14);
			celdaini.setCellValue((!creditosBean.getNombreUsuario().isEmpty()) ? creditosBean.getNombreUsuario() : "TODOS");
			
			String fechaVar = creditosBean.getParFechaEmision();
			
			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
			
			fila = hoja.createRow(1);
			
			Cell celdafin = fila.createCell((short) 13);
			celdafin.setCellValue("Fecha:");
			celdafin.setCellStyle(estiloNeg10);
			celdafin = fila.createCell((short) 14);
			celdafin.setCellValue(fechaVar);
			
			
			Cell celdaInst = fila.createCell((short) 4);
			celdaInst.setCellValue(creditosBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			1, //primera fila (0-based)
			1, //ultima fila  (0-based)
			4, //primer celda (0-based)
			12 //ultima celda   (0-based)
			));
			celdaInst.setCellStyle(estiloNeg14);
			
			fila = hoja.createRow(2);
			Cell celdaHora = fila.createCell((short) 13);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg10);
			
			String horaVar="";
			
			 
			int hora =calendario.get(Calendar.HOUR_OF_DAY);
			int minutos = calendario.get(Calendar.MINUTE);
			int segundos = calendario.get(Calendar.SECOND);
			
			String h = Integer.toString(hora);
			String m = "";
			String s = "";
			if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
			if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);
			
				 
			horaVar= h+":"+m+":"+s;
			
			celdaHora = fila.createCell((short) 14);
			celdaHora.setCellValue(horaVar);
			
			
			CreditosBean creditoEnc = null;
			creditoEnc = (CreditosBean) listaCreditos.get(0);
					
					
			Cell celda=fila.createCell((short)4);
			celda.setCellStyle(estiloNeg14);
			celda.setCellValue("REPORTE CARTERA CNBV AL DIA "+creditoEnc.getFechaFinRep());
			
		
		    hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            4, //primer celda (0-based)
		            12  //ultima celda   (0-based)
		    ));
		    
		    
		  
			// Creacion de fila
			fila = hoja.createRow(3);
			fila = hoja.createRow(4);
			celda = fila.createCell((short) 1);
			celda.setCellValue("Sucursal:");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short) 2);
			celda.setCellValue((!creditosBean.getSucursal().equals("0") ? creditosBean.getNombreSucursal() : "TODAS"));
			
			celda = fila.createCell((short) 4);
			celda.setCellValue("Moneda:");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short) 5);
			celda.setCellValue((!creditosBean.getMonedaID().equals("0") ? creditosBean.getNombreMoneda() : "TODOS"));
			
			celda = fila.createCell((short) 7);
			celda.setCellValue("Producto Crédito:");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short) 8);
			celda.setCellValue((!creditosBean.getProducCreditoID().equals("0") ? creditosBean.getNombreProducto() : "TODOS"));
			
			celda = fila.createCell((short) 10);
			celda.setCellValue("Promotor:");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short) 11);
			celda.setCellValue((!creditosBean.getPromotorID().equals("0") ? creditosBean.getNombrePromotor() : "TODOS"));
			
			
			celda = fila.createCell((short) 13);
			celda.setCellValue("Género:");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short) 14);
			celda.setCellValue((!creditosBean.getSexo().equals("") ? creditosBean.getNombreGenero() : "TODOS"));
			
			
			fila = hoja.createRow(5);
			
			celda = fila.createCell((short) 1);
			celda.setCellValue("Estado:");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short) 2);
			celda.setCellValue((!creditosBean.getEstadoID().equals("0") ? creditosBean.getNombreEstado() : "TODOS"));
			
			celda = fila.createCell((short) 4);
			celda.setCellValue("Municipio:");
			celda.setCellStyle(estiloNeg10);
			celda = fila.createCell((short) 5);
			celda.setCellValue((!creditosBean.getMunicipioID().equals("0") ? creditosBean.getNombreMunicipi() : "TODOS"));
			
			
			fila = hoja.createRow(6);
			fila = hoja.createRow(7);
			
			
			celda = fila.createCell((short)1);
			celda.setCellValue("ClienteID");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("Nombre Completo");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("CURP");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)4);	
			celda.setCellValue("CreditoID");
			celda.setCellStyle(estiloCentrado);
			
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Sucursal");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Clasificación");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Producto Credito");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Monto Credito.");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)9);
			celda.setCellValue("Fecha Otorgamiento");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Fecha Vencimiento");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Tasa");
			celda.setCellStyle(estiloCentrado);		
			
			celda = fila.createCell((short)12);
			celda.setCellValue("Modalidad");
			celda.setCellStyle(estiloCentrado);		
			
			celda = fila.createCell((short)13);
			celda.setCellValue("Fecha Ultimo Pago Capital");
			celda.setCellStyle(estiloCentrado);	
			
			celda = fila.createCell((short)14);
			celda.setCellValue("Monto Ultimo Pago Capital");
			celda.setCellStyle(estiloCentrado);	
			
			
			celda = fila.createCell((short)15);
			celda.setCellValue("Fecha Ultimo Pago Interés");
			celda.setCellStyle(estiloCentrado);	
			
			celda = fila.createCell((short)16);
			celda.setCellValue("Monto Ultimo Pago Interés");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)17);
			celda.setCellValue("Fecha Primer Amortización no Cubierta");
			celda.setCellStyle(estiloCentrado);	
			
			celda = fila.createCell((short)18);
			celda.setCellValue("Dias Mora");
			celda.setCellStyle(estiloCentrado);	
			
			celda = fila.createCell((short)19);
			celda.setCellValue("Saldo Insoluto");
			celda.setCellStyle(estiloCentrado);	
			
			celda = fila.createCell((short)20);
			celda.setCellValue("Interés Vencido");
			celda.setCellStyle(estiloCentrado);	
			
			celda = fila.createCell((short)21);
			celda.setCellValue("Interés Moratorio");
			celda.setCellStyle(estiloCentrado);	
			
			celda = fila.createCell((short)22);
			celda.setCellValue("Interés Refinanciado o Recapitalizado");
			celda.setCellStyle(estiloCentrado);	
			
			celda = fila.createCell((short)23);
			celda.setCellValue("Tipo Acreditado");
			celda.setCellStyle(estiloCentrado);	

			celda = fila.createCell((short)24);
			celda.setCellValue("Monto EPRC");
			celda.setCellStyle(estiloCentrado);	
			
			celda = fila.createCell((short)25);
			celda.setCellValue("Monto Garantía Líquida");
			celda.setCellStyle(estiloCentrado);	
			
			celda = fila.createCell((short)26);
			celda.setCellValue("Fecha SIC");
			celda.setCellStyle(estiloCentrado);	
			
			celda = fila.createCell((short)27);
			celda.setCellValue("Tipo Cobranza");
			celda.setCellStyle(estiloCentrado);	
			
		   
			
			/*Auto Ajusto las Comulmnas*/
			Utileria.autoAjustaColumnas(27, hoja);
		
			int i=8,iter=0;
			int tamanioLista = listaCreditos.size();
			CreditosBean credito = null;
			
			tamanioLista = tamanioLista - 1;
			for( iter=0; iter<tamanioLista; iter ++){

					credito = (CreditosBean) listaCreditos.get(iter);
					fila=hoja.createRow(i);

					celda=fila.createCell((short)1);
					celda.setCellValue(credito.getClienteID());
					
					celda=fila.createCell((short)2);
					celda.setCellValue(credito.getNombreCompleto());
					
					celda=fila.createCell((short)3);
					celda.setCellValue(credito.getCURP());
					
					celda=fila.createCell((short)4);
					celda.setCellValue(credito.getCreditoID());
					
					celda=fila.createCell((short)5);
					celda.setCellValue(credito.getSucursalID());

					celda=fila.createCell((short)6);
					celda.setCellValue(credito.getClasiDestinCred());

					celda=fila.createCell((short)7);
					celda.setCellValue(credito.getProducCreditoID());
					
				
					
					celda=fila.createCell((short)8);
					celda.setCellValue(Utileria.convierteDoble(credito.getMontoCredito()));
					celda.setCellStyle(estiloFormatoDecimal);

					celda=fila.createCell((short)9);
					celda.setCellValue(credito.getFechaOtorgamiento());
					celda.setCellStyle(estiloDatosCentrado);

					celda=fila.createCell((short)10);
					celda.setCellValue(credito.getFechaVencimiento());
					celda.setCellStyle(estiloDatosCentrado);

					celda=fila.createCell((short)11);
					celda.setCellValue(credito.getTasaFija());
					celda.setCellStyle(estiloFormatoDecimal);
						
					celda=fila.createCell((short)12);
					celda.setCellValue(credito.getFormaPago());
					
					celda=fila.createCell((short)13);
					celda.setCellValue(credito.getFechaUltPagoCap());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)14);
					celda.setCellValue(Utileria.convierteDoble(credito.getMontoUltPagoCap()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)15);
					celda.setCellValue(credito.getFechaUltPagoInt());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)16);
					celda.setCellValue(Utileria.convierteDoble(credito.getMontoUltPagoInt()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)17);
					celda.setCellValue(credito.getFechaPrimerAmortCub());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)18);
					celda.setCellValue(credito.getDiasAtraso());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)19);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoInsolutoCartera()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)20);
					celda.setCellValue(Utileria.convierteDoble(credito.getInteresVencido()));
					celda.setCellStyle(estiloFormatoDecimal);					
					
					celda=fila.createCell((short)21);
					celda.setCellValue(Utileria.convierteDoble(credito.getInteresMoratorio()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)22);
					celda.setCellValue(Utileria.convierteDoble(credito.getInteresRefinanciado()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)23);
					celda.setCellValue(credito.getTipoAcreditadoRel());
					celda.setCellStyle(estiloFormatoDecimal);

					celda=fila.createCell((short)24);
					celda.setCellValue(Utileria.convierteDoble(credito.getMontoEPRC()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)25);
					celda.setCellValue(Utileria.convierteDoble(credito.getMontoGarLiq()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)26);
					celda.setCellValue(credito.getFechaConsultaSIC());
					celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)27);
					celda.setCellValue(credito.getTipoCobranza());
					celda.setCellStyle(estiloDatosCentrado);
						
					
				i++;
			}
			 
			i = i+2;
			fila=hoja.createRow(i);
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg10);
			
			i = i+1;
			fila=hoja.createRow(i);
			celda=fila.createCell((short)0);
			celda.setCellValue(tamanioLista);
				
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteCarteraCNBV.xlsx");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
						
			}catch(Exception e){
				e.printStackTrace();
			}
		return  listaCreditos;
		
		
		}

	
	
	
	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	
	public ReporteCarteraCNBVServicio getReporteCarteraCNBVServicio() {
		return reporteCarteraCNBVServicio;
	}

	public void setReporteCarteraCNBVServicio(
			ReporteCarteraCNBVServicio reporteCarteraCNBVServicio) {
		this.reporteCarteraCNBVServicio = reporteCarteraCNBVServicio;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
	
	
	

}
