package riesgos.reporte;

import general.bean.ParametrosSesionBean;
import herramientas.Constantes;
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
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosMayorInsoluto3PorcServicio;


public class CreditosMayorInsoluto3PorcRepControlador extends AbstractCommandController{
	CreditosMayorInsoluto3PorcServicio creditosMayorInsoluto3PorcServicio = null;
	ParametrosSesionBean parametrosSesionBean;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporteExcel= 1;
	}
	public CreditosMayorInsoluto3PorcRepControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("mayorSaldoInsoluto3Porc");
	}
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
				
		UACIRiesgosBean riesgosBean = (UACIRiesgosBean) command;
		// TODO Auto-generated method stub
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):0;
						
			switch(tipoReporte){
				case Enum_Con_TipRepor.ReporteExcel:
					reporteMayorSaldoInsoluto3Porc(tipoReporte,riesgosBean,response);
				break;
			}
			return null;
		}
	// Reporte en Excel de Créditos Mayor Saldo Insoluto 3.5 %
	public List reporteMayorSaldoInsoluto3Porc(int tipoReporte,UACIRiesgosBean riesgosBean,  HttpServletResponse response){
		List listaRepote=null;
		String mesEnLetras	= "";
		String anio	= "";
		String nombreArchivo = "";
		mesEnLetras = creditosMayorInsoluto3PorcServicio.descripcionMes(riesgosBean.getMes());
		anio = riesgosBean.getAnio();
		nombreArchivo = "Mayor Saldo Insoluto 3.5 % "+mesEnLetras +" "+anio;  
		listaRepote = creditosMayorInsoluto3PorcServicio.listaReporteMayorSaldo3Porc(tipoReporte, riesgosBean, response); 
		
		int numCelda = 0;
		
		// Creacion de Libro
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
			
			//Estilo de datos centrados Encabezado
			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
			estiloDatosCentrado.setFont(fuenteNegrita10);
			estiloDatosCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			//Crea fuente con tamaño 8 para informacion del reporte.
			HSSFFont fuente8= libro.createFont();
			fuente8.setFontHeightInPoints((short)10);
			fuente8.setFontName(HSSFFont.FONT_ARIAL);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			//Estilo de 8  para Contenido
			HSSFCellStyle estilo8 = libro.createCellStyle();
			estilo8.setFont(fuente8);
			
			//Estilo de datos centrados contenido
			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
			estiloCentrado.setFont(fuente8);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			//Estilo de datos derecha contenido
			HSSFCellStyle estiloDerecha = libro.createCellStyle();
			estiloDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);  
			estiloDerecha.setFont(fuente8);
			estiloDerecha.setVerticalAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			HSSFDataFormat formato = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(formato.getFormat("#,##0.00"));
			estiloFormatoDecimal.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("Mayor Saldo Insoluto 3.5 %");
			HSSFRow fila= hoja.createRow(1);
			
			// Encabezado
			// Nombre Institucion	
			HSSFCell celdaInst=fila.createCell((short)0);
			celdaInst.setCellValue(riesgosBean.getNombreInstitucion());
			celdaInst.setCellStyle(estiloDatosCentrado);

			  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            5  //ultima celda   (0-based)
			    ));	
			  
				fila = hoja.createRow(3);
				HSSFCell celda=fila.createCell((short)0);
				celda.setCellValue("REPORTE MAYOR SALDO INSOLUTO 3.5 % "+mesEnLetras+" - "+riesgosBean.getAnio());
				celda.setCellStyle(estiloDatosCentrado);
				
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            3, //primera fila (0-based)
			            3, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            5  //ultima celda   (0-based)
			    ));
				
				fila = hoja.createRow(5);
				celda = fila.createCell((short)1);
				celda.setCellValue(Utileria.generaLocale("Número "+Constantes.CLIENTE_SOCIO, parametrosSesionBean.getNomCortoInstitucion()));
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("Número Crédito");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Saldo Insoluto");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Sucursal");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Diferencia entre el Monto\ndel 3.5% del Capital Neto");
				celda.setCellStyle(estiloNeg8);
				
				int i=6,iter=0;
				int tamanioLista = listaRepote.size();
				UACIRiesgosBean riesgos = null;
				for( iter=0; iter<tamanioLista; iter ++){
				 
					riesgos = (UACIRiesgosBean) listaRepote.get(iter);
					fila=hoja.createRow(i);
					
					celda=fila.createCell((short)1);
					celda.setCellValue(riesgos.getClienteID());
					celda.setCellStyle(estiloCentrado);
					
					celda=fila.createCell((short)2);
					celda.setCellValue(riesgos.getCreditoID());
					celda.setCellStyle(estiloCentrado);
					
					celda=fila.createCell((short)3);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getSaldoInsoluto()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)4);
					celda.setCellValue(riesgos.getSucursalID());
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)5);
					celda.setCellValue(Utileria.convierteDoble(riesgos.getDifMontoCapNeto()));
					celda.setCellStyle(estiloFormatoDecimal);
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
				

				for(int celd=0; celd<=22; celd++)
				hoja.autoSizeColumn((short)celd);
				
				
				fila = hoja.createRow(30);
				HSSFCell celdaCapital=fila.createCell((short)30);
				celdaCapital = fila.createCell((short)1);
				celdaCapital.setCellValue("Valor del Capital Neto del Mes");
				celdaCapital = fila.createCell((short)2);
				celdaCapital.setCellValue(Utileria.convierteDoble(riesgos.getCapitalNetoMensual()));
				celdaCapital.setCellStyle(estiloFormatoDecimal);
				
				fila = hoja.createRow(31);
				HSSFCell celdaResultado=fila.createCell((short)31);
				celdaResultado = fila.createCell((short)1);
				celdaResultado.setCellValue("Resultado sobre el 3.5% del Capital Neto");
				celdaResultado = fila.createCell((short)2);
				String resPorcentual = "(C31)*0.035"; 
				celdaResultado.setCellType (HSSFCell.CELL_TYPE_FORMULA ); 
				celdaResultado.setCellFormula(resPorcentual);
				celdaResultado.setCellStyle(estiloFormatoDecimal);

				
				fila = hoja.createRow(32);
				HSSFCell celdaPorcentaje=fila.createCell((short)32);
				celdaPorcentaje = fila.createCell((short)1);
				celdaPorcentaje.setCellValue("Parámetro de Porcentaje");
				celdaPorcentaje = fila.createCell((short)2);
				celdaPorcentaje.setCellValue(Utileria.convierteDoble(riesgos.getParametroPorcentaje()));
				celdaPorcentaje.setCellStyle(estiloFormatoDecimal);
				celdaPorcentaje = fila.createCell((short)3);
				celdaPorcentaje.setCellValue("%");
				celdaPorcentaje.setCellStyle(estilo8);
				
				//Nombre del Archivo
				response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
			return  listaRepote;
		}

	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosMayorInsoluto3PorcServicio getCreditosMayorInsoluto3PorcServicio() {
		return creditosMayorInsoluto3PorcServicio;
	}
	public void setCreditosMayorInsoluto3PorcServicio(
			CreditosMayorInsoluto3PorcServicio creditosMayorInsoluto3PorcServicio) {
		this.creditosMayorInsoluto3PorcServicio = creditosMayorInsoluto3PorcServicio;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
