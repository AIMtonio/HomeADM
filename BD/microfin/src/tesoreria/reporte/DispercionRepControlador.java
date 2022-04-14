package tesoreria.reporte;

import general.bean.ParametrosSesionBean;
import general.dao.TransaccionDAO;
import general.servicio.ParametrosAplicacionServicio;
import herramientas.Utileria;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.DispersionBean;
import tesoreria.bean.DispersionGridBean;
import tesoreria.servicio.OperDispersionServicio;

public class DispercionRepControlador extends AbstractCommandController {

	public DispercionRepControlador(){
		setCommandClass(DispersionBean.class);
		setCommandName("operDispersion");
	}
	
	
	
	OperDispersionServicio operDispersionServicio = null;
	ParametrosAplicacionServicio parametrosAplicacionServicio = null;
	TransaccionDAO transaccionDAO = null;
	
	
	public static interface Enum_Instituciones{
		int banorte 	= 24;
		int mifel   	= 11;
		int bancomer	= 37;
		int santander	= 28;
	}
	
	public static interface Enum_TipoTransaccion{
		int ordenPagoSan		= 1;			// Orden de pagos Santander
		int tranferenciaSan		= 2;			// Transferencia Santander
	}
	public static interface Enum_TipoArchivo{
		String ordenPagoSan			= "OP";			// Archivo de orden de pago santander
		String tranferenciaSan		= "TS";			// Archivo de Transferencia santander
		String tranferenciaSanOtros	= "OT";			// Archivo de Transferencia santander
		String tranferenciaCancel	= "CA";			// Archivo de Transferencia santander
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, 
			Object command, 
			BindException errors) throws Exception {
		
		operDispersionServicio.getOperDispersionDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		transaccionDAO.generaNumeroTransaccion();
		
		ServletOutputStream ouputStream=null;
		List<DispersionGridBean> listaDispersion = null;
		
		
		
		String aud_fecha= operDispersionServicio.getOperDispersionDAO().getParametrosAuditoriaBean().getFecha().toString();
		long numTransaccion = operDispersionServicio.getOperDispersionDAO().getParametrosAuditoriaBean().getNumeroTransaccion();
				
		int folioOperacion = (request.getParameter("folioOperacion")!=null) ? Integer.parseInt(request.getParameter("folioOperacion")) : 0;
		int institucionID = (request.getParameter("institucionID")!=null) ? Integer.parseInt(request.getParameter("institucionID")) : 0;
		
		int transaccion = (request.getParameter("tipoTransaccion")!=null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
		String nombreArchivo = (request.getParameter("nombreArchivo")!=null) ? request.getParameter("nombreArchivo") : "";

		DateFormat dateFormat = new SimpleDateFormat("ddMMyyyy");
		Date date = new Date();

		String archivoSal = "";
		String archivoSalOtros = "";
		
		ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
		String rutaArch = parametros.getRutaArchivos() + "ArchivosGenSantander";
		boolean exists = (new File(rutaArch)).exists();
		
		//VALIDACION SI EXISTE LA RUTA DESTINO
		if (!exists) {
			File aDir = new File(rutaArch);
			aDir.mkdir();
		}
				
		
		if(institucionID!=28){
			archivoSal = rutaArch+"/"+"Dispersion"+aud_fecha+".txt";
		}
		else{
			archivoSal = rutaArch+"/" + nombreArchivo+"-"+numTransaccion+"-"+aud_fecha+".txt";		
		}
		
		try{
			BufferedWriter writer = new BufferedWriter(new FileWriter(archivoSal));
			////
			switch(institucionID){
			
			case Enum_Instituciones.banorte :
				
				listaDispersion = operDispersionServicio.obtieneLayaoutDispersion(folioOperacion, institucionID);

			
				if (!listaDispersion.isEmpty()){

					for (DispersionGridBean beanDispersion: listaDispersion){

						writer.write(		
								"'"+beanDispersion.getGridTipoMov()+"\t"+
										"'"+beanDispersion.getClaveDispersion()+"\t"+
										"'"+beanDispersion.getGridCuentaAhoID()+"\t"+
										"'"+beanDispersion.getGridCuentaClabe()+"\t"+
										"'"+beanDispersion.getGridMonto()+"\t"+
										"'"+beanDispersion.getGridReferencia()+"\t"+
										beanDispersion.getGridDescripcion()+"\t"+
										"'"+beanDispersion.getGridRFC()+"\t"+
										"'"+beanDispersion.getIva()+"\t"+
										beanDispersion.getFechaAplicar()+"\t"+
										beanDispersion.getNombreBeneficiario()
								);        
						writer.newLine(); // Esto es un salto de linea	
					}

				}else{
					writer.write("");
				}
				/////////	
				break;

			case Enum_Instituciones.mifel://///////////////////////////////////////////////////////////////////
				
				listaDispersion = operDispersionServicio.obtieneLayaoutDispersionMifel(folioOperacion, institucionID);
                int totalTranferencias = listaDispersion.size();
                double montoTotal =0.00;
                String cuentaOrigen = "";
				
				
				if (!listaDispersion.isEmpty()){

					for (DispersionGridBean beanDispersion: listaDispersion){
                 		montoTotal += Utileria.convierteDoble(beanDispersion.getGridMonto());
                 		cuentaOrigen = beanDispersion.getGridCuentaAhoID();
					}	
					
					writer.write(
							"|"+totalTranferencias+""+
							"|"+montoTotal+""+
							"|Transfers "+
							"|"+cuentaOrigen+""+
							"|Disp. mifel;"
							);
					writer.newLine(); // Esto es un salto de linea
					
					int consecutivo=1;
						for (DispersionGridBean beanDispersion: listaDispersion){	
						
							 writer.write(		
										"|"+consecutivo+
										"|20"+//20 para transferencias de otros bancos 10 para tranf mifel
										"|"+// este siempre debe ir vacio
										"|"+beanDispersion.getGridCuentaClabe()+
										"|"+beanDispersion.getGridMonto()+
										"|MXP"+//para transferencias SPEI o TEF debe ser “MXP”.
										"|"+beanDispersion.getGridReferencia()+ // consepto  máximo 10 carcteres
										"|"+beanDispersion.getGridDescripcion()+
										"|"+//correo electrónico
										"|"+//telefono cel para sms
										"|"+beanDispersion.getGridRFC()+
										"|"+beanDispersion.getIva()+
										"|"+beanDispersion.getGridReferencia()+"|;"
																
								);        
						writer.newLine(); // Esto es un salto de linea	
						consecutivo ++;
					}

				}else{
					writer.write("");
				}
				/////////
				break;
				
			case Enum_Instituciones.bancomer :
				listaDispersion = operDispersionServicio.obtieneLayaoutDispersionBancomer(folioOperacion, institucionID);

							
				if (!listaDispersion.isEmpty()){
					for (DispersionGridBean beanDispersion: listaDispersion){
						
						String tipoCuenta="40";
						tipoCuenta=tipoCuenta+(beanDispersion.getGridCuentaAhoID().substring(0, 3));
			    String CadenaDispercionSalida="";	
				String CadenaDispercion=
				
							"PSC"+
							""+beanDispersion.getGridCuentaAhoID()+
							""+beanDispersion.getGridCuentaClabe()+
							""+beanDispersion.getGridFormaPago()+
							""+beanDispersion.getGridMonto()+
							""+beanDispersion.getGridNombreBenefi()+
							""+tipoCuenta+
							""+beanDispersion.getGridDescripcion()+							
							""+beanDispersion.getGridReferencia()+ 
							"H0                  000000000000.00";
				
				CadenaDispercionSalida=Utileria.quitaCaracterEsp(CadenaDispercion);
							writer.write(							
									CadenaDispercionSalida		
							);        
				  writer.newLine(); 
					
					}
				
				}
				break;
			case Enum_Instituciones.santander :

				//Orden de Pago de Santander
				if(transaccion==Enum_TipoTransaccion.ordenPagoSan){
					listaDispersion = operDispersionServicio.obtieneLayaoutDispersionSantander(folioOperacion, institucionID, Enum_TipoArchivo.ordenPagoSan, archivoSal);	
					if (!listaDispersion.isEmpty()){
						
						for (DispersionGridBean beanDispersion: listaDispersion){
		
							writer.write(		
									   beanDispersion.getGridCuentaAhoID()+ 		// CUENTA DE CARGO
									   beanDispersion.getClaveDispersion()+			// NUMERO DE ORDEN
									   beanDispersion.getFechaAplicacion()+			// FECHA EN QUE SE GENERO EL ARCHIVO
									   beanDispersion.getFechaAplicar()+			// FECHA LIMITE DE PAGO
									   beanDispersion.getGridRFC()+					// RFC
									   beanDispersion.getNombreBeneficiario()+		// NOMBRE DEL BENEFICIARIO
									   beanDispersion.getClaveSucursales()+			// CLAVE TODAS LAS SUCURSALES
									   beanDispersion.getClaveSucursal()+			// CLAVE SUCURSAL
									   beanDispersion.getTipoPago()+				// TIPO DE PAGO
									   beanDispersion.getGridMonto()+				// MONTO
									   beanDispersion.getConcepto()					// CONCEPTO
									);        
							writer.newLine(); // Esto es un salto de linea	
						}
		
					}else{
						writer.write("");
					}
				}
				
				if(transaccion==Enum_TipoTransaccion.tranferenciaSan){
					listaDispersion = operDispersionServicio.layaoutDispTransferenciaSanta(folioOperacion, institucionID, Enum_TipoArchivo.tranferenciaSan, archivoSal);					
					//Transferencia santander
					if (!listaDispersion.isEmpty()){
						for (DispersionGridBean beanDispersion: listaDispersion){
							
							
							writer.write(
								""+beanDispersion.getCodigoLayaut()+		// CODIGO LAYOUT
								""+beanDispersion.getGridCuentaAhoID()+		// CUENTA DE CARGO
								""+beanDispersion.getGridCuentaClabe()+		// CUENTA DE ABONO
								""+beanDispersion.getGridMonto()+			// IMPORTE
								""+beanDispersion.getConcepto()+			// CONCEPTO
								""+beanDispersion.getFechaAplicacion()+					// FECHA EN QUE SE GENERA EL ARCHIVO
								""+beanDispersion.getCorreoBeneficiario());	// EMAIL BENEFICIARIO							

							writer.newLine(); 
						
						}					
					}
					else{
						writer.write("");
					}
					
				}
				
				break;

			}
			writer.close();


			FileInputStream archivo = new FileInputStream(archivoSal);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo+"-"+numTransaccion+"-"+aud_fecha+".txt");
			response.setContentType("application/text");
			ouputStream = response.getOutputStream();
			ouputStream.write(datos);
			ouputStream.flush();
			ouputStream.close();
			

		}catch(IOException io ){	
			io.printStackTrace();
		}		
		return null;
	}

	public void setOperDispersionServicio(OperDispersionServicio operDispersionServicio) {
		this.operDispersionServicio = operDispersionServicio;
	}
	public OperDispersionServicio getOperDispersionServicio() {
		return operDispersionServicio;
	}
	public TransaccionDAO getTransaccionDAO() {
		return transaccionDAO;
	}

	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}

	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}

	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}
	
	
}
