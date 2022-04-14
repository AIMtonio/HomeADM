package soporte.controlador;

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

import org.apache.commons.io.FileUtils;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.servicio.GeneracionArchPlanosServicio;
import tesoreria.bean.CuentasSantanderBean;
import tesoreria.bean.DispersionBean;
import tesoreria.bean.DispersionGridBean;
import tesoreria.reporte.DispercionRepControlador.Enum_TipoArchivo;
import tesoreria.servicio.CuentasSantanderServicio;
import tesoreria.servicio.OperDispersionServicio;
import tesoreria.servicio.CuentasSantanderServicio.Enum_Tra_CuentaSantander;


public class GeneracionArchPlanosControlador extends AbstractCommandController {

	public GeneracionArchPlanosControlador(){
		setCommandClass(CuentasSantanderBean.class);
		setCommandName("cuentasSantander");
	}

	GeneracionArchPlanosServicio generacionArchPlanosServicio =null;
	OperDispersionServicio operDispersionServicio = null;
	ParametrosAplicacionServicio parametrosAplicacionServicio = null;
	TransaccionDAO transaccionDAO = null;
	
	public static interface Enum_Lis_CuentaSantander {
		int principal = 1; 
	}
	public static interface Enum_Arch_Generar {
		int generaCtasSant = 1;					//Genera el layaut de Ctas de bancos de Santander u Otros
		int generaLayautSanOtros = 2;
		int generaCancelacion = 3;
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, 
			Object command, 
			BindException errors) throws Exception {		
		transaccionDAO.generaNumeroTransaccion();
		
		generacionArchPlanosServicio.getCuentasSantanderDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		CuentasSantanderBean cuentasSantanderBean = (CuentasSantanderBean) command;
		
		ServletOutputStream ouputStream=null;
		List<CuentasSantanderBean> listaCuentasBanSant = null;
		List<CuentasSantanderBean> listaCuentasBanOtros = null;
		List<DispersionGridBean> listaDispersionOtros = null;
		
		
		String aud_fecha= generacionArchPlanosServicio.getCuentasSantanderDAO().getParametrosAuditoriaBean().getFecha().toString();
		Long numTrans = generacionArchPlanosServicio.getCuentasSantanderDAO().getParametrosAuditoriaBean().getNumeroTransaccion();
		
		// PARAMETROS GLOBALES
		String nombreArch = (request.getParameter("nombreArch")!=null) ? request.getParameter("nombreArch") : "";
		String extension = (request.getParameter("extension")!=null) ? request.getParameter("extension") : "";// ejem: .txt
		int tipoArchivo = Integer.parseInt(request.getParameter("tipoArchivo"));
		
		//Parametros Ctas Santander o Otros
		String fechaInicio = (request.getParameter("fechaInicio")!=null) ? request.getParameter("fechaInicio") : "";
		String fechaFin = (request.getParameter("fechaFin")!=null) ? request.getParameter("fechaFin") : "";
		String tipoCta = (request.getParameter("tipoCta")!=null) ? request.getParameter("tipoCta") : "";
		String estatus = (request.getParameter("estatus")!=null) ? request.getParameter("estatus") : "";
		
		// PARAMETROS PARA LAYAUT DE DISPERSION DE OTROS A TRAVES DE SANTNADER
		int folioOperacion = (request.getParameter("folioOperacion")!=null) ? Integer.parseInt(request.getParameter("folioOperacion")) : 0;
		long transaccion = (request.getParameter("numTransaccion")!=null) ? Utileria.convierteLong(request.getParameter("numTransaccion")) : 0;
		int institucionID = (request.getParameter("institucionID")!=null) ? Integer.parseInt(request.getParameter("institucionID")) : 0;
		
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
		String rutaArch = parametros.getRutaArchivos() + "ArchivosGenSantander";
		boolean exists = (new File(rutaArch)).exists();
		
		//VALIDACION SI EXISTE LA RUTA DESTINO
		if (!exists) {
			File aDir = new File(rutaArch);
			aDir.mkdir();
		}
		
		String nombreArcFinal =rutaArch+"/" + nombreArch+"-"+numTrans+"-"+aud_fecha+extension;
		
		try{
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArcFinal));
			
