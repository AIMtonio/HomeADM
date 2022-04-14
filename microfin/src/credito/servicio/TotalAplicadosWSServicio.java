package credito.servicio;

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
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.extensions.XSSFCellBorder.BorderSide;
import org.jfree.report.style.BorderStyle;

import credito.bean.SeguroVidaBean;
import credito.bean.TotalAplicadosWSBean;
import credito.dao.TotalAplicadosWSDAO;
import credito.servicio.SeguroVidaServicio.Enum_Lis_SeguroVida;
import general.servicio.BaseServicio;

public class TotalAplicadosWSServicio extends BaseServicio{

	TotalAplicadosWSDAO totalAplicadosWSDAO = null;
	
	public TotalAplicadosWSServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public static interface Enum_Rep_TotalAplicadosWS {
		int excel 				= 1;
	}
	
	public List lista(int tipoLista, TotalAplicadosWSBean totalAplicadosWSBean){		
		List listaWS = null;
		switch (tipoLista) {
			case Enum_Rep_TotalAplicadosWS.excel:		
				listaWS = totalAplicadosWSDAO.totalAplicadoRep(totalAplicadosWSBean, tipoLista);				
				break;	
			
		}		
		return listaWS;
	}
	
	public void generaReporteExcel(int tipoLista, TotalAplicadosWSBean totalAplicadosWSBean,
									HttpServletResponse response, HttpServletRequest request){
		
		List<TotalAplicadosWSBean> listaresult = null;
		listaresult = lista(tipoLista, totalAplicadosWSBean);
		
		try {
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);

			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);

