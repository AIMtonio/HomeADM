package originacion.reporte;

import herramientas.Utileria;

import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.RepRiesgoComunBean;
import originacion.servicio.RepRiesgoComunServicio;


public class RepRiesgoComunControlador extends AbstractCommandController{

	public static interface Enum_Con_TipRepor {
		  int  excel= 1 ;
	}
	
	RepRiesgoComunServicio repRiesgoComunServicio = null;
	
	String nombreReporte = null;
	String successView = null;
	
	public RepRiesgoComunControlador(){
		setCommandClass(RepRiesgoComunBean.class);
		setCommandName("repBitacoraSolBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		RepRiesgoComunBean repBitacoraSolBean = (RepRiesgoComunBean) command;
		int tipoReporte =(request.getParameter("tipoRep")!=null)?
				Integer.parseInt(request.getParameter("tipoRep")):0;
	
		String htmlString= "";
		
		switch(tipoReporte){	
		case Enum_Con_TipRepor.excel:	
			 List<RepRiesgoComunBean>listaReportes = listaReporte(tipoReporte, repBitacoraSolBean ,response);
			 break;
		}
		return null;	
	}
	
	public List<RepRiesgoComunBean> listaReporte(int tipoReporte,RepRiesgoComunBean repRiesgoComunBean,  HttpServletResponse response){
		List<RepRiesgoComunBean> listaSolicitudes=null;
		
		if(tipoReporte ==1){
			listaSolicitudes = repRiesgoComunServicio.listaReporte(1, repRiesgoComunBean, response);
		}	
		
	     
		int regExport = 0;
		Calendar calendario = Calendar.getInstance();
		
		if(listaSolicitudes != null){
					try {
						SXSSFWorkbook libro = new SXSSFWorkbook(100);
						//Crea un Fuente Negrita con tamaño 10		
						Font fuenteNegrita10= libro.createFont();
						fuenteNegrita10.setFontHeightInPoints((short)10);
						fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
						fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
							
						Font fuenteNegrita10Izq= libro.createFont();
						fuenteNegrita10Izq.setFontHeightInPoints((short)10);
						fuenteNegrita10Izq.setFontName(HSSFFont.FONT_ARIAL);
						fuenteNegrita10Izq.setBoldweight(Font.BOLDWEIGHT_BOLD);
											
						Font fuente10Der= libro.createFont();
						fuente10Der.setFontHeightInPoints((short)10);
						fuente10Der.setFontName(HSSFFont.FONT_ARIAL);
						
						Font fuente10Izq= libro.createFont();
						fuente10Izq.setFontHeightInPoints((short)10);
						fuente10Izq.setFontName(HSSFFont.FONT_ARIAL);
						
						Font fuente10Cen= libro.createFont();
						fuente10Cen.setFontHeightInPoints((short)10);
						fuente10Cen.setFontName(HSSFFont.FONT_ARIAL);
						
						Font fuenteNegritaSalto= libro.createFont();
						fuenteNegritaSalto.setFontHeightInPoints((short)10);
						fuenteNegritaSalto.setFontName(HSSFFont.FONT_ARIAL);
						fuenteNegritaSalto.setBoldweight(Font.BOLDWEIGHT_BOLD);
						
						//Estilo negrita tamaño 10 centrado 
						CellStyle estiloNeg10Cen = libro.createCellStyle();
						estiloNeg10Cen.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
						estiloNeg10Cen.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
						estiloNeg10Cen.setFont(fuenteNegrita10);
						
						//Estilo negrita tamaño 10 izquierda
						CellStyle estiloNeg10Izq = libro.createCellStyle();
						estiloNeg10Izq.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
						estiloNeg10Izq.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
						estiloNeg10Izq.setFont(fuenteNegrita10Izq);
						
						//Estilo 10 Izquiera
						CellStyle estiloFormatoIzquierda = libro.createCellStyle();
						estiloFormatoIzquierda.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
						estiloFormatoIzquierda.setFont(fuente10Izq);
						
						//Estilo 10 centrado
						CellStyle estiloFormatoICentrado = libro.createCellStyle();
						estiloFormatoICentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
						estiloFormatoICentrado.setFont(fuente10Cen);
						
						//Estilo 10 Derecha
						CellStyle estiloFormatoDerecha = libro.createCellStyle();
						estiloFormatoDerecha.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
						estiloFormatoDerecha.setFont(fuente10Der);
						
						//Estilo Salto de Linea
						CellStyle estiloSaltoLinea = libro.createCellStyle();
						estiloSaltoLinea.setAlignment((short)CellStyle.ALIGN_CENTER);
						estiloSaltoLinea.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
						estiloSaltoLinea.setFont(fuenteNegritaSalto);
						estiloSaltoLinea.setWrapText(true);
						
						CellStyle formatoDecimal = libro.createCellStyle();
						DataFormat format = libro.createDataFormat();
						formatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
						
						Sheet hoja = null;
						hoja = libro.createSheet("Reporte de Riesgo Común");
						
						Row fila = hoja.createRow(0);
						Cell celda=fila.createCell((short)0);		

						if(tipoReporte == 1) {	
						celda = fila.createCell((short)7);
						celda.setCellStyle(estiloNeg10Izq);
						celda.setCellValue("Usuario:");				// Usuario que genera el reporte		
						
						String nombreUsuario = repRiesgoComunBean.getNomUsuario().toUpperCase();
						
						celda = fila.createCell((short)8);
						celda.setCellValue(nombreUsuario.toUpperCase());
						celda.setCellStyle(estiloFormatoDerecha);					
							
						fila = hoja.createRow(1);
						celda = fila.createCell	((short)0);
						celda.setCellStyle(estiloNeg10Cen);
						celda.setCellValue(repRiesgoComunBean.getNombreInstitucion());
						hoja.addMergedRegion(new CellRangeAddress(
					            1, //primera fila 
					            1, //ultima fila 
					            0, //primer celda
					            6 //ultima celda
					    ));			
						
						celda=fila.createCell((short)7);
						celda.setCellStyle(estiloNeg10Izq);
						celda.setCellValue("Fecha: ");
						
						celda=fila.createCell((short)8);
						celda.setCellStyle(estiloFormatoDerecha);
						celda.setCellValue(repRiesgoComunBean.getFechaSistema());	// Fecha de Emisión del Reporte
						
						fila = hoja.createRow(2);
						
						celda = fila.createCell	((short)0);
						celda.setCellStyle(estiloNeg10Cen);
						celda.setCellValue("REPORTE DE RIESGO COMÚN");
						hoja.addMergedRegion(new CellRangeAddress(
					            2, //primera fila 
					            2, //ultima fila 
					            0, //primer celda
					            6 //ultima celda
					    ));										

						celda = fila.createCell((short)7);
						celda.setCellValue("Hora: ");
						celda.setCellStyle(estiloNeg10Izq);
						
						celda = fila.createCell((short)8);
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
						celda.setCellValue(horaVar);
						celda.setCellStyle(estiloFormatoDerecha);						
						
						fila = hoja.createRow(3);				
													
						// Creacion de fila										
						fila = hoja.createRow(4);
						celda = fila.createCell((short)0);
						celda.setCellValue("Cliente:");
						celda.setCellStyle(estiloNeg10Izq);	
						
						celda = fila.createCell((short)1);
						celda.setCellValue((!repRiesgoComunBean.getNumeroCliente().equals("0")? repRiesgoComunBean.getClienteNombre():"TODOS"));
						celda.setCellStyle(estiloFormatoIzquierda);	
						
						celda = fila.createCell((short)4);
						celda.setCellValue("Estatus:");	
						celda.setCellStyle(estiloNeg10Izq);	
						
						String Estatus = repRiesgoComunBean.getEstatus();
						if(Estatus.equalsIgnoreCase("P")){
							Estatus = "PENDIENTE";
						}else if(Estatus.equalsIgnoreCase("R") ){
							Estatus = "REVISADO";
						}else if(Estatus.equalsIgnoreCase("")){
							Estatus = "TODOS";
						}
						
						celda = fila.createCell((short)5);
						celda.setCellValue(Estatus);
						celda.setCellStyle(estiloFormatoIzquierda);	
						
						celda = fila.createCell((short)7);
						celda.setCellValue("Riesgo Común:");
						celda.setCellStyle(estiloNeg10Izq);	
						
						String riesgoCom = repRiesgoComunBean.getRiesgoComun();
						if(riesgoCom.equalsIgnoreCase("S")){
							riesgoCom = "SI";
						}else if(riesgoCom.equalsIgnoreCase("N") ){
							riesgoCom = "NO";
						}else if(riesgoCom.equalsIgnoreCase("")){
							riesgoCom = "TODOS";
						}
						hoja.addMergedRegion(new CellRangeAddress(
					            4, //primera fila 
					            4, //ultima fila 
					            7, //primer celda
					            8 //ultima celda
					    ));	
												
						celda = fila.createCell((short)9);
						celda.setCellValue(riesgoCom);
						celda.setCellStyle(estiloFormatoIzquierda);	
																		
						fila = hoja.createRow(5);
						celda = fila.createCell((short)0);
						celda.setCellValue("Personas Relacionadas:");
						celda.setCellStyle(estiloNeg10Izq);	
						hoja.addMergedRegion(new CellRangeAddress(
					            5, //primera fila 
					            5, //ultima fila 
					            0, //primer celda
					            1 //ultima celda
					    ));
												
						String persRela = repRiesgoComunBean.getPersRelacionada();
						if(persRela.equalsIgnoreCase("S")){
							persRela = "SI";
						}else if(persRela.equalsIgnoreCase("N") ){
							persRela = "NO";
						}else if(persRela.equalsIgnoreCase("")){
							persRela = "TODOS";
						}
											
						celda = fila.createCell((short)2);
						celda.setCellValue(persRela);
						celda.setCellStyle(estiloFormatoIzquierda);	
												
						celda = fila.createCell((short)4);
						celda.setCellValue("Procesado:");
						celda.setCellStyle(estiloNeg10Izq);	
						
						String procesado = repRiesgoComunBean.getProcesado();
						if(procesado.equalsIgnoreCase("S")){
							procesado = "SI";
						}else if(procesado.equalsIgnoreCase("N") ){
							procesado = "NO";
						}else if(procesado.equalsIgnoreCase("")){
							procesado = "TODOS";
						}
												
						celda = fila.createCell((short)5);
						celda.setCellValue(procesado);
						celda.setCellStyle(estiloFormatoIzquierda);	
						
						celda = fila.createCell((short)7);
						celda.setCellValue("Sucursal:");
						celda.setCellStyle(estiloNeg10Izq);	
						
						celda = fila.createCell((short)8);
						celda.setCellValue(repRiesgoComunBean.getSucursalSolCredID());
						celda.setCellStyle(estiloFormatoIzquierda);	
						
						String sucursalSolicitud = repRiesgoComunBean.getSucursalSolCredID();
						if(!sucursalSolicitud.equalsIgnoreCase("0")){
							sucursalSolicitud = repRiesgoComunBean.getSucursalSolCredNombre();
						}else if(sucursalSolicitud.equalsIgnoreCase("0") ){
							sucursalSolicitud = "TODAS";
						}
						
						celda = fila.createCell((short)9);
						celda.setCellValue(sucursalSolicitud);
						celda.setCellStyle(estiloFormatoIzquierda);	
						
						fila = hoja.createRow(7);
						fila = hoja.createRow(8);
						
						celda = fila.createCell((short)0);
						celda.setCellValue("Solicitud/Crédito");
						celda.setCellStyle(estiloSaltoLinea);
						fila.setHeight((short) 500);	
						
						celda = fila.createCell((short)1);
						celda.setCellValue("Sucursal Solicitud");
						celda.setCellStyle(estiloSaltoLinea);
						fila.setHeight((short) 500);						
						
						celda = fila.createCell((short)2);
						celda.setCellValue("Cliente");
						celda.setCellStyle(estiloSaltoLinea);
						fila.setHeight((short) 500);	
						
						celda = fila.createCell((short)3);
						celda.setCellValue("Nombre Solicitante");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)4);
						celda.setCellValue("Crédito");
						celda.setCellStyle(estiloSaltoLinea);

						celda = fila.createCell((short)5);
						celda.setCellValue("Cliente Riesgo");
						celda.setCellStyle(estiloSaltoLinea);					
					
						celda = fila.createCell((short)6);
						celda.setCellValue("Nombre Riesgo Común/Persona Relacionada");
						celda.setCellStyle(estiloSaltoLinea);
											
						celda = fila.createCell((short)7);
						celda.setCellValue("Monto Ac. Cr.");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)8);
						celda.setCellValue("Parentesco");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)9);
						celda.setCellValue("Estatus");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)10);
						celda.setCellValue("Clave");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)11);
						celda.setCellValue("Motivo");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)12);
						celda.setCellValue("Riesgo Común");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)13);
						celda.setCellValue("Personas Relacionadas");
						celda.setCellStyle(estiloSaltoLinea);
						
						//Solicitud Registrada	
						celda = fila.createCell((short)14);
						celda.setCellValue("Comentario");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)15);
						celda.setCellValue("Procesado");
						celda.setCellStyle(estiloSaltoLinea);
						
						hoja.setColumnWidth(0, 2219);
						hoja.setColumnWidth(1, 3703);
						hoja.setColumnWidth(2, 2972);
						hoja.setColumnWidth(3, 7944);
						hoja.setColumnWidth(4, 3034);
						hoja.setColumnWidth(5, 3147);
						hoja.setColumnWidth(6, 7944);
						hoja.setColumnWidth(7, 3395);
						hoja.setColumnWidth(8, 3488);
						hoja.setColumnWidth(9, 3488);
						hoja.setColumnWidth(10, 2219);
						hoja.setColumnWidth(11, 4798);
						hoja.setColumnWidth(12, 4860);
						hoja.setColumnWidth(13, 4860);
						hoja.setColumnWidth(14, 10317);
						hoja.setColumnWidth(15, 2951);
						
						int i=9;
						int tamanioLista = listaSolicitudes.size();
						for(RepRiesgoComunBean riesgos : listaSolicitudes ){
							fila=hoja.createRow(i);
							
							//Solicitud/Crédito
							celda=fila.createCell((short)0);
							celda.setCellValue(riesgos.getSolicitudCreditoID().equals(null) || riesgos.getSolicitudCreditoID().equals("") ? "-" : riesgos.getSolicitudCreditoID());
							celda.setCellStyle(estiloFormatoIzquierda);
							
							//Sucursal Solicitud
							celda=fila.createCell((short)1);					
							celda.setCellValue(riesgos.getClienteID().equals(null) || riesgos.getClienteID().equals("") ? "-" : riesgos.getSucursalSolCredID());
							celda.setCellStyle(estiloFormatoICentrado);
							
							//Cliente
							celda=fila.createCell((short)2);
							celda.setCellValue(riesgos.getClienteID().equals(null) || riesgos.getClienteID().equals("") ? "-" : riesgos.getClienteID());
							celda.setCellStyle(estiloFormatoIzquierda);
							
							//Nombre Solicitante
							celda=fila.createCell((short)3);
							celda.setCellValue(riesgos.getNombreCliente().equals(null) || riesgos.getNombreCliente().equals("") ? "-" : riesgos.getNombreCliente());
							celda.setCellStyle(estiloFormatoIzquierda);
							
							//Crédito
							celda=fila.createCell((short)4);
							celda.setCellValue(riesgos.getCreditoID().equals(null) || riesgos.getCreditoID().equals("") ? "-" : riesgos.getCreditoID());						
							celda.setCellStyle(estiloFormatoIzquierda);
							
							//Cliente Riesgo
							celda=fila.createCell((short)5);
							celda.setCellValue(riesgos.getClienteIDRel().equals(null) || riesgos.getClienteIDRel().equals("") ? "-" : riesgos.getClienteIDRel());
							celda.setCellStyle(estiloFormatoIzquierda);
							
							// Nombre Riesgo Común/Persona Relacionada
							celda=fila.createCell((short)6);
							celda.setCellValue(riesgos.getNombreClienteRel().equals(null) || riesgos.getNombreClienteRel().equals("") ? "-" : riesgos.getNombreClienteRel());
							celda.setCellStyle(estiloFormatoIzquierda);
							
							//Monto Ac. Cr.
							celda=fila.createCell((short)7);
							celda.setCellValue(Utileria.convierteDoble(riesgos.getMontoAcumulado().equals(null) || riesgos.getMontoAcumulado().equals("") ? "-" : riesgos.getMontoAcumulado()));
							celda.setCellStyle(formatoDecimal);
							
							//Parentesco
							celda=fila.createCell((short)8);
							celda.setCellValue(riesgos.getParentesco().equals(null) || riesgos.getParentesco().equals("") ? "-" : riesgos.getParentesco());
							celda.setCellStyle(estiloFormatoIzquierda);
							
							//Estatus
							celda=fila.createCell((short)9);
							celda.setCellValue(riesgos.getEstatus().equals(null) || riesgos.getEstatus().equals("") ? "-" : riesgos.getEstatus());
							celda.setCellStyle(estiloFormatoIzquierda);
							
							//Clave
							celda=fila.createCell((short)10);
							celda.setCellValue(riesgos.getClave().equals(null) || riesgos.getClave().equals("") ? "-" : riesgos.getClave());
							celda.setCellStyle(estiloFormatoIzquierda);
							
							//Motivo
							celda=fila.createCell((short)11);
							celda.setCellValue(riesgos.getMotivo().equals(null) || riesgos.getMotivo().equals("") ? "-" : riesgos.getMotivo());
							celda.setCellStyle(estiloFormatoIzquierda);
							
							//Riesgo Común
							celda=fila.createCell((short)12);
							celda.setCellValue(riesgos.getRiesgoComun().equals(null) || riesgos.getRiesgoComun().equals("") ? "-" : riesgos.getRiesgoComun());
							celda.setCellStyle(estiloFormatoICentrado);
							
							//Personas Relacionadas
							celda=fila.createCell((short)13);
							celda.setCellValue(riesgos.getPersRelacionada().equals(null) || riesgos.getPersRelacionada().equals("") ? "-" : riesgos.getPersRelacionada());
							celda.setCellStyle(estiloFormatoICentrado);
							
							//Comentario
							celda=fila.createCell((short)14);					
							celda.setCellValue(riesgos.getComentario().equals(null) || riesgos.getComentario().equals("") ? "-" : riesgos.getComentario());	
							celda.setCellStyle(estiloFormatoIzquierda);
							
							//Procesado
							celda=fila.createCell((short)15);					
							celda.setCellValue(riesgos.getProcesado().equals(null) || riesgos.getProcesado().equals("") ? "-" : riesgos.getProcesado());
							celda.setCellStyle(estiloFormatoICentrado);
												
							regExport 		= regExport + 1;
							i++;
						}	
						i = i+2;
						fila=hoja.createRow(i);
						celda = fila.createCell((short)0);
						celda.setCellValue("Registros Exportados");
						celda.setCellStyle(estiloNeg10Izq);
						
						i = i+1;
						fila=hoja.createRow(i);
						celda=fila.createCell((short)0);
						celda.setCellValue(tamanioLista);			
					}					
			
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteBitacoraSolCred.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				libro.write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				}catch(Exception e){
				
					e.printStackTrace();
				}//Fin del catch
			}
			return  listaSolicitudes;		
	}
	
	
	public RepRiesgoComunServicio getRepRiesgoComunServicio() {
		return repRiesgoComunServicio;
	}

	public void setRepRiesgoComunServicio(
			RepRiesgoComunServicio repRiesgoComunServicio) {
		this.repRiesgoComunServicio = repRiesgoComunServicio;
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

