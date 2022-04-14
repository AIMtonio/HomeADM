package tesoreria.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import tesoreria.bean.DepositosRefeBean;
import tesoreria.bean.ReferenciasPagosBean;

public class ReferenciasPagosDAO extends BaseDAO {

	java.sql.Date fecha = null;

	public ReferenciasPagosDAO(){
		super();
	}

	private final static String salidaPantalla = "S";

	/**
	 * Método de alta las referencias de pago por tipo de instrumento.
	 * @param referenciasBean : Clase bean que contiene los valores de los parámetros de entrada al SP-REFPAGOSXINSTALT.
	 * @param NumeroTransaccion : Número de transacción, para que se envié sólo un número por todas las altas.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean alta(final ReferenciasPagosBean referenciasBean, final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call REFPAGOSXINSTALT(?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_TipoCanalID", referenciasBean.getTipoCanalID());
									sentenciaStore.setString("Par_InstrumentoID", referenciasBean.getInstrumentoID());
									sentenciaStore.setString("Par_Origen", referenciasBean.getOrigen());
									sentenciaStore.setString("Par_InstitucionID", referenciasBean.getInstitucionID());
									sentenciaStore.setString("Par_NombInstitucion", referenciasBean.getNombInstitucion());

									sentenciaStore.setString("Par_Referencia", referenciasBean.getReferencia());
									sentenciaStore.setString("Par_TipoReferencia", referenciasBean.getTipoReferencia());

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());

									sentenciaStore.setLong("Aud_NumTransaccion",NumeroTransaccion);
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ReferenciasPagosDAO.alta");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ReferenciasPagosDAO.alta");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Paises GAFI PLD: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/**
	 * Método de baja de referencias de pago por tipo de instrumento.
	 * @param referenciasBean : Clase bean que contiene los valores de los parámetros de entrada al SP-REFPAGOSXINSTBAJ.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean baja(final ReferenciasPagosBean referenciasBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call REFPAGOSXINSTBAJ(?,?,?,?,?,"
																			+ "?,?,?,?,?,"
																			+ "?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_TipoCanalID", referenciasBean.getTipoCanalID());
									sentenciaStore.setString("Par_InstrumentoID", referenciasBean.getInstrumentoID());
									sentenciaStore.setString("Par_TipoReferencia", referenciasBean.getTipoReferencia());
									sentenciaStore.setInt("Par_InstitucionID", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_NumOpe", 1);

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());

									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

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
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ReferenciasPagosDAO.baja");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ReferenciasPagosDAO.baja");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de referencias de pagos por tipo de instrumento: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public MensajeTransaccionBean bajaInstitucion(final ReferenciasPagosBean referenciasBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call REFPAGOSXINSTBAJ(?,?,?,?,?,"
																			+ "?,?,?,?,?,"
																			+ "?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_TipoCanalID", referenciasBean.getTipoCanalID());
									sentenciaStore.setString("Par_InstrumentoID", referenciasBean.getInstrumentoID());
									sentenciaStore.setString("Par_TipoReferencia", referenciasBean.getTipoReferencia());
									sentenciaStore.setInt("Par_InstitucionID", Utileria.convierteEntero(referenciasBean.getInstitucionID()));
									sentenciaStore.setInt("Par_NumOpe", 2);

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());

									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

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
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ReferenciasPagosDAO.bajaInstitucion");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ReferenciasPagosDAO.baja");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de referencias de pagos por tipo de instrumento: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método que lista las referencias de pago por tipo de instrumento.
	 * @param referenciasBean : Clase bean para los valores de los parámetros de entrada al SP-REFPAGOSXINSTLIS.
	 * @param tipoLista : Tipo de Lista. 1.- Principal
	 * @return List : Lista de clases bean ReferenciasPagosBean.
	 * @author avelasco
	 */
	public List<ReferenciasPagosBean> lista(ReferenciasPagosBean referenciasBean, int tipoLista) {
		List<ReferenciasPagosBean> lista=new ArrayList<ReferenciasPagosBean>();
		String query = "CALL REFPAGOSXINSTLIS(?,?,?,?,   " +
											 "?,?,?,?,?,?,?);";
		Object[] parametros = {
				referenciasBean.getTipoCanalID(),
				referenciasBean.getInstrumentoID(),
				referenciasBean.getTipoReferencia(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,

				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ReferenciasPagosDAO.lista",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call REFPAGOSXINSTLIS(" + Arrays.toString(parametros) + ");");
		try{
			List<ReferenciasPagosBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReferenciasPagosBean parametro = new ReferenciasPagosBean();
					parametro.setOrigen(resultSet.getString("Origen"));
					parametro.setInstitucionID(resultSet.getString("InstitucionID"));
					parametro.setNombInstitucion(resultSet.getString("NombInstitucion"));
					parametro.setReferencia(resultSet.getString("Referencia"));
					parametro.setTipoReferencia(resultSet.getString("TipoReferencia"));
					return parametro;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en ReferenciasPagosDAO.lista: "+ex.getMessage());
		}
		return lista;
	}

	/**
	 * Método que elimina y registra las nuevas referencias de pago por tipo de instrumento.
	 * @param referenciasBean : Clase bean que contiene los valores para dar de baja las referencias.
	 * @param listaDetalle : Lista de las nuevas referencias a registrar.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean grabaDetalle(final ReferenciasPagosBean referenciasBean,final List<ReferenciasPagosBean> listaDetalle) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					mensajeBean=baja(referenciasBean);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
					for(ReferenciasPagosBean detalle : listaDetalle){
						detalle.setTipoReferencia(referenciasBean.getTipoReferencia());
						mensajeBean = alta(detalle, parametrosAuditoriaBean.getNumeroTransaccion());
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("grabar");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en grabar detalle: ", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});
		return mensajeTransaccion;
	}

	/**
	 * Consulta dada la referencia, la existencia de una cuenta de ahorro.
	 * @param depRefBean : Clase Bean DepositosRefeBean con los valores de los parámetros de entrada al SP-REFPAGOSXINSTCON.
	 * @param tipoConsulta : Número de Consulta 1.
	 * @return ReferenciasPagosBean : Clase Bean con el Resultado de la Consulta.
	 * @author avelasco
	 */
	public ReferenciasPagosBean consultaPrincipal(DepositosRefeBean depRefBean, int tipoConsulta){
		ReferenciasPagosBean cuentas= new ReferenciasPagosBean();
		try{
			//Query con el Store Procedure
			String query = "call REFPAGOSXINSTCON( ?,?,?,?,?,	"
												+ "?,?,?,?,?,	"
												+ "?,?,?,?);";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(depRefBean.getInstitucionID()),
					Constantes.STRING_VACIO,

					depRefBean.getReferenciaMov(),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,

					Constantes.STRING_VACIO,
					"ReferenciasPagosDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REFPAGOSXINSTCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReferenciasPagosBean CuentasAho = new ReferenciasPagosBean();
					CuentasAho.setExiste(resultSet.getString("Existe"));
					CuentasAho.setInstrumentoID(resultSet.getString("InstrumentoID"));

					return CuentasAho;
				}
			});

