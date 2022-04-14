package aportaciones.reporte;

import herramientas.Utileria;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import aportaciones.bean.AportDispersionesBean;
import aportaciones.servicio.AportDispersionesServicio;


public class ExpDispersionRepControlador extends AbstractCommandController{
	
	AportDispersionesServicio aportDispersionesServicio = null;
	
	public ExpDispersionRepControlador(){
		setCommandClass(AportDispersionesBean.class);
		setCommandName("aportDispersionesBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, 
			Object command, 
			BindException errors) throws Exception {
		
		aportDispersionesServicio.getAportDispersionesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		ServletOutputStream ouputStream=null;
		List<AportDispersionesBean> listaDispersion = null;
		
		String aud_fecha= aportDispersionesServicio.getAportDispersionesDAO().getParametrosAuditoriaBean().getFecha().toString();
		int consecutivo =(request.getParameter("consecutivo")!=null) ? Integer.parseInt(request.getParameter("consecutivo")): 0;
		
		// PARA OBTENER EL NOMBRE DEL ARCHIVO DE EXPORTACION
		String nomarchivoInterbancario="Interbancario";
		
		String anio = aud_fecha.substring(0, 4);
		String mes = aud_fecha.substring(5, 7);
		String dia = aud_fecha.substring(8, 9+1);
		
		String horaVar="";
		
		Calendar calendario = Calendar.getInstance();	 
		int hora = calendario.get(Calendar.HOUR_OF_DAY);
		int minutos = calendario.get(Calendar.MINUTE);
		int segundos = calendario.get(Calendar.SECOND);
		
		String h = "";
		String m = "";
		String s = "";
		if(hora<10)h = "0"+Integer.toString(hora); else h=Integer.toString(hora);
		if(minutos<10)m = "0"+Integer.toString(minutos); else m=Integer.toString(minutos);
		if(segundos<10)s = "0"+Integer.toString(segundos); else s=Integer.toString(segundos);		
			 
		horaVar = h+m+s;
		
		String nomInterbancario = nomarchivoInterbancario+anio+mes+dia+'_'+horaVar;
		
		String archivoSalInterbancario = nomInterbancario+".txt";
		
		try{
			BufferedWriter writerInterbancario = new BufferedWriter(new FileWriter(archivoSalInterbancario));
			
			listaDispersion = aportDispersionesServicio.obtieneLayaoutDispersionInter(consecutivo);
			
			if (!listaDispersion.isEmpty()){
				for (AportDispersionesBean beanDispersion: listaDispersion){ 
					
					String asuntoBenefici = beanDispersion.getCuentaDestino();
					if(asuntoBenefici.length() > 18){
						asuntoBenefici = asuntoBenefici.substring(0, 18);
					}
					String asuntoBeneficiario = Utileria.completaCerosIzquierda(asuntoBenefici,18);
					
					String asuntoOrdena = beanDispersion.getNumCtaInstit();
					if(asuntoOrdena.length() > 18 ){
						asuntoOrdena = asuntoOrdena.substring(0, 18);
					}
					String asuntoOrdenante = Utileria.completaCerosIzquierda(asuntoOrdena,18);
					
					String importeOpera = beanDispersion.getMonto().replace(",", ""); 
					String importeOperacion = Utileria.completaCerosIzquierda(importeOpera,16);
					
					String titular = beanDispersion.getNombreBeneficiario();
					if(titular.length() > 30){
						titular = titular.substring(0, 30);
					}
					String titularAsunto = Utileria.completaCaracteresDerecha(titular, 30," ");
					String tipoCuenta = beanDispersion.getTipoCuentaID();	
					String numeroBanco = beanDispersion.getFolio();	

					String motivo =  beanDispersion.getDescripcion();
					if(motivo.length() > 30){
						motivo = motivo.substring(0, 30);
					}
					String motivoPago = Utileria.completaCaracteresDerecha(motivo, 30," ");	

					String refere = beanDispersion.getReferencia();
					if(refere.length() > 7){
						refere = refere.substring(0, 7);
					}
					String referencia = Utileria.completaCerosIzquierda(refere,7);
					
					/*----------- Escritura Archivo Interbancario-----------*/
					writerInterbancario.write(
						asuntoBeneficiario+
						""+asuntoOrdenante+
						""+"MXP"+ 	// Valor Fijo Divisa de la Operación
						""+importeOperacion+
						""+titularAsunto+
						""+tipoCuenta+	// Valor Fijo Tipo de Cuenta 03 = Tarjeta Debito   40 = Cuenta Clabe
						""+numeroBanco+
						""+motivoPago+							
						""+referencia+
						""+"H"+""	// Valor Fijo Disponibilidad (H = Mismo Día Vía SPEI)
														
						);       
					writerInterbancario.newLine(); 
				}
				
			}
			
			writerInterbancario.close();
			FileInputStream archivoInter = new FileInputStream(archivoSalInterbancario);
			int longitudInter = archivoInter.available();
			byte[] datosInter = new byte[longitudInter];
			archivoInter.read(datosInter);
			archivoInter.close();

			response.setHeader("Content-Disposition","attachment;filename="+archivoSalInterbancario);
			response.setContentType("application/text");
			ouputStream= response.getOutputStream();
			ouputStream.write(datosInter);
			ouputStream.flush();
			ouputStream.close();
		
			//mensaje = operDispersionServicio.actualizaDispMov(folioOperacion ,Enum_Actualizacion.banInter);
			
		}catch(IOException io ){	
			io.printStackTrace();
		}		
		return null;
		
	}

	public AportDispersionesServicio getAportDispersionesServicio() {
		return aportDispersionesServicio;
	}

	public void setAportDispersionesServicio(
			AportDispersionesServicio aportDispersionesServicio) {
		this.aportDispersionesServicio = aportDispersionesServicio;
	}
}
