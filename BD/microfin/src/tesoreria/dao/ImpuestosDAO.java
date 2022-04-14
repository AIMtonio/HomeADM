package tesoreria.dao;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import tesoreria.bean.ImpuestosBean;


public class ImpuestosDAO extends BaseDAO  {

	public ImpuestosDAO() {
		super();
	}
	/*------------Alta de Tipos Proveedores-------------*/
	public MensajeTransaccionBean alta(final ImpuestosBean impuestosBean) {
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
								String query = "call IMPUESTOSALT(" +
									"?,?,?,?,?,?,?,?, ?,?,?," +
									"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_Descripcion",impuestosBean.getDescripcion());
								sentenciaStore.setString("Par_DescripCorta",impuestosBean.getDescripCorta());
								sentenciaStore.setString("Par_Tasa",impuestosBean.getTasa());
								sentenciaStore.setString("Par_GravaRetiene",impuestosBean.getGravaRetiene());
								sentenciaStore.setString("Par_BaseCalculo",impuestosBean.getBaseCalculo());
								sentenciaStore.setInt("Par_ImpuestoCalculo",Utileria.convierteEntero(impuestosBean.getImpuestoCalculo()));
								sentenciaStore.setString("Par_CtaEnTransito",impuestosBean.getCtaEnTransito());
								sentenciaStore.setString("Par_CtaRealizado",impuestosBean.getCtaRealizado());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								//Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ImpuestosDAO.alta");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " ImpuestosDAO.alta");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Impuestos" + e);
					e.printStackTrace();
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

	/* Modificacion de tipos Proveedores */
	public MensajeTransaccionBean modifica(final ImpuestosBean impuestosBean) {
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
								String query = "call IMPUESTOSMOD(" +
									"?,?,?,?,?,?,?,?,?, ?,?,?," +
									"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_ImpuestoID",impuestosBean.getImpuestoID());
								sentenciaStore.setString("Par_Descripcion",impuestosBean.getDescripcion());
								sentenciaStore.setString("Par_DescripCorta",impuestosBean.getDescripCorta());
								sentenciaStore.setString("Par_Tasa",impuestosBean.getTasa());
								sentenciaStore.setString("Par_GravaRetiene",impuestosBean.getGravaRetiene());
								sentenciaStore.setString("Par_BaseCalculo",impuestosBean.getBaseCalculo());
								sentenciaStore.setInt("Par_ImpuestoCalculo",Utileria.convierteEntero(impuestosBean.getImpuestoCalculo()));
								sentenciaStore.setString("Par_CtaEnTransito",impuestosBean.getCtaEnTransito());
								sentenciaStore.setString("Par_CtaRealizado",impuestosBean.getCtaRealizado());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								//Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ImpuestosDAO.modifica");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						});
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " ImpuestosDAO.modifica");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de Impuestos" + e);
					e.printStackTrace();
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

	//Consulta Principal de impuestos
	public ImpuestosBean consultaPrincipal(ImpuestosBean impuestosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call IMPUESTOSCON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(impuestosBean.getImpuestoID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call IMPUESTOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ImpuestosBean tipoprovBean = new ImpuestosBean();
				tipoprovBean.setTasa(resultSet.getString(1));
				tipoprovBean.setDescripcion(resultSet.getString(2));

				return tipoprovBean;
			}
		});
		return matches.size() > 0 ? (ImpuestosBean) matches.get(0) : null;
	}


	public List listaImpuestos(ImpuestosBean impuestosBean,int tipoConsulta){
		String query = "call IMPUESTOSLIS(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(impuestosBean.getImpuestoID()),
				impuestosBean.getDescripcion(),
				tipoConsulta,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call IMPUESTOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ImpuestosBean impuestosBean = new ImpuestosBean();
				impuestosBean.setImpuestoID(resultSet.getString(1));
				impuestosBean.setDescripcion(resultSet.getString(2));
				impuestosBean.setDescripCorta(resultSet.getString(3));

				return impuestosBean;
			}
		});
		return matches;

	}


	public List listaImpuestosTasa(ImpuestosBean impuestosBean,int tipoConsulta){
		String query = "call IMPUESTOSLIS(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(impuestosBean.getImpuestoID()),
				impuestosBean.getDescripcion(),
				tipoConsulta,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call IMPUESTOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ImpuestosBean impuestosBean = new ImpuestosBean();
				impuestosBean.setImpuestoID(resultSet.getString(1));
				impuestosBean.setDescripcion(resultSet.getString(2));
				impuestosBean.setDescripCorta(resultSet.getString(3));
				impuestosBean.setTasa(resultSet.getString(4));

				return impuestosBean;
			}
		});
		return matches;

	}

	public List listaImpuestosCombo(int tipoLista){
		String query = "call IMPUESTOSLIS(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				"",
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call IMPUESTOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ImpuestosBean impuestosBean = new ImpuestosBean();
				impuestosBean.setImpuestoID(resultSet.getString(1));
				impuestosBean.setDescripCorta(resultSet.getString(2));

				return impuestosBean;
			}
		});
		return matches;

	}

	//Consulta principal de tipos de proveedores
	public ImpuestosBean consultaImpuestos(ImpuestosBean impuestosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call IMPUESTOSCON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(impuestosBean.getImpuestoID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call IMPUESTOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ImpuestosBean impuestosBean = new ImpuestosBean();
				impuestosBean.setImpuestoID(String.valueOf(resultSet.getInt(1)));
				impuestosBean.setDescripcion(resultSet.getString(2));
				impuestosBean.setDescripCorta(resultSet.getString(3));
				impuestosBean.setTasa(resultSet.getString(4));
				impuestosBean.setGravaRetiene(resultSet.getString(5));
				impuestosBean.setBaseCalculo(resultSet.getString(6));
				impuestosBean.setImpuestoCalculo(resultSet.getString(7));
				impuestosBean.setCtaEnTransito(resultSet.getString(8));
				impuestosBean.setCtaRealizado(resultSet.getString(9));

				return impuestosBean;
			}
		});
		return matches.size() > 0 ? (ImpuestosBean) matches.get(0) : null;
	}


	//Consulta para saber el numero de impuestos diferentes
	public ImpuestosBean consultaNumeroImpuestos(ImpuestosBean impuestosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call IMPUESTOSCON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call IMPUESTOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ImpuestosBean impuestosBean = new ImpuestosBean();
				//impuestosBean.setNumImpuestos(String.valueOf(resultSet.getInt(1)));
				impuestosBean.setNumImpuestos(Integer.valueOf(resultSet.getInt(1)));

				return impuestosBean;
			}
		});
		return matches.size() > 0 ? (ImpuestosBean) matches.get(0) : null;
	}

}

