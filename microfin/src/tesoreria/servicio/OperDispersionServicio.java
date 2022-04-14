package tesoreria.servicio;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import credito.bean.CreditosBean;

import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.CuentasAhoTesoBean;
import tesoreria.bean.DispersionBean;
import tesoreria.bean.DispersionGridBean;


import tesoreria.dao.OperDispersionDAO;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class OperDispersionServicio extends BaseServicio {
	//---------- Constructor ------------------------------------------------------------------------
	private OperDispersionServicio(){
		super();
	}
	//---------- Variables ------------------------------------------------------------------------
	OperDispersionDAO operDispersionDAO = null;


	public static interface Enum_Lis_Creditos {
		int principal = 1;
	}

	public static interface Enum_Lis_CuentasAho{
		int principal = 1;
		int detalle   = 6;
	}

	public static interface Enum_Con_Dispersion {
		int principal			= 1;
		int consultaLayaout		= 2;
		int consecutivo			= 4;
		int conDisperAut		= 5;
		int conCuentaAhoID		= 6;
		int conNumTransaccion	= 7;
		int dispTransOrderPag	= 8;
		int foranea				= 9;
	}
	
	public static interface Enum_Con_DispersionMov {
		int dispOrderPagSol		= 1;
		int dispOrderPagRef		= 2;
	}

	public static interface Enum_Exp_Dispersion {
		int bancomer   	= 4;
		int santander   = 5;
		int cancelacion   = 6;

	}

	public static interface Enum_Tra_Dispersion {
		int alta 		 	= 1;
		int modificar    	= 2;
		int autoriza	 	= 3;
		int importa			= 4;
		int importaReq		= 5; // para importar los movimientos de Req
		int importaPagoServ	= 6; // para importar los movimientos de pagos de servicios
		int importaAntFact  = 7; // para importar los anticipos de facturas
		int importaBonifica	= 8; // Importar Bonificaciones
		int importarAport	= 9; // para importar las aportaciones
	}

	public static interface Enum_Act_Dispersion {
		int actCuentas 		 = 1;
		int cierraDisp    = 3;
		int autoriza	 = 3;
		int importa		= 4;
	}

	public static interface Enum_Lis_TipoMov{
		int spei = 1;
		int ordenPago = 2;
		int terceros = 3;
		int pagoServicio = 4;
	}

	public static interface Enum_Lis_Equiva{
		String spei = "04";
		String ordenPago = "02";
		String terceros = "02";
		String pagoServicio = "02";
	}

	public static interface Enum_Lis_Dispersion {
		int estatusAbierto = 1; // para listar folios de dispersion con estatus abierto
		int aExportar	= 2; // Lista de dispersiones con movimientos a Exportar archivo spei
		int canOrderPagSol = 3; // Lista para cancelar la dispersion por solicitud de credito
		int canOrderPagRef = 4; // Lista para cancelar la dispersion por referencia
	}

	public static interface Enum_Lis_OrdenPago {
		int encabezado = 1;
		int detalle	= 2;
		int sumario	= 3;
	}

	//---------- Transacciones ------------------------------------------------------------------------


	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, DispersionBean dispersionBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_Dispersion.alta:
			mensaje = altaDispersion(dispersionBean);	// da de alta la dispersion
			break;
		case Enum_Tra_Dispersion.modificar:
			mensaje = modDispersion(dispersionBean); // procesa la informacion que se obtiene
			break;
		case Enum_Tra_Dispersion.autoriza:
			mensaje = operDispersionDAO.actualizaEstatusDispersion(dispersionBean); //Autoriza Dispersion para ya expotar archivos
			break;
		case Enum_Tra_Dispersion.importa:
			mensaje = importaMovimientos(dispersionBean);
			break;
		case Enum_Tra_Dispersion.importaReq:
			mensaje = importaMovimientosReq(dispersionBean);
			break;
		case Enum_Tra_Dispersion.importaPagoServ:
			mensaje = importaPagosServicios(dispersionBean);
			break;
		case Enum_Tra_Dispersion.importaAntFact:
			mensaje = importaAnticiposFacturas(dispersionBean);
			break;
		case Enum_Tra_Dispersion.importaBonifica:
			mensaje = importaBonificaciones(dispersionBean);
			break;
		case Enum_Tra_Dispersion.importarAport:
			mensaje = importaMovAport(dispersionBean);
			break;
		}
		return mensaje;
	}

	public MensajeTransaccionBean importaMovimientos(DispersionBean dispersionBean){
		MensajeTransaccionBean mensaje = null;
		try{
			mensaje = operDispersionDAO.importaMovimientos(dispersionBean);
		}catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en importar movimientos", e);
		}
		return mensaje;
	}

	public MensajeTransaccionBean importaMovAport(DispersionBean dispersionBean){
		MensajeTransaccionBean mensaje = null;
		try{
			mensaje = operDispersionDAO.importaMovimientosAport(dispersionBean);
		}catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en importar movimientos", e);
		}
		return mensaje;
	}
	public MensajeTransaccionBean importaMovimientosReq(DispersionBean dispersionBean){
		MensajeTransaccionBean mensaje = null;
		try{
			mensaje = operDispersionDAO.importaMovimientosReq(dispersionBean);
		}catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en importar movimiento de requisicion", e);
		}
		return mensaje;
	}

	public MensajeTransaccionBean importaPagosServicios(DispersionBean dispersionBean){
		MensajeTransaccionBean mensaje = null;
		try{
			mensaje = operDispersionDAO.importaPagosServicios(dispersionBean);
		}catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en importar pagos de servicios", e);
		}
		return mensaje;
	}

	public MensajeTransaccionBean importaAnticiposFacturas(DispersionBean dispersionBean){
		MensajeTransaccionBean mensaje = null;
		try{
			mensaje = operDispersionDAO.importaAnticiposFacturas(dispersionBean);
		}catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en importar anticipos de facturas", e);
		}
		return mensaje;
	}

	public MensajeTransaccionBean importaBonificaciones(DispersionBean dispersionBean){
		MensajeTransaccionBean mensaje = null;
		try{
			mensaje = operDispersionDAO.importaBonificaciones(dispersionBean);
		}catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en importar las Bonificaciones", e);
		}

		return mensaje;
	}

	public List lista(int tipoLista, DispersionBean dispersionBean){
		List foliosDispersionLis = null;
		switch (tipoLista) {
	        case  Enum_Lis_Dispersion.estatusAbierto:
	        	foliosDispersionLis = operDispersionDAO.listaFoliosEstatusAbierto(dispersionBean, tipoLista);
	        break;
	        case  Enum_Lis_Dispersion.aExportar:
	        	foliosDispersionLis = operDispersionDAO.listaFoliosAExportar(dispersionBean, tipoLista);
	        break;
	        case  Enum_Lis_Dispersion.canOrderPagSol:
	        	foliosDispersionLis = operDispersionDAO.listaCancelaOrdPag(dispersionBean, tipoLista);
	        break;
	        case  Enum_Lis_Dispersion.canOrderPagRef:
	        	foliosDispersionLis = operDispersionDAO.listaCancelaOrdPag(dispersionBean, tipoLista);
	        break;
		}
		return foliosDispersionLis;
	}

	/* Graba los movimientos */
	public MensajeTransaccionBean altaDispersion(DispersionBean dispersionBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = operDispersionDAO.altaMovsDispersion(dispersionBean);
		return mensaje;
	}



	public MensajeTransaccionBean modDispersion( DispersionBean dispersionBean){
		MensajeTransaccionBean mensaje = null;

		ArrayList listaDetalleGrid = (ArrayList) operDispersionDAO.detalleGrid(dispersionBean);
		DispersionGridBean dispersionGridBean;


		int folioOperacion = Utileria.convierteEntero(dispersionBean.getFolioOperacion());

		for(int i=0; i < listaDetalleGrid.size(); i++){
			dispersionGridBean = (DispersionGridBean) listaDetalleGrid.get(i);

			int  claveDisp = Utileria.convierteEntero(dispersionGridBean.getClaveDispersion());

			if(claveDisp==0){// si es nuevo movimiento, entonces es alta
				mensaje = operDispersionDAO.altaCuerpoDetalle(dispersionGridBean, folioOperacion,9);
			}else{// si no entonces modificalo
				mensaje = operDispersionDAO.modificarDispersion(dispersionGridBean, folioOperacion);
			}
		}

		return mensaje;
	}


	/* Consultas y motodos de apoyo para la dispersion*/

	public List cuentasAho(int tipoLista,CuentasAhoTesoBean cuentasAhoTeso){
		List listaCuentas = null;
		switch (tipoLista) {
		case Enum_Lis_Creditos.principal:
			listaCuentas = operDispersionDAO.listaGridCuentasAho(cuentasAhoTeso, tipoLista);
			break;
		}
		return listaCuentas;
	}

	public DispersionBean consulta(int tipoConsulta, DispersionBean dispersionBean){

		DispersionBean dispersion = null;

		switch(tipoConsulta){
		case Enum_Con_Dispersion.foranea:
			dispersion = operDispersionDAO.consultaNombreCuenta(dispersionBean, tipoConsulta);
			break;
		case Enum_Con_Dispersion.principal:
			dispersion = operDispersionDAO.conFolioOperacion(dispersionBean, tipoConsulta);
			break;
		case Enum_Con_Dispersion.conCuentaAhoID:
			dispersion = operDispersionDAO.consultaNombreCuenta(dispersionBean, tipoConsulta);
			break;
		case Enum_Con_Dispersion.conDisperAut:
			dispersion = operDispersionDAO.dispersionAutorizada(dispersionBean, tipoConsulta);
			break;
		case Enum_Con_Dispersion.conNumTransaccion:
			dispersion = operDispersionDAO.conNumTransaccion(dispersionBean, tipoConsulta);
			break;
		case Enum_Con_Dispersion.dispTransOrderPag:
			dispersion = operDispersionDAO.conDispTransOrderPag(dispersionBean, tipoConsulta);
			break;
		}
		return dispersion;
	}
	
	public DispersionBean consultaMovs(int tipoConsulta, DispersionBean dispersionBean){
		DispersionBean dispersion = null;

		switch(tipoConsulta){
			case Enum_Con_DispersionMov.dispOrderPagSol:
				dispersion = operDispersionDAO.conDispOrderPag(dispersionBean, tipoConsulta);
				break;
			case Enum_Con_DispersionMov.dispOrderPagRef:
				dispersion = operDispersionDAO.conDispOrderPag(dispersionBean, tipoConsulta);
				break;
		}

		return dispersion;
	}
	
	/* Exportar archivo de Dipersion */
	public List obtieneLayaoutDispersion(int folioOperacion,int institucionID){
		List<DispersionGridBean> listaRegistros = null;
		List <DispersionGridBean> lista = new ArrayList();

		DispersionGridBean dispersion = null;
		String vacio = "";

		listaRegistros = operDispersionDAO.buscaDatosDispersion(folioOperacion, institucionID, Enum_Con_Dispersion.consultaLayaout);

		//Agregar una bandera que indique cuando un registro no cumple con las requisitos, esto para generar al final como error

		for (DispersionGridBean listaDispersion: listaRegistros){

			dispersion = new DispersionGridBean();

			String NombreBeneficiario = (listaDispersion.getNombreBeneficiario()!=null) ? listaDispersion.getNombreBeneficiario() : vacio;



			switch (Integer.parseInt(listaDispersion.getGridTipoMov())) {
			case Enum_Lis_TipoMov.spei:
				dispersion.setGridTipoMov((Enum_Lis_Equiva.spei).trim()); //Tipo de operacion
				dispersion.setClaveDispersion(Utileria.agregaEspacioDer(listaDispersion.getClaveDispersion(), 13)); //Consecutivo de la tabla Como Clave-ID
				dispersion.setGridReferencia(Utileria.completaCerosIzquierda(listaDispersion.getGridReferencia(),10)); //Referencia
				dispersion.setGridDescripcion(Utileria.agregaEspacioDer(listaDispersion.getGridDescripcion(),30));  // Descripcion
				dispersion.setGridRFC(Utileria.agregaEspacioDer(listaDispersion.getGridRFC(),13)); // RFC
				dispersion.setFechaAplicar(Utileria.formatoFecha(listaDispersion.getFechaAplicar())); // Fecha para aplicar
				dispersion.setNombreBeneficiario(Utileria.agregaEspacioDer(NombreBeneficiario,70)); // NOmbre Beneficiario
				break;
			case Enum_Lis_TipoMov.ordenPago:
				dispersion.setGridTipoMov((Enum_Lis_Equiva.ordenPago).trim()); //Tipo de operacion
				dispersion.setNombreBeneficiario(Utileria.agregaEspacioDer(NombreBeneficiario,70)); // NOmbre Beneficiario
				break;
			case Enum_Lis_TipoMov.terceros:
				dispersion.setGridTipoMov((Enum_Lis_Equiva.terceros).trim());
				dispersion.setClaveDispersion(Utileria.agregaEspacioDer(listaDispersion.getClaveDispersion(), 13)); //Consecutivo de la tabla Como Clave-ID
				dispersion.setGridReferencia(Utileria.completaCerosIzquierda(listaDispersion.getGridReferencia(),10)); //Referencia
				break;
			case Enum_Lis_TipoMov.pagoServicio:
				dispersion.setGridTipoMov((Enum_Lis_Equiva.pagoServicio).trim()); //Tipo de operacion
				break;
			default:
				dispersion.setClaveDispersion(Utileria.agregaEspacioDer(vacio, 13)); //Consecutivo de la tabla Como Clave-ID
				dispersion.setGridReferencia(Utileria.completaCerosIzquierda(listaDispersion.getGridReferencia(),10)); //Referencia
				dispersion.setGridDescripcion(Utileria.agregaEspacioDer(listaDispersion.getGridDescripcion(),30));  // Descripcion
				dispersion.setGridRFC(Utileria.agregaEspacioDer(listaDispersion.getGridRFC(),13)); // RFC
				dispersion.setFechaAplicar(Utileria.agregaEspacioDer(vacio, 8)); // Fecha para aplicar
				dispersion.setNombreBeneficiario(Utileria.agregaEspacioDer(NombreBeneficiario, 70)); // NOmbre Beneficiario
				break;
			}

			dispersion.setGridCuentaAhoID(Utileria.completaCerosIzquierda(listaDispersion.getGridCuentaAhoID(), 20)); //Cuenta Origen
			dispersion.setGridCuentaClabe(Utileria.completaCerosIzquierda(listaDispersion.getGridCuentaClabe(), 20)); //Cuenta o Cuenta Clable
			dispersion.setGridMonto(Utileria.completaCerosIzquierda(listaDispersion.getGridMonto().replace(".", ""), 14)); //Monto o Importe
			dispersion.setIva(Utileria.completaCerosIzquierda(vacio,14)); // IVA

			lista.add(dispersion);
		}

		return lista;
	}



	/* Exportar archivo de Dipersion Mifel*/
	public List obtieneLayaoutDispersionMifel(int folioOperacion,int institucionID){
		List<DispersionGridBean> listaRegistros = null;
		List <DispersionGridBean> lista = new ArrayList();

		DispersionGridBean dispersion = null;
		String vacio = "";

		listaRegistros = operDispersionDAO.buscaDatosDispersion(folioOperacion, institucionID, Enum_Con_Dispersion.consultaLayaout);


		for (DispersionGridBean listaDispersion: listaRegistros){

			dispersion = new DispersionGridBean();

			String NombreBeneficiario = (listaDispersion.getNombreBeneficiario()!=null) ? listaDispersion.getNombreBeneficiario() : vacio;



			dispersion.setGridCuentaAhoID(Utileria.completaCerosIzquierda(listaDispersion.getGridCuentaAhoID(),11)); //Cuenta Origen

			dispersion.setGridCuentaClabe(listaDispersion.getGridCuentaClabe()); //Cuenta o Cuenta Clable
			dispersion.setGridMonto(listaDispersion.getGridMonto()); //Monto o Importe
			dispersion.setClaveDispersion(listaDispersion.getClaveDispersion());
			dispersion.setGridDescripcion(listaDispersion.getGridDescripcion().trim());  // Descripcion
			dispersion.setGridRFC(listaDispersion.getGridRFC()); // RFC
			dispersion.setIva(listaDispersion.getIva()); // IVA
			dispersion.setGridReferencia(listaDispersion.getGridReferencia()); //Referencia
			//-----------------------------------------------------------------------


			lista.add(dispersion);
		}

		return lista;


	}


	/* Exportar archivo de Dipersion Bancomer*/
	public List obtieneLayaoutDispersionBancomer(int folioOperacion,int institucionID){
		List<DispersionGridBean> listaRegistros = null;
		List <DispersionGridBean> lista = new ArrayList();

		DispersionGridBean dispersion = null;
		String vacio = "";

		listaRegistros = operDispersionDAO.buscaDatosDispersionBancomer(folioOperacion, institucionID,Enum_Exp_Dispersion.bancomer);


		for (DispersionGridBean listaDispersion: listaRegistros){

			dispersion = new DispersionGridBean();

			String NombreBeneficiario = (listaDispersion.getNombreBeneficiario()!=null) ? listaDispersion.getNombreBeneficiario() : vacio;



			dispersion.setGridCuentaAhoID(Utileria.completaCerosIzquierda(listaDispersion.getGridCuentaAhoID(),18)); //Cuenta Origen

			dispersion.setGridCuentaClabe(Utileria.completaCerosIzquierda(listaDispersion.getGridCuentaClabe(),18)); //Cuenta o Cuenta Clable
			dispersion.setGridMonto(Utileria.completaCerosIzquierda(listaDispersion.getGridMonto(),16)); //Monto o Importe
			dispersion.setClaveDispersion(Utileria.agregaEspacioDer(listaDispersion.getClaveDispersion(),30));
			dispersion.setGridDescripcion(Utileria.agregaEspacioDer(listaDispersion.getGridDescripcion(),30));  // Descripcion
			dispersion.setGridRFC(Utileria.agregaEspacioDer(listaDispersion.getGridRFC(),13)); // RFC
			dispersion.setGridReferencia(Utileria.completaCerosIzquierda(listaDispersion.getGridReferencia(),7)); //Referencia
			dispersion.setGridFormaPago(listaDispersion.getGridFormaPago());
			dispersion.setGridNombreBenefi(Utileria.agregaEspacioDer(NombreBeneficiario,30));
			//-----------------------------------------------------------------------


			lista.add(dispersion);
		}

		return lista;


	}
	
	/* Exportar archivo de Dipersion Orden de Pago */
	public List obtieneLayaoutDispersionSantander(int folioOperacion,int institucionID, String tipoArchivo, String NombreArchivo){
		List<DispersionGridBean> listaRegistros = null;
		List <DispersionGridBean> lista = new ArrayList();

		DispersionGridBean dispersion = null;
		String vacio = "";

		listaRegistros = operDispersionDAO.buscaDatosDispOrdenpagSan(folioOperacion, institucionID, Enum_Exp_Dispersion.santander, tipoArchivo, NombreArchivo);

		//Agregar una bandera que indique cuando un registro no cumple con las requisitos, esto para generar al final como error

		for (DispersionGridBean listaDispersion: listaRegistros){

			dispersion = new DispersionGridBean();

			String NombreBeneficiario = (listaDispersion.getNombreBeneficiario()!=null) ? listaDispersion.getNombreBeneficiario() : vacio;
			
			dispersion.setGridCuentaAhoID(listaDispersion.getGridCuentaAhoID()); 		// NUMERO DE CUENTA
			dispersion.setClaveDispersion(listaDispersion.getClaveDispersion()); 		// NUMERO DE ORDEN
			dispersion.setFechaAplicacion(listaDispersion.getFechaAplicacion());		// FECHA DE APLICACION
			dispersion.setFechaAplicar(listaDispersion.getFechaAplicar()); 				// FECHA LIMITE DE PAGO
			dispersion.setGridRFC(listaDispersion.getGridRFC()); 						// RFC
			dispersion.setNombreBeneficiario(listaDispersion.getNombreBeneficiario()); 	// NOmbre Beneficiario
			dispersion.setClaveSucursales(listaDispersion.getClaveSucursales());		// Clave Sucursales
			dispersion.setClaveSucursal(listaDispersion.getClaveSucursal());			// Clave Sucursal
			dispersion.setTipoPago(listaDispersion.getTipoPago());						// Tipo de pago
			dispersion.setGridMonto(listaDispersion.getGridMonto());					// Monto o Importe
			dispersion.setConcepto(listaDispersion.getConcepto());  					// Concepto

			lista.add(dispersion);
		}
		return lista;
	}
	
	/* Exportar archivo de Dipersion de Transferencia Santander*/
	public List layaoutDispTransferenciaSanta(int folioOperacion,int institucionID, String tipoArchivo, String NombreArchivo){
		List<DispersionGridBean> listaRegistros = null;
		List <DispersionGridBean> lista = new ArrayList();

		DispersionGridBean dispersion = null;
		String vacio = "";
		
		listaRegistros = operDispersionDAO.buscaDatosDispersionSantander(folioOperacion, institucionID,Enum_Exp_Dispersion.santander, tipoArchivo, NombreArchivo);

		for (DispersionGridBean listaDispersion: listaRegistros){

			dispersion = new DispersionGridBean();
			String NombreBeneficiario = (listaDispersion.getNombreBeneficiario()!=null) ? listaDispersion.getNombreBeneficiario() : vacio;

			dispersion.setCodigoLayaut(listaDispersion.getCodigoLayaut());				// Codigo del layaut
			dispersion.setGridCuentaClabe(listaDispersion.getGridCuentaClabe()); 		// Cuenta o Cuenta Clable Abono
			dispersion.setGridCuentaAhoID(listaDispersion.getGridCuentaAhoID()); 		// Cuenta Cargo			
			dispersion.setGridMonto(listaDispersion.getGridMonto()); 					// Monto o Importe
			dispersion.setGridDescripcion(listaDispersion.getGridDescripcion());  		// Descripcion
			dispersion.setConcepto(listaDispersion.getConcepto());						// Concepto
			dispersion.setCorreoBeneficiario(listaDispersion.getCorreoBeneficiario());	// Correo del beneficiario
			dispersion.setClaveDispersion(listaDispersion.getClaveDispersion());		// Clave dispersion
			dispersion.setGridRFC(listaDispersion.getGridRFC()); 						// RFC
			dispersion.setGridReferencia(listaDispersion.getGridReferencia()); 			// Referencia
			dispersion.setGridFormaPago(listaDispersion.getGridFormaPago());			// Forma de pago
			dispersion.setGridNombreBenefi(listaDispersion.getNombreBeneficiario());	// Nombre del beneficiario
			dispersion.setFechaAplicacion(listaDispersion.getFechaAplicacion());
			//-----------------------------------------------------------------------

			lista.add(dispersion);
		}

		return lista;

	}
	
	/* Exportar archivo de Dipersion de Transferencia de Otros a traves de Santander*/
	public List layaoutDispTransferenciaOtrosSanta(int folioOperacion,int institucionID, String tipoArchivo, String NombreArchivo){
		List<DispersionGridBean> listaRegistros = null;
		List <DispersionGridBean> lista = new ArrayList();
		
		DispersionGridBean dispersion = null;
		String vacio = "";
		
		listaRegistros = operDispersionDAO.buscaDatosDispersionOtrosSantander(folioOperacion, institucionID,Enum_Exp_Dispersion.santander, tipoArchivo, NombreArchivo);
		
		for (DispersionGridBean listaDispersion: listaRegistros){
			
			dispersion = new DispersionGridBean();
			String NombreBeneficiario = (listaDispersion.getNombreBeneficiario()!=null) ? listaDispersion.getNombreBeneficiario() : vacio;
			
			dispersion.setCodigoLayaut(listaDispersion.getCodigoLayaut());				// Codigo del layaut
			dispersion.setGridCuentaAhoID(listaDispersion.getGridCuentaAhoID()); 		// Cuenta Cargo	
			dispersion.setGridCuentaClabe(listaDispersion.getGridCuentaClabe()); 		// Cuenta o Cuenta Clable Abono
			dispersion.setBancoReceptor(listaDispersion.getBancoReceptor());			// banco Receptor
			dispersion.setGridNombreBenefi(listaDispersion.getNombreBeneficiario());	// Nombre del beneficiario
			dispersion.setSucursalID(listaDispersion.getSucursalID());					// Sucursal
			dispersion.setGridMonto(listaDispersion.getGridMonto()); 					// Monto o Importe
			dispersion.setPlazaBanxico(listaDispersion.getPlazaBanxico());				// Plaza banxico
			dispersion.setConcepto(listaDispersion.getConcepto());						// Concepto
			dispersion.setGridReferencia(listaDispersion.getGridReferencia()); 			// Referencia
			dispersion.setCorreoBeneficiario(listaDispersion.getCorreoBeneficiario());	// Correo del beneficiario
			
			dispersion.setGridDescripcion(listaDispersion.getGridDescripcion());  		// Descripcion
			dispersion.setClaveDispersion(listaDispersion.getClaveDispersion());		// Clave dispersion
			dispersion.setGridRFC(listaDispersion.getGridRFC()); 						// RFC			
			dispersion.setGridFormaPago(listaDispersion.getGridFormaPago());			// Forma de pago
			
			//-----------------------------------------------------------------------
			
			lista.add(dispersion);
		}
		
		return lista;
		
	}
	public List layaoutDispCancelacion(long folioOperacion,int institucionID, String tipoArchivo, String NombreArchivo){
		List<DispersionGridBean> listaRegistros = null;
		List <DispersionGridBean> lista = new ArrayList();

		DispersionGridBean dispersion = null;
		String vacio = "";
		
		listaRegistros = operDispersionDAO.buscaDatosDispersionCanc(folioOperacion, institucionID,Enum_Exp_Dispersion.cancelacion, tipoArchivo, NombreArchivo);

		for (DispersionGridBean listaDispersion: listaRegistros){

			dispersion = new DispersionGridBean();
			String NombreBeneficiario = (listaDispersion.getNombreBeneficiario()!=null) ? listaDispersion.getNombreBeneficiario() : vacio;

			dispersion.setNumeroOrden(listaDispersion.getNumeroOrden());
			
			//-----------------------------------------------------------------------

			lista.add(dispersion);
		}

		return lista;

	}

	/*case para listas de reportes de proteccion de orden de pago (Bancomer)*/
	public List listaReportesPorteccionOrdenP(int tipoLista, DispersionBean dispersionBean, HttpServletResponse response){

		 List listaProteccion=null;

		switch(tipoLista){

			case Enum_Lis_OrdenPago.encabezado:
				listaProteccion = operDispersionDAO.listaReportesProteccionEnc(dispersionBean, Enum_Lis_OrdenPago.encabezado);
				break;

			case Enum_Lis_OrdenPago.detalle:
				listaProteccion = operDispersionDAO.listaReportesProteccion(dispersionBean, Enum_Lis_OrdenPago.detalle);
				break;

			case Enum_Lis_OrdenPago.sumario:
				listaProteccion = operDispersionDAO.listaReportesProteccionFin(dispersionBean, Enum_Lis_OrdenPago.sumario);
				break;
		}

		return listaProteccion;
	}

	// reporte

	public ByteArrayOutputStream reporteDispersionPDF(DispersionBean dispersionBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio", dispersionBean.getFechaInicio() );
		parametrosReporte.agregaParametro("Par_FechaFin", dispersionBean.getFechaFin() );
		parametrosReporte.agregaParametro("Par_InstitucionID", Utileria.convierteEntero(dispersionBean.getInstitucionID()));
		parametrosReporte.agregaParametro("Par_CuentaAhoID", Utileria.convierteLong(dispersionBean.getCuentaAhorro()));
		parametrosReporte.agregaParametro("Par_EstatusEnc", dispersionBean.getEstatusEnc() );
		parametrosReporte.agregaParametro("Par_EstatusDet", dispersionBean.getEstatusDet() );
		parametrosReporte.agregaParametro("Par_Sucursal", Utileria.convierteEntero(dispersionBean.getSucursal()));
		parametrosReporte.agregaParametro("Par_FechaEmision", dispersionBean.getFechaEmision() );

		parametrosReporte.agregaParametro("Par_NomSucursal",(!dispersionBean.getNomSucursal().isEmpty())? dispersionBean.getNomSucursal():"TODAS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!dispersionBean.getNomUsuario().isEmpty())?dispersionBean.getNomUsuario(): "");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!dispersionBean.getNomInstitucion().isEmpty())?dispersionBean.getNomInstitucion(): "");
		parametrosReporte.agregaParametro("Par_NomInstitucionID",(!dispersionBean.getNomInstitucionID().isEmpty())?dispersionBean.getNomInstitucionID(): "TODAS");
		parametrosReporte.agregaParametro("Par_NomEstatus",(!dispersionBean.getNomEstatus().isEmpty())?dispersionBean.getNomEstatus(): "TODOS");
		parametrosReporte.agregaParametro("Par_NomEstatusMov",(!dispersionBean.getNomEstatusMov().isEmpty())?dispersionBean.getNomEstatusMov(): "TODOS");
		parametrosReporte.agregaParametro("Par_NomCuentaAho",(!dispersionBean.getNombreCuentAho().isEmpty())?dispersionBean.getNombreCuentAho(): "TODAS");


		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public String reporteDispPantalla(DispersionBean dispersionBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio", dispersionBean.getFechaInicio() );
		parametrosReporte.agregaParametro("Par_FechaFin", dispersionBean.getFechaFin() );
		parametrosReporte.agregaParametro("Par_InstitucionID", Utileria.convierteEntero(dispersionBean.getInstitucionID()));
		parametrosReporte.agregaParametro("Par_CuentaAhoID", Utileria.convierteLong(dispersionBean.getCuentaAhorro()));
		parametrosReporte.agregaParametro("Par_EstatusEnc", dispersionBean.getEstatusEnc() );
		parametrosReporte.agregaParametro("Par_EstatusDet", dispersionBean.getEstatusDet() );
		parametrosReporte.agregaParametro("Par_Sucursal", Utileria.convierteEntero(dispersionBean.getSucursal()));
		parametrosReporte.agregaParametro("Par_FechaEmision", dispersionBean.getFechaEmision() );

		parametrosReporte.agregaParametro("Par_NomSucursal",(!dispersionBean.getNomSucursal().isEmpty())? dispersionBean.getNomSucursal():"TODAS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!dispersionBean.getNomUsuario().isEmpty())?dispersionBean.getNomUsuario(): "");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!dispersionBean.getNomInstitucion().isEmpty())?dispersionBean.getNomInstitucion(): "");
		parametrosReporte.agregaParametro("Par_NomInstitucionID",(!dispersionBean.getNomInstitucionID().isEmpty())?dispersionBean.getNomInstitucionID(): "TODAS");
		parametrosReporte.agregaParametro("Par_NomEstatus",(!dispersionBean.getNomEstatus().isEmpty())?dispersionBean.getNomEstatus(): "TODOS");
		parametrosReporte.agregaParametro("Par_NomEstatusMov",(!dispersionBean.getNomEstatusMov().isEmpty())?dispersionBean.getNomEstatusMov(): "TODOS");
		parametrosReporte.agregaParametro("Par_NomCuentaAho",(!dispersionBean.getNombreCuentAho().isEmpty())?dispersionBean.getNombreCuentAho(): "TODAS");


		return Reporte.creaHtmlReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	public List listaRepDispersionExcel(int tipoLista, DispersionBean dispersionBean, HttpServletResponse response){
		List listaDispersion=null;

		listaDispersion=operDispersionDAO.consultaRepDispersionesExcel(dispersionBean, tipoLista);

		return listaDispersion;
	}


	// METODO PARA GENERAR LAS ORDENES DE PAGO EN PDF
	public ByteArrayOutputStream reporteDispOrdenPagPDF(DispersionBean dispersionBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();

		parametrosReporte.agregaParametro("Par_InstitucionID", Utileria.convierteEntero(dispersionBean.getInstitucionID()));
		parametrosReporte.agregaParametro("Par_CuentaAhoID", dispersionBean.getCuentaAhorro());
		parametrosReporte.agregaParametro("Par_Sucursal", Utileria.convierteEntero(dispersionBean.getSucursal()));
		parametrosReporte.agregaParametro("Par_FechaEmision", dispersionBean.getFechaEmision() );
		parametrosReporte.agregaParametro("Par_FolioOperacion", dispersionBean.getFolioOperacion() );
		parametrosReporte.agregaParametro("Par_Referencia", dispersionBean.getReferenciaDisp() );
		parametrosReporte.agregaParametro("Par_Monto", Utileria.convierteDoble(dispersionBean.getMontoDisp()));
		parametrosReporte.agregaParametro("Par_CuentaClabe", dispersionBean.getCuentaClabeDisp() );
		parametrosReporte.agregaParametro("Par_FechaEnvio", dispersionBean.getFechaEnvioDisp() );

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	//---------- Asignaciones -----------------------------------------------------------------------
	public void setOperDispersionDAO(OperDispersionDAO operDispersionDAO) {
		this.operDispersionDAO = operDispersionDAO;
	}

	public OperDispersionDAO getOperDispersionDAO() {
		return operDispersionDAO;
	}

}