			cuentas= matches.size() > 0 ? (ReferenciasPagosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal de Referencias de Pago por Inctrumento: ", e);
		}
		return cuentas;
	}

	/**
	 * Consulta dada la referencia, tipo de canal y número de institución, la existencia de una referencia (cuenta de ahorro o crédito).
	 * @param depRefBean : Clase Bean {@linkplain ReferenciasPagosBean} con los valores de los parámetros de entrada al SP-REFPAGOSXINSTCON.
	 * @param tipoConsulta : Número de Consulta 2.
	 * @return {@linkplain ReferenciasPagosBean} con el Resultado de la Consulta.
	 * @author avelasco
	 */
	public ReferenciasPagosBean consultaForanea(ReferenciasPagosBean depRefBean, int tipoConsulta){
		ReferenciasPagosBean cuentas= new ReferenciasPagosBean();
		try{
			//Query con el Store Procedure
			String query = "call REFPAGOSXINSTCON( ?,?,?,?,?,	"
												+ "?,?,?,?,?,	"
												+ "?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(depRefBean.getTipoCanalID()),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(depRefBean.getInstitucionID()),
					Constantes.STRING_VACIO,

					depRefBean.getReferencia().trim(),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,

					Constantes.STRING_VACIO,
					"ReferenciasPagosDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REFPAGOSXINSTCON(" + Arrays.toString(parametros) + ");");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReferenciasPagosBean CuentasAho = new ReferenciasPagosBean();
					CuentasAho.setExiste(resultSet.getString("Existe"));
					CuentasAho.setInstrumentoID(resultSet.getString("InstrumentoID"));

					return CuentasAho;
				}
			});

			cuentas= matches.size() > 0 ? (ReferenciasPagosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal de Referencias de Pago por Inctrumento: ", e);
		}
		return cuentas;
	}

	// Consulta las referencias que corresponde a un crédito
	public ReferenciasPagosBean consultaReferenciasCredito(ReferenciasPagosBean depRefBean, int tipoConsulta){
		ReferenciasPagosBean cuentas= new ReferenciasPagosBean();
		try{
			//Query con el Store Procedure
			String query = "call REFCREDITOSCON( ?,?,?,?,?,	"
												+ "?,?,?,?);";
			Object[] parametros = {
					depRefBean.getInstrumentoID(),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,

					Constantes.STRING_VACIO,
					"ReferenciasPagosDAO.consultaReferenciasCredito",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REFCREDITOSCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReferenciasPagosBean CuentasAho = new ReferenciasPagosBean();
					CuentasAho.setExiste(resultSet.getString("Existe"));
					CuentasAho.setInstrumentoID(resultSet.getString("InstrumentoID"));

					return CuentasAho;
				}
			});

			cuentas= matches.size() > 0 ? (ReferenciasPagosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de Referencias de Crédito: ", e);
		}
		return cuentas;
	}



	/* calcula la referencia de la institucion */
	public ReferenciasPagosBean calculaAlgoritmoRefe(final ReferenciasPagosBean referenciasPagosBean) {

		ReferenciasPagosBean referenciasPagosBeanResultado = new ReferenciasPagosBean();
		referenciasPagosBeanResultado = (ReferenciasPagosBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				ReferenciasPagosBean refeTransaccion = new ReferenciasPagosBean();
				try {
					// Query con el Store Procedure
					refeTransaccion = (ReferenciasPagosBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call ALGORITREFPAGOCAL(?,?, ?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_InstitucionID", Utileria.convierteEntero(referenciasPagosBean.getInstitucionID()));
									sentenciaStore.setString("Par_Referencia",	referenciasPagosBean.getReferencia());

									sentenciaStore.registerOutParameter("Par_NuevaRefe", Types.VARCHAR);
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {

									ReferenciasPagosBean bean = new ReferenciasPagosBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										bean.setNumero((resultadosStore.getString(1)));
										bean.setReferencia(resultadosStore.getString(2));
										//bean.setNumTransaccion(	resultadosStore.getString(3));
										//bean.setNombreCompleto(	resultadosStore.getString(4));

									}
									return bean;
								}
							}
							);


					} catch (Exception e) {

						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al calcular la referencia ", e);
					}
					return refeTransaccion;
				}
			});


			return referenciasPagosBeanResultado;
		}

}