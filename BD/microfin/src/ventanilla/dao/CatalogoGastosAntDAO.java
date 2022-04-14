package ventanilla.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import ventanilla.bean.CatalogoGastosAntBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;


public class CatalogoGastosAntDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;

	public CatalogoGastosAntDAO(){
		super();
	}

	public MensajeTransaccionBean alta(final CatalogoGastosAntBean catalogoGastosAntBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TIPOSANTGASTOSALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?," +
																	  "?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_TipoAntGastoID",catalogoGastosAntBean.getTipoAntGastoID());
								sentenciaStore.setString("Par_Descripcion",catalogoGastosAntBean.getDescripcion());
								sentenciaStore.setString("Par_Naturaleza",catalogoGastosAntBean.getNaturaleza());
								sentenciaStore.setString("Par_Estatus",catalogoGastosAntBean.getEstatus());
								sentenciaStore.setString("Par_EsGasto",catalogoGastosAntBean.getEsGasto());

								sentenciaStore.setString("Par_ReqNoEmp",catalogoGastosAntBean.getReqNoEmp());
								sentenciaStore.setString("Par_CtaContable",catalogoGastosAntBean.getCtaContable());
								sentenciaStore.setString("Par_CentroCosto",catalogoGastosAntBean.getCentroCosto());
								sentenciaStore.setInt("Par_Instrumento",Utileria.convierteEntero(catalogoGastosAntBean.getTipoInstrumentoID()));
								sentenciaStore.setDouble("Par_MontoMaxEfect",Utileria.convierteDoble(catalogoGastosAntBean.getMontoMaxEfect()));
								sentenciaStore.setInt("Par_TipoGastoID",Utileria.convierteEntero(catalogoGastosAntBean.getTipoGastoID()));
								sentenciaStore.setDouble("Par_MontoMaxTrans",Utileria.convierteDoble(catalogoGastosAntBean.getMontoMaxTransaccion()));

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

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Alta del Catalogo de Anticipos y Gastos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	//modificacion de Tipo de Gatos y Anticipos
	public MensajeTransaccionBean modifica(final CatalogoGastosAntBean catalogoGastosAntBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TIPOSANTGASTOSMOD(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,  ?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_TipoAntGastoID",catalogoGastosAntBean.getTipoAntGastoID());
								sentenciaStore.setString("Par_Descripcion",catalogoGastosAntBean.getDescripcion());
								sentenciaStore.setString("Par_Naturaleza",catalogoGastosAntBean.getNaturaleza());
								sentenciaStore.setString("Par_Estatus",catalogoGastosAntBean.getEstatus());
								sentenciaStore.setString("Par_EsGasto",catalogoGastosAntBean.getEsGasto());

								sentenciaStore.setString("Par_ReqNoEmp",catalogoGastosAntBean.getReqNoEmp());
								sentenciaStore.setString("Par_CtaContable",catalogoGastosAntBean.getCtaContable());
								sentenciaStore.setString("Par_CentroCosto",catalogoGastosAntBean.getCentroCosto());
								sentenciaStore.setInt("Par_Instrumento",Utileria.convierteEntero(catalogoGastosAntBean.getTipoInstrumentoID()));
								sentenciaStore.setDouble("Par_MontoMaxEfect",Utileria.convierteDoble(catalogoGastosAntBean.getMontoMaxEfect()));
								sentenciaStore.setInt("Par_TipoGastoID",Utileria.convierteEntero(catalogoGastosAntBean.getTipoGastoID()));
								sentenciaStore.setDouble("Par_MontoMaxTrans",Utileria.convierteDoble(catalogoGastosAntBean.getMontoMaxTransaccion()));


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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Modificacion del Catalogo de Tipos de Gastos y Anticipos en Ventanilla", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para realizar el Proceso de Anticipo de Gastos
	 * @param catalogoGastosAntBean
	 * @param numtransaccion
	 * @param origenVentanilla
	 * @return
	 */
	public MensajeTransaccionBean anticiposGastosProceso(final CatalogoGastosAntBean catalogoGastosAntBean, final long numtransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call ANTICIPOSPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(catalogoGastosAntBean.getSucursalID()));
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(catalogoGastosAntBean.getCajaID()));
							sentenciaStore.setDate("Par_Fecha", OperacionesFechas.conversionStrDate(catalogoGastosAntBean.getFecha()));
							sentenciaStore.setDouble("Par_MontoOperacion", Utileria.convierteDoble(catalogoGastosAntBean.getMonto()));
							sentenciaStore.setString("Par_FormaPago", catalogoGastosAntBean.getEsCheque());

							sentenciaStore.setInt("Par_TipoOpe", Utileria.convierteEntero(catalogoGastosAntBean.getTipoAntGastoID()));
							sentenciaStore.setString("Par_Naturaleza", catalogoGastosAntBean.getNaturaleza());
							sentenciaStore.setInt("Par_EmpleadoID", Utileria.convierteEntero(catalogoGastosAntBean.getEmpleadoID()));
							sentenciaStore.setInt("Par_Moneda", Utileria.convierteEntero(catalogoGastosAntBean.getMonedaID()));

							sentenciaStore.setInt("Par_ConceptoConta", Utileria.convierteEntero(catalogoGastosAntBean.getConceptoCon()));
							sentenciaStore.setString("Par_DescripcionMov", catalogoGastosAntBean.getDescripcion());
							sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(catalogoGastosAntBean.getPolizaID()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							/*sentenciaStore.registerOutParameter("Par_Poliza", Types.BIGINT);*/
							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numtransaccion);

							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el Modificacion del Catalogo de Tipos de Gastos y Anticipos en Ventanilla", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el Modificacion del Catalogo de Tipos de Gastos y Anticipos en Ventanilla", e);
					}
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	//consulta de Catalogo Tipo Gastos Anticipo
	public CatalogoGastosAntBean consultaPrincipal(CatalogoGastosAntBean catalogoGastosAntBean, int tipoConsulta) {
		CatalogoGastosAntBean consultaBean	=null;
		try{
			//Query con el Store Procedure
			String query = "call TIPOSANTGASTOSCON(?,?,?, ?,?,?, ?,?,?);";
			Object[] parametros = {	catalogoGastosAntBean.getTipoAntGastoID(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"catalogoGastosAntDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSANTGASTOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatalogoGastosAntBean catalogoGastosAnt = new CatalogoGastosAntBean();
					catalogoGastosAnt.setTipoAntGastoID(String.valueOf(resultSet.getInt(1)));
					catalogoGastosAnt.setDescripcion(resultSet.getString(2));
					catalogoGastosAnt.setNaturaleza(resultSet.getString(3));
					catalogoGastosAnt.setEstatus(resultSet.getString(4));
					catalogoGastosAnt.setEsGasto(resultSet.getString(5));
					catalogoGastosAnt.setTipoGastoID(resultSet.getString(6));
					catalogoGastosAnt.setReqNoEmp(resultSet.getString(7));
					catalogoGastosAnt.setCtaContable(resultSet.getString(8));
					catalogoGastosAnt.setCentroCosto(resultSet.getString(9));
					catalogoGastosAnt.setTipoInstrumentoID(resultSet.getString(10));
					catalogoGastosAnt.setMontoMaxEfect(resultSet.getString(11));
					catalogoGastosAnt.setMontoMaxTransaccion(resultSet.getString(12));
						return catalogoGastosAnt;
				}
			});consultaBean= matches.size() > 0 ? (CatalogoGastosAntBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Catalogo de Tipos de Gastos", e);
		}
		return consultaBean;
	}

	public List listaPrincipal(CatalogoGastosAntBean catalogoGastosAntBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call TIPOSANTGASTOSLIS(?,?,? ,?,?,? ,?,?,?,?);";
		Object[] parametros = {	catalogoGastosAntBean.getTipoAntGastoID(),
								Constantes.STRING_VACIO,
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSANTGASTOSLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CatalogoGastosAntBean catalogoGastosAnt = new CatalogoGastosAntBean();
				catalogoGastosAnt.setTipoAntGastoID(resultSet.getString(1));
				catalogoGastosAnt.setDescripcion(resultSet.getString(2));
				catalogoGastosAnt.setNaturaleza(resultSet.getString(3));
				return catalogoGastosAnt;
			}
		});
		return matches;
	}

	/* Lista Combo para el Catalogo de Gastos*/
	public List listaComboGastosAnt( int tipoLista) {
		List listaGastosAnticipos = null ;
		try{
			// Query con el Store Procedure
			String query = "call TIPOSANTGASTOSLIS(?,?,?, ?,?,? ,?,?,?, ?);";
			Object[] parametros = {
									Constantes.ENTERO_CERO,
									Constantes.STRING_VACIO,
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"CatalogoGastosAntDAO.listaCombo",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO };

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSANTGASTOSLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CatalogoGastosAntBean catalogoGastosAnt = new CatalogoGastosAntBean();
					catalogoGastosAnt.setTipoAntGastoID(resultSet.getString(1));
					catalogoGastosAnt.setDescripcion(resultSet.getString(2));
					return catalogoGastosAnt;
				}
			});
			listaGastosAnticipos= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista Combo del Catalogo de Gastos", e);
		}
		return listaGastosAnticipos;
	}

	public List listaNaturaleza(CatalogoGastosAntBean catalogoGastosAntBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call TIPOSANTGASTOSLIS(?,?,? ,?,?,? ,?,?,?, ?);";
		Object[] parametros = {	catalogoGastosAntBean.getTipoAntGastoID(),
								catalogoGastosAntBean.getNaturaleza(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSANTGASTOSLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CatalogoGastosAntBean catalogoGastosAnt = new CatalogoGastosAntBean();
				catalogoGastosAnt.setTipoAntGastoID(resultSet.getString(1));
				catalogoGastosAnt.setDescripcion(resultSet.getString(2));
				catalogoGastosAnt.setNaturaleza(resultSet.getString(3));
				return catalogoGastosAnt;
			}
		});
		return matches;
	}









	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}



}
