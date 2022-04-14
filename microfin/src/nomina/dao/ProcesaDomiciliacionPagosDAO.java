package nomina.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import nomina.bean.ProcesaDomiciliacionPagosBean;
import nomina.bean.ResultadoCargaArchivosDomiciliaBean;


public class ProcesaDomiciliacionPagosDAO extends BaseDAO{
	protected static final HttpServletResponse HttpServletResponse = null;

	PolizaDAO polizaDAO	= null;

	String conceptoContaDomiciliaPagos = "67"; 									// Numero de concepto contable para la Domiciliación de Pago de Crédito (CONCEPTOSCONTA)
	String conceptoContaDomiciliaPagosDes = "DOMICILIACION PAGO DE CREDITO"; 	// Descripcion para el concepto contable para la Domiciliación de Pago de Crédito (CONCEPTOSCONTA)

	public ProcesaDomiciliacionPagosDAO (){
		super();
	}

	// -------------- Tipo Transaccion  ----------------
	public static interface Enum_Tipo_Transaccion{
		int eliminar     		= 1;		// Eliminar Registros de Domiciliación de Pagos por Usuario
		int eliminarProc 		= 2;		// Eliminar Registros de Domiciliación de Pagos después de Procesar
		int bajaDomiciliacion   = 3;		// Baja de Domiciliación de Pagos
	}

	// -------------- Tipo Actualizacion  ----------------
	public static interface Enum_Act_Domiciliacion {
		int actualizaEstatus = 1;			// Actualiza Estatus Domiciliacion de Pagos
	}

	// -------------- Tipo Consulta ----------------
	public static interface Enum_Con_Domiciliacion{
		int numFolioProcesa		= 1;		// Consulta Número de Folio al Adjuntar el Archivo de DOmiciliación de Pagos para Procesar
		int conParamArchivo		= 3;		// Consulta de Parámetros de Archivos de Nómina
		int numFolioGenera		= 5;		// Consulta Numero de Folios para Generar el Layout de Domiciliacion de Pagos
	}

	// -------------- Tipo Lista ----------------
	public static interface Enum_Lis_Domiciliacion{
		int domiciliaPagos		= 4;		// Lista de Domiciliación de Pagos
		int layoutDomPagos		= 6;		// Lista de Domiciliación de Pagos para generar el Layout
	}

	final	String saltoLinea="\n";

