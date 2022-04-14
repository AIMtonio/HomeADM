package tesoreria.reporte;

import herramientas.Utileria;

import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.bean.RepMasivoFRBean;

import tesoreria.bean.DispersionBean;
import tesoreria.bean.ProteccionOrdenPagoBean;
import tesoreria.servicio.OperDispersionServicio;

public class DispOrdenPagoRepControlador extends AbstractCommandController {
	
	OperDispersionServicio operDispersionServicio = null;
	String successView = null;	
	String nomReporte = null;
	
	public DispOrdenPagoRepControlador(){
 		setCommandClass(DispersionBean.class);
 		setCommandName("operDispersion");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
				DispersionBean dispersionBean = (DispersionBean) command;
				
				operDispersionServicio.getOperDispersionDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
				
				dispersionBean.setFolioOperacion(request.getParameter("folioOperacion"));
				dispersionBean.setInstitucionID(request.getParameter("institucionID"));
				dispersionBean.setCuentaAhorro(request.getParameter("cuentaAhorro"));
				dispersionBean.setReferenciaDisp(request.getParameter("referencia"));
				dispersionBean.setMontoDisp(request.getParameter("monto"));
				dispersionBean.setCuentaClabeDisp(request.getParameter("cuentaClabe"));
				dispersionBean.setFechaEnvioDisp(request.getParameter("fechaEnvio"));
				
				int tipoReporte=(request.getParameter("tipoReporte")!=null) ? Utileria.convierteEntero(request.getParameter("tipoReporte")) : 0;
				
				if(tipoReporte==2){
					List listaReportesTxt = proteccionOrdenPagoTxt(2,dispersionBean,response);
				}else{
					ByteArrayOutputStream htmlStringPDF = imprimeOrdenPag(dispersionBean,response);
				}
				
				return null;
	}
			