			switch (tipoArchivo) { 
				case Enum_Arch_Generar.generaCtasSant:		
					cuentasSantanderBean.setTipoCta(tipoCta);
					cuentasSantanderBean.setEstatus(estatus);
					
					if(tipoCta.equals("A")){
						listaCuentasBanSant = generacionArchPlanosServicio.listaCreaArchivoTxt(Enum_Lis_CuentaSantander.principal, cuentasSantanderBean);
						if (!listaCuentasBanSant.isEmpty()){
							for (CuentasSantanderBean cuentasSantander: listaCuentasBanSant){	
								writer.write(		
									""+cuentasSantander.getTipoCta()+
									""+cuentasSantander.getNumeroCta()+
									""+cuentasSantander.getTitular()
									); 
								writer.newLine(); // Esto es un salto de linea	
								
							}

						}else{
							writer.write("");
						}
					}
					if(tipoCta.equals("O")){
						listaCuentasBanOtros = generacionArchPlanosServicio.listaCreaArchivoTxt(Enum_Lis_CuentaSantander.principal, cuentasSantanderBean);
						if (!listaCuentasBanOtros.isEmpty() && listaCuentasBanOtros!=null){
							for (CuentasSantanderBean cuentasOtros: listaCuentasBanOtros){	
								writer.write(		
									""+cuentasOtros.getTipoCta()+
									""+cuentasOtros.getNumeroCta()+
									""+cuentasOtros.getTitular()+
									""+cuentasOtros.getClaveBanco()+
									""+cuentasOtros.getPazaBanxico()+
									""+cuentasOtros.getSucursal()+
									""+cuentasOtros.getTipoCtaID()+
									""+cuentasOtros.getBenefAppPaterno()+
									""+cuentasOtros.getBenefAppMaterno()+
									""+cuentasOtros.getBenefNombre()+
									""+cuentasOtros.getBenefDireccion()+
									""+cuentasOtros.getBenefCiudad()
									);  

								writer.newLine(); // Esto es un salto de linea	
								
							}

						}else{
							writer.write("");
						}						
					}
				break;
				case Enum_Arch_Generar.generaLayautSanOtros:
					// Transferencias Otros a Traves de Santander
					listaDispersionOtros = operDispersionServicio.layaoutDispTransferenciaOtrosSanta(folioOperacion, institucionID, Enum_TipoArchivo.tranferenciaSanOtros, nombreArcFinal);
					if (!listaDispersionOtros.isEmpty() && listaDispersionOtros!=null){
						
					
					}
					if (!listaDispersionOtros.isEmpty()){
						
						
						for (DispersionGridBean dispersionBean: listaDispersionOtros){
							
							writer.write(	
								""+dispersionBean.getCodigoLayaut()+		// CODIGO LAYOUT
								""+dispersionBean.getGridCuentaAhoID()+		// CUENTA DE CARGO
								""+dispersionBean.getGridCuentaClabe()+		// CUENTA DE ABONO
								""+dispersionBean.getBancoReceptor()+		// BANCO RECEPTOR
								""+dispersionBean.getGridNombreBenefi()+	// BENEFICIARIO
								""+dispersionBean.getSucursalID()+			// SUCURSAL
								""+dispersionBean.getGridMonto()+			// IMPORTE
								""+dispersionBean.getPlazaBanxico()+		// PLAZA BANXICO
								""+dispersionBean.getConcepto()+			// CONCEPTO
								""+dispersionBean.getGridReferencia()+		// REFERENCIA
								""+dispersionBean.getCorreoBeneficiario());	// EMAIL BENEFICIARIO							

							writer.newLine(); 
						
						}
						
						
					}
						
				break;
				case Enum_Arch_Generar.generaCancelacion:
					// Transferencias Otros a Traves de Santander
					listaDispersionOtros = operDispersionServicio.layaoutDispCancelacion(transaccion, institucionID, Enum_TipoArchivo.tranferenciaCancel, nombreArcFinal);
					if (!listaDispersionOtros.isEmpty()){
						
						
						for (DispersionGridBean dispersionBean: listaDispersionOtros){
							
							writer.write(	
								""+dispersionBean.getNumeroOrden());	// Numero de orden
							writer.newLine(); 
						
						}
						
						
					}
					break;
				
			}
			
			

			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArcFinal);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition","attachment;filename="+nombreArch+"-"+numTrans+"-"+aud_fecha+extension);
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

	public GeneracionArchPlanosServicio getGeneracionArchPlanosServicio() {
		return generacionArchPlanosServicio;
	}

	public void setGeneracionArchPlanosServicio(
			GeneracionArchPlanosServicio generacionArchPlanosServicio) {
		this.generacionArchPlanosServicio = generacionArchPlanosServicio;
	}

	public OperDispersionServicio getOperDispersionServicio() {
		return operDispersionServicio;
	}

	public void setOperDispersionServicio(
			OperDispersionServicio operDispersionServicio) {
		this.operDispersionServicio = operDispersionServicio;
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
