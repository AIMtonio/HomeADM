package spei.dao;

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

import spei.bean.AutorizaEnvioSpeiBean;
import spei.bean.ConsultaSpeiBean;
import spei.bean.CuentaClabePMoralBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CuentaClabePMoralDAO extends  BaseDAO {

	CuentaClabePMoralDAO cuentaClabePMoralDAO = null;

	public CuentaClabePMoralDAO(){
		super();
	}


	// Actualiza el estatus para cuenta persona moral
		public MensajeTransaccionBean actualizaCuentaClabePM(final CuentaClabePMoralBean cuentaClabePMoralBean, final int tipoActualizacion) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try{
						// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SPEICUENTASCLABPMORALACT(?,?,?,?,?,  ?,?,  ?,?,?,  ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SpeiCuentaPMoralID", Utileria.convierteEntero(cuentaClabePMoralBean.getSpeiCuentaPMoralID()));
									sentenciaStore.setInt("Par_CuentaClabe",tipoActualizacion);
									sentenciaStore.setInt("Par_PIDTarea",tipoActualizacion);
									sentenciaStore.setInt("Par_IDRespuesta",tipoActualizacion);
									sentenciaStore.setInt("Par_DescripcionRespuesta",tipoActualizacion);

									sentenciaStore.setInt("Par_Comentario",tipoActualizacion);
									sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la actualizacion de la cuenta clabe", e);
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

		public CuentaClabePMoralBean consultaCuentaClabe(CuentaClabePMoralBean cuentaClabePMoralBean, int tipoConsulta){

			String query = "call SPEICUENTASCLABPMORALCON(?,?,?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = { cuentaClabePMoralBean.getClienteID(),
									cuentaClabePMoralBean.getInstrumento(),
									Constantes.ENTERO_CERO,
									tipoConsulta,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									Constantes.STRING_VACIO,
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SPEICUENTASCLABPMORALCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentaClabePMoralBean clabePMoralBean = new CuentaClabePMoralBean();
					clabePMoralBean.setSpeiCuentaPMoralID(String.valueOf(resultSet.getString(1)));
					clabePMoralBean.setClienteID(String.valueOf(resultSet.getString(2)));
					clabePMoralBean.setCuentaClabe(String.valueOf(resultSet.getString(3)));
					clabePMoralBean.setFechaCreacion(String.valueOf(resultSet.getString(4)));
					clabePMoralBean.setEstatus(String.valueOf(resultSet.getString(5)));
					clabePMoralBean.setTipoInstrumento(String.valueOf(resultSet.getString(6)));
					clabePMoralBean.setInstrumento(String.valueOf(resultSet.getString(7)));
					clabePMoralBean.setDescEstatus(String.valueOf(resultSet.getString(8)));

					return clabePMoralBean;
				}
			});

			return matches.size() > 0 ? (CuentaClabePMoralBean) matches.get(0) : null;
		}

	public CuentaClabePMoralDAO getCuentaClabePMoralDAO() {
		return cuentaClabePMoralDAO;
	}

	public void setCuentaClabePMoralDAO(CuentaClabePMoralDAO cuentaClabePMoralDAO) {
		this.cuentaClabePMoralDAO = cuentaClabePMoralDAO;
	}



}
