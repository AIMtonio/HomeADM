package pld.dao;

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

import pld.bean.ParametrosEscalaBean;
import pld.bean.ParametrosOpRelBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ParametrosEscalaDAO extends BaseDAO{

	public ParametrosEscalaDAO() {
		super();
	}

	public MensajeTransaccionBean alta(final ParametrosEscalaBean parametrosEscalaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PARAMETROSESCALAALT(?,?,?,?,?,"
																+ "?,?,?,?,?,"
																+ "?,?,?,?,?,"
																+ "?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_TipoPersona", parametrosEscalaBean.getTipoPersona());
							sentenciaStore.setInt("Par_TipoInstrumento", Utileria.convierteEntero(parametrosEscalaBean.getTipoInstrumento()));
							sentenciaStore.setString("Par_NacMoneda", parametrosEscalaBean.getNacMoneda());
							sentenciaStore.setString("Par_LimiteInferior", parametrosEscalaBean.getLimiteInferior());
							sentenciaStore.setInt("Par_MonedaComp", Utileria.convierteEntero(parametrosEscalaBean.getMonedaComp()));

							sentenciaStore.setInt("Par_RolTitular", Utileria.convierteEntero(parametrosEscalaBean.getRolTitular()));
							sentenciaStore.setInt("Par_RolSuplente", Utileria.convierteEntero(parametrosEscalaBean.getRolSuplente()));
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());

							sentenciaStore.setInt("Aud_SucursalID",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ParametrosEscalaDAO.alta");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ParametrosEscalaDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if(mensajeBean.getNumero() == 0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de parametros escalamiento", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	public MensajeTransaccionBean modificacion(final ParametrosEscalaBean parametrosEscalaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PARAMETROSESCALAMOD(?,?,?,?,?,"
																+ "?,?,?,?,?,"
																+ "?,?,?,?,?,"
																+ "?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_FolioID", Utileria.convierteEntero(parametrosEscalaBean.getFolioID()));
							sentenciaStore.setString("Par_TipoPersona", parametrosEscalaBean.getTipoPersona());
							sentenciaStore.setInt("Par_TipoInstrumento", Utileria.convierteEntero(parametrosEscalaBean.getTipoInstrumento()));
							sentenciaStore.setString("Par_NacMoneda", parametrosEscalaBean.getNacMoneda());
							sentenciaStore.setString("Par_LimiteInferior", parametrosEscalaBean.getLimiteInferior());

							sentenciaStore.setInt("Par_MonedaComp", Utileria.convierteEntero(parametrosEscalaBean.getMonedaComp()));
							sentenciaStore.setInt("Par_RolTitular", Utileria.convierteEntero(parametrosEscalaBean.getRolTitular()));
							sentenciaStore.setInt("Par_RolSuplente", Utileria.convierteEntero(parametrosEscalaBean.getRolSuplente()));
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_SucursalID",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ParametrosEscalaDAO.modificacion");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ParametrosEscalaDAO.modificacion");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if(mensajeBean.getNumero() == 0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de parametros escalamiento", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//consulta parametros escalamiento
	public ParametrosEscalaBean consultaPrincipal(ParametrosEscalaBean parametrosEscala, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call PARAMETROSESCALACON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
								parametrosEscala.getTipoPersona(),
								parametrosEscala.getTipoInstrumento(),
								parametrosEscala.getNacMoneda(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ParametrosEscalaDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMETROSESCALACON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParametrosEscalaBean parametrosEscala = new ParametrosEscalaBean();
				parametrosEscala.setFolioID(resultSet.getString("FolioID"));
				parametrosEscala.setTipoPersona(resultSet.getString("TipoPersona"));
				parametrosEscala.setTipoInstrumento(String.valueOf(resultSet.getInt("TipoInstrumento")));
				parametrosEscala.setNacMoneda(resultSet.getString("NacMoneda"));
				parametrosEscala.setLimiteInferior(resultSet.getString("LimiteInferior"));
				parametrosEscala.setMonedaComp(String.valueOf(resultSet.getInt("MonedaComp")));
				parametrosEscala.setRolTitular(String.valueOf(resultSet.getInt("RolTitular")));
				parametrosEscala.setRolSuplente(String.valueOf(resultSet.getInt("RolSuplente")));
				return parametrosEscala;
			}
		});
		return matches.size() > 0 ? (ParametrosEscalaBean) matches.get(0) : null;
	}

}