			HSSFFont fuente8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);

			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);

			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
			estiloDatosCentrado.setFont(fuenteNegrita10);
			estiloDatosCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);

			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuente8);
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
			
			HSSFCellStyle estiloNegCentradoBorde = libro.createCellStyle();
			estiloNegCentradoBorde.setFont(fuenteNegrita8);
			estiloNegCentradoBorde.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloNegCentradoBorde.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			estiloNegCentradoBorde.setBorderBottom(HSSFCellStyle.BORDER_HAIR);
			estiloNegCentradoBorde.setBorderLeft(HSSFCellStyle.BORDER_HAIR);
			estiloNegCentradoBorde.setBorderRight(HSSFCellStyle.BORDER_HAIR);
			estiloNegCentradoBorde.setBorderTop(HSSFCellStyle.BORDER_HAIR);
			
			HSSFCellStyle estilo8Izq = libro.createCellStyle();
			estilo8Izq.setFont(fuente8);
			estilo8Izq.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			
			HSSFCellStyle estiloNeg8Der = libro.createCellStyle();
			estiloNeg8Der.setFont(fuenteNegrita8);
			estiloNeg8Der.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			// Creacion de hoja
			HSSFSheet hoja = libro.createSheet("Reporte Total Aplicados");
			HSSFRow fila= hoja.createRow(0);
		  	// inicio fecha, usuario,institucion y hora
			HSSFCell celdaUsu=fila.createCell((short)1);
			celdaUsu = fila.createCell((short)28);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)29);
			celdaUsu.setCellValue(request.getParameter("usuario"));

			fila = hoja.createRow(1);
			HSSFCell celdaFec=fila.createCell((short)1);
		  	celdaFec = fila.createCell((short)28);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)29);
			celdaFec.setCellValue(request.getParameter("fechaSis"));
			
			HSSFCell celdaInst=fila.createCell((short)1);
			celdaInst=fila.createCell((short)3);
			celdaInst.setCellValue(request.getParameter("nombreInstitucion"));
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            3, //primer celda (0-based)
			            27  //ultima celda (0-based)
			    ));
			 celdaInst.setCellStyle(estiloDatosCentrado);

			Calendar calendario = new GregorianCalendar();
			fila = hoja.createRow(2);
			HSSFCell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)28);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);
			
			celdaHora = fila.createCell((short)29);
			celdaHora.setCellValue(calendario.get(Calendar.HOUR_OF_DAY) + ":" + calendario.get(Calendar.MINUTE) + ":" + calendario.get(Calendar.SECOND));
			// fin fecha usuario,institucion y hora
			  
			HSSFCell celdaTit=fila.createCell((short)1);
			celdaTit = fila.createCell((short)3);
			celdaTit.setCellValue("REPORTE DE TOTAL APLICADO A TRAVÉS DE WS DE PAGO DEL "+totalAplicadosWSBean.getFechaInicial()+" AL "+totalAplicadosWSBean.getFechaFin());
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            3, //primer celda (0-based)
		            27  //ultima celda (0-based)
		    ));
			celdaTit.setCellStyle(estiloDatosCentrado);
			
			fila = hoja.createRow(3);
			fila = hoja.createRow(4);
			
			HSSFCell celdaInstnomina=fila.createCell((short)9);
			celdaInstnomina.setCellValue("Institución de Nómina: ");
			celdaInstnomina.setCellStyle(estiloNeg8Der);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            4, //primera fila (0-based)
		            4, //ultima fila  (0-based)
		            9, //primer celda (0-based)
		            10  //ultima celda (0-based)
		    ));
			celdaInstnomina=fila.createCell((short)11);
			celdaInstnomina.setCellValue(totalAplicadosWSBean.getInstitNominaID()+"-"+totalAplicadosWSBean.getInstitNomina());
			celdaInstnomina.setCellStyle(estilo8Izq);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            4, //primera fila (0-based)
		            4, //ultima fila  (0-based)
		            11, //primer celda (0-based)
		            18  //ultima celda (0-based)
		    ));
			
			HSSFCell celdaConvenio=fila.createCell((short)19);
			celdaConvenio.setCellValue("Convenio de Nómina: ");
			celdaConvenio.setCellStyle(estiloNeg8);
			celdaConvenio.setCellStyle(estiloNeg8Der);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            4, //primera fila (0-based)
		            4, //ultima fila  (0-based)
		            19, //primer celda (0-based)
		            20  //ultima celda (0-based)
		    ));
			
			celdaConvenio=fila.createCell((short)21);
			celdaConvenio.setCellValue(totalAplicadosWSBean.getConvenioNominaID()+"-"+totalAplicadosWSBean.getNombreConvenio());
			celdaConvenio.setCellStyle(estilo8Izq);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            4, //primera fila (0-based)
		            4, //ultima fila  (0-based)
		            21, //primer celda (0-based)
		            29  //ultima celda (0-based)
		    ));
			fila = hoja.createRow(5);
			fila = hoja.createRow(6);
			
			//Fila 6
			HSSFCell celdaCabecera = fila.createCell((short)1);
			celdaCabecera.setCellValue("Datos del Crédito");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            6, //primera fila (0-based)
		            6, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            5  //ultima celda (0-based)
		    ));
			
			celdaCabecera = fila.createCell((short)6);
			celdaCabecera.setCellValue("Datos del Cliente");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            6, //primera fila (0-based)
		            6, //ultima fila  (0-based)
		            6, //primer celda (0-based)
		            8  //ultima celda (0-based)
		    ));
			
			celdaCabecera = fila.createCell((short)9);
			celdaCabecera.setCellValue("Datos de la Cuenta Operativa");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            6, //primera fila (0-based)
		            6, //ultima fila  (0-based)
		            9, //primer celda (0-based)
		            12  //ultima celda (0-based)
		    ));
			
			celdaCabecera = fila.createCell((short)13);
			celdaCabecera.setCellValue("Datos de la Domiciliación");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            6, //primera fila (0-based)
		            6, //ultima fila  (0-based)
		            13, //primer celda (0-based)
		            14  //ultima celda (0-based)
		    ));
			
			celdaCabecera = fila.createCell((short)15);
			celdaCabecera.setCellValue("Detalles del Pago al Crédito");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            6, //primera fila (0-based)
		            6, //ultima fila  (0-based)
		            15, //primer celda (0-based)
		            23  //ultima celda (0-based)
		    ));
			
			celdaCabecera = fila.createCell((short)24);
			celdaCabecera.setCellValue("");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)25);
			celdaCabecera.setCellValue("");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)26);
			celdaCabecera.setCellValue("Datos del Banco");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            6, //primera fila (0-based)
		            6, //ultima fila  (0-based)
		            26, //primer celda (0-based)
		            27  //ultima celda (0-based)
		    ));
			
			celdaCabecera = fila.createCell((short)28);
			celdaCabecera.setCellValue("");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            6, //primera fila (0-based)
		            6, //ultima fila  (0-based)
		            28, //primer celda (0-based)
		            29  //ultima celda (0-based)
		    ));
			
			fila = hoja.createRow(7);
			
			celdaCabecera = fila.createCell((short)0);
			celdaCabecera.setCellValue("Fecha Pago");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)1);
			celdaCabecera.setCellValue("Producto");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)2);
			celdaCabecera.setCellValue("Movimiento");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)3);
			celdaCabecera.setCellValue("No. Crédito");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)4);
			celdaCabecera.setCellValue("Institución de Nómina");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)5);
			celdaCabecera.setCellValue("Convenio");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)6);
			celdaCabecera.setCellValue("No. Cliente");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)7);
			celdaCabecera.setCellValue("Nombre Cliente");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)8);
			celdaCabecera.setCellValue("RFC");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)9);
			celdaCabecera.setCellValue("Cuenta Operativa");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)10);
			celdaCabecera.setCellValue("Saldo Disponible");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)11);
			celdaCabecera.setCellValue("Saldo Bloqueado");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)12);
			celdaCabecera.setCellValue("Saldo Total");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)13);
			celdaCabecera.setCellValue("Institución");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)14);
			celdaCabecera.setCellValue("Cuenta CLABE");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)15);
			celdaCabecera.setCellValue("Fecha Aplicación");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)16);
			celdaCabecera.setCellValue("Capital");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)17);
			celdaCabecera.setCellValue("Interés");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)18);
			celdaCabecera.setCellValue("IVA Interés");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)19);
			celdaCabecera.setCellValue("Accesorios");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)20);
			celdaCabecera.setCellValue("IVA Accesorios");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)21);
			celdaCabecera.setCellValue("Notas de Cargo");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)22);
			celdaCabecera.setCellValue("IVA Nota de Cargo");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)23);
			celdaCabecera.setCellValue("Total Pagado");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)24);
			celdaCabecera.setCellValue("Importe Pendiente Aplicar");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)25);
			celdaCabecera.setCellValue("Total de la Operación");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)26);
			celdaCabecera.setCellValue("Institución");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)27);
			celdaCabecera.setCellValue("Cuenta");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)28);
			celdaCabecera.setCellValue("Origen del Pago");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			celdaCabecera = fila.createCell((short)29);
			celdaCabecera.setCellValue("Concepto");
			celdaCabecera.setCellStyle(estiloNegCentradoBorde);
			
			int filaActual = 8;
			TotalAplicadosWSBean bean = null;
			for(int i = 0 ; i< listaresult.size();i++){
				bean = listaresult.get(i);
				
				fila = hoja.createRow(filaActual);
				
				HSSFCell celda = fila.createCell((short)0);
				celda.setCellValue(bean.getFechaPago());
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)1);
				celda.setCellValue(bean.getDescProducto());
				
				celda = fila.createCell((short)2);
				celda.setCellValue(bean.getMovimientoID());
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)3);
				celda.setCellValue(bean.getCreditoID());
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)4);
				celda.setCellValue(bean.getDescInstNomina());
				
				
				celda = fila.createCell((short)5);
				celda.setCellValue(bean.getConvNominaDesc());
				
				celda = fila.createCell((short)6);
				celda.setCellValue(bean.getClienteID());
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)7);
				celda.setCellValue(bean.getNombreCliente());

				celda = fila.createCell((short)8);
				celda.setCellValue(bean.getRFC());
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)9);
				celda.setCellValue(bean.getCuentaAhoID());
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)10);
				celda.setCellValue(bean.getSaldoDisp());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)11);
				celda.setCellValue(bean.getSaldoBloq());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)12);
				celda.setCellValue(bean.getSaldoTotal());
				celda.setCellStyle(estiloFormatoDecimal);
				
				
				celda = fila.createCell((short)13);
				celda.setCellValue(bean.getNombreInst());
				
				celda = fila.createCell((short)14);
				celda.setCellValue(bean.getCuentaCLABE());
				
				celda = fila.createCell((short)15);
				celda.setCellValue(bean.getFechaAplicacion());
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)16);
				celda.setCellValue(bean.getCapital());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)17);
				celda.setCellValue(bean.getInteres());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)18);
				celda.setCellValue(bean.getIvaInteres());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)19);
				celda.setCellValue(bean.getAccesorios());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)20);
				celda.setCellValue(bean.getiVAAccesorios());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)21);
				celda.setCellValue(bean.getNotasCargo());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)22);
				celda.setCellValue(bean.getiVANotaCargo());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)23);
				celda.setCellValue(bean.getTotalPagado());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)24);
				celda.setCellValue(bean.getImportePenApli());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)25);
				celda.setCellValue(bean.getTotalOperacion());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda = fila.createCell((short)26);
				celda.setCellValue(bean.getNombreInstPago());
				
				celda = fila.createCell((short)27);
				celda.setCellValue(bean.getCuentaPago());
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)28);
				celda.setCellValue(bean.getOrigenPago());
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)29);
				celda.setCellValue(bean.getConceptoPago());

				
				filaActual++;
				
			}
			
			
			filaActual = filaActual+2;
			fila=hoja.createRow(filaActual);
			HSSFCell celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			
			celda=fila.createCell((short)1);
			celda.setCellValue(listaresult.size());
			celda.setCellStyle(estiloNeg8);
			
			celda=fila.createCell((short)28);
			celda.setCellValue("Procedure:");
			celda.setCellStyle(estiloNeg10);
			
			celda=fila.createCell((short)29);
			celda.setCellValue("TOTALAPLICADOSWSREP");
		
			

			for(int celd=0; celd<=29; celd++)
			hoja.autoSizeColumn((short)celd);
			
			
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteTotalAplicadosWS.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("error en el reporte de Total Aplicados por WS ");
		}
		
	}
	
	
	
	
	public TotalAplicadosWSDAO getTotalAplicadosWSDAO() {
		return totalAplicadosWSDAO;
	}

	public void setTotalAplicadosWSDAO(TotalAplicadosWSDAO totalAplicadosWSDAO) {
		this.totalAplicadosWSDAO = totalAplicadosWSDAO;
	}
	
	
	
}