	/**
	 *
	 * @param procesaDomiciliacionPagosBean
	 * @param tipoBaja : Se eliminan registros existentes por Usuario antes de dar de alta información de Domiciliacion de Pagos
	 * @return
	 */
	public MensajeTransaccionBean eliminaDomiciliacionPagos(final ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean,  final int tipoBaja) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call TMPPROCDOMICILIAPAGOSBAJ(?,	?,?,?,	 ?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_TipoBaja",tipoBaja);

							//Parametros de OutPut
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
							}
							);

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
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+"Error en eliminar la Domiciliación de Pagos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param procesaDomiciliacionPagosBean : Bean para el registro de información de Domiciliación de Pagos
	 * @param result : Resultado Lectura de Archivo
	 * @param numeroTransaccion : Numero de Transaccion
	 * @return
	 */
	public ResultadoCargaArchivosDomiciliaBean altaDomiciliacionPagos(final ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean,
			final ResultadoCargaArchivosDomiciliaBean result, final double numeroTransaccion ){
		ResultadoCargaArchivosDomiciliaBean resultCarga = new ResultadoCargaArchivosDomiciliaBean();

		resultCarga = (ResultadoCargaArchivosDomiciliaBean) transactionTemplate.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				try {
					MensajeTransaccionBean mensaje = null;
					// Realiza el registro de informacion de Domiciliación de Pagos
					mensaje = altaDomiciliacionPagos(procesaDomiciliacionPagosBean, numeroTransaccion);

					result.setNumero(mensaje.getNumero());
					result.setDescripcion(mensaje.getDescripcion());

					if(mensaje.getNumero()==0){
						result.setExitosos(result.getExitosos()+1);
					}else{
						result.setFallidos(result.getFallidos()+1);
						result.setDescripcion("Error en Línea:"+(result.getExitosos() + result.getFallidos())+" <br> "
								+mensaje.getDescripcion());
					}

				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+"Error en el registro de Domiciliación de Pagos", e);
					result.setFallidos(result.getFallidos()+1);
				}
				return result;
			}
		});
		return result;
	}

	/**
	 *
	 * @param procesaDomiciliacionPagosBean
	 * @param numeroTransaccion : Numero de transaccion en el registro de información de Domiciliación de Pagos
	 * @return
	 */
	public MensajeTransaccionBean altaDomiciliacionPagos(final ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean,final double numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call TMPPROCDOMICILIAPAGOSALT(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_FolioID",Utileria.convierteLong(procesaDomiciliacionPagosBean.getFolioID()));
									sentenciaStore.setString("Par_CuentaClabe",procesaDomiciliacionPagosBean.getCuentaClabe());
									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(procesaDomiciliacionPagosBean.getCreditoID()));
									sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(procesaDomiciliacionPagosBean.getMonto()));
									sentenciaStore.setDouble("Par_MontoPendiente",Utileria.convierteDoble(procesaDomiciliacionPagosBean.getMontoPendiente()));

									sentenciaStore.setString("Par_ClaveDomicilia",procesaDomiciliacionPagosBean.getClaveDomiciliacion());

									//Parametros de OutPut
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",(long) numeroTransaccion);

									loggerSAFI.info(this.getClass()+" - "+sentenciaStore.toString());
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
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente: " + mensajeBean.getDescripcion());
							mensajeBean.setDescripcion("No es posible realizar la operación, el Cliente hizo coincidencia con la Listas de Personas Bloqueadas");
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+"Error el registro de información de Domiciliación de Pagos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param rutaArchivo : Ruta de Alojamiento del Archivo de Afiliación para su Lectura y validaciones
	 * @param procesaDomiciliacionPagosBean
	 * @return
	 */
	public ResultadoCargaArchivosDomiciliaBean cargaArchivo(final String rutaArchivo, final ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean){
		ResultadoCargaArchivosDomiciliaBean resultado = new ResultadoCargaArchivosDomiciliaBean();
		resultado = (ResultadoCargaArchivosDomiciliaBean)transactionTemplate.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				ResultadoCargaArchivosDomiciliaBean resultadoCarga = new ResultadoCargaArchivosDomiciliaBean();
				resultadoCarga.setExitosos(0);
				resultadoCarga.setFallidos(0);
				int tamanoLista=0;
				try{
					List <ProcesaDomiciliacionPagosBean> procesaDomiciliacionPagos = leeArchivo(rutaArchivo);

					if(procesaDomiciliacionPagos!=null){
						tamanoLista = procesaDomiciliacionPagos.size();

						Iterator <ProcesaDomiciliacionPagosBean> iterList = procesaDomiciliacionPagos.iterator();

						String motivoDescripcion = saltoLinea+ "El Archivo se ha cargado Exitosamente.";

						ProcesaDomiciliacionPagosBean procDomiciliacionBean;

						if(procesaDomiciliacionPagos!=null && procesaDomiciliacionPagos.size() > 0){
							double numtransacc = transaccionDAO.generaNumeroTransaccionOut();
							double numeroTransaccion = numtransacc;

							ProcesaDomiciliacionPagosBean procDomiciliaPago = new ProcesaDomiciliacionPagosBean();
							//Consulta el Número de Folio al Adjuntar el Archivo de Domiciliación de Pagos para Procesar
							procDomiciliaPago = consultaNumeroFolioProcesar(procesaDomiciliacionPagosBean, Enum_Con_Domiciliacion.numFolioProcesa);

							String folioID = procDomiciliaPago.getFolioID();

							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							// Se eliminan registros existentes por Usuario antes de dar de alta información de Domiciliacion de Pagos
							mensajeBean = eliminaDomiciliacionPagos(procesaDomiciliacionPagosBean,Enum_Tipo_Transaccion.eliminar);

							if(mensajeBean.getNumero() != 0){
								throw new Exception(mensajeBean.getDescripcion());
							}

							while(iterList.hasNext()){
								procDomiciliacionBean = (ProcesaDomiciliacionPagosBean) iterList.next();
								if(procDomiciliacionBean.getNumError().equals("0")){
									procDomiciliacionBean.setFolioID(folioID);

									String monto = procDomiciliacionBean.getMonto();
									String montoEntero  = monto.substring(0, 13);
									String montoDecimal = monto.substring(14, 15);

									procDomiciliacionBean.setMonto(montoEntero+"."+montoDecimal);

									resultadoCarga =  altaDomiciliacionPagos(procDomiciliacionBean, resultadoCarga, numeroTransaccion);

									if(resultadoCarga.getNumero()!=0){
										throw new Exception(resultadoCarga.getDescripcion());
									}

									resultadoCarga.setDescripcion ("" +
											"<table border='0'>" +
											"<tr>" +
											"<td>Total Registros: </td>" +
											"<td style='text-align:right;'>"+tamanoLista+"</td>" +
											"</tr>" +
											"<tr>" +
											"<td>Registros Exitosos: </td>" +
											"<td style='text-align:right;'>"+resultadoCarga.getExitosos()+"</td>" +
											"</tr>" +
											"<tr>" +
											"<td>Registros Fallidos: </td>" +
											"<td style='text-align:right;'>"+resultadoCarga.getFallidos()+"</td>" +
											"</tr>" +
											"<tr>" +
											"<td>Descripción: </td>" +
											"</tr>" +
											"<tr>" +
											"<td style='text-align:justify;'>"+motivoDescripcion+"</td>" +
											"</tr>" +
											"</table>" +
											"");
								}else{
									resultadoCarga.setFallidos(resultadoCarga.getFallidos()+1);
									resultadoCarga.setDescripcion(procDomiciliacionBean.getDescError());
									throw new Exception(resultadoCarga.getDescripcion());
								}
							}
						}else{
							resultadoCarga.setNumero(999);
							resultadoCarga.setDescripcion("Asegúrese de Subir el Archivo con el Formato Correcto.");
							throw new Exception(resultadoCarga.getDescripcion());
						}
					}else{
						resultadoCarga.setDescripcion("Asegúrese de Subir el Archivo con el Formato Correcto.");
						throw new Exception(resultadoCarga.getDescripcion());
					}
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+"Error en carga de Archivo", e);
					resultadoCarga.setConsecutivoInt("0");
					resultadoCarga.setConsecutivoString("0");
					resultadoCarga.setNumero(999);

					resultadoCarga.setDescripcion ("" +
							"<table border='0'>" +
							"<tr>" +
							"<td>Total Registros: </td>" +
							"<td style='text-align:right;'>"+tamanoLista+"</td>" +
							"</tr>" +
							"<tr>" +
							"<td>Registros Exitosos: </td>" +
							"<td style='text-align:right;'>"+resultadoCarga.getExitosos()+"</td>" +
							"</tr>" +
							"<tr>" +
							"<td>Registros Fallidos: </td>" +
							"<td style='text-align:right;'>"+resultadoCarga.getFallidos()+"</td>" +
							"</tr>" +
							"<tr>" +
							"<td>Descripción: </td>" +
							"</tr>" +
							"<tr>" +
							"<td style='text-align:justify;'>"+resultadoCarga.getDescripcion()+"</td>" +
							"</tr>" +
							"</table>" +
							"");

					transaction.setRollbackOnly();
				}

				return resultadoCarga;
			}
		});
		return resultado;
	}

	/**
	 *
	 * @param rutaArchivo : Ruta de Alojamiento del Archivo de Domiciliación de Pagos para su Lectura
	 * @return
	 */
	public List<ProcesaDomiciliacionPagosBean> leeArchivo(String rutaArchivo){

		ArrayList<ProcesaDomiciliacionPagosBean> listaDomiciliacion = new ArrayList<ProcesaDomiciliacionPagosBean>();
		BufferedReader bufferedReader;
		String [] arreglo = null;
		int contadorErr =0;

		ProcesaDomiciliacionPagosBean procesaDomiciliacionPagos;
		String renglon;

		int tamEncabezado = 1;
		int numeroLinea = 0;

		String credito ="";
		String cuentaClabe ="";
		String claveRespuesta ="";
		String monto ="";
		try {
			bufferedReader = new BufferedReader(new FileReader(rutaArchivo));

			while ((renglon = bufferedReader.readLine())!= null){
				numeroLinea +=1;
				if(tamEncabezado < numeroLinea && !renglon.trim().equals("") ){
					arreglo = renglon.split("");
					procesaDomiciliacionPagos = new ProcesaDomiciliacionPagosBean();
					procesaDomiciliacionPagos.setNumError("0");

					credito  =  arreglo[60].trim()+arreglo[61].trim()+arreglo[62].trim()+arreglo[63].trim()
							 +  arreglo[64].trim()+arreglo[65].trim()+arreglo[66].trim()+arreglo[67].trim()+arreglo[68].trim()
							 +  arreglo[69].trim()+arreglo[70].trim()+arreglo[71].trim();
					procesaDomiciliacionPagos.setCreditoID(credito);

					cuentaClabe		=	arreglo[133].trim()+arreglo[134].trim()+arreglo[135].trim()+arreglo[136].trim()+arreglo[137].trim()
									 +  arreglo[138].trim()+arreglo[139].trim()+arreglo[140].trim()+arreglo[141].trim()+arreglo[142].trim()
									 +  arreglo[143].trim()+arreglo[144].trim()+arreglo[145].trim()+arreglo[146].trim()+arreglo[147].trim()
									 +  arreglo[148].trim()+arreglo[149].trim()+arreglo[150].trim();

					claveRespuesta = arreglo[166].trim()+arreglo[167].trim();
					procesaDomiciliacionPagos.setClaveDomiciliacion(claveRespuesta);


					monto 	= 	arreglo[100].trim()+arreglo[101].trim()+arreglo[102].trim()+arreglo[103].trim()+arreglo[104].trim()
							 +  arreglo[105].trim()+arreglo[106].trim()+arreglo[107].trim()+arreglo[108].trim()+arreglo[109].trim()
							 +  arreglo[110].trim()+arreglo[111].trim()+arreglo[112].trim()+arreglo[113].trim()+arreglo[114].trim();

					procesaDomiciliacionPagos.setMonto(monto);

					if(cuentaClabe.length() == 18){
						procesaDomiciliacionPagos.setCuentaClabe(cuentaClabe);

					}else{
						procesaDomiciliacionPagos.setNumError("111");
						procesaDomiciliacionPagos.setDescError("Error en Línea: " +numeroLinea +saltoLinea+" La Cuenta Clabe No Tiene una Longitud de 18 Caracteres.");
						procesaDomiciliacionPagos.setLineaError(numeroLinea);
					}


					if(!procesaDomiciliacionPagos.getNumError().equals("0")){
						contadorErr++;
					}

					listaDomiciliacion.add(procesaDomiciliacionPagos);

				}
			}

		}catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+"Error en Leer el Archivo", e);

			listaDomiciliacion=null;
		}

		return listaDomiciliacion;
	}

	/**
	 *
	 * @param listaBean : Metodo para mandar a llamar al metodo para el proceso de Domiciliación de Pagos
	 * @return
	 */
	public MensajeTransaccionBean procesaDomicialiacionPagos(final ProcesaDomiciliacionPagosBean procesaDomiciliacionPagos, final List listaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				final PolizaBean polizaBean=new PolizaBean();

				String numeroPoliza = "";
				int polizaGenerada = 1;

				try {
					ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean;

					String nombreArchivo = procesaDomiciliacionPagos.getNombreArchivo();

					if(listaBean != null){
						for(int i=0; i<listaBean.size(); i++){
							/* obtenemos un bean de la lista */
							procesaDomiciliacionPagosBean = (ProcesaDomiciliacionPagosBean)listaBean.get(i);
							procesaDomiciliacionPagosBean.setNombreArchivo(nombreArchivo);
							String folioID = procesaDomiciliacionPagosBean.getFolioID();
							// Se realiza el alta de Poliza
							if(polizaGenerada == 1 ){

								polizaBean.setConceptoID(conceptoContaDomiciliaPagos);
								polizaBean.setConcepto(conceptoContaDomiciliaPagosDes);

								int	contador  = 0;
								while(contador <= PolizaBean.numIntentosGeneraPoliza){
									contador ++;
									polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
									if (Utileria.convierteLong(polizaBean.getPolizaID()) > 0){
										break;
									}
								}

								polizaGenerada = 0;
							}

							numeroPoliza = polizaBean.getPolizaID();
							procesaDomiciliacionPagosBean.setPolizaID(numeroPoliza);

							if (Utileria.convierteLong(procesaDomiciliacionPagosBean.getPolizaID()) > 0) {
								// Proceso de Domiciliacion de Pagos
								mensajeBean = procesaDomicialiacionPagos(procesaDomiciliacionPagosBean,parametrosAuditoriaBean.getNumeroTransaccion());

								if(mensajeBean.getNumero()!=0){
									MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
									mensaje = mensajeBean;
									try{
										// Baja de Poliza en caso de que haya ocurrido un error
										PolizaBean bajaPolizaBean = new PolizaBean();
										bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
										bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
										bajaPolizaBean.setNumErrPol(mensajeBean.getNumero() + "");
										bajaPolizaBean.setErrMenPol(mensajeBean.getDescripcion());
										bajaPolizaBean.setDescProceso("ProcesaDomiciliacionPagosDAO.procesaDomicialiacionPagos");
										bajaPolizaBean.setPolizaID(procesaDomiciliacionPagosBean.getPolizaID());
										MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
										mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
										loggerSAFI.error(this.getClass()+" - "+"ProcesaDomiciliacionPagosDAO.procesaDomicialiacionPagos: Credito: " + procesaDomiciliacionPagosBean.getCreditoID() + " Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());

										if(mensajeBaja.getNumero() != 0){
											throw new Exception(mensajeBean.getDescripcion());
										}else{
											mensajeBean = mensaje;
											throw new Exception(mensajeBean.getDescripcion());
										}

									} catch (Exception ex) {
										ex.printStackTrace();
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							}
						 else{
							 mensajeBean.setNumero(999);
							 mensajeBean.setDescripcion("El Número de Póliza se encuentra Vacio.");
							 mensajeBean.setNombreControl("numeroTransaccion");
							 mensajeBean.setConsecutivoString("0");
						 	}
						  procesaDomiciliacionPagos.setFolioID(folioID);
						}
					}

					if(mensajeBean.getNumero() == 0){
						// Se registra el Nombre del Archivo una vez realizada el Proceso de Domiciliación de Pagos
						mensajeBean = altaArchivoDomiciliacionPagos (procesaDomiciliacionPagos,parametrosAuditoriaBean.getNumeroTransaccion());

						if(mensajeBean.getNumero() != 0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Domiciliación de Pagos Procesada Exitosamente.");
					mensajeBean.setNombreControl("generar");
					mensajeBean.setConsecutivoInt("0");

				}
				 catch (Exception e) {
				e.printStackTrace();
				loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en proceso de Domiciliación de Pagos", e);
				if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
				}
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();
			}
			return mensajeBean;
			}
		});

	return mensaje;
	}

	/**
	 *
	 * @param procesaDomiciliacionPagosBean
	 * @param NumeroTransaccion : Numero de Transaccion
	 * @return
	 */
	public MensajeTransaccionBean procesaDomicialiacionPagos(final ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean,final long numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call DOMICILIACIONPAGOSPRO(?,?,?,?,?,  ?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(procesaDomiciliacionPagosBean.getClienteID()));
									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(procesaDomiciliacionPagosBean.getInstitucionID()));
									sentenciaStore.setString("Par_CuentaClabe",procesaDomiciliacionPagosBean.getCuentaClabe());
									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(procesaDomiciliacionPagosBean.getCreditoID()));
									sentenciaStore.setDouble("Par_MontoAplicado",Utileria.convierteDoble(procesaDomiciliacionPagosBean.getMontoAplicado()));

									sentenciaStore.setDouble("Par_MontoPendiente",Utileria.convierteDoble(procesaDomiciliacionPagosBean.getMontoPendiente()));
									sentenciaStore.setString("Par_ClaveDomicilia",procesaDomiciliacionPagosBean.getClaveDomiciliacion());
									sentenciaStore.setLong("Par_FolioID",Utileria.convierteLong(procesaDomiciliacionPagosBean.getFolioID()));
									sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(procesaDomiciliacionPagosBean.getPolizaID()));
									sentenciaStore.setString("Par_NombreArchivo",procesaDomiciliacionPagosBean.getNombreArchivo());

									//Parametros de OutPut
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

									loggerSAFI.info(this.getClass()+" - "+sentenciaStore.toString());
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
							}
							);

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
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+"Error en proceso de Domiciliación de Pagos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param procesaDomiciliacionPagosBean : Lista para Generar Layout de Domiciliación de Pagos
	 * @return
	 */
	public MensajeTransaccionBean generaDomiciliacionPagos(final ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean,final List listaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					ProcesaDomiciliacionPagosBean procesaDomiciliacionPagos;

					ProcesaDomiciliacionPagosBean procDomiciliaPago = new ProcesaDomiciliacionPagosBean();
					procDomiciliaPago = consultaNumeroFolioGenerar(procesaDomiciliacionPagosBean, Enum_Con_Domiciliacion.numFolioGenera);

					String folioID = procDomiciliaPago.getFolioID();

					if(listaBean != null){
						for(int i=0; i<listaBean.size(); i++){

							procesaDomiciliacionPagos = (ProcesaDomiciliacionPagosBean)listaBean.get(i);
							procesaDomiciliacionPagos.setNumFolioID(folioID);
							// Se genera Información de Domiciliación de Pagos de Créditos con Estatus Fallido
							if(procesaDomiciliacionPagos.getClaveDomiciliacion().equals("04")
									|| procesaDomiciliacionPagos.getClaveDomiciliacion().equals("24")
									|| procesaDomiciliacionPagos.getClaveDomiciliacion().equals("15")){
								// Registro de Información de Domiciliación de Pagos
								mensajeBean = generaDomiciliacionPagos(procesaDomiciliacionPagos,parametrosAuditoriaBean.getNumeroTransaccion());

								if(mensajeBean.getNumero() != 0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}
					}

					// Registro de Encabezados del Layout de Domiciliación de Pagos.
					mensajeBean = altaEncabezadoLayout(procesaDomiciliacionPagosBean,folioID,parametrosAuditoriaBean.getNumeroTransaccion());

					if(mensajeBean.getNumero() != 0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Generación del Layout de Domiciliación de Pagos realizada Exitosamente.");
					mensajeBean.setNombreControl("generar");
					mensajeBean.setConsecutivoInt("0");
					mensajeBean.setCampoGenerico(mensajeBean.getConsecutivoString()+"-"+folioID+"-"+parametrosAuditoriaBean.getNumeroTransaccion());


				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Generar Layout Domiciliación de Pagos", e);
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param procesaDomiciliacionPagosBean: Registro de Información de Domiciliación de Pagos
	 * @param numeroTransaccion : Número de Transacción
	 * @return
	 */
	public MensajeTransaccionBean generaDomiciliacionPagos(final ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean,final long numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call DOMICILIACIONPAGOSALT(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_FolioID",Utileria.convierteLong(procesaDomiciliacionPagosBean.getNumFolioID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(procesaDomiciliacionPagosBean.getClienteID()));
									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(procesaDomiciliacionPagosBean.getInstitucionID()));
									sentenciaStore.setString("Par_CuentaClabe",procesaDomiciliacionPagosBean.getCuentaClabe());
									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(procesaDomiciliacionPagosBean.getCreditoID()));

									sentenciaStore.setDouble("Par_MontoExigible",Utileria.convierteDoble(procesaDomiciliacionPagosBean.getMonto()));

									//Parametros de OutPut
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

									loggerSAFI.info(this.getClass()+" - "+sentenciaStore.toString());
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
							}
							);

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
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+"Error en generar la Domiciliación de Pagos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param procesaDomiciliacionPagosBean : Bean de registro de Encabezados del Layout de Domiciliación de Pagos.
	 * @param numeroTransaccion : Número de Transacción
	 * @return
	 */
	public MensajeTransaccionBean altaEncabezadoLayout(final ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean, final String folioID,
			final long numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call DOMICILIACIONPAGOSENCALT(?,?,?,?,?,	?,?,?,?,?,	?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_FolioID",Utileria.convierteLong(folioID));
									sentenciaStore.setString("Par_FechaRegistro",Utileria.convierteFecha(procesaDomiciliacionPagosBean.getFechaSistema()));

									//Parametros de OutPut
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

									loggerSAFI.info(this.getClass()+" - "+sentenciaStore.toString());
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
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

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
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+"Error al registrar el Encabezado de la Domiciliación de Pagos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param procesaDomiciliacionPagosBean : Registro del Archivo una vez realizada el Proceso de Domiciliación de Pagos
	 * @param numeroTransaccion : Número de Transacción
	 * @return
	 */
	public MensajeTransaccionBean altaArchivoDomiciliacionPagos(final ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean,final long numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call DOMICILIAPAGOSARCHALT(?,?,?,?,?,	?,?,?,?,?,	?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_FolioID",Utileria.convierteLong(procesaDomiciliacionPagosBean.getFolioID()));
									sentenciaStore.setString("Par_Fecha",Utileria.convierteFecha(procesaDomiciliacionPagosBean.getFechaSistema()));
									sentenciaStore.setString("Par_NombreArchivo",procesaDomiciliacionPagosBean.getNombreArchivo());

									//Parametros de OutPut
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

									loggerSAFI.info(this.getClass()+" - "+sentenciaStore.toString());
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
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

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
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+"Error al registrar el Archivo de la Domiciliación de Pagos despúes de Procesar.", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param procesaDomiciliacionPagosBean : Se actualiza el Estatus de los Créditos con Estatus Fallido después de generar el Layout de Domiciliación de Pagos
	 * @param numeroTransaccion : Número de Transacción
	 * @return
	 */
	public MensajeTransaccionBean actualizaDomiciliacionPagos(final ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean,final long numeroTransaccion,
			final int numActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call DOMICILIACIONPAGOSACT(?,?,?,?,?,	?,?,?,?,?,	?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_FolioID",Utileria.convierteLong(procesaDomiciliacionPagosBean.getFolioID()));
									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(procesaDomiciliacionPagosBean.getCreditoID()));
									sentenciaStore.setInt("Par_NumAct", numActualizacion);

									//Parametros de OutPut
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

									loggerSAFI.info(this.getClass()+" - "+sentenciaStore.toString());
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
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

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
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+"Error al actualizar el estatus del Cŕedito despúes de Generar el Layout de Domiciliación de Pagos..", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param procesaDomiciliacionPagosBean : Genera Layout Domiciliación de Pagos.
	 */
	public void generaLayout(List procesaDomiciliacionPagosBean,long consecutivo,HttpServletResponse response){
		try{
			ProcesaDomiciliacionPagosBean procesaDomiciliacionPagos = new ProcesaDomiciliacionPagosBean();

			procesaDomiciliacionPagos.setConsecutivoID(String.valueOf(consecutivo));
			procesaDomiciliacionPagos = consultaParametrosArchivo(procesaDomiciliacionPagos,Enum_Con_Domiciliacion.conParamArchivo);

			ServletOutputStream ouputStream = null;
			BufferedWriter writer;

			String nombreArchivo= "";

			nombreArchivo = procesaDomiciliacionPagos.getNombreArchivo()+".pag";
			writer = new BufferedWriter(new FileWriter(nombreArchivo));

			String importeTotal = procesaDomiciliacionPagos.getImporteTotal().replace(".", "");

			String espacios ="                                                                             ";
			writer.write("HCP"+procesaDomiciliacionPagos.getClabeInstitBancaria()
			+procesaDomiciliacionPagos.getFechaArchivo()
			+procesaDomiciliacionPagos.getConsecutivo()
			+Utileria.completaCerosIzquierda(procesaDomiciliacionPagosBean.size(), 6)
			+Utileria.completaCerosIzquierda(importeTotal, 15)
			+Utileria.completaCerosIzquierda(procesaDomiciliacionPagosBean.size(), 6)
			+Utileria.completaCerosIzquierda(importeTotal, 15)
			+Utileria.completaCerosIzquierda("0", 6)
			+Utileria.completaCerosIzquierda("0", 15)
			+Utileria.completaCerosIzquierda("0", 6)
			+"0"
			+espacios);

			ProcesaDomiciliacionPagosBean detalle = null;

			for(int i = 0;i<procesaDomiciliacionPagosBean.size();i++){
				detalle = new ProcesaDomiciliacionPagosBean();

				detalle = (ProcesaDomiciliacionPagosBean)procesaDomiciliacionPagosBean.get(i);

				writer.newLine();
				String montoExigible = detalle.getMontoExigible().replace(".", "");
				writer.write("D"+procesaDomiciliacionPagos.getFechaArchivo()
				+Utileria.completaCerosIzquierda(detalle.getNumEmpleado(), 10)
				+agregaEspacio(detalle.getReferencia(),40,'D')
				+Utileria.completaCerosIzquierda(detalle.getCreditoID(), 12)+agregaEspacio(detalle.getDescripcion(),28,'D')
				+Utileria.completaCerosIzquierda(montoExigible, 15)
				+detalle.getCuentaClabe().substring(0,3)
				+"40"
				+Utileria.completaCerosIzquierda(detalle.getCuentaClabe(), 18)
				+"1"
				+"A"
				+"00000000"
				+agregaEspacio("",18,'D'));
			}

			writer.newLine();
			writer.close();

			FileInputStream archivoAfiliacion = new FileInputStream(nombreArchivo);
			int longitud = archivoAfiliacion.available();
			byte[] datos = new byte[longitud];
			archivoAfiliacion.read(datos);
			archivoAfiliacion.close();

			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
			response.setContentType("application/text");
			ouputStream = response.getOutputStream();
			ouputStream.write(datos);
			ouputStream.flush();
			ouputStream.close();

		}catch(Exception e){
			loggerSAFI.error(this.getClass()+" - "+"Error en generar el Layout de Domiciliación de Pagos", e);
		}
	}

	/**
	 *
	 * @param rutaDirectorio: Creación de Directorios para alojar el Layout de Domiciliación de Pagos de Nómina.
	 */
	public void crearDirectorio(String rutaDirectorio){
		File rutaNomina = new File(rutaDirectorio);
		try{
		if(!rutaNomina.exists()){
			rutaNomina.mkdirs();
		}
		}catch(Exception e){
			System.err.println("crearDirectorio"+"-"+"error en la creacion del Directorio "+ e);
		}
	}

	/**
	 * Creación de espacios
	 */
	public String agregaEspacio(String cadena,int longitud,char direccion){
		String cadenaNueva = cadena;

		longitud = longitud-cadena.length();
			if(direccion == 'I'){

				for(int i=0; i<longitud;i++){
					cadenaNueva = " "+cadenaNueva;
				}
			}
			if(direccion =='D'){
				for(int i=0; i<longitud;i++){
					cadenaNueva = cadenaNueva+" ";
				}
			}
		return cadenaNueva;
	}

	/**
	 *
	 * @param generaDomiciliacionPagosBean
	 * @param tipoConsulta : Consulta de Parámetros para generar el Layout de Domiciliación de Pagos
	 * @return
	 */
	public ProcesaDomiciliacionPagosBean consultaParametrosArchivo(ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean,int tipoConsulta) {
		ProcesaDomiciliacionPagosBean procesaDomiciliacionPagos = new ProcesaDomiciliacionPagosBean();
		try{
			//Query con el Store Procedure
			String query = "call DOMICILIACIONPAGOSCON(?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?);";

			Object[] parametros = {
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Utileria.convierteLong(procesaDomiciliacionPagosBean.getConsecutivoID()),
									tipoConsulta,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"ProcesaDomiciliacionPagosDAO.consultaParam",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOMICILIACIONPAGOSCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ProcesaDomiciliacionPagosBean generaDomiciliacionPagos = new ProcesaDomiciliacionPagosBean();
					generaDomiciliacionPagos.setClabeInstitBancaria(resultSet.getString("Var_ClabeInstitBancaria"));
					generaDomiciliacionPagos.setNombreArchivo(resultSet.getString("NombreArchivo"));
					generaDomiciliacionPagos.setFechaArchivo(resultSet.getString("Var_FechaArchivo"));
					generaDomiciliacionPagos.setConsecutivo(resultSet.getString("Consecutivo"));
					generaDomiciliacionPagos.setImporteTotal(resultSet.getString("ImporteTotal"));

					return generaDomiciliacionPagos;
				}
			});

			procesaDomiciliacionPagos= matches.size() > 0 ? (ProcesaDomiciliacionPagosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Parámetros para generar el Layout de Domiciliación de Pagos", e);
		}
		return procesaDomiciliacionPagos;
	}

	/**
	 *
	 * @param procesaDomiciliacionPagosBean
	 * @param tipoConsulta : Consulta Número de Folio al Adjuntar el Archivo de Domiciliación de Pagos
	 * @return
	 */
	public ProcesaDomiciliacionPagosBean consultaNumeroFolioProcesar(ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean, int tipoConsulta) {
		ProcesaDomiciliacionPagosBean procesaDomiciliacionPagos= new ProcesaDomiciliacionPagosBean();
		try{
			//Query con el Store Procedure
			String query = "call TMPPROCDOMICILIAPAGOSCON(?,?,?,?,?,  ?,?,?);";

			Object[] parametros = {
									tipoConsulta,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"ProcesaDomiciliacionPagosDAO.numFolioProcesar",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TMPPROCDOMICILIAPAGOSCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ProcesaDomiciliacionPagosBean bean = new ProcesaDomiciliacionPagosBean();
					bean.setFolioID(resultSet.getString("Var_FolioID"));
					return bean;
				}// trows ecexeption
			});//lista

			procesaDomiciliacionPagos= matches.size() > 0 ? (ProcesaDomiciliacionPagosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta Numero de Folio para Procesar Domiciliación de Pagos.", e);
		}
		return procesaDomiciliacionPagos;
	}

	/**
	 *
	 * @param procesaDomiciliacionPagosBean
	 * @param tipoConsulta : Consulta Numero de Folios para Generar el Layout de Domiciliacion de Pagos
	 * @return
	 */
	public ProcesaDomiciliacionPagosBean consultaNumeroFolioGenerar(ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean, int tipoConsulta) {
		ProcesaDomiciliacionPagosBean procesaDomiciliacionPagos= new ProcesaDomiciliacionPagosBean();
		try{
			//Query con el Store Procedure
			String query = "call DOMICILIACIONPAGOSCON(?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?);";

			Object[] parametros = {
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									tipoConsulta,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"ProcesaDomiciliacionPagosDAO.numFolioGenerar",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOMICILIACIONPAGOSCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ProcesaDomiciliacionPagosBean bean = new ProcesaDomiciliacionPagosBean();
					bean.setFolioID(resultSet.getString("Var_FolioID"));
					return bean;
				}// trows ecexeption
			});//lista

			procesaDomiciliacionPagos= matches.size() > 0 ? (ProcesaDomiciliacionPagosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta Numero de Folio para Generar Layout Domiciliación de Pagos.", e);
		}
		return procesaDomiciliacionPagos;
	}
	/**
	 *
	 * @param procesaDomiciliacionPagosBean
	 * @param tipoLista : Lista por Procesar de Domiciliación de Pagos
	 * @return
	 */
	public List listaPorProcesar(ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean, int tipoLista) {
		List listaDomiciliacionPagos = null;
		try{
		String query = "call TMPPROCDOMICILIAPAGOSLIS(?,?,?,?,?,	?,?,?);";
		Object[] parametros = {
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"ProcesaDomiciliacionPagosDAO.listaGrid",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TMPPROCDOMICILIAPAGOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				ProcesaDomiciliacionPagosBean listaDomiciliacion = new ProcesaDomiciliacionPagosBean();

				listaDomiciliacion.setFolioID(resultSet.getString("FolioID"));
				listaDomiciliacion.setClienteID(resultSet.getString("ClienteID"));
				listaDomiciliacion.setNombreCliente(resultSet.getString("NombreCliente"));
				listaDomiciliacion.setInstitucionID(resultSet.getString("InstitucionID"));
				listaDomiciliacion.setNombreInstitucion(resultSet.getString("NombreInstitucion"));
				listaDomiciliacion.setCuentaClabe(resultSet.getString("CuentaClabe"));
				listaDomiciliacion.setCreditoID(resultSet.getString("CreditoID"));
				listaDomiciliacion.setMonto(resultSet.getString("MontoTotal"));
				listaDomiciliacion.setMontoPendiente(resultSet.getString("MontoPendiente"));
				listaDomiciliacion.setMontoAplicado(resultSet.getString("MontoAplicado"));
				listaDomiciliacion.setEstatus(resultSet.getString("Estatus"));
				listaDomiciliacion.setComentario(resultSet.getString("Comentario"));
				listaDomiciliacion.setClaveDomiciliacion(resultSet.getString("ClaveDomicilia"));

				return listaDomiciliacion;
			}
		});

		listaDomiciliacionPagos= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de detalles de Domiciliación de Pagos", e);
		}
		return listaDomiciliacionPagos;

	}

	/**
	 *
	 * @param folioID : Lista para generar el Layout de Domiciiación de Pagos
	 * @param tipoLista : 6
	 * @return
	 */
	public List listaLayoutDomPagos(String folioID, int tipoLista) {
		List listaDomiciliacion=null;
		try{
		String query = "call DOMICILIACIONPAGOSLIS(?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?,?, ?,?,?);";
		Object[] parametros = {
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,

								Constantes.STRING_VACIO,
								Utileria.convierteLong(folioID),
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"ProcesaDomiciliacionPagosDAO.listaLayout",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOMICILIACIONPAGOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean = new ProcesaDomiciliacionPagosBean();
				procesaDomiciliacionPagosBean.setNumEmpleado(resultSet.getString("NoEmpleado"));
				procesaDomiciliacionPagosBean.setReferencia(resultSet.getString("Referencia"));
				procesaDomiciliacionPagosBean.setCuentaClabe(resultSet.getString("CuentaClabe"));
				procesaDomiciliacionPagosBean.setMontoExigible(resultSet.getString("MontoExigible"));
				procesaDomiciliacionPagosBean.setCreditoID(resultSet.getString("CreditoID"));
				procesaDomiciliacionPagosBean.setDescripcion(resultSet.getString("Descripcion"));

				return procesaDomiciliacionPagosBean;
			}
		});

		listaDomiciliacion= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Layout de Domiciliación de Pagos", e);
		}
		return listaDomiciliacion;
	}

	// ====================== GETTER & SETTER ================ //

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}


}