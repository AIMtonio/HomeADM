package arrendamiento.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import arrendamiento.bean.ArrendamientosBean;
import arrendamiento.bean.DepositoRefereArrendaBean;
import arrendamiento.bean.ResultadoCargaArchivosArrendaBean;
import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;

public class DepositoRefereArrendaDAO extends BaseDAO{
    PolizaDAO	polizaDAO	= null;
	PolizaBean	polizaBean	= new PolizaBean();
	ArrendamientosDAO arrendamientosDAO = null;

	ParametrosSesionBean parametrosSesionBean;
	Logger log = Logger.getLogger( this.getClass() );

	private final static String salidaPantalla = "S";
	private final static String esPrepago = "N";
	private final static String altaEnPolizaNo = "N";
	private final static String altaEnPolizaSi = "S";
	String numcredito = "";  // guarda el numero del credito que se a dado de alta
	String mensajedes = "";  // mesaje del credito

	public DepositoRefereArrendaDAO (){
		super();
	}


	public static interface Enum_Tra_NatMovimi {
		String abono = "A";
		String vacio = " ";
	}

	final	String saltoLinea=" <br> ";
	public ResultadoCargaArchivosArrendaBean altaDepositosRefere(final DepositoRefereArrendaBean refeBean,
			final ResultadoCargaArchivosArrendaBean result, final int institucionID, final double numeroTransaccion, final long varDepRefereID  ){
		ResultadoCargaArchivosArrendaBean resultCarga = new ResultadoCargaArchivosArrendaBean();
		resultCarga = (ResultadoCargaArchivosArrendaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				try {
					MensajeTransaccionBean mensaje = null;
					// Realiza el proceso de Depositos
					mensaje = procesoDepositoRefere(institucionID, refeBean, numeroTransaccion, varDepRefereID);
					result.setNumero(mensaje.getNumero());
					result.setDescripcion(mensaje.getDescripcion());
					result.setConsecutivoInt(mensaje.getConsecutivoInt());
					if(mensaje.getNumero()==0){
						result.setExitosos(result.getExitosos()+1);
					}else{
						result.setFallidos(result.getFallidos()+1);
						result.setDescripcion("Error en linea:"+(result.getExitosos() + result.getFallidos())+" <br> "
								+mensaje.getDescripcion());
					}
				}catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de deposito referenciado", e);
					//transaction.setRollbackOnly();
					result.setFallidos(result.getFallidos()+1);
				}
				return result;
			}
		});
		return result;
	}


	public MensajeTransaccionBean procesoDepositoRefere(final int institucionID, final DepositoRefereArrendaBean refeBean,	final double numeroTransaccion, final long varDepRefereID){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call DEPOSITOREFEREARRENDAPRO(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_InstitucionID",institucionID);
							sentenciaStore.setLong("Par_DepRefereID", varDepRefereID);
							sentenciaStore.setString("Par_NumCtaInstit",refeBean.getNumCtaInstit());
							sentenciaStore.setDate("Par_FechaOperacion",OperacionesFechas.conversionStrDate(refeBean.getFechaOperacion()));
							sentenciaStore.setString("Par_ReferenciaMov",refeBean.getReferenciaMov());

							sentenciaStore.setString("Par_DescripcionMov",refeBean.getDescripcionMov());
							sentenciaStore.setString("Par_NatMovimiento",refeBean.getNatMovimiento());
							sentenciaStore.setDouble("Par_MontoMov",Utileria.convierteDoble(refeBean.getMontoMov()));
							sentenciaStore.setInt("Par_TipoCanal",Utileria.convierteEntero(refeBean.getTipoCanal()));
							sentenciaStore.setString("Par_TipoDeposito",refeBean.getTipoDeposito());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);
							sentenciaStore.registerOutParameter("Var_FolioDepRefe", Types.BIGINT);

							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID","DepositosRefeDAO.altaDepositosRefere");

							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",(long) numeroTransaccion);
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
						DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					//transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de deposito referencido", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/*METODO PARA CARGA DEL ARCHIVO ESTANDAR*/
	public ResultadoCargaArchivosArrendaBean cargaArchivo(final String rutaArchivo, final DepositoRefereArrendaBean depositosRefeBean){
		ResultadoCargaArchivosArrendaBean resultado = new ResultadoCargaArchivosArrendaBean();
		transaccionDAO.generaNumeroTransaccion();
		resultado = (ResultadoCargaArchivosArrendaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				ResultadoCargaArchivosArrendaBean resultadoCarga =new ResultadoCargaArchivosArrendaBean();
				resultadoCarga.setExitosos(0);
				resultadoCarga.setFallidos(0);
				int tamanoLista=0;
				long varDepRefereID = 0;
				try{
					List <DepositoRefereArrendaBean> depositoReferenciado = leeArchivo(rutaArchivo);
					if(depositoReferenciado!=null && depositoReferenciado.size() > 0){
						tamanoLista= depositoReferenciado.size();

						Iterator <DepositoRefereArrendaBean> iterList = depositoReferenciado.iterator();
						int intitucionID = Integer.parseInt(depositosRefeBean.getInstitucionID());
						String motivoDescripcion = saltoLinea+ "Motivo:El archivo se ha cargado exitosamente.";
						DepositoRefereArrendaBean refeBean;
						transaccionDAO.generaNumeroTransaccion();
						double numeroTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();
						while(iterList.hasNext()){
							refeBean = (DepositoRefereArrendaBean) iterList.next();
							if(refeBean.getNumError().equals("0")){
								// se valida que el movimiento este entre el rango de fechas, si no esta simplemente no lo agrega
								Date fechaInicial;
								Date fechaFinal;
								Date fechaConcilia;
								fechaInicial 	= OperacionesFechas.conversionStrDate(depositosRefeBean.getFechaCargaInicial());
								fechaFinal 		= OperacionesFechas.conversionStrDate(depositosRefeBean.getFechaCargaFinal());
								fechaConcilia 	= OperacionesFechas.conversionStrDate(refeBean.getFechaOperacion());
								if( (fechaConcilia.after(fechaInicial) && fechaConcilia.before(fechaFinal) || fechaConcilia.equals(fechaInicial) || fechaConcilia.equals(fechaFinal)) ){
									if(depositosRefeBean.getNumCtaInstit().equals(refeBean.getNumCtaInstit())){
										resultadoCarga =  altaDepositosRefere(refeBean, resultadoCarga, intitucionID,numeroTransaccion, varDepRefereID);
										varDepRefereID = Utileria.convierteLong(resultadoCarga.getConsecutivoInt());
										if(resultadoCarga.getNumero()!=0){
											throw new Exception(resultadoCarga.getDescripcion());
										}
										resultadoCarga.setDescripcion("Total Registros:"+tamanoLista+
												saltoLinea+"Exitosos:"+resultadoCarga.getExitosos()+
												saltoLinea+"Excluidos:"+resultadoCarga.getFallidos()+
												motivoDescripcion);

									}else{
										resultadoCarga.setNumero(998);
										resultadoCarga.setDescripcion("El numero de cuenta de institucion no coincide con el numero de cuenta del archivo cargado.");
										throw new Exception(resultadoCarga.getDescripcion());
									}
								}else{
									motivoDescripcion = saltoLinea+"Motivo:La fecha de los movimientos no coincide con el rango de fechas de carga";
									resultadoCarga.setFallidos(resultadoCarga.getFallidos()+1);
									resultadoCarga.setDescripcion(
											"Total Registros:"+tamanoLista+
											saltoLinea+"Exitosos:"+resultadoCarga.getExitosos()+
											saltoLinea+"Excluidos:"+resultadoCarga.getFallidos()+
											motivoDescripcion
											);
									throw new Exception(resultadoCarga.getDescripcion());
								}
							}else{
								resultadoCarga.setFallidos(resultadoCarga.getFallidos()+1);
								resultadoCarga.setDescripcion(refeBean.getDescError());
								throw new Exception(resultadoCarga.getDescripcion());
							}
						}
					}else{
						resultadoCarga.setDescripcion("Asegurese de subir el archivo con el formato correcto.");
						throw new Exception(resultadoCarga.getDescripcion());
					}
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en carga de archivo", e);
					resultadoCarga.setConsecutivoInt("institucionID");
					resultadoCarga.setConsecutivoString("institucionID");
					resultadoCarga.setNumero(999);
					resultadoCarga.setDescripcion("Total Registros:"+tamanoLista+
							saltoLinea+"Exitosos:"+0+
							saltoLinea+"Fallidos:"+tamanoLista+
					saltoLinea+resultadoCarga.getDescripcion()
					);
					transaction.setRollbackOnly();
				}
				return resultadoCarga;
			}
		});
		return resultado;
	}

	// METODO PARA LEER EL ARCHIVO
	public List<DepositoRefereArrendaBean> leeArchivo(String rutaArchivo){
		ArrayList<DepositoRefereArrendaBean> listaDep = new ArrayList<DepositoRefereArrendaBean>();
		BufferedReader bufferedReader;
		String [] arreglo = null;
		int contadorErr =0;
		int contador =1;
		DepositoRefereArrendaBean depRefe;
		String renglon;
		try {
			bufferedReader = new BufferedReader(new FileReader(rutaArchivo));
			while ((renglon = bufferedReader.readLine())!= null && !renglon.trim().equals("")){
				arreglo = renglon.split("\\|");
				depRefe = new DepositoRefereArrendaBean();
				//0NumCtaInstit|1Fecha(yyyy-MM-dd)|2ReferenciaDeposito|3Descripcion|
				//4TipoDeposito(1= arrendamiento; 2 = cliente)|5Monto|6TipoDeposito T - Tranferencia; E - Efectivo; C=Cheque
				//8049184|2012-01-01|1234567890|Pago a credito|A|123.89|37.00|01|E|01
				depRefe.setNumError("0");
				depRefe.setNumCtaInstit(arreglo[0].trim());
				if(validarFecha(arreglo[1])){
					depRefe.setFechaOperacion(arreglo[1]);
				}else{
					depRefe.setNumError("111");
					depRefe.setDescError("Error en linea: " +contador +saltoLinea+" Motivo: Formato Incorrecto en Fecha de Operacion");
					depRefe.setLineaError(contador);
				}
				if(arreglo[2].length()<=150){
					depRefe.setReferenciaMov(arreglo[2]);
				}
				else{
					depRefe.setNumError("222");
					depRefe.setDescError("Error en linea: " +contador +saltoLinea+" Motivo: La Referencia no debe ser mayor a 150 caracteres.");
					depRefe.setLineaError(contador);
				}
				if(arreglo[3].length()<=150){
					depRefe.setDescripcionMov(arreglo[3].trim());
				}
				else{
					depRefe.setNumError("333");
					depRefe.setDescError("Error en linea: " +contador +saltoLinea+" Motivo: La Descripcion no debe ser mayor a 150 caracteres.");
					depRefe.setLineaError(contador);
				}
				if(esCantidadPositiva(arreglo[4])){
					depRefe.setTipoCanal(arreglo[4]);
				}else{
					depRefe.setNumError("777");
					depRefe.setDescError("Error en linea: " +contador +saltoLinea+" Motivo: Valor incorrecto para Tipo de Deposito.");
					depRefe.setLineaError(contador);
				}
				if(esCantidadPositiva(arreglo[5].trim().replaceAll(",","").replaceAll("\\$",""))){
					depRefe.setMontoMov(arreglo[5].trim().replaceAll(",","").replaceAll("\\$",""));
				}else{
					depRefe.setNumError("555");
					depRefe.setDescError("Error en linea: " +contador +saltoLinea+" Motivo: El Monto del Movimiento es negativo o no coincide con el formato numerico.");
					depRefe.setLineaError(contador);
				}
				if(arreglo[6].equals("E") || arreglo[6].equals("T") ||arreglo[6].equals("C")){
					depRefe.setTipoDeposito(arreglo[6]);
				}else{
					depRefe.setNumError("888");
					depRefe.setDescError("Error en linea: " +contador +saltoLinea+" Motivo: Valor incorrecto para Forma de Deposito.");
					depRefe.setLineaError(contador);
				}
				if(!depRefe.getNumError().equals("0")){
					contadorErr++;
				}
				listaDep.add(depRefe);
				contador++;
			}
		}catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lee archivo dep refere arrenda", e);
			listaDep=null;
		}
		return listaDep;
	}


	public boolean validarFecha(String fecha) {
		if (fecha == null)
			return false;

		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); //a√±o-mes-dia
		if (fecha.trim().length() != dateFormat.toPattern().length())
			return false;

		dateFormat.setLenient(false);
		try {
			dateFormat.parse(fecha.trim());
		}catch ( Exception pe) {
			return false;
		}
		return true;
	}

	public boolean esCantidadPositiva(String cantidad){
		float cantidadFloat=0;
		boolean resul=true;
		try{
			cantidadFloat = Float.parseFloat(cantidad);
			if(cantidadFloat<=0){ resul=false;}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cantidad positiva ", e);
			resul= false;
		}
		return resul;
	}

	public boolean esCantidadPositivaMPA(String cantidad){
		float cantidadFloat=0;
		boolean resul=true;
		try{
			cantidadFloat = Float.parseFloat(cantidad);
			if(cantidadFloat<0){ resul=false;}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cantidad positiva", e);
			resul= false;
		}
		return resul;
	}

	// lista de arrendamientos
	public List listaPrincipalDepRefere(int tipoLista, DepositoRefereArrendaBean depositoRefereArrendaBean) {
		List listaArrendamientos = null;
		try{
			String query = "call DEPOSITOREFEREARRENDALIS(" +
					"?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(depositoRefereArrendaBean.getDepRefereID()),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"DepositoRefereArrendaDAO.listaDepositosArrenda",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DEPOSITOREFEREARRENDALIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DepositoRefereArrendaBean resultado = new DepositoRefereArrendaBean();
					resultado.setDepRefereID(resultSet.getString("DepRefereID"));
					resultado.setNombreCorto(resultSet.getString("NombreCorto"));
					resultado.setNumCtaInstit(resultSet.getString("NumCtaInstit"));
					resultado.setFechaCarga(resultSet.getString("FechaCarga"));
					return resultado;
				}
			});
			listaArrendamientos = matches;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de arrendamientos", e);
		}
		return listaArrendamientos;
	}

	// lista de arrendamientos
	public List listaDepositosRefere(int tipoLista, DepositoRefereArrendaBean depositoRefereArrendaBean) {
		List listaArrendamientos = null;
		try{
			String query = "call DEPOSITOREFEREARRENDALIS(" +
					"?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(depositoRefereArrendaBean.getDepRefereID()),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"DepositoRefereArrendaDAO.listaDepositosArrenda",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DEPOSITOREFEREARRENDALIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DepositoRefereArrendaBean resultado = new DepositoRefereArrendaBean();
					resultado.setDepRefereID(resultSet.getString("DepRefereID"));
					resultado.setFolioCargaID(resultSet.getString("FolioCargaID"));
					resultado.setFechaCarga(resultSet.getString("FechaCarga"));
					resultado.setReferenciaMov(resultSet.getString("ReferenciaMov"));
					resultado.setClienteID(resultSet.getString("Cliente"));
					resultado.setMontoMov(resultSet.getString("MontoMov"));
					return resultado;
				}
			});
			listaArrendamientos = matches;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de arrendamientos", e);
			e.printStackTrace();
		}
		return listaArrendamientos;
	}

	/* PARA OBTENER LA CONSULTA PRINCIPAL  */
	public DepositoRefereArrendaBean consultaPrincipal(DepositoRefereArrendaBean arrendamientosBean, int tipoConsulta) {
		DepositoRefereArrendaBean result = null;
		try{
			// Query con el Store Procedure
			String query = "call DEPOSITOREFEREARRENDACON(" +
					"?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteLong(arrendamientosBean.getDepRefereID()),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,

					Constantes.STRING_VACIO,
					"DepositoRefereArrendaDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DEPOSITOREFEREARRENDACON( " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					DepositoRefereArrendaBean arrendaBean = new DepositoRefereArrendaBean();
					arrendaBean.setDepRefereID(resultSet.getString("DepRefereID"));
					arrendaBean.setInstitucionID(resultSet.getString("InstitucionID"));
					arrendaBean.setNumCtaInstit(resultSet.getString("NumCtaInstit"));
					arrendaBean.setFechaCarga(resultSet.getString("FechaCarga"));
					arrendaBean.setEstatus(resultSet.getString("Estatus"));
				    return arrendaBean;
				}
			});
			result =  matches.size() > 0 ? (DepositoRefereArrendaBean) matches.get(0) : null;
		}catch(Exception e ){
			e.printStackTrace();
		}
		return result;
	}

	public MensajeTransaccionBean aplicaDepositos(final DepositoRefereArrendaBean depRefBean){
		MensajeTransaccionBean resultado = new MensajeTransaccionBean();

		polizaBean.setConceptoID(depRefBean.concAplica);
		polizaBean.setConcepto(depRefBean.descAplica);

		resultado = (MensajeTransaccionBean)transactionTemplate.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean resultadoBean = new MensajeTransaccionBean();
				resultadoBean.setNumero(0);
				DepositoRefereArrendaBean depoRefereArrendaBean =null;
				long numeroPoliza =  0;
				String msgResult = "";
				int i = 0;
				int contador = 0;
				while (contador <= PolizaBean.numIntentosGeneraPoliza) {
					contador++;
					polizaDAO.generaPolizaIDGenerico(polizaBean, parametrosAuditoriaBean.getNumeroTransaccion());
					if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
						break;
					}
				}
				numeroPoliza = Utileria.convierteLong(polizaBean.getPolizaID());
				ArrayList listaMovimientos = (ArrayList) listaGridMovimientos(depRefBean);
				try{
					if(resultadoBean.getNumero()==0){
						if(!listaMovimientos.isEmpty()){
							for( int j=0; j < listaMovimientos.size(); j++){
								depoRefereArrendaBean = (DepositoRefereArrendaBean) listaMovimientos.get(j);
								if(depoRefereArrendaBean.getFolioCargaID().isEmpty()){
								}else{
									resultadoBean= validarDepositosReferenciados(depoRefereArrendaBean, parametrosAuditoriaBean.getNumeroTransaccion());
								}
								if(resultadoBean.getNumero()!=0){
									throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
							}
							for(i=0; i < listaMovimientos.size(); i++){
								depoRefereArrendaBean = (DepositoRefereArrendaBean) listaMovimientos.get(i);
								if(depoRefereArrendaBean.getFolioCargaID().isEmpty()){
								}else{
									resultadoBean= aplicarDepositosReferenciados(depoRefereArrendaBean, numeroPoliza, parametrosAuditoriaBean.getNumeroTransaccion());
								}
								if(resultadoBean.getNumero()!=0){
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al aplicar el pago para el arrendamiento: "+depoRefereArrendaBean.getReferenciaMov());
								}else{
									bajaDepositosReferenciados(parametrosAuditoriaBean.getNumeroTransaccion());
								}
							}
						}else{
							resultadoBean.setNumero(999);
							resultadoBean.setDescripcion("No hay movimientos para los datos proporcionados");
							resultadoBean.setNombreControl(Constantes.STRING_VACIO);
							resultadoBean.setConsecutivoString(Constantes.STRING_CERO);
							throw new Exception("No hay movimientos para los datos proporcionados");
						}
					}else{
						resultadoBean.setNumero(999);
						resultadoBean.setDescripcion(resultadoBean.getDescripcion());
						resultadoBean.setNombreControl(resultadoBean.getNombreControl());
						resultadoBean.setConsecutivoString(resultadoBean.getConsecutivoString());
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}
				}catch(Exception e){
					if (resultadoBean.getNumero() == 0) {
						resultadoBean.setNumero(999);
						resultadoBean.setDescripcion(e.getMessage());
						resultadoBean.setNombreControl(resultadoBean.getNombreControl());
						resultadoBean.setConsecutivoString(Constantes.STRING_CERO);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en aplicacion de depositos refere de arrendamiento", e);
					transaction.setRollbackOnly();
				}
				return resultadoBean;
			}
		});

		return resultado;
	}


	// METODO PARA LEER LISTA DE DEPOSITOS
	public List listaGridMovimientos(DepositoRefereArrendaBean depositoRefereArrendaBean){
		List<String> listaDepRefereID  	= depositoRefereArrendaBean.getlDepRefereID();
		List<String> listaFolioCargaID	= depositoRefereArrendaBean.getlFolioCargaID();
		List<String> listaFechaCarga   	= depositoRefereArrendaBean.getlFechaCarga();
		List<String> listaReferenciaMov	= depositoRefereArrendaBean.getlReferenciaMov();
		List<String> listaCliente   	= depositoRefereArrendaBean.getlCliente();
		List<String> listaMontoMov   	= depositoRefereArrendaBean.getlMontoMov();
		List<String> listalSeleccionado = depositoRefereArrendaBean.getlSeleccionado();

		ArrayList listaDetalle = new ArrayList();
		DepositoRefereArrendaBean depRefeBean = null;
		try{
			if(!listaFolioCargaID.isEmpty()){
				int tamanio = listaFolioCargaID.size();
				System.out.println("Folio de carga "+ tamanio);
				for(int i=0; i<tamanio; i++){
					depRefeBean = new DepositoRefereArrendaBean();
					depRefeBean.setSeleccionado(listalSeleccionado.get(i));
					if(depRefeBean.getSeleccionado().equals("S")){
						depRefeBean.setDepRefereID(listaDepRefereID.get(i));
						depRefeBean.setFolioCargaID(listaFolioCargaID.get(i));
						depRefeBean.setFechaCarga(listaFechaCarga.get(i));
						depRefeBean.setReferenciaMov(listaReferenciaMov.get(i));
						depRefeBean.setClienteID(listaCliente.get(i));
						depRefeBean.setMontoMov(listaMontoMov.get(i).trim().replaceAll(",",""));
						listaDetalle.add(depRefeBean);
					}
				}
			}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de grid de dep refere arrenda", e);
		}
		return listaDetalle;
	}

	// PROCESO DE APLICACION DE DEPOSITOS REFERENCIADOS
	public MensajeTransaccionBean aplicarDepositosReferenciados(final DepositoRefereArrendaBean refeBean, final long polizaID,  final double numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call DEPOSITOREFEARRENDAAPLICAPRO(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setLong("Par_DepRefereID", Utileria.convierteLong(refeBean.getDepRefereID()));
							sentenciaStore.setLong("Par_FolioCargaID",Utileria.convierteLong(refeBean.getFolioCargaID()));
							sentenciaStore.setLong("Par_Poliza",polizaID);

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Var_Poliza", Types.BIGINT);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

							sentenciaStore.setString("Aud_ProgramaID","DepositosRefeDAO.altaDepositosRefere");
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",(long) numeroTransaccion);
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
						DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					//transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de deposito referencido", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// PROCESO DE VALIDACION APLICACION DE DEPOSITOS REFERENCIADOS
	public MensajeTransaccionBean validarDepositosReferenciados(final DepositoRefereArrendaBean refeBean, final double numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call DEPOSITOREFEARRENDAAPLICAVAL(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setLong("Par_DepRefereID", Utileria.convierteLong(refeBean.getDepRefereID()));
							sentenciaStore.setLong("Par_FolioCargaID",Utileria.convierteLong(refeBean.getFolioCargaID()));
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID","DepositosRefeDAO.altaDepositosRefere");

							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",(long) numeroTransaccion);
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
						DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					//transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de deposito referencido", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// PROCESO DE baja APLICACION DE DEPOSITOS REFERENCIADOS
	public MensajeTransaccionBean bajaDepositosReferenciados(final double numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call TMPDEPOARRENDABAJ(" +
									"?,?,?,?,?, ?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID","DepositosRefeDAO.altaDepositosRefere");

							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",(long) numeroTransaccion);
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
						DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					//transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de deposito referencido", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//** GET y SET
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}
	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}

}
