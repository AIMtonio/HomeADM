package pld.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import pld.bean.PLDDetecPersBean;

public class PLDDetecPersDAO extends BaseDAO {

	java.sql.Date fecha = null;
	private static final String CARGA_MASIVA = "C";

	public PLDDetecPersDAO(){
		super();
	}

	private final static String salidaPantalla = "S";

	/* Alta de Carga de Archivos para listas PLD */
	public MensajeTransaccionBean alta(final PLDDetecPersBean personasBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PLDDETECPERSALT("
														+ "?,?,?,?,?,	"
														+ "?,?,?,?,?,	"
														+ "?,?,?,?,?,	"
														+ "?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_TipoPersonaSAFI", personasBean.getTipoPersonaSAFI());
									sentenciaStore.setString("Par_ClavePersonaInv", personasBean.getClavePersonaInv());
									sentenciaStore.setString("Par_NombreCompleto", personasBean.getNombreCompleto());
									sentenciaStore.setString("Par_TipoLista", personasBean.getTipoLista());
									sentenciaStore.setString("Par_ListaPLDID", personasBean.getListaPLDID());

									sentenciaStore.setString("Par_IDQEQ", personasBean.getIdQEQ());
									sentenciaStore.setString("Par_NumeroOficio", personasBean.getNumeroOficio());
									sentenciaStore.setString("Par_OrigenDeteccion", personasBean.getOrigenDeteccion());
									sentenciaStore.setString("Par_FechaAlta", personasBean.getFechaAlta());
									sentenciaStore.setString("Par_TipoListaID", personasBean.getTipoListaID());

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();
										resultadosStore.beforeFirst();
										resultadosStore.next();
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .PLDDetecPersDAO.alta");
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
						throw new Exception(Constantes.MSG_ERROR + " .PLDDetecPersDAO.alta");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de deteccion de personas PLD: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public JSONArray consultaDatosPersonas(final PLDDetecPersBean personasBean, final int tipoLista, final long numTransaccion){
		JSONArray resultadoStore = null;
		try {
			resultadoStore = (JSONArray)
				((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						//Query con el Store Procedure
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PLDDETECPERSLIS(" +
													"?,?,?,?,?,	" +
													"?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_TipoLista",tipoLista);
							sentenciaStore.setString("Par_TipoPersonaSAFI",personasBean.getTipoPersonaSAFI());
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());

							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID","PLDDetecPersDAO.consultaDatosPersonas");
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
						DataAccessException {
							JSONArray json = new JSONArray();
							ResultSet resultadosStore = null;
							if(callableStatement.execute()){
								resultadosStore = callableStatement.getResultSet();
								ResultSetMetaData rsmd = resultadosStore.getMetaData();
								while(resultadosStore.next()) {
									int numColumns = rsmd.getColumnCount();
									JSONObject obj = new JSONObject();
									for (int i=1; i<=numColumns; i++) {
										String column_name = rsmd.getColumnName(i);
										obj.put(column_name, resultadosStore.getString(column_name));
									}
									json.put(obj);
								}
							}
							return json;
						}
					});
			return resultadoStore;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en lista (consultaDatosPersonas): ", e);
			return null;
		}
	}


	public long getNumTransaccion(){
		return transaccionDAO.generaNumeroTransaccionOut();
	}
}