	// Reporte de ORDENES DE PAGO DE DISPERSIONES
	public ByteArrayOutputStream imprimeOrdenPag(DispersionBean dispersionBean, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = operDispersionServicio.reporteDispOrdenPagPDF(dispersionBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=OrdenPago.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return htmlStringPDF;
	}

	public List  proteccionOrdenPagoTxt (int tipoLista,DispersionBean dispersionBean,  HttpServletResponse response){
		List listaFR=null;
		List ListaEnc = null;
		List ListaSumario = null;
		int listaEnc=1;
		int listaSum=3;
				 	
		String archivoSal ="ProteccionOrdenPago-"+dispersionBean.getFolioOperacion()+".txt";
		try{
			ServletOutputStream ouputStream=null;
			BufferedWriter writer = new BufferedWriter(new FileWriter(archivoSal));
					
			ListaEnc = operDispersionServicio.listaReportesPorteccionOrdenP(listaEnc,dispersionBean,response);
			listaFR  = operDispersionServicio.listaReportesPorteccionOrdenP(tipoLista,dispersionBean,response);
			ListaSumario = operDispersionServicio.listaReportesPorteccionOrdenP(listaSum,dispersionBean,response);
					
				
					
			if (!listaFR.isEmpty()){
				
				ProteccionOrdenPagoBean repFRBean=null;
				
				//Linea de encabezado
				repFRBean= (ProteccionOrdenPagoBean)ListaEnc.get(0);
				writer.write(		
						repFRBean.getColumna1()+ 	//[1]
						""+repFRBean.getColumna2()+	//[2]
						""+repFRBean.getColumna3()+	//[3]
						""+repFRBean.getColumna4()+	//[4]
						""+repFRBean.getColumna5()+	//[5]
						""+repFRBean.getColumna6()+	//[6]
						""+repFRBean.getColumna7()+	//[7]
						""+repFRBean.getColumna8()+	//[8]
						""+repFRBean.getColumna9()+	//[9]
						""+repFRBean.getColumna10()//[10]
				);        
				writer.newLine(); // Esto es un salto de linea
				repFRBean=null;
				
						 
				int i=1,iter=0;
				int tamanioLista=listaFR.size();
				for(iter=0; iter<tamanioLista; iter ++ ){

					repFRBean= (ProteccionOrdenPagoBean)listaFR.get(iter);
							 
					writer.write(		
							repFRBean.getDetalle()+ 	//[1]
							""+repFRBean.getAlta()+	//[2]
							""+repFRBean.getCuentaNum()+	//[3]
							""+repFRBean.getConcepto()+	//[4]
							""+repFRBean.getPagoVent()+	//[5]
							""+repFRBean.getCodigopagoVent()+	//[6]
							""+repFRBean.getNoPagoInt()+	//[7]
							""+repFRBean.getReferencia()+	//[8]
							""+repFRBean.getBeneficiario()+	//[9]
							""+repFRBean.getIdentificacion()+	//[10]
							""+repFRBean.getDivisa()+	//[11]
							""+repFRBean.getMonto()+	//[12]
							""+repFRBean.getConfirmacion()+	//[13]
							""+repFRBean.getCorreoCel()+	//[14]
							""+repFRBean.getFechaDispersion()+	//[15]
							""+repFRBean.getFechaVenci()+	//[16]
							""+repFRBean.getEstatus()+	//[17]
							repFRBean.getDescEstatus()	//[18]
					);        
					writer.newLine(); // Esto es un salto de linea	
				}
				
				//Linea de encabezado
				repFRBean= (ProteccionOrdenPagoBean)ListaSumario.get(0);
				writer.write(		
						repFRBean.getColumna1()+ 	//[1]
						""+repFRBean.getColumna2()+	//[2]
						""+repFRBean.getColumna3()+	//[3]
						""+repFRBean.getColumna4()+	//[4]
						""+repFRBean.getColumna5()+	//[5]
						""+repFRBean.getColumna4()+	//[6]
						""+repFRBean.getColumna5()+	//[7]
						""+repFRBean.getColumna4()+	//[8]
						""+repFRBean.getColumna5()+	//[9]
						""+repFRBean.getColumna4()+	//[10]
						""+repFRBean.getColumna5()+	//[11]
						""+repFRBean.getColumna4()+	//[12]
						""+repFRBean.getColumna5()+	//[13]
						""+repFRBean.getColumna6()+	//[14]
						""+repFRBean.getColumna7()+	//[15]
						""+repFRBean.getColumna6()+	//[16]
						""+repFRBean.getColumna7()+	//[17]
						""+repFRBean.getColumna6()+	//[18]
						""+repFRBean.getColumna7()+	//[19]
						""+repFRBean.getColumna6()+	//[20]
						""+repFRBean.getColumna7()+	//[21]
						""+repFRBean.getColumna6()+	//[22]
						""+repFRBean.getColumna7()+	//[23]
						""+repFRBean.getColumna6()+	//[24]
						""+repFRBean.getColumna7()+	//[25]
						""+repFRBean.getColumna6()+	//[26]
						""+repFRBean.getColumna7()+	//[27]
						""+repFRBean.getColumna6()+	//[28]
						""+repFRBean.getColumna7()+	//[29]
						""+repFRBean.getColumna6()+	//[30]
						""+repFRBean.getColumna7()+	//[31]
						""+repFRBean.getColumna6()+	//[32]
						""+repFRBean.getColumna7()+	//[33]
						""+repFRBean.getColumna8()	//[34]
				);        
				writer.newLine(); // Esto es un salto de linea
						 				 
			}else{
				writer.write("");
			}
								
			writer.close();
					
					
			FileInputStream archivo = new FileInputStream(archivoSal);
			int longitud = archivo.available();
	        byte[] datos = new byte[longitud];
	        archivo.read(datos);
	        archivo.close();
			        
	        response.setHeader("Content-Disposition","attachment;filename="+archivoSal);
	    	response.setContentType("application/text");
	    	ouputStream = response.getOutputStream();
	    	ouputStream.write(datos);
	    	ouputStream.flush();
	    	ouputStream.close();
			    
			            
		}catch(IOException io ){
			io.printStackTrace();
		}		
				
		return listaFR;
	}
			
		public String getSuccessView() {
			return successView;
		}	
		
		public void setSuccessView(String successView) {
			this.successView = successView;
		}

		public OperDispersionServicio getOperDispersionServicio() {
			return operDispersionServicio;
		}

		public void setOperDispersionServicio(OperDispersionServicio operDispersionServicio) {
			this.operDispersionServicio = operDispersionServicio;
		}

		public String getNomReporte() {
			return nomReporte;
		}

		public void setNomReporte(String nomReporte) {
			this.nomReporte = nomReporte;
		}

	}

