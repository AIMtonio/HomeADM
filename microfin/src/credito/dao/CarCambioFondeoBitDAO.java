package credito.dao;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.List;

import nomina.bean.NomTipoClavePresupBean;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import contabilidad.dao.DetallePolizaDAO;
import contabilidad.dao.PolizaDAO;

import soporte.bean.ParamGeneralesBean;
import soporte.dao.ParamGeneralesDAO;
import ventanilla.bean.IngresosOperacionesBean;
import credito.bean.CarCambioFondeoBitBean;
import credito.bean.CarCreditoSuspendidoBean;

public class CarCambioFondeoBitDAO extends BaseDAO{
	private ParamGeneralesDAO paramGeneralesDAO;
	PolizaDAO polizaDAO = null;
	final boolean origenFuenFondeoMas = true;
	public static String concepContaFuenteFondeoMas = "908"; // corresponde con la tabla	CONCEPTOSCONTA

	public CarCambioFondeoBitDAO(){
		super();
	}


	/*********************************************************************************************************************/
	/*************************** METODO PARA  VALIDAR LOS CREDITOS A FONDEAR CARGADO PREVIAMENTE ************************/
	public MensajeTransaccionBean fondeoCreditoVal(final CarCambioFondeoBitBean carCambioFondeoBitBean) {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

		try {
			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "CALL TMP_CARFONDEOMASIVOVAL( ?,?,?,?,?,  " +
																"?,?,?,?,?, " +
																"?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setLong("Par_TransaccionCargaID",Utileria.convierteLong(carCambioFondeoBitBean.getNumeroTransacion()));

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					//Parametros de Auditoria
					sentenciaStore.setString("Aud_EmpresaID", String.valueOf(parametrosAuditoriaBean.getEmpresaID()));
					sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID", "CarCambioFondeoBitDAO.fondeoCreditoVal");
					sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

					loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
					return sentenciaStore;
				}
			},new CallableStatementCallback() {
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
					MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
					if(callableStatement.execute()){
						ResultSet resultadosStore = callableStatement.getResultSet();

						resultadosStore.next();
						mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
						mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
						mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
						mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
					}else{
						mensajeTransaccion.setNumero(999);
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CarCambioFondeoBitDAO.fondeoCreditoVal");
						mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
						mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
					}
					return mensajeTransaccion;
				}
			});

			if(mensajeBean ==  null){
				mensajeBean = new MensajeTransaccionBean();
				mensajeBean.setNumero(999);
				throw new Exception(Constantes.MSG_ERROR + " .CarCambioFondeoBitDAO.fondeoCreditoVal");
			}else if(mensajeBean.getNumero()!=0){
				throw new Exception(mensajeBean.getDescripcion());
			}
		} catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Proceso de Validación de Créditos A Fondear" + e);
			e.printStackTrace();
			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
		}
		return mensajeBean;
	}

	/* ****************************************************************************************************************************************************** */
	/* ****************************************************************************************************************************************************** */
	public MensajeTransaccionBean cargaArchivoFondeo(final CarCambioFondeoBitBean carCambioFondeoBitBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		// Llamada del ETL para la carga de la informacion de Fondeo de Credito
		carCambioFondeoBitBean.setNumeroTransacion(Long.toString(parametrosAuditoriaBean.getNumeroTransaccion()));

		mensaje = procesarArchivoFondeo(carCambioFondeoBitBean);

		if(mensaje.getNumero()!=0){
			loggerSAFI.info(this.getClass()+" - "+"Error al Intentar Procesar la Información de Fondeo Crédito :  " + mensaje.getDescripcion());
			return mensaje;
		}

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try{
					// Llamada del metodo de validacion de Creditos a fondear
					mensajeBean = fondeoCreditoVal(carCambioFondeoBitBean);

					if(mensajeBean.getNumero()!=0){
						loggerSAFI.info(this.getClass()+" - "+"Error al Intentar Validar los Créditos a Fondear:  " + mensajeBean.getDescripcion());
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Créditos Fondeo Cargado Correctamente.");
				}catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"  Error a Intentar Validar los Créditos a Fondear ", e);
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


	/* **************************** Ejecucion de la Carga de la Información de Fondeo de Credito ************************** */
	/* ******************************************************************************************************************** */
	private MensajeTransaccionBean procesarArchivoFondeo(CarCambioFondeoBitBean carCambioFondeoBitBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		//Ejecucion de respues de buro
		try{
			int consultaRutaAplicacionesFondeo = 41;
			ParamGeneralesBean paramGeneralesBean = paramGeneralesDAO.consultaPrincipal(new ParamGeneralesBean(), consultaRutaAplicacionesFondeo);

			String rutaAplicacionFondeo = paramGeneralesBean.getValorParametro();

			File directorioEjecFondeo = new File(rutaAplicacionFondeo);
			if (!directorioEjecFondeo.exists()) {
				loggerSAFI.info(this.getClass()+" - "+"Configure la Carpeta donde se encuentran los Ejecutables para Fondeo De Crédito.");
				throw new Exception("Configure la Carpeta donde se encuentran los Ejecutables para Fondeo de Crédito.");
			}

			String shProcesaRespuesta = rutaAplicacionFondeo + "CesionCredito" + System.getProperty("file.separator") + "CargaArchivoCesionCredito.sh";

			File archivoSH = new File(shProcesaRespuesta);
			if(!archivoSH.exists()) {
				loggerSAFI.info(this.getClass()+" - "+"No se encontro el ejecutable para la Carga de la Información de Fondeo de Credito.");
				throw new Exception("No se encontro el ejecutable para la Carga de la Información de Fondeo de Credito.");
			}

			SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd");
			String strFecha = formato.format(parametrosAuditoriaBean.getFecha());
			String estatusRegistrado = "R";

			loggerSAFI.info(this.getClass()+" - "+"Datos:" + shProcesaRespuesta + "/" + carCambioFondeoBitBean.getNumeroTransacion() + "/" + carCambioFondeoBitBean.getUrlArchivo() +"/" + estatusRegistrado + "/" + carCambioFondeoBitBean.getNombreArchivo());

			String[] command = {"sh", shProcesaRespuesta, carCambioFondeoBitBean.getNumeroTransacion(),  carCambioFondeoBitBean.getUrlArchivo(), estatusRegistrado, strFecha, carCambioFondeoBitBean.getNombreArchivo() };
			ProcessBuilder pb = new ProcessBuilder();
			pb.command(command);
			Process p = pb.start();
			p.waitFor();

			//Leemos salida del programa
			InputStream is = p.getInputStream();
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader br = new BufferedReader(isr);
			String line;
			String respuesta = null;
			while ((line = br.readLine()) != null) {
				respuesta = line;
			}

			String[] partes = respuesta.split("-");
			int codigoRespuesta = Integer.parseInt(partes[0]);
			String mensajeRespuesta = partes[1];

			loggerSAFI.info(this.getClass()+" - "+"Respuesta recibida del SH:" + respuesta);

			mensaje.setNumero(codigoRespuesta);
			mensaje.setDescripcion(mensajeRespuesta);

		}catch(Exception e){
			e.printStackTrace();

			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al Intentar Cargar el Archivo de Fondeo de Crédito.");
		}
		return mensaje;
	}

	/*********************************************************************************************************************/
	/****************** METODO PARA EL LISTADO LOS CREDITOS A FONDEAR QUE PRESENTAN ERRORES O ADVERTENCIA ****************/
	public List lisCredFondeoErr(final CarCambioFondeoBitBean carCambioFondeoBitBean, final int tipoLista){
		List lista = null;
		try{
			String query = "call TMP_CARFONDEOMASIVOLIS( ?,?,?,?,?," +
													    "?,?,?,?);";
			Object[] parametros = {
				carCambioFondeoBitBean.getNumeroTransacion(),

				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CarCambioFondeoBitDAO.lisCredFondeoErr",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TMP_CARFONDEOMASIVOLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CarCambioFondeoBitBean carCambioFondeoBit = new CarCambioFondeoBitBean();

					carCambioFondeoBit.setCarFondeoMavisoID(resultSet.getString("CarFondeoMavisoID"));
					carCambioFondeoBit.setFilaArchivo(resultSet.getString("FilaArchivo"));
					carCambioFondeoBit.setCreditoID(resultSet.getString("CreditoID"));
					carCambioFondeoBit.setDescripcionEstatus(resultSet.getString("DescripcionEstatus"));
					carCambioFondeoBit.setCantError(resultSet.getString("CantError"));
					carCambioFondeoBit.setCantAdvertencia(resultSet.getString("CantAdvertencia"));
					carCambioFondeoBit.setEstatus(resultSet.getString("Estatus"));

					return carCambioFondeoBit;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista  de los Creditos a fondear", e);
		}
		return lista;
	}

	/* ============= METODO CAMBIO DE FUENTE DE FONDEO MASIVO ================= */
	public MensajeTransaccionBean cambioFuenteFondeoMasivo(final CarCambioFondeoBitBean carCambioFondeoBitBean ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
							//Se genera la poliza para pasarlo al SP del proceso
							transaccionDAO.generaNumeroTransaccion(origenFuenFondeoMas);
							int contador = 0;
							ingresosOperacionesBean.setConceptoCon(concepContaFuenteFondeoMas);
							ingresosOperacionesBean.setDescripcionMov("CAMBIO DE FUENTE FONDEO MASIVO");//ASIGNAR EL VALOR REAL
							while (contador <= 3) {
								contador++;
								polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenFuenFondeoMas);
								if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
									break;
								}
							}

							String query = "call CARRECLACONTAFONDEOPRO(?,?,?,?,?," +
																		"?,?,?," +
																		"?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setLong("Par_CreditoID",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Par_CreditoFondeoID",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Par_NumTransaccionPro", Utileria.convierteLong(carCambioFondeoBitBean.getNumeroTransacion()));
							sentenciaStore.setInt("Par_PolizaID", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setInt("Par_NumPro", 2);//Valor para proceso masivo

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "CarCreditoSuspendidoDAO.reversaCreditoSuspendido");
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CARRECLACONTAFONDEOPRO(" + sentenciaStore.toString() + ")");
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CarCambioFondeoBitDAO.cambioFuenteFondeoMasivo");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CarCambioFondeoBitDAO.cambioFuenteFondeoMasivo");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Proceso Cambio de Fuente de Fondeo Masivo" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/* ============= FIN METODO CAMBIO DE FUENTE DE FONDEO MASIVO ================= */
	public MensajeTransaccionBean cambioFuenteFondeo(final CarCambioFondeoBitBean cambioFondeoBitBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
							//Se genera la poliza para pasarlo al SP del proceso
							transaccionDAO.generaNumeroTransaccion(origenFuenFondeoMas);
							int contador = 0;
							ingresosOperacionesBean.setConceptoCon(concepContaFuenteFondeoMas);
							ingresosOperacionesBean.setDescripcionMov("CAMBIO DE FUENTE FONDEO");
							while (contador <= 3) {
								contador++;
								polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenFuenFondeoMas);
								if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
									break;
								}
							}

							String query = "call CARRECLACONTAFONDEOPRO(?,?,?,?,?," +
																		"?,?,?," +
																		"?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(cambioFondeoBitBean.getCreditoID()));
							sentenciaStore.setLong("Par_CreditoFondeoID",Utileria.convierteLong(cambioFondeoBitBean.getCreditoFondeoActID()));
							sentenciaStore.setLong("Par_NumTransaccionPro", Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Par_PolizaID", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setInt("Par_NumPro", 1);

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "CarCambioFondeoBitDAO.cambioFuenteFondeo");
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CARRECLACONTAFONDEOPRO(" + sentenciaStore.toString() + ")");
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CarCambioFondeoBitDAO.cambioFuenteFondeoMasivo");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CarCambioFondeoBitDAO.cambioFuenteFondeoMasivo");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Proceso Cambio de Fuente de Fondeo Masivo" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public ParamGeneralesDAO getParamGeneralesDAO() {
		return paramGeneralesDAO;
	}


	public void setParamGeneralesDAO(ParamGeneralesDAO paramGeneralesDAO) {
		this.paramGeneralesDAO = paramGeneralesDAO;
	}


	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}


	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}

}
