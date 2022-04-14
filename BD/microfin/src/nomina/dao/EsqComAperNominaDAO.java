package nomina.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
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

import nomina.bean.EsqComAperNominaBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class EsqComAperNominaDAO extends BaseDAO {

	public EsqComAperNominaDAO() {
		super();
	}

	/**
	 * MODIFICACONVENIOSPRO
	 * @param EsqComAperNominaBean : Bean de Esquema de Comision por Apertura por Convenio
	 * @param numeroTransaccion : Número de Transacción
	 * @return
	 */
	public MensajeTransaccionBean esqComAperNominaAlt(final EsqComAperNominaBean esqComAperNominaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call ESQCOMAPERNOMINAALT(?,?,?,  ?,?,?,?,?,  ?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(esqComAperNominaBean.getInstitNominaID()));
								sentenciaStore.setInt("Par_ProducCreditoID",Utileria.convierteEntero(esqComAperNominaBean.getProducCreditoID()));
								sentenciaStore.setString("Par_ManejaEsqConvenio",esqComAperNominaBean.getManejaEsqConvenio());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Grabar Esquema de Comisiones.", e);
					if (mensajeBean.getNumero() == 0) {
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


	public MensajeTransaccionBean esqComAperNominaMod(final EsqComAperNominaBean esqComAperNominaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL ESQCOMAPERNOMINAMOD (?,?,?,?,	 ?,?,?,?,?,	 ?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_EsqComApertID", Utileria.convierteEntero(esqComAperNominaBean.getEsqComApertID()));
									sentenciaStore.setInt("Par_InstitNominaID", Utileria.convierteEntero(esqComAperNominaBean.getInstitNominaID()));
									sentenciaStore.setInt("Par_ProducCreditoID",  Utileria.convierteEntero(esqComAperNominaBean.getProducCreditoID()));
									sentenciaStore.setString("Par_ManejaEsqConvenio", esqComAperNominaBean.getManejaEsqConvenio());

									sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "EsqComAperNominaDAO.esqComAperNominaMod");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ConveniosNominaDAO.modificaConveniosNomina");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoInt(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " EsqComAperNominaDAO.esqComAperNominaMod");
					} else if(mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+" - "+" Error al modificar el registro del esquema" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
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


	// CONSULTA PRINCIPAL
	public EsqComAperNominaBean consultaPrincipal(int tipoConsulta, EsqComAperNominaBean esqComAperNominaBean) {
		EsqComAperNominaBean registro = null;
		try {
			String query = "CALL ESQCOMAPERNOMINACON (?,?,?,?,?,	?,?,?,?,?);";
			Object[] parametros = {

					Utileria.convierteEntero(esqComAperNominaBean.getInstitNominaID()),
					Utileria.convierteEntero(esqComAperNominaBean.getProducCreditoID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL ESQCOMAPERNOMINACON (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EsqComAperNominaBean resultado = new EsqComAperNominaBean();
					resultado.setEsqComApertID(resultSet.getString("EsqComApertID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setProducCreditoID(resultSet.getString("ProducCreditoID"));
					resultado.setManejaEsqConvenio(resultSet.getString("ManejaEsqConvenio"));

					return resultado;
				}
			});
			registro = matches.size() > 0 ? (EsqComAperNominaBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de ESQUEMA de comisiones", e);
		}
		return registro;
	}

	/**
	 *
	 * @param EsqComAperNominaBean : Bean de Esquema de Comisión por Apertura
	 * @param listaEsquemasConvenio : Lista de Esquema de Comisiones por Apertura
	 * @return
	 */
	public MensajeTransaccionBean comApertConvenioGrabar(final EsqComAperNominaBean esqComAperNominaBean, final List listaEsquemasConvenio) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					EsqComAperNominaBean esqComAperNomina;
					mensajeBean = bajaComApertConvenio(esqComAperNominaBean,parametrosAuditoriaBean.getNumeroTransaccion());

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					if (!esqComAperNominaBean.getFila().isEmpty() && esqComAperNominaBean.getFila()!="") {
						for(int i=0; i<listaEsquemasConvenio.size(); i++){
							esqComAperNomina = (EsqComAperNominaBean)listaEsquemasConvenio.get(i);
							mensajeBean = altaComApertConvenio(esqComAperNomina,parametrosAuditoriaBean.getNumeroTransaccion());
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Esquema de Cobro Grabado Exitósamente.");
					mensajeBean.setNombreControl("esqComApertID");
					mensajeBean.setConsecutivoInt(esqComAperNominaBean.getEsqComApertID());

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Grabar Esquema de Cobro de Comision Apertura.", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param esqComAperNominaBean : Bean de Esquema de Comisión por Apertura
	 * @param numeroTransaccion : Número de Transacción
	 * @return
	 */
	public MensajeTransaccionBean bajaComApertConvenio(final EsqComAperNominaBean esqComAperNominaBean,final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call COMAPERTCONVENIOBAJ(?,  ?,?,?,?,?,   ?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_EsqComApertID",Utileria.convierteEntero(esqComAperNominaBean.getEsqComApertID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Baja de Esquema de Cobro Comisión Apertura Convenios.", e);
					if (mensajeBean.getNumero() == 0) {
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
	 * @param esqComAperNominaBean : Bean de Esquema de Comisión por Apertura
	 * @param numeroTransaccion : Número de Transacción
	 * @return
	 */
	public MensajeTransaccionBean altaComApertConvenio(final EsqComAperNominaBean esqComAperNominaBean,final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call COMAPERTCONVENIOALT(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_EsqComApertID",Utileria.convierteEntero(esqComAperNominaBean.getEsqComApertID()));
								sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(esqComAperNominaBean.getConvenioNominaID()));
								sentenciaStore.setString("Par_FormCobroComAper",esqComAperNominaBean.getFormCobroComAper());
								sentenciaStore.setString("Par_TipoComApert",esqComAperNominaBean.getTipoComApert());
								sentenciaStore.setString("Par_PlazoID",esqComAperNominaBean.getPlazoID());

								sentenciaStore.setDouble("Par_MontoMin",Utileria.convierteDoble(esqComAperNominaBean.getMontoMin()));
								sentenciaStore.setDouble("Par_MontoMax",Utileria.convierteDoble(esqComAperNominaBean.getMontoMax()));
								sentenciaStore.setDouble("Par_Valor",Utileria.convierteDoble(esqComAperNominaBean.getValor()));
								sentenciaStore.setDouble("Par_Fila",Utileria.convierteDoble(esqComAperNominaBean.getFila()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Grabar Esquema de CObro Comision Apertura.", e);
					if (mensajeBean.getNumero() == 0) {
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
	 * @param esqComAperNominaBean : Bean de Esquema de Comisión por Apertura
	 * @param tipoLista
	 * @return
	 */
	public List listaEsquemaConvenios(EsqComAperNominaBean esqComAperNominaBean, int tipoLista){
		List listaGrid = null;
		try{

		String query = "call COMAPERTCONVENIOLIS(?,?,?,?,?  ?,?,?,?,?,  ?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(esqComAperNominaBean.getEsqComApertID()),
				tipoLista,
				Utileria.convierteEntero(esqComAperNominaBean.getConvenioNominaID()),
				esqComAperNominaBean.getPlazoID(),
				Utileria.convierteDoble(esqComAperNominaBean.getValor()),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"EsqComAperNominaDAO.listaEsquemaConvenios",

				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COMAPERTCONVENIOLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EsqComAperNominaBean esqComAperNominaBean = new EsqComAperNominaBean();
				esqComAperNominaBean.setEsqComApertID(resultSet.getString("EsqConvComAperID"));
				esqComAperNominaBean.setEsqComApertID(resultSet.getString("EsqComApertID"));
				esqComAperNominaBean.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
				esqComAperNominaBean.setFormCobroComAper(resultSet.getString("FormCobroComAper"));
				esqComAperNominaBean.setTipoComApert(resultSet.getString("TipoComApert"));
				esqComAperNominaBean.setPlazoID(resultSet.getString("PlazoID"));
				esqComAperNominaBean.setMontoMin(resultSet.getString("MontoMin"));
				esqComAperNominaBean.setMontoMax(resultSet.getString("MontoMax"));
				esqComAperNominaBean.setValor(resultSet.getString("Valor"));

				return esqComAperNominaBean;

				}
			});
			listaGrid= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Lista de Esquema de Comisiones.", e);

		}
		return listaGrid;
	}
}
