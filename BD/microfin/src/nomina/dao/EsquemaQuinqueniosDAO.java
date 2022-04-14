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
import nomina.bean.EsquemaQuinqueniosBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;


public class EsquemaQuinqueniosDAO  extends BaseDAO {


	public EsquemaQuinqueniosDAO (){
		super ();
	}

	/**
	 *
	 * @param esquemaQuinqueniosBean : Bean de Esquema de Quinquenios
	 * @param listaEsquemaQuinquenios : Lista de Esquema de Quinquenios
	 * @return
	 */
	public MensajeTransaccionBean grabarEsquemaQuinquenios(final EsquemaQuinqueniosBean esquemaQuinqueniosBean, final List listaEsquemaQuinquenios) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					EsquemaQuinqueniosBean esquemaQuinquenios;
					mensajeBean = bajaEsquemaQuinquenios(esquemaQuinqueniosBean,parametrosAuditoriaBean.getNumeroTransaccion());

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaEsquemaQuinquenios.size(); i++){
						esquemaQuinquenios = (EsquemaQuinqueniosBean)listaEsquemaQuinquenios.get(i);
						mensajeBean = altaEsquemaQuinquenios(esquemaQuinquenios,parametrosAuditoriaBean.getNumeroTransaccion());
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Esquema de Quinquenios Grabado Exitósamente.");
					mensajeBean.setNombreControl("institNominaID");
					mensajeBean.setConsecutivoInt(esquemaQuinqueniosBean.getInstitNominaID());

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Grabar Esquema de Quinquenios.", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param esquemaQuinqueniosBean : Bean de Esquema de Quinquenios
	 * @param numeroTransaccion : Número de Transacción
	 * @return
	 */
	public MensajeTransaccionBean bajaEsquemaQuinquenios(final EsquemaQuinqueniosBean esquemaQuinqueniosBean,final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call ESQUEMAQUINQUENIOSBAJ(?,?,?,?,?,   ?,?,?,?,?,  ?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(esquemaQuinqueniosBean.getInstitNominaID()));
								sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(esquemaQuinqueniosBean.getConvenioNominaID()));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Baja de Esquema de Quinquenios.", e);
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
	 * @param esquemaQuinqueniosBean : Bean de Esquema de Quinquenios
	 * @param numeroTransaccion : Número de Transacción
	 * @return
	 */
	public MensajeTransaccionBean altaEsquemaQuinquenios(final EsquemaQuinqueniosBean esquemaQuinqueniosBean,final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call ESQUEMAQUINQUENIOSALT(?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(esquemaQuinqueniosBean.getInstitNominaID()));
								sentenciaStore.setInt("Par_ConvenioNominaID",Utileria.convierteEntero(esquemaQuinqueniosBean.getConvenioNominaID()));
								sentenciaStore.setString("Par_SucursalID",esquemaQuinqueniosBean.getSucursalID());
								sentenciaStore.setString("Par_QuinquenioID",esquemaQuinqueniosBean.getQuinquenioID());
								sentenciaStore.setString("Par_PlazoID",esquemaQuinqueniosBean.getPlazoID());

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Grabar Esquema de Quinquenios.", e);
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
	 * @param esquemaQuinqueniosBean : Bean de Esquema de Quinquenios
	 * @param tipoLista
	 * @return
	 */
	public List listaEsquemaQuinquenios(EsquemaQuinqueniosBean esquemaQuinqueniosBean, int tipoLista){
		List listaGrid = null;
		try{

		String query = "call ESQUEMAQUINQUENIOSLIS(?,?,?,?,?,  ?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(esquemaQuinqueniosBean.getInstitNominaID()),
				Utileria.convierteEntero(esquemaQuinqueniosBean.getConvenioNominaID()),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"EsquemaQuinqueniosDAO.listaEsquemaQuinquenios",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ESQUEMAQUINQUENIOSLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EsquemaQuinqueniosBean resultadoBean = new EsquemaQuinqueniosBean();
				resultadoBean.setSucursalID(resultSet.getString("SucursalID"));
				resultadoBean.setQuinquenioID(resultSet.getString("QuinquenioID"));
				resultadoBean.setPlazoID(resultSet.getString("PlazoID"));

				return resultadoBean;

				}
			});
			listaGrid= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Lista de Esquema de Quinquenios.", e);

		}
		return listaGrid;
	}

	// CONSULTA PRINCIPAL
	public EsquemaQuinqueniosBean consultaPrincipal(int tipoConsulta, EsquemaQuinqueniosBean esquemaQuinqueniosBean) {
		EsquemaQuinqueniosBean registro = null;
		try {
			String query = "CALL ESQUEMAQUINQUENIOSCON (?,?,?,?,?,	?,?,?,?,?,	?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(esquemaQuinqueniosBean.getInstitNominaID()),
					Utileria.convierteEntero(esquemaQuinqueniosBean.getConvenioNominaID()),
					Utileria.convierteEntero(esquemaQuinqueniosBean.getSucursalID()),
					Utileria.convierteEntero(esquemaQuinqueniosBean.getQuinquenioID()),
					Utileria.convierteEntero(esquemaQuinqueniosBean.getClienteID()),

					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,

					"CatQuinqueniosDAO.listaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL ESQUEMAQUINQUENIOSCON (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EsquemaQuinqueniosBean resultado = new EsquemaQuinqueniosBean();
					resultado.setEsqQuinquenioID(resultSet.getString("EsqQuinquenioID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setSucursalID(resultSet.getString("SucursalID"));
					resultado.setQuinquenioID(resultSet.getString("QuinquenioID"));
					resultado.setPlazoID(resultSet.getString("PlazoID"));
					resultado.setEmpresaID(resultSet.getString("EmpresaID"));

					return resultado;
				}
			});
			registro = matches.size() > 0 ? (EsquemaQuinqueniosBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de ESQUEMA DE QUINQUENIOS", e);
		}
		return registro;
	}


	//CONSULTA FORANEA
	public EsquemaQuinqueniosBean consultaForanea(int tipoConsulta, EsquemaQuinqueniosBean esquemaQuinqueniosBean) {
		EsquemaQuinqueniosBean registro = null;
		try {
			String query = "CALL ESQUEMAQUINQUENIOSCON (?,?,?,?,?,	?,?,?,?,?,	?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(esquemaQuinqueniosBean.getInstitNominaID()),
					Utileria.convierteEntero(esquemaQuinqueniosBean.getConvenioNominaID()),
					Utileria.convierteEntero(esquemaQuinqueniosBean.getSucursalID()),
					Utileria.convierteEntero(esquemaQuinqueniosBean.getQuinquenioID()),
					Utileria.convierteEntero(esquemaQuinqueniosBean.getClienteID()),

					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,

					"CatQuinqueniosDAO.listaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL ESQUEMAQUINQUENIOSCON (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EsquemaQuinqueniosBean resultado = new EsquemaQuinqueniosBean();
					resultado.setEsqQuinquenioID(resultSet.getString("EsqQuinquenioID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setSucursalID(resultSet.getString("SucursalID"));
					resultado.setQuinquenioID(resultSet.getString("QuinquenioID"));
					resultado.setPlazoID(resultSet.getString("PlazoID"));
					resultado.setEmpresaID(resultSet.getString("EmpresaID"));
					resultado.setDesQuinquenio(resultSet.getString("DesQuinquenio"));
					resultado.setDesplazo(resultSet.getString("Desplazo"));
					resultado.setManejaQuinquenios(resultSet.getString("ManejaQuinquenios"));

					return resultado;
				}
			});
			registro = matches.size() > 0 ? (EsquemaQuinqueniosBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de ESQUEMA DE QUINQUENIOS", e);
		}
		return registro;
	}

	//CONSULTA FORANEA
		public EsquemaQuinqueniosBean consultaConExisteEsqQ(int tipoConsulta, EsquemaQuinqueniosBean esquemaQuinqueniosBean) {
			EsquemaQuinqueniosBean registro = null;
			try {
				String query = "CALL ESQUEMAQUINQUENIOSCON (?,?,?,?,?,	?,?,?,?,?,	?,?,?);";
				Object[] parametros = {
						Utileria.convierteEntero(esquemaQuinqueniosBean.getInstitNominaID()),
						Utileria.convierteEntero(esquemaQuinqueniosBean.getConvenioNominaID()),
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,

						tipoConsulta,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,

						"CatQuinqueniosDAO.listaPrincipal",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO};

				loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL ESQUEMAQUINQUENIOSCON (" + Arrays.toString(parametros) +")");
				List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						EsquemaQuinqueniosBean resultado = new EsquemaQuinqueniosBean();
						resultado.setCantidad(resultSet.getString("Cantidad"));

						return resultado;
					}
				});
				registro = matches.size() > 0 ? (EsquemaQuinqueniosBean) matches.get(0) : null;
			} catch (Exception e) {
				e.printStackTrace();
				loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de ESQUEMA DE QUINQUENIOS", e);
			}
			return registro;
		}



}
